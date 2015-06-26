{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2015, SAS.Planet development team.                      *}
{* This program is free software: you can redistribute it and/or modify       *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* This program is distributed in the hope that it will be useful,            *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with this program.  If not, see <http://www.gnu.org/licenses/>.      *}
{*                                                                            *}
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_MarkSystemImplORM;

interface

uses
  Windows,
  Classes,
  mORMot,
  mORMotSQLite3,
  SynCommons,
  SynSQLite3Static,
  t_MarkSystemORM,
  t_MarkSystemModelORM,
  i_HashFunction,
  i_GeometryLonLatFactory,
  i_VectorItemSubsetBuilder,
  i_InternalPerformanceCounter,
  i_AppearanceOfMarkFactory,
  i_ReadWriteState,
  i_VectorDataItemSimple,
  i_MarkPicture,
  i_NotifierOperation,
  i_HtmlToHintTextConverter,
  i_MarkCategory,
  i_MarkFactory,
  i_MarkDbImpl,
  i_MarkCategoryDBImpl,
  i_MarkSystemImpl,
  i_MarkDbInternalORM,
  i_MarkFactoryDbInternalORM,
  i_MarkCategoryDbInternalORM,
  i_ReadWriteStateInternal,
  u_BaseInterfacedObject;

type
  TMarkSystemImplORM = class(TBaseInterfacedObject, IMarkSystemImpl)
  private
    FState: IReadWriteStateChangeble;
    FDbId: Integer;
    FUser: TSQLUser;
    FModel: TSQLModel;
    FClientDB: TSQLRestClientDB;
    FMarkDbImpl: IMarkDbImpl;
    FMarkDbInternal: IMarkDbInternalORM;
    FCategoryDBImpl: IMarkCategoryDBImpl;
    FCategoryDBInternal: IMarkCategoryDbInternalORM;
    FFactoryDbInternal: IMarkFactoryDbInternalORM;
  private
    { IMarkSystemImpl }
    function GetMarkDb: IMarkDbImpl;
    function GetCategoryDB: IMarkCategoryDBImpl;
    function GetState: IReadWriteStateChangeble;
    function GetStringIdByMark(const AMark: IVectorDataItem): string;
    function GetMarkByStringId(const AId: string): IVectorDataItem;
    function GetMarkCategoryByStringId(const AId: string): IMarkCategory;
  public
    constructor Create(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const ABasePath: string;
      const AMarkPictureList: IMarkPictureList;
      const AHashFunction: IHashFunction;
      const AAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
      const AVectorGeometryLonLatFactory: IGeometryLonLatFactory;
      const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
      const AMarkFactory: IMarkFactory;
      const ALoadDbCounter: IInternalPerformanceCounter;
      const ASaveDbCounter: IInternalPerformanceCounter;
      const AHintConverter: IHtmlToHintTextConverter;
      const AReadOnly: Boolean = False
    );
    destructor Destroy; override;
  end;


implementation

uses
  SysUtils,
  t_CommonTypes,
  i_GeometryToStream,
  i_GeometryFromStream,
  u_GeometryToStreamSML, // ToDo: use WKB
  u_GeometryFromStreamSML, // ToDo: use WKB
  u_ReadWriteStateInternal,
  u_MarkDbImplORM,
  u_MarkCategoryDbImplORM,
  u_MarkSystemORMTools,
  u_MarkFactoryDbInternalORM;

constructor TMarkSystemImplORM.Create(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const ABasePath: string;
  const AMarkPictureList: IMarkPictureList;
  const AHashFunction: IHashFunction;
  const AAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
  const AVectorGeometryLonLatFactory: IGeometryLonLatFactory;
  const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
  const AMarkFactory: IMarkFactory;
  const ALoadDbCounter: IInternalPerformanceCounter;
  const ASaveDbCounter: IInternalPerformanceCounter;
  const AHintConverter: IHtmlToHintTextConverter;
  const AReadOnly: Boolean
);
var
  VUserName: RawUTF8;
  VCategoryDb: TMarkCategoryDbImplORM;
  VMarkDb: TMarkDbImplORM;
  VState: TReadWriteStateInternal;
  VStateInternal: IReadWriteStateInternal;
  VDatabaseFileName: TFileName;
  VGeometryReader: IGeometryFromStream;
  VGeometryWriter: IGeometryToStream;
begin
  inherited Create;
  FDbId := Integer(Self);
  VState := TReadWriteStateInternal.Create;
  FState := VState;
  VStateInternal := VState;

  if AReadOnly then begin
    VStateInternal.WriteAccess := asDisabled;
  end;

  VDatabaseFileName := IncludeTrailingPathDelimiter(ABasePath) + 'Marks.db3';

  FModel := CreateModel;

  FClientDB :=
    TSQLRestClientDB.Create(
      FModel,
      nil,
      VDatabaseFileName,
      TSQLRestServerDB
    );

  FClientDB.DB.WALMode := True;
  //FClientDB.DB.Synchronous := smNormal;

  FClientDB.Server.CreateMissingTables;

  VUserName := StringToUTF8('sasgis');

  FUser := TSQLUser.Create(FClientDB, 'Name=?', [VUserName]);
  if FUser.ID = 0 then begin
    FUser.Name := VUserName;
    CheckID( FClientDB.Add(FUser, True) );
  end;

  VCategoryDb :=
    TMarkCategoryDbImplORM.Create(
      FDbId,
      FUser.ID,
      FClientDB
    );

  FCategoryDBImpl := VCategoryDb;
  FCategoryDBInternal := VCategoryDb;

  FFactoryDbInternal :=
    TMarkFactoryDbInternalORM.Create(
      FDbId,
      AMarkPictureList,
      AAppearanceOfMarkFactory,
      AMarkFactory,
      AHashFunction,
      AHintConverter,
      FCategoryDBInternal
    );

  //ToDo: use WKB
  VGeometryReader := TGeometryFromStreamSML.Create(AVectorGeometryLonLatFactory);
  VGeometryWriter := TGeometryToStreamSML.Create;

  VMarkDb :=
    TMarkDbImplORM.Create(
      FDbId,
      FUser.ID,
      FClientDB,
      FFactoryDbInternal,
      VGeometryReader,
      VGeometryWriter,
      AVectorItemSubsetBuilderFactory
    );

  FMarkDbImpl := VMarkDb;
  FMarkDbInternal := VMarkDb;
end;

destructor TMarkSystemImplORM.Destroy;
begin
  FreeAndNil(FUser);
  FreeAndNil(FClientDB);
  FreeAndNil(FModel);
  inherited;
end;

function TMarkSystemImplORM.GetCategoryDB: IMarkCategoryDBImpl;
begin
  Result := FCategoryDBImpl;
end;

function TMarkSystemImplORM.GetMarkByStringId(const AId: string): IVectorDataItem;
var
  VId: Integer; // ! TID
begin
  Result := nil;
  if AId <> '' then begin
    if TryStrToInt(AId, VId) then begin
      if not Supports(FMarkDbInternal.GetById(VId), IVectorDataItem, Result) then begin
        Result := nil;
      end;
    end;
  end;
end;

function TMarkSystemImplORM.GetMarkCategoryByStringId(const AId: string): IMarkCategory;
var
  VId: Integer; // ! TID
begin
  Result := nil;
  if AId <> '' then begin
    if TryStrToInt(AId, VId) then begin
      if not Supports(FCategoryDBInternal.GetCategoryByID(VId), IMarkCategory, Result) then begin
        Result := nil;
      end;
    end;
  end;
end;

function TMarkSystemImplORM.GetMarkDb: IMarkDbImpl;
begin
  Result := FMarkDbImpl;
end;

function TMarkSystemImplORM.GetState: IReadWriteStateChangeble;
begin
  Result := FState;
end;

function TMarkSystemImplORM.GetStringIdByMark(const AMark: IVectorDataItem): string;
var
  VMark: IMarkInternalORM;
begin
  Result := '';
  if Assigned(AMark) and Supports(AMark.MainInfo, IMarkInternalORM, VMark) then begin
    Result := IntToStr(VMark.Id);
  end;
end;

end.

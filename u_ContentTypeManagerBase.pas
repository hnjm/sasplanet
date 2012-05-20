{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
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
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_ContentTypeManagerBase;

interface

uses
  i_ContentTypeInfo,
  i_ContentConverter,
  i_ContentTypeManager,
  u_ContentTypeListByKey,
  u_ContentConverterMatrix;

type
  TContentTypeManagerBase = class(TInterfacedObject, IContentTypeManager)
  private
    FExtList: TContentTypeListByKey;
    FTypeList: TContentTypeListByKey;
    FBitmapExtList: TContentTypeListByKey;
    FBitmapTypeList: TContentTypeListByKey;
    FKmlExtList: TContentTypeListByKey;
    FKmlTypeList: TContentTypeListByKey;
    FConverterMatrix: TContentConverterMatrix;
  protected
    procedure AddByType(
      const AInfo: IContentTypeInfoBasic;
      const AType: string
    );
    procedure AddByExt(
      const AInfo: IContentTypeInfoBasic;
      const AExt: string
    );
    property ExtList: TContentTypeListByKey read FExtList;
    property TypeList: TContentTypeListByKey read FTypeList;
    property BitmapExtList: TContentTypeListByKey read FBitmapExtList;
    property BitmapTypeList: TContentTypeListByKey read FBitmapTypeList;
    property KmlExtList: TContentTypeListByKey read FKmlExtList;
    property KmlTypeList: TContentTypeListByKey read FKmlTypeList;
    property ConverterMatrix: TContentConverterMatrix read FConverterMatrix;

  protected
    function GetInfo(const AType: WideString): IContentTypeInfoBasic;
    function GetInfoByExt(const AExt: WideString): IContentTypeInfoBasic;
    function GetIsBitmapType(const AType: WideString): Boolean;
    function GetIsBitmapExt(const AExt: WideString): Boolean;
    function GetIsKmlType(const AType: WideString): Boolean;
    function GetIsKmlExt(const AExt: WideString): Boolean;
    function GetConverter(const ATypeSource, ATypeTarget: WideString): IContentConverter;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

procedure TContentTypeManagerBase.AddByExt(
  const AInfo: IContentTypeInfoBasic;
  const AExt: string
);
begin
  FExtList.Add(AExt, AInfo);
  if Supports(AInfo, IContentTypeInfoBitmap) then begin
    FBitmapExtList.Add(AExt, AInfo);
  end else if Supports(AInfo, IContentTypeInfoVectorData) then begin
    FKmlExtList.Add(AExt, AInfo);
  end;
end;

procedure TContentTypeManagerBase.AddByType(
  const AInfo: IContentTypeInfoBasic;
  const AType: string
);
begin
  FTypeList.Add(AType, AInfo);
  if Supports(AInfo, IContentTypeInfoBitmap) then begin
    FBitmapTypeList.Add(AType, AInfo);
  end else if Supports(AInfo, IContentTypeInfoVectorData) then begin
    FKmlTypeList.Add(AType, AInfo);
  end;
end;

constructor TContentTypeManagerBase.Create;
begin
  inherited Create;
  FExtList := TContentTypeListByKey.Create;
  FTypeList := TContentTypeListByKey.Create;
  FBitmapExtList := TContentTypeListByKey.Create;
  FBitmapTypeList := TContentTypeListByKey.Create;
  FKmlExtList := TContentTypeListByKey.Create;
  FKmlTypeList := TContentTypeListByKey.Create;
  FConverterMatrix := TContentConverterMatrix.Create;
end;

destructor TContentTypeManagerBase.Destroy;
begin
  FreeAndNil(FExtList);
  FreeAndNil(FTypeList);
  FreeAndNil(FBitmapExtList);
  FreeAndNil(FBitmapTypeList);
  FreeAndNil(FKmlExtList);
  FreeAndNil(FKmlTypeList);
  FreeAndNil(FConverterMatrix);
  inherited;
end;

function TContentTypeManagerBase.GetConverter(
  const ATypeSource, ATypeTarget: WideString): IContentConverter;
begin
  Result := FConverterMatrix.Get(ATypeSource, ATypeTarget);
end;

function TContentTypeManagerBase.GetInfo(
  const AType: WideString): IContentTypeInfoBasic;
begin
  Result := FTypeList.Get(AType);
end;

function TContentTypeManagerBase.GetInfoByExt(
  const AExt: WideString): IContentTypeInfoBasic;
begin
  Result := FExtList.Get(AExt);
end;

function TContentTypeManagerBase.GetIsBitmapExt(const AExt: WideString): Boolean;
begin
  Result := FBitmapExtList.Get(AExt) <> nil;
end;

function TContentTypeManagerBase.GetIsBitmapType(const AType: WideString): Boolean;
begin
  Result := FBitmapTypeList.Get(AType) <> nil;
end;

function TContentTypeManagerBase.GetIsKmlExt(const AExt: WideString): Boolean;
begin
  Result := FKmlExtList.Get(AExt) <> nil;
end;

function TContentTypeManagerBase.GetIsKmlType(const AType: WideString): Boolean;
begin
  Result := FKmlTypeList.Get(AType) <> nil;
end;

end.

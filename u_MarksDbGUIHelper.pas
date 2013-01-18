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

unit u_MarksDbGUIHelper;

interface

uses
  Windows,
  Classes,
  Dialogs,
  t_GeoTypes,
  i_PathConfig,
  i_LanguageManager,
  i_ProjectionInfo,
  i_VectorItemsFactory,
  i_ArchiveReadWriteFactory,
  i_ValueToStringConverter,
  i_VectorItemLonLat,
  i_LocalCoordConverterChangeable,
  i_MarksSimple,
  i_MarkCategory,
  i_MarksSystem,
  i_ImportConfig,
  frm_MarkCategoryEdit,
  frm_MarkEditPoint,
  frm_MarkEditPath,
  frm_MarkEditPoly,
  frm_MarkInfo,
  frm_ImportConfigEdit,
  frm_MarksMultiEdit;

type
  TMarksDbGUIHelper = class
  private
    FMarksDb: IMarksSystem;
    FVectorItemsFactory: IVectorItemsFactory;
    FArchiveReadWriteFactory: IArchiveReadWriteFactory;
    FValueToStringConverterConfig: IValueToStringConverterConfig;
    FfrmMarkEditPoint: TfrmMarkEditPoint;
    FfrmMarkEditPath: TfrmMarkEditPath;
    FfrmMarkEditPoly: TfrmMarkEditPoly;
    FfrmMarkCategoryEdit: TfrmMarkCategoryEdit;
    FfrmImportConfigEdit: TfrmImportConfigEdit;
    FfrmMarksMultiEdit: TfrmMarksMultiEdit;
    FfrmMarkInfo: TfrmMarkInfo;
    FExportDialog: TSaveDialog;
  public
    function GetMarkIdCaption(const AMarkId: IMarkId): string;

    function DeleteMarkModal(
      const AMarkId: IMarkId;
      handle: THandle
    ): Boolean;
    function DeleteMarksModal(
      const AMarkIDList: IInterfaceList;
      handle: THandle
    ): Boolean;
    function DeleteCategoryModal(
      const ACategory: IMarkCategory;
      handle: THandle
    ): Boolean;
    function PolygonForOperation(
      const AMark: IMark;
      const AProjection: IProjectionInfo
    ): ILonLatPolygon;
    function AddKategory(const Name: string): IMarkCategory;
    procedure ShowMarkInfo(
      const AMark: IMark
    );
    function EditMarkModal(
      const AMark: IMark;
      AIsNewMark: Boolean
    ): IMark;
    function EditCategoryModal(
      const ACategory: IMarkCategory;
      AIsNewMark: Boolean
    ): IMarkCategory;
    function AddNewPointModal(const ALonLat: TDoublePoint): Boolean;
    function SavePointModal(
      const AMark: IMarkPoint;
      const ALonLat: TDoublePoint
    ): Boolean;
    function SavePolyModal(
      const AMark: IMarkPoly;
      const ALine: ILonLatPolygon;
      AAsNewMark: Boolean = false
    ): Boolean;
    function SaveLineModal(
      const AMark: IMarkLine;
      const ALine: ILonLatPath;
      const ADescription: string;
      AAsNewMark: Boolean = false
    ): Boolean;
    function EditModalImportConfig: IImportConfig;
    function MarksMultiEditModal(const ACategory: ICategory): IImportConfig;
    procedure ExportMark(const AMark: IMark);
    procedure ExportCategory(
      const AMarkCategory: IMarkCategory;
      AIgnoreMarksVisible: Boolean
    );
    procedure ExportCategoryList(
      ACategoryList: IInterfaceList;
      AIgnoreMarksVisible: Boolean
    );

    property MarksDb: IMarksSystem read FMarksDb;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AMediaPath: IPathConfig;
      const AMarksDB: IMarksSystem;
      const AViewPortState: ILocalCoordConverterChangeable;
      const AVectorItemsFactory: IVectorItemsFactory;
      const AArchiveReadWriteFactory: IArchiveReadWriteFactory;
      const AValueToStringConverterConfig: IValueToStringConverterConfig
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  gnugettext,
  i_DoublePointFilter,
  u_Datum,
  u_ResStrings,
  u_EnumDoublePointLine2Poly,
//  u_EnumDoublePointCircleByPoint,
  u_ExportMarks2KML,
  u_GeoFun,
  u_GeoToStr;

{ TMarksDbGUIHelper }

constructor TMarksDbGUIHelper.Create(
  const ALanguageManager: ILanguageManager;
  const AMediaPath: IPathConfig;
  const AMarksDB: IMarksSystem;
  const AViewPortState: ILocalCoordConverterChangeable;
  const AVectorItemsFactory: IVectorItemsFactory;
  const AArchiveReadWriteFactory: IArchiveReadWriteFactory;
  const AValueToStringConverterConfig: IValueToStringConverterConfig
);
begin
  inherited Create;
  FMarksDb := AMarksDB;
  FVectorItemsFactory := AVectorItemsFactory;
  FArchiveReadWriteFactory := AArchiveReadWriteFactory;
  FValueToStringConverterConfig := AValueToStringConverterConfig;
  FfrmMarkEditPoint :=
    TfrmMarkEditPoint.Create(
      ALanguageManager,
      AMediaPath,
      FMarksDb.CategoryDB,
      FMarksDb.MarksDb,
      AViewPortState,
      AValueToStringConverterConfig
    );
  FfrmMarkEditPath :=
    TfrmMarkEditPath.Create(
      ALanguageManager,
      AMediaPath,
      FMarksDb.CategoryDB,
      FMarksDb.MarksDb
    );
  FfrmMarkEditPoly :=
    TfrmMarkEditPoly.Create(
      ALanguageManager,
      AMediaPath,
      FMarksDb.CategoryDB,
      FMarksDb.MarksDb
    );
  FfrmMarkCategoryEdit :=
    TfrmMarkCategoryEdit.Create(
      ALanguageManager,
      FMarksDb.CategoryDB
    );
  FfrmImportConfigEdit :=
    TfrmImportConfigEdit.Create(
      ALanguageManager,
      FMarksDb.CategoryDB,
      FMarksDb.MarksDb
    );
  FfrmMarkInfo :=
    TfrmMarkInfo.Create(
      ALanguageManager,
      AValueToStringConverterConfig,
      TDatum.Create(3395, 6378137, 6356752)
    );
  FfrmMarksMultiEdit :=
    TfrmMarksMultiEdit.Create(
      ALanguageManager,
      FMarksDb.CategoryDB,
      FMarksDb.MarksDb
    );
  FExportDialog := TSaveDialog.Create(nil);

  //ExportDialog
  FExportDialog.Name := 'ExportDialog';
  FExportDialog.DefaultExt := '.kmz';
  FExportDialog.Filter := _('Compressed Keyhole Markup Language (kmz)|*.kmz|Keyhole Markup Language (kml)|*.kml');
  FExportDialog.Options := [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing];
end;

destructor TMarksDbGUIHelper.Destroy;
begin
  FreeAndNil(FfrmMarkEditPoint);
  FreeAndNil(FfrmMarkEditPath);
  FreeAndNil(FfrmMarkEditPoly);
  FreeAndNil(FfrmMarkCategoryEdit);
  FreeAndNil(FfrmImportConfigEdit);
  FreeAndNil(FfrmMarksMultiEdit);
  FreeAndNil(FfrmMarkInfo);
  FreeAndNil(FExportDialog);
  inherited;
end;

function TMarksDbGUIHelper.AddKategory(const Name: string): IMarkCategory;
var
  VCategory: IMarkCategory;
begin
  VCategory := FMarksDb.CategoryDB.Factory.CreateNew(Name);
  Result := FMarksDb.CategoryDB.GetCategoryByName(VCategory.Name);
  if Result = nil then begin
    Result := FMarksDb.CategoryDB.UpdateCategory(nil, VCategory);
  end;
end;

function TMarksDbGUIHelper.AddNewPointModal(const ALonLat: TDoublePoint): Boolean;
var
  VMark: IMarkPoint;
begin
  Result := False;
  VMark := FMarksDb.MarksDb.Factory.CreateNewPoint(ALonLat, '', '');
  VMark := FfrmMarkEditPoint.EditMark(VMark, True);
  if VMark <> nil then begin
    FMarksDb.MarksDb.UpdateMark(nil, VMark);
    Result := True;
  end;
end;

function TMarksDbGUIHelper.DeleteCategoryModal(
  const ACategory: IMarkCategory;
  handle: THandle
): Boolean;
var
  VMessage: string;
begin
  Result := False;
  if ACategory <> nil then begin
    VMessage := Format(SAS_MSG_DeleteMarkCategoryAsk, [ACategory.Name]);
    if MessageBox(handle, PChar(VMessage), PChar(SAS_MSG_coution), 36) = IDYES then begin
      FMarksDb.DeleteCategoryWithMarks(ACategory);
      Result := True;
    end;
  end;
end;

function TMarksDbGUIHelper.DeleteMarkModal(
  const AMarkId: IMarkId;
  handle: THandle
): Boolean;
var
  VMark: IMark;
  VMessage: string;
begin
  Result := False;
  if AMarkId <> nil then begin
    VMark := FMarksDb.MarksDb.GetMarkByID(AMarkId);
    if VMark <> nil then begin
      if Supports(VMark, IMarkPoint) then begin
        VMessage := SAS_MSG_DeleteMarkPointAsk;
      end else if Supports(VMark, IMarkLine) then begin
        VMessage := SAS_MSG_DeleteMarkPathAsk;
      end else if Supports(VMark, IMarkPoly) then begin
        VMessage := SAS_MSG_DeleteMarkPolyAsk;
      end;
      VMessage := Format(VMessage, [AMarkId.Name]);
      if MessageBox(handle, PChar(VMessage), PChar(SAS_MSG_coution), 36) = IDYES then begin
        FMarksDb.MarksDb.UpdateMark(AMarkId, nil);
        Result := True;
      end;
    end;
  end;
end;

function TMarksDbGUIHelper.DeleteMarksModal(
  const AMarkIDList: IInterfaceList;
  handle: THandle
): Boolean;
var
  VMark: IMarkId;
  VMessage: string;
begin
  Result := False;
  if (AMarkIDList <> nil) and (AMarkIDList.Count > 0) then begin
    if AMarkIDList.Count = 1 then begin
      VMark := IMarkId(AMarkIDList[0]);
      Result := DeleteMarkModal(VMark, handle);
    end else begin
      VMessage := Format(SAS_MSG_DeleteManyMarksAsk, [AMarkIDList.Count]);
      if MessageBox(handle, PChar(VMessage), PChar(SAS_MSG_coution), 36) = IDYES then begin
        FMarksDb.MarksDb.UpdateMarksList(AMarkIDList, nil);
        Result := True;
      end;
    end;
  end;
end;

function TMarksDbGUIHelper.EditCategoryModal(
  const ACategory: IMarkCategory;
  AIsNewMark: Boolean
): IMarkCategory;
begin
  Result := FfrmMarkCategoryEdit.EditCategory(ACategory, AIsNewMark);
end;

function TMarksDbGUIHelper.EditMarkModal(
  const AMark: IMark;
  AIsNewMark: Boolean
): IMark;
var
  VMarkPoint: IMarkPoint;
  VMarkLine: IMarkLine;
  VMarkPoly: IMarkPoly;
begin
  Result := nil;
  if Supports(AMark, IMarkPoint, VMarkPoint) then begin
    Result := FfrmMarkEditPoint.EditMark(VMarkPoint, AIsNewMark);
  end else if Supports(AMark, IMarkLine, VMarkLine) then begin
    Result := FfrmMarkEditPath.EditMark(VMarkLine, AIsNewMark);
  end else if Supports(AMark, IMarkPoly, VMarkPoly) then begin
    Result := FfrmMarkEditPoly.EditMark(VMarkPoly, AIsNewMark);
  end;
end;

function TMarksDbGUIHelper.EditModalImportConfig: IImportConfig;
begin
  Result := FfrmImportConfigEdit.GetImportConfig;
end;

procedure TMarksDbGUIHelper.ExportCategory(
  const AMarkCategory: IMarkCategory;
  AIgnoreMarksVisible: Boolean
);
var
  KMLExport: TExportMarks2KML;
  VMarksSubset: IMarksSubset;
  VFileName: string;
begin
  if AMarkCategory <> nil then begin
    VFileName := AMarkCategory.Name;
    VFileName := StringReplace(VFileName, '\', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '/', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, ':', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '*', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '?', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '"', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '>', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '<', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '|', '-', [rfReplaceAll]);
    FExportDialog.FileName := VFileName;
    if FExportDialog.Execute then begin
      VFileName := FExportDialog.FileName;
      if VFileName <> '' then begin
        KMLExport := TExportMarks2KML.Create(FArchiveReadWriteFactory);
        try
          VMarksSubset :=
            FMarksDb.MarksDb.GetMarksSubset(
              DoubleRect(-180, 90, 180, -90),
              AMarkCategory,
              AIgnoreMarksVisible
            );
          KMLExport.ExportCategoryToKML(AMarkCategory, VMarksSubset, VFileName);
        finally
          KMLExport.free;
        end;
      end;
    end;
  end;
end;

procedure TMarksDbGUIHelper.ExportCategoryList(
  ACategoryList: IInterfaceList;
  AIgnoreMarksVisible: Boolean
);
var
  KMLExport: TExportMarks2KML;
  VMarksSubset: IMarksSubset;
  VFileName: string;
begin
  if (ACategoryList <> nil) and (ACategoryList.Count > 0) then begin
    if FExportDialog.Execute then begin
      VFileName := FExportDialog.FileName;
      if VFileName <> '' then begin
        KMLExport := TExportMarks2KML.Create(FArchiveReadWriteFactory);
        try
          VMarksSubset :=
            FMarksDb.MarksDb.GetMarksSubset(
              DoubleRect(-180, 90, 180, -90),
              ACategoryList,
              AIgnoreMarksVisible
            );
          KMLExport.ExportToKML(ACategoryList, VMarksSubset, VFileName);
        finally
          KMLExport.free;
        end;
      end;
    end;
  end;
end;

procedure TMarksDbGUIHelper.ExportMark(const AMark: IMark);
var
  KMLExport: TExportMarks2KML;
  VFileName: string;
begin
  if AMark <> nil then begin
    VFileName := AMark.Name;
    VFileName := StringReplace(VFileName, '\', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '/', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, ':', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '*', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '?', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '"', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '>', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '<', '-', [rfReplaceAll]);
    VFileName := StringReplace(VFileName, '|', '-', [rfReplaceAll]);
    FExportDialog.FileName := VFileName;
    if FExportDialog.Execute then begin
      VFileName := FExportDialog.FileName;
      if VFileName <> '' then begin
        KMLExport := TExportMarks2KML.Create(FArchiveReadWriteFactory);
        try
          KMLExport.ExportMarkToKML(AMark, VFileName);
        finally
          KMLExport.free;
        end;
      end;
    end;
  end;
end;

function TMarksDbGUIHelper.GetMarkIdCaption(const AMarkId: IMarkId): string;
var
  VPointCaptionFormat: string;
  VPolygonCaptionFormat: string;
  VPathCaptionFormat: string;
  VFormat: string;
  VName: string;
begin
  VPointCaptionFormat := SAS_STR_ExtendedPointCaption;
  VPolygonCaptionFormat := SAS_STR_ExtendedPolygonCaption;
  VPathCaptionFormat := SAS_STR_ExtendedPathCaption;
  VName := AMarkId.Name;
  if VName = '' then begin
    VName := '(NoName)';
  end;
  case AMarkId.MarkType of
  mt_Point:
    VFormat := VPointCaptionFormat;
  mt_Polyline:
    VFormat := VPathCaptionFormat;
  mt_Polygon:
    VFormat := VPolygonCaptionFormat;
  else
    VFormat := '%0:s';
  end;
  Result := Format(VFormat, [VName]);
end;

function TMarksDbGUIHelper.MarksMultiEditModal(const ACategory: ICategory): IImportConfig;
begin
  Result := FfrmMarksMultiEdit.GetImportConfig(ACategory);
end;

procedure TMarksDbGUIHelper.ShowMarkInfo(
  const AMark: IMark
);
begin
  if AMark <> nil then begin
    FfrmMarkInfo.ShowInfoModal(AMark);
  end;
end;


function TMarksDbGUIHelper.PolygonForOperation(
  const AMark: IMark;
  const AProjection: IProjectionInfo
  ): ILonLatPolygon;
var
  VMarkPoly: IMarkPoly;
  VMarkLine: IMarkLine;
  VMarkPoint: IMarkPoint;
  VDefRadius: String;
  VRadius: double;
  VFilter: ILonLatPointFilter;
begin
  if Supports(AMark, IMarkPoly, VMarkPoly) then begin
    Result := VMarkPoly.Line;
  end else begin
  if Supports(AMark, IMarkLine, VMarkLine) then begin
    VDefRadius := '100';
    if InputQuery('', 'Radius , m', VDefRadius) then begin
      try
        VRadius := str2r(VDefRadius);
      except
        ShowMessage(SAS_ERR_ParamsInput);
        Exit;
      end;
      VFilter := TLonLatPointFilterLine2Poly.Create(VRadius, AProjection);
      Result :=
        FVectorItemsFactory.CreateLonLatPolygonByLonLatPathAndFilter(
          VMarkLine.Line,
          VFilter
          );
    end;
  end else begin
    if Supports(AMark, IMarkPoint, VMarkPoint) then begin
      VDefRadius := '100';
      if InputQuery('', 'Radius , m', VDefRadius) then begin
        try
          VRadius := str2r(VDefRadius);
        except
          ShowMessage(SAS_ERR_ParamsInput);
          Exit;
        end;
        Result :=
          FVectorItemsFactory.CreateLonLatPolygonCircleByPoint(
            AProjection,
            VMarkPoint.GetPoint,
            VRadius
          );
        end;
      end;
    end;
  end;
end;

function TMarksDbGUIHelper.SaveLineModal(
  const AMark: IMarkLine;
  const ALine: ILonLatPath;
  const ADescription: string;
  AAsNewMark: Boolean
): Boolean;
var
  VMark: IMarkLine;
  VSourceMark: IMarkLine;
  VNewMark: Boolean;
begin
  Result := False;
  if AMark <> nil then begin
    VMark := FMarksDb.MarksDb.Factory.SimpleModifyLine(AMark, ALine, ADescription);
    VNewMark := AAsNewMark;
  end else begin
    VMark := FMarksDb.MarksDb.Factory.CreateNewLine(ALine, '', ADescription);
    VNewMark := True;
  end;
  if VMark <> nil then begin
    VMark := FfrmMarkEditPath.EditMark(VMark, VNewMark);
    if VMark <> nil then begin
      if AAsNewMark then begin
        VSourceMark := nil;
      end else begin
        VSourceMark := AMark;
      end;
      FMarksDb.MarksDb.UpdateMark(VSourceMark, VMark);
      Result := True;
    end;
  end;
end;

function TMarksDbGUIHelper.SavePointModal(
  const AMark: IMarkPoint;
  const ALonLat: TDoublePoint
): Boolean;
var
  VMark: IMarkPoint;
  VNewMark: Boolean;
begin
  Result := False;
  if AMark <> nil then begin
    VMark := FMarksDb.MarksDb.Factory.SimpleModifyPoint(AMark, ALonLat);
    VNewMark := False;
  end else begin
    VMark := FMarksDb.MarksDb.Factory.CreateNewPoint(ALonLat, '', '');
    VNewMark := True;
  end;
  if VMark <> nil then begin
    VMark := FfrmMarkEditPoint.EditMark(VMark, VNewMark);
    if VMark <> nil then begin
      FMarksDb.MarksDb.UpdateMark(AMark, VMark);
      Result := True;
    end;
  end;
end;

function TMarksDbGUIHelper.SavePolyModal(
  const AMark: IMarkPoly;
  const ALine: ILonLatPolygon;
  AAsNewMark: Boolean
): Boolean;
var
  VMark: IMarkPoly;
  VSourceMark: IMarkPoly;
  VNewMark: Boolean;
begin
  Result := False;
  if AMark <> nil then begin
    VMark := FMarksDb.MarksDb.Factory.SimpleModifyPoly(AMark, ALine);
    VNewMark := AAsNewMark;
  end else begin
    VMark := FMarksDb.MarksDb.Factory.CreateNewPoly(ALine, '', '');
    VNewMark := True;
  end;
  if VMark <> nil then begin
    VMark := FfrmMarkEditPoly.EditMark(VMark, VNewMark);
    if VMark <> nil then begin
      if AAsNewMark then begin
        VSourceMark := nil;
      end else begin
        VSourceMark := AMark;
      end;
      FMarksDb.MarksDb.UpdateMark(VSourceMark, VMark);
      Result := True;
    end;
  end;
end;

end.



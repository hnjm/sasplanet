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

unit u_ExportMarks2KML;

interface

uses
  Classes,
  SysUtils,
  Windows,
  GR32,
  XMLIntf,
  XMLDoc,
  ActiveX,
  i_InterfaceListStatic,
  i_ArchiveReadWrite,
  i_ArchiveReadWriteFactory,
  i_AppearanceOfVectorItem,
  i_Category,
  i_VectorDataItemSimple,
  i_VectorItemSubset,
  u_GeoToStr;

type
  TExportMarks2KML = class
  private
    FKmlDoc: IXMLDocument;
    FFileName: string;
    FKmlNode: iXMLNode;
    FKmlDocumentNode: iXMLNode;
    FArchiveReadWriteFactory: IArchiveReadWriteFactory;
    FZip: IArchiveWriter;
    procedure AddFolders(
      const AMarksSet: IVectorItemSubset;
      const ACategoryList: IInterfaceListStatic
    );
    function AddFolder(
      const AParentNode: IXMLNode;
      const ACategoryNamePostfix: string;
      const AMarksSubset: IVectorItemSubset
    ): boolean;
    function AddMarks(
      const AMarksSubset: IVectorItemSubset;
      const inNode: iXMLNode
    ): Boolean;
    procedure AddMark(
      const AMark: IVectorDataItemSimple;
      const inNode: iXMLNode
    );
    function SaveMarkIcon(const AAppearanceIcon: IAppearancePointIcon): string;
    function Color32toKMLColor(Color32: TColor32): string;
    procedure PrepareExportToFile(const AFileName: string);
    procedure SaveToFile;
  public
    constructor Create(const AArchiveReadWriteFactory: IArchiveReadWriteFactory);
    procedure ExportToKML(
      const ACategoryList: IInterfaceListStatic;
      const AMarksSubset: IVectorItemSubset;
      const AFileName: string
    );
    procedure ExportCategoryToKML(
      const ACategory: ICategory;
      const AMarksSubset: IVectorItemSubset;
      const AFileName: string
    );
    procedure ExportMarkToKML(
      const AMark: IVectorDataItemSimple;
      const AFileName: string
    );
  end;

implementation

uses
  t_GeoTypes,
  i_BinaryData,
  i_EnumDoublePoint,
  i_GeometryLonLat,
  u_BinaryDataByMemStream,
  u_StreamReadOnlyByBinaryData;

function XMLTextPrepare(const Src: AnsiString): AnsiString;
var
  i, l: integer;
  Buf, P: PAnsiChar;
  ch: Integer;
begin
  Result := '';
  L := Length(src);
  if L = 0 then begin
    exit;
  end;
  GetMem(Buf, L);
  try
    P := Buf;
    for i := 1 to L do begin
      ch := Ord(src[i]);
      if (ch >= 32) or (ch = $09) or (ch = $0A) or (ch = $0D) then begin
        P^ := AnsiChar(ch);
        Inc(P);
      end;
    end;
    SetString(Result, Buf, P - Buf);
  finally
    FreeMem(Buf);
  end;
end;

function GetKMLCoordinates(
  const APointEnum: IEnumLonLatPoint
): String;
var
  VPoint: TDoublePoint;
begin
  Result := '';
  while APointEnum.Next(VPoint) do begin
    Result := Result + R2StrPoint(VPoint.X) + ',' + R2StrPoint(VPoint.Y) + ',0 ';
  end;
end;

constructor TExportMarks2KML.Create(
  const AArchiveReadWriteFactory: IArchiveReadWriteFactory
);
begin
  inherited Create;
  FArchiveReadWriteFactory := AArchiveReadWriteFactory;
end;

procedure TExportMarks2KML.PrepareExportToFile(const AFileName: string);
begin
  FKmlDoc := TXMLDocument.Create(nil);
  FKmlDoc.Options := FKmlDoc.Options + [doNodeAutoIndent];
  FKmlDoc.Active := true;
  FKmlDoc.Version := '1.0';
  FKmlDoc.Encoding := 'UTF-8';
  FKmlNode := FKmlDoc.AddChild('kml');
  FKmlNode.Attributes['xmlns'] := 'http://earth.google.com/kml/2.2';
  FKmlDocumentNode := FKmlNode.AddChild('Document');
  FFileName := AFileName;
  if ExtractFileExt(FFileName) = '.kmz' then begin
    FZip := FArchiveReadWriteFactory.CreateZipWriterByName(FFileName);
  end else begin
    FZip := nil;
  end;
end;

procedure TExportMarks2KML.SaveToFile;
var
  KMLStream: TMemoryStream;
  VData: IBinaryData;
begin
  if Assigned(FZip) then begin
    KMLStream := TMemoryStream.Create;
    try
      FKmlDoc.SaveToStream(KMLStream);
      KMLStream.Position := 0;
      VData := TBinaryDataByMemStream.CreateWithOwn(KMLStream);
      FZip.AddFile(VData, 'doc.kml', Now);
    finally
      KMLStream.Free;
    end;
  end else begin
    FKmlDoc.SaveToFile(FFileName);
  end;
end;

procedure TExportMarks2KML.ExportToKML(
  const ACategoryList: IInterfaceListStatic;
  const AMarksSubset: IVectorItemSubset;
  const AFileName: string
);
begin
  PrepareExportToFile(AFileName);
  AddFolders(AMarksSubset, ACategoryList);
  SaveToFile;
end;

procedure TExportMarks2KML.ExportCategoryToKML(
  const ACategory: ICategory;
  const AMarksSubset: IVectorItemSubset;
  const AFileName: string
);
begin
  PrepareExportToFile(AFileName);
  AddFolder(FKmlDocumentNode, ACategory.Name, AMarksSubset);
  SaveToFile;
end;

procedure TExportMarks2KML.ExportMarkToKML(
  const AMark: IVectorDataItemSimple;
  const AFileName: string
);
begin
  PrepareExportToFile(AFileName);
  AddMark(AMark, FKmlDocumentNode);
  SaveToFile;
end;

procedure TExportMarks2KML.AddFolders(
  const AMarksSet: IVectorItemSubset;
  const ACategoryList: IInterfaceListStatic
);
var
  K: Integer;
  VCategory: ICategory;
  VMarksSubset: IVectorItemSubset;
begin
  for K := 0 to ACategoryList.Count - 1 do begin
    VCategory := ICategory(Pointer(ACategoryList.Items[K]));
    VMarksSubset := AMarksSet.GetSubsetByCategory(VCategory);
    AddFolder(FKmlDocumentNode, VCategory.Name, VMarksSubset);
  end;
end;

function TExportMarks2KML.AddFolder(
  const AParentNode: IXMLNode;
  const ACategoryNamePostfix: string;
  const AMarksSubset: IVectorItemSubset
): boolean;
  function FindNodeWithText(
    AParent: iXMLNode;
  const ACategoryNameElement: string
  ): IXMLNode;
  var
    i: Integer;
    tmpNode: IXMLNode;
  begin
    Result := nil;
    if AParent.HasChildNodes then begin
      for i := 0 to AParent.ChildNodes.Count - 1 do begin
        tmpNode := AParent.ChildNodes.Get(i);
        if (tmpNode.NodeName = 'Folder') and (tmpNode.ChildValues['name'] = ACategoryNameElement) then begin
          Result := tmpNode;
          break;
        end;
      end;
    end;
  end;

var
  VCatgoryNamePrefix: string;
  VCatgoryNamePostfix: string;
  VDelimiterPos: Integer;
  VNode: IXMLNode;
  VCreatedNode: Boolean;
begin
  if ACategoryNamePostfix = '' then begin
    Result := AddMarks(AMarksSubset, AParentNode);
  end else begin
    VDelimiterPos := Pos('\', ACategoryNamePostfix);
    if VDelimiterPos > 0 then begin
      VCatgoryNamePrefix := Copy(ACategoryNamePostfix, 1, VDelimiterPos - 1);
      VCatgoryNamePostfix := Copy(ACategoryNamePostfix, VDelimiterPos + 1, Length(ACategoryNamePostfix));
    end else begin
      VCatgoryNamePrefix := ACategoryNamePostfix;
      VCatgoryNamePostfix := '';
    end;
    VCreatedNode := False;
    if VCatgoryNamePrefix = '' then begin
      VNode := AParentNode;
    end else begin
      VNode := FindNodeWithText(AParentNode, VCatgoryNamePrefix);
      if (VNode = nil) then begin
        VNode := AParentNode.AddChild('Folder');
        VNode.ChildValues['name'] := VCatgoryNamePrefix;
        VNode.ChildValues['open'] := 1;
        with VNode.AddChild('Style').AddChild('ListStyle') do begin
          ChildValues['listItemType'] := 'check';
          ChildValues['bgColor'] := '00ffffff';
        end;
        VCreatedNode := True;
      end;
    end;
    Result := AddFolder(VNode, VCatgoryNamePostfix, AMarksSubset);
    if (not Result) and (VCreatedNode) then begin
      AParentNode.ChildNodes.Remove(VNode);
    end;
  end;
end;

function TExportMarks2KML.AddMarks(
  const AMarksSubset: IVectorItemSubset;
  const inNode: iXMLNode
): Boolean;
var
  VMark: IVectorDataItemSimple;
  VEnumMarks: IEnumUnknown;
  i: integer;
begin
  Result := False;
  if Assigned(AMarksSubset) then begin
    VEnumMarks := AMarksSubset.GetEnum;
    while (VEnumMarks.Next(1, VMark, @i) = S_OK) do begin
      AddMark(VMark, inNode);
      Result := True;
    end;
  end;
end;

procedure TExportMarks2KML.AddMark(
  const AMark: IVectorDataItemSimple;
  const inNode: iXMLNode
);
var
  i: integer;
  width: integer;
  currNode: IXMLNode;
  rootNode: IXMLNode;
  VCoordinates: string;
  VFileName: string;
  VMarkPoint: IVectorDataItemPoint;
  VAppearanceIcon: IAppearancePointIcon;
  VAppearanceCaption: IAppearancePointCaption;
  VMarkLine: IVectorDataItemLine;
  VAppearanceLine: IAppearanceLine;
  VMarkPoly: IVectorDataItemPoly;
  VAppearanceBorder: IAppearancePolygonBorder;
  VAppearanceFill: IAppearancePolygonFill;
  VLonLatPolygon: IGeometryLonLatMultiPolygon;
  VLonLatPolygonLine: IGeometryLonLatPolygon;
  VLonLatPath: IGeometryLonLatMultiLine;
  VLonLatPathLine: IGeometryLonLatLine;
begin
  currNode := inNode.AddChild('Placemark');
  currNode.ChildValues['name'] := XMLTextPrepare(AMark.Name);
  currNode.ChildValues['description'] := XMLTextPrepare(AMark.Desc);
  if Supports(AMark, IVectorDataItemPoint, VMarkPoint) then begin
    // Placemark
    if not Supports(AMark.Appearance, IAppearancePointIcon, VAppearanceIcon) then begin
      VAppearanceIcon := nil;
    end;
    if not Supports(AMark.Appearance, IAppearancePointCaption, VAppearanceCaption) then begin
      VAppearanceCaption := nil;
    end;
    if (VAppearanceCaption <> nil) or (VAppearanceIcon <> nil)  then begin
      with currNode.AddChild('Style') do begin
        if VAppearanceCaption <> nil then begin
          with AddChild('LabelStyle') do begin
            ChildValues['color'] := Color32toKMLColor(VAppearanceCaption.TextColor);
            ChildValues['scale'] := R2StrPoint(VAppearanceCaption.FontSize / 14);
          end;
        end;
        if VAppearanceIcon <> nil then begin
          if VAppearanceIcon.Pic <> nil then begin
            with AddChild('IconStyle') do begin
              VFileName := SaveMarkIcon(VAppearanceIcon);
              width := VAppearanceIcon.Pic.GetMarker.Size.X;
              ChildValues['scale'] := R2StrPoint(VAppearanceIcon.MarkerSize / width);
              with AddChild('Icon') do begin
                ChildValues['href'] := VFileName;
              end;
              with AddChild('hotSpot') do begin
                Attributes['x'] := '0.5';
                Attributes['y'] := 0;
                Attributes['xunits'] := 'fraction';
                Attributes['yunits'] := 'fraction';
              end;
            end;
          end;
        end;
      end;
    end;
    currNode := currNode.AddChild('Point');
    currNode.ChildValues['extrude'] := 1;
    with VMarkPoint.Point.Point do begin
      VCoordinates := R2StrPoint(X) + ',' + R2StrPoint(Y) + ',0 ';
    end;
    currNode.ChildValues['coordinates'] := VCoordinates;
  end else if Supports(AMark, IVectorDataItemLine, VMarkLine) then begin
    // <Placemark><MultiGeometry><LineString></LineString><LineString>...
    // <Placemark><LineString><coordinates>
    if Supports(AMark.Appearance, IAppearanceLine, VAppearanceLine) then begin
      with currNode.AddChild('Style') do begin
        with AddChild('LineStyle') do begin
          ChildValues['color'] := Color32toKMLColor(VAppearanceLine.LineColor);
          ChildValues['width'] := R2StrPoint(VAppearanceLine.LineWidth);
        end;
      end;
    end;
    VLonLatPath := VMarkLine.Line;
    if VLonLatPath.Count>1 then begin
      // MultiGeometry
      rootNode := currNode.AddChild('MultiGeometry');
      for i := 0 to VLonLatPath.Count-1 do begin
        VLonLatPathLine := VLonLatPath.Item[i];
        if (VLonLatPathLine.Count>1) then begin
          // make path
          currNode := rootNode.AddChild('LineString');
          currNode.ChildValues['extrude'] := 1;
          VCoordinates := GetKMLCoordinates(VLonLatPathLine.GetEnum);
          currNode.ChildValues['coordinates'] := VCoordinates;
        end;
      end;
    end else begin
      // simple object
      currNode := currNode.AddChild('LineString');
      currNode.ChildValues['extrude'] := 1;
      VLonLatPathLine := VLonLatPath.Item[0];
      VCoordinates := GetKMLCoordinates(VLonLatPathLine.GetEnum);
      currNode.ChildValues['coordinates'] := VCoordinates;
    end;
  end else if Supports(AMark, IVectorDataItemPoly, VMarkPoly) then begin
    // <Placemark><MultiGeometry><Polygon><outerBoundaryIs><LinearRing><coordinates>
    // <Placemark><Polygon><outerBoundaryIs><LinearRing><coordinates>
    if not Supports(AMark.Appearance, IAppearancePolygonBorder, VAppearanceBorder) then begin
      VAppearanceBorder := nil;
    end;
    if not Supports(AMark.Appearance, IAppearancePolygonFill, VAppearanceFill) then begin
      VAppearanceFill := nil;
    end;
    if (VAppearanceBorder <> nil) or (VAppearanceFill <> nil) then begin
      with currNode.AddChild('Style') do begin
        if VAppearanceBorder <> nil then begin
          with AddChild('LineStyle') do begin
            ChildValues['color'] := Color32toKMLColor(VAppearanceBorder.LineColor);
            ChildValues['width'] := R2StrPoint(VAppearanceBorder.LineWidth);
          end;
        end;
        if VAppearanceFill <> nil then begin
          with AddChild('PolyStyle') do begin
            ChildValues['color'] := Color32toKMLColor(VAppearanceFill.FillColor);
            ChildValues['fill'] := 1;
          end;
        end;
      end;
    end;
    VLonLatPolygon := VMarkPoly.Line;
    if VLonLatPolygon.Count>1 then begin
      // MultiGeometry
      rootNode := currNode.AddChild('MultiGeometry');
      for i := 0 to VLonLatPolygon.Count-1 do begin
        VLonLatPolygonLine := VLonLatPolygon.Item[i];
        if (VLonLatPolygonLine.Count>2) then begin
          // make contour
          currNode := rootNode.AddChild('Polygon').AddChild('outerBoundaryIs').AddChild('LinearRing');
          currNode.ChildValues['extrude'] := 1;
          VCoordinates := GetKMLCoordinates(VLonLatPolygonLine.GetEnum);
          currNode.ChildValues['coordinates'] := VCoordinates;
        end;
      end;
    end else begin
      // simple object
      currNode := currNode.AddChild('Polygon').AddChild('outerBoundaryIs').AddChild('LinearRing');
      currNode.ChildValues['extrude'] := 1;
      VLonLatPolygonLine := VLonLatPolygon.Item[0];
      VCoordinates := GetKMLCoordinates(VLonLatPolygonLine.GetEnum);
      currNode.ChildValues['coordinates'] := VCoordinates;
    end;
  end;
end;

function TExportMarks2KML.Color32toKMLColor(Color32: TColor32): string;
begin
  result := IntToHex(AlphaComponent(Color32), 2) +
    IntToHex(BlueComponent(Color32), 2) +
    IntToHex(GreenComponent(Color32), 2) +
    IntToHex(RedComponent(Color32), 2);
end;

function TExportMarks2KML.SaveMarkIcon(
  const AAppearanceIcon: IAppearancePointIcon
): string;
var
  VTargetPath: string;
  VTargetFullName: string;
  VPicName: string;
  VStream: TCustomMemoryStream;
  VData: IBinaryData;
begin
  Result := '';
  if AAppearanceIcon.Pic <> nil then begin
    VData := AAppearanceIcon.Pic.Source;
    if VData <> nil then begin
      VStream := TStreamReadOnlyByBinaryData.Create(VData);
      try
        VPicName := AAppearanceIcon.Pic.GetName;
        VTargetPath := 'files' + PathDelim;
        Result := VTargetPath + VPicName;
        if Assigned(FZip)  then begin
          FZip.AddFile(VData, Result, Now);
        end else begin
          VTargetPath := ExtractFilePath(FFileName) + VTargetPath;
          VTargetFullName := VTargetPath + VPicName;
          CreateDir(VTargetPath);
          VStream.SaveToFile(VTargetFullName);
        end;
      finally
        VStream.Free;
      end;
    end;
  end;
end;

end.

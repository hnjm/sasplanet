{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
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
  Forms,
  Classes,
  SysUtils,
  Windows,
  GR32,
  XMLIntf,
  
  XMLDoc,
  KaZip,
  ActiveX,
  i_MarksSimple,
  i_MarkCategory,
  u_GeoToStr;

type
  TExportMarks2KML = class
  private
    kmldoc:TXMLDocument;
    filename:string;
    inKMZ:boolean;
    doc:iXMLNode;
    Zip: TKaZip;
    procedure AddFolders(
      AMarksSet: IMarksSubset;
      ACategoryList: IInterfaceList
    );
    function AddFolder(
      AParentNode: IXMLNode;
      ACategoryNamePostfix: string;
      AMarksSubset: IMarksSubset
    ):boolean;
    function AddMarks(
      AMarksSubset: IMarksSubset;
      inNode:iXMLNode
    ): Boolean;
    procedure AddMark(Mark:IMark; inNode:iXMLNode);
    function SaveMarkIcon(Mark:IMarkPoint): string;
    function Color32toKMLColor(Color32:TColor32):string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ExportToKML(
      ACategoryList: IInterfaceList;
      AMarksSubset: IMarksSubset;
      AFileName: string
    );
    procedure ExportCategoryToKML(
      ACategory: IMarkCategory;
      AMarksSubset: IMarksSubset;
      AFileName: string
    );
    procedure ExportMarkToKML(
      Mark: IMark;
      AFileName: string
    );
  end;

implementation

constructor TExportMarks2KML.Create;
var child:iXMLNode;
begin
  kmldoc:=TXMLDocument.Create(Application);
  kmldoc.Options:=kmldoc.Options + [doNodeAutoIndent];
  kmldoc.Active:=true;
  kmldoc.Version:='1.0';
  kmldoc.Encoding:='UTF-8';
  child:=kmldoc.AddChild('kml');
  child.Attributes['xmlns']:='http://earth.google.com/kml/2.2';
  doc:=child.AddChild('Document');
  Zip := TKaZip.Create(nil);
end;

destructor TExportMarks2KML.Destroy;
begin
  Zip.Active := false;
  Zip.Close;
  Zip.Free;
  kmldoc.Free;
  inherited;
end;

procedure TExportMarks2KML.ExportToKML(
  ACategoryList: IInterfaceList;
  AMarksSubset: IMarksSubset;
  AFileName: string
);
var
  KMLStream:TMemoryStream;
begin
  filename:=Afilename;
  inKMZ:=ExtractFileExt(filename)='.kmz';
  if inKMZ then begin
    Zip.FileName := filename;
    Zip.CreateZip(filename);
    Zip.CompressionType := ctFast;
    Zip.Active := true;
    AddFolders(AMarksSubset, ACategoryList);
    KMLStream:=TMemoryStream.Create;
    try
      kmldoc.SaveToStream(KMLStream);
      KMLStream.Position:=0;
      Zip.AddStream('doc.kml',KMLStream);
    finally
      KMLStream.Free;
    end;
  end else begin
    AddFolders(AMarksSubset, ACategoryList);
    kmldoc.SaveToFile(FileName);
  end;
end;

procedure TExportMarks2KML.ExportCategoryToKML(
  ACategory: IMarkCategory;
  AMarksSubset: IMarksSubset;
  AFileName: string
);
var
  KMLStream:TMemoryStream;
begin
  filename:=Afilename;
  inKMZ:=ExtractFileExt(filename)='.kmz';
  if inKMZ then begin
    Zip.FileName := filename;
    Zip.CreateZip(filename);
    Zip.CompressionType := ctFast;
    Zip.Active := true;
    AddFolder(doc, ACategory.name, AMarksSubset);
    KMLStream:=TMemoryStream.Create;
    try
      kmldoc.SaveToStream(KMLStream);
      KMLStream.Position:=0;
      Zip.AddStream('doc.kml',KMLStream);
    finally
      KMLStream.Free;
    end;
  end else begin
    AddFolder(doc, ACategory.name, AMarksSubset);
    kmldoc.SaveToFile(FileName);
  end;
end;

procedure TExportMarks2KML.ExportMarkToKML(
  Mark: IMark;
  AFileName: string
);
var
  KMLStream:TMemoryStream;
begin
  filename:=Afilename;
  inKMZ:=ExtractFileExt(filename)='.kmz';
  if inKMZ then begin
    Zip.FileName := filename;
    Zip.CreateZip(filename);
    Zip.CompressionType := ctFast;
    Zip.Active := true;
    AddMark(Mark,doc);
    KMLStream:=TMemoryStream.Create;
    try
      kmldoc.SaveToStream(KMLStream);
      KMLStream.Position:=0;
      Zip.AddStream('doc.kml',KMLStream);
    finally
      KMLStream.Free;
    end;
  end else begin
    AddMark(Mark,doc);
    kmldoc.SaveToFile(FileName);
  end;
end;

procedure TExportMarks2KML.AddFolders(
  AMarksSet: IMarksSubset;
  ACategoryList: IInterfaceList
);
var
  K: Integer;
  VCategory: IMarkCategory;
  VMarksSubset: IMarksSubset;
begin
  for K := 0 to ACategoryList.Count - 1 do begin
    VCategory := IMarkCategory(Pointer(ACategoryList.Items[K]));
    VMarksSubset := AMarksSet.GetSubsetByCategory(VCategory);
    AddFolder(doc, VCategory.name, VMarksSubset);
  end;
end;

function TExportMarks2KML.AddFolder(
  AParentNode: IXMLNode;
  ACategoryNamePostfix: string;
  AMarksSubset: IMarksSubset
): boolean;
  function FindNodeWithText(AParent: iXMLNode; const ACategoryNameElement: string): IXMLNode;
  var
    i: Integer;
    tmpNode: IXMLNode;
  begin
    if AParent.HasChildNodes then begin
      for i:=0 to AParent.ChildNodes.Count-1 do begin
        tmpNode :=AParent.ChildNodes.Get(i);
        if (tmpNode.NodeName='Folder')and(tmpNode.ChildValues['name'] = ACategoryNameElement) then begin
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
  if ACategoryNamePostfix='' then begin
    Result := AddMarks(AMarksSubset, AParentNode);
  end else begin
    VDelimiterPos:=Pos('\', ACategoryNamePostfix);
    if VDelimiterPos > 0 then begin
      VCatgoryNamePrefix := Copy(ACategoryNamePostfix, 1, VDelimiterPos - 1);
      VCatgoryNamePostfix := Copy(ACategoryNamePostfix, VDelimiterPos + 1, Length(ACategoryNamePostfix))
    end else begin
      VCatgoryNamePrefix:=ACategoryNamePostfix;
      VCatgoryNamePostfix := '';
    end;
    VCreatedNode := False;
    if VCatgoryNamePrefix = '' then begin
      VNode := AParentNode;
    end else begin
      VNode := FindNodeWithText(AParentNode, VCatgoryNamePrefix);
      if (VNode = nil) then begin
        VNode := AParentNode.AddChild('Folder');
        VNode.ChildValues['name']:=VCatgoryNamePrefix;
        VNode.ChildValues['open']:=1;
        with VNode.AddChild('Style').AddChild('ListStyle') do begin
          ChildValues['listItemType']:='check';
          ChildValues['bgColor']:='00ffffff';
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
  AMarksSubset:IMarksSubset;
  inNode:iXMLNode
): Boolean;
var
  Mark:IMark;
  VEnumMarks:IEnumUnknown;
  i:integer;
begin
  Result := False;
  VEnumMarks := AMarksSubset.GetEnum;
  while (VEnumMarks.Next(1, Mark, @i) = S_OK) do begin
    AddMark(Mark,inNode);
    Result := True;
  end;
end;

procedure TExportMarks2KML.AddMark(Mark:IMark;inNode:iXMLNode);
var
  j,width:integer;
  currNode:IXMLNode;
  coordinates:string;
  VFileName: string;
var
  VMarkPoint: IMarkPoint;
  VMarkLine: IMarkLine;
  VMarkPoly: IMarkPoly;
begin
  currNode:=inNode.AddChild('Placemark');
  currNode.ChildValues['name']:=Mark.name;
  currNode.ChildValues['description']:=Mark.Desc;
  if Supports(Mark, IMarkPoint, VMarkPoint) then begin
    with currNode.AddChild('Style') do begin
      with AddChild('LabelStyle') do begin
        ChildValues['color']:=Color32toKMLColor(VMarkPoint.TextColor);
        ChildValues['scale']:=R2StrPoint(VMarkPoint.FontSize/14);
      end;
      if VMarkPoint.Pic <> nil then begin
        with AddChild('IconStyle') do begin
          VFileName := SaveMarkIcon(VMarkPoint);
          width:=VMarkPoint.Pic.GetMarker.BitmapSize.X;
          ChildValues['scale']:=R2StrPoint(VMarkPoint.MarkerSize/width);
          with AddChild('Icon') do begin
            ChildValues['href']:=VFileName;
          end;
          with AddChild('hotSpot') do begin
            Attributes['x']:='0.5';
            Attributes['y']:=0;
            Attributes['xunits']:='fraction';
            Attributes['yunits']:='fraction';
          end;
        end;
      end;
    end;
    currNode:=currNode.AddChild('Point');
    currNode.ChildValues['extrude']:=1;
    coordinates:=coordinates+R2StrPoint(VMarkPoint.Point.X)+','+R2StrPoint(VMarkPoint.Point.Y)+',0 ';
    currNode.ChildValues['coordinates']:=coordinates;
  end else if Supports(Mark, IMarkLine, VMarkLine) then begin
    with currNode.AddChild('Style') do begin
      with AddChild('LineStyle') do begin
        ChildValues['color']:=Color32toKMLColor(VMarkLine.LineColor);
        ChildValues['width']:=R2StrPoint(VMarkLine.LineWidth);
      end;
    end;
    currNode:=currNode.AddChild('LineString');
    currNode.ChildValues['extrude']:=1;
    coordinates:='';
    for j := 0 to length(VMarkLine.Points) - 1 do begin
      coordinates:=coordinates+R2StrPoint(VMarkLine.Points[j].X)+','+R2StrPoint(VMarkLine.Points[j].Y)+',0 ';
    end;
    currNode.ChildValues['coordinates']:=coordinates;
  end else if Supports(Mark, IMarkPoly, VMarkPoly) then begin
    with currNode.AddChild('Style') do begin
      with AddChild('LineStyle') do begin
        ChildValues['color']:=Color32toKMLColor(VMarkPoly.BorderColor);
        ChildValues['width']:=R2StrPoint(VMarkPoly.LineWidth);
      end;
      with AddChild('PolyStyle') do begin
        ChildValues['color']:=Color32toKMLColor(VMarkPoly.FillColor);
        ChildValues['fill']:=1;
      end;
    end;
    currNode:=currNode.AddChild('Polygon').AddChild('outerBoundaryIs').AddChild('LinearRing');
    currNode.ChildValues['extrude']:=1;
    coordinates:='';
    for j := 0 to length(VMarkPoly.Points) - 1 do begin
      coordinates:=coordinates+R2StrPoint(VMarkPoly.Points[j].X)+','+R2StrPoint(VMarkPoly.Points[j].Y)+',0 ';
    end;
    currNode.ChildValues['coordinates']:=coordinates;
  end;
end;

function TExportMarks2KML.Color32toKMLColor(Color32:TColor32):string;
begin
  result:=IntToHex(AlphaComponent(Color32),2)+
          IntToHex(BlueComponent(Color32),2)+
          IntToHex(GreenComponent(Color32),2)+
          IntToHex(RedComponent(Color32),2);
end;

function TExportMarks2KML.SaveMarkIcon(Mark:IMarkPoint): string;
var
  VTargetPath: string;
  VTargetFullName: string;
  VPicName: string;
  VMemStream: TMemoryStream;
begin
  Result := '';
  if Mark.Pic <> nil then begin
    VMemStream := TMemoryStream.Create;
    try
      Mark.Pic.ExportToStream(VMemStream);
      VPicName := Mark.Pic.GetName;
      VTargetPath := 'files' + PathDelim;
      Result := VTargetPath  + VPicName;
      if inKMZ then begin
        Zip.AddStream(Result, VMemStream);
      end else begin
        VTargetPath := ExtractFilePath(filename) + VTargetPath;
        VTargetFullName := VTargetPath + VPicName;
        CreateDir(VTargetPath);
        VMemStream.SaveToFile(VTargetFullName);
      end;
    finally
      VMemStream.Free;
    end;
  end;
end;

end.


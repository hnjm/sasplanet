unit u_ThreadExportToZip;

interface

uses
  Windows,
  Forms,
  SysUtils,
  Classes,
  VCLZIp,
  GR32,
  i_ITileFileNameGenerator,
  UMapType,
  UGeoFun,
  UResStrings,
  t_GeoTypes,
  u_ThreadExportAbstract;

type
  TThreadExportToZip = class(TThreadExportAbstract)
  private
    FMapTypeArr: array of TMapType;
    FTileNameGen: ITileFileNameGenerator;

    FPathExport: string;
    FZip: TVCLZip;
  protected
    procedure ProcessRegion; override;
    procedure Terminate; override;
  public
    constructor Create(
      APath: string;
      APolygon: TExtendedPointArray;
      Azoomarr: array of boolean;
      Atypemaparr: array of TMapType;
      ATileNameGen: ITileFileNameGenerator
    );
    destructor Destroy; override;
  end;

implementation

uses
  u_GeoToStr;

procedure TThreadExportToZip.Terminate;
begin
  inherited;
  FZip.CancelTheOperation;
end;

constructor TThreadExportToZip.Create(
  APath: string;
  APolygon: TExtendedPointArray;
  Azoomarr: array of boolean;
  Atypemaparr: array of TMapType;
  ATileNameGen: ITileFileNameGenerator);
var
  i: integer;
begin
  inherited Create(APolygon, Azoomarr);
  FPathExport := APath;
  FTileNameGen := ATileNameGen;
  setlength(FMapTypeArr, length(Atypemaparr));
  for i := 1 to length(Atypemaparr) do begin
    FMapTypeArr[i - 1] := Atypemaparr[i - 1];
  end;
  FZip := TVCLZip.Create(nil);
end;

function RetDate(inDate: TDateTime): string;
var
  xYear, xMonth, xDay: word;
begin
  DecodeDate(inDate, xYear, xMonth, xDay);
  Result := inttostr(xDay) + '.' + inttostr(xMonth) + '.' + inttostr(xYear);
end;

destructor TThreadExportToZip.Destroy;
begin
  inherited;
  FZip.free;
end;

procedure TThreadExportToZip.ProcessRegion;
var
  p_x, p_y, i, j: integer;
  polyg: TPointArray;
  pathfrom, persl, perzoom, kti, datestr: string;
  VExt: string;
  VPath: string;
  VPixelRect: TRect;
  VLonLatRect: TExtendedRect;
  VTile: TPoint;
begin
    FTilesToProcess := 0;
    SetLength(polyg, length(FPolygLL));
    persl := '';
    kti := '';
    datestr := RetDate(now);
    for i := 0 to length(FMapTypeArr) - 1 do begin
      persl := persl + FMapTypeArr[i].GetShortFolderName + '_';
      perzoom := '';
      for j := 0 to 23 do begin
        if FZoomArr[j] then begin
          polyg := FMapTypeArr[i].GeoConvert.LonLatArray2PixelArray(FPolygLL, j);
          FTilesToProcess := FTilesToProcess + GetDwnlNum(VPixelRect.TopLeft, VPixelRect.BottomRight, Polyg, true);
          perzoom := perzoom + inttostr(j + 1) + '_';

          VLonLatRect := FMapTypeArr[i].GeoConvert.PixelRect2LonLatRect(VPixelRect, j);
          kti := RoundEx(VLonLatRect.Left, 4);
          kti := kti + '_' + RoundEx(VLonLatRect.Top, 4);
          kti := kti + '_' + RoundEx(VLonLatRect.Right, 4);
          kti := kti + '_' + RoundEx(VLonLatRect.Bottom, 4);
        end;
      end;
    end;
    persl := copy(persl, 1, length(persl) - 1);
    perzoom := copy(perzoom, 1, length(perzoom) - 1);
    ProgressFormUpdateCaption(
      SAS_STR_ExportTiles + ' ' + SAS_STR_CreateArhList,
      SAS_STR_AllSaves + ' ' + inttostr(FTilesToProcess) + ' ' + SAS_STR_Files
    );
    FZip.Recurse := False;
    FZip.StorePaths := true;
    FZip.PackLevel := 0; // ������� ������
    FZip.ZipName := FPathExport + 'SG-' + persl + '-' + perzoom + '-' + kti + '-' + datestr + '.ZIP';
    FTilesProcessed := 0;
    ProgressFormUpdateOnProgress;
    for i := 0 to 23 do //�� ��������
    begin
      if FZoomArr[i] then begin
        for j := 0 to length(FMapTypeArr) - 1 do //�� ����
        begin
          polyg := FMapTypeArr[j].GeoConvert.LonLatArray2PixelArray(FPolygLL, i);
          VExt := FMapTypeArr[j].TileFileExt;
          VPath := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(FPathExport) + FMapTypeArr[j].GetShortFolderName);
          GetDwnlNum(VPixelRect.TopLeft, VPixelRect.BottomRight, Polyg, false);
          p_x := VPixelRect.Left;
          while p_x < VPixelRect.Right do begin
            VTile.X := p_x shr 8;
            p_y := VPixelRect.Top;
            while p_y < VPixelRect.Bottom do begin
              VTile.Y := p_y shr 8;
              if IsCancel then begin
                exit;
              end;
              if not (RgnAndRgn(Polyg, p_x, p_y, false)) then begin
                inc(p_y, 256);
                CONTINUE;
              end;
              if FMapTypeArr[j].TileExists(VTile, i) then begin
//TODO: ����������� � ���������� �� �����. ����� ������������� �������, ��� ����� �������� �� � ������, � ����� ���������� ����������� � �����.
                pathfrom := FMapTypeArr[j].GetTileFileName(VTile, i);
                FZip.FilesList.Add(pathfrom);
              end;
              inc(FTilesProcessed);
              if FTilesProcessed mod 100 = 0 then begin
                ProgressFormUpdateOnProgress;
              end;
              inc(p_y, 256);
            end;
            inc(p_x, 256);
          end;
        end;
      end;
    end;
    ProgressFormUpdateCaption(
      SAS_STR_Pack + ' ' + 'SG-' + persl + '-' + perzoom + '-' + kti + '-' + datestr + '.ZIP',
      SAS_STR_AllSaves + ' ' + inttostr(FTilesToProcess) + ' ' + SAS_STR_Files
    );
    if FileExists(FZip.ZipName) then begin
      DeleteFile(FZip.ZipName);
    end;
    If FZip.Zip = 0 then begin
      Application.MessageBox(PChar(SAS_ERR_CreateArh), PChar(SAS_MSG_coution), 48);
    end;
    ProgressFormUpdateOnProgress;
    FTileNameGen := nil;
end;

end.

unit u_ThreadExportAbstract;

interface

uses
  Classes,
  Types,
  i_VectorItemLonLat,
  i_NotifierOperation,
  i_RegionProcessProgressInfo,
  u_ThreadRegionProcessAbstract,
  u_ResStrings;

type
  TThreadExportAbstract = class(TThreadRegionProcessAbstract)
  protected
    FZooms: TByteDynArray;
    procedure ProgressFormUpdateOnProgress(AProcessed, AToProcess: Int64);
    procedure ProcessRegion; override;
  public
    constructor Create(
      const ACancelNotifier: INotifierOperation;
      AOperationID: Integer;
      const AProgressInfo: IRegionProcessProgressInfoInternal;
      const APolygon: ILonLatPolygon;
      const AZooms: TByteDynArray;
      const ADebigThreadName: AnsiString = ''
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

constructor TThreadExportAbstract.Create(
  const ACancelNotifier: INotifierOperation;
  AOperationID: Integer;
  const AProgressInfo: IRegionProcessProgressInfoInternal;
  const APolygon: ILonLatPolygon;
  const AZooms: TByteDynArray;
  const ADebigThreadName: AnsiString = ''
);
var
  i: Integer;
  VZoomSourceCount: Integer;
  VZoomCount: Integer;
  VZoom: Byte;
begin
  inherited Create(
    ACancelNotifier,
    AOperationID,
    AProgressInfo,
    APolygon,
    ADebigThreadName
  );
  Assert(AZooms <> nil);
  VZoomSourceCount := Length(AZooms);
  Assert(VZoomSourceCount > 0);
  Assert(VZoomSourceCount <= 24);
  if VZoomSourceCount > 24 then begin
    VZoomSourceCount := 24;
  end;
  VZoomCount := 0;
  for i := 0 to VZoomSourceCount - 1 do begin
    VZoom := AZooms[i];
    if VZoom < 24 then begin
      if VZoomCount > 0 then begin
        if FZooms[VZoomCount - 1] < VZoom then begin
          SetLength(FZooms, VZoomCount + 1);
          FZooms[VZoomCount] := VZoom;
          Inc(VZoomCount);
        end;
      end else begin
        SetLength(FZooms, VZoomCount + 1);
        FZooms[VZoomCount] := VZoom;
        Inc(VZoomCount);
      end;
    end;
  end;
end;

destructor TThreadExportAbstract.Destroy;
begin
  inherited;
  FZooms := nil;
end;

procedure TThreadExportAbstract.ProcessRegion;
begin
  inherited;
  if Length(FZooms) <= 0 then begin
    raise Exception.Create('�� ������� �� ������ ����');
  end;
end;

procedure TThreadExportAbstract.ProgressFormUpdateOnProgress(AProcessed, AToProcess: Int64);
begin
  ProgressInfo.SetProcessedRatio(AProcessed / AToProcess);
  ProgressInfo.SetSecondLine(SAS_STR_Processed + ' ' + inttostr(AProcessed));
end;

end.

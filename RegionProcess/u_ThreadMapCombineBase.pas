unit u_ThreadMapCombineBase;

interface

uses
  Classes,
  Types,
  GR32,
  i_OperationNotifier,
  i_BitmapLayerProvider,
  i_RegionProcessProgressInfo,
  i_VectorItemLonLat,
  i_CoordConverter,
  i_MapCalibration,
  i_LocalCoordConverter,
  i_LocalCoordConverterFactorySimpe,
  u_ThreadRegionProcessAbstract;

type
  TThreadMapCombineBase = class(TThreadRegionProcessAbstract)
  private
    FTargetConverter: ILocalCoordConverter;
    FImageProvider: IBitmapLayerProvider;
    FConverterFactory: ILocalCoordConverterFactorySimpe;
    FMapCalibrationList: IMapCalibrationList;
    FSplitCount: TPoint;
    FFileName: string;
    FFilePath: string;
    FFileExt: string;
  protected
    procedure ProgressFormUpdateOnProgress(AProgress: Double);
    procedure SaveRect(
      AOperationID: Integer;
      const ACancelNotifier: IOperationNotifier;
      const AFileName: string;
      const AImageProvider: IBitmapLayerProvider;
      const ALocalConverter: ILocalCoordConverter;
      const AConverterFactory: ILocalCoordConverterFactorySimpe
    ); virtual; abstract;

    procedure ProcessRegion; override;
  public
    constructor Create(
      const ACancelNotifier: IOperationNotifier;
      AOperationID: Integer;
      const AProgressInfo: IRegionProcessProgressInfo;
      const APolygon: ILonLatPolygon;
      const ATargetConverter: ILocalCoordConverter;
      const AImageProvider: IBitmapLayerProvider;
      const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
      const AMapCalibrationList: IMapCalibrationList;
      const AFileName: string;
      const ASplitCount: TPoint
    );
  end;

implementation

uses
  SysUtils,
  u_ResStrings;

{ TMapCombineThreadBase }

constructor TThreadMapCombineBase.Create(
  const ACancelNotifier: IOperationNotifier;
  AOperationID: Integer;
  const AProgressInfo: IRegionProcessProgressInfo;
  const APolygon: ILonLatPolygon;
  const ATargetConverter: ILocalCoordConverter;
  const AImageProvider: IBitmapLayerProvider;
  const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
  const AMapCalibrationList: IMapCalibrationList;
  const AFileName: string;
  const ASplitCount: TPoint
);
begin
  inherited Create(
    ACancelNotifier,
    AOperationID,
    AProgressInfo,
    APolygon
  );
  FTargetConverter := ATargetConverter;
  FImageProvider := AImageProvider;
  FSplitCount := ASplitCount;
  FFilePath := ExtractFilePath(AFileName);
  FFileExt := ExtractFileExt(AFileName);
  FFileName := ChangeFileExt(ExtractFileName(AFileName), '');
  FMapCalibrationList := AMapCalibrationList;
  FConverterFactory := ALocalConverterFactory;
end;

procedure TThreadMapCombineBase.ProgressFormUpdateOnProgress(AProgress: Double);
begin
  ProgressInfo.Processed := AProgress;
  ProgressInfo.SecondLine := SAS_STR_Processed + ': ' + IntToStr(Trunc(AProgress * 100)) + '%';
end;


procedure TThreadMapCombineBase.ProcessRegion;
var
  i, j, pti: integer;
  VProcessTiles: Int64;
  VTileRect: TRect;
  VCurrentPieceConverter: ILocalCoordConverter;
  VMapRect: TRect;
  VMapSize: TPoint;
  VCurrentPieceRect: TRect;
  VMapPieceSize: TPoint;
  VSizeInTile: TPoint;
  VCurrentFileName: string;
begin
  inherited;
  VMapSize := FTargetConverter.GetLocalRectSize;
  VMapRect := FTargetConverter.GetRectInMapPixel;
  VTileRect :=
    FTargetConverter.GeoConverter.PixelRect2TileRect(
      VMapRect,
      FTargetConverter.Zoom
    );
  VSizeInTile.X := VTileRect.Right - VTileRect.Left;
  VSizeInTile.Y := VTileRect.Bottom - VTileRect.Top;
  VProcessTiles := VSizeInTile.X;
  VProcessTiles := VProcessTiles * VSizeInTile.Y;

  ProgressInfo.Caption :=
    Format(
      SAS_STR_MapCombineProgressCaption,
      [VMapSize.X, VMapSize.Y, FSplitCount.X * FSplitCount.Y]
    );
  ProgressInfo.FirstLine :=
    Format(
      SAS_STR_MapCombineProgressLine0,
      [VSizeInTile.X, VSizeInTile.Y, VProcessTiles]
    );
  ProgressFormUpdateOnProgress(0);
  VMapPieceSize.X := VMapSize.X div FSplitCount.X;
  VMapPieceSize.Y := VMapSize.Y div FSplitCount.Y;

  for i := 1 to FSplitCount.X do begin
    for j := 1 to FSplitCount.Y do begin
      VCurrentPieceRect.Left := VMapRect.Left + VMapPieceSize.X * (i - 1);
      VCurrentPieceRect.Right := VMapRect.Left + VMapPieceSize.X * i;
      VCurrentPieceRect.Top := VMapRect.Top + VMapPieceSize.Y * (j - 1);
      VCurrentPieceRect.Bottom := VMapRect.Top + VMapPieceSize.Y * j;

      VCurrentPieceConverter :=
        FConverterFactory.CreateConverterNoScale(
          Rect(0, 0, VMapPieceSize.X, VMapPieceSize.Y),
          FTargetConverter.Zoom,
          FTargetConverter.GeoConverter,
          VCurrentPieceRect.TopLeft
        );
      if (FSplitCount.X > 1) or (FSplitCount.Y > 1) then begin
        VCurrentFileName := FFilePath + FFileName + '_' + inttostr(i) + '-' + inttostr(j) + FFileExt;
      end else begin
        VCurrentFileName := FFilePath + FFileName + FFileExt;
      end;

      for pti := 0 to FMapCalibrationList.Count - 1 do begin
        try
          (FMapCalibrationList.get(pti) as IMapCalibration).SaveCalibrationInfo(
            VCurrentFileName,
            VCurrentPieceRect.TopLeft,
            VCurrentPieceRect.BottomRight,
            FTargetConverter.Zoom,
            FTargetConverter.GeoConverter
          );
        except
          //TODO: �������� ���� ���������� ��������� ������.
        end;
      end;
      try
        SaveRect(
          OperationID,
          CancelNotifier,
          VCurrentFileName,
          FImageProvider,
          VCurrentPieceConverter,
          FConverterFactory
        );
      except
        on E: Exception do begin
          if (FSplitCount.X > 1) or (FSplitCount.Y > 1) then begin
            raise Exception.CreateFmt(
              '%0:s'#13#10'Piece %1:dx%2:d',
              [E.message, i, j]
            );
          end else begin
            raise;
          end;
        end;
      end;
    end;
  end;
end;

end.

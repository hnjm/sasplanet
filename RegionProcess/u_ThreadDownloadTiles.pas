unit u_ThreadDownloadTiles;

interface

uses
  Windows,
  SyncObjs,
  Classes,
  t_GeoTypes,
  i_JclNotify,
  i_LogSimple,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_OperationNotifier,
  i_CoordConverterFactory,
  i_GlobalDownloadConfig,
  i_TileRequestResult,
  i_VectorItemLonLat,
  i_VectorItemProjected,
  i_VectorItmesFactory,
  i_DownloadInfoSimple,
  i_MapTypes,
  u_MapType,
  u_OperationNotifier;

type
  TThreadDownloadTiles = class(TThread)
  private
    FAppClosingNotifier: IJclNotifier;
    FMapType: TMapType;
    FDownloadInfo: IDownloadInfoSimple;
    FPolygLL: ILonLatPolygon;
    FPolyProjected: IProjectedPolygon;
    FSecondLoadTNE:boolean;
    FReplaceExistTiles: boolean;
    FCheckExistTileSize: boolean;
    FCheckExistTileDate: boolean;
    FDownloadConfig: IGlobalDownloadConfig;
    FCheckTileDate: TDateTime;
    FLastProcessedPoint: TPoint;
    FLastSuccessfulPoint: TPoint;

    FTotalInRegion: Int64;
    FProcessed: Int64;

    FElapsedTime: TDateTime;
    FStartTime: TDateTime;

    FLog: ILogSimple;
    FDownloadPause: Boolean;
    FFinished: Boolean;
    FZoom: Byte;
    FGotoNextTile: Boolean;
    FPausedSleepTime: Cardinal;
    FBanSleepTime: Cardinal;
    FProxyAuthErrorSleepTime: Cardinal;
    FDownloadErrorSleepTime: Cardinal;

    FRES_UserStop: string;
    FRES_ProcessedFile: string;
    FRES_LoadProcessRepl: string;
    FRES_LoadProcess: string;
    FRES_FileBeCreateTime: string;
    FRES_FileBeCreateLen: string;
    FRES_Authorization: string;
    FRES_WaitTime: string;
    FRES_Ban: string;
    FRES_BadMIME: string;
    FRES_TileNotExists: string;
    FRES_Noconnectionstointernet: string;
    FRES_FileExistsShort: string;
    FRES_ProcessFilesComplete: string;


    FCancelNotifier: IOperationNotifier;
    FCancelNotifierInternal: IOperationNotifierInternal;
    FFinishEvent: TEvent;
    FTileDownloadFinishListener: IJclListenerDisconnectable;

    FAppClosingListener: IJclListener;
    FResult: ITileRequestResult;

    procedure OnTileDownloadFinish(AMsg: IInterface);
    procedure OnAppClosing;
    procedure ProcessResult(AResult: ITileRequestResult);
    procedure SleepCancelable(ATime: Cardinal);

    procedure PrepareStrings;

    function GetElapsedTime: TDateTime;
    function GetDownloaded: Int64;
    function GetDownloadSize: Double;

    constructor CreateInternal(
      AAppClosingNotifier: IJclNotifier;
      ALog: ILogSimple;
      AMapType: TMapType;
      AZoom: byte;
      APolygon: ILonLatPolygon;
      APolyProjected: IProjectedPolygon;
      ADownloadConfig: IGlobalDownloadConfig;
      ADownloadInfo: IDownloadInfoSimple;
      AReplaceExistTiles: Boolean;
      ACheckExistTileSize: Boolean;
      ACheckExistTileDate: Boolean;
      AReplaceOlderDate: TDateTime;
      ASecondLoadTNE: Boolean;
      ALastProcessedPoint: TPoint;
      AProcessed: Int64;
      AElapsedTime: TDateTime
    );
  protected
    procedure Execute; override;
  public
    constructor Create(
      AAppClosingNotifier: IJclNotifier;
      ALog: ILogSimple;
      APolygon: ILonLatPolygon;
      APolyProjected: IProjectedPolygon;
      ADownloadConfig: IGlobalDownloadConfig;
      ADownloadInfo: IDownloadInfoSimple;
      Azamena: boolean;
      ACheckExistTileSize: boolean;
      Azdate: boolean;
      ASecondLoadTNE: boolean;
      AZoom: byte;
      Atypemap: TMapType;
      AReplaceOlderDate: TDateTime
    );
    constructor CreateFromSls(
      AAppClosingNotifier: IJclNotifier;
      AVectorItmesFactory: IVectorItmesFactory;
      ALog: ILogSimple;
      AFullMapsSet: IMapTypeSet;
      AProjectionFactory: IProjectionInfoFactory;
      ASLSSection: IConfigDataProvider;
      ADownloadConfig: IGlobalDownloadConfig;
      ADownloadInfo: IDownloadInfoSimple
    );
    destructor Destroy; override;

    procedure SaveToFile(ASLSSection: IConfigDataWriteProvider);
    procedure DownloadPause;
    procedure DownloadResume;
    property TotalInRegion: Int64 read FTotalInRegion;
    property Downloaded: Int64 read GetDownloaded;
    property Processed: Int64 read FProcessed;
    property DownloadSize: Double read GetDownloadSize;
    property ElapsedTime: TDateTime read GetElapsedTime;
    property StartTime: TDateTime read FStartTime;
    property Zoom: Byte read FZoom;
    property Finished: Boolean read FFinished;
    property MapType: TMapType read FMapType;
  end;

implementation

uses
  SysUtils,
  Types,
  i_DownloadResult,
  i_EnumDoublePoint,
  i_DoublePointsAggregator,
  i_TileRequest,
  i_TileIterator,
  i_TileDownloaderState,
  u_DownloadInfoSimple,
  u_TileIteratorByPolygon,
  u_DoublePointsAggregator,
  u_NotifyEventListener,
  u_ResStrings;

constructor TThreadDownloadTiles.CreateInternal(
  AAppClosingNotifier: IJclNotifier;
  ALog: ILogSimple;
  AMapType: TMapType;
  AZoom: byte;
  APolygon: ILonLatPolygon;
  APolyProjected: IProjectedPolygon;
  ADownloadConfig: IGlobalDownloadConfig;
  ADownloadInfo: IDownloadInfoSimple;
  AReplaceExistTiles, ACheckExistTileSize, ACheckExistTileDate: Boolean;
  AReplaceOlderDate: TDateTime; ASecondLoadTNE: Boolean;
  ALastProcessedPoint: TPoint;
  AProcessed: Int64;
  AElapsedTime: TDateTime
);
var
  VOperationNotifier: TOperationNotifier;
  VState: ITileDownloaderStateStatic;
begin
  inherited Create(False);

  FAppClosingNotifier := AAppClosingNotifier;
  FDownloadInfo := ADownloadInfo;
  FDownloadConfig := ADownloadConfig;
  FLog := ALog;

  FPausedSleepTime := 100;
  FBanSleepTime := 5000;
  FProxyAuthErrorSleepTime := 10000;
  FDownloadErrorSleepTime := 5000;
  Priority := tpLower;

  FReplaceExistTiles := AReplaceExistTiles;
  Fzoom := AZoom;
  FCheckExistTileSize := ACheckExistTileSize;
  FMapType := AMapType;
  FCheckTileDate := AReplaceOlderDate;
  FCheckExistTileDate := ACheckExistTileDate;
  FSecondLoadTNE := ASecondLoadTNE;
  FPolygLL := APolygon;
  FPolyProjected := APolyProjected;
  FProcessed := AProcessed;
  FElapsedTime := AElapsedTime;
  FLastProcessedPoint := ALastProcessedPoint;
  if Terminated then begin
    FFinished := true;
    Exit;
  end;
  if FMapType = nil then begin
    Terminate;
    FFinished := true;
    Exit;
  end;
  if not FMapType.Abilities.UseDownload then begin
    ALog.WriteText(Format('Download of map %s disabled by map params', [FMapType.GUIConfig.Name.Value]), 10);
    Terminate;
    FFinished := true;
    Exit;
  end;
  VState := FMapType.TileDownloadSubsystem.State.GetStatic;
  if not VState.Enabled then begin
    ALog.WriteText(Format('Download of map %s disabled. Reason: %s', [FMapType.GUIConfig.Name.Value, VState.DisableReason]), 10);
    Terminate;
    FFinished := true;
    Exit;
  end;
  if FPolygLL = nil then begin
    ALog.WriteText('Polygon does not exist', 10);
    Terminate;
    FFinished := true;
    Exit;
  end;
  if FPolygLL.Count < 1 then begin
    ALog.WriteText('Empty Polygon', 10);
    Terminate;
    FFinished := true;
    Exit;
  end;

  if FPolyProjected = nil then begin
    ALog.WriteText('Polygon does not exist', 10);
    Terminate;
    FFinished := true;
    Exit;
  end;
  if FPolyProjected.Count < 1 then begin
    ALog.WriteText('Empty Polygon', 10);
    Terminate;
    FFinished := true;
    Exit;
  end;

  PrepareStrings;

  VOperationNotifier := TOperationNotifier.Create;
  FCancelNotifierInternal := VOperationNotifier;
  FCancelNotifier := VOperationNotifier;
  FFinishEvent := TEvent.Create;

  FTileDownloadFinishListener := TNotifyEventListener.Create(Self.OnTileDownloadFinish);
  FAppClosingListener := TNotifyNoMmgEventListener.Create(Self.OnAppClosing);
  FAppClosingNotifier.Add(FAppClosingListener);
end;

constructor TThreadDownloadTiles.Create(
  AAppClosingNotifier: IJclNotifier;
  ALog: ILogSimple;
  APolygon: ILonLatPolygon;
  APolyProjected: IProjectedPolygon;
  ADownloadConfig: IGlobalDownloadConfig;
  ADownloadInfo: IDownloadInfoSimple;
  Azamena, ACheckExistTileSize, Azdate, ASecondLoadTNE: boolean;
  AZoom: byte;
  Atypemap: TMapType;
  AReplaceOlderDate: TDateTime
);
begin
  CreateInternal(
    AAppClosingNotifier,
    ALog,
    Atypemap,
    AZoom,
    APolygon,
    APolyProjected,
    ADownloadConfig,
    TDownloadInfoSimple.Create(ADownloadInfo),
    Azamena,
    ACheckExistTileSize,
    Azdate,
    AReplaceOlderDate,
    ASecondLoadTNE,
    Point(-1,-1),
    0,
    0
  );
end;

constructor TThreadDownloadTiles.CreateFromSls(
  AAppClosingNotifier: IJclNotifier;
  AVectorItmesFactory: IVectorItmesFactory;
  ALog: ILogSimple;
  AFullMapsSet: IMapTypeSet;
  AProjectionFactory: IProjectionInfoFactory;
  ASLSSection: IConfigDataProvider;
  ADownloadConfig: IGlobalDownloadConfig;
  ADownloadInfo: IDownloadInfoSimple
);
var
  i: integer;
  VGuids: string;
  VGuid: TGUID;
  VMap: IMapType;
  VZoom: Byte;
  VReplaceExistTiles: Boolean;
  VCheckExistTileSize: Boolean;
  VCheckExistTileDate: Boolean;
  VCheckTileDate: TDateTime;
  VProcessedTileCount: Int64;
  VProcessedSize: Int64;
  VProcessed: Int64;
  VSecondLoadTNE: Boolean;
  VLastProcessedPoint: TPoint;
  VPointsAggregator: IDoublePointsAggregator;
  VElapsedTime: TDateTime;
  VMapType: TMapType;
  VPoint: TDoublePoint;
  VValidPoint: Boolean;
  VPolygon: ILonLatPolygon;
  VProjectedPolygon: IProjectedPolygon;
begin
  VMapType := nil;
  VReplaceExistTiles := False;
  VCheckExistTileSize := False;
  VCheckExistTileDate := False;
  VCheckTileDate := Now;
  VSecondLoadTNE := False;
  VProcessed := 0;
  VElapsedTime := 0;
  VProcessedTileCount := 0;
  VProcessedSize := 0;
  try
    if ASLSSection = nil then begin
      ALog.WriteText('No SLS data', 10);
      Terminate;
      FFinished := true;
      Exit;
    end;
    VGuids := ASLSSection.ReadString('MapGUID','');
    if VGuids = '' then begin
      ALog.WriteText('Map GUID is empty', 10);
      Terminate;
      FFinished := true;
      Exit;
    end;
    VGuid := StringToGUID(VGuids);
    VZoom := ASLSSection.ReadInteger('zoom', 0);
    if VZoom > 0 then begin
      Dec(VZoom);
    end else begin
      ALog.WriteText('Unknown zoom', 10);
      Terminate;
      FFinished := true;
      Exit;
    end;
    VReplaceExistTiles := ASLSSection.ReadBool('zamena', VReplaceExistTiles);
    VCheckExistTileSize := ASLSSection.ReadBool('raz', VCheckExistTileSize);
    VCheckExistTileDate := ASLSSection.ReadBool('zdate', VCheckExistTileDate);
    VCheckTileDate := ASLSSection.ReadDate('FDate', VCheckTileDate);
    VProcessedTileCount := ASLSSection.ReadInteger('scachano', VProcessedTileCount);
    VProcessedSize := trunc(ASLSSection.ReadFloat('dwnb', 0)*1024);

    VProcessed := ASLSSection.ReadInteger('obrab', VProcessed);
    VSecondLoadTNE:=ASLSSection.ReadBool('SecondLoadTNE', VSecondLoadTNE);
    VElapsedTime := ASLSSection.ReadFloat('ElapsedTime', VProcessed);
    if ADownloadConfig.IsUseSessionLastSuccess then begin
      VLastProcessedPoint.X:=ASLSSection.ReadInteger('LastSuccessfulStartX',-1);
      VLastProcessedPoint.Y:=ASLSSection.ReadInteger('LastSuccessfulStartY',-1);
    end else begin
      VLastProcessedPoint.X:=ASLSSection.ReadInteger('StartX',-1);
      VLastProcessedPoint.Y:=ASLSSection.ReadInteger('StartY',-1);
    end;
    VPointsAggregator := TDoublePointsAggregator.Create;
    i:=1;
    repeat
      VPoint.X := ASLSSection.ReadFloat('LLPointX_'+inttostr(i),-10000);
      VPoint.Y := ASLSSection.ReadFloat('LLPointY_'+inttostr(i),-10000);
      VValidPoint := (Abs(VPoint.X) < 360) and (Abs(VPoint.Y) < 360);
      if VValidPoint then begin
        VPointsAggregator.Add(VPoint);
        inc(i);
      end;
    until not VValidPoint;
    if VPointsAggregator.Count > 0 then begin
      VPolygon := AVectorItmesFactory.CreateLonLatPolygon(VPointsAggregator.Points, VPointsAggregator.Count);
    end;

    VMap := AFullMapsSet.GetMapTypeByGUID(VGuid);
    if VMap = nil then begin
      ALog.WriteText(Format('Map with GUID = %s not found', [VGuids]), 10);
    end else begin
      VMapType := VMap.MapType;
      if not VMapType.GeoConvert.CheckZoom(VZoom) then begin
        ALog.WriteText('Unknown zoom', 10);
        Terminate;
        FFinished := true;
        Exit;
      end;
    end;

    if VPolygon.Count > 0 then begin
      VProjectedPolygon :=
        AVectorItmesFactory.CreateProjectedPolygonByLonLatPolygon(
          AProjectionFactory.GetByConverterAndZoom(
            VMapType.GeoConvert,
            VZoom
          ),
          VPolygon
        );
    end;
  finally
    CreateInternal(
      AAppClosingNotifier,
      ALog,
      VMapType,
      VZoom,
      VPolygon,
      VProjectedPolygon,
      ADownloadConfig,
      TDownloadInfoSimple.Create(ADownloadInfo, VProcessedTileCount, VProcessedSize),
      VReplaceExistTiles,
      VCheckExistTileSize,
      VCheckExistTileDate,
      VCheckTileDate,
      VSecondLoadTNE,
      VLastProcessedPoint,
      VProcessed,
      VElapsedTime
    );
  end;
end;

destructor TThreadDownloadTiles.Destroy;
begin
  if FCancelNotifierInternal <> nil then begin
    FCancelNotifierInternal.NextOperation;
    FCancelNotifierInternal := nil;
  end;
  if FTileDownloadFinishListener <> nil then begin
    FTileDownloadFinishListener.Disconnect;
    FTileDownloadFinishListener := nil;
  end;

  if FAppClosingNotifier <> nil then begin
    FAppClosingNotifier.Remove(FAppClosingListener);
  end;
  FAppClosingNotifier := nil;
  FAppClosingListener := nil;

  if FFinishEvent <> nil then begin
    FFinishEvent.SetEvent;
    FreeAndNil(FFinishEvent);
  end;

  FLog := nil;
  inherited;
end;

procedure TThreadDownloadTiles.SaveToFile(ASLSSection: IConfigDataWriteProvider);
var
  i:integer;
  VElapsedTime: TDateTime;
  VEnum: IEnumDoublePoint;
  VPoint: TDoublePoint;
begin
  ASLSSection.WriteString('MapGUID', GUIDToString(FMapType.Zmp.GUID));
  ASLSSection.WriteInteger('zoom', Fzoom + 1);
  ASLSSection.WriteBool('zamena', FReplaceExistTiles);
  ASLSSection.WriteBool('raz', FCheckExistTileSize);
  ASLSSection.WriteBool('zdate', FCheckExistTileDate);
  ASLSSection.WriteDate('FDate', FCheckTileDate);
  ASLSSection.WriteBool('SecondLoadTNE', FSecondLoadTNE);
  ASLSSection.WriteInteger('scachano', FDownloadInfo.TileCount);
  ASLSSection.WriteInteger('obrab', FProcessed);
  ASLSSection.WriteFloat('dwnb', FDownloadInfo.Size / 1024);
  ASLSSection.WriteInteger('StartX', FLastProcessedPoint.X);
  ASLSSection.WriteInteger('StartY', FLastProcessedPoint.Y);
  ASLSSection.WriteInteger('LastSuccessfulStartX', FLastSuccessfulPoint.X);
  ASLSSection.WriteInteger('LastSuccessfulStartY', FLastSuccessfulPoint.Y);
  VEnum := FPolygLL.GetEnum;
  i := 0;
  while VEnum.Next(VPoint) do begin
    ASLSSection.WriteFloat('LLPointX_'+inttostr(i), VPoint.x);
    ASLSSection.WriteFloat('LLPointY_'+inttostr(i), VPoint.y);
    Inc(i);
  end;
  if (FDownloadPause) then begin
    VElapsedTime := FElapsedTime;
  end else begin
    VElapsedTime := FElapsedTime + (Now - FStartTime);
  end;
  ASLSSection.WriteFloat('ElapsedTime', VElapsedTime);
end;

procedure TThreadDownloadTiles.SleepCancelable(ATime: Cardinal);
begin
  FFinishEvent.WaitFor(ATime);
end;

procedure TThreadDownloadTiles.Execute;
var
  VTileExists: boolean;
  VTile: TPoint;
  VTileIterator: ITileIterator;
  VOperationID: Integer;
  VRequest: ITileRequest;
begin
  Randomize;
  FStartTime := Now;
  VTileIterator := TTileIteratorByPolygon.Create(FPolyProjected);
//  if (FMapType.TileDownloaderConfig.IteratorSubRectSize.X=1)and
//     (FMapType.TileDownloaderConfig.IteratorSubRectSize.Y=1) then begin
//    VTileIterator := TTileIteratorStuped.Create(FPolyProjected);
//  end else begin
//    VTileIterator := TTileIteratorBySubRect.Create(FPolyProjected,
//                      FMapType.TileDownloaderConfig.IteratorSubRectSize);
//  end;
  try
    FTotalInRegion := VTileIterator.TilesTotal;
    FLastSuccessfulPoint := Point(-1,-1);
    if (FLastProcessedPoint.X >= 0) and (FLastProcessedPoint.Y >= 0)  then begin
      while VTileIterator.Next(VTile) do begin
        if Terminated then begin
          Break;;
        end;
        if (VTile.X = FLastProcessedPoint.X) and (VTile.Y = FLastProcessedPoint.Y) then begin
          Break;
        end;
      end;

    end;
    if not Terminated then begin
      while VTileIterator.Next(VTile) do begin
        if Terminated then begin
          Break;
        end;
        FGoToNextTile := false;
        while not FGoToNextTile do begin
          FFinishEvent.ResetEvent;
          if (FDownloadPause) then begin
            FElapsedTime := FElapsedTime + (Now - FStartTime);
            FLog.WriteText(FRES_UserStop, 10);
            While (FDownloadPause)and (not Terminated) do SleepCancelable(FPausedSleepTime);
            FStartTime := now;
          end;

          FLog.WriteText(Format(FRES_ProcessedFile, [FMapType.GetTileShowName(VTile, Fzoom)]), 0);
          VTileExists := FMapType.TileExists(VTile, Fzoom);
          if (FReplaceExistTiles) or not(VTileExists) then begin
            if VTileExists then begin
              FLog.WriteText(FRES_LoadProcessRepl, 0);
            end else begin
              FLog.WriteText(FRES_LoadProcess+'...', 0);
            end;
            if (FCheckExistTileDate)
              and (VTileExists)
              and (FMapType.TileLoadDate(VTile, Fzoom) >= FCheckTileDate) then
            begin
              FLog.WriteText(FRES_FileBeCreateTime, 0);
              FLastSuccessfulPoint := VTile;
              FLastProcessedPoint := VTile;
              FGoToNextTile := True;
            end else begin
              try
                if (not(FSecondLoadTNE))and(FMapType.TileNotExistsOnServer(VTile, Fzoom))and(FDownloadConfig.IsSaveTileNotExists) then begin
                  FLog.WriteText('(tne exists)', 0);
                  FLastProcessedPoint := VTile;
                  FLastSuccessfulPoint := VTile;
                  FGoToNextTile := True;
                end else begin
                  VOperationID := FCancelNotifier.CurrentOperation;
                  VRequest := FMapType.TileDownloadSubsystem.GetRequest(FCancelNotifier, VOperationID, VTile, FZoom, FCheckExistTileSize);
                  VRequest.FinishNotifier.Add(FTileDownloadFinishListener);
                  FMapType.TileDownloadSubsystem.Download(VRequest);
                  if Terminated then begin
                    Break;
                  end;
                  FFinishEvent.WaitFor(INFINITE);
                  if Terminated then begin
                    Break;
                  end;
                  ProcessResult(FResult);
                  if Terminated then begin
                    Break;
                  end;
                  FLastProcessedPoint := VTile;
                end;
              except
                on E: Exception do begin
                  FLog.WriteText(E.Message, 0);
                  FGoToNextTile := True;
                end;
              end;
            end;
          end else begin
            FLog.WriteText(FRES_FileExistsShort, 0);
            FGoToNextTile := True;
          end;
          if FGoToNextTile then begin
            inc(FProcessed);
          end;
          if Terminated then begin
            Break;
          end;
        end;
        if Terminated then begin
          Break;
        end;
      end;
    end;
  finally
    VTileIterator := nil;
  end;
  if not Terminated then begin
    FLog.WriteText(FRES_ProcessFilesComplete, 0);
    FFinished := true;
  end;
end;

procedure TThreadDownloadTiles.DownloadPause;
begin
  FDownloadPause := True;
end;

procedure TThreadDownloadTiles.DownloadResume;
begin
  FDownloadPause := False;
end;

function TThreadDownloadTiles.GetDownloaded: Int64;
begin
  Result := FDownloadInfo.TileCount;
end;

function TThreadDownloadTiles.GetDownloadSize: Double;
begin
  Result := FDownloadInfo.Size / 1024;
end;

function TThreadDownloadTiles.GetElapsedTime: TDateTime;
begin
  if FFinished or FDownloadPause then begin
    Result := FElapsedTime;
  end else begin
    Result := FElapsedTime + (Now - FStartTime);
  end;
end;

procedure TThreadDownloadTiles.OnAppClosing;
begin
  Terminate;
  FCancelNotifierInternal.NextOperation;
  FFinishEvent.SetEvent;
end;

procedure TThreadDownloadTiles.OnTileDownloadFinish(AMsg: IInterface);
var
  VResult: ITileRequestResult;
begin
  VResult := AMsg as ITileRequestResult;
  FResult := VResult;
  FFinishEvent.SetEvent;
end;

procedure TThreadDownloadTiles.PrepareStrings;
begin
  FRES_UserStop := SAS_STR_UserStop;
  FRES_ProcessedFile := SAS_STR_ProcessedFile;
  FRES_LoadProcessRepl := SAS_STR_LoadProcessRepl;
  FRES_LoadProcess := SAS_STR_LoadProcess;
  FRES_FileBeCreateTime := SAS_MSG_FileBeCreateTime;
  FRES_FileBeCreateLen := SAS_MSG_FileBeCreateLen;
  FRES_Authorization := SAS_ERR_Authorization;
  FRES_WaitTime := SAS_ERR_WaitTime;
  FRES_Ban := SAS_ERR_Ban;
  FRES_BadMIME := SAS_ERR_BadMIME;
  FRES_TileNotExists := SAS_ERR_TileNotExists;
  FRES_Noconnectionstointernet := SAS_ERR_Noconnectionstointernet;
  FRES_FileExistsShort := SAS_ERR_FileExistsShort;
  FRES_ProcessFilesComplete := SAS_MSG_ProcessFilesComplete;
end;

procedure TThreadDownloadTiles.ProcessResult(AResult: ITileRequestResult);
var
  VResultOk: IDownloadResultOk;
  VResultBadContentType: IDownloadResultBadContentType;
  VResultDownloadError: IDownloadResultError;
  VResultWithDownload: ITileRequestResultWithDownloadResult;
begin
  if Supports(AResult, ITileRequestResultWithDownloadResult, VResultWithDownload) then begin
    FFinishEvent.ResetEvent;
    if Supports(VResultWithDownload.DownloadResult, IDownloadResultOk, VResultOk) then begin
      FLastSuccessfulPoint := AResult.Request.Tile;
      if FDownloadInfo <> nil then begin
        FDownloadInfo.Add(1, VResultOk.Size);
      end;
      FGoToNextTile := True;
      FLog.WriteText('(Ok!)', 0);
    end else if Supports(VResultWithDownload.DownloadResult, IDownloadResultNotNecessary) then begin
      FLastSuccessfulPoint := AResult.Request.Tile;
      FLog.WriteText(FRES_FileBeCreateLen, 0);
      FGoToNextTile := True;
    end else if Supports(VResultWithDownload.DownloadResult, IDownloadResultProxyError) then begin
      FLog.WriteText(FRES_Authorization + #13#10 + Format(FRES_WaitTime,[FProxyAuthErrorSleepTime div 1000]), 10);
      SleepCancelable(FProxyAuthErrorSleepTime);
      FGoToNextTile := false;
    end else if Supports(VResultWithDownload.DownloadResult, IDownloadResultBanned) then begin
      FLog.WriteText(FRES_Ban + #13#10 + Format(FRES_WaitTime, [FBanSleepTime div 1000]), 10);
      SleepCancelable(FBanSleepTime);
      FGoToNextTile := false;
    end else if Supports(VResultWithDownload.DownloadResult, IDownloadResultBadContentType, VResultBadContentType) then begin
      FLog.WriteText(Format(FRES_BadMIME, [VResultBadContentType.ContentType]), 1);
      FGoToNextTile := True;
    end else if Supports(VResultWithDownload.DownloadResult, IDownloadResultDataNotExists) then begin
      FLog.WriteText(FRES_TileNotExists, 1);
      FGoToNextTile := True;
    end else if Supports(VResultWithDownload.DownloadResult, IDownloadResultError, VResultDownloadError) then begin
      if Supports(VResultWithDownload.DownloadResult, IDownloadResultNoConnetctToServer) then begin
        FLog.WriteText(VResultDownloadError.ErrorText + #13#10 + Format(FRES_WaitTime, [FDownloadErrorSleepTime div 1000]), 10);
        SleepCancelable(FDownloadErrorSleepTime);
        FGoToNextTile := false;
      end else begin
        FLog.WriteText(FRES_Noconnectionstointernet + #13#10 + Format(FRES_WaitTime, [FDownloadErrorSleepTime div 1000]), 10);
        SleepCancelable(FDownloadErrorSleepTime);
        if FDownloadConfig.IsGoNextTileIfDownloadError then begin
          FGoToNextTile := True;
        end else begin
          FGoToNextTile := False;
        end;
      end;
    end;
  end else begin
    if Supports(AResult, ITileRequestResultCanceled) then begin
      FGotoNextTile := False;
    end else begin
      FGotoNextTile := True;
    end;
  end;
end;

end.


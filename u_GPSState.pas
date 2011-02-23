unit u_GPSState;

interface

uses
  SysUtils,
  i_IJclListenerNotifierLinksList,
  i_IDatum,
  i_IGPSRecorder,
  i_IConfigDataProvider,
  i_IConfigDataWriteProvider,
  i_IGPSConfig,
  i_IGPSModule,
  i_IGPSModuleByCOM,
  i_IGPSModuleByCOMPortSettings,
  u_GPSModuleByCOMPortSettings,
  u_GPSLogWriterToPlt;

type
  TGPSpar = class
  private
    FConfig: IGPSConfig;
    FDatum: IDatum;
    FLogPath: string;
    FGPSRecorder: IGPSRecorder;
    FGPSModule: IGPSModule;
    FGPSModuleByCOM: IGPSModuleByCOM;
    FLinksList: IJclListenerNotifierLinksList;

    FLogWriter: TPltLogWriter;

    procedure OnGpsConnect(Sender: TObject);
    procedure OnGpsDataReceive(Sender: TObject);
    procedure OnGpsDisconnect(Sender: TObject);
    procedure OnConfigChange(Sender: TObject);
  public
    speed: Double;
    len: Double;
    sspeed: Double;
    allspeed: Double;
    sspeednumentr: integer;
    altitude: Double;
    maxspeed: Double;
    azimut: Double;
    Odometr: Double;
    Odometr2: Double;

    constructor Create(ALogPath: string; AConfig: IGPSConfig);
    destructor Destroy; override;
    procedure LoadConfig(AConfigProvider: IConfigDataProvider); virtual;
    procedure StartThreads; virtual;
    procedure SendTerminateToThreads; virtual;
    procedure SaveConfig(AConfigProvider: IConfigDataWriteProvider); virtual;

    property GPSRecorder: IGPSRecorder read FGPSRecorder;
    property GPSModule: IGPSModule read FGPSModule;
  end;

implementation

uses
  t_GeoTypes,
  i_GPS,
  u_JclListenerNotifierLinksList,
  u_NotifyEventListener,
  u_Datum,
  u_GPSModuleByZylGPS,
  u_GPSRecorderStuped;

constructor TGPSpar.Create(ALogPath: string; AConfig: IGPSConfig);
begin
  FConfig := AConfig;
  FDatum := TDatum.Create(3395, 6378137, 6356752);
  FLogPath := ALogPath;
  FLogWriter := TPltLogWriter.Create(FLogPath);
  FGPSModuleByCOM := TGPSModuleByZylGPS.Create;
  FGPSModule := FGPSModuleByCOM;
  FGPSRecorder := TGPSRecorderStuped.Create(FGPSModule);
  FLinksList := TJclListenerNotifierLinksList.Create;

  FLinksList.Add(
    TNotifyEventListener.Create(Self.OnGpsConnect),
    FGPSModule.ConnectedNotifier
  );
  FLinksList.Add(
    TNotifyEventListener.Create(Self.OnGpsDataReceive),
    FGPSModule.DataReciveNotifier
  );
  FLinksList.Add(
    TNotifyEventListener.Create(Self.OnGpsDisconnect),
    FGPSModule.DisconnectedNotifier
  );

  FLinksList.Add(
    TNotifyEventListener.Create(Self.OnConfigChange),
    FConfig.GetChangeNotifier
  );

  Odometr := 0;
  Odometr2 := 0;
end;

destructor TGPSpar.Destroy;
begin
  FLinksList := nil;
  FGPSRecorder := nil;
  FGPSModule := nil;
  FreeAndNil(FLogWriter);
  inherited;
end;

procedure TGPSpar.LoadConfig(AConfigProvider: IConfigDataProvider);
var
  VConfigProvider: IConfigDataProvider;
begin
  VConfigProvider := AConfigProvider.GetSubItem('GPS');
  if VConfigProvider <> nil then begin
    Odometr := VConfigProvider.ReadFloat('Odometr', Odometr);
    Odometr2 := VConfigProvider.ReadFloat('Odometr2', Odometr2);
  end;
end;

procedure TGPSpar.OnConfigChange(Sender: TObject);
begin
  if FConfig.GPSEnabled then begin
    if FGPSModuleByCOM.IsReadyToConnect then begin
      FGPSModuleByCOM.Connect(FConfig.ModuleConfig.GetStatic);
    end;
  end else begin
    FGPSModuleByCOM.Disconnect;
  end;
end;

procedure TGPSpar.OnGpsConnect;
begin
  allspeed:=0;
  sspeed:=0;
  speed:=0;
  maxspeed:=0;
  sspeednumentr:=0;

  if FConfig.WriteLog then begin
    try
      FLogWriter.StartWrite;
    except
      FConfig.WriteLog := false;
    end;
  end;
end;

procedure TGPSpar.OnGpsDataReceive;
var
  VPosition: IGPSPosition;
  VPointCurr: TDoublePoint;
  VPointPrev: TDoublePoint;
  VDistToPrev: Double;
begin
  VPosition := FGPSModule.Position;
  if FLogWriter.Started then begin
    FLogWriter.AddPoint(VPosition);
  end;
  VPointPrev := FGPSRecorder.GetLastPoint;
//  FGPSRecorder.AddPoint(VPosition);

  if (VPosition.IsFix=0) then exit;
  VPointCurr := VPosition.Position;
  if (VPointCurr.x<>0)or(VPointCurr.y<>0) then begin
    speed:=VPosition.Speed_KMH;
    if maxspeed < speed then begin
      maxspeed:=speed;
    end;
    inc(sspeednumentr);
    allspeed:=allspeed+speed;
    sspeed:=allspeed/sspeednumentr;
    altitude:=VPosition.Altitude;
    if (VPointPrev.x<>0)or(VPointPrev.y<>0) then begin
      VDistToPrev := FDatum.CalcDist(VPointPrev, VPointCurr);
      len:=len+VDistToPrev;
      Odometr:=Odometr+VDistToPrev;
      Odometr2:=Odometr2+VDistToPrev;
      azimut:=VPosition.Heading;
    end;
  end;
end;

procedure TGPSpar.OnGpsDisconnect;
begin
  FConfig.GPSEnabled := False;
  try
    FLogWriter.CloseLog;
  except
  end;
end;

procedure TGPSpar.SaveConfig(AConfigProvider: IConfigDataWriteProvider);
var
  VConfigProvider: IConfigDataWriteProvider;
begin
  inherited;
  VConfigProvider := AConfigProvider.GetOrCreateSubItem('GPS');
  VConfigProvider.WriteFloat('Odometr', Odometr);
  VConfigProvider.WriteFloat('Odometr2', Odometr2);
end;

procedure TGPSpar.SendTerminateToThreads;
begin
  FLinksList.DeactivateLinks;
  FGPSModuleByCOM.Disconnect;
end;

procedure TGPSpar.StartThreads;
begin
  FLinksList.ActivateLinks;
  OnConfigChange(nil);
end;

end.


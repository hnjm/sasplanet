unit u_GPSState;

interface

uses
  SysUtils,
  Graphics,
  i_JclNotify,
  i_IGPSRecorder,
  i_IConfigDataProvider,
  i_IConfigDataWriteProvider,
  i_IGPSModule,
  i_IGPSModuleByCOMPortSettings,
  u_GPSModuleByCOMPortSettings,
  u_GPSLogWriterToPlt;

type
  TGPSpar = class
  private
    FGPSRecorder: IGPSRecorder;
    FSettings: IGPSModuleByCOMPortSettings;
    FSettingsObj: TGPSModuleByCOMPortSettings;
    FGPSModele: IGPSModule;
    GPS_enab: Boolean;

    FGpsConnectListener: IJclListener;
    FGpsDataReceiveListener: IJclListener;
    FGpsDisconnectListener: IJclListener;
    FLogWriter: TPltLogWriter;

    procedure OnGpsConnect;
    procedure OnGpsDataReceive;
    procedure OnGpsDisconnect;
  public
    speed: extended;
    len: extended;
    sspeed: extended;
    allspeed: extended;
    sspeednumentr: integer;
    altitude: extended;
    maxspeed: extended;
    nap: integer;
    azimut: extended;
    Odometr: extended;
    Odometr2: extended;
    SignalStrength: extended;

    //������ ��������� ����������� ��� GPS-���������
    GPS_ArrowSize: Integer;
    //���� ��������� ����������� ��� ���������
    GPS_ArrowColor: TColor;
    // ������� ������������ GPS �����
    GPS_TrackWidth: Integer;
    //������������ ���������� ������������� ����� �����
    GPS_NumTrackPoints: integer;
    //���������� GPS ����
    GPS_ShowPath: Boolean;
    //������������ ����� �� GPS �������
    GPS_MapMove: Boolean;
    GPS_MapMoveCentered: Boolean;
    //��������� GPS ���� � ����
    GPS_WriteLog: boolean;
    //��������/���������� ������ �������� ��� �����������/���������� GPS
    GPS_SensorsAutoShow: boolean;
    constructor Create();
    destructor Destroy; override;
    procedure LoadConfig(AConfigProvider: IConfigDataProvider); virtual;
    procedure StartThreads; virtual;
    procedure SendTerminateToThreads; virtual;
    procedure SaveConfig(AConfigProvider: IConfigDataWriteProvider); virtual;

    property GPSRecorder: IGPSRecorder read FGPSRecorder;
    property GPSSettings: TGPSModuleByCOMPortSettings read FSettingsObj;
    property GPSModele: IGPSModule read FGPSModele;
  end;

implementation

uses
  u_JclNotify,
  t_GeoTypes,
  i_GPS,
  i_ICoordConverter,
  u_GlobalState,
  u_GPSModuleByZylGPS,
  u_GPSRecorderStuped;

{ TGPSManagerListener }

type
  TGPSManagerListener = class(TJclBaseListener)
  private
    FGPSManager: TGPSpar;
  public
    constructor Create(AGPSManager: TGPSpar);
  end;

constructor TGPSManagerListener.Create(AGPSManager: TGPSpar);
begin
  FGPSManager := AGPSManager;
end;

{ TGPSConnect }

type
  TGPSConnect = class(TGPSManagerListener)
  protected
    procedure Notification(msg: IJclNotificationMessage); override;
  end;

procedure TGPSConnect.Notification(msg: IJclNotificationMessage);
begin
  inherited;
  FGPSManager.OnGpsConnect;
end;

{ TGPSDisconnect }

type
  TGPSDisconnect = class(TGPSManagerListener)
  protected
    procedure Notification(msg: IJclNotificationMessage); override;
  end;

procedure TGPSDisconnect.Notification(msg: IJclNotificationMessage);
begin
  inherited;
  FGPSManager.OnGpsDisconnect;
end;

{ TGPSDataReceive }

type
  TGPSDataReceive = class(TGPSManagerListener)
  protected
    procedure Notification(msg: IJclNotificationMessage); override;
  end;

procedure TGPSDataReceive.Notification(msg: IJclNotificationMessage);
begin
  inherited;
  FGPSManager.OnGpsDataReceive;
end;



constructor TGPSpar.Create;
begin
  FGPSRecorder := TGPSRecorderStuped.Create;
  FSettingsObj := TGPSModuleByCOMPortSettings.Create;
  FSettings := FSettingsObj;
  FGPSModele := TGPSModuleByZylGPS.Create(FSettings);

  FGpsConnectListener := TGPSConnect.Create(Self);
  FGPSModele.ConnectNotifier.Add(FGpsConnectListener);
  FGpsDataReceiveListener := TGPSDataReceive.Create(Self);
  FGPSModele.DataReciveNotifier.Add(FGpsDataReceiveListener);
  FGpsDisconnectListener := TGPSDisconnect.Create(Self);
  FGPSModele.DisconnectNotifier.Add(FGpsDisconnectListener);
end;

destructor TGPSpar.Destroy;
begin
  FGPSRecorder := nil;
  FSettingsObj := nil;
  FSettings := nil;
  FGPSModele.ConnectNotifier.Remove(FGpsConnectListener);
  FGPSModele.DataReciveNotifier.Remove(FGpsDataReceiveListener);
  FGPSModele.DisconnectNotifier.Remove(FGpsDisconnectListener);
  FGpsConnectListener := nil;
  FGpsDataReceiveListener := nil;
  FGpsDisconnectListener := nil;
  FGPSModele := nil;
  FreeAndNil(FLogWriter);
  inherited;
end;

procedure TGPSpar.LoadConfig(AConfigProvider: IConfigDataProvider);
var
  VConfigProvider: IConfigDataProvider;
begin
  FSettingsObj.LogPath := GState.TrackLogPath;
  FLogWriter := TPltLogWriter.Create(GState.TrackLogPath);
  VConfigProvider := AConfigProvider.GetSubItem('GPS');
  if VConfigProvider <> nil then begin
    GPS_enab := VConfigProvider.ReadBool('enbl', false);

    FSettingsObj.Port := VConfigProvider.ReadInteger('COM', FSettings.Port);
    FSettingsObj.BaudRate := VConfigProvider.ReadInteger('BaudRate', FSettings.BaudRate);
    FSettingsObj.ConnectionTimeout := VConfigProvider.ReadInteger('timeout', FSettings.ConnectionTimeout);
    FSettingsObj.Delay := VConfigProvider.ReadInteger('update', FSettings.Delay);
    FSettingsObj.NMEALog := VConfigProvider.ReadBool('NMEAlog', FSettings.NMEALog);

    GPS_ArrowSize := VConfigProvider.ReadInteger('SizeStr', 25);
    GPS_ArrowColor := VConfigProvider.ReadInteger('ColorStr', clRed);
    GPS_TrackWidth := VConfigProvider.ReadInteger('SizeTrack', 5);
    GPS_NumTrackPoints := VConfigProvider.ReadInteger('NumShowTrackPoints', 5000);
    GPS_WriteLog:=VConfigProvider.ReadBool('log',true);
    GPS_ShowPath:=VConfigProvider.ReadBool('path',true);
    GPS_MapMove:=VConfigProvider.ReadBool('go',true);
    GPS_MapMoveCentered:=VConfigProvider.ReadBool('goCentered',false);
    GPS_SensorsAutoShow:=VConfigProvider.ReadBool('SensorsAutoShow',true);

    Odometr:=VConfigProvider.ReadFloat('Odometr',0);
    Odometr2:=VConfigProvider.ReadFloat('Odometr2',0);
  end else begin
    GPS_enab := False;
    GPS_ArrowSize := 25;
    GPS_ArrowColor := clRed;
    GPS_TrackWidth := 5;
    GPS_NumTrackPoints := 5000;
    GPS_WriteLog:=true;
    GPS_ShowPath:=true;
    GPS_MapMove:=true;
    GPS_MapMoveCentered:=false;
    GPS_SensorsAutoShow:=true;
    Odometr:=0;
    Odometr2:=0;
  end;
end;

procedure TGPSpar.OnGpsConnect;
var
  VPath: string;
  VFileName: string;
begin
  allspeed:=0;
  sspeed:=0;
  speed:=0;
  maxspeed:=0;
  sspeednumentr:=0;

  if GPS_WriteLog then begin
    try
      FLogWriter.StartWrite;
    except
      GPS_WriteLog := false;
    end;
  end;
end;

procedure TGPSpar.OnGpsDataReceive;
var
  VPosition: IGPSPosition;
  VPointCurr: TExtendedPoint;
  VPointPrev: TExtendedPoint;
  VTrackPoint: TGPSTrackPoint;
  VDistToPrev: Extended;
  VConverter: ICoordConverter;
begin
  VPosition := GPSModele.Position;
  if (VPosition.IsFix=0) then exit;
  VPointCurr := VPosition.Position;
  if (VPointCurr.x<>0)or(VPointCurr.y<>0) then begin
    VPointPrev := GPSRecorder.GetLastPoint;
    VTrackPoint.Point := VPointCurr;
    VTrackPoint.Speed := VPosition.Speed_KMH;
    GPSRecorder.AddPoint(VTrackPoint);
    VConverter := GState.ViewState.GetCurrentCoordConverter;
    speed:=VTrackPoint.Speed;
    if maxspeed < speed then begin
      maxspeed:=speed;
    end;
    inc(sspeednumentr);
    allspeed:=allspeed+speed;
    sspeed:=allspeed/sspeednumentr;
    altitude:=VPosition.Altitude;
    if (VPointPrev.x<>0)or(VPointPrev.y<>0) then begin
      VDistToPrev := VConverter.CalcDist(VPointPrev, VPointCurr);
      len:=len+VDistToPrev;
      Odometr:=Odometr+VDistToPrev;
      Odometr2:=Odometr2+VDistToPrev;
      azimut:=VPosition.Heading;
    end;
  end;
  if FLogWriter.Started then begin
    FLogWriter.AddPoint(VPosition);
  end;
end;

procedure TGPSpar.OnGpsDisconnect;
begin
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
  VConfigProvider.WriteBool('enbl', GPS_enab);

  VConfigProvider.WriteInteger('COM', FSettings.Port);
  VConfigProvider.WriteInteger('BaudRate',FSettings.BaudRate);
  VConfigProvider.WriteInteger('timeout',FSettings.ConnectionTimeout);
  VConfigProvider.WriteInteger('update',FSettings.Delay);
  VConfigProvider.WriteBool('NMEALog',FSettings.NMEALog);

  VConfigProvider.WriteInteger('SizeStr',GPS_ArrowSize);
  VConfigProvider.WriteInteger('ColorStr',GPS_ArrowColor);
  VConfigProvider.WriteInteger('SizeTrack',GPS_TrackWidth);
  VConfigProvider.WriteInteger('NumShowTrackPoints',GPS_NumTrackPoints);
  VConfigProvider.WriteBool('path',GPS_ShowPath);
  VConfigProvider.WriteBool('go',GPS_MapMove);
  VConfigProvider.WriteBool('goCentered',GPS_MapMoveCentered);
  VConfigProvider.WriteBool('log',GPS_WriteLog);
  VConfigProvider.WriteBool('SensorsAutoShow',GPS_SensorsAutoShow);

  VConfigProvider.WriteFloat('Odometr', Odometr);
  VConfigProvider.WriteFloat('Odometr2', Odometr2);
end;

procedure TGPSpar.SendTerminateToThreads;
begin
  if FGPSModele.IsConnected then begin
    GPS_enab := True;
    FGPSModele.Disconnect;
  end else begin
    GPS_enab := False;
  end;
end;

procedure TGPSpar.StartThreads;
begin
  if GPS_enab then begin
    FGPSModele.Connect;
  end;
end;

end.

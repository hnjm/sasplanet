unit u_LastSelectionInfoSaver;

interface

uses
  Classes,
  i_NotifierOperation,
  i_Listener,
  i_PathConfig,
  i_SimpleFlag,
  i_VectorItmesFactory,
  i_LastSelectionInfo,
  u_BackgroundTask;

type
  TLastSelectionInfoSaver = class(TBackgroundTask)
  private
    FLastSelection: ILastSelectionInfo;
    FFileName: IPathConfig;
    FVectorItmesFactory: IVectorItmesFactory;

    FListener: IListener;
    FNeedReadFlag: ISimpleFlag;
    FNeedWriteFlag: ISimpleFlag;
    procedure OnNeedSave;
    procedure ProcessSave(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation
    );
  public
    constructor Create(
      const AAppClosingNotifier: INotifierOneOperation;
      const AVectorItmesFactory: IVectorItmesFactory;
      const ALastSelection: ILastSelectionInfo;
      const AFileName: IPathConfig
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  IniFiles,
  i_ThreadConfig,
  i_VectorItemLonLat,
  i_ConfigDataWriteProvider,
  u_ThreadConfig,
  u_ConfigProviderHelpers,
  u_ListenerByEvent,
  u_SimpleFlagWithInterlock,
  u_ConfigDataWriteProviderByIniFile;

{ TLastSelectionInfoSaver }

constructor TLastSelectionInfoSaver.Create(
  const AAppClosingNotifier: INotifierOneOperation;
  const AVectorItmesFactory: IVectorItmesFactory;
  const ALastSelection: ILastSelectionInfo;
  const AFileName: IPathConfig
);
var
  VThreadConfig: IThreadConfig;
begin
  Assert(ALastSelection <> nil);
  Assert(AFileName <> nil);
  VThreadConfig := TThreadConfig.Create(tpIdle);
  inherited Create(AAppClosingNotifier, Self.ProcessSave, VThreadConfig, Self.ClassName);

  FVectorItmesFactory := AVectorItmesFactory;
  FLastSelection := ALastSelection;
  FFileName := AFileName;
  

  FNeedReadFlag := TSimpleFlagWithInterlock.Create;
  FNeedWriteFlag := TSimpleFlagWithInterlock.Create;
  
  FListener := TNotifyNoMmgEventListener.Create(Self.OnNeedSave);

  FLastSelection.ChangeNotifier.Add(FListener);
  FFileName.ChangeNotifier.Add(FListener);

  FNeedReadFlag.SetFlag;
  StartExecute;
end;

destructor TLastSelectionInfoSaver.Destroy;
begin
  if FLastSelection <> nil then begin
    FLastSelection.ChangeNotifier.Remove(FListener);
  end;
  FLastSelection := nil;

  if FFileName <> nil then begin
    FFileName.ChangeNotifier.Remove(FListener);
  end;
  FFileName := nil;

  FListener := nil;
  inherited;
end;

procedure TLastSelectionInfoSaver.OnNeedSave;
begin
  Self.StartExecute;  
  FNeedWriteFlag.SetFlag;
end;

procedure TLastSelectionInfoSaver.ProcessSave(AOperationID: Integer;
  const ACancelNotifier: INotifierOperation);
var
  VFileName: string;
  VPath: string;
  VZoom: Byte;
  VPolygon: ILonLatPolygon;
  VNeedRead: Boolean;
  VNeedWrite: Boolean;
  VIniFile: TMemIniFile;
  VProvider: IConfigDataWriteProvider;
begin
  if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
    Exit;
  end;
  VFileName := FFileName.FullPath;
  VNeedRead := FNeedReadFlag.CheckFlagAndReset;
  VNeedWrite := FNeedWriteFlag.CheckFlagAndReset;
  VZoom := 0;
  VPolygon := nil;
  if VNeedRead then begin
    if FileExists(VFileName) then begin
      try
        VIniFile := TMemIniFile.Create(VFileName);
        try
          VProvider := TConfigDataWriteProviderByIniFile.Create(VIniFile);
          VIniFile := nil;
          VProvider := VProvider.GetOrCreateSubItem('HIGHLIGHTING');
          VPolygon := ReadPolygon(VProvider, FVectorItmesFactory);
          if VPolygon.Count > 0 then begin
            VZoom := VProvider.Readinteger('Zoom', VZoom);
          end;
        finally
          VIniFile.Free;
        end;
      except
        VZoom := 0;
        VPolygon := nil;
      end;
      if VPolygon <> nil then begin
        FLastSelection.SetPolygon(VPolygon, VZoom);
      end;
    end;
  end;
  if VNeedWrite then begin
    FLastSelection.LockRead;
    try
      VZoom := FLastSelection.Zoom;
      VPolygon := FLastSelection.Polygon;
    finally
      FLastSelection.UnlockRead;
    end;
    VPath := ExtractFilePath(VFileName);
    if not ForceDirectories(VPath) then begin
      Exit;
    end;
    try
      VIniFile := TMemIniFile.Create(VFileName);
      try
        VProvider := TConfigDataWriteProviderByIniFile.Create(VIniFile);
        VIniFile := nil;
        VProvider := VProvider.GetOrCreateSubItem('HIGHLIGHTING');
        VProvider.WriteInteger('Zoom', VZoom);
        WritePolygon(VProvider, VPolygon);
      finally
        VIniFile.Free;
      end;
    except
    end;
  end;
end;

end.

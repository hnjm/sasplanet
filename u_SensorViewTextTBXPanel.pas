unit u_SensorViewTextTBXPanel;

interface

uses
  Windows,
  Classes,
  ImgList,
  SyncObjs,
  Buttons,
  TB2Item,
  TB2Dock,
  TBX,
  TBXControls,
  i_JclNotify,
  i_JclListenerNotifierLinksList,
  i_Sensor;

type
  TSensorViewTextTBXPanel = class(TInterfacedObject, ISensorView)
  private
    FSensor: ISensorText;
    FConfig: ISensorViewConfig;

    FOwner: TComponent;
    FDefaultDoc: TTBDock;
    FParentMenu: TTBCustomItem;
    FImages: TCustomImageList;
    FImageIndexReset: TImageIndex;

    FCS: TCriticalSection;
    FLinksList: IJclListenerNotifierLinksList;

    FBar: TTBXToolWindow;
    FpnlTop: TTBXAlignmentPanel;
    FlblCaption: TTBXLabel;
    FbtnReset: TTBXButton;
    FlblValue: TTBXLabel;

    FResetItem: TTBXItem;
    FVisibleItem: TTBXCustomItem;
    FVisibleItemWithReset: TTBXSubmenuItem;

    FTextChanged: Boolean;
    FLastText: string;

    function GuidToComponentName(APrefix: string; AGUID: TGUID): string;
    procedure CreatePanel;
    procedure CreateMenu;

    procedure UpdateControls;

    procedure OnBarVisibleChanged(Sender: TObject);
    procedure OnVisibleItemClick(Sender: TObject);
    procedure OnResetClick(Sender: TObject);
    procedure OnTimer(Sender: TObject);
    procedure OnConfigChange(Sender: TObject);
    procedure OnSensorChange(Sender: TObject);
    procedure OnSensorDataUpdate(Sender: TObject);
  protected
    function GetConfig: ISensorViewConfig;
    function GetSensor: ISensor;
  public
    constructor Create(
      ASensor: ISensorText;
      AConfig: ISensorViewConfig;
      ATimerNoifier: IJclNotifier;
      AOwner: TComponent;
      ADefaultDoc: TTBDock;
      AParentMenu: TTBCustomItem;
      AImages: TCustomImageList;
      AImageIndexReset: TImageIndex
    );
    destructor Destroy; override;
  end;

implementation

uses
  Graphics,
  Controls,
  SysUtils,
  u_JclNotify,
  u_JclListenerNotifierLinksList,
  u_NotifyEventListener,
  u_ResStrings;

constructor TSensorViewTextTBXPanel.Create(
  ASensor: ISensorText;
  AConfig: ISensorViewConfig;
  ATimerNoifier: IJclNotifier;
  AOwner: TComponent;
  ADefaultDoc: TTBDock;
  AParentMenu: TTBCustomItem;
  AImages: TCustomImageList;
  AImageIndexReset: TImageIndex
);
begin
  FSensor := ASensor;
  FConfig := AConfig;
  FOwner := AOwner;
  FDefaultDoc := ADefaultDoc;
  FParentMenu := AParentMenu;
  FImages := AImages;
  FImageIndexReset := AImageIndexReset;

  FCS := TCriticalSection.Create;
  FLinksList := TJclListenerNotifierLinksList.Create;

  FLinksList.Add(
    TNotifyEventListener.Create(Self.OnConfigChange),
    FConfig.GetChangeNotifier
  );

  FLinksList.Add(
    TNotifyEventListener.Create(Self.OnTimer),
    ATimerNoifier
  );

  FLinksList.Add(
    TNotifyEventListener.Create(Self.OnSensorChange),
    FSensor.GetChangeNotifier
  );

  FLinksList.Add(
    TNotifyEventListener.Create(Self.OnSensorDataUpdate),
    FSensor.GetDataUpdateNotifier
  );

  CreatePanel;
  CreateMenu;
  UpdateControls;

  FLinksList.ActivateLinks;
  OnConfigChange(nil);
  OnSensorDataUpdate(nil);
end;

destructor TSensorViewTextTBXPanel.Destroy;
begin
  FLinksList.DeactivateLinks;
  FLinksList := nil;
  FreeAndNil(FBar);
  FConfig := nil;
  FSensor := nil;
  FreeAndNil(FCS);
  inherited;
end;

procedure TSensorViewTextTBXPanel.CreateMenu;
begin
  if FSensor.CanReset then begin
    FVisibleItemWithReset := TTBXSubmenuItem.Create(FBar);
    FVisibleItemWithReset.DropdownCombo := True;
    FVisibleItem := FVisibleItemWithReset;

    FResetItem := TTBXItem.Create(FBar);

    FResetItem.Name := GuidToComponentName('SensorReset_', FSensor.GetGUID);
    FResetItem.OnClick := Self.OnResetClick;
    FResetItem.Caption := '��������';
    FResetItem.Hint := '';
    FResetItem.Images := FImages;
    FResetItem.ImageIndex := FImageIndexReset;
    FVisibleItemWithReset.Add(FResetItem);
  end else begin
    FVisibleItem := TTBXItem.Create(FBar);
//    FVisibleItem.Name := '';
    FVisibleItemWithReset := nil;
  end;
  FVisibleItem.Name := GuidToComponentName('Sensor_', FSensor.GetGUID);
  FVisibleItem.AutoCheck := True;
  FVisibleItem.OnClick := Self.OnVisibleItemClick;
  FParentMenu.Add(FVisibleItem);
end;

procedure TSensorViewTextTBXPanel.CreatePanel;
begin
  FBar := TTBXToolWindow.Create(FOwner);
  FlblValue := TTBXLabel.Create(FBar);
  FpnlTop := TTBXAlignmentPanel.Create(FBar);
  FlblCaption := TTBXLabel.Create(FBar);

  FBar.Name := GuidToComponentName('Sensor_', FSensor.GetGUID);
  FBar.Align := alTop;
  FBar.ActivateParent := True;
  FBar.DefaultDock := FDefaultDoc;
  FBar.UseLastDock := False;
  FBar.ClientAreaHeight := 32;
  FBar.ClientAreaWidth := 150;
  FBar.DockRow := FDefaultDoc.GetHighestRow(False) + 1;
  FBar.DockPos := 0;
  FBar.Stretch := True;
  FBar.OnVisibleChanged := Self.OnBarVisibleChanged;
  FBar.Visible := True;
  FBar.Parent := FDefaultDoc;
  FBar.CurrentDock := FDefaultDoc;

//  FpnlTop.Name := '';
  FpnlTop.Parent := FBar;
  FpnlTop.Left := 0;
  FpnlTop.Top := 0;
  FpnlTop.Width := 150;
  FpnlTop.Height := 17;
  FpnlTop.Align := alTop;
//  FpnlTop.TabOrder := 1;

  if FSensor.CanReset then begin
    FbtnReset := TTBXButton.Create(FBar);
//    FbtnReset.Name := '';
    FbtnReset.Parent := FpnlTop;
    FbtnReset.Left := 133;
    FbtnReset.Top := 0;
    FbtnReset.Width := 17;
    FbtnReset.Height := 17;
    FbtnReset.Hint := '��������';
    FbtnReset.Align := alRight;
    FbtnReset.TabStop := False;
    FbtnReset.Images := FImages;
    FbtnReset.ImageIndex := FImageIndexReset;
    FbtnReset.ButtonStyle := bsFlat;

    FbtnReset.OnClick := Self.OnResetClick;
  end;

//  FlblCaption.Name := '';
  FlblCaption.Parent := FpnlTop;
  FlblCaption.Left := 0;
  FlblCaption.Top := 0;
  FlblCaption.Width := 133;
  FlblCaption.Height := 17;
  FlblCaption.Align := alClient;
  FlblCaption.Wrapping := twEndEllipsis;

//  FlblValue.Name := '';
  FlblValue.Parent := FBar;
  FlblValue.Left := 0;
  FlblValue.Top := 17;
  FlblValue.Width := 150;
  FlblValue.Height := 15;
  FlblValue.Align := alClient;
//  FlblValue.Font.Charset := RUSSIAN_CHARSET;
//  FlblValue.Font.Color := clWindowText;
  FlblValue.Font.Height := -16;
  FlblValue.Font.Name := 'Arial';
  FlblValue.Font.Style := [fsBold];
  FlblValue.ParentFont := False;
  FlblValue.Wrapping := twEndEllipsis;
  FlblValue.Caption := '';

end;

{ TSensorViewTextTBXPanel }

procedure TSensorViewTextTBXPanel.OnBarVisibleChanged(Sender: TObject);
begin
  FConfig.Visible := FBar.Visible;
end;

procedure TSensorViewTextTBXPanel.OnConfigChange(Sender: TObject);
var
  VVisible: Boolean;
begin
  VVisible := FConfig.Visible;
  FBar.Visible := VVisible;
  FVisibleItem.Checked := VVisible;
end;

function TSensorViewTextTBXPanel.GetConfig: ISensorViewConfig;
begin
  Result := FConfig;
end;

function TSensorViewTextTBXPanel.GetSensor: ISensor;
begin
  Result := FSensor;
end;

function TSensorViewTextTBXPanel.GuidToComponentName(APrefix: string;
  AGUID: TGUID): string;
var
  VGUIDStr: string;
begin
  VGUIDStr := GUIDToString(AGUID);
  VGUIDStr := StringReplace(VGUIDStr, '{', '', [rfReplaceAll]);
  VGUIDStr := StringReplace(VGUIDStr, '}', '', [rfReplaceAll]);
  VGUIDStr := StringReplace(VGUIDStr, '-', '_', [rfReplaceAll]);
  Result := APrefix + VGUIDStr;
end;

procedure TSensorViewTextTBXPanel.OnResetClick(Sender: TObject);
begin
  if FSensor.CanReset then begin
    if (MessageBox(0, pchar(SAS_MSG_youasurerefrsensor),pchar(SAS_MSG_coution),36)=IDYES) then begin
      FSensor.Reset;
      OnTimer(nil);
    end;
  end;
end;

procedure TSensorViewTextTBXPanel.OnSensorChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TSensorViewTextTBXPanel.OnSensorDataUpdate(Sender: TObject);
begin
  FCS.Acquire;
  try
    FTextChanged := True;
  finally
    FCS.Release;
  end;
end;

procedure TSensorViewTextTBXPanel.OnTimer(Sender: TObject);
var
  VText: string;
begin
  if FConfig.Visible then begin
    FCS.Acquire;
    try
      if FTextChanged then begin
        VText := FSensor.GetText;
        if FLastText <> VText then begin
          FLastText := VText;
          FlblValue.Caption := FLastText;
        end;
        FTextChanged := False;
      end;
    finally
      FCS.Release;
    end;
  end;
end;

procedure TSensorViewTextTBXPanel.OnVisibleItemClick(Sender: TObject);
begin
  FConfig.Visible := FVisibleItem.Checked;
end;

procedure TSensorViewTextTBXPanel.UpdateControls;
begin
  FVisibleItem.Caption := FSensor.GetMenuItemName;
  FBar.Caption := FSensor.GetCaption;
  FBar.Hint := FSensor.GetDescription;
  FlblCaption.Caption := FSensor.GetCaption;
end;

end.

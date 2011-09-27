{******************************************************************************}
{* SAS.������� (SAS.Planet)                                                   *}
{* Copyright (C) 2007-2011, ������ ��������� SAS.������� (SAS.Planet).        *}
{* ��� ��������� �������� ��������� ����������� ������������. �� ������       *}
{* �������������� �/��� �������������� � �������� �������� �����������       *}
{* ������������ �������� GNU, �������������� ������ ���������� ������������   *}
{* �����������, ������ 3. ��� ��������� ���������������� � �������, ��� ���   *}
{* ����� ��������, �� ��� ������ ��������, � ��� ����� ���������������        *}
{* �������� ��������� ��������� ��� ������� � �������� ��� ������˨�����      *}
{* ����������. �������� ����������� ������������ �������� GNU ������ 3, ���   *}
{* ��������� �������������� ����������. �� ������ ���� �������� �����         *}
{* ����������� ������������ �������� GNU ������ � ����������. � ������ �     *}
{* ����������, ���������� http://www.gnu.org/licenses/.                       *}
{*                                                                            *}
{* http://sasgis.ru/sasplanet                                                 *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_GlobalAppConfig;

interface

uses
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_GlobalAppConfig,
  u_ConfigDataElementBase;

type
  TGlobalAppConfig = class(TConfigDataElementBase, IGlobalAppConfig)
  private
    FIsShowIconInTray: Boolean;
    FIsSendStatistic: Boolean;
    FIsShowDebugInfo: Boolean;
  protected
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetIsShowIconInTray: Boolean;
    procedure SetIsShowIconInTray(AValue: Boolean);

    function GetIsSendStatistic: Boolean;
    procedure SetIsSendStatistic(AValue: Boolean);

    function GetIsShowDebugInfo: Boolean;
    procedure SetIsShowDebugInfo(AValue: Boolean);
  public
    constructor Create;
  end;

implementation

{ TGlobalAppConfig }

constructor TGlobalAppConfig.Create;
begin
  inherited;
  FIsShowIconInTray := False;

  {$IFDEF DEBUG}
    FIsShowDebugInfo := True;
  {$ELSE}
    FIsShowDebugInfo := False;
  {$ENDIF}
  FIsSendStatistic := True;
end;

procedure TGlobalAppConfig.DoReadConfig(AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FIsShowIconInTray := AConfigData.ReadBool('ShowIconInTray', FIsShowIconInTray);
    FIsShowDebugInfo := AConfigData.ReadBool('ShowDebugInfo', FIsShowDebugInfo);
    FIsSendStatistic := AConfigData.ReadBool('SendStatistic', FIsSendStatistic);
    SetChanged;
  end;
end;

procedure TGlobalAppConfig.DoWriteConfig(AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  AConfigData.WriteBool('ShowIconInTray', FIsShowIconInTray);
end;

function TGlobalAppConfig.GetIsSendStatistic: Boolean;
begin
  LockRead;
  try
    Result := FIsSendStatistic;
  finally
    UnlockRead;
  end;
end;

function TGlobalAppConfig.GetIsShowDebugInfo: Boolean;
begin
  LockRead;
  try
    Result := FIsShowDebugInfo;
  finally
    UnlockRead;
  end;
end;

function TGlobalAppConfig.GetIsShowIconInTray: Boolean;
begin
  LockRead;
  try
    Result := FIsShowIconInTray;
  finally
    UnlockRead;
  end;
end;

procedure TGlobalAppConfig.SetIsSendStatistic(AValue: Boolean);
begin
  LockWrite;
  try
    if FIsSendStatistic <> AValue then begin
      FIsSendStatistic := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TGlobalAppConfig.SetIsShowDebugInfo(AValue: Boolean);
begin
  LockWrite;
  try
    if FIsShowDebugInfo <> AValue then begin
      FIsShowDebugInfo := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TGlobalAppConfig.SetIsShowIconInTray(AValue: Boolean);
begin
  LockWrite;
  try
    if FIsShowIconInTray <> AValue then begin
      FIsShowIconInTray := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.

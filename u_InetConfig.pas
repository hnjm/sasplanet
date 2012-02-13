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

unit u_InetConfig;

interface

uses
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_ProxySettings,
  i_InetConfig,
  u_ConfigDataElementComplexBase;

type
  TInetConfig = class(TConfigDataElementComplexBase, IInetConfig)
  private
    FUserAgentString: string;
    FTimeOut: Cardinal;
    FProxyConfig: IProxyConfig;
    FSleepOnResetConnection: Cardinal;
    FDownloadTryCount: Integer;

    FStatic: IInetConfigStatic;
    function CreateStatic: IInetConfigStatic;
  protected
    procedure DoBeforeChangeNotify; override;
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetProxyConfig: IProxyConfig;

    function GetUserAgentString: string;
    procedure SetUserAgentString(AValue: string);

    function GetTimeOut: Cardinal;
    procedure SetTimeOut(AValue: Cardinal);

    function GetSleepOnResetConnection: Cardinal;
    procedure SetSleepOnResetConnection(AValue: Cardinal);

    function GetDownloadTryCount: Integer;
    procedure SetDownloadTryCount(AValue: Integer);

    function GetStatic: IInetConfigStatic;
  public
    constructor Create;
  end;

implementation

uses
  u_ConfigSaveLoadStrategyBasicProviderSubItem,
  u_InetConfigStatic,
  u_ProxyConfig;

{ TInetConfig }

constructor TInetConfig.Create;
begin
  inherited;
  FUserAgentString := 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727)';
  FTimeOut := 40000;
  FSleepOnResetConnection := 30000;
  FDownloadTryCount := 2;
  
  FProxyConfig := TProxyConfig.Create;
  Add(FProxyConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('Proxy'));

  FStatic := CreateStatic;
end;

function TInetConfig.CreateStatic: IInetConfigStatic;
begin
  Result :=
    TInetConfigStatic.Create(
      FProxyConfig.GetStatic,
      FUserAgentString,
      FTimeOut,
      FSleepOnResetConnection,
      FDownloadTryCount
    );
end;

procedure TInetConfig.DoBeforeChangeNotify;
begin
  inherited;
  LockWrite;
  try
    FStatic := CreateStatic;
  finally
    UnlockWrite;
  end;
end;

procedure TInetConfig.DoReadConfig(AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FUserAgentString := AConfigData.ReadString('UserAgentString', FUserAgentString);
    FTimeOut := AConfigData.ReadInteger('TimeOut', FTimeOut);
    SetDownloadTryCount(AConfigData.ReadInteger('DownloadTryCount', FDownloadTryCount));
    FSleepOnResetConnection := AConfigData.ReadInteger('SleepOnResetConnection', FSleepOnResetConnection);
    SetChanged;
  end;
end;

procedure TInetConfig.DoWriteConfig(AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  AConfigData.WriteString('UserAgentString', FUserAgentString);
  AConfigData.WriteInteger('TimeOut', FTimeOut);
  AConfigData.WriteInteger('DownloadTryCount', FDownloadTryCount);
  AConfigData.WriteInteger('SleepOnResetConnection', FSleepOnResetConnection);
end;

function TInetConfig.GetDownloadTryCount: Integer;
begin
  LockRead;
  try
    Result := FDownloadTryCount;
  finally
    UnlockRead;
  end;
end;

function TInetConfig.GetProxyConfig: IProxyConfig;
begin
  Result := FProxyConfig;
end;

function TInetConfig.GetSleepOnResetConnection: Cardinal;
begin
  LockRead;
  try
    Result := FSleepOnResetConnection;
  finally
    UnlockRead;
  end;
end;

function TInetConfig.GetStatic: IInetConfigStatic;
begin
  LockRead;
  try
    Result := FStatic;
  finally
    UnlockRead;
  end;
end;

function TInetConfig.GetTimeOut: Cardinal;
begin
  LockRead;
  try
    Result := FTimeOut;
  finally
    UnlockRead;
  end;
end;

function TInetConfig.GetUserAgentString: string;
begin
  LockRead;
  try
    Result := FUserAgentString;
  finally
    UnlockRead;
  end;
end;

procedure TInetConfig.SetDownloadTryCount(AValue: Integer);
begin
  if (AValue > 0) and (AValue < 100) then begin
    LockWrite;
    try
      if FDownloadTryCount <> AValue then begin
        FDownloadTryCount := AValue;
        SetChanged;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

procedure TInetConfig.SetSleepOnResetConnection(AValue: Cardinal);
begin
  LockWrite;
  try
    if FSleepOnResetConnection <> AValue then begin
      FSleepOnResetConnection := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TInetConfig.SetTimeOut(AValue: Cardinal);
begin
  LockWrite;
  try
    if FTimeOut <> AValue then begin
      FTimeOut := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TInetConfig.SetUserAgentString(AValue: string);
begin
  LockWrite;
  try
    if FUserAgentString <> AValue then begin
      FUserAgentString := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.

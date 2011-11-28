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

unit u_DownloadUIConfig;

interface

uses
  t_CommonTypes,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_DownloadUIConfig,
  u_ConfigDataElementBase;

type
  TDownloadUIConfig = class(TConfigDataElementBase, IDownloadUIConfig)
  private
    FUseDownload: TTileSource;
    FTilesOut: Integer;
    FTileMaxAgeInInternet: TDateTime;
  protected
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetUseDownload: TTileSource;
    procedure SetUseDownload(const AValue: TTileSource);

    function GetTileMaxAgeInInternet: TDateTime;
    procedure SetTileMaxAgeInInternet(const AValue: TDateTime);

    function GetTilesOut: Integer;
    procedure SetTilesOut(const AValue: Integer);
  public
    constructor Create;
  end;
implementation

{ TDownloadUIConfig }

constructor TDownloadUIConfig.Create;
begin
  inherited;
  FUseDownload := tsCacheInternet;
  FTilesOut := 0;
  FTileMaxAgeInInternet := 1/24/60;
end;

procedure TDownloadUIConfig.DoReadConfig(AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    case AConfigData.ReadInteger('TileSource', Integer(FUseDownload)) of
      0: FUseDownload := tsInternet;
      1: FUseDownload := tsCache;
      2: FUseDownload := tsCacheInternet;
    else
      FUseDownload := tsCache;
    end;
    FTileMaxAgeInInternet := AConfigData.ReadTime('TileMaxAgeInInternet', FTileMaxAgeInInternet);
    FTilesOut := AConfigData.ReadInteger('TilesOut', FTilesOut);
    SetChanged;
  end;
end;

procedure TDownloadUIConfig.DoWriteConfig(
  AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  case FUseDownload of
    tsInternet: AConfigData.WriteInteger('TileSource', 0);
    tsCache: AConfigData.WriteInteger('TileSource', 1);
    tsCacheInternet: AConfigData.WriteInteger('TileSource', 2);
  end;
  AConfigData.WriteTime('TileMaxAgeInInternet', FTileMaxAgeInInternet);
  AConfigData.WriteInteger('TilesOut', FTilesOut);
end;

function TDownloadUIConfig.GetTileMaxAgeInInternet: TDateTime;
begin
  LockRead;
  try
    Result := FTileMaxAgeInInternet;
  finally
    UnlockRead;
  end;
end;

function TDownloadUIConfig.GetTilesOut: Integer;
begin
  LockRead;
  try
    Result := FTilesOut;
  finally
    UnlockRead;
  end;
end;

function TDownloadUIConfig.GetUseDownload: TTileSource;
begin
  LockRead;
  try
    Result := FUseDownload;
  finally
    UnlockRead;
  end;
end;

procedure TDownloadUIConfig.SetTileMaxAgeInInternet(const AValue: TDateTime);
begin
  LockWrite;
  try
    if FTileMaxAgeInInternet <> AValue then begin
      FTileMaxAgeInInternet := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TDownloadUIConfig.SetTilesOut(const AValue: Integer);
begin
  LockWrite;
  try
    if FTilesOut <> AValue then begin
      FTilesOut := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TDownloadUIConfig.SetUseDownload(const AValue: TTileSource);
begin
  LockWrite;
  try
    if FUseDownload <> AValue then begin
      FUseDownload := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.

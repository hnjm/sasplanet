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

unit u_SelectionPolylineLayerConfig;

interface

uses
  GR32,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_PolygonLayerConfig,
  i_PolylineLayerConfig,
  i_SelectionPolylineLayerConfig,
  u_PolylineLayerConfig,
  u_ConfigDataElementBase,
  u_ConfigDataElementComplexBase;

type
  TSelectionPolylineShadowLayerConfig = class(TLineLayerConfig, ISelectionPolylineShadowLayerConfig)
  private
    FPolygoneRadius: Double;
    FFillColor: TColor32;
  protected
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetFillColor: TColor32;
    procedure SetFillColor(AValue: TColor32);

    function GetRadius: Double;
    procedure SetRadius(AValue: Double);
  public
    constructor Create;
  end;

  TSelectionPolylineLayerConfig = class(TConfigDataElementComplexBase, ISelectionPolylineLayerConfig)
  private
    FLineConfig: ILineLayerConfig;
    FPointsConfig: IPointsSetLayerConfig;
    FShadowConfig: ISelectionPolylineShadowLayerConfig;
  protected
    function GetLineConfig: ILineLayerConfig;
    function GetPointsConfig: IPointsSetLayerConfig;
    function GetShadowConfig: ISelectionPolylineShadowLayerConfig;
  public
    constructor Create;
  end;

implementation

uses
  u_ConfigProviderHelpers,
  u_PolygonLayerConfig,
  u_ConfigSaveLoadStrategyBasicProviderSubItem;

{ TSelectionPolylineLayerConfig }

constructor TSelectionPolylineLayerConfig.Create;
begin
  inherited;
  FLineConfig := TLineLayerConfig.Create;
  FLineConfig.LineColor := SetAlpha(clBlue32, 180);

  Add(
    FLineConfig,
    TConfigSaveLoadStrategyBasicProviderSubItem.Create('Line')
  );

  FShadowConfig := TSelectionPolylineShadowLayerConfig.Create;
  Add(
    FShadowConfig,
    TConfigSaveLoadStrategyBasicProviderSubItem.Create('Shadow')
  );

  FPointsConfig := TPointsSetLayerConfig.Create;
  Add(
    FPointsConfig,
    TConfigSaveLoadStrategyBasicProviderSubItem.Create('Line')
  );
end;

function TSelectionPolylineLayerConfig.GetLineConfig: ILineLayerConfig;
begin
  Result := FLineConfig;
end;

function TSelectionPolylineLayerConfig.GetPointsConfig: IPointsSetLayerConfig;
begin
  Result := FPointsConfig;
end;

function TSelectionPolylineLayerConfig.GetShadowConfig: ISelectionPolylineShadowLayerConfig;
begin
  Result := FShadowConfig;
end;

{ TLineLayerConfig }

constructor TSelectionPolylineShadowLayerConfig.Create;
begin
  inherited;
  FPolygoneRadius := 100;
  FFillColor := SetAlpha(clBlack32,150);
  SetLineWidth(1);
end;

procedure TSelectionPolylineShadowLayerConfig.DoReadConfig(AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FPolygoneRadius := AConfigData.ReadFloat('PolygoneRadius', FPolygoneRadius);
    FFillColor := ReadColor32(AConfigData, 'FillColor', FFillColor);
    SetChanged;
  end;
end;

procedure TSelectionPolylineShadowLayerConfig.DoWriteConfig(AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  AConfigData.WriteFloat('PolygoneRadius', FPolygoneRadius);
  WriteColor32(AConfigData, 'FillColor', FFillColor);
end;

function TSelectionPolylineShadowLayerConfig.GetFillColor: TColor32;
begin
  LockRead;
  try
    Result := FFillColor;
  finally
    UnlockRead;
  end;
end;

function TSelectionPolylineShadowLayerConfig.GetRadius: Double;
begin
  LockRead;
  try
    Result := FPolygoneRadius;
  finally
    UnlockRead;
  end;
end;

procedure TSelectionPolylineShadowLayerConfig.SetFillColor(AValue: TColor32);
begin
  LockWrite;
  try
    if FFillColor <> AValue then begin
      FFillColor := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TSelectionPolylineShadowLayerConfig.SetRadius(AValue: Double);
begin
  if AValue > 0 then begin
    LockWrite;
    try
      if FPolygoneRadius <> AValue then begin
        FPolygoneRadius := AValue;
        SetChanged;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

end.

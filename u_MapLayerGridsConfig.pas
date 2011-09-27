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

unit u_MapLayerGridsConfig;

interface

uses
  i_MapLayerGridsConfig,
  u_ConfigDataElementComplexBase;

type
  TMapLayerGridsConfig = class(TConfigDataElementComplexBase, IMapLayerGridsConfig)
  private
    FTileGrid: ITileGridConfig;
    FGenShtabGrid: IGenShtabGridConfig;
  protected
    function GetTileGrid: ITileGridConfig;
    function GetGenShtabGrid: IGenShtabGridConfig;
  public
    constructor Create;
  end;

implementation

uses
  u_ConfigSaveLoadStrategyBasicProviderSubItem,
  u_TileGridConfig,
  u_GenShtabGridConfig;

{ TMapLayerGridsConfig }

constructor TMapLayerGridsConfig.Create;
begin
  inherited;
  FTileGrid := TTileGridConfig.Create;
  Add(FTileGrid, TConfigSaveLoadStrategyBasicProviderSubItem.Create('TileGrid'));
  FGenShtabGrid := TGenShtabGridConfig.Create;
  Add(FGenShtabGrid, TConfigSaveLoadStrategyBasicProviderSubItem.Create('GenShtabGrid'));
end;

function TMapLayerGridsConfig.GetGenShtabGrid: IGenShtabGridConfig;
begin
  Result := FGenShtabGrid;
end;

function TMapLayerGridsConfig.GetTileGrid: ITileGridConfig;
begin
  Result := FTileGrid;
end;

end.

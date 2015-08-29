{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_ProjectionInfo;

interface

uses
  Types,
  t_Hash,
  t_GeoTypes,
  i_CoordConverter,
  i_ProjectionInfo,
  u_BaseInterfacedObject;

type
  TProjectionInfo = class(TBaseInterfacedObject, IProjectionInfo)
  private
    FHash: THashValue;
    FGeoConverter: ICoordConverter;
    FZoom: Byte;

    FTileRect: TRect;
    FPixelRect: TRect;
    FPixelsFloat: Double;
    FTileSplitCode: Integer;
  private
    function GetHash: THashValue;
    function GetZoom: Byte;
    function GetGeoConverter: ICoordConverter;
    function GetIsSameProjectionInfo(const AProjection: IProjectionInfo): Boolean;

    // ���������� ������������� ������ ���������� � �������� ����
    function GetTileRect: TRect;
    // ���������� ������������� �������� ���������� � �������� ����
    function GetPixelRect: TRect;

    // ���������� ����� ���������� �������� �� �������� ����
    function GetPixelsFloat: Double;

    // ���������� ��� ���� ������� �� ����� (�� �������, ����� �������� ������������ ������ ������)
    function GetTileSplitCode: Integer;

    // ����������� ���������� ������� �  ���������� ����� c���������� �������
    function PixelPos2TilePos(
      const APoint: TPoint;
      ARounding: TPointRounding
    ): TPoint;
    // ����������� ���������� ������� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function PixelPos2Relative(
      const APoint: TPoint
    ): TDoublePoint;
    // ����������� ���������� ������� � �������������� ����������
    function PixelPos2LonLat(
      const APoint: TPoint
    ): TDoublePoint;
    function PixelPos2TilePosFloat(
      const APoint: TPoint
    ): TDoublePoint;

    function PixelPosFloat2TilePosFloat(
      const APoint: TDoublePoint
    ): TDoublePoint;
    function PixelPosFloat2Relative(
      const APoint: TDoublePoint
    ): TDoublePoint;
    function PixelPosFloat2LonLat(
      const APoint: TDoublePoint
    ): TDoublePoint;

    // ��������� ������������� ������ ����������� ������������� ��������
    function PixelRect2TileRect(
      const ARect: TRect
    ): TRect;
    // ����������� ���������� �������������� �������� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function PixelRect2RelativeRect(
      const ARect: TRect
    ): TDoubleRect;
    // ����������� ���������� �������������� �������� � �������������� ���������� �� �����
    function PixelRect2LonLatRect(
      const ARect: TRect
    ): TDoubleRect;
    function PixelRect2TileRectFloat(
      const ARect: TRect
    ): TDoubleRect;

    function PixelRectFloat2TileRectFloat(
      const ARect: TDoubleRect
    ): TDoubleRect;
    function PixelRectFloat2RelativeRect(
      const ARect: TDoubleRect
    ): TDoubleRect;
    function PixelRectFloat2LonLatRect(
      const ARect: TDoubleRect
    ): TDoubleRect;

    // ����������� ������� ����� ��������� ���� � ���������� ������� ��� ������ �������� ����
    function TilePos2PixelPos(
      const APoint: TPoint
    ): TPoint;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2PixelRect(
      const APoint: TPoint
    ): TRect;
    function TilePos2PixelRectFloat(
      const APoint: TPoint
    ): TDoubleRect;
    // ����������� ���������� ����� � ������������� ���������� �� ����� (x/PixelsAtZoom)
    function TilePos2Relative(
      const APoint: TPoint
    ): TDoublePoint;
    // ����������� ������� ����� ��������� ���� � ������ �������� ��� ����� �� �������� ����
    function TilePos2RelativeRect(
      const APoint: TPoint
    ): TDoubleRect;
    // ����������� ���������� ����� � �������������� ����������
    function TilePos2LonLat(
      const APoint: TPoint
    ): TDoublePoint;
    // ����������� ������� ����� ��������� ���� � �������������� ���������� ��� �����
    function TilePos2LonLatRect(
      const APoint: TPoint
    ): TDoubleRect;

    function TilePosFloat2PixelPosFloat(
      const APoint: TDoublePoint
    ): TDoublePoint;
    function TilePosFloat2Relative(
      const APoint: TDoublePoint
    ): TDoublePoint;
    function TilePosFloat2LonLat(
      const APoint: TDoublePoint
    ): TDoublePoint;

    // ��������� ��������� �������� ������ �������������� ������
    function TileRect2PixelRect(
      const ARect: TRect
    ): TRect;
    // ��������� ������������� ��������� ������ �������������� ������
    function TileRect2RelativeRect(
      const ARect: TRect
    ): TDoubleRect;
    // ����������� ������������� ������ ��������� ���� � �������������� ���������� ��� �����
    function TileRect2LonLatRect(
      const ARect: TRect
    ): TDoubleRect;

    function TileRectFloat2PixelRectFloat(
      const ARect: TDoubleRect
    ): TDoubleRect;
    function TileRectFloat2RelativeRect(
      const ARect: TDoubleRect
    ): TDoubleRect;
    function TileRectFloat2LonLatRect(
      const ARect: TDoubleRect
    ): TDoubleRect;

    // ����������� ������������� ���������� �� ����� � ���������� �������
    function Relative2PixelPosFloat(
      const APoint: TDoublePoint
    ): TDoublePoint;
    // ����������� ������������� ���������� �� ����� � ���������� �����
    function Relative2TilePosFloat(
      const APoint: TDoublePoint
    ): TDoublePoint;

    // ����������� ������������� � �������������� ������������ � ������������� ��������
    function RelativeRect2PixelRectFloat(
      const ARect: TDoubleRect
    ): TDoubleRect;
    // ����������� ������������� � �������������� ������������ � ������������� ������
    function RelativeRect2TileRectFloat(
      const ARect: TDoubleRect
    ): TDoubleRect;

    // ����������� ������������� ���������� � ���������� ������� �� �������� ���� ������������ ������ ����������
    function LonLat2PixelPosFloat(
      const APoint: TDoublePoint
    ): TDoublePoint;
    // ����������� ������������� ���������� � ������� ����� �� �������� ���� ������������ ������ ����������
    function LonLat2TilePosFloat(
      const APoint: TDoublePoint
    ): TDoublePoint;

    function LonLatRect2PixelRectFloat(
      const ARect: TDoubleRect
    ): TDoubleRect;
    function LonLatRect2TileRectFloat(
      const ARect: TDoubleRect
    ): TDoubleRect;

    function GetTileSize(
      const APoint: TPoint
    ): TPoint;

    procedure ValidateTilePos(
      var APoint: TPoint;
      ACicleMap: Boolean
    );
    procedure ValidateTilePosStrict(
      var APoint: TPoint;
      ACicleMap: Boolean
    );
    procedure ValidateTileRect(
      var ARect: TRect
    );

    procedure ValidatePixelPos(
      var APoint: TPoint;
      ACicleMap: Boolean
    );
    procedure ValidatePixelPosFloat(
      var APoint: TDoublePoint;
      ACicleMap: Boolean
    );
    procedure ValidatePixelPosStrict(
      var APoint: TPoint;
      ACicleMap: Boolean
    );
    procedure ValidatePixelPosFloatStrict(
      var APoint: TDoublePoint;
      ACicleMap: Boolean
    );
    procedure ValidatePixelRect(
      var ARect: TRect
    );
    procedure ValidatePixelRectFloat(
      var ARect: TDoubleRect
    );

    function CheckTilePos(
      const APoint: TPoint
    ): boolean;
    function CheckTilePosStrict(
      const APoint: TPoint
    ): boolean;
    function CheckTileRect(
      const ARect: TRect
    ): boolean;

    function CheckPixelPos(
      const APoint: TPoint
    ): boolean;
    function CheckPixelPosFloat(
      const APoint: TDoublePoint
    ): boolean;
    function CheckPixelPosStrict(
      const APoint: TPoint
    ): boolean;
    function CheckPixelPosFloatStrict(
      const APoint: TDoublePoint
    ): boolean;
    function CheckPixelRect(
      const ARect: TRect
    ): boolean;
    function CheckPixelRectFloat(
      const ARect: TDoubleRect
    ): boolean;
  public
    constructor Create(
      const AHash: THashValue;
      const AGeoConverter: ICoordConverter;
      AZoom: Byte
    );
  end;

implementation

{ TProjectionInfo }

constructor TProjectionInfo.Create(
  const AHash: THashValue;
  const AGeoConverter: ICoordConverter;
  AZoom: Byte
);
begin
  Assert(Assigned(AGeoConverter));
  Assert(AGeoConverter.CheckZoom(AZoom));
  inherited Create;
  FHash := AHash;
  FGeoConverter := AGeoConverter;
  FZoom := AZoom;

  FTileRect := FGeoConverter.TileRectAtZoom(FZoom);
  FPixelRect := FGeoConverter.PixelRectAtZoom(FZoom);
  FPixelsFloat := FGeoConverter.PixelsAtZoomFloat(FZoom);
  FTileSplitCode := FGeoConverter.GetTileSplitCode;
end;

function TProjectionInfo.CheckPixelPos(const APoint: TPoint): boolean;
begin
  Result := FGeoConverter.CheckPixelPos(APoint, FZoom);
end;

function TProjectionInfo.CheckPixelPosFloat(
  const APoint: TDoublePoint
): boolean;
begin
  Result := FGeoConverter.CheckPixelPosFloat(APoint, FZoom);
end;

function TProjectionInfo.CheckPixelPosFloatStrict(
  const APoint: TDoublePoint
): boolean;
begin
  Result := FGeoConverter.CheckPixelPosFloatStrict(APoint, FZoom);
end;

function TProjectionInfo.CheckPixelPosStrict(const APoint: TPoint): boolean;
begin
  Result := FGeoConverter.CheckPixelPosStrict(APoint, FZoom);
end;

function TProjectionInfo.CheckPixelRect(const ARect: TRect): boolean;
begin
  Result := FGeoConverter.CheckPixelRect(ARect, FZoom);
end;

function TProjectionInfo.CheckPixelRectFloat(const ARect: TDoubleRect): boolean;
begin
  Result := FGeoConverter.CheckPixelRectFloat(ARect, FZoom);
end;

function TProjectionInfo.CheckTilePos(const APoint: TPoint): boolean;
begin
  Result := FGeoConverter.CheckTilePos(APoint, FZoom);
end;

function TProjectionInfo.CheckTilePosStrict(const APoint: TPoint): boolean;
begin
  Result := FGeoConverter.CheckTilePosStrict(APoint, FZoom);
end;

function TProjectionInfo.CheckTileRect(const ARect: TRect): boolean;
begin
  Result := FGeoConverter.CheckTileRect(ARect, FZoom);
end;

function TProjectionInfo.GetGeoConverter: ICoordConverter;
begin
  Result := FGeoConverter;
end;

function TProjectionInfo.GetHash: THashValue;
begin
  Result := FHash;
end;

function TProjectionInfo.GetIsSameProjectionInfo(
  const AProjection: IProjectionInfo): Boolean;
var
  VSelf: IProjectionInfo;
begin
  VSelf := Self;
  if VSelf = AProjection then begin
    Result := True;
  end else if AProjection = nil then begin
    Result := False;
  end else begin
    if (FHash <> 0) and (AProjection.Hash <> 0) and (FHash <> AProjection.Hash) then begin
      Result := False;
      Exit;
    end;
    Result := False;
    if FZoom = AProjection.Zoom then begin
      if FGeoConverter.IsSameConverter(AProjection.GeoConverter) then begin
        Result := True;
      end;
    end;
  end;
end;

function TProjectionInfo.GetPixelRect: TRect;
begin
  Result := FPixelRect;
end;

function TProjectionInfo.GetPixelsFloat: Double;
begin
  Result := FPixelsFloat;
end;

function TProjectionInfo.GetTileRect: TRect;
begin
  Result := FTileRect;
end;

function TProjectionInfo.GetTileSize(const APoint: TPoint): TPoint;
begin
  Result := FGeoConverter.GetTileSize(APoint, FZoom);
end;

function TProjectionInfo.GetTileSplitCode: Integer;
begin
  Result := FTileSplitCode;
end;

function TProjectionInfo.GetZoom: Byte;
begin
  Result := FZoom;
end;

function TProjectionInfo.LonLat2PixelPosFloat(
  const APoint: TDoublePoint
): TDoublePoint;
begin
  Result := FGeoConverter.LonLat2PixelPosFloat(APoint, FZoom);
end;

function TProjectionInfo.LonLat2TilePosFloat(
  const APoint: TDoublePoint
): TDoublePoint;
begin
  Result := FGeoConverter.LonLat2TilePosFloat(APoint, FZoom);
end;

function TProjectionInfo.LonLatRect2PixelRectFloat(
  const ARect: TDoubleRect
): TDoubleRect;
begin
  Result := FGeoConverter.LonLatRect2PixelRectFloat(ARect, FZoom);
end;

function TProjectionInfo.LonLatRect2TileRectFloat(
  const ARect: TDoubleRect
): TDoubleRect;
begin
  Result := FGeoConverter.LonLatRect2TileRectFloat(ARect, FZoom);
end;

function TProjectionInfo.PixelPos2LonLat(const APoint: TPoint): TDoublePoint;
begin
  Result := FGeoConverter.PixelPos2LonLat(APoint, FZoom);
end;

function TProjectionInfo.PixelPos2Relative(const APoint: TPoint): TDoublePoint;
begin
  Result := FGeoConverter.PixelPos2Relative(APoint, FZoom);
end;

function TProjectionInfo.PixelPos2TilePos(
  const APoint: TPoint;
  ARounding: TPointRounding
): TPoint;
begin
  Result := FGeoConverter.PixelPos2TilePos(APoint, FZoom, ARounding);
end;

function TProjectionInfo.PixelPos2TilePosFloat(
  const APoint: TPoint
): TDoublePoint;
begin
  Result := FGeoConverter.PixelPos2TilePosFloat(APoint, FZoom);
end;

function TProjectionInfo.PixelPosFloat2LonLat(
  const APoint: TDoublePoint
): TDoublePoint;
begin
  Result := FGeoConverter.PixelPosFloat2LonLat(APoint, FZoom);
end;

function TProjectionInfo.PixelPosFloat2Relative(
  const APoint: TDoublePoint
): TDoublePoint;
begin
  Result := FGeoConverter.PixelPosFloat2Relative(APoint, FZoom);
end;

function TProjectionInfo.PixelPosFloat2TilePosFloat(
  const APoint: TDoublePoint
): TDoublePoint;
begin
  Result := FGeoConverter.PixelPosFloat2TilePosFloat(APoint, FZoom);
end;

function TProjectionInfo.PixelRect2LonLatRect(const ARect: TRect): TDoubleRect;
begin
  Result := FGeoConverter.PixelRect2LonLatRect(ARect, FZoom);
end;

function TProjectionInfo.PixelRect2RelativeRect(
  const ARect: TRect
): TDoubleRect;
begin
  Result := FGeoConverter.PixelRect2RelativeRect(ARect, FZoom);
end;

function TProjectionInfo.PixelRect2TileRect(const ARect: TRect): TRect;
begin
  Result := FGeoConverter.PixelRect2TileRect(ARect, FZoom);
end;

function TProjectionInfo.PixelRect2TileRectFloat(
  const ARect: TRect
): TDoubleRect;
begin
  Result := FGeoConverter.PixelRect2TileRectFloat(ARect, FZoom);
end;

function TProjectionInfo.PixelRectFloat2LonLatRect(
  const ARect: TDoubleRect
): TDoubleRect;
begin
  Result := FGeoConverter.PixelRectFloat2LonLatRect(ARect, FZoom);
end;

function TProjectionInfo.PixelRectFloat2RelativeRect(
  const ARect: TDoubleRect
): TDoubleRect;
begin
  Result := FGeoConverter.PixelRectFloat2RelativeRect(ARect, FZoom);
end;

function TProjectionInfo.PixelRectFloat2TileRectFloat(
  const ARect: TDoubleRect
): TDoubleRect;
begin
  Result := FGeoConverter.PixelRectFloat2TileRectFloat(ARect, FZoom);
end;

function TProjectionInfo.Relative2PixelPosFloat(
  const APoint: TDoublePoint
): TDoublePoint;
begin
  Result := FGeoConverter.Relative2PixelPosFloat(APoint, FZoom);
end;

function TProjectionInfo.Relative2TilePosFloat(
  const APoint: TDoublePoint
): TDoublePoint;
begin
  Result := FGeoConverter.Relative2TilePosFloat(APoint, FZoom);
end;

function TProjectionInfo.RelativeRect2PixelRectFloat(
  const ARect: TDoubleRect
): TDoubleRect;
begin
  Result := FGeoConverter.RelativeRect2PixelRectFloat(ARect, FZoom);
end;

function TProjectionInfo.RelativeRect2TileRectFloat(
  const ARect: TDoubleRect
): TDoubleRect;
begin
  Result := FGeoConverter.RelativeRect2TileRectFloat(ARect, FZoom);
end;

function TProjectionInfo.TilePos2LonLat(const APoint: TPoint): TDoublePoint;
begin
  Result := FGeoConverter.TilePos2LonLat(APoint, FZoom);
end;

function TProjectionInfo.TilePos2LonLatRect(const APoint: TPoint): TDoubleRect;
begin
  Result := FGeoConverter.TilePos2LonLatRect(APoint, FZoom);
end;

function TProjectionInfo.TilePos2PixelPos(const APoint: TPoint): TPoint;
begin
  Result := FGeoConverter.TilePos2PixelPos(APoint, FZoom);
end;

function TProjectionInfo.TilePos2PixelRect(const APoint: TPoint): TRect;
begin
  Result := FGeoConverter.TilePos2PixelRect(APoint, FZoom);
end;

function TProjectionInfo.TilePos2PixelRectFloat(
  const APoint: TPoint
): TDoubleRect;
begin
  Result := FGeoConverter.TilePos2PixelRectFloat(APoint, FZoom);
end;

function TProjectionInfo.TilePos2Relative(const APoint: TPoint): TDoublePoint;
begin
  Result := FGeoConverter.TilePos2Relative(APoint, FZoom);
end;

function TProjectionInfo.TilePos2RelativeRect(
  const APoint: TPoint
): TDoubleRect;
begin
  Result := FGeoConverter.TilePos2RelativeRect(APoint, FZoom);
end;

function TProjectionInfo.TilePosFloat2LonLat(
  const APoint: TDoublePoint
): TDoublePoint;
begin
  Result := FGeoConverter.TilePosFloat2LonLat(APoint, FZoom);
end;

function TProjectionInfo.TilePosFloat2PixelPosFloat(
  const APoint: TDoublePoint
): TDoublePoint;
begin
  Result := FGeoConverter.TilePosFloat2PixelPosFloat(APoint, FZoom);
end;

function TProjectionInfo.TilePosFloat2Relative(
  const APoint: TDoublePoint
): TDoublePoint;
begin
  Result := FGeoConverter.TilePosFloat2Relative(APoint, FZoom);
end;

function TProjectionInfo.TileRect2LonLatRect(const ARect: TRect): TDoubleRect;
begin
  Result := FGeoConverter.TileRect2LonLatRect(ARect, FZoom);
end;

function TProjectionInfo.TileRect2PixelRect(const ARect: TRect): TRect;
begin
  Result := FGeoConverter.TileRect2PixelRect(ARect, FZoom);
end;

function TProjectionInfo.TileRect2RelativeRect(const ARect: TRect): TDoubleRect;
begin
  Result := FGeoConverter.TileRect2RelativeRect(ARect, FZoom);
end;

function TProjectionInfo.TileRectFloat2LonLatRect(
  const ARect: TDoubleRect
): TDoubleRect;
begin
  Result := FGeoConverter.TileRectFloat2LonLatRect(ARect, FZoom);
end;

function TProjectionInfo.TileRectFloat2PixelRectFloat(
  const ARect: TDoubleRect
): TDoubleRect;
begin
  Result := FGeoConverter.TileRectFloat2PixelRectFloat(ARect, FZoom);
end;

function TProjectionInfo.TileRectFloat2RelativeRect(
  const ARect: TDoubleRect
): TDoubleRect;
begin
  Result := FGeoConverter.TileRectFloat2RelativeRect(ARect, FZoom);
end;

procedure TProjectionInfo.ValidatePixelPos(
  var APoint: TPoint;
  ACicleMap: Boolean
);
begin
  FGeoConverter.ValidatePixelPos(APoint, FZoom, ACicleMap);
end;

procedure TProjectionInfo.ValidatePixelPosFloat(
  var APoint: TDoublePoint;
  ACicleMap: Boolean
);
begin
  FGeoConverter.ValidatePixelPosFloat(APoint, FZoom, ACicleMap);
end;

procedure TProjectionInfo.ValidatePixelPosFloatStrict(
  var APoint: TDoublePoint;
  ACicleMap: Boolean
);
begin
  FGeoConverter.ValidatePixelPosFloatStrict(APoint, FZoom, ACicleMap);
end;

procedure TProjectionInfo.ValidatePixelPosStrict(
  var APoint: TPoint;
  ACicleMap: Boolean
);
begin
  FGeoConverter.ValidatePixelPosStrict(APoint, FZoom, ACicleMap);
end;

procedure TProjectionInfo.ValidatePixelRect(var ARect: TRect);
begin
  FGeoConverter.ValidatePixelRect(ARect, FZoom);
end;

procedure TProjectionInfo.ValidatePixelRectFloat(var ARect: TDoubleRect);
begin
  FGeoConverter.ValidatePixelRectFloat(ARect, FZoom);
end;

procedure TProjectionInfo.ValidateTilePos(
  var APoint: TPoint;
  ACicleMap: Boolean
);
begin
  FGeoConverter.ValidateTilePos(APoint, FZoom, ACicleMap);
end;

procedure TProjectionInfo.ValidateTilePosStrict(
  var APoint: TPoint;
  ACicleMap: Boolean
);
begin
  FGeoConverter.ValidateTilePosStrict(APoint, FZoom, ACicleMap);
end;

procedure TProjectionInfo.ValidateTileRect(var ARect: TRect);
begin
  FGeoConverter.ValidateTileRect(ARect, FZoom);
end;

end.

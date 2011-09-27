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

unit u_LocalCoordConverterFactorySimpe;

interface

uses
  Types,
  t_GeoTypes,
  i_CoordConverter,
  i_LocalCoordConverter,
  i_LocalCoordConverterFactorySimpe;

type
  TLocalCoordConverterFactorySimpe = class(TInterfacedObject, ILocalCoordConverterFactorySimpe)
  protected
    function CreateConverter(
      ALocalRect: TRect;
      AZoom: Byte;
      AGeoConverter: ICoordConverter;
      AMapScale: TDoublePoint;
      ALocalTopLeftAtMap: TDoublePoint
    ): ILocalCoordConverter;
    function CreateForTile(
      ATile: TPoint;
      AZoom: Byte;
      AGeoConverter: ICoordConverter
    ): ILocalCoordConverter;
    function CreateForTileRect(
      ATileRect: TRect;
      AZoom: Byte;
      AGeoConverter: ICoordConverter
    ): ILocalCoordConverter;
  end;


implementation

uses
  u_GeoFun,
  u_LocalCoordConverter;

{ TLocalCoordConverterFactorySimpe }

function TLocalCoordConverterFactorySimpe.CreateConverter(
  ALocalRect: TRect;
  AZoom: Byte;
  AGeoConverter: ICoordConverter;
  AMapScale,
  ALocalTopLeftAtMap: TDoublePoint
): ILocalCoordConverter;
begin
  Result := TLocalCoordConverter.Create(ALocalRect, AZoom, AGeoConverter, AMapScale, ALocalTopLeftAtMap);
end;

function TLocalCoordConverterFactorySimpe.CreateForTile(ATile: TPoint;
  AZoom: Byte; AGeoConverter: ICoordConverter): ILocalCoordConverter;
var
  VPixelRect: TRect;
  VBitmapTileRect: TRect;
begin
  VPixelRect := AGeoConverter.TilePos2PixelRect(ATile, AZoom);
  VBitmapTileRect.Left := 0;
  VBitmapTileRect.Top := 0;
  VBitmapTileRect.Right := VPixelRect.Right - VPixelRect.Left;
  VBitmapTileRect.Bottom := VPixelRect.Bottom - VPixelRect.Top;
  Result := CreateConverter(VBitmapTileRect, AZoom, AGeoConverter, DoublePoint(1, 1), DoublePoint(VPixelRect.TopLeft));
end;

function TLocalCoordConverterFactorySimpe.CreateForTileRect(ATileRect: TRect;
  AZoom: Byte; AGeoConverter: ICoordConverter): ILocalCoordConverter;
var
  VPixelRect: TRect;
  VBitmapTileRect: TRect;
begin
  VPixelRect := AGeoConverter.TileRect2PixelRect(ATileRect, AZoom);
  VBitmapTileRect.Left := 0;
  VBitmapTileRect.Top := 0;
  VBitmapTileRect.Right := VPixelRect.Right - VPixelRect.Left;
  VBitmapTileRect.Bottom := VPixelRect.Bottom - VPixelRect.Top;
  Result := CreateConverter(VBitmapTileRect, AZoom, AGeoConverter, DoublePoint(1, 1), DoublePoint(VPixelRect.TopLeft));
end;

end.

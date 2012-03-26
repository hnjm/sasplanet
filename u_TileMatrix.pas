unit u_TileMatrix;

interface

uses
  Types,
  i_LocalCoordConverter,
  i_LocalCoordConverterFactorySimpe,
  i_TileMatrix;

type
  TTileMatrix = class(TInterfacedObject, ITileMatrix)
  private
    FLocalConverter: ILocalCoordConverter;
    FTileRect: TRect;
    FTileCount: TPoint;
    FItems: array of ITileMatrixElement;
  private
    function GetLocalConverter: ILocalCoordConverter;
    function GetTileRect: TRect;
    function GetElementByTile(ATile: TPoint): ITileMatrixElement;
    function GetItem(AX, AY: Integer): ITileMatrixElement;
  public
    constructor Create(
      ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
      ALocalConverter: ILocalCoordConverter;
      ATileRect: TRect;
      AItems: array of ITileMatrixElement
    );
    destructor Destroy; override;
  end;

implementation

uses
  u_TileMatrixElement;

{ TTileMatrix }

constructor TTileMatrix.Create(
  ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
  ALocalConverter: ILocalCoordConverter;
  ATileRect: TRect;
  AItems: array of ITileMatrixElement
);
var
  VItemsCount: Integer;
  VSourceItems: Integer;
  i: Integer;
  VTile: TPoint;
  VTileConverter: ILocalCoordConverter;
begin
  FLocalConverter := ALocalConverter;
  FTileRect := ATileRect;
  FTileCount := Point(FTileRect.Right - FTileRect.Left, FTileRect.Bottom - FTileRect.Top);
  VItemsCount := FTileCount.X * FTileCount.Y;
  SetLength(FItems, VItemsCount);
  VSourceItems := Length(AItems);
  if VSourceItems > VItemsCount then begin
    VSourceItems := VItemsCount;
  end;

  for i := 0 to VSourceItems - 1 do begin
    FItems[i] := AItems[i];
  end;

  for i := 0 to VItemsCount - 1 do begin
    if FItems[i] = nil then begin
      VTile.Y := i div FTileCount.X;
      VTile.X := i - FTileCount.X * VTile.Y;

      VTileConverter :=
        ALocalConverterFactory.CreateForTile(
          VTile,
          ALocalConverter.Zoom,
          ALocalConverter.GeoConverter
        );

      FItems[i] :=
        TTileMatrixElement.Create(
          VTile,
          VTileConverter,
          nil
        );
    end;
  end;
end;

destructor TTileMatrix.Destroy;
var
  i: Integer;
begin
  for i := 0 to FTileCount.X * FTileCount.Y - 1 do begin
    FItems[i] := nil;
  end;

  inherited;
end;

function TTileMatrix.GetElementByTile(ATile: TPoint): ITileMatrixElement;
begin
  Result := GetItem(ATile.X - FTileRect.Left, ATile.Y - FTileRect.Top);
end;

function TTileMatrix.GetItem(AX, AY: Integer): ITileMatrixElement;
var
  VIndex: Integer;
  VX, VY: Integer;
begin
  Result := nil;
  VX := AX;
  if VX >= FTileCount.X then begin
    VX := -1;
  end;

  VY := AY;
  if VY >= FTileCount.Y then begin
    VY := -1;
  end;

  if (VX >= 0) and (VY >= 0) then begin
    VIndex := VY * FTileCount.X + VX;
    Result := FItems[VIndex];
  end;
end;

function TTileMatrix.GetLocalConverter: ILocalCoordConverter;
begin
  Result := FLocalConverter;
end;

function TTileMatrix.GetTileRect: TRect;
begin
  Result := FTileRect;
end;

end.

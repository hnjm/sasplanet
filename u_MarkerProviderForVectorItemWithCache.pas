unit u_MarkerProviderForVectorItemWithCache;

interface

uses
  i_IdCacheSimple,
  i_VectorDataItemSimple,
  i_MarkerDrawable,
  i_MarkerProviderForVectorItem;

type
  TMarkerProviderForVectorItemWithCache = class(TInterfacedObject, IMarkerProviderForVectorItem)
  private
    FCache: IIdCacheSimple;
    FProvider: IMarkerProviderForVectorItem;
  private
    function GetMarker(const AItem: IVectorDataItemSimple): IMarkerDrawable;
  public
    constructor Create(
      ACache: IIdCacheSimple;
      AProvider: IMarkerProviderForVectorItem
    );
  end;

implementation

uses
  SysUtils;

{ TMarkerProviderForVectorItemWithCache }

constructor TMarkerProviderForVectorItemWithCache.Create(ACache: IIdCacheSimple;
  AProvider: IMarkerProviderForVectorItem);
begin
  Assert(ACache <> nil);
  Assert(AProvider <> nil);
  inherited Create;
  FCache := ACache;
  FProvider := AProvider;
end;

function TMarkerProviderForVectorItemWithCache.GetMarker(
  const AItem: IVectorDataItemSimple): IMarkerDrawable;
var
  VID: Integer;
begin
  VID := Integer(AItem);
  if not Supports(FCache.GetByID(VID), IMarkerDrawable, Result) then begin
    Result := FProvider.GetMarker(AItem);
    FCache.Add(VID, Result);
  end;
end;

end.

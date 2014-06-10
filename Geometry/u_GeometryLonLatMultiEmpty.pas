unit u_GeometryLonLatMultiEmpty;

interface

uses
  t_GeoTypes,
  t_Hash,
  i_LonLatRect,
  i_EnumDoublePoint,
  i_GeometryLonLat,
  u_BaseInterfacedObject;

type
  TGeometryLonLatMultiEmpty = class(TBaseInterfacedObject, IGeometryLonLat, IGeometryLonLatMultiLine, IGeometryLonLatMultiPolygon)
  private
    FEnumLonLat: IEnumLonLatPoint;
  private
    function GetItemLonLatPathLine(AIndex: Integer): IGeometryLonLatSingleLine;
    function GetItemLonLatPolygonLine(AIndex: Integer): IGeometryLonLatSinglePolygon;

    function GetEnumLonLat: IEnumLonLatPoint;
  private
    function GetBounds: ILonLatRect;
    function GetHash: THashValue;
    function GetCount: Integer;
    function IsSameGeometry(const AGeometry: IGeometryLonLat): Boolean;
    function IsSamePath(const APath: IGeometryLonLatMultiLine): Boolean;
    function IsSamePolygon(const APolygon: IGeometryLonLatMultiPolygon): Boolean;
    function GetGoToPoint: TDoublePoint;

    function IGeometryLonLatMultiLine.IsSame = IsSamePath;
    function IGeometryLonLatMultiPolygon.IsSame = IsSamePolygon;

    function IGeometryLonLatMultiLine.GetEnum = GetEnumLonLat;
    function IGeometryLonLatMultiPolygon.GetEnum = GetEnumLonLat;

    function IGeometryLonLatMultiLine.GetItem = GetItemLonLatPathLine;
    function IGeometryLonLatMultiPolygon.GetItem = GetItemLonLatPolygonLine;
  public
    constructor Create;
  end;

implementation

uses
  SysUtils,
  u_GeoFunc;

{ TEnumDoublePointEmpty }

type
  TEnumDoublePointEmpty = class(TBaseInterfacedObject, IEnumDoublePoint, IEnumLonLatPoint)
  private
    function Next(out APoint: TDoublePoint): Boolean;
  end;

function TEnumDoublePointEmpty.Next(out APoint: TDoublePoint): Boolean;
begin
  APoint := CEmptyDoublePoint;
  Result := False;
end;

{ TLineSetEmpty }

constructor TGeometryLonLatMultiEmpty.Create;
var
  VEnum: TEnumDoublePointEmpty;
begin
  inherited Create;
  VEnum := TEnumDoublePointEmpty.Create;
  FEnumLonLat := VEnum;
end;

function TGeometryLonLatMultiEmpty.GetBounds: ILonLatRect;
begin
  Result := nil;
end;

function TGeometryLonLatMultiEmpty.GetCount: Integer;
begin
  Result := 0;
end;

function TGeometryLonLatMultiEmpty.GetEnumLonLat: IEnumLonLatPoint;
begin
  Result := FEnumLonLat;
end;

function TGeometryLonLatMultiEmpty.GetGoToPoint: TDoublePoint;
begin
  Result := CEmptyDoublePoint;
end;

function TGeometryLonLatMultiEmpty.GetHash: THashValue;
begin
  Result := 0;
end;

function TGeometryLonLatMultiEmpty.GetItemLonLatPathLine(AIndex: Integer): IGeometryLonLatSingleLine;
begin
  Result := nil;
end;

function TGeometryLonLatMultiEmpty.GetItemLonLatPolygonLine(
  AIndex: Integer): IGeometryLonLatSinglePolygon;
begin
  Result := nil;
end;

function TGeometryLonLatMultiEmpty.IsSameGeometry(
  const AGeometry: IGeometryLonLat
): Boolean;
var
  VLine: IGeometryLonLatMultiLine;
  VPolygon: IGeometryLonLatMultiPolygon;
begin
  Result := False;
  if Supports(AGeometry, IGeometryLonLatMultiPolygon, VPolygon) then begin
    Result := IsSamePolygon(VPolygon);
  end else if Supports(AGeometry, IGeometryLonLatMultiLine, VLine) then begin
    Result := IsSamePath(VLine);
  end;
end;

function TGeometryLonLatMultiEmpty.IsSamePath(const APath: IGeometryLonLatMultiLine): Boolean;
begin
  Result := (APath.Count = 0);
end;

function TGeometryLonLatMultiEmpty.IsSamePolygon(const APolygon: IGeometryLonLatMultiPolygon): Boolean;
begin
  Result := (APolygon.Count = 0);
end;

end.

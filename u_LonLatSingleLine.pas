unit u_LonLatSingleLine;

interface

uses
  t_GeoTypes,
  t_Hash,
  i_EnumDoublePoint,
  i_LonLatRect,
  i_Datum,
  i_NotifierOperation,
  i_VectorItemLonLat,
  u_BaseInterfacedObject;

type
  TLonLatLineBase = class(TBaseInterfacedObject)
  private
    FCount: Integer;
    FBounds: ILonLatRect;
    FHash: THashValue;
    FPoints: array of TDoublePoint;
  private
    function GetBounds: ILonLatRect;
    function GetHash: THashValue;
    function GetCount: Integer;
    function GetPoints: PDoublePointArray;
  public
    constructor Create(
      AClosed: Boolean;
      const ABounds: ILonLatRect;
      const AHash: THashValue;
      const APoints: PDoublePointArray;
      ACount: Integer
    ); overload;
  end;

  TLonLatPathLine = class(TLonLatLineBase, IGeometryLonLat, IGeometryLonLatLine)
  private
    function GetEnum: IEnumLonLatPoint;
    function IsSameGeometry(const AGeometry: IGeometryLonLat): Boolean;
    function IsSame(const ALine: IGeometryLonLatLine): Boolean;
    function CalcLength(const ADatum: IDatum): Double;
  public
    constructor Create(
      const ABounds: ILonLatRect;
      const AHash: THashValue;
      const APoints: PDoublePointArray;
      ACount: Integer
    );
  end;

  TLonLatPolygonLine = class(TLonLatLineBase, IGeometryLonLat, IGeometryLonLatPolygon)
  private
    function GetEnum: IEnumLonLatPoint;
    function IsSameGeometry(const AGeometry: IGeometryLonLat): Boolean;
    function IsSame(const ALine: IGeometryLonLatPolygon): Boolean;
    function CalcPerimeter(const ADatum: IDatum): Double;
    function CalcArea(
      const ADatum: IDatum;
      const ANotifier: INotifierOperation = nil;
      const AOperationID: Integer = 0
    ): Double;
  public
    constructor Create(
      const ABounds: ILonLatRect;
      const AHash: THashValue;
      const APoints: PDoublePointArray;
      ACount: Integer
    );
  end;

implementation

uses
  SysUtils,
  u_GeoFun,
  u_EnumDoublePointBySingleLine;

{ TLineBase }

constructor TLonLatLineBase.Create(
  AClosed: Boolean;
  const ABounds: ILonLatRect;
  const AHash: THashValue;
  const APoints: PDoublePointArray;
  ACount: Integer
);
begin
  inherited Create;
  FBounds := ABounds;
  FHash := AHash;
  FCount := ACount;
  Assert(FCount > 0, 'Empty line');

  if AClosed and (FCount > 1) and DoublePointsEqual(APoints[0], APoints[ACount - 1]) then begin
    Dec(FCount);
  end;

  SetLength(FPoints, FCount);
  Move(APoints^, FPoints[0], FCount * SizeOf(TDoublePoint));
end;

function TLonLatLineBase.GetBounds: ILonLatRect;
begin
  Result := FBounds;
end;

function TLonLatLineBase.GetCount: Integer;
begin
  Result := FCount;
end;

function TLonLatLineBase.GetHash: THashValue;
begin
  Result := FHash;
end;

function TLonLatLineBase.GetPoints: PDoublePointArray;
begin
  Result := @FPoints[0];
end;

{ TLonLatPathLine }

function TLonLatPathLine.CalcLength(const ADatum: IDatum): Double;
var
  VEnum: IEnumLonLatPoint;
  VPrevPoint: TDoublePoint;
  VCurrPoint: TDoublePoint;
begin
  Result := 0;
  VEnum := GetEnum;
  if VEnum.Next(VPrevPoint) then begin
    while VEnum.Next(VCurrPoint) do begin
      Result := Result + ADatum.CalcDist(VPrevPoint, VCurrPoint);
      VPrevPoint := VCurrPoint;
    end;
  end;
end;

constructor TLonLatPathLine.Create(
  const ABounds: ILonLatRect;
  const AHash: THashValue;
  const APoints: PDoublePointArray;
  ACount: Integer
);
begin
  inherited Create(False, ABounds, AHash, APoints, ACount);
end;

function TLonLatPathLine.GetEnum: IEnumLonLatPoint;
begin
  Result := TEnumDoublePointBySingleLonLatLine.Create(Self, False, @FPoints[0], FCount);
end;

function TLonLatPathLine.IsSame(const ALine: IGeometryLonLatLine): Boolean;
var
  i: Integer;
  VPoints: PDoublePointArray;
begin
  if ALine = IGeometryLonLatLine(Self) then begin
    Result := True;
    Exit;
  end;

  if FCount <> ALine.Count then begin
    Result := False;
    Exit;
  end;

  if (FHash <> 0) and (ALine.Hash <> 0) then begin
    Result := FHash = ALine.Hash;
  end else begin
    if not FBounds.IsEqual(ALine.Bounds) then begin
      Result := False;
      Exit;
    end;

    VPoints := ALine.Points;

    for i := 0 to FCount - 1 do begin
      if not DoublePointsEqual(FPoints[i], VPoints[i]) then begin
        Result := False;
        Exit;
      end;
    end;

    Result := True;
  end;
end;

function TLonLatPathLine.IsSameGeometry(const AGeometry: IGeometryLonLat): Boolean;
var
  VLine: IGeometryLonLatLine;
begin
  if AGeometry = nil then begin
    Result := False;
    Exit;
  end;
  if AGeometry = IGeometryLonLat(Self) then begin
    Result := True;
    Exit;
  end;
  if (FHash <> 0) and (AGeometry.Hash <> 0) and (FHash <> AGeometry.Hash) then begin
    Result := False;
    Exit;
  end;

  Result := False;
  if Supports(AGeometry, IGeometryLonLatLine, VLine) then begin
    Result := IsSame(VLine);
  end;
end;

{ TLonLatPolygonLine }

function TLonLatPolygonLine.CalcArea(
  const ADatum: IDatum;
  const ANotifier: INotifierOperation = nil;
  const AOperationID: Integer = 0
): Double;
begin
  if FCount < 3 then begin
    Result := 0;
  end else begin
    Result := ADatum.CalcPolygonArea(@FPoints[0], FCount, ANotifier, AOperationID);
  end;
end;

function TLonLatPolygonLine.CalcPerimeter(const ADatum: IDatum): Double;
var
  VEnum: IEnumLonLatPoint;
  VPrevPoint: TDoublePoint;
  VCurrPoint: TDoublePoint;
begin
  Result := 0;
  VEnum := GetEnum;
  if VEnum.Next(VPrevPoint) then begin
    while VEnum.Next(VCurrPoint) do begin
      Result := Result + ADatum.CalcDist(VPrevPoint, VCurrPoint);
      VPrevPoint := VCurrPoint;
    end;
  end;
end;

constructor TLonLatPolygonLine.Create(
  const ABounds: ILonLatRect;
  const AHash: THashValue;
  const APoints: PDoublePointArray;
  ACount: Integer
);
begin
  inherited Create(True, ABounds, AHash, APoints, ACount);
end;

function TLonLatPolygonLine.GetEnum: IEnumLonLatPoint;
begin
  Result := TEnumDoublePointBySingleLonLatLine.Create(Self, True, @FPoints[0], FCount);
end;

function TLonLatPolygonLine.IsSame(const ALine: IGeometryLonLatPolygon): Boolean;
var
  i: Integer;
  VPoints: PDoublePointArray;
begin
  if ALine = IGeometryLonLatPolygon(Self) then begin
    Result := True;
    Exit;
  end;

  if FCount <> ALine.Count then begin
    Result := False;
    Exit;
  end;

  if (FHash <> 0) and (ALine.Hash <> 0) then begin
    Result := FHash = ALine.Hash;
  end else begin
    if not FBounds.IsEqual(ALine.Bounds) then begin
      Result := False;
      Exit;
    end;

    VPoints := ALine.Points;

    for i := 0 to FCount - 1 do begin
      if not DoublePointsEqual(FPoints[i], VPoints[i]) then begin
        Result := False;
        Exit;
      end;
    end;

    Result := True;
  end;
end;

function TLonLatPolygonLine.IsSameGeometry(
  const AGeometry: IGeometryLonLat
): Boolean;
var
  VLine: IGeometryLonLatPolygon;
begin
  if AGeometry = nil then begin
    Result := False;
    Exit;
  end;
  if AGeometry = IGeometryLonLat(Self) then begin
    Result := True;
    Exit;
  end;
  if (FHash <> 0) and (AGeometry.Hash <> 0) and (FHash <> AGeometry.Hash) then begin
    Result := False;
    Exit;
  end;

  Result := False;
  if Supports(AGeometry, IGeometryLonLatPolygon, VLine) then begin
    Result := IsSame(VLine);
  end;
end;

end.

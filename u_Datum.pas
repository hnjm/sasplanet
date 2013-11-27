{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2013, SAS.Planet development team.                      *}
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

unit u_Datum;

interface

uses
  t_Hash,
  t_GeoTypes,
  i_Datum,
  i_NotifierOperation,
  i_EnumDoublePoint,
  i_DistanceCalculator,
  i_PolygonAreaCalculator,
  u_BaseInterfacedObject;

type
  TDatum = class(TBaseInterfacedObject, IDatum)
  private
    FHash: THashValue;
    FEPSG: Integer;
    FRadiusA: Double;
    FRadiusB: Double;
    FAreaCalc: IPolygonAreaCalculator;
    FDistCalc: IDistanceCalculator;
  private
    { IDatum }
    function GetHash: THashValue;
    function GetEPSG: Integer; stdcall;
    function GetSpheroidRadiusA: Double; stdcall;
    function GetSpheroidRadiusB: Double; stdcall;
    function IsSameDatum(const ADatum: IDatum): Boolean; stdcall;

    function CalcPolygonArea(
      const APoints: PDoublePointArray;
      const ACount: Integer;
      const ANotifier: INotifierOperation = nil;
      const AOperationID: Integer = 0
    ): Double;

    function CalcDist(const AStart, AFinish: TDoublePoint): Double; overload;

    function CalcDist(
      const AStart: TDoublePoint;
      const AFinish: TDoublePoint;
      out AInitialBearing: Double;
      out AFinalBearing: Double
    ): Double; overload;

    function CalcFinishPosition(
      const AStart: TDoublePoint;
      const AInitialBearing: Double;
      const ADistance: Double
    ): TDoublePoint;

    function GetLinePoints(
      const AStart: TDoublePoint;
      const AFinish: TDoublePoint;
      const APointCount: integer
    ): IEnumLonLatPoint;
  public
    constructor Create(
      const AHash: THashValue;
      const AEPSG: Integer;
      const ARadiusA: Double;
      const ARadiusB: Double
    ); overload;

    constructor Create(
      const AHash: THashValue;
      const AEPSG: Integer;
      const ARadiusA: Double
    ); overload;
  end;

implementation

uses
  i_DoublePointsAggregator,
  u_DoublePointsAggregator,
  u_PolygonAreaCalculator,
  u_DistanceCalculatorByVincentyAlgorithm,
  u_EnumDoublePointsByArray;

{ TDatum }

constructor TDatum.Create(
  const AHash: THashValue;
  const AEPSG: Integer;
  const ARadiusA, ARadiusB: Double
);
begin
  inherited Create;
  FHash := AHash;
  FEPSG := AEPSG;
  FRadiusA := ARadiusA;
  FRadiusB := ARadiusB;

  FAreaCalc := TPolygonAreaCalculator.Create(FRadiusA, FRadiusB);
  FDistCalc := TDistanceCalculatorByVincentyAlgorithm.Create(FRadiusA, FRadiusB);
end;

constructor TDatum.Create(
  const AHash: THashValue;
  const AEPSG: Integer;
  const ARadiusA: Double
);
begin
  Create(AHash, AEPSG, ARadiusA, ARadiusA);
end;

function TDatum.GetEPSG: integer;
begin
  Result := FEPSG;
end;

function TDatum.GetHash: THashValue;
begin
  Result := FHash;
end;

function TDatum.GetSpheroidRadiusA: Double;
begin
  Result := FRadiusA;
end;

function TDatum.GetSpheroidRadiusB: Double;
begin
  Result := FRadiusB;
end;

function TDatum.IsSameDatum(const ADatum: IDatum): Boolean;
var
  VSelf: IDatum;
begin
  VSelf := Self;
  if VSelf = ADatum then begin
    Result := True;
  end else begin
    Result := (ADatum.EPSG <> 0) and (FEPSG <> 0) and (FEPSG = ADatum.EPSG);
  end;
end;

function TDatum.CalcPolygonArea(
  const APoints: PDoublePointArray;
  const ACount: Integer;
  const ANotifier: INotifierOperation = nil;
  const AOperationID: Integer = 0
): Double;
begin
  Result := FAreaCalc.ComputePolygonArea(APoints, ACount, ANotifier, AOperationID);
end;

function TDatum.CalcFinishPosition(
  const AStart: TDoublePoint;
  const AInitialBearing: Double;
  const ADistance: Double
): TDoublePoint;
begin
  FDistCalc.ComputeFinishPosition(
    AStart.Y,
    AStart.X,
    AInitialBearing,
    ADistance,
    Result.Y,
    Result.X
  );
end;

function TDatum.CalcDist(const AStart, AFinish: TDoublePoint): Double;
var
  VInitialBearing: Double;
  VFinalBearing: Double;
begin
  Result := FDistCalc.ComputeDistance(
    AStart.Y,
    AStart.X,
    AFinish.Y,
    AFinish.X,
    VInitialBearing,
    VFinalBearing
  );
end;

function TDatum.CalcDist(
  const AStart: TDoublePoint;
  const AFinish: TDoublePoint;
  out AInitialBearing: Double;
  out AFinalBearing: Double
): Double;
begin
  Result := FDistCalc.ComputeDistance(
    AStart.Y,
    AStart.X,
    AFinish.Y,
    AFinish.X,
    AInitialBearing,
    AFinalBearing
  );
end;

function TDatum.GetLinePoints(
  const AStart: TDoublePoint;
  const AFinish: TDoublePoint;
  const APointCount: Integer
): IEnumLonLatPoint;
var
  I: Integer;
  VDistFull: Double;
  VDistPart: Double;
  VInitialBearing: Double;
  VFinalBearing: Double;
  VStart, VFinish: TDoublePoint;
  VPointsAggregator: IDoublePointsAggregator;
begin
  Assert(APointCount >= 1);

  VDistFull := FDistCalc.ComputeDistance(
    AStart.Y,
    AStart.X,
    AFinish.Y,
    AFinish.X,
    VInitialBearing,
    VFinalBearing
  );

  VDistPart := VDistFull / (APointCount + 1);

  VPointsAggregator := TDoublePointsAggregator.Create;

  VStart := AStart;
  for I := 0 to APointCount - 1 do begin
    FDistCalc.ComputeFinishPosition(
      VStart.Y,
      VStart.X,
      VInitialBearing,
      VDistPart,
      VFinish.Y,
      VFinish.X
    );

    VPointsAggregator.Add(VFinish);
    VStart := VFinish;
  end; 

  Result := TEnumDoublePointsByArray.Create(VPointsAggregator) as IEnumLonLatPoint;
end;

end.

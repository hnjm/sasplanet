unit u_VectorItmesFactorySimple_Test;

{

  Delphi DUnit Test Case
  ----------------------
}

interface

uses
  TestFramework,
  t_GeoTypes,
  i_GeometryProjectedFactory,
  i_GeometryLonLatFactory;

type
  TestTVectorItmesLonLatFactorySimple = class(TTestCase)
  private
    FFactory: IGeometryLonLatFactory;
    FPoints: array of TDoublePoint;
  protected
    procedure SetUp; override;
  published
    procedure CreateLonLatPathSimple;
    procedure CreateLonLatPathTwoLines;
    procedure CreateLonLatPathNoLines;

    procedure CreateLonLatPolygonSimple;
    procedure CreateLonLatPolygonTwoLines;
    procedure CreateLonLatPolygonNoLines;
  end;

  TestTVectorItmesProjectedFactorySimple = class(TTestCase)
  private
    FFactory: IGeometryProjectedFactory;
    FPoints: array of TDoublePoint;
  protected
    procedure SetUp; override;
  published
    procedure CreateProjectedPathSimple;
    procedure CreateProjectedPathTwoLines;
    procedure CreateProjectedPathNoLines;

    procedure CreateProjectedPolygonSimple;
    procedure CreateProjectedPolygonTwoLines;
    procedure CreateProjectedPolygonNoLines;
  end;

implementation

uses
  i_GeometryLonLat,
  i_Projection,
  i_HashFunction,
  i_GeometryProjected,
  i_EnumDoublePoint,
  u_GeoFunc,
  u_ProjectionInfo,
  u_HashFunctionCityHash,
  u_HashFunctionWithCounter,
  u_InternalPerformanceCounterFake,
  u_GeometryProjectedFactory,
  u_GeometryLonLatFactory;

{ TestTVectorItmesFactorySimple }

procedure TestTVectorItmesLonLatFactorySimple.SetUp;
var
  VHashFunction: IHashFunction;
begin
  VHashFunction :=
    THashFunctionWithCounter.Create(
      THashFunctionCityHash.Create,
      TInternalPerformanceCounterFake.Create
    );
  FFactory := TGeometryLonLatFactory.Create(VHashFunction);
end;

procedure TestTVectorItmesLonLatFactorySimple.CreateLonLatPathNoLines;
var
  VResult: IGeometryLonLatMultiLine;
begin
  VResult := FFactory.CreateLonLatMultiLine(nil, 0);
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 0);
  VResult := FFactory.CreateLonLatMultiLine(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 1);
  FPoints[0] := CEmptyDoublePoint;
  VResult := FFactory.CreateLonLatMultiLine(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 2);
  FPoints[0] := CEmptyDoublePoint;
  FPoints[1] := CEmptyDoublePoint;
  VResult := FFactory.CreateLonLatMultiLine(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
end;

procedure TestTVectorItmesLonLatFactorySimple.CreateLonLatPathSimple;
var
  VResult: IGeometryLonLatMultiLine;
  VLine: IGeometryLonLatSingleLine;
  VPoint: TDoublePoint;
  VEnum: IEnumDoublePoint;
begin
  SetLength(FPoints, 3);
  FPoints[0] := DoublePoint(0, 1);
  FPoints[1] := DoublePoint(1, 1);
  FPoints[2] := DoublePoint(1, 0);
  VResult := FFactory.CreateLonLatMultiLine(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(1, VResult.Count);
  VEnum := VResult.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[0];
  CheckNotNull(VLine);
  CheckEquals(3, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckFalse(VEnum.Next(VPoint));
end;

procedure TestTVectorItmesLonLatFactorySimple.CreateLonLatPathTwoLines;
var
  VResult: IGeometryLonLatMultiLine;
  VLine: IGeometryLonLatSingleLine;
  VPoint: TDoublePoint;
  VEnum: IEnumDoublePoint;
begin
  SetLength(FPoints, 4);
  FPoints[0] := DoublePoint(0, 1);
  FPoints[1] := CEmptyDoublePoint;
  FPoints[2] := DoublePoint(1, 1);
  FPoints[3] := DoublePoint(1, 0);
  VResult := FFactory.CreateLonLatMultiLine(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(2, VResult.Count);
  VEnum := VResult.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[3]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[0];
  CheckNotNull(VLine);
  CheckEquals(1, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[1];
  CheckNotNull(VLine);
  CheckEquals(2, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[3]));
  CheckFalse(VEnum.Next(VPoint));
end;

procedure TestTVectorItmesLonLatFactorySimple.CreateLonLatPolygonNoLines;
var
  VResult: IGeometryLonLatMultiPolygon;
begin
  VResult := FFactory.CreateLonLatMultiPolygon(nil, 0);
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 0);
  VResult := FFactory.CreateLonLatMultiPolygon(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 1);
  FPoints[0] := CEmptyDoublePoint;
  VResult := FFactory.CreateLonLatMultiPolygon(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 2);
  FPoints[0] := CEmptyDoublePoint;
  FPoints[1] := CEmptyDoublePoint;
  VResult := FFactory.CreateLonLatMultiPolygon(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
end;

procedure TestTVectorItmesLonLatFactorySimple.CreateLonLatPolygonSimple;
var
  VResult: IGeometryLonLatMultiPolygon;
  VLine: IGeometryLonLatSinglePolygon;
  VPoint: TDoublePoint;
  VEnum: IEnumDoublePoint;
begin
  SetLength(FPoints, 3);
  FPoints[0] := DoublePoint(0, 1);
  FPoints[1] := DoublePoint(1, 1);
  FPoints[2] := DoublePoint(1, 0);
  VResult := FFactory.CreateLonLatMultiPolygon(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(1, VResult.Count);
  VEnum := VResult.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[0];
  CheckNotNull(VLine);
  CheckEquals(3, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckFalse(VEnum.Next(VPoint));
end;

procedure TestTVectorItmesLonLatFactorySimple.CreateLonLatPolygonTwoLines;
var
  VResult: IGeometryLonLatMultiPolygon;
  VLine: IGeometryLonLatSinglePolygon;
  VPoint: TDoublePoint;
  VEnum: IEnumDoublePoint;
begin
  SetLength(FPoints, 4);
  FPoints[0] := DoublePoint(0, 1);
  FPoints[1] := CEmptyDoublePoint;
  FPoints[2] := DoublePoint(1, 1);
  FPoints[3] := DoublePoint(1, 0);
  VResult := FFactory.CreateLonLatMultiPolygon(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(2, VResult.Count);
  VEnum := VResult.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[3]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[0];
  CheckNotNull(VLine);
  CheckEquals(1, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[1];
  CheckNotNull(VLine);
  CheckEquals(2, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[3]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckFalse(VEnum.Next(VPoint));
end;

procedure TestTVectorItmesProjectedFactorySimple.SetUp;
begin
  inherited;
  FFactory := TGeometryProjectedFactory.Create;
end;

procedure TestTVectorItmesProjectedFactorySimple.CreateProjectedPathNoLines;
var
  VResult: IGeometryProjectedMultiLine;
begin
  VResult := FFactory.CreateProjectedPath(nil, 0);
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 0);
  VResult := FFactory.CreateProjectedPath(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 1);
  FPoints[0] := CEmptyDoublePoint;
  VResult := FFactory.CreateProjectedPath(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 2);
  FPoints[0] := CEmptyDoublePoint;
  FPoints[1] := CEmptyDoublePoint;
  VResult := FFactory.CreateProjectedPath(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
end;

procedure TestTVectorItmesProjectedFactorySimple.CreateProjectedPathSimple;
var
  VResult: IGeometryProjectedMultiLine;
  VLine: IGeometryProjectedSingleLine;
  VPoint: TDoublePoint;
  VEnum: IEnumDoublePoint;
begin
  SetLength(FPoints, 3);
  FPoints[0] := DoublePoint(0, 1);
  FPoints[1] := DoublePoint(1, 1);
  FPoints[2] := DoublePoint(1, 0);
  VResult := FFactory.CreateProjectedPath(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(1, VResult.Count);
  VEnum := VResult.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[0];
  CheckNotNull(VLine);
  CheckEquals(3, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckFalse(VEnum.Next(VPoint));
end;

procedure TestTVectorItmesProjectedFactorySimple.CreateProjectedPathTwoLines;
var
  VResult: IGeometryProjectedMultiLine;
  VLine: IGeometryProjectedSingleLine;
  VPoint: TDoublePoint;
  VEnum: IEnumDoublePoint;
begin
  SetLength(FPoints, 4);
  FPoints[0] := DoublePoint(0, 1);
  FPoints[1] := CEmptyDoublePoint;
  FPoints[2] := DoublePoint(1, 1);
  FPoints[3] := DoublePoint(1, 0);
  VResult := FFactory.CreateProjectedPath(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(2, VResult.Count);
  VEnum := VResult.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[3]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[0];
  CheckNotNull(VLine);
  CheckEquals(1, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[1];
  CheckNotNull(VLine);
  CheckEquals(2, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[3]));
  CheckFalse(VEnum.Next(VPoint));
end;

procedure TestTVectorItmesProjectedFactorySimple.CreateProjectedPolygonNoLines;
var
  VResult: IGeometryProjectedMultiPolygon;
begin
  VResult := FFactory.CreateProjectedPolygon(nil, 0);
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 0);
  VResult := FFactory.CreateProjectedPolygon(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 1);
  FPoints[0] := CEmptyDoublePoint;
  VResult := FFactory.CreateProjectedPolygon(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
  SetLength(FPoints, 2);
  FPoints[0] := CEmptyDoublePoint;
  FPoints[1] := CEmptyDoublePoint;
  VResult := FFactory.CreateProjectedPolygon(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(0, VResult.Count);
  CheckNotNull(VResult.GetEnum);
end;

procedure TestTVectorItmesProjectedFactorySimple.CreateProjectedPolygonSimple;
var
  VResult: IGeometryProjectedMultiPolygon;
  VLine: IGeometryProjectedSinglePolygon;
  VPoint: TDoublePoint;
  VEnum: IEnumDoublePoint;
begin
  SetLength(FPoints, 3);
  FPoints[0] := DoublePoint(0, 1);
  FPoints[1] := DoublePoint(1, 1);
  FPoints[2] := DoublePoint(1, 0);
  VResult := FFactory.CreateProjectedPolygon(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(1, VResult.Count);
  VEnum := VResult.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[0];
  CheckNotNull(VLine);
  CheckEquals(3, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckFalse(VEnum.Next(VPoint));
end;

procedure TestTVectorItmesProjectedFactorySimple.CreateProjectedPolygonTwoLines;
var
  VResult: IGeometryProjectedMultiPolygon;
  VLine: IGeometryProjectedSinglePolygon;
  VPoint: TDoublePoint;
  VEnum: IEnumDoublePoint;
begin
  SetLength(FPoints, 4);
  FPoints[0] := DoublePoint(0, 1);
  FPoints[1] := CEmptyDoublePoint;
  FPoints[2] := DoublePoint(1, 1);
  FPoints[3] := DoublePoint(1, 0);
  VResult := FFactory.CreateProjectedPolygon(@FPoints[0], Length(FPoints));
  CheckNotNull(VResult);
  CheckEquals(2, VResult.Count);
  VEnum := VResult.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[1]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[3]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[0];
  CheckNotNull(VLine);
  CheckEquals(1, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[0]));
  CheckFalse(VEnum.Next(VPoint));
  VLine := VResult.Item[1];
  CheckNotNull(VLine);
  CheckEquals(2, VLine.Count);
  VEnum := VLine.GetEnum;
  CheckNotNull(VEnum);
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[3]));
  CheckTrue(VEnum.Next(VPoint));
  CheckTrue(DoublePointsEqual(VPoint, FPoints[2]));
  CheckFalse(VEnum.Next(VPoint));
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTVectorItmesLonLatFactorySimple.Suite);
  RegisterTest(TestTVectorItmesProjectedFactorySimple.Suite);
end.

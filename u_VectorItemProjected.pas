unit u_VectorItemProjected;

interface

uses
  Classes,
  t_GeoTypes,
  i_EnumDoublePoint,
  i_ProjectionInfo,
  i_VectorItemProjected;

type
  TProjectedLineSet = class(TInterfacedObject)
  private
    FList: IInterfaceList;
    FProjection: IProjectionInfo;
  private
    function GetCount: Integer;
    function GetProjection: IProjectionInfo;
  public
    constructor Create(
      AProjection: IProjectionInfo;
      AList: IInterfaceList
    );
  end;

  TProjectedPath = class(TProjectedLineSet, IProjectedPath)
  private
    function GetEnum: IEnumProjectedPoint;
    function IsPointOnPath(APoint:TDoublePoint; ADist: Double): Boolean;
    function GetItem(AIndex: Integer): IProjectedPathLine;
  end;

  TProjectedPolygon = class(TProjectedLineSet, IProjectedPolygon)
  private
    function GetEnum: IEnumProjectedPoint;
    function IsPointInPolygon(const APoint: TDoublePoint): Boolean;
    function CalcArea: Double;
    function GetItem(AIndex: Integer): IProjectedPolygonLine;
  end;

  TProjectedPathOneLine = class(TInterfacedObject, IProjectedPath)
  private
    FLine: IProjectedPathLine;
  private
    function GetProjection: IProjectionInfo;
    function GetCount: Integer;
    function GetEnum: IEnumProjectedPoint;
    function IsPointOnPath(APoint:TDoublePoint; ADist: Double): Boolean;
    function GetItem(AIndex: Integer): IProjectedPathLine;
  public
    constructor Create(
      ALine: IProjectedPathLine
    );
  end;

  TProjectedPolygonOneLine = class(TInterfacedObject, IProjectedPolygon)
  private
    FLine: IProjectedPolygonLine;
  private
    function GetProjection: IProjectionInfo;
    function GetCount: Integer;
    function GetEnum: IEnumProjectedPoint;
    function IsPointInPolygon(const APoint: TDoublePoint): Boolean;
    function CalcArea: Double;
    function GetItem(AIndex: Integer): IProjectedPolygonLine;
  public
    constructor Create(
      ALine: IProjectedPolygonLine
    );
  end;

implementation

uses
  SysUtils,
  u_EnumDoublePointByLineSet;

{ TProjectedLineSet }

constructor TProjectedLineSet.Create(AProjection: IProjectionInfo;
  AList: IInterfaceList);
begin
  FList := AList;
  FProjection := AProjection;
end;

function TProjectedLineSet.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TProjectedLineSet.GetProjection: IProjectionInfo;
begin
  Result := FProjection;
end;

{ TProjectedPath }

function TProjectedPath.GetEnum: IEnumProjectedPoint;
begin
  Result := TEnumProjectedPointByPath.Create(Self);
end;

function TProjectedPath.GetItem(AIndex: Integer): IProjectedPathLine;
begin
  if not Supports(FList[AIndex], IProjectedPathLine, Result) then begin
    Result := nil;
  end;
end;

function TProjectedPath.IsPointOnPath(APoint: TDoublePoint;
  ADist: Double): Boolean;
var
  i: Integer;
  VLine: IProjectedPathLine;
begin
  Result := False;
  for i := 0 to FList.Count - 1 do begin
    VLine := GetItem(i);
    if VLine.IsPointOnPath(APoint, ADist) then begin
      Result := True;
      Break;
    end;
  end;
end;

{ TProjectedPolygon }

function TProjectedPolygon.CalcArea: Double;
var
  i: Integer;
  VLine: IProjectedPolygonLine;
begin
  Result := 0;
  for i := 0 to FList.Count - 1 do begin
    VLine := GetItem(i);
    Result := Result + VLine.CalcArea;
  end;
end;

function TProjectedPolygon.GetEnum: IEnumProjectedPoint;
begin
  Result := TEnumProjectedPointByPolygon.Create(Self);
end;

function TProjectedPolygon.GetItem(AIndex: Integer): IProjectedPolygonLine;
begin
  if not Supports(FList[AIndex], IProjectedPolygonLine, Result) then begin
    Result := nil;
  end;
end;

function TProjectedPolygon.IsPointInPolygon(
  const APoint: TDoublePoint): Boolean;
var
  i: Integer;
  VLine: IProjectedPolygonLine;
begin
  Result := False;
  for i := 0 to FList.Count - 1 do begin
    VLine := GetItem(i);
    if VLine.IsPointInPolygon(APoint) then begin
      Result := True;
      Break;
    end;
  end;
end;

{ TProjectedPathOneLine }

constructor TProjectedPathOneLine.Create(ALine: IProjectedPathLine);
begin
  FLine := ALine;
end;

function TProjectedPathOneLine.GetCount: Integer;
begin
  Result := 1;
end;

function TProjectedPathOneLine.GetEnum: IEnumProjectedPoint;
begin
  Result := FLine.GetEnum;
end;

function TProjectedPathOneLine.GetItem(AIndex: Integer): IProjectedPathLine;
begin
  if AIndex = 0 then begin
    Result := FLine;
  end else begin
    Result := nil;
  end;
end;

function TProjectedPathOneLine.GetProjection: IProjectionInfo;
begin
  Result := FLine.Projection;
end;

function TProjectedPathOneLine.IsPointOnPath(APoint: TDoublePoint;
  ADist: Double): Boolean;
begin
  Result := FLine.IsPointOnPath(APoint, ADist);
end;

{ TProjectedPolygonOneLine }

constructor TProjectedPolygonOneLine.Create(ALine: IProjectedPolygonLine);
begin
  FLine := ALine;
end;

function TProjectedPolygonOneLine.CalcArea: Double;
begin
  Result := FLine.CalcArea;
end;

function TProjectedPolygonOneLine.GetCount: Integer;
begin
  Result := 1;
end;

function TProjectedPolygonOneLine.GetEnum: IEnumProjectedPoint;
begin
  Result := FLine.GetEnum;
end;

function TProjectedPolygonOneLine.GetItem(
  AIndex: Integer): IProjectedPolygonLine;
begin
  if AIndex = 0 then begin
    Result := FLine;
  end else begin
    Result := nil;
  end;
end;

function TProjectedPolygonOneLine.GetProjection: IProjectionInfo;
begin
  Result := FLine.Projection;
end;

function TProjectedPolygonOneLine.IsPointInPolygon(
  const APoint: TDoublePoint): Boolean;
begin
  Result := FLine.IsPointInPolygon(APoint);
end;

end.

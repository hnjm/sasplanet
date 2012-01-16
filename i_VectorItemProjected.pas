unit i_VectorItemProjected;

interface

uses
  t_GeoTypes,
  i_EnumDoublePoint,
  i_ProjectionInfo;

type
  IProjectedPathLine = interface
    ['{0D9B7321-DBA0-494F-959C-5026DB27C681}']
    function GetEnum: IEnumProjectedPoint;

    function GetProjection: IProjectionInfo;
    property Projection: IProjectionInfo read GetProjection;

    function IsPointOnPath(const APoint: TDoublePoint; ADist: Double): Boolean;

    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetPoints: PDoublePointArray;
    property Points: PDoublePointArray read GetPoints;
  end;

  IProjectedPolygonLine = interface
    ['{30424113-D148-45EB-A4C8-C0150DB89D22}']
    function GetEnum: IEnumProjectedPoint;

    function GetProjection: IProjectionInfo;
    property Projection: IProjectionInfo read GetProjection;

    function IsPointInPolygon(const APoint: TDoublePoint): Boolean;
    function IsPointOnBorder(APoint:TDoublePoint; ADist: Double): Boolean;
    function CalcArea: Double;

    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetPoints: PDoublePointArray;
    property Points: PDoublePointArray read GetPoints;
  end;

  IProjectedPath = interface
    ['{781FAF61-C109-4CC9-A861-90CBE807D8E1}']
    function GetEnum: IEnumProjectedPoint;

    function GetProjection: IProjectionInfo;
    property Projection: IProjectionInfo read GetProjection;

    function IsPointOnPath(APoint:TDoublePoint; ADist: Double): Boolean;

    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetItem(AIndex: Integer): IProjectedPathLine;
    property Item[AIndex: Integer]: IProjectedPathLine read GetItem;
  end;

  IProjectedPolygon = interface
    ['{02C310DE-60C3-4175-8811-367D5C5AC0CE}']
    function GetEnum: IEnumProjectedPoint;

    function GetProjection: IProjectionInfo;
    property Projection: IProjectionInfo read GetProjection;

    function IsPointInPolygon(const APoint: TDoublePoint): Boolean;
    function IsPointOnBorder(APoint:TDoublePoint; ADist: Double): Boolean;
    function CalcArea: Double;

    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetItem(AIndex: Integer): IProjectedPolygonLine;
    property Item[AIndex: Integer]: IProjectedPolygonLine read GetItem;
  end;

implementation

end.

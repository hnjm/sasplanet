unit u_PointOnMapEdit;

interface

uses
  t_GeoTypes,
  i_PointOnMapEdit,
  u_ConfigDataElementBase;

type
  TPointOnMapEdit = class(TConfigDataElementBaseEmptySaveLoad, IPointOnMapEdit)
  private
    FPoint: TDoublePoint;
  private
    function GetPoint: TDoublePoint;
    procedure SetPoint(AValue: TDoublePoint);

    procedure Clear;
  public
    constructor Create;
  end;

implementation

uses
  u_GeoFun;

{ TPointOnMapEdit }

constructor TPointOnMapEdit.Create;
begin
  inherited Create;
  FPoint := CEmptyDoublePoint;
end;

procedure TPointOnMapEdit.Clear;
begin
  SetPoint(CEmptyDoublePoint);
end;

function TPointOnMapEdit.GetPoint: TDoublePoint;
begin
  LockRead;
  try
    Result := FPoint;
  finally
    UnlockRead;
  end;
end;

procedure TPointOnMapEdit.SetPoint(AValue: TDoublePoint);
begin
  LockWrite;
  try
    if not DoublePointsEqual(AValue, FPoint) then begin
      FPoint := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.

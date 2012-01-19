{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
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

unit u_LineOnMapEdit;

interface

uses
  Classes,
  t_GeoTypes,
  i_VectorItemLonLat,
  i_VectorItmesFactory,
  i_EnumDoublePoint,
  u_ConfigDataElementBase,
  i_LineOnMapEdit;

type
  TLineOnMapEdit = class(TConfigDataElementBaseEmptySaveLoad, ILineOnMapEdit)
  private
    FFactory: IVectorItmesFactory;
    FPoints: TArrayOfDoublePoint;
    FPointsCount: Integer;
    FSelectedPointIndex: Integer;
    procedure _GrowPoints(AAddCount: Integer);
    procedure _UpdateLineObject; virtual; abstract;
    procedure _UpdateLineWithSelected; virtual; abstract;
  private
    procedure SetSelectedPoint(ASegmentIndex: Integer; APointIndex: Integer);
    procedure SetSelectedNextPoint;
    procedure SetSelectedPrevPoint;
    function SelectPointInLonLatRect(ARect: TDoubleRect): Boolean;

    function IsEmpty: Boolean; virtual; abstract;
    function IsReady: Boolean; virtual; abstract;
    procedure Clear;
    procedure DeleteActivePoint;
    procedure InsertPoint(APoint: TDoublePoint);
    procedure MoveActivePoint(APoint: TDoublePoint);
  public
    constructor Create(AFactory: IVectorItmesFactory);
  end;

  TPathOnMapEdit = class(TLineOnMapEdit, IPathOnMapEdit)
  private
    FLine: ILonLatPath;
    FLineWithSelected: ILonLatPathWithSelected;
    procedure _UpdateLineObject; override;
    procedure _UpdateLineWithSelected; override;
  private
    function IsEmpty: Boolean; override;
    function IsReady: Boolean; override;
    function GetPath: ILonLatPathWithSelected;
    procedure SetPath(AValue: ILonLatPathWithSelected); overload;
    procedure SetPath(AValue: ILonLatPath); overload;
  end;

  TPolygonOnMapEdit = class(TLineOnMapEdit, IPolygonOnMapEdit)
  private
    FLine: ILonLatPolygon;
    FLineWithSelected: ILonLatPolygonWithSelected;
    procedure _UpdateLineObject; override;
    procedure _UpdateLineWithSelected; override;
  private
    function IsEmpty: Boolean; override;
    function IsReady: Boolean; override;
    function GetPolygon: ILonLatPolygonWithSelected;
    procedure SetPolygon(AValue: ILonLatPolygonWithSelected); overload;
    procedure SetPolygon(AValue: ILonLatPolygon); overload;
  end;

implementation

uses
  i_Datum,
  u_GeoFun;

type
  TLonLatLineWithSelectedBase = class(TInterfacedObject)
  private
    FSelectedPoint: TDoublePoint;
    FSelectedSegmentIndex: Integer;
    FSelectedPointIndex: Integer;
  private
    function GetSelectedPoint: TDoublePoint;
    function GetSelectedSegmentIndex: Integer;
    function GetSelectedPointIndex: Integer;
  public
    constructor Create(
      ASelectedPoint: TDoublePoint;
      ASelectedSegmentIndex: Integer;
      ASelectedPointIndex: Integer
    );
  end;

  TLonLatPathWithSelected = class(TLonLatLineWithSelectedBase, ILonLatPathWithSelected)
  private
    FLine: ILonLatPath;
  private
    function GetEnum: IEnumLonLatPoint;
    function GetBounds: TDoubleRect;
    function CalcLength(ADatum: IDatum): Double;
    function GetCount: Integer;
    function GetItem(AIndex: Integer): ILonLatPathLine;
  public
    constructor Create(
      ALine: ILonLatPath;
      ASelectedPointIndex: Integer
    );
  end;

  TLonLatPolygonWithSelected = class(TLonLatLineWithSelectedBase, ILonLatPolygonWithSelected)
  private
    FLine: ILonLatPolygon;
  private
    function GetEnum: IEnumLonLatPoint;
    function GetBounds: TDoubleRect;
    function CalcPerimeter(ADatum: IDatum): Double;
    function CalcArea(ADatum: IDatum): Double;
    function GetCount: Integer;
    function GetItem(AIndex: Integer): ILonLatPolygonLine;
  public
    constructor Create(
      ALine: ILonLatPolygon;
      ASelectedPointIndex: Integer
    );
  end;

{ TLineOnMapEdit }

constructor TLineOnMapEdit.Create(AFactory: IVectorItmesFactory);
begin
  inherited Create;
  FFactory := AFactory;
  FPointsCount := 0;
  FSelectedPointIndex := 0;
  SetLength(FPoints, 0);
end;

procedure TLineOnMapEdit.Clear;
begin
  LockWrite;
  try
    if FPointsCount > 0 then begin
      FPointsCount := 0;
      FSelectedPointIndex := 0;
      _UpdateLineObject;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TLineOnMapEdit.DeleteActivePoint;
var
  VPrevPoint: TDoublePoint;
  VNextPoint: TDoublePoint;
  VDelCount: Integer;
begin
  LockWrite;
  try
    if FPointsCount > 0 then begin
      if FSelectedPointIndex < FPointsCount then begin
        if FSelectedPointIndex = FPointsCount - 1 then begin
          Dec(FPointsCount);
          Dec(FSelectedPointIndex);
        end else begin
          VNextPoint := FPoints[FSelectedPointIndex + 1];
          if FSelectedPointIndex = 0 then begin
            VPrevPoint := CEmptyDoublePoint;
          end else begin
            VPrevPoint := FPoints[FSelectedPointIndex - 1];
          end;
          if PointIsEmpty(VPrevPoint) and PointIsEmpty(VNextPoint) then begin
            VDelCount := 2;
          end else begin
            VDelCount := 1;
          end;
          Move(FPoints[FSelectedPointIndex + VDelCount], FPoints[FSelectedPointIndex], (FPointsCount - FSelectedPointIndex - VDelCount) * SizeOf(TDoublePoint));
          Dec(FPointsCount, VDelCount);
          if FSelectedPointIndex > 0 then begin
            Dec(FSelectedPointIndex);
          end;
        end;
        _UpdateLineObject;
      end else begin
        FSelectedPointIndex := FPointsCount - 1;
        _UpdateLineWithSelected;
      end;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TLineOnMapEdit.InsertPoint(APoint: TDoublePoint);
var
  VInsertCount: Integer;
  VCurrPoint: TDoublePoint;
  VNextPoint: TDoublePoint;
begin
  LockWrite;
  try
    if FSelectedPointIndex >= FPointsCount then begin
      VCurrPoint := CEmptyDoublePoint;
      VNextPoint := CEmptyDoublePoint;
    end else begin
      if FSelectedPointIndex = FPointsCount - 1 then begin
        VCurrPoint := FPoints[FSelectedPointIndex];
        VNextPoint := CEmptyDoublePoint;
      end else begin
        VCurrPoint := FPoints[FSelectedPointIndex];
        VNextPoint := FPoints[FSelectedPointIndex + 1];
      end;
    end;

    if PointIsEmpty(APoint) then begin
      if not PointIsEmpty(VCurrPoint) then begin
        if PointIsEmpty(VNextPoint) then begin
          Inc(FSelectedPointIndex);
          _UpdateLineWithSelected;
        end else begin
          VInsertCount := 1;
          _GrowPoints(VInsertCount);
          Move(FPoints[FSelectedPointIndex + 1], FPoints[FSelectedPointIndex + VInsertCount + 1], (FPointsCount - FSelectedPointIndex - 1) * SizeOf(TDoublePoint));
          FPoints[FSelectedPointIndex] := CEmptyDoublePoint;
          Inc(FPointsCount, VInsertCount);
          Inc(FSelectedPointIndex, 2);
          _UpdateLineObject;
        end;
      end;
    end else begin
      if PointIsEmpty(VCurrPoint) then begin
        if FSelectedPointIndex < FPointsCount then begin
          VInsertCount := 2;
        end else begin
          VInsertCount := 1;
        end;
        _GrowPoints(VInsertCount);
        if FSelectedPointIndex < FPointsCount then begin
          Move(FPoints[FSelectedPointIndex], FPoints[FSelectedPointIndex + VInsertCount], (FPointsCount - FSelectedPointIndex) * SizeOf(TDoublePoint));
          FPoints[FSelectedPointIndex + 1] := APoint;
          FPoints[FSelectedPointIndex + 2] := CEmptyDoublePoint;
          Inc(FSelectedPointIndex);
        end else begin
          FPoints[FSelectedPointIndex] := APoint;
        end;
        Inc(FPointsCount, VInsertCount);
        _UpdateLineObject;
      end else begin
        VInsertCount := 1;
        _GrowPoints(VInsertCount);
        if FSelectedPointIndex < FPointsCount - 1 then begin
          Move(FPoints[FSelectedPointIndex + 1], FPoints[FSelectedPointIndex + VInsertCount + 1], (FPointsCount - FSelectedPointIndex - 1) * SizeOf(TDoublePoint));
        end;
        FPoints[FSelectedPointIndex + 1] := APoint;
        Inc(FPointsCount, VInsertCount);
        Inc(FSelectedPointIndex);
        _UpdateLineObject;
      end;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TLineOnMapEdit.MoveActivePoint(APoint: TDoublePoint);
var
  VCurrPoint: TDoublePoint;
begin
  if not PointIsEmpty(APoint) then begin
    LockWrite;
    try
      if FSelectedPointIndex < FPointsCount then begin
        VCurrPoint := FPoints[FSelectedPointIndex];
        if not PointIsEmpty(VCurrPoint) then begin
          if not DoublePointsEqual(APoint, VCurrPoint) then begin
            FPoints[FSelectedPointIndex] := APoint;
            _UpdateLineObject;
          end;
        end;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

function TLineOnMapEdit.SelectPointInLonLatRect(ARect: TDoubleRect): Boolean;
var
  VIndex: Integer;
  VPoint: TDoublePoint;
  i: Integer;
begin
  Result := False;
  LockWrite;
  try
    VIndex := -1;
    if FPointsCount > 0 then begin
      if FSelectedPointIndex < FPointsCount then begin
        VPoint := FPoints[FSelectedPointIndex];
        if not PointIsEmpty(VPoint) then begin
          if LonLatPointInRect(VPoint, ARect) then begin
            VIndex := FSelectedPointIndex;
          end;
        end;
      end;
    end;

    if VIndex < 0 then begin
      for i := FPointsCount - 1 downto 0 do begin
        VPoint := FPoints[i];
        if not PointIsEmpty(VPoint) then begin
          if LonLatPointInRect(VPoint, ARect) then begin
            VIndex := i;
            Break;
          end;
        end;
      end;
    end;
    
    if VIndex >= 0 then begin
      if FSelectedPointIndex <> VIndex then begin
        FSelectedPointIndex := VIndex;
        _UpdateLineWithSelected;
      end;
      Result := True;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TLineOnMapEdit.SetSelectedNextPoint;
begin
  LockWrite;
  try
    if FSelectedPointIndex < FPointsCount then begin
      Inc(FSelectedPointIndex);
      _UpdateLineWithSelected;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TLineOnMapEdit.SetSelectedPoint(ASegmentIndex,
  APointIndex: Integer);
var
  i: Integer;
  VSegmentIndex: Integer;
  VPointIndex: Integer;
  VResult: Integer;
begin
  LockWrite;
  try
    VResult := -1;
    VSegmentIndex := 0;
    VPointIndex := 0;
    for i := 0 to FPointsCount - 1 do begin
      if VSegmentIndex = ASegmentIndex then begin
        if VPointIndex = APointIndex then begin
          VResult := i;
          Break;
        end;
      end;
      if PointIsEmpty(FPoints[i]) then begin
        Inc(VSegmentIndex);
        VPointIndex := 0;
      end else begin
        Inc(VPointIndex);
      end;
    end;
    if VResult >= 0 then begin
      if FSelectedPointIndex <> VResult then begin
        FSelectedPointIndex := VResult;
        _UpdateLineWithSelected;
      end;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TLineOnMapEdit.SetSelectedPrevPoint;
begin
  LockWrite;
  try
    if FSelectedPointIndex > 0 then begin
      Dec(FSelectedPointIndex);
      _UpdateLineWithSelected;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TLineOnMapEdit._GrowPoints(AAddCount: Integer);
var
  VSize: Integer;
begin
  VSize := Length(FPoints);
  if FPointsCount + AAddCount > VSize then begin
    if VSize < 64 then begin
      VSize := 64;
    end else if VSize < 1024 then begin
      VSize := VSize * 2;
    end else begin
      VSize := VSize + 1024;
    end;
    SetLength(FPoints, VSize);
  end;
end;

{ TPathOnMapEdit }

function TPathOnMapEdit.GetPath: ILonLatPathWithSelected;
begin
  LockRead;
  try
    Result := FLineWithSelected;
  finally
    UnlockRead;
  end;
end;

procedure TPathOnMapEdit.SetPath(AValue: ILonLatPathWithSelected);
var
  i: Integer;
  VLine: ILonLatPathLine;
begin
  LockWrite;
  try
    FSelectedPointIndex := - 1;
    FPointsCount := 0;
    for i := 0 to AValue.Count - 1 do begin
      VLine := AValue.Item[i];
      _GrowPoints(VLine.Count + 1);
      Move(VLine.Points[0], FPoints[FPointsCount], VLine.Count * SizeOf(TDoublePoint));
      if AValue.GetSelectedSegmentIndex = i then begin
        if AValue.GetSelectedPointIndex <= VLine.Count then begin
          FSelectedPointIndex := FPointsCount + AValue.GetSelectedPointIndex;
        end else begin
          FSelectedPointIndex := FPointsCount + VLine.Count - 1;
        end;
      end;
      Inc(FPointsCount, VLine.Count);
      FPoints[FPointsCount] := CEmptyDoublePoint;
      Inc(FPointsCount);
    end;
    if FPointsCount > 0 then begin
      Dec(FPointsCount);
    end;
    if FSelectedPointIndex < 0 then begin
      FSelectedPointIndex := FPointsCount - 1;
    end;
  finally
    UnlockWrite;
  end;
end;

function TPathOnMapEdit.IsEmpty: Boolean;
begin
  LockRead;
  try
    Result := FLine.Count > 0;
  finally
    UnlockRead;
  end;
end;

function TPathOnMapEdit.IsReady: Boolean;
begin
  LockRead;
  try
    Result := False;
    if FLine.Count > 0 then begin
      Result := FLine.Item[0].Count > 1;
    end;
  finally
    UnlockRead;
  end;
end;

procedure TPathOnMapEdit.SetPath(AValue: ILonLatPath);
var
  i: Integer;
  VLine: ILonLatPathLine;
begin
  LockWrite;
  try
    FPointsCount := 0;
    for i := 0 to AValue.Count - 1 do begin
      VLine := AValue.Item[i];
      _GrowPoints(VLine.Count + 1);
      Move(VLine.Points[0], FPoints[FPointsCount], VLine.Count * SizeOf(TDoublePoint));
      Inc(FPointsCount, VLine.Count);
      FPoints[FPointsCount] := CEmptyDoublePoint;
      Inc(FPointsCount);
    end;
    if FPointsCount > 0 then begin
      Dec(FPointsCount);
    end;
    FSelectedPointIndex := FPointsCount - 1;
  finally
    UnlockWrite;
  end;
end;

procedure TPathOnMapEdit._UpdateLineObject;
begin
  FLine := FFactory.CreateLonLatPath(@FPoints[0], FPointsCount);
  _UpdateLineWithSelected;
end;

procedure TPathOnMapEdit._UpdateLineWithSelected;
begin
  FLineWithSelected := TLonLatPathWithSelected.Create(FLine, FSelectedPointIndex);
  SetChanged;
end;

{ TPolygonOnMapEdit }

function TPolygonOnMapEdit.GetPolygon: ILonLatPolygonWithSelected;
begin
  LockRead;
  try
    Result := FLineWithSelected;
  finally
    UnlockRead;
  end;
end;

procedure TPolygonOnMapEdit.SetPolygon(AValue: ILonLatPolygonWithSelected);
var
  i: Integer;
  VLine: ILonLatPolygonLine;
begin
  LockWrite;
  try
    FSelectedPointIndex := - 1;
    FPointsCount := 0;
    for i := 0 to AValue.Count - 1 do begin
      VLine := AValue.Item[i];
      _GrowPoints(VLine.Count + 1);
      Move(VLine.Points[0], FPoints[FPointsCount], VLine.Count * SizeOf(TDoublePoint));
      if AValue.GetSelectedSegmentIndex = i then begin
        if AValue.GetSelectedPointIndex <= VLine.Count then begin
          FSelectedPointIndex := FPointsCount + AValue.GetSelectedPointIndex;
        end else begin
          FSelectedPointIndex := FPointsCount + VLine.Count - 1;
        end;
      end;
      Inc(FPointsCount, VLine.Count);
      FPoints[FPointsCount] := CEmptyDoublePoint;
      Inc(FPointsCount);
    end;
    if FPointsCount > 0 then begin
      Dec(FPointsCount);
    end;
    if FSelectedPointIndex < 0 then begin
      FSelectedPointIndex := FPointsCount - 1;
    end;
  finally
    UnlockWrite;
  end;
end;

function TPolygonOnMapEdit.IsEmpty: Boolean;
begin
  LockRead;
  try
    Result := FLine.Count > 0;
  finally
    UnlockRead;
  end;
end;

function TPolygonOnMapEdit.IsReady: Boolean;
begin
  LockRead;
  try
    Result := False;
    if FLine.Count > 0 then begin
      Result := FLine.Item[0].Count > 2;
    end;
  finally
    UnlockRead;
  end;
end;

procedure TPolygonOnMapEdit.SetPolygon(AValue: ILonLatPolygon);
var
  i: Integer;
  VLine: ILonLatPolygonLine;
begin
  LockWrite;
  try
    FPointsCount := 0;
    for i := 0 to AValue.Count - 1 do begin
      VLine := AValue.Item[i];
      _GrowPoints(VLine.Count + 1);
      Move(VLine.Points[0], FPoints[FPointsCount], VLine.Count * SizeOf(TDoublePoint));
      Inc(FPointsCount, VLine.Count);
      FPoints[FPointsCount] := CEmptyDoublePoint;
      Inc(FPointsCount);
    end;
    if FPointsCount > 0 then begin
      Dec(FPointsCount);
    end;
    FSelectedPointIndex := FPointsCount - 1;
  finally
    UnlockWrite;
  end;
end;

procedure TPolygonOnMapEdit._UpdateLineObject;
begin
  FLine := FFactory.CreateLonLatPolygon(@FPoints[0], FPointsCount);
  _UpdateLineWithSelected;
end;

procedure TPolygonOnMapEdit._UpdateLineWithSelected;
begin
  FLineWithSelected := TLonLatPolygonWithSelected.Create(FLine, FSelectedPointIndex);
  SetChanged;
end;

{ TLonLatLineWithSelectedBase }

constructor TLonLatLineWithSelectedBase.Create(ASelectedPoint: TDoublePoint;
  ASelectedSegmentIndex, ASelectedPointIndex: Integer);
begin
  FSelectedPoint := ASelectedPoint;
  FSelectedSegmentIndex := ASelectedSegmentIndex;
  FSelectedPointIndex := ASelectedPointIndex;
end;

function TLonLatLineWithSelectedBase.GetSelectedPoint: TDoublePoint;
begin
  Result := FSelectedPoint;
end;

function TLonLatLineWithSelectedBase.GetSelectedPointIndex: Integer;
begin
  Result := FSelectedPointIndex;
end;

function TLonLatLineWithSelectedBase.GetSelectedSegmentIndex: Integer;
begin
  Result := FSelectedSegmentIndex;
end;

{ TLonLatPathWithSelected }

constructor TLonLatPathWithSelected.Create(ALine: ILonLatPath;
  ASelectedPointIndex: Integer);
var
  VSelectedSegmentIndex: Integer;
  VSelectedPointIndex: Integer;
  VSelectedPoint: TDoublePoint;
  VLine: ILonLatPathLine;
  i: Integer;
  VPointExists: Boolean;
begin
  VSelectedSegmentIndex := 0;
  VSelectedPointIndex := ASelectedPointIndex;
  VPointExists := False;
  for i := 0 to ALine.Count - 1 do begin
    VLine := ALine.Item[i];
    if VSelectedPointIndex <= VLine.Count then begin
      VSelectedSegmentIndex := i;
      if VSelectedPointIndex = VLine.Count then begin
        VSelectedPoint := CEmptyDoublePoint;
      end else begin
        VSelectedPoint := VLine.Points[VSelectedPointIndex];
      end;
      VPointExists := True;
      Break;
    end else begin
      Dec(VSelectedPointIndex, VLine.Count);
      Dec(VSelectedPointIndex);
    end;
  end;
  if not VPointExists then begin
    VSelectedSegmentIndex := ALine.Count - 1;
    if VSelectedSegmentIndex >= 0 then begin
      VLine := ALine.Item[VSelectedSegmentIndex];
      VSelectedPointIndex := VLine.Count - 1;
      if VSelectedPointIndex >= 0 then begin
        VSelectedPoint := VLine.Points[VSelectedPointIndex];
      end else begin
        VSelectedPoint := CEmptyDoublePoint;
      end;
    end else begin
      VSelectedPointIndex := -1;
      VSelectedPoint := CEmptyDoublePoint;
    end;
  end;
  inherited Create(VSelectedPoint, VSelectedSegmentIndex, VSelectedPointIndex);
  FLine := ALine;
end;

function TLonLatPathWithSelected.CalcLength(ADatum: IDatum): Double;
begin
  Result := FLine.CalcLength(ADatum);
end;

function TLonLatPathWithSelected.GetBounds: TDoubleRect;
begin
  Result := FLine.Bounds;
end;

function TLonLatPathWithSelected.GetCount: Integer;
begin
  Result := FLine.Count;
end;

function TLonLatPathWithSelected.GetEnum: IEnumLonLatPoint;
begin
  Result := FLine.GetEnum;
end;

function TLonLatPathWithSelected.GetItem(AIndex: Integer): ILonLatPathLine;
begin
  Result := FLine.Item[AIndex];
end;

{ TLonLatPolygonWithSelected }

constructor TLonLatPolygonWithSelected.Create(ALine: ILonLatPolygon;
  ASelectedPointIndex: Integer);
var
  VSelectedSegmentIndex: Integer;
  VSelectedPointIndex: Integer;
  VSelectedPoint: TDoublePoint;
  VLine: ILonLatPolygonLine;
  i: Integer;
  VPointExists: Boolean;
begin
  VSelectedSegmentIndex := 0;
  VSelectedPointIndex := ASelectedPointIndex;
  VPointExists := False;
  for i := 0 to ALine.Count - 1 do begin
    VLine := ALine.Item[i];
    if VSelectedPointIndex <= VLine.Count then begin
      VSelectedSegmentIndex := i;
      if VSelectedPointIndex = VLine.Count then begin
        VSelectedPoint := CEmptyDoublePoint;
      end else begin
        VSelectedPoint := VLine.Points[VSelectedPointIndex];
      end;
      VPointExists := True;
      Break;
    end else begin
      Dec(VSelectedPointIndex, VLine.Count);
      Dec(VSelectedPointIndex);
    end;
  end;
  if not VPointExists then begin
    VSelectedSegmentIndex := ALine.Count - 1;
    if VSelectedSegmentIndex >= 0 then begin
      VLine := ALine.Item[VSelectedSegmentIndex];
      VSelectedPointIndex := VLine.Count - 1;
      if VSelectedPointIndex >= 0 then begin
        VSelectedPoint := VLine.Points[VSelectedPointIndex];
      end else begin
        VSelectedPoint := CEmptyDoublePoint;
      end;
    end else begin
      VSelectedPointIndex := -1;
      VSelectedPoint := CEmptyDoublePoint;
    end;
  end;
  inherited Create(VSelectedPoint, VSelectedSegmentIndex, VSelectedPointIndex);
  FLine := ALine;
end;

function TLonLatPolygonWithSelected.CalcArea(ADatum: IDatum): Double;
begin
  Result := FLine.CalcArea(ADatum);
end;

function TLonLatPolygonWithSelected.CalcPerimeter(ADatum: IDatum): Double;
begin
  Result := FLine.CalcPerimeter(ADatum);
end;

function TLonLatPolygonWithSelected.GetBounds: TDoubleRect;
begin
  Result := FLine.Bounds;
end;

function TLonLatPolygonWithSelected.GetCount: Integer;
begin
  Result := FLine.Count;
end;

function TLonLatPolygonWithSelected.GetEnum: IEnumLonLatPoint;
begin
  Result := FLine.GetEnum;
end;

function TLonLatPolygonWithSelected.GetItem(
  AIndex: Integer): ILonLatPolygonLine;
begin
  Result := FLine.Item[AIndex];
end;

end.

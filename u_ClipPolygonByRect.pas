unit u_ClipPolygonByRect;

interface

uses
  Types,
  t_GeoTypes;

type
  IPolyClip = interface
    ['{DD70326E-B6E0-4550-91B4-8AA974AD2DE5}']
    function Clip(const APoints: TDoublePointArray; APointsCount: Integer; var AResultPoints: TDoublePointArray): Integer;
  end;

  TPolyClipByLineAbstract = class(TInterfacedObject, IPolyClip)
  protected
    function GetPointCode(APoint: TDoublePoint): Byte; virtual; abstract;
    function GetIntersectPoint(APrevPoint,ACurrPoint: TDoublePoint): TDoublePoint; virtual; abstract;
  public
    function Clip(const APoints: TDoublePointArray; APointsCount: Integer; var AResultPoints: TDoublePointArray): Integer;
  end;

  TPolyClipByVerticalLine = class(TPolyClipByLineAbstract)
  protected
    FX: Double;
  protected
    function GetIntersectPoint(APrevPoint,ACurrPoint: TDoublePoint): TDoublePoint; override;
  public
    constructor Create(AX: Double);
  end;

  TPolyClipByLeftBorder = class(TPolyClipByVerticalLine)
  protected
    function GetPointCode(APoint: TDoublePoint): Byte; override;
  end;

  TPolyClipByRightBorder = class(TPolyClipByVerticalLine)
  protected
    function GetPointCode(APoint: TDoublePoint): Byte; override;
  end;

  TPolyClipByHorizontalLine = class(TPolyClipByLineAbstract)
  protected
    FY: Double;
  protected
    function GetIntersectPoint(APrevPoint,ACurrPoint: TDoublePoint): TDoublePoint; override;
  public
    constructor Create(AY: Double);
  end;

  TPolyClipByTopBorder = class(TPolyClipByHorizontalLine)
  protected
    function GetPointCode(APoint: TDoublePoint): Byte; override;
  end;

  TPolyClipByBottomBorder = class(TPolyClipByHorizontalLine)
  protected
    function GetPointCode(APoint: TDoublePoint): Byte; override;
  end;

  TPolyClipByRect = class(TInterfacedObject, IPolyClip)
  private
    FClipLeft: IPolyClip;
    FClipTop: IPolyClip;
    FClipRight: IPolyClip;
    FClipBottom: IPolyClip;
  public
    constructor Create(ARect: TRect);
    destructor Destroy; override;
    function Clip(const APoints: TDoublePointArray; APointsCount: Integer; var AResultPoints: TDoublePointArray): Integer;
  end;

implementation

uses
  SysUtils,
  Ugeofun;

{ TPolyClipByLineAbstract }

function TPolyClipByLineAbstract.Clip(const APoints: TDoublePointArray;
  APointsCount: Integer; var AResultPoints: TDoublePointArray): Integer;
var
  VPrevPoint: TDoublePoint;
  VPrevPointCode: Byte;
  VCurrPoint: TDoublePoint;
  VCurrPointCode: Byte;
  VLineCode: Byte;
  i: Integer;
  VIntersectPoint: TDoublePoint;
  VOutPointsCapacity: Integer;
begin
  Result := 0;
  if APointsCount > 0 then begin
    if Length(APoints)< APointsCount then begin
      raise EAccessViolation.Create('� ���������� ������� ������ ����� ��� ���������');
    end;
    VOutPointsCapacity := Length(AResultPoints);
    VCurrPoint := APoints[0];
    VCurrPointCode := GetPointCode(VCurrPoint);
    if APointsCount > 1 then begin
      for i := 1 to APointsCount - 1 do begin
        VPrevPoint := VCurrPoint;
        VPrevPointCode := VCurrPointCode;
        VCurrPoint := APoints[i];
        VCurrPointCode := GetPointCode(VCurrPoint);
        VLineCode := VPrevPointCode * 3 + VCurrPointCode;
        {
        ���   ���� ��� �����
        0:     ���-��� ���
        1:     ���-��  ��������
        2:     ���-��� �����,���
        3:     �� -��� ���
        4:     �� -��  ��������
        5:     �� -��� ��������
        6:     ���-��� ���������
        7:     ���-��  ��������
        8:     ���-��� ��������
        }
        case VLineCode of
          1, 4, 5, 7, 8: begin
            if Result = 0 then begin
              if Result >= VOutPointsCapacity then begin
                if VOutPointsCapacity  >= 32 then begin
                  VOutPointsCapacity := VOutPointsCapacity * 2;
                end else begin
                  VOutPointsCapacity := 32;
                end;
                SetLength(AResultPoints, VOutPointsCapacity);
              end;
              AResultPoints[Result] := VPrevPoint;
              Inc(Result);
            end;
            if Result >= VOutPointsCapacity then begin
              if VOutPointsCapacity  >= 32 then begin
                VOutPointsCapacity := VOutPointsCapacity * 2;
              end else begin
                VOutPointsCapacity := 32;
              end;
              SetLength(AResultPoints, VOutPointsCapacity);
            end;
            AResultPoints[Result] := VCurrPoint;
            Inc(Result);
          end;
          2: begin
            VIntersectPoint := GetIntersectPoint(VPrevPoint, VCurrPoint);
            if Result >= VOutPointsCapacity then begin
              if VOutPointsCapacity  >= 32 then begin
                VOutPointsCapacity := VOutPointsCapacity * 2;
              end else begin
                VOutPointsCapacity := 32;
              end;
              SetLength(AResultPoints, VOutPointsCapacity);
            end;
            AResultPoints[Result] := VIntersectPoint;
            Inc(Result);
            if Result >= VOutPointsCapacity then begin
              if VOutPointsCapacity  >= 32 then begin
                VOutPointsCapacity := VOutPointsCapacity * 2;
              end else begin
                VOutPointsCapacity := 32;
              end;
              SetLength(AResultPoints, VOutPointsCapacity);
            end;
            AResultPoints[Result] := VCurrPoint;
            Inc(Result);
          end;
          6: begin
            if Result = 0 then begin
              if Result >= VOutPointsCapacity then begin
                if VOutPointsCapacity  >= 32 then begin
                  VOutPointsCapacity := VOutPointsCapacity * 2;
                end else begin
                  VOutPointsCapacity := 32;
                end;
                SetLength(AResultPoints, VOutPointsCapacity);
              end;
              AResultPoints[Result] := VPrevPoint;
              Inc(Result);
            end;
            VIntersectPoint := GetIntersectPoint(VPrevPoint, VCurrPoint);
            if Result >= VOutPointsCapacity then begin
              if VOutPointsCapacity  >= 32 then begin
                VOutPointsCapacity := VOutPointsCapacity * 2;
              end else begin
                VOutPointsCapacity := 32;
              end;
              SetLength(AResultPoints, VOutPointsCapacity);
            end;
            AResultPoints[Result] := VIntersectPoint;
            Inc(Result);
          end;
        end;
      end;
      if Result > 0 then begin
        if compare2EP(APoints[0], APoints[APointsCount - 1]) then begin
          if not compare2EP(AResultPoints[0], AResultPoints[Result - 1]) then begin
            if Result >= VOutPointsCapacity then begin
              if VOutPointsCapacity  >= 32 then begin
                VOutPointsCapacity := VOutPointsCapacity * 2;
              end else begin
                VOutPointsCapacity := 32;
              end;
              SetLength(AResultPoints, VOutPointsCapacity);
            end;
            AResultPoints[Result] := AResultPoints[0];
            Inc(Result);
          end;
        end;
      end;
    end else begin
      if VCurrPointCode = 2 then begin
        if Result >= VOutPointsCapacity then begin
          VOutPointsCapacity := 1;
          SetLength(AResultPoints, VOutPointsCapacity);
        end;
        AResultPoints[Result] := VCurrPoint;
        Inc(Result);
      end;
    end;
  end;
end;

{ TPolyClipByVerticalLine }

constructor TPolyClipByVerticalLine.Create(AX: Double);
begin
  FX := AX;
end;

function TPolyClipByVerticalLine.GetIntersectPoint(APrevPoint,
  ACurrPoint: TDoublePoint): TDoublePoint;
begin
  Result.X := FX;
  Result.Y := (ACurrPoint.Y - APrevPoint.Y) / (ACurrPoint.X - APrevPoint.X) * (FX - APrevPoint.X) + APrevPoint.Y;
end;

{ TPolyClipByLeftBorder }

function TPolyClipByLeftBorder.GetPointCode(APoint: TDoublePoint): Byte;
begin
  if APoint.X < FX then begin
    Result := 0;
  end else if APoint.X > FX then begin
    Result := 2;
  end else begin
    Result := 1;
  end;
end;

{ TPolyClipByRightBorder }

function TPolyClipByRightBorder.GetPointCode(APoint: TDoublePoint): Byte;
begin
  if APoint.X > FX then begin
    Result := 0;
  end else if APoint.X < FX then begin
    Result := 2;
  end else begin
    Result := 1;
  end;
end;

{ TPolyClipByHorizontalLine }

constructor TPolyClipByHorizontalLine.Create(AY: Double);
begin
  FY := AY;
end;

function TPolyClipByHorizontalLine.GetIntersectPoint(APrevPoint,
  ACurrPoint: TDoublePoint): TDoublePoint;
begin
  Result.X := (ACurrPoint.X - APrevPoint.X) / (ACurrPoint.Y - APrevPoint.Y) * (FY - APrevPoint.Y) + APrevPoint.X;
  Result.Y := FY;
end;

{ TPolyClipByTopBorder }

function TPolyClipByTopBorder.GetPointCode(APoint: TDoublePoint): Byte;
begin
  if APoint.Y < FY then begin
    Result := 0;
  end else if APoint.Y > FY then begin
    Result := 2;
  end else begin
    Result := 1;
  end;
end;

{ TPolyClipByBottomBorder }

function TPolyClipByBottomBorder.GetPointCode(APoint: TDoublePoint): Byte;
begin
  if APoint.Y > FY then begin
    Result := 0;
  end else if APoint.Y < FY then begin
    Result := 2;
  end else begin
    Result := 1;
  end;
end;

{ TPolyClipByRect }

function TPolyClipByRect.Clip(const APoints: TDoublePointArray;
  APointsCount: Integer; var AResultPoints: TDoublePointArray): Integer;
var
  VTempArray: TDoublePointArray;
begin
  Result := 0;
  if APointsCount > 0 then begin
    SetLength(VTempArray, Length(AResultPoints));
    Result := FClipLeft.Clip(APoints, APointsCount, VTempArray);
    if Result > 0 then begin
      Result := FClipTop.Clip(VTempArray, Result, AResultPoints);
      if Result > 0 then begin
        Result := FClipRight.Clip(AResultPoints, Result, VTempArray);
        if Result > 0 then begin
          Result := FClipBottom.Clip(VTempArray, Result, AResultPoints);
        end;
      end;
    end;
  end;
end;

constructor TPolyClipByRect.Create(ARect: TRect);
begin
  FClipLeft := TPolyClipByLeftBorder.Create(ARect.Left);
  FClipTop := TPolyClipByTopBorder.Create(ARect.Top);
  FClipRight := TPolyClipByRightBorder.Create(ARect.Right);
  FClipBottom := TPolyClipByBottomBorder.Create(ARect.Bottom);
end;

destructor TPolyClipByRect.Destroy;
begin
  FClipLeft := nil;
  FClipTop := nil;
  FClipRight := nil;
  FClipBottom := nil;
  inherited;
end;

end.

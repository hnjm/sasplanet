{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2019, SAS.Planet development team.                      *}
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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_WindowLayerSunCalcTimeInfo;

interface

uses
  Types,
  GR32,
  GR32_Math,
  u_WindowLayerSunCalcInfoBase;

type
  TWindowLayerSunCalcTimeInfo = class(TWindowLayerSunCalcInfoBase)
  private
    FCaption: record
      Text: string;
      Bitmap: TBitmap32;
    end;
    procedure DrawCaption(ABuffer: TBitmap32; const ASunPoint: TPoint);
  protected
    procedure PaintLayer(ABuffer: TBitmap32); override;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;

implementation

uses
  Math,
  SysUtils,
  SunCalc,
  u_SunCalcDrawTools;

resourcestring
  rsAzimuth = 'Azimuth';
  rsAltitude = 'Altitude';

{ TWindowLayerSunCalcTimeInfo }

procedure TWindowLayerSunCalcTimeInfo.AfterConstruction;
begin
  inherited;
  FRepaintOnDayChange := True;
  FRepaintOnTimeChange := True;
  FRepaintOnLocationChange := True;
  FCaption.Text := '';
  FCaption.Bitmap := nil;
end;

destructor TWindowLayerSunCalcTimeInfo.Destroy;
begin
  FreeAndNil(FCaption.Bitmap);
  inherited;
end;

procedure TWindowLayerSunCalcTimeInfo.DrawCaption(
  ABuffer: TBitmap32;
  const ASunPoint: TPoint
);
var
  VSunPos: TSunPos;
  VAzimuth: string;
  VAltitude: string;
  VText: string;
  VRect: TRect;
  VTextSize: TSize;
begin
  VSunPos := SunCalc.GetPosition(FDateTime, FLocation.Y, FLocation.X);

  VAzimuth := Format('%.2f�', [RadToDeg(VSunPos.Azimuth + Pi)]);
  VAltitude := Format('%.2f�', [RadToDeg(VSunPos.Altitude)]);
  VText := Format('%s: %s; %s: %s', [rsAltitude, VAltitude, rsAzimuth, VAzimuth]);

  if not Assigned(FCaption.Bitmap) then begin
    FCaption.Bitmap := TBitmap32.Create;
  end;

  if FCaption.Text <> VText then begin
    FCaption.Text := VText;

    FCaption.Bitmap.Font.Size := FFont.FontSize;
    FCaption.Bitmap.Font.Name := FFont.FontName;
    FCaption.Bitmap.Font.Color := WinColor(FFont.TextColor);

    VTextSize := FCaption.Bitmap.TextExtent(FCaption.Text);

    FCaption.Bitmap.SetSize(VTextSize.cx + 8, VTextSize.cy + 4);

    FCaption.Bitmap.Clear(FColor.BgColor);
    FCaption.Bitmap.RenderText(4, 2, FCaption.Text, 0, FFont.TextColor);
    FCaption.Bitmap.DrawMode := dmBlend;
  end;

  VRect.Left := ASunPoint.X + 12;
  VRect.Top := ASunPoint.Y;
  VRect.Right := VRect.Left + FCaption.Bitmap.Width;
  VRect.Bottom := VRect.Top + FCaption.Bitmap.Height;

  if ABuffer.MeasuringMode then begin
    ABuffer.Changed(VRect);
  end else begin
    FCaption.Bitmap.DrawTo(ABuffer, VRect.Left, VRect.Top);
  end;
end;

procedure TWindowLayerSunCalcTimeInfo.PaintLayer(ABuffer: TBitmap32);
var
  VCenter: TFixedPoint;
  VSunPoint: TFixedPoint;
begin
  if not FShapesGenerator.IsIntersectScreenRect then begin
    Exit;
  end;

  ABuffer.BeginUpdate;
  try
    FShapesGenerator.ValidateCache;

    // Current time info
    FShapesGenerator.GetTimeInfoPoints(VSunPoint, VCenter);

    // Draw sun line
    if (VSunPoint.X > 0) and (VSunPoint.Y > 0) then begin
      ThickLine(ABuffer, VCenter, VSunPoint, FShapesColors.DayLineColor, 6);

      // Draw caption (Azimuth and Altitude info)
      if FSunCalcConfig.ShowCaptionNearSun then begin
        DrawCaption(ABuffer, GR32.Point(VSunPoint));
      end;
    end;
  finally
    ABuffer.EndUpdate;
    ABuffer.Changed;
  end;
end;

end.

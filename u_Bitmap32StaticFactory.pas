{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
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

unit u_Bitmap32StaticFactory;

interface

uses
  SysUtils,
  GR32,
  i_NotifierTime,
  i_Bitmap32Static,
  i_Bitmap32StaticFactory,
  u_BaseInterfacedObject;

type
  TBitmap32StaticFactory = class(TBaseInterfacedObject, IBitmap32StaticFactory)
  private
    FStandartSizePool: IObjectPoolBitmap32Standart;
    FFactorySimple: IBitmap32StaticFactory;
  private
    function Build(
      const ASize: TPoint;
      const AData: PColor32Array
    ): IBitmap32Static;
    function BuildEmpty(const ASize: TPoint): IBitmap32Static;
    function BuildEmptyClear(
      const ASize: TPoint;
      const AColor: TColor32
    ): IBitmap32Static;
  public
    constructor Create(
      const ATTLNotifier: INotifierTime;
      const ASync: IReadWriteSync
    );
  end;

implementation

uses
  Types,
  GR32_LowLevel,
  u_Bitmap32StaticFactorySimple,
  u_ObjectPoolBitmap32Standart;

{ TBitmap32StaticFactory }

constructor TBitmap32StaticFactory.Create(
  const ATTLNotifier: INotifierTime;
  const ASync: IReadWriteSync
);
begin
  inherited Create;
  FStandartSizePool :=
    TObjectPoolBitmap32Standart.Create(
      ATTLNotifier,
      ASync,
      100,
      200
    );
  FFactorySimple := TBitmap32StaticFactorySimple.Create;
end;

function TBitmap32StaticFactory.Build(const ASize: TPoint;
  const AData: PColor32Array): IBitmap32Static;
begin
  Assert(ASize.X > 0);
  Assert(ASize.Y > 0);
  Assert(ASize.X < 1 shl 16);
  Assert(ASize.Y < 1 shl 16);
  Assert(ASize.X * ASize.Y < 1 shl 28);
  Assert(AData <> nil);

  Result := BuildEmpty(ASize);
  if (Result <> nil) and (AData <> nil) then begin
    if AData <> nil then begin
      MoveLongWord(AData^, Result.Data^, ASize.X * ASize.Y);
    end;
  end;
end;

function TBitmap32StaticFactory.BuildEmpty(
  const ASize: TPoint
): IBitmap32Static;
var
  VStandartSize: TPoint;
begin
  VStandartSize := FStandartSizePool.Size;
  if (ASize.X = VStandartSize.X) and (ASize.Y = VStandartSize.Y) then begin
    Result := FStandartSizePool.Build;
  end else begin
    Result := FFactorySimple.BuildEmpty(ASize);
  end;
end;

function TBitmap32StaticFactory.BuildEmptyClear(
  const ASize: TPoint;
  const AColor: TColor32
): IBitmap32Static;
begin
  Result := BuildEmpty(ASize);
  if Result <> nil then begin
    FillLongword(Result.Data^, ASize.X * ASize.Y, AColor);
  end;
end;

end.

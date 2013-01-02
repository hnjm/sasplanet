{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
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

unit u_BitmapPostProcessingConfigStatic;

interface

uses
  GR32,
  i_Bitmap32Static,
  i_Bitmap32StaticFactory,
  i_BitmapPostProcessingConfig,
  u_BaseInterfacedObject;

type
  TComponentTable = array [0..255] of byte;

  TBitmapPostProcessingSimple = class(TBaseInterfacedObject, IBitmapPostProcessing)
  private
    function Process(const ABitmap: IBitmap32Static): IBitmap32Static;
  end;

  TBitmapPostProcessingByTable = class(TBaseInterfacedObject, IBitmapPostProcessing)
  private
    FBitmapFactory: IBitmap32StaticFactory;
    FTable: TComponentTable;
  private
    function Process(const ABitmap: IBitmap32Static): IBitmap32Static;
  public
    constructor Create(
      const ABitmapFactory: IBitmap32StaticFactory;
      const ATable: TComponentTable
    );
  end;

implementation

uses
  GR32_Filters,
  u_BitmapFunc,
  u_Bitmap32Static;

{ TBitmapPostProcessingSimple }

function TBitmapPostProcessingSimple.Process(
  const ABitmap: IBitmap32Static): IBitmap32Static;
begin
  Result := ABitmap;
end;

{ TBitmapPostProcessingByTable }

constructor TBitmapPostProcessingByTable.Create(
  const ABitmapFactory: IBitmap32StaticFactory;
  const ATable: TComponentTable
);
begin
  inherited Create;
  FBitmapFactory := ABitmapFactory;
  FTable := ATable;
end;

function TBitmapPostProcessingByTable.Process(
  const ABitmap: IBitmap32Static
): IBitmap32Static;
var
  i: Integer;
  VSize: TPoint;
  VSource: PColor32Array;
  VTarget: PColor32Array;
  VColorEntry: TColor32Entry;
begin
  Result := nil;
  if ABitmap <> nil then begin
    VSize := ABitmap.Size;
    Result := FBitmapFactory.BuildEmpty(VSize);
    if Result <> nil then begin
      VSource := ABitmap.Data;
      VTarget := Result.Data;
      for i := 0 to VSize.X * VSize.Y - 1 do begin
        VColorEntry.ARGB := VSource[i];
        VTarget[i] :=
          Color32(
            FTable[VColorEntry.R],
            FTable[VColorEntry.G],
            FTable[VColorEntry.B],
            VColorEntry.A
          );
      end;
    end;
  end;
end;

end.

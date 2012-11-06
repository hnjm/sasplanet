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

unit i_CoordConverterFactory;

interface

uses
  i_Datum,
  i_CoordConverter,
  i_ProjectionInfo,
  i_ConfigDataProvider;

type
  IDatumFactory = interface
    ['{6F33BA85-B340-44BE-BCCE-049216B2C472}']
    function GetByCode(ADatumEPSG: Integer): IDatum;
    function GetByRadius(const ARadiusA, ARadiusB: Double): IDatum;
  end;

  ICoordConverterFactory = interface
    ['{399F7734-B79E-44E0-9A5A-A6BA38E9125A}']
    function GetCoordConverterByConfig(const AConfig: IConfigDataProvider): ICoordConverter;
    function GetCoordConverterByCode(
      AProjectionEPSG: Integer;
      ATileSplitCode: Integer
    ): ICoordConverter;
  end;

  IProjectionInfoFactory = interface
    ['{81B33FFE-DD06-4817-8371-E3FC2F5BCAF2}']
    function GetByConverterAndZoom(
      const AGeoConverter: ICoordConverter;
      AZoom: Byte
    ): IProjectionInfo;
  end;

implementation

end.

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

unit i_BitmapLayerProvider;

interface

uses
  i_OperationNotifier,
  i_Bitmap32Static,
  i_LocalCoordConverter;

type
  IBitmapLayerProvider = interface
    ['{A4E2AEE1-1747-46F1-9836-173AFB62CCF9}']
    function GetBitmapRect(
      AOperationID: Integer;
      const ACancelNotifier: IOperationNotifier;
      const ALocalConverter: ILocalCoordConverter
    ): IBitmap32Static;
  end;

implementation

end.

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

unit u_UsedMarksConfigStatic;

interface

uses
  i_UsedMarksConfig;

type
  TUsedMarksConfigStatic = class(TInterfacedObject, IUsedMarksConfigStatic)
  private
    FIsUseMarks: Boolean;
    FIgnoreMarksVisible: Boolean;
    FIgnoreCategoriesVisible: Boolean;
  protected
    function GetIsUseMarks: Boolean;
    function GetIgnoreCategoriesVisible: Boolean;
    function GetIgnoreMarksVisible: Boolean;
  public
    constructor Create(
      AIsUseMarks: Boolean;
      AIgnoreMarksVisible: Boolean;
      AIgnoreCategoriesVisible: Boolean
    );
  end;

implementation

{ TUsedMarksConfigStatic }

constructor TUsedMarksConfigStatic.Create(AIsUseMarks, AIgnoreMarksVisible,
  AIgnoreCategoriesVisible: Boolean);
begin
  inherited Create;
  FIsUseMarks := AIsUseMarks;
  FIgnoreCategoriesVisible := AIgnoreCategoriesVisible;
  FIgnoreMarksVisible := AIgnoreMarksVisible;
end;

function TUsedMarksConfigStatic.GetIgnoreCategoriesVisible: Boolean;
begin
  Result := FIgnoreCategoriesVisible;
end;

function TUsedMarksConfigStatic.GetIgnoreMarksVisible: Boolean;
begin
  Result := FIgnoreMarksVisible;
end;

function TUsedMarksConfigStatic.GetIsUseMarks: Boolean;
begin
  Result := FIsUseMarks;
end;

end.

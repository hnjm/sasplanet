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

unit u_ConfigSaveLoadStrategyBasicUseProvider;

interface

uses
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_ConfigDataElement,
  i_ConfigSaveLoadStrategy;

type
  TConfigSaveLoadStrategyBasicUseProvider = class(TInterfacedObject, IConfigSaveLoadStrategy)
  protected
    procedure WriteConfig(
      AProvider: IConfigDataWriteProvider;
      AElement: IConfigDataElement
    );
    procedure ReadConfig(
      AProvider: IConfigDataProvider;
      AElement: IConfigDataElement
    );
  end;

implementation

{ TConfigSaveLoadStrategyBasicUseProvider }

procedure TConfigSaveLoadStrategyBasicUseProvider.ReadConfig(
  AProvider: IConfigDataProvider; AElement: IConfigDataElement);
begin
  AElement.ReadConfig(AProvider);
end;

procedure TConfigSaveLoadStrategyBasicUseProvider.WriteConfig(
  AProvider: IConfigDataWriteProvider; AElement: IConfigDataElement);
begin
  AElement.WriteConfig(AProvider);
end;

end.

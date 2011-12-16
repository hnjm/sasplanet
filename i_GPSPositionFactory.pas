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

unit i_GPSPositionFactory;

interface

uses
  ActiveX,
  t_GeoTypes,
  vsagps_public_base,
  vsagps_public_position,
  vsagps_public_events,
  i_GPS;

type
  IGPSPositionFactory = interface
    ['{542F6E48-EC4E-4C8D-9A53-8B392B0E8EA6}']
    function BuildSatelliteInfo(
      const AData: PSingleSatFixibilityData;
      const ASky: PSingleSatSkyData
    ): IGPSSatelliteInfo;

    function BuildSatellitesInViewEmpty: IGPSSatellitesInView;
    
    function BuildSatellitesInView(
      const AItemsCountGP: Integer;
      const AItemsGP: PUnknownList;
      const AItemsCountGL: Integer;
      const AItemsGL: PUnknownList
    ): IGPSSatellitesInView;

    function BuildPositionEmpty: IGPSPosition;
    function BuildPosition(
      const FSingleGPSData: PSingleGPSData;
      const ASatellites: IGPSSatellitesInView
    ): IGPSPosition;

    function ExecuteGPSCommand(Sender: TObject;
                               const AUnitIndex: Byte;
                               const ACommand: LongInt;
                               const APointer: Pointer): String;
    procedure SetExecuteGPSCommandHandler(AExecuteGPSCommandEvent: TExecuteGPSCommandEvent);

    procedure SetGPSUnitInfoChangedHandler(AGPSUnitInfoChangedEvent: TVSAGPS_UNIT_INFO_Changed_Event);
    function GetGPSUnitInfoChangedHandler: TVSAGPS_UNIT_INFO_Changed_Event;
    property GPSUnitInfoChangedHandler: TVSAGPS_UNIT_INFO_Changed_Event read GetGPSUnitInfoChangedHandler write SetGPSUnitInfoChangedHandler;
  end;

implementation

end.

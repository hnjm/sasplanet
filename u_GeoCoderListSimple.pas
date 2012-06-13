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

unit u_GeoCoderListSimple;

interface

uses
  i_TTLCheckNotifier,
  i_InetConfig,
  i_DownloadResultFactory,
  i_ValueToStringConverter,
  u_GeoCoderListBase;

type
  TGeoCoderListSimple = class(TGeoCoderListBase)
  public
    constructor Create(
      const AInetConfig: IInetConfig;
      const AGCList: ITTLCheckNotifier;
      const AResultFactory: IDownloadResultFactory;
      const AValueToStringConverterConfig: IValueToStringConverterConfig
    );
  end;
implementation

uses
  c_GeoCoderGUIDSimple,
  i_GeoCoderList,
  u_GeoCoderListEntity,
  u_GeoCoderByGoogle,
  u_GeoCoderByYandex,
  u_GeoCoderBy2GIS,
  u_GeoCoderByOSM,
  u_GeoCoderByWikiMapia,
  u_GeoCoderByRosreestr,
  u_GeoCoderByNavitel,
  u_GeoCoderByURL,
  u_GeoCoderByPolishMap,
  u_GeoCoderByTXT;

{ TGeoCoderListSimple }

constructor TGeoCoderListSimple.Create(
  const AInetConfig: IInetConfig;
  const AGCList: ITTLCheckNotifier;
  const AResultFactory: IDownloadResultFactory;
  const AValueToStringConverterConfig: IValueToStringConverterConfig
);
var
  VItem: IGeoCoderListEntity;
begin
  inherited Create;
  VItem :=
    TGeoCoderListEntity.Create(
      CGeoCoderGoogleGUID,
      'Google',
      TGeoCoderByGoogle.Create(AInetConfig, AGCList, AResultFactory)
    );
  Add(VItem);

  VItem :=
    TGeoCoderListEntity.Create(
      CGeoCoderYandexGUID,
      'Yandex',
      TGeoCoderByYandex.Create(AInetConfig, AGCList, AResultFactory)
    );
  Add(VItem);

  VItem :=
    TGeoCoderListEntity.Create(
      CGeoCoder2GISGUID,
      '2GIS',
      TGeoCoderBy2GIS.Create(AInetConfig, AGCList, AResultFactory)
    );
  Add(VItem);

  VItem :=
    TGeoCoderListEntity.Create(
      CGeoCoderOSMGUID,
      'OSM',
      TGeoCoderByOSM.Create(AInetConfig, AGCList, AResultFactory)
    );
  Add(VItem);

  VItem :=
    TGeoCoderListEntity.Create(
      CGeoCoderWikiMapiaGUID,
      'WikiMapia',
      TGeoCoderByWikiMapia.Create(AInetConfig, AGCList, AResultFactory)
    );
  Add(VItem);

  VItem :=
    TGeoCoderListEntity.Create(
      CGeoCoderRosreestrGUID,
      'Rosreestr',
      TGeoCoderByRosreestr.Create(AInetConfig, AGCList, AResultFactory)
    );
  Add(VItem);

  VItem :=
    TGeoCoderListEntity.Create(
      CGeoCoderNavitelGUID,
      'Navitel',
      TGeoCoderByNavitel.Create(AInetConfig, AGCList, AResultFactory)
    );
  Add(VItem);

  VItem :=
    TGeoCoderListEntity.Create(
      CGeoCoderURLGUID,
      'Link and URL',
      TGeoCoderByURL.Create(AInetConfig, AGCList, AResultFactory, AValueToStringConverterConfig)
    );
  Add(VItem);

  try
  VItem :=
    TGeoCoderListEntity.Create(
      CGeoCoderPolishMapGUID,
      'Offline search (*.mp)',
      TGeoCoderByPolishMap.Create()
    );
  Add(VItem);
  Except
  end;

  try
  VItem :=
    TGeoCoderListEntity.Create(
      CGeoCoderGeoNamesTXTGUID,
      'Offline search (*.txt)',
      TGeoCoderByTXT.Create()
    );
  Add(VItem);
  Except
  end;

end;

end.

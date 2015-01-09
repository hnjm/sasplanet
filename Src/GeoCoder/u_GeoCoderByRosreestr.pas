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

unit u_GeoCoderByRosreestr;

interface

uses
  Classes,
  i_InterfaceListSimple,
  i_InetConfig,
  i_DownloadResult,
  i_DownloadRequest,
  i_NotifierTime,
  i_NotifierOperation,
  i_GeoCoder,
  i_LocalCoordConverter,
  i_VectorItemSubsetBuilder,
  i_DownloadResultFactory,
  i_ValueToStringConverter,
  u_GeoCoderBasic;

type
  TGeoCoderByRosreestr = class(TGeoCoderBasic)
  private
    FValueToStringConverter: IValueToStringConverterChangeable;
  protected
    function PrepareRequest(
      const ASearch: WideString;
      const ALocalConverter: ILocalCoordConverter
    ): IDownloadRequest; override;
    function ParseResultToPlacemarksList(
      const ACancelNotifier: INotifierOperation;
      AOperationID: Integer;
      const AResult: IDownloadResultOk;
      const ASearch: WideString;
      const ALocalConverter: ILocalCoordConverter
    ): IInterfaceListSimple; override;
  public
    constructor Create(
      const AInetSettings: IInetConfig;
      const AGCNotifier: INotifierTime;
      const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
      const APlacemarkFactory: IGeoCodePlacemarkFactory;
      const AResultFactory: IDownloadResultFactory;
      const AValueToStringConverter: IValueToStringConverterChangeable
    );

  end;

implementation

uses
  SysUtils,
  StrUtils,
  ALString,
  RegExprUtils,
  t_GeoTypes,
  i_VectorDataItemSimple,
  i_CoordConverter,
  u_InterfaceListSimple,
  u_ResStrings;

{ TGeoCoderByRosreestr }

procedure meters_to_lonlat(
  in_x, in_y: Double;
  out outout: TDoublePoint
);
begin
  outout.X := in_X / 6378137 * 180 / Pi;
  outout.Y := ((arctan(exp(in_Y / 6378137)) - Pi / 4) * 360) / Pi;
end;

function GetBetween(
  const ASTR, AFrom, ATo: AnsiString;
  var VRes: AnsiString;
  APtr: integer
): integer;
var
  i, j: integer;
begin
  i := ALPosEx(AFrom, ASTR, Aptr);
  if i > 0 then begin
    j := ALPosEx(ATo, ASTR, i + length(AFrom));
    if j > i then begin
      VRes := Copy(AStr, i + Length(AFrom), j - (i + length(AFrom)));
      Result := j;
    end else begin
      VRes := '';
      Result := Aptr;
    end;
  end else begin
    VRes := '';
    Result := Aptr;
  end;
end;

constructor TGeoCoderByRosreestr.Create(
  const AInetSettings: IInetConfig;
  const AGCNotifier: INotifierTime;
  const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
  const APlacemarkFactory: IGeoCodePlacemarkFactory;
  const AResultFactory: IDownloadResultFactory;
  const AValueToStringConverter: IValueToStringConverterChangeable
);
begin
  inherited Create(
    AInetSettings,
    AGCNotifier,
    AVectorItemSubsetBuilderFactory,
    APlacemarkFactory,
    AResultFactory
  );
  FValueToStringConverter := AValueToStringConverter;
end;


function TGeoCoderByRosreestr.ParseResultToPlacemarksList(
  const ACancelNotifier: INotifierOperation;
  AOperationID: Integer;
  const AResult: IDownloadResultOk;
  const ASearch: WideString;
  const ALocalConverter: ILocalCoordConverter
): IInterfaceListSimple;
var
  slat, slon: AnsiString;
  sname, sdesc, sfulldesc, VtempString: string;
  i, j: integer;
  VPoint: TDoublePoint;
  VPlace: IVectorDataItem;
  VList: IInterfaceListSimple;
  VFormatSettings: TALFormatSettings;
  VValueConverter: IValueToStringConverter;
  VStr: AnsiString;
  VTemp: AnsiString;
  VTemp1: AnsiString;
begin
  VValueConverter := FValueToStringConverter.GetStatic;
  sfulldesc := '';
  sdesc := '';
  VtempString := '';

  if AResult.Data.Size <= 0 then begin
    raise EParserError.Create(SAS_ERR_EmptyServerResponse);
  end;
  SetLength(Vstr, AResult.Data.Size);
  Move(AResult.Data.Buffer^, Vstr[1], AResult.Data.Size);
  VFormatSettings.DecimalSeparator := '.';
  VList := TInterfaceListSimple.Create;
  i := ALPosEx('_jsonpCallback', VStr);
  VStr := ALStringReplace(VStr, '\"', '''', [rfReplaceAll]);
  VStr := ALStringReplace(VStr, '\/', '/', [rfReplaceAll]);
  VStr := ALStringReplace(VStr, '&quot;', '''', [rfReplaceAll]);

  //�� ������������ ������
  while (ALPosEx('{"attributes"', VStr, i) > i) and (i > 0) do begin
    j := ALPosEx('{"attributes"', VStr, i);
    sdesc := '';
    sname := '';
    j := GetBetween(Vstr, '"CAD_NUM":"', '"', VTemp, j);
    sname := string(VTemp);

    j := GetBetween(Vstr, '"OBJECT_ADDRESS":"', '"', VTemp, j);
    sdesc := Utf8ToAnsi(VTemp);

    if sdesc = '' then begin
      j := GetBetween(Vstr, '"OBJECT_PLACE":"', '"', VTemp, j);
      j := GetBetween(Vstr, '"OBJECT_LOCALITY":"', '"', VTemp1, j);
      sdesc := Utf8ToAnsi(VTemp + ' ' + VTemp1);
    end;

    j := GetBetween(Vstr, '"XC":', ',', slon, j);
    j := GetBetween(Vstr, '"YC":', ',', slat, j);

    try
      meters_to_lonlat(ALStrToFloat(slon, VFormatSettings), ALStrToFloat(slat, VFormatSettings), Vpoint);
    except
      raise EParserError.CreateFmt(SAS_ERR_CoordParseError, [slat, slon]);
    end;
    i := (ALPosEx('}}', VStr, j));
    sdesc := sdesc + #$D#$A + '[ ' + VValueConverter.LonLatConvert(VPoint) + ' ]';
    sfulldesc := ReplaceStr(sname + #$D#$A + sdesc, #$D#$A, '<br>');
    VPlace := PlacemarkFactory.Build(VPoint, sname, sdesc, sfulldesc, 4);
    VList.Add(VPlace);
  end;

  // �� ������������
  while (ALPosEx('address', VStr, i) > i) and (i > 0) do begin
    j := i;

    i := ALPosEx('"address":"', VStr, j);
    j := ALPosEx('"', VStr, i + 11);
    sname := Utf8ToAnsi(Copy(VStr, i + 11, j - (i + 11)));

    i := ALPosEx('"x":', VStr, j);
    j := ALPosEx('.', VStr, i + 4);
    slon := Copy(VStr, i + 4, j - (i + 4));

    i := ALPosEx('"y":', VStr, j);
    j := ALPosEx('.', VStr, i + 4);
    slat := Copy(VStr, i + 4, j - (i + 4));

    i := ALPosEx('"ParentName":"', VStr, j);
    j := ALPosEx('"', VStr, i + 14);
    sdesc := Utf8ToAnsi(Copy(VStr, i + 14, j - (i + 14)));
    try
      meters_to_lonlat(ALStrToFloat(slon, VFormatSettings), ALStrToFloat(slat, VFormatSettings), Vpoint);
    except
      raise EParserError.CreateFmt(SAS_ERR_CoordParseError, [slat, slon]);
    end;
    i := (ALPosEx('}}', VStr, i));
    sdesc := sdesc + #$D#$A + '[ ' + VValueConverter.LonLatConvert(VPoint) + ' ]';
    sfulldesc := ReplaceStr(sname + #$D#$A + sdesc, #$D#$A, '<br>');
    VPlace := PlacemarkFactory.Build(VPoint, sname, sdesc, sfulldesc, 4);
    VList.Add(VPlace);
  end;
  Result := VList;
end;

function TGeoCoderByRosreestr.PrepareRequest(
  const ASearch: WideString;
  const ALocalConverter: ILocalCoordConverter
): IDownloadRequest;
var
  VSearch: AnsiString;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMapRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
  i: integer;
  s1, s2, s3, s4: AnsiString;
  i1, i2, i3, i4: integer;
begin
  VSearch := AnsiString(ASearch);
  VConverter := ALocalConverter.GetGeoConverter;
  VZoom := ALocalConverter.GetZoom;
  VMapRect := ALocalConverter.GetRectInMapPixelFloat;
  VConverter.ValidatePixelRectFloat(VMapRect, VZoom);
  VLonLatRect := VConverter.PixelRectFloat2LonLatRect(VMapRect, VZoom);
  VSearch := ALStringReplace(ALStringReplace(VSearch, '*', '', [rfReplaceAll]), ':', '', [rfReplaceAll]);// ������� * � : �� ������ ������������ ������

  if '' = RegExprReplaceMatchSubStr(VSearch, '[0-9]', '') then begin //cadastre number
    VSearch := AnsiString(ASearch);
    i := ALPosEx(':', VSearch, 1);
    s1 := copy(VSearch, 1, i - 1);
    VSearch := copy(VSearch, i + 1, length(VSearch) - i + 1);
    i1 := ALStrToInt(s1);

    i := ALPosEx(':', VSearch, 1);
    s2 := copy(VSearch, 1, i - 1);
    VSearch := copy(VSearch, i + 1, length(VSearch) - i + 1);
    i2 := ALStrToInt(s2);

    i := ALPosEx(':', VSearch, 1);
    if i = 0 then begin
      i := length(VSearch) + 1;
    end;
    s3 := copy(VSearch, 1, i - 1);
    VSearch := copy(VSearch, i + 1, length(VSearch) - i + 1);
    try
      i3 := ALStrToInt(s3);
    except
      i3 := 0;
    end;

    s4 := VSearch;
    try
      i4 := ALStrToInt(s4);
    except
      i4 := 0;
    end;

    if ('' = RegExprReplaceMatchSubStr(s1, '[0-9]', '')) and (i1 > 0) then begin
      while length(s1) < 2 do begin
        s1 := '0' + s1;
      end;
    end;
    if ('' = RegExprReplaceMatchSubStr(s2, '[0-9]', '')) and (i2 > 0) then begin
      while length(s2) < 2 do begin
        s2 := '0' + s2;
      end;
    end;
    if ('' = RegExprReplaceMatchSubStr(s3, '[0-9]', '')) and (i3 > 0) then begin
      while length(s3) < 7 do begin
        s3 := '0' + s3;
      end;
    end;
    if ('' = RegExprReplaceMatchSubStr(s4, '[0-9]', '')) and (i4 > 0) then begin
      while length(s4) < 5 do begin
        s4 := '0' + s4;
      end;
    end;

    VSearch := s1 + s2 + s3 + s4;

    if ALPosEx('*', VSearch, 1) > 0 then begin
      VSearch := ALStringReplace(VSearch, '*', '', [rfReplaceAll]);// ������� * �� ������ ������������ ������
      Result :=
        PrepareRequestByURL(
          'http://maps.rosreestr.ru/arcgis/rest/services/Cadastre/CadastreSelected/MapServer/exts/GKNServiceExtension/online/parcel/find?cadNum=' + URLEncode(AnsiToUtf8(ASearch)) + '&onlyAttributes=false&returnGeometry=true&f=json&callback=dojo.io.script.jsonp_dojoIoScript24._jsonpCallback'
        );
    end else if i4 = 0 then // ��������
    begin
      Result :=
        PrepareRequestByURL(
          'http://maps.rosreestr.ru/arcgis/rest/services/Cadastre/CadastreSelected/MapServer/2/query?f=json&where=PKK_ID%20like%20''' + URLEncode(AnsiToUtf8(VSearch)) + '%25''&returnGeometry=true&spatialRel=esriSpatialRelIntersects&outFields=*&callback=dojo.io.script.jsonp_dojoIoScript21._jsonpCallback'
        );
    end else // �������
    begin
      Result :=
        PrepareRequestByURL(
          'http://maps.rosreestr.ru/arcgis/rest/services/Cadastre/CadastreSelected/MapServer/exts/GKNServiceExtension/online/parcel/find?cadNum=' + URLEncode(AnsiToUtf8(ASearch)) + '&onlyAttributes=false&returnGeometry=true&f=json&callback=dojo.io.script.jsonp_dojoIoScript16._jsonpCallback'
        );
    end;

  end else begin //name
    Result :=
      PrepareRequestByURL(
        'http://maps.rosreestr.ru/arcgis/rest/services/Address/Locator_Composite/GeocodeServer/findAddressCandidates?SingleLine=' + URLEncode(AnsiToUtf8(ASearch)) + '&f=json&outFields=*&callback=dojo.io.script.jsonp_dojoIoScript21._jsonpCallback'
      );
  end;
end;

end.
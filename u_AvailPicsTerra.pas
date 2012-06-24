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

unit u_AvailPicsTerra;

interface

uses
  SysUtils,
  Classes,
  u_AvailPicsAbstract;

type
  TAvailPicsTerraserver = class(TAvailPicsAbstract)
  public
    function ContentType: String; override;

    function ParseResponse(const AStream: TMemoryStream): Integer; override;

    function LinkToImages: String; override;
  end;

implementation

uses
  u_GeoToStr,
  u_TileRequestBuilderHelpers;

function _RandInt5: String;
var i: Integer;
begin
  // returns integer value as string[5]
  i := 20000 + Random(60000);
  Result := IntToStr(i);
end;

{ TAvailPicsTerraserver }

function TAvailPicsTerraserver.ContentType: String;
begin
  Result := 'text/html';
end;

function TAvailPicsTerraserver.LinkToImages: String;
//var VZoom: Byte;
begin
  //VZoom := FTileInfoPtr.Zoom;
  //AdjustMinimalHiResZoom(VZoom);
  // use decremented zoom here!

  // http://www.terraserver.com/view_frm.asp?cx=56.75&cy=60.94&mpp=5&proj=4326&pic=img&prov=-1&stac=-1&ovrl=-1&drwl=&lgin=28374&styp=&vic=
  Result := 'http://www.terraserver.com/view_frm.asp?' +
            'cx=' + RoundEx(FTileInfoPtr.LonLat.X, 4) +
            '&cy=' + RoundEx(FTileInfoPtr.LonLat.Y, 4) +
            '&mpp=5' +
            '&proj=4326&pic=img&prov=-1&stac=-1&ovrl=-1&drwl=' +
            '&lgin=' + _RandInt5 +
            '&styp=&vic=';
end;

function TAvailPicsTerraserver.ParseResponse(const AStream: TMemoryStream): Integer;

  function _ConvertToYYYYMMDD(const AText, ASep: String): String;
  var
    VSepPos: Integer;
    Vyyyy, Vmm, Vdd: String;
  begin
    Result := '';
    Vmm := '';
    Vdd := '';
    Vyyyy := AText;
    
    // get m[m]
    VSepPos := System.Pos(ASep, Vyyyy);
    if VSepPos>0 then begin
      Vmm := System.Copy(Vyyyy, 1, VSepPos-1);
      System.Delete(Vyyyy, 1, VSepPos);
      while Length(Vmm)<2 do
        Vmm := '0' + Vmm;
    end;

    // get d[d]
    VSepPos := System.Pos(ASep, Vyyyy);
    if VSepPos>0 then begin
      Vdd := System.Copy(Vyyyy, 1, VSepPos-1);
      System.Delete(Vyyyy, 1, VSepPos);
      while Length(Vdd)<2 do
        Vdd := '0' + Vdd;
    end;
    
    // check all parts
    if TryStrToInt(Vyyyy, VSepPos) then
    if TryStrToInt(Vmm, VSepPos) then
    if TryStrToInt(Vdd, VSepPos) then begin
      // ok
      Result := Vyyyy + DateSeparator + Vmm + DateSeparator + Vdd;
    end;
  end;

  function _ProcessOption(const AOptionText: String;
                          var AParams: TStrings): Boolean;
  var
    //VText: String;
    VDate: String;
    VValue: String;
    VLayer: String;
    VSep: String; // actual separator
    VPos: Integer;
  begin
    // value='dg,4c0512fac553a1d9cf226b003610efad'  selected='selected'  >5/22/2011
    VValue := AnsiLowerCase(Trim(GetAfter('>', AOptionText)));

    // try convert to date (m[m]/d[d]/yyyy)
    if (Length(VValue) in [8..10]) then begin
      // find separator
      VSep := '/';
      VPos := System.Pos(VSep, VValue);
      if (VPos>0) then begin
        // sep defined
        VDate := _ConvertToYYYYMMDD(VValue, VSep);
      end else begin
        // lookup sep
        VPos := 1;
        VSep := '';
        while (VPos <= Length(VValue)) do begin
          if (VValue[VPos] in ['0','1'..'9']) then
            Inc(VPos)
          else begin
            // found
            VSep := VValue[VPos];
            break;
          end;
        end;

        // if found
        if (0<Length(VSep)) then begin
          VDate := _ConvertToYYYYMMDD(VValue, VSep);
        end else begin
          // no date
          VDate := VValue;
        end;
      end;
    end else begin
      // no date
      VDate := VValue;
    end;

    // get parts of value=
    VValue := GetAfter('value=', AOptionText);
    VValue := GetBetween(VValue, '''', '''');
    VLayer := GetAfter(',', VValue);
    VValue := GetBefore(',', VValue);

    // make params
    if (nil=AParams) then
      AParams := TStringList.Create
    else
      AParams.Clear;
    // add
    AParams.Values['date'] := VDate;
    AParams.Values['layer'] := VLayer;
    AParams.Values['provider'] := VValue;

    // call
    Result := FTileInfoPtr.AddImageProc(Self, VDate, 'Terraserver', AParams);
  end;

var
  VResponse: TStringList;
  VSLParams: TStrings;
  S: String;
begin
  Result:=0;

  if (not Assigned(FTileInfoPtr.AddImageProc)) then
    Exit;

  if (nil=AStream) or (0=AStream.Size) then
    Exit;

  // search for:
  // <option value='dg,4c0512fac553a1d9cf226b003610efad'  selected='selected'  >5/22/2011</option>
  // <option value='dg,f09a1d6be635f037f9b2a079ea57040b'  >7/19/2010</option>
  VSLParams := nil;
  VResponse := TStringList.Create;
  try
    VResponse.LoadFromStream(AStream);

    while (VResponse.Count>0) do begin
      S := Trim(VResponse[0]);
      S := GetBetween(S, '<option', '</option>');
      if Length(S)>0 then begin
        // got  value='dg,4c0512fac553a1d9cf226b003610efad'  selected='selected'  >5/22/2011
        // provider = dg
        // layer = 4c0512fac553a1d9cf226b003610efad
        // date = 5/22/2011
        if _ProcessOption(Trim(S), VSLParams) then
          Inc(Result);
      end;

      // skip this line
      VResponse.Delete(0);
    end;
  finally
    FreeAndNil(VResponse);
    FreeAndNil(VSLParams);
  end;
end;

end.

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

unit u_PathDetalizeProviderMailRu;

interface

uses
  t_GeoTypes,
  i_LanguageManager,
  i_ProxySettings,
  u_PathDetalizeProviderListEntity;

type
  TPathDetalizeProviderMailRu = class(TPathDetalizeProviderListEntity)
  private
    FBaseUrl: string;
    FProxyConfig: IProxyConfig;

    function SecondToTime(const Seconds: Cardinal): Double;
  protected { IPathDetalizeProvider }
    function GetPath(ASource: TArrayOfDoublePoint; var AComment: string): TArrayOfDoublePoint; override;
  public
    constructor Create(
      AGUID: TGUID;
      ALanguageManager: ILanguageManager;
      AProxyConfig: IProxyConfig;
      ABaseUrl: string
    );
  end;

type
  TPathDetalizeProviderMailRuShortest = class(TPathDetalizeProviderMailRu)
  protected
    function GetCaptionTranslated: string; override;
    function GetDescriptionTranslated: string; override;
    function GetMenuItemNameTranslated: string; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AProxyConfig: IProxyConfig
    );
  end;

type
  TPathDetalizeProviderMailRuFastest = class(TPathDetalizeProviderMailRu)
  protected
    function GetCaptionTranslated: string; override;
    function GetDescriptionTranslated: string; override;
    function GetMenuItemNameTranslated: string; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AProxyConfig: IProxyConfig
    );
  end;

type
  TPathDetalizeProviderMailRuFastestWithTraffic = class(TPathDetalizeProviderMailRu)
  protected
    function GetCaptionTranslated: string; override;
    function GetDescriptionTranslated: string; override;
    function GetMenuItemNameTranslated: string; override;
  public
    constructor Create(
      ALanguageManager: ILanguageManager;
      AProxyConfig: IProxyConfig
    );
  end;

implementation

uses
  Classes,
  SysUtils,
  StrUtils,
  DateUtils,
  gnugettext,
  c_PathDetalizeProvidersGUID,
  u_GeoToStr,
  u_ResStrings,
  frm_InvisibleBrowser;

{ TPathDetalizeProviderMailRu }

constructor TPathDetalizeProviderMailRu.Create(
  AGUID: TGUID;
  ALanguageManager: ILanguageManager;
  AProxyConfig: IProxyConfig;
  ABaseUrl: string
);
begin
  inherited Create(AGUID, ALanguageManager);
  FBaseUrl := ABaseUrl;
  FProxyConfig := AProxyConfig;
end;

function TPathDetalizeProviderMailRu.GetPath(ASource: TArrayOfDoublePoint;
  var AComment: string): TArrayOfDoublePoint;
var ms:TMemoryStream;
    pathstr,timeT1:string;
    url:string;
    i,posit,posit2,endpos,dd,seconds,meters:integer;
    dateT1:TDateTime;
begin
  url := FBaseUrl;
  for i:=0 to length(ASource)-1 do begin
    url:=url+'&x'+inttostr(i)+'='+R2StrPoint(ASource[i].x)+'&y'+inttostr(i)+'='+R2StrPoint(ASource[i].y);
  end;
  ms:=TMemoryStream.Create;
  try
    if GetStreamFromURL(ms,url,'text/javascript; charset=utf-8', FProxyConfig.GetStatic)>0 then begin
      ms.Position:=0;
      SetLength(pathstr, ms.Size);
      ms.ReadBuffer(pathstr[1], ms.Size);
      SetLength(Result,0);
      meters:=0;
      seconds:=0;

      try
        posit:=PosEx('"totalLength"',pathstr,1);
        While (posit>0) do begin
          try
            posit2:=PosEx('"',pathstr,posit+17);
            meters:=meters+strtoint(copy(pathstr,posit+17,posit2-(posit+17)));
            posit:=PosEx('"totalTime"',pathstr,posit);
            posit2:=PosEx('"',pathstr,posit+15);
            seconds:=seconds+strtoint(copy(pathstr,posit+15,posit2-(posit+15)));
          except
          end;
          posit:=PosEx('"points"',pathstr,posit);
          endpos:=PosEx(']',pathstr,posit);
          while (posit>0)and(posit<endpos) do begin
            try
              SetLength(Result,length(Result)+1);
              posit:=PosEx('"x" : "',pathstr,posit);
              posit2:=PosEx('", "y" : "',pathstr,posit);
              Result[length(Result)-1].X:=str2r(copy(pathstr,posit+7,posit2-(posit+7)));
              posit:=PosEx('"',pathstr,posit2+10);
              Result[length(Result)-1].y:=str2r(copy(pathstr,posit2+10,posit-(posit2+10)));
              posit:=PosEx('{',pathstr,posit);
            except
              SetLength(Result,length(Result)-1);
            end;
          end;
          posit:=PosEx('"totalLength"',pathstr,posit);
        end;
      except
      end;

      if meters>1000 then begin
        AComment:=SAS_STR_MarshLen+RoundEx(meters/1000,2)+' '+SAS_UNITS_km;
      end else begin
        AComment:=SAS_STR_MarshLen+inttostr(meters)+' '+SAS_UNITS_m;
      end;
      DateT1:=SecondToTime(seconds);
      dd:=DaysBetween(0,DateT1);
      timeT1:='';
      if dd>0 then begin
        timeT1:=inttostr(dd)+' ����, ';
      end;
      timeT1:=timeT1+TimeToStr(DateT1);
      AComment:=AComment+#13#10+SAS_STR_Marshtime+timeT1;
    end;
  finally
    ms.Free;
  end;
end;

function TPathDetalizeProviderMailRu.SecondToTime(
  const Seconds: Cardinal): Double;
const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;
var
  ms, ss, mm, hh, dd: Cardinal;
begin
  dd := Seconds div SecPerDay;
  hh := (Seconds mod SecPerDay) div SecPerHour;
  mm := ((Seconds mod SecPerDay) mod SecPerHour) div SecPerMinute;
  ss := ((Seconds mod SecPerDay) mod SecPerHour) mod SecPerMinute;
  ms := 0;
  Result := dd + EncodeTime(hh, mm, ss, ms);
end;

{ TPathDetalizeProviderMailRuShortest }

constructor TPathDetalizeProviderMailRuShortest.Create(
  ALanguageManager: ILanguageManager;
  AProxyConfig: IProxyConfig
);
begin
  inherited Create(
    CPathDetalizeProviderMailRuShortest,
    ALanguageManager,
    AProxyConfig,
    'http://maps.mail.ru/stamperx/getPath.aspx?mode=distance'
  );
end;

function TPathDetalizeProviderMailRuShortest.GetCaptionTranslated: string;
begin
  Result := _('By car (Shortest) with Maps@mail.ru');
end;

function TPathDetalizeProviderMailRuShortest.GetDescriptionTranslated: string;
begin
  Result := _('Detalize route by car (Shortest) with Maps@mail.ru');
end;

function TPathDetalizeProviderMailRuShortest.GetMenuItemNameTranslated: string;
begin
  Result := _('Maps@mail.ru') + '|0020~\' +  _('By Car (Shortest)') + '|0010';
end;

{ TPathDetalizeProviderMailRuFastest }

constructor TPathDetalizeProviderMailRuFastest.Create(
  ALanguageManager: ILanguageManager;
  AProxyConfig: IProxyConfig
);
begin
  inherited Create(
    CPathDetalizeProviderMailRuFastest,
    ALanguageManager,
    AProxyConfig,
    'http://maps.mail.ru/stamperx/getPath.aspx?mode=time'
  );
end;

function TPathDetalizeProviderMailRuFastest.GetCaptionTranslated: string;
begin
  Result := _('By car (Fastest) with Maps@mail.ru');
end;

function TPathDetalizeProviderMailRuFastest.GetDescriptionTranslated: string;
begin
  Result := _('Detalize route by car (Fastest) with Maps@mail.ru');
end;

function TPathDetalizeProviderMailRuFastest.GetMenuItemNameTranslated: string;
begin
  Result := _('Maps@mail.ru') + '|0020~\' +  _('By Car (Fastest)') + '|0020';
end;

{ TPathDetalizeProviderMailRuFastestWithTraffic }

constructor TPathDetalizeProviderMailRuFastestWithTraffic.Create(
  ALanguageManager: ILanguageManager;
  AProxyConfig: IProxyConfig
);
begin
  inherited Create(
    CPathDetalizeProviderMailRuFastestWithTraffic,
    ALanguageManager,
    AProxyConfig,
    'http://maps.mail.ru/stamperx/getPath.aspx?mode=deftime'
  );
end;

function TPathDetalizeProviderMailRuFastestWithTraffic.GetCaptionTranslated: string;
begin
  Result := _('By car (Fastest with traffic) with Maps@mail.ru');
end;

function TPathDetalizeProviderMailRuFastestWithTraffic.GetDescriptionTranslated: string;
begin
  Result := _('Detalize route by car (Fastest with traffic) with Maps@mail.ru');
end;

function TPathDetalizeProviderMailRuFastestWithTraffic.GetMenuItemNameTranslated: string;
begin
  Result := _('Maps@mail.ru') + '|0020~\' +  _('By Car (Fastest with traffic)') + '|0030';
end;

end.

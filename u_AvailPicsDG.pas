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

unit u_AvailPicsDG;

interface

uses
  SysUtils,
  Classes,
  u_AvailPicsAbstract;

type
  TAvailPicsDG = class(TAvailPicsAbstract)
  private
    FStack_Key: String;
    FStack_Number: String;
    FStack_Descript: String;
    FStack_AppId: String;
  public
    function ContentType: String; override;

    function ParseResponse(const AStream: TMemoryStream): Integer; override;

    function LinkToImages: String; override;

    // name in this class of vendor (stack number and description)
    function GUI_Name: String;
  end;

  TAvailPicsDGs = array of TAvailPicsDG;

procedure GenerateAvailPicsDG(var ADGs: TAvailPicsDGs;
                              const ATileInfoPtr: PAvailPicsTileInfo);

implementation

uses
  u_GeoToStr;

(*
DG:
'7065963162,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A
'7065963163,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A
'7065963164,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A
'7065963170,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7065963171,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7065963172,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7065963178,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7065963179,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7065963180,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7065963186,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7065963187,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7065963188,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7016123157,2008-07-24,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7016123158,2008-07-24,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7066342802,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342803,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342804,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342810,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342811,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342812,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342818,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342819,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342820,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342826,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342827,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7066342828,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
#$D#$A'7016412308,2009-05-29,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7016412309,2009-05-29,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7016431218,2005-09-14,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7016431219,2005-09-14,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7016431220,2005-09-14,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7016431245,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7016431246,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7016431247,2007-05-06,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7386775772,2010-07-09,"DigitalGlobe",-1,0.5,"Color",12000.0,'
#$D#$A'7386775773,2010-07-09,"DigitalGlobe",-1,0.5,"Color",12000.0,'
#$D#$A'7386775774,2010-07-09,"DigitalGlobe",-1,0.5,"Color",12000.0,'
#$D#$A'3756683568,2000-01-01,"DigitalGlobe",-1,15.0,"Color",100000.0,'
#$D#$A'7015679822,2008-05-03,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7015679823,2008-05-03,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7015679824,2008-05-03,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7015679825,2008-05-03,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7061609172,2002-07-01,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7061609173,2002-07-01,"DigitalGlobe",-1,0.6,"Color",50000.0,'
#$D#$A'7062690744,2007-04-05,"DigitalGlobe",-1,0.6,"Col...
*)

var
  Stacks : array [0..13,0..3] of string =
            (
             ('227400001','1','GlobeXplorer Premium Stack','020100S'),
             ('227400001','2','USGS 1:24k Topo Stack','020100S'),
             ('2133000801','4','GlobeXplorer Premium Portal Stack','060100W'),
             ('dfe278a2-8c6e-494f-927e-8937470893fc','6','APUSA Stack','020100S'),
             ('dfe278a2-8c6e-494f-927e-8937470893fc','7','DigitalGlobe Stack','020100S'),
             ('dfe278a2-8c6e-494f-927e-8937470893fc','11','CitiPix by GlobeXplorer ODI stack','020100S'),
             ('dfe278a2-8c6e-494f-927e-8937470893fc','13','DOQQ Stack','020100S'),
             ('dfe278a2-8c6e-494f-927e-8937470893fc','14','I-cubed Image Stack','020100S'),
             ('dfe278a2-8c6e-494f-927e-8937470893fc','18','CitiPix by GlobeXplorer ODI plus RDI stack','020100S'),
             ('227400001','19','WMS Premium','020100S'),
             ('dfe278a2-8c6e-494f-927e-8937470893fc','20','National Map Data Stack','020100S'),
             ('227400001','27','NAIP Stack','020100S'),
             ('2133000801','32','Current Events Stack','060100W'),
//             ('4844000213','33', 'GlobeXplorer Deluxe Stack','030603A'),
//             ('4844000213','34', 'GlobeXplorer Deluxe Portal Stack','030603A'),
             ('dfe278a2-8c6e-494f-927e-8937470893fc','49','Country Coverage','020100S')
             );
{ Stacks : array [0..32,0..3] of string =
            (
             ('227400001','1','GlobeXplorer Premium Stack','020100S'),
             ('227400001','2','USGS 1:24k Topo Stack','020100S'),
             ('227400001','3','GlobeXplorer Basic Stack','020100S'),
             ('2133000801','4','GlobeXplorer Premium Portal Stack','060100W'),
             ('ca4046dd-bba5-425c-8966-0a553e0deb3a','6','APUSA Stack','020100S'),
             ('ca4046dd-bba5-425c-8966-0a553e0deb3a','7','DigitalGlobe Stack','020100S'),
             ('7327000291','10', 'GlobeXplorer Standard Stack','020100S'),
             ('ca4046dd-bba5-425c-8966-0a553e0deb3a','11','CitiPix by GlobeXplorer ODI stack','020100S'),
             ('ca4046dd-bba5-425c-8966-0a553e0deb3a','13','DOQQ Stack','020100S'),
             ('ca4046dd-bba5-425c-8966-0a553e0deb3a','14','I-cubed Image Stack','020100S'),
             ('7327000291','15', 'I-cubed Map Stack','020100S'),
             ('7327000291','16', 'STDB Demo Stack','020100S'),
             ('ca4046dd-bba5-425c-8966-0a553e0deb3a','18','CitiPix by GlobeXplorer ODI plus RDI stack','020100S'),
             ('227400001','19','WMS Premium','020100S'),
             ('ca4046dd-bba5-425c-8966-0a553e0deb3a','20','National Map Data Stack','020100S'),
             ('7327000291','21', 'NavTech Accuracy Data Stack','020100S'),
             ('7327000291','22', 'NavTech Propietary Data Stack','020100S'),
             ('7327000291','26', 'GlobeXplorer Premium 3D Data Stack','020100S'),
             ('227400001','27','NAIP Stack','020100S'),
             ('7327000291','28', 'EarthSat Stack','020100S'),
             ('2133000801','32','Current Events Stack','060100W'),
             ('7327000291','33', 'GlobeXplorer Deluxe Stack','020100S'),
             ('7327000291','34', 'GlobeXplorer Deluxe Portal Stack','020100S'),
             ('7327000291','38','GlobeXplorer Premium Portal Data NB Stack','020100S'),
             ('7327000291','41','DigitalGlobe owned','020100S'),
             ('7327000291','47','DIBU Data','020100S'),
             ('7327000291','48','Oil and Gas NB','020100S'),
             ('ca4046dd-bba5-425c-8966-0a553e0deb3a','49','Country Coverage','020100S'),
             ('7327000291','51','WorldView-01','020100S'),
             ('7327000291','52','DigitalGlobe CitySphere','020100S'),
             ('7327000291','53','Country Coverage2','020100S'),
             ('7327000291','54','DigitalGlobe GeoCells','020100S'),
             ('7327000291','55','DigitalGlobe NGA Ortho Imagery','020100S')
             );  }


procedure GenerateAvailPicsDG(var ADGs: TAvailPicsDGs;
                              const ATileInfoPtr: PAvailPicsTileInfo);
var i,k: Integer;
begin
  k := length(Stacks);

  // set length
  SetLength(ADGs, k);

  // create objects
  for i:=0 to k-1 do begin
    ADGs[i] := TAvailPicsDG.Create(ATileInfoPtr);
    ADGs[i].FStack_Key      := Stacks[i,0];
    ADGs[i].FStack_Number   := Stacks[i,1];
    ADGs[i].FStack_Descript := Stacks[i,2];
    ADGs[i].FStack_AppId    := Stacks[i,3];
  end;
end;

function EncodeDG(const S: String): String;
var i: integer;
begin
  Result:=S;

  if (0<Length(S)) then
  for i:=1 to Length(S) do begin
    if (0 = (Ord(S[i]) mod 2)) then
      Result[i]:=Chr(Ord(S[i])+1)
    else
      Result[i]:=Chr(Ord(S[i])-1);
  end;
end;

function Encode64(const S: String): String;
const
  Codes64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var
  i,a,x,b: Integer;
begin
  Result:='';
  a:=0;
  b:=0;

  if (0<Length(S)) then
  for i := 1 to Length(S) do
  begin
    x:=Ord(S[i]);
    b:=b*256+x;
    a:=a+8;

    while (a >= 6) do begin
      a := a-6;
      x := b div (1 shl a);
      b := b mod (1 shl a);
      Result := Result + Codes64[x + 1];
    end;
  end;
  
  if a>0 then begin
    Result := Result + Codes64[(b shl (6-a))+1];
  end;
end;

function GetWord(const ASource, ASmb: String;
                 const AWordNmbr: Byte): String;
var
  VLine, SWord: String;
  StrLen, N: Byte;
begin
  VLine := Trim(ASource);
  StrLen := Length(VLine);
  N := 1;

  while ((AWordNmbr >= N) and (StrLen <> 0)) do
  begin
    StrLen := System.Pos(ASmb, VLine);
    if StrLen <> 0 then
    begin
      SWord := Copy(VLine, 1, StrLen - 1);
      Delete(VLine, 1, StrLen);
      Inc(N);
    end
    else SWord := VLine;
  end;
  
  if AWordNmbr <= N then
    Result := SWord
  else
    Result := '';
end;

procedure TrimQuotes(var S: String);
begin
  if (0<Length(S)) and ('"'=S[1]) then
    System.Delete(S,1,1);
  if (0<Length(S)) and ('"'=S[Length(S)]) then
    SetLength(S,(Length(S)-1));
end;


{ TAvailPicsDG }

function TAvailPicsDG.ContentType: String;
begin
  Result := 'text/plain';
end;

function TAvailPicsDG.GUI_Name: String;
begin
  Result:=FStack_Number+', '+FStack_Descript;
end;

function TAvailPicsDG.LinkToImages: String;
var
  VEncrypt: String;
begin
  VEncrypt:= Encode64(EncodeDG('cmd=info&id='+FStack_Key+
                               '&appid='+FStack_AppId+
                               '&ls='+FStack_Number+
                               '&xc='+RoundEx(FTileInfoPtr.LonLat.X, 6)+
                               '&yc='+RoundEx(FTileInfoPtr.LonLat.y, 6)+
                               '&mpp='+R2StrPoint(FTileInfoPtr.mpp)+
                               '&iw='+inttostr(FTileInfoPtr.wi)+
                               '&ih='+inttostr(FTileInfoPtr.hi)+
                               '&extentset=all'));
  Result := 'http://image.globexplorer.com/gexservlets/gex?encrypt=' + VEncrypt;
end;

function TAvailPicsDG.ParseResponse(const AStream: TMemoryStream): Integer;
var
  i: Integer;
  VAddResult: Boolean;
  VList: TStringList;
  VLine: String;
  VDate, VId: String;
  VDateOrig, VProvider, VColor, VResolution: String;
  VParams: TStrings;
begin
  Result := 0;

  if (not Assigned(FTileInfoPtr.AddImageProc)) then
    Exit;

  if (nil=AStream) or (0=AStream.Size) then
    Exit;

  VList:=TStringList.Create;
  try
    VList.LoadFromStream(AStream);

    if (0<VList.Count) then
    for i := 0 to VList.Count-1 do
    try
      //'7066342802,2007-05-06,"DigitalGlobe",-1,0.6,"Color-E",50000.0,'
      VParams:=nil;
      VLine:=VList[i];
    
      // date as 2007/05/06
      VDate := GetWord(VLine, ',', 2);
      if (Length(VDate)<10) then
        break;
      VDate[5] := DateSeparator;
      VDate[8] := DateSeparator;

      // id = 7066342802
      VId := GetWord(VLine, ',', 1);

      // params:

      // date original as 2007-05-06
      VDateOrig := GetWord(VLine, ',', 2);

      // DigitalGlobe
      VProvider := GetWord(VLine, ',', 3);
      TrimQuotes(VProvider);

      // Color-E
      VColor := GetWord(VLine, ',', 6);
      TrimQuotes(VColor);

      // 0.6
      VResolution := GetWord(VLine, ',', 5);

      if CheckHiResResolution(VResolution) then begin
        // make params
        VParams:=TStringList.Create;
        VParams.Values['tid']:=VId;
        VParams.Values['date']:=VDateOrig;
        VParams.Values['provider']:=VProvider;
        VParams.Values['resolution']:=VResolution;
        VParams.Values['color']:=VColor;
      
        // add item
        VAddResult := FTileInfoPtr.AddImageProc(Self, VDate, VId, VParams);
        FreeAndNil(VParams);

        if VAddResult then
          Inc(Result);
      end;
    except
      if (nil<>VParams) then begin
        try
          VParams.Free;
        except
        end;
        VParams:=nil;
      end;
    end;
  finally
    FreeAndNil(VList);
  end;
end;

end.

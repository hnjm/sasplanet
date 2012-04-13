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

unit u_GeoCoderByYandex;

interface

uses
  Classes,
  i_CoordConverter,
  u_GeoTostr,
  u_GeoCoderBasic;

type
  TGeoCoderByYandex = class(TGeoCoderBasic)
  protected
    function PrepareURL(const ASearch: WideString): string; override;
    function ParseStringToPlacemarksList(const AStr: string; const ASearch: WideString): IInterfaceList; override;
  public
  end;

implementation

uses
  SysUtils,
  StrUtils,
  t_GeoTypes,
  i_GeoCoder,
  u_ResStrings,
  u_GeoCodePlacemark;

{ TGeoCoderByYandex }

function TGeoCoderByYandex.ParseStringToPlacemarksList(
  const AStr: string; const ASearch: WideString): IInterfaceList;
var
  slat, slon, sname, sdesc, sfulldesc: string;
  i, j: integer;
  VPoint: TDoublePoint;
  VPlace: IGeoCodePlacemark;
  VList: IInterfaceList;
  VFormatSettings: TFormatSettings;
  CurPos:integer;// ������� �������� �������
  BrLevel:integer;//������� ����������� {=���� ����   }=����� ����
  Buffer:string; // ���� ���������� �������� ��������� ������
  CurChar:string; // ������� ������
  err:boolean;// ������� ��������� ������ ����� ��� �� �����...
  ParseErr:boolean; // ������� ������ ������� ������
  Vstr2Find :string;
begin
  Buffer := '';
  BrLevel := 0;
  err := false;
  if AStr = '' then begin
    raise EParserError.Create(SAS_ERR_EmptyServerResponse);
  end;
  VFormatSettings.DecimalSeparator := '.';
  VList := TInterfaceList.Create;
  Vstr2Find := AStr;
  Vstr2Find := ReplaceStr(Vstr2Find,'\/','/'); // �����������
  Vstr2Find := ReplaceStr(Vstr2Find,'\"','"'); // �����������
  CurPos:=PosEx('"features":[', AStr,1)-1;
  while (CurPos<length(Vstr2Find)) and (not err)do begin
   inc (CurPos);
   CurChar:=copy(Vstr2Find,CurPos,1);
   Buffer:=Buffer+CurChar;

   if CurChar='{' then inc(BrLevel);
   if CurChar='}' then begin
    dec(BrLevel);
    if BrLevel=0 then  begin
   // ��������� ������. ������ ����� � ������ � ������������ ��� ��������
     sdesc:='';
     sname:='';
     sfulldesc:='';
     ParseErr:=False;
     j:=1;
     // ���� ���� �������� ���������� - ��������� �
     // ��� �� �������� ��������� ���� ��� ����� ����� ������������
     i := PosEx('{"AddressLine":"', Buffer, 1);
     if i>0  then begin
      if i>j then begin
       j := PosEx('",', Buffer, i + 16);
       sdesc:=Utf8ToAnsi(Copy(Buffer, i + 16, j - (i + 16)));
      end;
     end
    else
    if PosEx('"Address":{"locality":"', Buffer, 1)>1 then begin
     i := PosEx('"Address":{"locality":"', Buffer, 1);
     j := PosEx('",', Buffer, i + 23);
     sdesc:=Utf8ToAnsi(Copy(Buffer, i + 23, j - (i + 23)));
    end else
    // � ��� �� ������ �� �������. ��������� ��������� ����
    if PosEx('PSearchMetaData', Buffer, 1)>1 then begin
     i:=PosEx('"PSearchMetaData":{"id":"', Buffer, 1);
     j := PosEx('",', Buffer, i + 25);
     sfulldesc:='http://n.maps.yandex.ru/?l=wmap&oid='+Copy(Buffer, i + 25, j - (i + 25));
   end
   else ParseErr:=true; // ������ ������ �� ��������� ��� ����������� ������������.

   if ParseErr=false then begin // ���� ����� ������� ���������� ������
    // ������ ������ �� �������� ���� ��� ����.
    j:=1;
    i:= PosEx('"CompanyMetaData":{"id":"', Buffer, 1);
    if i>j then begin
     j := PosEx('",', Buffer, i + 25);
     sfulldesc:='http://maps.yandex.ru/sprav/'+Copy(Buffer, i + 25, j - (i + 25))+'/';
    end;

     // ������ ������������
     i := PosEx(',"name":"', Buffer, 1);
     j := PosEx('",', Buffer, i + 9);
     sname:= Utf8ToAnsi(Copy(Buffer, i + 9, j - (i + 9)));
     // ���������� ��������� ����� (�����,������..) ���� ��� ��� ����� �� �������������
     if Copy(Buffer,j,8)='","type"' then begin
      i := PosEx('"type":"', Buffer, j);
      j := PosEx('",', Buffer, i + 8);
      sname:= sname+' '+Utf8ToAnsi(Copy(Buffer, i + 8, j - (i + 8)));
     end;

     // ������ ����������
     i := PosEx('"coordinates":[', Buffer, j);
     j := PosEx(',', Buffer, i + 15);
     slon := Copy(Buffer, i + 15, j - (i + 15));
     i := PosEx(']', Buffer, j);
     slat := Copy(Buffer, j + 1, i - (j + 1));
     if slat[1] = '\' then delete(slat, 1, 1);
     if slon[1] = '\' then delete(slon, 1, 1);


     i:=1;
     if PosEx('"Categories":', Buffer, i)>i then begin// ������ ���� ���������
      sdesc:=sdesc+' (';
      while PosEx('{"name":"', Buffer, i)>i do begin // �������� ��������� ����� ���� ��������� ������� ����� �� �������� (�����-���������)
       i := PosEx('{"name":"', Buffer, i);
       j := PosEx('","', Buffer, i);
       sdesc:=sdesc+' '+Utf8ToAnsi(Copy(Buffer, i + 9, j - (i + 9)));
       i:=j;
       end;
      sdesc:=sdesc+')';
      end;

     // �������� �� ���
     j:=1;
     i:= PosEx('{"locality":"', Buffer, 1);
     if i>j then begin
      j := PosEx('"', Buffer, i + 13);
      sdesc:='(���) '+Utf8ToAnsi(Copy(Buffer, i + 13, j - (i + 13)));
      end;

     // �������� �� ���
     j:=1;
     i:= PosEx('"category_name":"', Buffer, 1);
     if i>j then begin
      j := PosEx('"', Buffer, i + 17);
      if sdesc='' then sdesc:='(���) ';
      sdesc:=sdesc+' ('+Utf8ToAnsi(Copy(Buffer, i + 17, j - (i + 17)))+')';
      end;

     try
      VPoint.Y := StrToFloat(slat, VFormatSettings);
      VPoint.X := StrToFloat(slon, VFormatSettings);
     except
      raise EParserError.CreateFmt(SAS_ERR_CoordParseError, [slat, slon]);
     end;

      // ���� ����� ���-������ - ����� ��������� �����.
     if sdesc<>'' then begin
      VPlace := TGeoCodePlacemark.Create(VPoint, sname, sdesc, sfulldesc, 4);
      VList.Add(VPlace);
     end;
    end;
    Buffer:='';
   end;
   if (BrLevel=1) and (curpos>= length(Vstr2Find)) then err:=true;//  ������. ��������. �������.
   end;
  end;
  Result := VList;
end;

function TGeoCoderByYandex.PrepareURL(const ASearch: WideString): string;
var
  VSearch: String;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMapRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
begin
  VSearch := ASearch;
  VConverter:=FLocalConverter.GetGeoConverter;
  VZoom := FLocalConverter.GetZoom;
  VMapRect := FLocalConverter.GetRectInMapPixelFloat;
  VConverter.CheckPixelRectFloat(VMapRect, VZoom);
  VLonLatRect := VConverter.PixelRectFloat2LonLatRect(VMapRect, VZoom);
  Result := 'http://maps.yandex.ru/?text='+URLEncode(AnsiToUtf8(VSearch))+
            '&sll='+R2StrPoint(FLocalConverter.GetCenterLonLat.x)+','+R2StrPoint(FLocalConverter.GetCenterLonLat.y)+
            '&sspn='+R2StrPoint(VLonLatRect.Right-VLonLatRect.Left)+','+R2StrPoint(VLonLatRect.Top-VLonLatRect.Bottom)+
            '&z='+inttostr(VZoom)+'&source=form&output=json';

end;
end.
// examples
//  http://maps.yandex.ru/?text=%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D1%8F%2C%20%D0%A2%D1%8E%D0%BC%D0%B5%D0%BD%D1%81%D0%BA%D0%B0%D1%8F%20%D0%BE%D0%B1%D0%BB%D0%B0%D1%81%D1%82%D1%8C%2C%20%D0%A2%D1%8E%D0%BC%D0%B5%D0%BD%D1%8C&sll=65.558412%2C57.182627&ll=38.975277%2C45.035407&spn=0.469666%2C0.261446&z=11&l=map
//  http://maps.yandex.ru/?text=%D0%B1%D0%B0%D0%BB%D0%BE%D1%87%D0%BA%D0%B0&sll=38.975276999999984%2C45.03540700001939&sspn=0.469666%2C0.261446&z=11&source=form&output=json

// http://maps.yandex.ru/?text=%D0%9C%D0%BE%D1%81%D0%BA%D0%B2%D0%B0&sll=37.4969343220393,55.7374581159436&sspn=0.211658477783203,0.0711842917507042&z=13&source=form&output=json

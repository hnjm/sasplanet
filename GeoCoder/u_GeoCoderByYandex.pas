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
  i_InterfaceListSimple,
  i_NotifierOperation,
  i_LocalCoordConverter,
  i_DownloadRequest,
  i_DownloadResult,
  u_GeoCoderBasic;

type
  TGeoCoderByYandex = class(TGeoCoderBasic)
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
  end;

implementation

uses
  SysUtils,
  StrUtils,
  ALfcnString,
  t_GeoTypes,
  i_GeoCoder,
  i_CoordConverter,
  u_InterfaceListSimple,
  u_GeoToStr,
  u_ResStrings,
  u_GeoCodePlacemark;

{ TGeoCoderByYandex }

function TGeoCoderByYandex.ParseResultToPlacemarksList(
  const ACancelNotifier: INotifierOperation;
  AOperationID: Integer;
  const AResult: IDownloadResultOk;
  const ASearch: WideString;
  const ALocalConverter: ILocalCoordConverter
): IInterfaceListSimple;
var
  slat, slon: AnsiString;
  sname, sdesc, sfulldesc: string;
  i, j: integer;
  VPoint: TDoublePoint;
  VPlace: IGeoCodePlacemark;
  VList: IInterfaceListSimple;
  VFormatSettings: TALFormatSettings;
  CurPos:integer;// ������� �������� �������
  BrLevel:integer;//������� ����������� {=���� ����   }=����� ����
  Buffer:AnsiString; // ���� ���������� �������� ��������� ������
  CurChar:AnsiString; // ������� ������
  err:boolean;// ������� ��������� ������ ����� ��� �� �����...
  ParseErr:boolean; // ������� ������ ������� ������
  Vstr2Find: AnsiString;
begin
  Buffer := '';
  BrLevel := 0;
  err := false;
  if AResult.Data.Size <= 0 then begin
    raise EParserError.Create(SAS_ERR_EmptyServerResponse);
  end;
  VFormatSettings.DecimalSeparator := '.';
  VList := TInterfaceListSimple.Create;
  SetLength(Vstr2Find, AResult.Data.Size);
  Move(AResult.Data.Buffer^, Vstr2Find[1], AResult.Data.Size);
  Vstr2Find := ALStringReplace(Vstr2Find,'\/','/', [rfReplaceAll]); // �����������
  Vstr2Find := ALStringReplace(Vstr2Find,'\"','"', [rfReplaceAll]); // �����������
  CurPos:=ALPosEx('"features":[', Vstr2Find, 1)-1;
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
     i := ALPosEx('{"AddressLine":"', Buffer, 1);
     if i>0  then begin
      if i>j then begin
       j := ALPosEx('",', Buffer, i + 16);
       sdesc:=Utf8ToAnsi(Copy(Buffer, i + 16, j - (i + 16)));
      end;
     end
    else
    if ALPosEx('"Address":{"locality":"', Buffer, 1)>1 then begin
     i := ALPosEx('"Address":{"locality":"', Buffer, 1);
     j := ALPosEx('",', Buffer, i + 23);
     sdesc:=Utf8ToAnsi(Copy(Buffer, i + 23, j - (i + 23)));
    end else
    // � ��� �� ������ �� �������. ��������� ��������� ����
    if ALPosEx('PSearchMetaData', Buffer, 1)>1 then begin
     i:=ALPosEx('"PSearchMetaData":{"id":"', Buffer, 1);
     j := ALPosEx('",', Buffer, i + 25);
     sfulldesc:='http://n.maps.yandex.ru/?l=wmap&oid='+ string(Copy(Buffer, i + 25, j - (i + 25)));
   end
   else ParseErr:=true; // ������ ������ �� ��������� ��� ����������� ������������.

   if not ParseErr then begin // ���� ����� ������� ���������� ������
    // ������ ������ �� �������� ���� ��� ����.
    j:=1;
    i:= ALPosEx('"CompanyMetaData":{"id":"', Buffer, 1);
    if i>j then begin
     j := ALPosEx('",', Buffer, i + 25);
     sfulldesc:='http://maps.yandex.ru/sprav/'+string(Copy(Buffer, i + 25, j - (i + 25)))+'/';
    end;

     // ������ ������������
     i := ALPosEx(',"name":"', Buffer, 1);
     j := ALPosEx('",', Buffer, i + 9);
     sname:= Utf8ToAnsi(Copy(Buffer, i + 9, j - (i + 9)));
     // ���������� ��������� ����� (�����,������..) ���� ��� ��� ����� �� �������������
     if Copy(Buffer,j,8)='","type"' then begin
      i := ALPosEx('"type":"', Buffer, j);
      j := ALPosEx('",', Buffer, i + 8);
      sname:= sname+' '+Utf8ToAnsi(Copy(Buffer, i + 8, j - (i + 8)));
     end;

     // ������ ����������
     i := ALPosEx('"coordinates":[', Buffer, j);
     j := ALPosEx(',', Buffer, i + 15);
     slon := Copy(Buffer, i + 15, j - (i + 15));
     i := ALPosEx(']', Buffer, j);
     slat := Copy(Buffer, j + 1, i - (j + 1));
     if slat[1] = '\' then delete(slat, 1, 1);
     if slon[1] = '\' then delete(slon, 1, 1);


     i:=1;
     if ALPosEx('"Categories":', Buffer, i)>i then begin// ������ ���� ���������
      sdesc:=sdesc+' (';
      while ALPosEx('{"name":"', Buffer, i)>i do begin // �������� ��������� ����� ���� ��������� ������� ����� �� �������� (�����-���������)
       i := ALPosEx('{"name":"', Buffer, i);
       j := ALPosEx('","', Buffer, i);
       sdesc:=sdesc+' '+Utf8ToAnsi(Copy(Buffer, i + 9, j - (i + 9)));
       i:=j;
       end;
      sdesc:=sdesc+')';
      end;

     // �������� �� ���
     j:=1;
     i:= ALPosEx('{"locality":"', Buffer, 1);
     if i>j then begin
      j := ALPosEx('"', Buffer, i + 13);
      sdesc:='(���) '+Utf8ToAnsi(Copy(Buffer, i + 13, j - (i + 13)));
      end;

     // �������� �� ���
     j:=1;
     i:= ALPosEx('"category_name":"', Buffer, 1);
     if i>j then begin
      j := ALPosEx('"', Buffer, i + 17);
      if sdesc='' then sdesc:='(���) ';
      sdesc:=sdesc+' ('+Utf8ToAnsi(Copy(Buffer, i + 17, j - (i + 17)))+')';
      end;

     try
      VPoint.Y := ALStrToFloat(slat, VFormatSettings);
      VPoint.X := ALStrToFloat(slon, VFormatSettings);
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

function TGeoCoderByYandex.PrepareRequest(const ASearch: WideString;
  const ALocalConverter: ILocalCoordConverter): IDownloadRequest;
var
  VSearch: String;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMapRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
begin
  VSearch := ASearch;
  VConverter:=ALocalConverter.GetGeoConverter;
  VZoom := ALocalConverter.GetZoom;
  VMapRect := ALocalConverter.GetRectInMapPixelFloat;
  VConverter.CheckPixelRectFloat(VMapRect, VZoom);
  VLonLatRect := VConverter.PixelRectFloat2LonLatRect(VMapRect, VZoom);
  Result :=
    PrepareRequestByURL(
            'http://maps.yandex.ru/?text='+URLEncode(AnsiToUtf8(VSearch))+
            '&sll='+R2AnsiStrPoint(ALocalConverter.GetCenterLonLat.x)+','+R2AnsiStrPoint(ALocalConverter.GetCenterLonLat.y)+
            '&sspn='+R2AnsiStrPoint(VLonLatRect.Right-VLonLatRect.Left)+','+R2AnsiStrPoint(VLonLatRect.Top-VLonLatRect.Bottom)+
            '&z='+ALIntToStr(VZoom)+'&source=form&output=json'
    );
end;
end.
// examples
//  http://maps.yandex.ru/?text=%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D1%8F%2C%20%D0%A2%D1%8E%D0%BC%D0%B5%D0%BD%D1%81%D0%BA%D0%B0%D1%8F%20%D0%BE%D0%B1%D0%BB%D0%B0%D1%81%D1%82%D1%8C%2C%20%D0%A2%D1%8E%D0%BC%D0%B5%D0%BD%D1%8C&sll=65.558412%2C57.182627&ll=38.975277%2C45.035407&spn=0.469666%2C0.261446&z=11&l=map
//  http://maps.yandex.ru/?text=%D0%B1%D0%B0%D0%BB%D0%BE%D1%87%D0%BA%D0%B0&sll=38.975276999999984%2C45.03540700001939&sspn=0.469666%2C0.261446&z=11&source=form&output=json

// http://maps.yandex.ru/?text=%D0%9C%D0%BE%D1%81%D0%BA%D0%B2%D0%B0&sll=37.4969343220393,55.7374581159436&sspn=0.211658477783203,0.0711842917507042&z=13&source=form&output=json

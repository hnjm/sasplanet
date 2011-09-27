{******************************************************************************}
{* SAS.������� (SAS.Planet)                                                   *}
{* Copyright (C) 2007-2011, ������ ��������� SAS.������� (SAS.Planet).        *}
{* ��� ��������� �������� ��������� ����������� ������������. �� ������       *}
{* �������������� �/��� �������������� � �������� �������� �����������       *}
{* ������������ �������� GNU, �������������� ������ ���������� ������������   *}
{* �����������, ������ 3. ��� ��������� ���������������� � �������, ��� ���   *}
{* ����� ��������, �� ��� ������ ��������, � ��� ����� ���������������        *}
{* �������� ��������� ��������� ��� ������� � �������� ��� ������˨�����      *}
{* ����������. �������� ����������� ������������ �������� GNU ������ 3, ���   *}
{* ��������� �������������� ����������. �� ������ ���� �������� �����         *}
{* ����������� ������������ �������� GNU ������ � ����������. � ������ �     *}
{* ����������, ���������� http://www.gnu.org/licenses/.                       *}
{*                                                                            *}
{* http://sasgis.ru/sasplanet                                                 *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_ContentConverterKml2Kmz;

interface

uses
  Classes,
  u_ContentConverterBase;

type
  TContentConverterKml2Kmz = class(TContentConverterBase)
  protected
    procedure ConvertStream(ASource, ATarget: TStream); override;
  end;

implementation

uses
  KAZip;

{ TContentConverterKmz2Kml }

procedure TContentConverterKml2Kmz.ConvertStream(ASource, ATarget: TStream);
var
  VZip:TKAZip;
begin
  inherited;
  VZip:=TKAZip.Create(nil);
  try
    VZip.CreateZip(ATarget);
    VZip.Open(ATarget);
    VZip.CompressionType := ctNormal;
    VZip.AddStream('doc.kml', ASource);
  finally
    VZip.Free;
  end;
end;

end.

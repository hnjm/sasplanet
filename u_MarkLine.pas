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

unit u_MarkLine;

interface

uses
  GR32,
  t_GeoTypes,
  i_MarksSimple,
  i_MarkCategory,
  i_HtmlToHintTextConverter,
  u_MarkFullBase;

type
  TMarkLine = class(TMarkFullBase, IMarkLine)
  private
    FLLRect: TDoubleRect;
    FPoints: TArrayOfDoublePoint;
    FLineColor: TColor32;
    FLineWidth: Integer;
  protected
    function GetLLRect: TDoubleRect; override;
    function GetPoints: TArrayOfDoublePoint;
    function GetLineColor: TColor32;
    function GetLineWidth: Integer;
    function GetGoToLonLat: TDoublePoint; override;
  public
    constructor Create(
      AHintConverter: IHtmlToHintTextConverter;
      ADbCode: Integer;
      AName: string;
      AId: Integer;
      AVisible: Boolean;
      ACategory: ICategory;
      ADesc: string;
      ALLRect: TDoubleRect;
      APoints: TArrayOfDoublePoint;
      ALineColor: TColor32;
      ALineWidth: Integer
    );
  end;

implementation

{ TMarkFull }

constructor TMarkLine.Create(
  AHintConverter: IHtmlToHintTextConverter;
  ADbCode: Integer;
  AName: string;
  AId: Integer;
  AVisible: Boolean;
  ACategory: ICategory;
  ADesc: string;
  ALLRect: TDoubleRect;
  APoints: TArrayOfDoublePoint;
  ALineColor: TColor32;
  ALineWidth: Integer
);
begin
  inherited Create(AHintConverter, ADbCode, AName, AId, ACategory, ADesc, AVisible);
  FLLRect := ALLRect;
  FPoints := APoints;
  FLineColor := ALineColor;
  FLineWidth := ALineWidth;
end;

function TMarkLine.GetLineColor: TColor32;
begin
  Result := FLineColor;
end;

function TMarkLine.GetGoToLonLat: TDoublePoint;
begin
  Result := FPoints[0];
end;

function TMarkLine.GetLLRect: TDoubleRect;
begin
  Result := FLLRect;
end;

function TMarkLine.GetPoints: TArrayOfDoublePoint;
begin
  Result := FPoints;
end;

function TMarkLine.GetLineWidth: Integer;
begin
  Result := FLineWidth;
end;

end.


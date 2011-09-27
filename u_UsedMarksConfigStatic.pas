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

unit u_UsedMarksConfigStatic;

interface

uses
  i_UsedMarksConfig;

type
  TUsedMarksConfigStatic = class(TInterfacedObject, IUsedMarksConfigStatic)
  private
    FIsUseMarks: Boolean;
    FIgnoreMarksVisible: Boolean;
    FIgnoreCategoriesVisible: Boolean;
  protected
    function GetIsUseMarks: Boolean;
    function GetIgnoreCategoriesVisible: Boolean;
    function GetIgnoreMarksVisible: Boolean;
  public
    constructor Create(
      AIsUseMarks: Boolean;
      AIgnoreMarksVisible: Boolean;
      AIgnoreCategoriesVisible: Boolean
    );
  end;

implementation

{ TUsedMarksConfigStatic }

constructor TUsedMarksConfigStatic.Create(AIsUseMarks, AIgnoreMarksVisible,
  AIgnoreCategoriesVisible: Boolean);
begin
  FIsUseMarks := AIsUseMarks;
  FIgnoreCategoriesVisible := AIgnoreCategoriesVisible;
  FIgnoreMarksVisible := AIgnoreMarksVisible;
end;

function TUsedMarksConfigStatic.GetIgnoreCategoriesVisible: Boolean;
begin
  Result := FIgnoreCategoriesVisible;
end;

function TUsedMarksConfigStatic.GetIgnoreMarksVisible: Boolean;
begin
  Result := FIgnoreMarksVisible;
end;

function TUsedMarksConfigStatic.GetIsUseMarks: Boolean;
begin
  Result := FIsUseMarks;
end;

end.

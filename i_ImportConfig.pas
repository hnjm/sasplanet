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

unit i_ImportConfig;

interface

uses
  i_MarkTemplate,
  i_MarksDb;

type
  IImportConfig = interface
    ['{95479381-A0D7-4FE3-86FB-11C5ED532FD2}']
    function GetMarkDB: IMarksDb;
    property MarkDB: IMarksDb read GetMarkDB;

    function GetTemplateNewPoint: IMarkTemplatePoint;
    property TemplateNewPoint: IMarkTemplatePoint read GetTemplateNewPoint;

    function GetTemplateNewLine: IMarkTemplateLine;
    property TemplateNewLine: IMarkTemplateLine read GetTemplateNewLine;

    function GetTemplateNewPoly: IMarkTemplatePoly;
    property TemplateNewPoly: IMarkTemplatePoly read GetTemplateNewPoly;
  end;

implementation

end.

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

unit u_LanguageListStatic;

interface

uses
  Classes,
  i_LanguageListStatic;

type
  TLanguageListStatic = class(TInterfacedObject, ILanguageListStatic)
  private
    FSortedByCode: TStringList;
    FList: TStringList;
  protected
    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetCode(AIndex: Integer): string;
    function FindCode(ACode: string; out AIndex: Integer): Boolean;
  public
    constructor Create(
      AList: TStrings
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

{ TLanguageListStatic }

constructor TLanguageListStatic.Create(AList: TStrings);
var
  i: Integer;
  VCode: string;
begin
  FSortedByCode := TStringList.Create;
  FSortedByCode.Sorted := True;
  FSortedByCode.Duplicates := dupError;

  FList := TStringList.Create;

  for i := 0 to AList.Count - 1 do begin
    VCode := AList.Strings[i];
    FSortedByCode.AddObject(VCode, TObject(i));
    FList.Add(VCode);
  end;
end;

destructor TLanguageListStatic.Destroy;
begin
  FreeAndNil(FSortedByCode);
  FreeAndNil(FList);
  inherited;
end;

function TLanguageListStatic.FindCode(ACode: string;
  out AIndex: Integer): Boolean;
begin
  Result := FSortedByCode.Find(ACode, AIndex);
end;

function TLanguageListStatic.GetCode(AIndex: Integer): string;
begin
  Result := FList.Strings[AIndex];
end;

function TLanguageListStatic.GetCount: Integer;
begin
  Result := FList.Count;
end;

end.

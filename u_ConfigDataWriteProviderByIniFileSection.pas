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

unit u_ConfigDataWriteProviderByIniFileSection;

interface

uses
  Classes,
  IniFiles,
  i_ConfigDataWriteProvider,
  u_ConfigDataProviderByIniFileSection;

type
  TConfigDataWriteProviderByIniFileSection = class(TConfigDataProviderByIniFileSection, IConfigDataWriteProvider)
  protected
    function GetOrCreateSubItem(const AIdent: string): IConfigDataWriteProvider;
    procedure DeleteSubItem(const AIdent: string);
    procedure DeleteValue(const AIdent: string);
    procedure DeleteValues;
    procedure WriteBinaryStream(const AIdent: string; AValue: TStream);
    procedure WriteString(const AIdent: string; const AValue: string);
    procedure WriteInteger(const AIdent: string; const AValue: Longint);
    procedure WriteBool(const AIdent: string; const AValue: Boolean);
    procedure WriteDate(const AIdent: string; const AValue: TDateTime);
    procedure WriteDateTime(const AIdent: string; const AValue: TDateTime);
    procedure WriteFloat(const AIdent: string; const AValue: Double);
    procedure WriteTime(const AIdent: string; const AValue: TDateTime);
  end;

implementation

uses
  SysUtils;

{ TConfigDataWriteProviderByIniFileSection }

procedure TConfigDataWriteProviderByIniFileSection.DeleteSubItem(
  const AIdent: string);
begin
  FIniFile.EraseSection(GetSubItemSectionName(AIdent));
end;

procedure TConfigDataWriteProviderByIniFileSection.DeleteValue(
  const AIdent: string);
begin
  FIniFile.DeleteKey(FSection, AIdent);
end;

procedure TConfigDataWriteProviderByIniFileSection.DeleteValues;
begin
  FIniFile.EraseSection(FSection);
end;

function TConfigDataWriteProviderByIniFileSection.GetOrCreateSubItem(
  const AIdent: string): IConfigDataWriteProvider;
begin
  Result := TConfigDataWriteProviderByIniFileSection.Create(
    FIniFile,
    GetSubItemSectionName(AIdent),
    Self
  );
end;

procedure TConfigDataWriteProviderByIniFileSection.WriteBinaryStream(
  const AIdent: string; AValue: TStream);
begin
  FIniFile.WriteBinaryStream(FSection, AIdent, AValue);
end;

procedure TConfigDataWriteProviderByIniFileSection.WriteBool(
  const AIdent: string; const AValue: Boolean);
begin
  FIniFile.WriteBool(FSection, AIdent, AValue);
end;

procedure TConfigDataWriteProviderByIniFileSection.WriteDate(
  const AIdent: string; const AValue: TDateTime);
begin
  FIniFile.WriteString(FSection, AIdent, DateToStr(AValue, FFormatSettings));
end;

procedure TConfigDataWriteProviderByIniFileSection.WriteDateTime(
  const AIdent: string; const AValue: TDateTime);
begin
  FIniFile.WriteString(FSection, AIdent, DateTimeToStr(AValue, FFormatSettings));
end;

procedure TConfigDataWriteProviderByIniFileSection.WriteFloat(
  const AIdent: string; const AValue: Double);
begin
  FIniFile.WriteString(FSection, AIdent, FloatToStr(AValue, FFormatSettings));
end;

procedure TConfigDataWriteProviderByIniFileSection.WriteInteger(
  const AIdent: string; const AValue: Integer);
begin
  FIniFile.WriteInteger(FSection, AIdent, AValue);
end;

procedure TConfigDataWriteProviderByIniFileSection.WriteString(const AIdent,
  AValue: string);
begin
  FIniFile.WriteString(FSection, AIdent, AValue);
end;

procedure TConfigDataWriteProviderByIniFileSection.WriteTime(
  const AIdent: string; const AValue: TDateTime);
begin
  FIniFile.WriteString(FSection, AIdent, TimeToStr(AValue, FFormatSettings));
end;

end.

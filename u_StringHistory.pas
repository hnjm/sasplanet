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

unit u_StringHistory;

interface

uses
  Classes,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_StringHistory,
  u_ConfigDataElementBase;

type
  TStringHistory = class(TConfigDataElementBase, IStringHistory)
  private
    FList: TStringList;
  protected
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetCapacity: Integer;
    procedure SetCapacity(AValue: Integer);

    function GetCount: Integer;

    function GetItem(AIndex: Integer): string;
    procedure RemoveItem(AIndex: Integer);
    procedure AddItem(AValue: string);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

{ TStringHistory }

constructor TStringHistory.Create;
begin
  inherited;
  FList := TStringList.Create;
  FList.Capacity := 10;
end;

destructor TStringHistory.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TStringHistory.AddItem(AValue: string);
var
  VIndex: Integer;
  i: Integer;
begin
  if AValue <> '' then begin
    LockWrite;
    try
      if FList.Capacity > 0 then begin
        VIndex := FList.IndexOf(AValue);
        if VIndex < 0 then begin
          if FList.Count >= FList.Capacity then begin
            FList.Delete(FList.Capacity - 1);
          end;
          FList.Insert(0, AValue);
          SetChanged;
        end else if VIndex > 0 then begin
          for i := VIndex - 1 downto 0 do begin
            FList.Exchange(i, i + 1);
          end;
          SetChanged;
        end;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

procedure TStringHistory.DoReadConfig(AConfigData: IConfigDataProvider);
var
  i: Integer;
begin
  inherited;
  if AConfigData <> nil then begin
    FList.Capacity := AConfigData.ReadInteger('Capacity', FList.Capacity);
    for i := FList.Capacity - 1 downto 0 do begin
      AddItem(AConfigData.ReadString('Item' + IntToStr(i),''));
    end;
    SetChanged;
  end;
end;

procedure TStringHistory.DoWriteConfig(AConfigData: IConfigDataWriteProvider);
var
  i: Integer;
begin
  inherited;
  AConfigData.DeleteValues;
  AConfigData.WriteInteger('Capacity', FList.Capacity);
  for i := 0 to FList.Count - 1 do begin
    AConfigData.WriteString('Item' + IntToStr(i), FList[i]);
  end;
end;

function TStringHistory.GetCapacity: Integer;
begin
  LockRead;
  try
    Result := FList.Capacity;
  finally
    UnlockRead;
  end;
end;

function TStringHistory.GetCount: Integer;
begin
  LockRead;
  try
    Result := FList.Count;
  finally
    UnlockRead;
  end;
end;

function TStringHistory.GetItem(AIndex: Integer): string;
begin
  LockRead;
  try
    if (AIndex >= 0) and (AIndex < FList.Count) then begin
      Result := FList[AIndex];
    end else begin
      Result := '';
    end;
  finally
    UnlockRead;
  end;
end;

procedure TStringHistory.RemoveItem(AIndex: Integer);
begin
  LockWrite;
  try
    if (AIndex >= 0) and (AIndex < FList.Count) then begin
      FList.Delete(AIndex);
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TStringHistory.SetCapacity(AValue: Integer);
begin
  LockWrite;
  try
    if FList.Capacity <> AValue then begin
      FList.Capacity := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.

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

unit u_ConfigProviderHelpers;

interface

uses
  GR32,
  i_ContentTypeManager,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider;

procedure WriteColor32(
  AConfigProvider: IConfigDataWriteProvider;
  AIdent: string;
  AValue: TColor32
);
function ReadColor32(
  AConfigProvider: IConfigDataProvider;
  AIdent: string;
  ADefault: TColor32
): TColor32;

procedure ReadBitmapByFileRef(
  AConfigProvider: IConfigDataProvider;
  AFullFileName: string;
  AContentTypeManager: IContentTypeManager;
  ABitmap: TCustomBitmap32
);

implementation

uses
  Classes,
  SysUtils,
  Graphics,
  i_ContentTypeInfo;

function ReadColor32(
  AConfigProvider: IConfigDataProvider;
  AIdent: string;
  ADefault: TColor32
): TColor32;
var
  VColor: TColor;
  VAlfa: Integer;
  VHexString: string;
  VIntColor: Integer;
begin
  Result := ADefault;
  if AConfigProvider <> nil then begin
    VHexString := AConfigProvider.ReadString(AIdent + 'Hex', '');
    if VHexString = '' then begin
      VAlfa := AlphaComponent(Result);
      VColor := WinColor(Result);
      VAlfa := AConfigProvider.ReadInteger(AIdent + 'Alfa', VAlfa);
      VColor := AConfigProvider.ReadInteger(AIdent, VColor);
      Result := SetAlpha(Color32(VColor), VAlfa);
    end else begin
      if TryStrToInt(VHexString, VIntColor) then begin
        Result := VIntColor;
      end;
    end;
  end;
end;

procedure WriteColor32(
  AConfigProvider: IConfigDataWriteProvider;
  AIdent: string;
  AValue: TColor32
);
begin
  AConfigProvider.WriteString(AIdent + 'Hex', HexDisplayPrefix + IntToHex(AValue, 8));
end;

procedure ReadBitmapByFileRef(
  AConfigProvider: IConfigDataProvider;
  AFullFileName: string;
  AContentTypeManager: IContentTypeManager;
  ABitmap: TCustomBitmap32
);
var
  VFilePath: string;
  VFileName: string;
  VFileExt: string;
  VResourceProvider: IConfigDataProvider;
  VStream: TMemoryStream;
  VInfoBasic: IContentTypeInfoBasic;
  VBitmapContntType: IContentTypeInfoBitmap;
begin
  VFilePath := ExcludeTrailingPathDelimiter(ExtractFilePath(AFullFileName));
  VFileName := ExtractFileName(AFullFileName);
  VFileExt := ExtractFileExt(VFileName);

  try
    VResourceProvider := AConfigProvider.GetSubItem(VFilePath);
  except
    Assert(False, '������ ��� ��������� ���� ' + VFilePath);
  end;

  if VResourceProvider <> nil then begin
    VStream := TMemoryStream.Create;
    try
      if VResourceProvider.ReadBinaryStream(VFileName, VStream) > 0 then begin
        VInfoBasic := AContentTypeManager.GetInfoByExt(VFileExt);
        if VInfoBasic <> nil then begin
          if Supports(VInfoBasic, IContentTypeInfoBitmap, VBitmapContntType) then begin
            VStream.Position := 0;
            try
              VBitmapContntType.GetLoader.LoadFromStream(VStream, ABitmap);
            except
              Assert(False, '������ ��� �������� �������� ' + AFullFileName);
            end;
          end;
        end;
      end;
    finally
      VStream.Free;
    end;
  end;
end;

end.

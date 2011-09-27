{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
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

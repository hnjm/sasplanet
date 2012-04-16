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

unit u_ConfigDataProviderByPathConfig;

interface

uses
  Classes,
  i_StringListStatic,
  i_BinaryData,
  i_PathConfig,
  i_ConfigDataProvider;

type
  TConfigDataProviderByPathConfig = class(TInterfacedObject, IConfigDataProvider)
  private
    FSourcePath: IPathConfig;
  protected
    function GetSubItem(const AIdent: string): IConfigDataProvider;
    function ReadBinary(const AIdent: string): IBinaryData;
    function ReadString(const AIdent: string; const ADefault: string): string;
    function ReadInteger(const AIdent: string; const ADefault: Longint): Longint;
    function ReadBool(const AIdent: string; const ADefault: Boolean): Boolean;
    function ReadDate(const AIdent: string; const ADefault: TDateTime): TDateTime;
    function ReadDateTime(const AIdent: string; const ADefault: TDateTime): TDateTime;
    function ReadFloat(const AIdent: string; const ADefault: Double): Double;
    function ReadTime(const AIdent: string; const ADefault: TDateTime): TDateTime; 

    function ReadSubItemsList: IStringListStatic;
    function ReadValuesList: IStringListStatic;
  public
    constructor Create(const ASourcePath: IPathConfig);
  end;

implementation

uses
  SysUtils,
  IniFiles,
  u_StringListStatic,
  u_BinaryDataByMemStream,
  u_ConfigDataProviderByFolder,
  u_ConfigDataProviderByIniFile;

{ TConfigDataProviderByPathConfig }

constructor TConfigDataProviderByPathConfig.Create(const ASourcePath: IPathConfig);
begin
  FSourcePath := ASourcePath;
end;

function TConfigDataProviderByPathConfig.GetSubItem(
  const AIdent: string): IConfigDataProvider;
var
  VExt: string;
  VFullName: string;
  VIniFile: TMemIniFile;
  VIniStrings: TStringList;
  VIniStream: TMemoryStream;
begin
  Result := nil;
  VFullName := IncludeTrailingPathDelimiter(FSourcePath.FullPath) + AIdent;
  if DirectoryExists(VFullName) then begin
      Result := TConfigDataProviderByFolder.Create(VFullName);
  end else begin
    VExt := UpperCase(ExtractFileExt(AIdent));
    if (VExt = '.INI') or (VExt = '.TXT') then begin
      if FileExists(VFullName) then begin
        VIniFile := TMemIniFile.Create('');
        try
          VIniStream := TMemoryStream.Create;
          try
            VIniStream.LoadFromFile(VFullName);
            VIniStream.Position := 0;
            VIniStrings := TStringList.Create;
            try
              VIniStrings.LoadFromStream(VIniStream);
              VIniFile.SetStrings(VIniStrings);
            finally
              VIniStrings.Free;
            end;
          finally
            VIniStream.Free;
          end;
        except
          VIniFile.Free;
          raise;
        end;
        Result := TConfigDataProviderByIniFile.Create(VIniFile);
      end;
    end;
  end;
end;

function TConfigDataProviderByPathConfig.ReadBinary(const AIdent: string): IBinaryData;
var
  VMemStream: TMemoryStream;
  VFileName: string;
begin
  Result := nil;
  VFileName := IncludeTrailingPathDelimiter(FSourcePath.FullPath) + AIdent;
  if FileExists(VFileName) then begin
    VMemStream := TMemoryStream.Create;
    try
      VMemStream.LoadFromFile(VFileName);
      Result := TBinaryDataByMemStream.CreateWithOwn(VMemStream);
      VMemStream := nil;
    finally
      VMemStream.Free;
    end;
  end;
end;

function TConfigDataProviderByPathConfig.ReadBool(const AIdent: string;
  const ADefault: Boolean): Boolean;
begin
  Result := ADefault;
end;

function TConfigDataProviderByPathConfig.ReadDate(const AIdent: string;
  const ADefault: TDateTime): TDateTime;
begin
  Result := ADefault;
end;

function TConfigDataProviderByPathConfig.ReadDateTime(const AIdent: string;
  const ADefault: TDateTime): TDateTime;
begin
  Result := ADefault;
end;

function TConfigDataProviderByPathConfig.ReadFloat(const AIdent: string;
  const ADefault: Double): Double;
begin
  Result := ADefault;
end;

function TConfigDataProviderByPathConfig.ReadInteger(const AIdent: string;
  const ADefault: Integer): Longint;
begin
  Result := ADefault;
end;

function TConfigDataProviderByPathConfig.ReadString(const AIdent,
  ADefault: string): string;
var
  VExt: string;
  VStream: TMemoryStream;
  VFileName: string;
begin
  Result := '';
  if AIdent = '::FileName' then begin
    Result := FSourcePath.FullPath;
  end else begin
    VExt := UpperCase(ExtractFileExt(AIdent));
    if (VExt = '.INI') or (VExt = '.HTML') or (VExt = '.TXT') then begin
      VFileName := IncludeTrailingPathDelimiter(FSourcePath.FullPath) + AIdent;
      if FileExists(VFileName) then begin
        VStream := TMemoryStream.Create;
        try
          VStream.LoadFromFile(VFileName);
          SetLength(Result, VStream.Size);
          VStream.Position := 0;
          VStream.ReadBuffer(Result[1], VStream.Size);
        finally
          VStream.Free;
        end;
      end else begin
        Result := ADefault;
      end;
    end else begin
      Result := ADefault;
    end;
  end;
end;

function TConfigDataProviderByPathConfig.ReadSubItemsList: IStringListStatic;
var
  VList: TStringList;
  VExt: string;
  VFolder: string;
  SearchRec: TSearchRec;
begin
  VList := TStringList.Create;
  try
    VFolder := IncludeTrailingPathDelimiter(FSourcePath.FullPath);
    if FindFirst(VFolder + '*', faAnyFile, SearchRec) = 0 then begin
      repeat
        if (SearchRec.Attr and faDirectory) = faDirectory then begin
          continue;
        end;
        VExt := UpperCase(ExtractFileExt(SearchRec.Name));
        if (VExt = '.INI') or (VExt = '.TXT') then begin
          VList.Add(SearchRec.Name);
        end;
      until FindNext(SearchRec) <> 0;
    end;
    Result := TStringListStatic.CreateWithOwn(VList);
    VList := nil;
  finally
    VList.Free;
  end;
end;

function TConfigDataProviderByPathConfig.ReadTime(const AIdent: string;
  const ADefault: TDateTime): TDateTime;
begin
  Result := ADefault;
end;

function TConfigDataProviderByPathConfig.ReadValuesList: IStringListStatic;
var
  VList: TStringList;
  VExt: string;
  VFolder: string;
  SearchRec: TSearchRec;
begin
  VList := TStringList.Create;
  try
    VFolder := IncludeTrailingPathDelimiter(FSourcePath.FullPath);
    if FindFirst(VFolder + '*', faAnyFile, SearchRec) = 0 then begin
      repeat
        if (SearchRec.Attr and faDirectory) = faDirectory then begin
          continue;
        end;
        VExt := UpperCase(ExtractFileExt(SearchRec.Name));
        if (VExt <> '.INI') or (VExt = '.HTML') or (VExt = '.TXT') then begin
          VList.Add(SearchRec.Name);
        end;
      until FindNext(SearchRec) <> 0;
    end;
    Result := TStringListStatic.CreateWithOwn(VList);
    VList := nil;
  finally
    VList.Free;
  end;
end;

end.

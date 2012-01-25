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

unit u_ZmpFileNamesIteratorFactory;

interface

uses
  WideStrings,
  i_FileNameIterator;

type
  TZmpFileNamesIteratorFactory = class(TInterfacedObject, IFileNameIteratorFactory)
  private
    FFactory: IFileNameIteratorFactory;
  protected
    function  CreateIterator(
      ARootFolderName: WideString;
      AFolderNameFromRoot: WideString
    ): IFileNameIterator;
  public
    constructor Create();
    destructor Destroy; override;
  end;
implementation

uses
  SysUtils,
  u_FoldersIteratorRecursiveByLevelsWithIgnoredFolders,
  u_FileNameIteratorInFolderByMaskList,
  u_FileNameIteratorFolderWithSubfolders;

{ TZmpFileNamesIteratorFactory }

constructor TZmpFileNamesIteratorFactory.Create;
var
  VIgnoredFodlerMasks: TWideStringList;
  VProcessFileMasks: TWideStringList;
  VFoldersIteratorFactory: IFileNameIteratorFactory;
  VFilesInFolderIteratorFactory: IFileNameIteratorFactory;
begin
  VIgnoredFodlerMasks := TWideStringList.Create;
  VProcessFileMasks := TWideStringList.Create;
  try
    VProcessFileMasks.Add('*.zmp');
    VIgnoredFodlerMasks.Add('*.zmp');
    VIgnoredFodlerMasks.Add('.*');
    VFoldersIteratorFactory :=
      TFoldersIteratorRecursiveByLevelsWithIgnoredFoldersFactory.Create(
        6,
        VIgnoredFodlerMasks
      );
    try
      VFilesInFolderIteratorFactory :=
        TFileNameIteratorInFolderByMaskListFactory.Create(
          VProcessFileMasks,
          False
        );
      try
        FFactory :=
          TFileNameIteratorFolderWithSubfoldersFactory.Create(
            VFoldersIteratorFactory,
            VFilesInFolderIteratorFactory
          );
      finally
        VFilesInFolderIteratorFactory := nil;
      end;
    finally
      VFoldersIteratorFactory := nil;
    end;
  finally
    FreeAndNil(VIgnoredFodlerMasks);
    FreeAndNil(VProcessFileMasks);
  end;
end;

function TZmpFileNamesIteratorFactory.CreateIterator(ARootFolderName,
  AFolderNameFromRoot: WideString): IFileNameIterator;
begin
  Result := FFactory.CreateIterator(ARootFolderName, AFolderNameFromRoot);
end;

destructor TZmpFileNamesIteratorFactory.Destroy;
begin
  FFactory := nil;
  inherited;
end;

end.

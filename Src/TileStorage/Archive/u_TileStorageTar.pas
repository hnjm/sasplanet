{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_TileStorageTar;

interface

uses
  Types,
  i_TileInfoBasic,
  i_ContentTypeInfo,
  i_ContentTypeManager,
  i_ProjectionSet,
  i_TileStorageAbilities,
  i_TileFileNameParser,
  i_TileFileNameGenerator,
  i_ArchiveReadWriteFactory,
  u_TileStorageArchive;

type
  TTileStorageTar = class(TTileStorageArchive)
  protected
    function ScanTiles(
      const AIgnoreTNE: Boolean;
      const AIgnoreMultiVersionTiles: Boolean
    ): IEnumTileInfo; override;
  public
    constructor Create(
      const AStorageTypeAbilities: ITileStorageTypeAbilities;
      const AArchiveFileName: string;
      const AContentType: IContentTypeInfoBasic;
      const AContentTypeManager: IContentTypeManager;
      const AProjectionSet: IProjectionSet;
      const AArchiveFactory: IArchiveWriterFactory;
      const ATileNameParser: ITileFileNameParser;
      const ATileNameGenerator: ITileFileNameGenerator
    );
  end;

implementation

uses
  Classes,
  SysUtils,
  ALString,
  LibTar,
  u_BinaryDataByMemStream,
  u_BaseInterfacedObject;

type
  TEnumTileInfoByTar = class(TBaseInterfacedObject, IEnumTileInfo)
  private
    FTarReader: TTarArchive;
    FIgnoreTNE: Boolean;
    FContentTypeManager: IContentTypeManager;
    FTileFileNameParser: ITileFileNameParser;
  private
    { IEnumTileInfo }
    function Next(var ATileInfo: TTileInfo): Boolean;
  public
    constructor Create(
      const AIgnoreTNE: Boolean;
      const ATarArchiveFileName: string;
      const AContentTypeManager: IContentTypeManager;
      const ATileFileNameParser: ITileFileNameParser
    );
    destructor Destroy; override;
  end;

{ TEnumTileInfoByTar }

constructor TEnumTileInfoByTar.Create(
  const AIgnoreTNE: Boolean;
  const ATarArchiveFileName: string;
  const AContentTypeManager: IContentTypeManager;
  const ATileFileNameParser: ITileFileNameParser
);
begin
  inherited Create;
  FTarReader := TTarArchive.Create(ATarArchiveFileName); // read-only access
  FIgnoreTNE := AIgnoreTNE;
  FContentTypeManager := AContentTypeManager;
  FTileFileNameParser := ATileFileNameParser;
end;

destructor TEnumTileInfoByTar.Destroy;
begin
  FreeAndNil(FTarReader);
  inherited;
end;

function TEnumTileInfoByTar.Next(var ATileInfo: TTileInfo): Boolean;
var
  VZoom: Byte;
  VTileXY: TPoint;
  VExtLow: AnsiString;
  VTileName: AnsiString;
  VTarRec: TTarDirRec;
  VStream: TMemoryStream;
begin
  Result := False;
  while FTarReader.FindNext(VTarRec) do begin
    if VTarRec.FileType = ftNormal then begin // regular file
      VTileName := ALStringReplace(VTarRec.Name, '/', PathDelim, [rfReplaceAll]);
      if FTileFileNameParser.GetTilePoint(VTileName, VTileXY, VZoom) then begin
        ATileInfo.FTile := VTileXY;
        ATileInfo.FZoom := VZoom;
        ATileInfo.FVersionInfo := nil;
        ATileInfo.FSize := VTarRec.Size;
        ATileInfo.FLoadDate := VTarRec.DateTime;

        VExtLow := AlLowerCase(alExtractFileExt(VTileName));
        if VExtLow = '.tne' then begin
          if not FIgnoreTNE then begin
            ATileInfo.FInfoType := titTneExists;
            ATileInfo.FContentType := nil;
            ATileInfo.FData := nil;
            // found "tne"
            Result := True;
            Break;
          end;
        end else begin
          VStream := TMemoryStream.Create;
          try
            ATileInfo.FInfoType := titExists;
            ATileInfo.FContentType := FContentTypeManager.GetInfoByExt(VExtLow);

            FTarReader.ReadFile(VStream);
            Assert(VStream.Size = VTarRec.Size);
            VStream.Position := 0;
            ATileInfo.FData := TBinaryDataByMemStream.CreateWithOwn(VStream);
            VStream := nil;
            // found tile
            Result := True;
            Break;
          finally
            VStream.Free;
          end;
        end;
      end;
    end;
  end;
end;

{ TTileStorageTar }

constructor TTileStorageTar.Create(
  const AStorageTypeAbilities: ITileStorageTypeAbilities;
  const AArchiveFileName: string;
  const AContentType: IContentTypeInfoBasic;
  const AContentTypeManager: IContentTypeManager;
  const AProjectionSet: IProjectionSet;
  const AArchiveFactory: IArchiveWriterFactory;
  const ATileNameParser: ITileFileNameParser;
  const ATileNameGenerator: ITileFileNameGenerator
);
begin
  inherited Create(
    AStorageTypeAbilities,
    AArchiveFileName,
    AContentType,
    AContentTypeManager,
    AProjectionSet,
    AArchiveFactory,
    ATileNameParser,
    ATileNameGenerator
  );
end;

function TTileStorageTar.ScanTiles(
  const AIgnoreTNE: Boolean;
  const AIgnoreMultiVersionTiles: Boolean
): IEnumTileInfo;
begin
  Result :=
    TEnumTileInfoByTar.Create(
      AIgnoreTNE,
      FArchiveFileName,
      FContentTypeManager,
      FTileNameParser
    );
end;

end.

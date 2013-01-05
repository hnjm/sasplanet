unit u_TileStorageTypeFileSystemSimple;

interface

uses
  i_CoordConverter,
  i_ContentTypeInfo,
  i_TileFileNameGenerator,
  i_TileFileNameParser,
  i_TileStorage,
  i_TileInfoBasicMemCache,
  i_TileStorageTypeConfig,
  u_TileStorageTypeBase;

type
  TTileStorageTypeFileSystemSimple = class(TTileStorageTypeBase)
  private
    FNameGenerator: ITileFileNameGenerator;
    FTileNameParser: ITileFileNameParser;
  protected
    function BuildStorage(
      const AGeoConverter: ICoordConverter;
      const AMainContentType: IContentTypeInfoBasic;
      const APath: string;
      const ACacheTileInfo: ITileInfoBasicMemCache
    ): ITileStorage; override;
  public
    constructor Create(
      const ANameGenerator: ITileFileNameGenerator;
      const ATileNameParser: ITileFileNameParser;
      const AConfig: ITileStorageTypeConfig
    );
  end;

implementation

uses
  u_TileStorageTypeAbilities,
  u_TileStorageFileSystem,
  u_MapVersionFactorySimpleString;

{ TTileStorageTypeFileSystemSimple }

constructor TTileStorageTypeFileSystemSimple.Create(
  const ANameGenerator: ITileFileNameGenerator;
  const ATileNameParser: ITileFileNameParser;
  const AConfig: ITileStorageTypeConfig
);
begin
  inherited Create(
    TTileStorageTypeAbilitiesFileFolder.Create,
    TMapVersionFactorySimpleString.Create,
    AConfig
  );
  FNameGenerator := ANameGenerator;
  FTileNameParser := ATileNameParser;
end;

function TTileStorageTypeFileSystemSimple.BuildStorage(
  const AGeoConverter: ICoordConverter;
  const AMainContentType: IContentTypeInfoBasic;
  const APath: string;
  const ACacheTileInfo: ITileInfoBasicMemCache
): ITileStorage;
begin
  Result :=
    TTileStorageFileSystem.Create(
      AGeoConverter,
      APath,
      AMainContentType,
      GetMapVersionFactory,
      FNameGenerator,
      FTileNameParser
    );
end;

end.

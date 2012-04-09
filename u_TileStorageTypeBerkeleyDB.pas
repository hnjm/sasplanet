unit u_TileStorageTypeBerkeleyDB;

interface

uses
  i_TileStorage,
  i_TileStorageTypeConfig,
  u_TileStorageTypeBase;

type
  TTileStorageTypeBerkeleyDB = class(TTileStorageTypeBase)
  protected
    function BuildStorage(const APath: string): ITileStorage; override;
  public
    constructor Create(
      const AGUID: TGUID;
      const ACaption: string;
      const AConfig: ITileStorageTypeConfig
    );
  end;

implementation

uses
  u_TileStorageTypeAbilities,
  u_MapVersionFactorySimpleString;

{ TTileStorageTypeBerkeleyDB }

constructor TTileStorageTypeBerkeleyDB.Create(
  const AGUID: TGUID;
  const ACaption: string;
  const AConfig: ITileStorageTypeConfig
);
begin
  inherited Create(
    AGUID,
    ACaption,
    TTileStorageTypeAbilitiesBerkeleyDB.Create,
    TMapVersionFactorySimpleString.Create,
    AConfig
  );
end;

function TTileStorageTypeBerkeleyDB.BuildStorage(const APath: string): ITileStorage;
begin
  Assert(False);
  //TODO: �������� �������� ���������
end;

end.

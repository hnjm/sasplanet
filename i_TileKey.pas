unit i_TileKey;

interface

uses
  Types,
  i_MapVersionInfo;

type
  ITileKey = interface
  ['{C9875442-9A76-4815-9E18-E129838AC83E}']
    function GetTile: TPoint;
    property Tile: TPoint read GetTile;

    function GetZoom: Byte;
    property Zoom: Byte read GetZoom;

    function GetVersionInfo: IMapVersionInfo;
    property VersionInfo: IMapVersionInfo read GetVersionInfo;

    function IsSame(const AValue: ITileKey): Boolean;
  end;

implementation

end.

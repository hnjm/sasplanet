unit i_ITileRequestProcessorPool;

interface

uses
  i_TileDownloaderAsync;

type
  ITileRequestProcessorPool = interface
    ['{F262A368-51F8-4B47-A85E-B6DC27B57A9C}']
    procedure InitThreadsIfNeed;
  end;

implementation

end.

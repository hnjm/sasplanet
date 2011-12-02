unit i_TileDownloadRequestBuilderFactory;

interface

uses
  i_TileDownloaderState,
  i_TileDownloadRequestBuilder;

type
  ITileDownloadRequestBuilderFactory = interface
    ['{325CF600-26D2-484E-B261-5C30FC5744E7}']
    function GetState: ITileDownloaderStateChangeble;
    property State: ITileDownloaderStateChangeble read GetState;

    function BuildRequestBuilder: ITileDownloadRequestBuilder;
  end;

implementation

end.

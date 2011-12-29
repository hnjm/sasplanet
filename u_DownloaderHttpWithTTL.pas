unit u_DownloaderHttpWithTTL;

interface

uses
  i_OperationNotifier,
  i_TTLCheckListener,
  i_TTLCheckNotifier,
  i_DownloadRequest,
  i_DownloadResult,
  i_DownloadResultFactory,
  i_Downloader,
  u_DownloaderHttp;

type
  TDownloaderHttpWithTTL = class(TInterfacedObject, IDownloader)
  private
    FResultFactory: IDownloadResultFactory;
    FGCList: ITTLCheckNotifier;

    FTTLListener: ITTLCheckListener;

    FDownloader: IDownloader;
    procedure OnTTLTrim(Sender: TObject);
  protected
    function DoRequest(
      ARequest: IDownloadRequest;
      ACancelNotifier: IOperationNotifier;
      AOperationID: Integer
    ): IDownloadResult;
  public
    constructor Create(
      AGCList: ITTLCheckNotifier;
      AResultFactory: IDownloadResultFactory
    );
    destructor Destroy; override;
  end;

implementation

uses
  u_TTLCheckListener;

{ TDownloaderHttpWithTTL }

constructor TDownloaderHttpWithTTL.Create(
  AGCList: ITTLCheckNotifier;
  AResultFactory: IDownloadResultFactory
);
begin
  FResultFactory := AResultFactory;
  FGCList := AGCList;

  FTTLListener := TTTLCheckListener.Create(Self.OnTTLTrim, 10000, 1000);
  FGCList.Add(FTTLListener);
end;

destructor TDownloaderHttpWithTTL.Destroy;
begin
  FGCList.Remove(FTTLListener);
  FTTLListener := nil;
  FGCList := nil;
  inherited;
end;

function TDownloaderHttpWithTTL.DoRequest(
  ARequest: IDownloadRequest;
  ACancelNotifier: IOperationNotifier;
  AOperationID: Integer
): IDownloadResult;
var
  VDownloader: IDownloader;
begin
  FTTLListener.UpdateUseTime;
  VDownloader := FDownloader;
  if VDownloader = nil then begin
    VDownloader := TDownloaderHttp.Create(FResultFactory);
    FDownloader := VDownloader;
  end;
  Result := VDownloader.DoRequest(ARequest, ACancelNotifier, AOperationID);
  FTTLListener.UpdateUseTime;
end;

procedure TDownloaderHttpWithTTL.OnTTLTrim(Sender: TObject);
begin
  FDownloader := nil;
end;

end.

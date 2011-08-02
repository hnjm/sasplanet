unit u_DownloadResultFactoryTileDownload;

interface

uses
  Types,
  i_DownloadResult,
  i_TileDownloadResult,
  u_MapType,
  i_DownloadResultTextProvider,
  i_DownloadResultFactory;

type
  TDownloadResultFactoryTileDownload = class(TInterfacedObject, IDownloadResultFactory)
  private
    FTextProvider: IDownloadResultTextProvider;
    FUrl: string;
    FRequestHead: string;
    FTileInfo: ITileInfo;
  protected
    function BuildCanceled: IDownloadResultCanceled;
    function BuildOk(
      const AStatusCode: Cardinal;
      const ARawResponseHeader: string;
      const AContentType: string;
      const ASize: Integer;
      const ABuffer: Pointer
    ): IDownloadResultOk;
    function BuildUnexpectedProxyAuth: IDownloadResultProxyError;
    function BuildBadProxyAuth: IDownloadResultProxyError;
    function BuildNoConnetctToServerByErrorCode(
      const AErrorCode: DWORD
    ): IDownloadResultNoConnetctToServer;
    function BuildLoadErrorByStatusCode(
      const AStatusCode: DWORD
    ): IDownloadResultError;
    function BuildLoadErrorByUnknownStatusCode(
      const AStatusCode: DWORD
    ): IDownloadResultError;
    function BuildLoadErrorByErrorCode(
      const AErrorCode: DWORD
    ): IDownloadResultError;
    function BuildBadContentType(
      const AContentType, ARawResponseHeader: string
    ): IDownloadResultBadContentType;
    function BuildBanned(
      const ARawResponseHeader: string
    ): IDownloadResultBanned;
    function BuildDataNotExists(
      const AReasonText, ARawResponseHeader: string
    ): IDownloadResultDataNotExists;
    function BuildDataNotExistsByStatusCode(
      const ARawResponseHeader: string;
      const AStatusCode: DWORD
    ): IDownloadResultDataNotExists;
    function BuildDataNotExistsZeroSize(
      const ARawResponseHeader: string
    ): IDownloadResultDataNotExists;
    function BuildNotNecessary(
      const AReasonText, ARawResponseHeader: string
    ): IDownloadResultNotNecessary;
  public
    constructor Create(
      ATextProvider: IDownloadResultTextProvider;
      AZoom: Byte;
      AXY: TPoint;
      AMapType: TMapType;
      AUrl: string;
      ARequestHead: string
    );
  end;

implementation

uses
  u_TileDownloadResult;

{ TDownloadResultFactorySimpleDownload }

constructor TDownloadResultFactoryTileDownload.Create(
  ATextProvider: IDownloadResultTextProvider;
  AZoom: Byte;
  AXY: TPoint;
  AMapType: TMapType;
  AUrl, ARequestHead: string
);
begin
  FTileInfo := TTileInfo.Create(AZoom, AXY, AMapType);
  FUrl := AUrl;
  FRequestHead := ARequestHead;
  FTextProvider := ATextProvider;
end;

function TDownloadResultFactoryTileDownload.BuildBadContentType(
  const AContentType, ARawResponseHeader: string
): IDownloadResultBadContentType;
begin
  Result := TTileDownloadResultBadContentType.Create(FTileInfo, FUrl, FRequestHead, AContentType, ARawResponseHeader, '����������� ��� %s');
end;

function TDownloadResultFactoryTileDownload.BuildBadProxyAuth: IDownloadResultProxyError;
begin
  Result := TTileDownloadResultProxyError.Create(FTileInfo, FUrl, FRequestHead, '������ ����������� �� ������');
end;

function TDownloadResultFactoryTileDownload.BuildBanned(
  const ARawResponseHeader: string
): IDownloadResultBanned;
begin
  Result := TTileDownloadResultBanned.Create(FTileInfo, FUrl, FRequestHead, ARawResponseHeader, '������ ��� ��������');
end;

function TDownloadResultFactoryTileDownload.BuildCanceled: IDownloadResultCanceled;
begin
  Result := TTileDownloadResultCanceled.Create(FTileInfo, FUrl, FRequestHead);
end;

function TDownloadResultFactoryTileDownload.BuildDataNotExists(
  const AReasonText, ARawResponseHeader: string
): IDownloadResultDataNotExists;
begin
  Result := TTileDownloadResultDataNotExists.Create(FTileInfo, FUrl, FRequestHead, AReasonText, ARawResponseHeader);
end;

function TDownloadResultFactoryTileDownload.BuildDataNotExistsByStatusCode(
  const ARawResponseHeader: string;
  const AStatusCode: DWORD
): IDownloadResultDataNotExists;
begin
  Result := TTileDownloadResultDataNotExistsByStatusCode.Create(FTileInfo, FUrl, FRequestHead, ARawResponseHeader, '������� �����������. ������ %d', AStatusCode);
end;

function TDownloadResultFactoryTileDownload.BuildDataNotExistsZeroSize(
  const ARawResponseHeader: string
): IDownloadResultDataNotExists;
begin
  Result := TTileDownloadResultDataNotExistsZeroSize.Create(FTileInfo, FUrl, FRequestHead, ARawResponseHeader, '������� ����� ������� ������');
end;

function TDownloadResultFactoryTileDownload.BuildLoadErrorByErrorCode(
  const AErrorCode: DWORD
): IDownloadResultError;
begin
  Result := TTileDownloadResultLoadErrorByErrorCode.Create(FTileInfo, FUrl, FRequestHead, '������ ��������. ��� ������ %d', AErrorCode);
end;

function TDownloadResultFactoryTileDownload.BuildLoadErrorByStatusCode(
  const AStatusCode: DWORD
): IDownloadResultError;
begin
  Result := TTileDownloadResultLoadErrorByStatusCode.Create(FTileInfo, FUrl, FRequestHead, '������ ��������. ������ %d', AStatusCode);
end;

function TDownloadResultFactoryTileDownload.BuildLoadErrorByUnknownStatusCode(
  const AStatusCode: DWORD
): IDownloadResultError;
begin
  Result := TTileDownloadResultLoadErrorByUnknownStatusCode.Create(FTileInfo, FUrl, FRequestHead, '����������� ������ %d', AStatusCode);
end;

function TDownloadResultFactoryTileDownload.BuildNoConnetctToServerByErrorCode(
  const AErrorCode: DWORD
): IDownloadResultNoConnetctToServer;
begin
  Result := TTileDownloadResultNoConnetctToServerByErrorCode.Create(FTileInfo, FUrl, FRequestHead, '������ ����������� � �������. ��� ������ %d', AErrorCode);
end;

function TDownloadResultFactoryTileDownload.BuildNotNecessary(
  const AReasonText, ARawResponseHeader: string
): IDownloadResultNotNecessary;
begin
  Result := TTileDownloadResultNotNecessary.Create(FTileInfo, FUrl, FRequestHead, AReasonText, ARawResponseHeader);
end;

function TDownloadResultFactoryTileDownload.BuildOk(
  const AStatusCode: Cardinal;
  const ARawResponseHeader, AContentType: string;
  const ASize: Integer;
  const ABuffer: Pointer
): IDownloadResultOk;
begin
  Result := TTileDownloadResultOk.Create(FTileInfo, FUrl, FRequestHead, AStatusCode, ARawResponseHeader, AContentType, ASize, ABuffer);
end;

function TDownloadResultFactoryTileDownload.BuildUnexpectedProxyAuth: IDownloadResultProxyError;
begin
  Result := TTileDownloadResultProxyError.Create(FTileInfo, FUrl, FRequestHead, '��������� �� ��������������� ����������� �� ������');
end;

end.


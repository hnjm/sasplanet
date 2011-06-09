unit u_DownloadExceptions;

interface

uses
  SysUtils;

type
  EDownloadErrorBase = class(Exception);

  EDownloadErrorWithoutConnect = class(EDownloadErrorBase);

  EProxyAuthError = class(EDownloadErrorWithoutConnect);
  ENoServerConnection = class(EDownloadErrorWithoutConnect);

  EDownloadErrorWithConnect = class(EDownloadErrorBase);

  EMimeTypeError = class(EDownloadErrorWithConnect);
  ESameTileSize = class(EDownloadErrorWithConnect);
  ETileNotExists = class(EDownloadErrorWithConnect);
  EFileNotExistsByHTTPStatus = class(ETileNotExists)
  public
    constructor CreateByStatus(AStatusCode: Cardinal);
  end;
  EFileNotExistsByResultZeroSize = class(ETileNotExists)
  public
    constructor Create;
  end;
  EDownloadBanned = class(EDownloadErrorWithConnect);
  EDownloadError = class(EDownloadErrorWithConnect);
  EDownloadErrorByHTTPStatus = class(EDownloadError)
  public
    constructor CreateByStatus(AStatusCode: Cardinal);
  end;
  EDownloadErrorUnknownHTTPStatus = class(EDownloadError)
  public
    constructor CreateByStatus(AStatusCode: Cardinal);
  end;


implementation

{ EFileNotExistsByHTTPStatus }

constructor EFileNotExistsByHTTPStatus.CreateByStatus(AStatusCode: Cardinal);
begin
  inherited CreateFmt('��� ������. ������ %d', [AStatusCode]);
end;

{ EDownloadErrorByHTTPStatus }

constructor EDownloadErrorByHTTPStatus.CreateByStatus(AStatusCode: Cardinal);
begin
  inherited CreateFmt('������ ��������. ������ %d', [AStatusCode]);
end;

{ EFileNotExistsByResultZeroSize }

constructor EFileNotExistsByResultZeroSize.Create;
begin
  inherited Create('������ ���������� ������ ����� ����');
end;

{ EDownloadErrorUnknownHTTPStatus }

constructor EDownloadErrorUnknownHTTPStatus.CreateByStatus(
  AStatusCode: Cardinal);
begin
  inherited CreateFmt('����������� ������ %d', [AStatusCode]);
end;

end.

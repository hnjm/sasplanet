unit u_DownloadCheckerStuped;

interface

uses
  Classes,
  i_DownloadResult,
  i_DownloadResultFactory,
  i_DownloadChecker;

type
  TDownloadCheckerStuped = class(TInterfacedObject, IDownloadChecker)
  private
    FResultFactory: IDownloadResultFactory;
    FIgnoreMIMEType: Boolean;
    FExpectedMIMETypes: string;
    FDefaultMIMEType: string;
    FCheckTileSize: Boolean;
    FExistsFileSize: Cardinal;
  protected
    function BeforeRequest(AUrl:  string; ARequestHead: string): IDownloadResult;
    function AfterResponce(
      var AStatusCode: Cardinal;
      var AContentType: string;
      var AResponseHead: string
    ): IDownloadResult;
    function AfterReciveData(
      ARecivedSize: Integer;
      ARecivedBuffer: Pointer;
      var AStatusCode: Cardinal;
      var AResponseHead: string
    ): IDownloadResult;
  public
    constructor Create(
      AResultFactory: IDownloadResultFactory;
      AIgnoreMIMEType: Boolean;
      AExpectedMIMETypes: string;
      ADefaultMIMEType: string;
      ACheckTileSize: Boolean;
      AExistsFileSize: Cardinal
    );
  end;

implementation

uses
  SysUtils,
  u_UrlGeneratorHelpers,
  u_DownloadExceptions;

{ TDownloadCheckerStuped }

constructor TDownloadCheckerStuped.Create(
  AResultFactory: IDownloadResultFactory;
  AIgnoreMIMEType: Boolean;
  AExpectedMIMETypes, ADefaultMIMEType: string;
  ACheckTileSize: Boolean;
  AExistsFileSize: Cardinal
);
begin
  FResultFactory := AResultFactory;
  FIgnoreMIMEType := AIgnoreMIMEType;
  FExpectedMIMETypes := AExpectedMIMETypes;
  FDefaultMIMEType := ADefaultMIMEType;
  FCheckTileSize := ACheckTileSize;
  FExistsFileSize := AExistsFileSize;
end;

function TDownloadCheckerStuped.BeforeRequest(
  AUrl, ARequestHead: string
): IDownloadResult;
begin
// ������ ������
end;

function TDownloadCheckerStuped.AfterResponce(
  var AStatusCode: Cardinal;
  var AContentType: string;
  var AResponseHead: string
): IDownloadResult;
var
  VContentLenAsStr: string;
  VContentLen: Int64;
begin
  if FIgnoreMIMEType then begin
    AContentType := FDefaultMIMEType;
  end else begin
    if (AContentType = '') then begin
      AContentType := FDefaultMIMEType;
    end else if (Pos(AContentType, FExpectedMIMETypes) <= 0) then begin
      raise EMimeTypeError.CreateFmt('����������� ��� %s', [AContentType]);
    end;
  end;
  if FCheckTileSize then begin
    VContentLenAsStr := GetHeaderValue(AResponseHead, 'Conternt Length');
    if VContentLenAsStr <> '' then begin
      if TryStrToInt64(VContentLenAsStr, VContentLen) then begin
        if VContentLen = FExistsFileSize then begin
          raise ESameTileSize.Create('���������� ������ �����');
        end;
      end;
    end;
  end;
end;

function TDownloadCheckerStuped.AfterReciveData(
  ARecivedSize: Integer;
  ARecivedBuffer: Pointer;
  var AStatusCode: Cardinal;
  var AResponseHead: string
): IDownloadResult;
begin
  if FCheckTileSize then begin
    if ARecivedSize = FExistsFileSize then begin
      raise ESameTileSize.Create('���������� ������ �����');
    end;
  end;
end;

end.

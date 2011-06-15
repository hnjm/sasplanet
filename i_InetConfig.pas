unit i_InetConfig;

interface

uses
  i_ConfigDataElement,
  i_ProxySettings;

type
  IInetConfigStatic = interface
    ['{5608C1CA-91D5-43CB-BAF0-8C76351EC1D7}']
    function GetProxyConfigStatic: IProxyConfigStatic;
    property ProxyConfigStatic: IProxyConfigStatic read GetProxyConfigStatic;

    function GetUserAgentString: string;
    property UserAgentString: string read GetUserAgentString;

    function GetTimeOut: Cardinal;
    property TimeOut: Cardinal read GetTimeOut;

    function GetSleepOnResetConnection: Cardinal;
    property SleepOnResetConnection: Cardinal read GetSleepOnResetConnection;

    function GetDownloadTryCount: Integer;
    property DownloadTryCount: Integer read GetDownloadTryCount;
  end;

  IInetConfig = interface(IConfigDataElement)
    ['{D025A3CE-2CC7-4DB3-BBF6-53DF14A2A2E7}']
    function GetProxyConfig: IProxyConfig;
    property ProxyConfig: IProxyConfig read GetProxyConfig;

    function GetUserAgentString: string;
    procedure SetUserAgentString(AValue: string);
    property UserAgentString: string read GetUserAgentString write SetUserAgentString;

    function GetTimeOut: Cardinal;
    procedure SetTimeOut(AValue: Cardinal);
    property TimeOut: Cardinal read GetTimeOut write SetTimeOut;

    function GetSleepOnResetConnection: Cardinal;
    procedure SetSleepOnResetConnection(AValue: Cardinal);
    property SleepOnResetConnection: Cardinal read GetSleepOnResetConnection write SetSleepOnResetConnection;

    function GetDownloadTryCount: Integer;
    procedure SetDownloadTryCount(AValue: Integer);
    property DownloadTryCount: Integer read GetDownloadTryCount write SetDownloadTryCount;

    function GetStatic: IInetConfigStatic;
  end;

implementation

end.

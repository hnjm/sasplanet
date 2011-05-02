unit u_WindowLayerBasic;

interface

uses
  Windows,
  SyncObjs,
  i_JclListenerNotifierLinksList;

type
  TWindowLayerAbstract = class
  private
    FCS: TCriticalSection;
    FRedrawCounter: Cardinal;
    FRedrawTime: TDateTime;
  private
    FLinksList: IJclListenerNotifierLinksList;
  protected
    procedure IncRedrawCounter(ATime: TDateTime);
    property LinksList: IJclListenerNotifierLinksList read FLinksList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure StartThreads; virtual;
    procedure SendTerminateToThreads; virtual;
    property RedrawCounter: Cardinal read FRedrawCounter;
    property RedrawTime: TDateTime read FRedrawTime;
  end;

implementation

uses
  SysUtils,
  Types,
  u_JclListenerNotifierLinksList;

{ TWindowLayerAbstract }

constructor TWindowLayerAbstract.Create;
begin
  FCS := TCriticalSection.Create;
  FRedrawCounter := 0;
  FRedrawTime  := 0;
  FLinksList := TJclListenerNotifierLinksList.Create;
end;

destructor TWindowLayerAbstract.Destroy;
begin
  FLinksList := nil;
  FreeAndNil(FCS);
  inherited;
end;

procedure TWindowLayerAbstract.IncRedrawCounter(ATime: TDateTime);
begin
  FCS.Acquire;
  try
    Inc(FRedrawCounter);
    FRedrawTime := FRedrawTime + ATime;
  finally
    FCS.Release;
  end;
end;

procedure TWindowLayerAbstract.SendTerminateToThreads;
begin
  FLinksList.DeactivateLinks;
end;

procedure TWindowLayerAbstract.StartThreads;
begin
  FLinksList.ActivateLinks;
end;

end.

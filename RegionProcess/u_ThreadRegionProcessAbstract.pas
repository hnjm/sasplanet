unit u_ThreadRegionProcessAbstract;

interface

uses
  Classes,
  i_Listener,
  i_VectorItemLonLat,
  i_NotifierOperation,
  i_RegionProcessProgressInfo;

type
  TThreadRegionProcessAbstract = class(TThread)
  private
    FOperationID: Integer;
    FCancelListener: IListener;
    FProgressInfo: IRegionProcessProgressInfoInternal;
    FPolygLL: ILonLatPolygon;

    FMessageForShow: string;
    FCancelNotifier: INotifierOperation;
    procedure OnCancel;
    procedure SynShowMessage;
    procedure ShowMessageSync(const AMessage: string);
  protected
    procedure ProcessRegion; virtual; abstract;
    procedure Execute; override;

    property CancelNotifier: INotifierOperation read FCancelNotifier;
    property OperationID: Integer read FOperationID;
    property ProgressInfo: IRegionProcessProgressInfoInternal read FProgressInfo;
    property PolygLL: ILonLatPolygon read FPolygLL;
  public
    constructor Create(
      const ACancelNotifier: INotifierOperation;
      AOperationID: Integer;
      const AProgressInfo: IRegionProcessProgressInfoInternal;
      const APolygon: ILonLatPolygon
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  Dialogs,
  u_NotifyEventListener;

constructor TThreadRegionProcessAbstract.Create(
  const ACancelNotifier: INotifierOperation;
  AOperationID: Integer;
  const AProgressInfo: IRegionProcessProgressInfoInternal;
  const APolygon: ILonLatPolygon
);
begin
  inherited Create(false);
  Priority := tpLowest;
  FreeOnTerminate := true;
  FCancelNotifier := ACancelNotifier;
  FOperationID := AOperationID;
  FProgressInfo := AProgressInfo;
  FPolygLL := APolygon;
  if not FCancelNotifier.IsOperationCanceled(FOperationID) then begin
    FCancelListener := TNotifyNoMmgEventListener.Create(Self.OnCancel);
    FCancelNotifier.AddListener(FCancelListener);
  end;
  if FCancelNotifier.IsOperationCanceled(FOperationID) then begin
    Terminate;
  end;
end;

destructor TThreadRegionProcessAbstract.Destroy;
begin
  if (FCancelListener <> nil) and (FCancelNotifier <> nil) then begin
    FCancelNotifier.RemoveListener(FCancelListener);
    FCancelListener := nil;
    FCancelNotifier := nil;
  end;
  FPolygLL := nil;
  FProgressInfo.Finish;
  FProgressInfo := nil;
  inherited;
end;

procedure TThreadRegionProcessAbstract.Execute;
begin
  try
    ProcessRegion;
  except
    on e: Exception do begin
      ShowMessageSync(e.Message);
    end;
  end;
end;

procedure TThreadRegionProcessAbstract.OnCancel;
begin
  Terminate;
end;

procedure TThreadRegionProcessAbstract.ShowMessageSync(const AMessage: string);
begin
  FMessageForShow := AMessage;
  Synchronize(SynShowMessage);
end;

procedure TThreadRegionProcessAbstract.SynShowMessage;
begin
  ShowMessage(FMessageForShow);
end;

end.



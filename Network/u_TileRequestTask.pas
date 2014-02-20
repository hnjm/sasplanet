unit u_TileRequestTask;

interface

uses
  Windows,
  i_NotifierOperation,
  i_TileRequest,
  i_TileRequestResult,
  i_TileRequestTask,
  u_BaseInterfacedObject;

type
  TTileRequestTask = class(TBaseInterfacedObject, ITileRequestTask, ITileRequestTaskInternal)
  private
    FTileRequest: ITileRequest;
    FSoftCancelNotifier: INotifierOneOperation;
    FCancelNotifier: INotifierOperation;
    FOperationID: Integer;
    FFinishNotifier: ITileRequestTaskFinishNotifier;
  private
    { ITileRequestTask }
    function GetTileRequest: ITileRequest;
    function GetSoftCancelNotifier: INotifierOneOperation;
    function GetCancelNotifier: INotifierOperation;
    function GetOperationID: Integer;
    { ITileRequestTaskInternal }
    procedure SetFinished(const AResult: ITileRequestResult);
  public
    constructor Create(
      const ATileRequest: ITileRequest;
      const ASoftCancelNotifier: INotifierOneOperation;
      const ACancelNotifier: INotifierOperation;
      const AOperationID: Integer;
      const AFinishNotifier: ITileRequestTaskFinishNotifier
    );
  end;

  TTileRequestTaskFinishNotifierCallBack = procedure(
    const ATask: ITileRequestTask;
    const AResult: ITileRequestResult
  ) of object;

  TTileRequestTaskFinishNotifier = class(TBaseInterfacedObject, ITileRequestTaskFinishNotifier)
  private
    FEnabled: Integer;
    FCallBack: TTileRequestTaskFinishNotifierCallBack;
  private
    procedure Notify(
      const ATask: ITileRequestTask;
      const AResult: ITileRequestResult
    );
    procedure SetEnabled(const AValue: Boolean);
    function GetEnabled: Boolean;
  public
    constructor Create(const ACallBack: TTileRequestTaskFinishNotifierCallBack);
  end;


implementation

{ TTileRequestTask }

constructor TTileRequestTask.Create(
  const ATileRequest: ITileRequest;
  const ASoftCancelNotifier: INotifierOneOperation;
  const ACancelNotifier: INotifierOperation;
  const AOperationID: Integer;
  const AFinishNotifier: ITileRequestTaskFinishNotifier
);
begin
  Assert(AFinishNotifier <> nil);
  inherited Create;
  FTileRequest := ATileRequest;
  FSoftCancelNotifier := ASoftCancelNotifier;
  FCancelNotifier := ACancelNotifier;
  FOperationID := AOperationID;
  FFinishNotifier := AFinishNotifier;
end;

function TTileRequestTask.GetSoftCancelNotifier: INotifierOneOperation;
begin
  Result := FSoftCancelNotifier;
end;

function TTileRequestTask.GetCancelNotifier: INotifierOperation;
begin
  Result := FCancelNotifier;
end;

function TTileRequestTask.GetOperationID: Integer;
begin
  Result := FOperationID;
end;

function TTileRequestTask.GetTileRequest: ITileRequest;
begin
  Result := FTileRequest;
end;

procedure TTileRequestTask.SetFinished(const AResult: ITileRequestResult);
begin
  FFinishNotifier.Notify(Self, AResult);
end;

{ TTileRequestTaskFinishNotifier }

constructor TTileRequestTaskFinishNotifier.Create(
 const ACallBack: TTileRequestTaskFinishNotifierCallBack
);
begin
  Assert(Assigned(ACallBack));
  inherited Create;
  FCallBack := ACallBack;
  FEnabled := 1;
end;

procedure TTileRequestTaskFinishNotifier.Notify(
  const ATask: ITileRequestTask;
  const AResult: ITileRequestResult
);
begin
  if InterlockedCompareExchange(FEnabled, 0, 0) > 0 then begin
    FCallBack(ATask, AResult);
  end;
end;

procedure TTileRequestTaskFinishNotifier.SetEnabled(const AValue: Boolean);
begin
  if AValue then begin
    InterlockedExchange(FEnabled, 1);
  end else begin
    InterlockedExchange(FEnabled, 0);
  end;
end;

function TTileRequestTaskFinishNotifier.GetEnabled: Boolean;
begin
  Result := InterlockedCompareExchange(FEnabled, 0, 0) > 0;
end;

end.

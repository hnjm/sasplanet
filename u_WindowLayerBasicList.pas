unit u_WindowLayerBasicList;

interface

uses
  Classes,
  u_WindowLayerBasic;

type
  TWindowLayerBasicList = class
  private
    FList: TList;
    function GetCount: Integer;
  protected
    function Get(AIndex: Integer): TWindowLayerAbstract;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AItem: TWindowLayerAbstract): Integer;
    procedure StartThreads;
    procedure SendTerminateToThreads;
    property Items[Index: Integer]: TWindowLayerAbstract read Get; default;
    property Count: Integer read GetCount;
  end;

implementation

uses
  SysUtils;

{ TWindowLayerBasicList }

function TWindowLayerBasicList.Add(AItem: TWindowLayerAbstract): Integer;
begin
  Result := FList.Add(AItem);
end;

constructor TWindowLayerBasicList.Create;
begin
  FList := TList.Create;;
end;

destructor TWindowLayerBasicList.Destroy;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do begin
    Items[i].Free;
  end;
  FreeAndNil(FList);
  inherited;
end;

function TWindowLayerBasicList.Get(AIndex: Integer): TWindowLayerAbstract;
begin
  Result := TWindowLayerAbstract(FList.Items[AIndex]);
end;

function TWindowLayerBasicList.GetCount: Integer;
begin
  Result := FList.Count;
end;

procedure TWindowLayerBasicList.SendTerminateToThreads;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do begin
    Items[i].SendTerminateToThreads;
  end;
end;

procedure TWindowLayerBasicList.StartThreads;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do begin
    Items[i].StartThreads;
  end;
end;

end.

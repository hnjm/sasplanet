unit u_InterfaceListSimple;

interface

uses
  Classes,
  i_InterfaceListStatic,
  i_InterfaceListSimple,
  u_BaseInterfacedObject;

type
  TInterfaceListSimple = class(TBaseInterfacedObject, IInterfaceListSimple)
  private
    FList: TList;
  private
    procedure Clear;
    procedure Delete(AIndex: Integer);
    procedure Exchange(AIndex1, AIndex2: Integer);
    function First: IInterface;
    function IndexOf(const AItem: IInterface): Integer;
    function Add(const AItem: IInterface): Integer;
    procedure AddList(const AList: IInterfaceList);
    procedure AddListStatic(const AList: IInterfaceListStatic);
    procedure AddListSimple(const AList: IInterfaceListSimple);
    procedure Insert(AIndex: Integer; const AItem: IInterface);
    function Last: IInterface;
    function Remove(const AItem: IInterface): Integer;

    function GetItem(AIndex: Integer): IInterface;
    procedure SetItem(AIndex: Integer; const AItem: IInterface);

    function GetCapacity: Integer;
    procedure SetCapacity(ANewCapacity: Integer);

    function GetCount: Integer;
    procedure SetCount(ANewCount: Integer);

    function MakeStaticAndClear: IInterfaceListStatic;
    function MakeStaticCopy: IInterfaceListStatic;
  public
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  u_InterfaceListStatic;

{ TInterfaceListSimple }

constructor TInterfaceListSimple.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TInterfaceListSimple.Destroy;
var
  i: Integer;
  VItem: Pointer;
begin
  if Assigned(FList) then begin
    for i := 0 to FList.Count - 1 do begin
      VItem := FList[i];
      if Assigned(VItem) then begin
        IInterface(VItem)._Release;
      end;
    end;
    FreeAndNil(FList);
  end;
  inherited;
end;

function TInterfaceListSimple.Add(const AItem: IInterface): Integer;
begin
  Result := FList.Add(nil);
  FList[Result] := Pointer(AItem);
  if Assigned(AItem) then begin
    AItem._AddRef;
  end;
end;

procedure TInterfaceListSimple.AddList(const AList: IInterfaceList);
var
  i: Integer;
begin
  if Assigned(AList) then begin
    AList.Lock;
    try
      for i := 0 to AList.Count - 1 do begin
        Add(AList[i]);
      end;
    finally
      AList.Unlock;
    end;
  end;
end;

procedure TInterfaceListSimple.AddListSimple(const AList: IInterfaceListSimple);
var
  i: Integer;
begin
  if Assigned(AList) then begin
    for i := 0 to AList.Count - 1 do begin
      Add(AList[i]);
    end;
  end;
end;

procedure TInterfaceListSimple.AddListStatic(const AList: IInterfaceListStatic);
var
  i: Integer;
begin
  if Assigned(AList) then begin
    for i := 0 to AList.Count - 1 do begin
      Add(AList[i]);
    end;
  end;
end;

procedure TInterfaceListSimple.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

procedure TInterfaceListSimple.Delete(AIndex: Integer);
var
  VItem: Pointer;
begin
  VItem := FList[AIndex];
  FList.Delete(AIndex);
  if Assigned(VItem) then begin
    IInterface(VItem) := nil;
  end;
end;

procedure TInterfaceListSimple.Exchange(AIndex1, AIndex2: Integer);
begin
  FList.Exchange(AIndex1, AIndex2);
end;

function TInterfaceListSimple.First: IInterface;
begin
  Result := IInterface(FList[0]);
end;

function TInterfaceListSimple.GetCapacity: Integer;
begin
  Result := FList.Capacity;
end;

function TInterfaceListSimple.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TInterfaceListSimple.GetItem(AIndex: Integer): IInterface;
begin
  Result := IInterface(FList[AIndex]);
end;

function TInterfaceListSimple.IndexOf(const AItem: IInterface): Integer;
begin
  Result := FList.IndexOf(Pointer(AItem));
end;

procedure TInterfaceListSimple.Insert(AIndex: Integer; const AItem: IInterface);
begin
  FList.Insert(AIndex, nil);
  FList[AIndex] := Pointer(AItem);
  if Assigned(AItem) then begin
    AItem._AddRef;
  end;
end;

function TInterfaceListSimple.Last: IInterface;
begin
  Result := IInterface(FList[FList.Count - 1]);
end;

function TInterfaceListSimple.MakeStaticAndClear: IInterfaceListStatic;
begin
  Result := TInterfaceListStatic.CreateWithOwn(FList);
  if not Assigned(FList) then begin
    FList := nil;
  end;
end;

function TInterfaceListSimple.MakeStaticCopy: IInterfaceListStatic;
begin
  Result := TInterfaceListStatic.Create(FList);
end;

function TInterfaceListSimple.Remove(const AItem: IInterface): Integer;
begin
  Result := FList.IndexOf(Pointer(AItem));
  if Result > -1 then
  begin
    Delete(Result);
  end;
end;

procedure TInterfaceListSimple.SetCapacity(ANewCapacity: Integer);
begin
  FList.Capacity := ANewCapacity;
end;

procedure TInterfaceListSimple.SetCount(ANewCount: Integer);
var
  i: Integer;
begin
  if FList.Count > ANewCount then begin
    for i := FList.Count - 1 downto ANewCount do begin
      Delete(i);
    end;
  end;
  FList.Count := ANewCount;
end;

procedure TInterfaceListSimple.SetItem(AIndex: Integer; const AItem: IInterface);
var
  VItem: Pointer;
begin
  VItem := FList[AIndex];
  if Assigned(VItem) then begin
    IInterface(VItem) := nil;
  end;
  FList[AIndex] := Pointer(AItem);
  if Assigned(AItem) then begin
    AItem._AddRef;
  end;
end;

end.

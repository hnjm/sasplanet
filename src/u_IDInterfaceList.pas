unit u_IDInterfaceList;

interface

uses
  Classes,
  i_IIDList,
  u_IdListBase;

type
  TInterfaceWithId = record
    Id: Integer;
    Obj: IInterface;
  end;

  PInterfaceWithIdList = ^TInterfaceWithIdList;
  TInterfaceWithIdList = array[0..MaxListSize - 1] of TInterfaceWithId;
  TInterfaceWithIDListSortCompare = function (const Item1, Item2: Integer): Integer of object;

  TIDInterfaceList = class(TIDListBase, IIDInterfaceList)
  protected
    FList: PInterfaceWithIdList;
    procedure SetCapacity(NewCapacity: Integer); override;
    procedure SetCount(NewCount: Integer); override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; AID: Integer; AObj: IInterface);
    procedure Sort(); override;
    function GetItemId(Index: Integer): Integer; override;
  public
    // ���������� �������. ���� ������ � ����� ID ��� ����, �� ���������� �� �����
    // ���������� �������� ������
    function Add(AID: Integer; AInterface: IInterface): IInterface; virtual;

    // ��������� ������� �� ID
    function GetByID(AID: Integer): IInterface; virtual;

    // ������ ������������� ������� �����, ���� �����������, �� ������ ���������
    procedure Replace(AID: Integer; AInterface: IInterface); virtual;
  end;

resourcestring
  SInterfaceIsNilError = 'Interface is nil';

implementation

uses
  SysUtils;

{ TIDInterfaceList }

function TIDInterfaceList.Add(AID: Integer; AInterface: IInterface): IInterface;
var
  VIndex: Integer;
begin
  if (not FAllowNil) and (AInterface = nil) then begin
    raise Exception.Create(LoadResString(@SInterfaceIsNilError));
  end;
  if not Find(AID, VIndex) then begin
    Insert(VIndex, AID, AInterface);
    Result := AInterface;
  end else begin
    Result := FList^[VIndex].Obj;
  end;
end;

procedure TIDInterfaceList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then begin
    Error(@SListIndexError, Index);
  end;
  FList^[Index].Obj := nil;
  Dec(FCount);
  if Index < FCount then begin
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TInterfaceWithId));
  end;
end;

function TIDInterfaceList.GetByID(AID: Integer): IInterface;
var
  VIndex: Integer;
begin
  if Find(AID, VIndex) then begin
    Result := FList^[VIndex].Obj;
  end else begin
    Result := nil;
  end;
end;

function TIDInterfaceList.GetItemID(Index: Integer): Integer;
begin
  Result := FList^[Index].ID;
end;

procedure TIDInterfaceList.Insert(Index, AID: Integer; AObj: IInterface);
begin
  if (Index < 0) or (Index > FCount) then begin
    Error(@SListIndexError, Index);
  end;
  if FCount = FCapacity then begin
    Grow;
  end;
  if Index < FCount then begin
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TInterfaceWithId));
  end;
  FillChar(FList^[Index], SizeOf(TInterfaceWithId), 0);
  FList^[Index].ID := AID;
  FList^[Index].Obj := AObj;
  Inc(FCount);
end;

procedure TIDInterfaceList.Replace(AID: Integer; AInterface: IInterface);
var
  VIndex: Integer;
begin
  if (not FAllowNil) and (AInterface = nil) then begin
    raise Exception.Create(LoadResString(@SInterfaceIsNilError));
  end;
  if Find(AID, VIndex) then begin
    FList^[VIndex].Obj := AInterface;
  end else begin
    Insert(VIndex, AID, AInterface);
  end;
end;

procedure TIDInterfaceList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then begin
    Error(@SListCapacityError, NewCapacity);
  end;
  if NewCapacity <> FCapacity then begin
    ReallocMem(FList, NewCapacity * SizeOf(TInterfaceWithId));
    FCapacity := NewCapacity;
  end;
end;

procedure TIDInterfaceList.SetCount(NewCount: Integer);
var
  I: Integer;
begin
  if (NewCount < 0) or (NewCount > MaxListSize) then begin
    Error(@SListCountError, NewCount);
  end;
  if NewCount > FCapacity then begin
    SetCapacity(NewCount);
  end;
  if NewCount > FCount then begin
    FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(TInterfaceWithID), 0)
  end else begin
    for I := FCount - 1 downto NewCount do begin
      Delete(I);
    end;
  end;
  FCount := NewCount;
end;

procedure QuickSort(SortList: PInterfaceWithIDList; L, R: Integer;
  SCompare: TInterfaceWithIDListSortCompare);
var
  I, J: Integer;
  P, T: TInterfaceWithID;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while SCompare(SortList^[I].ID, P.ID) < 0 do begin
        Inc(I);
      end;
      while SCompare(SortList^[J].ID, P.ID) > 0 do begin
        Dec(J);
      end;
      if I <= J then begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then begin
      QuickSort(SortList, L, J, SCompare);
    end;
    L := I;
  until I >= R;
end;

procedure TIDInterfaceList.Sort;
begin
  if (FList <> nil) and (Count > 0) then begin
    QuickSort(FList, 0, Count - 1, CompareId);
  end;
end;

end.

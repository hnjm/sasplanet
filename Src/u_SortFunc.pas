{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
{* This program is free software: you can redistribute it and/or modify       *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* This program is distributed in the hope that it will be useful,            *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with this program.  If not, see <http://www.gnu.org/licenses/>.      *}
{*                                                                            *}
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_SortFunc;

interface

uses
  i_InterfaceListSimple;

function IsSortedDoubleArray(
  const AArray: array of Double
): Boolean;
function IsSortedIntegerArray(
  const AArray: array of Integer
): Boolean;

procedure SortDoubleArray(
  var AArray: array of Double
);
procedure SortIntegerArray(
  var AArray: array of Integer
);
procedure SortIntegerArrayByIntegerMeasure(
  var AArray: array of Integer;
  var AMeasure: array of Integer
);
procedure SortInterfaceListByDoubleMeasure(
  const AList: IInterfaceListSimple;
  var AMeasure: array of Double
);
procedure SortInterfaceListByIntegerMeasure(
  const AList: IInterfaceListSimple;
  var AMeasure: array of Integer
);

procedure SortInterfaceListByStringMeasure(
  const AList: IInterfaceListSimple;
  var AMeasure: array of string
);

type
  TInterfaceListSortCompareFunction = function (const Item1, Item2: IInterface): Integer;
  TInterfaceListSortCompareFunctor = function (const Item1, Item2: IInterface): Integer of object;

function IsSortedInterfaceListByCompareFunction(
  const AList: IInterfaceListSimple;
  ACompareFunc: TInterfaceListSortCompareFunction
): Boolean;

function IsSortedInterfaceListByCompareFunctor(
  const AList: IInterfaceListSimple;
  ACompareFunc: TInterfaceListSortCompareFunctor
): Boolean;

procedure SortInterfaceListByCompareFunction(
  const AList: IInterfaceListSimple;
  ACompareFunc: TInterfaceListSortCompareFunction
);

procedure SortInterfaceListByCompareFunctor(
  const AList: IInterfaceListSimple;
  ACompareFunc: TInterfaceListSortCompareFunctor
);

implementation

uses
  ExplorerSort;

function IsSortedDoubleArray(
  const AArray: array of Double
): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(AArray) - 1 do begin
    if AArray[i - 1] > AArray[i] then begin
      Result := False;
      Break;
    end;
  end;
end;

function IsSortedIntegerArray(
  const AArray: array of Integer
): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(AArray) - 1 do begin
    if AArray[i - 1] > AArray[i] then begin
      Result := False;
      Break;
    end;
  end;
end;

procedure SortDoubleArray(
  var AArray: array of Double
);
  procedure QuickSort(
    var AArray: array of Double;
    L, R: Integer
  );
  var
    I, J: Integer;
    P: Double;
    T: Double;
  begin
    repeat
      I := L;
      J := R;
      P := AArray[(L + R) shr 1];
      repeat
        while AArray[I] < P do begin
          Inc(I);
        end;
        while AArray[J] > P do begin
          Dec(J);
        end;
        if I <= J then begin
          T := AArray[I];

          AArray[I] := AArray[J];
          AArray[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then begin
        QuickSort(AArray, L, J);
      end;
      L := I;
    until I >= R;
  end;
var
  VCount: Integer;
begin
  VCount := Length(AArray);
  if VCount > 1 then begin
    QuickSort(AArray, 0, VCount - 1);
  end;
end;

procedure SortIntegerArray(
  var AArray: array of Integer
);
  procedure QuickSort(
    var AArray: array of Integer;
    L, R: Integer
  );
  var
    I, J: Integer;
    P: Integer;
    T: Integer;
  begin
    repeat
      I := L;
      J := R;
      P := AArray[(L + R) shr 1];
      repeat
        while AArray[I] < P do begin
          Inc(I);
        end;
        while AArray[J] > P do begin
          Dec(J);
        end;
        if I <= J then begin
          T := AArray[I];

          AArray[I] := AArray[J];
          AArray[J] := T;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then begin
        QuickSort(AArray, L, J);
      end;
      L := I;
    until I >= R;
  end;
var
  VCount: Integer;
begin
  VCount := Length(AArray);
  if VCount > 1 then begin
    QuickSort(AArray, 0, VCount - 1);
  end;
end;

procedure SortIntegerArrayByIntegerMeasure(
  var AArray: array of Integer;
  var AMeasure: array of Integer
);
  procedure QuickSort(
    var AArray: array of Integer;
    var AMeasure: array of Integer;
    L, R: Integer
  );
  var
    I, J: Integer;
    P: Integer;
    TI: Integer;
    TM: Integer;
  begin
    repeat
      I := L;
      J := R;
      P := AMeasure[(L + R) shr 1];
      repeat
        while AMeasure[I] < P do begin
          Inc(I);
        end;
        while AMeasure[J] > P do begin
          Dec(J);
        end;
        if I <= J then begin
          TM := AArray[I];
          AArray[I] := AArray[J];
          AArray[J] := TM;
          TI := AMeasure[I];
          AMeasure[I] := AMeasure[J];
          AMeasure[J] := TI;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then begin
        QuickSort(AArray, AMeasure, L, J);
      end;
      L := I;
    until I >= R;
  end;
var
  VCount: Integer;
begin
  VCount := Length(AMeasure);
  Assert(Length(AArray) = VCount);
  if VCount > 1 then begin
    QuickSort(AArray, AMeasure, 0, VCount - 1);
  end;
end;

procedure SortInterfaceListByDoubleMeasure(
  const AList: IInterfaceListSimple;
  var AMeasure: array of Double
);
  procedure QuickSort(
    const AList: IInterfaceListSimple;
    var AMeasure: array of Double;
    L, R: Integer
  );
  var
    I, J: Integer;
    P: Double;
    TI: Double;
  begin
    repeat
      I := L;
      J := R;
      P := AMeasure[(L + R) shr 1];
      repeat
        while AMeasure[I] < P do begin
          Inc(I);
        end;
        while AMeasure[J] > P do begin
          Dec(J);
        end;
        if I <= J then begin
          AList.Exchange(I, J);
          TI := AMeasure[I];
          AMeasure[I] := AMeasure[J];
          AMeasure[J] := TI;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then begin
        QuickSort(AList, AMeasure, L, J);
      end;
      L := I;
    until I >= R;
  end;
var
  VCount: Integer;
begin
  Assert(Assigned(AList));
  VCount := Length(AMeasure);
  Assert(AList.Count = VCount);
  if VCount > 1 then begin
    QuickSort(AList, AMeasure, 0, VCount - 1);
  end;
end;

procedure SortInterfaceListByIntegerMeasure(
  const AList: IInterfaceListSimple;
  var AMeasure: array of Integer
);
  procedure QuickSort(
    const AList: IInterfaceListSimple;
    var AMeasure: array of Integer;
    L, R: Integer
  );
  var
    I, J: Integer;
    P: Integer;
    TI: Integer;
  begin
    repeat
      I := L;
      J := R;
      P := AMeasure[(L + R) shr 1];
      repeat
        while AMeasure[I] < P do begin
          Inc(I);
        end;
        while AMeasure[J] > P do begin
          Dec(J);
        end;
        if I <= J then begin
          AList.Exchange(I, J);
          TI := AMeasure[I];
          AMeasure[I] := AMeasure[J];
          AMeasure[J] := TI;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then begin
        QuickSort(AList, AMeasure, L, J);
      end;
      L := I;
    until I >= R;
  end;
var
  VCount: Integer;
begin
  Assert(Assigned(AList));
  VCount := Length(AMeasure);
  Assert(AList.Count = VCount);
  if VCount > 1 then begin
    QuickSort(AList, AMeasure, 0, VCount - 1);
  end;
end;

procedure SortInterfaceListByStringMeasure(
  const AList: IInterfaceListSimple;
  var AMeasure: array of string
);
  procedure QuickSort(
    const AList: IInterfaceListSimple;
    var AMeasure: array of string;
    L, R: Integer
  );
  var
    I, J: Integer;
    P: string;
    TI: string;
  begin
    repeat
      I := L;
      J := R;
      P := AMeasure[(L + R) shr 1];
      repeat
        while CompareStringOrdinal(AMeasure[I], P) < 0 do begin
          Inc(I);
        end;
        while CompareStringOrdinal(AMeasure[J], P) > 0 do begin
          Dec(J);
        end;
        if I <= J then begin
          AList.Exchange(I, J);
          TI := AMeasure[I];
          AMeasure[I] := AMeasure[J];
          AMeasure[J] := TI;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then begin
        QuickSort(AList, AMeasure, L, J);
      end;
      L := I;
    until I >= R;
  end;
var
  VCount: Integer;
begin
  Assert(Assigned(AList));
  VCount := Length(AMeasure);
  Assert(AList.Count = VCount);
  if VCount > 1 then begin
    QuickSort(AList, AMeasure, 0, VCount - 1);
  end;
end;

function IsSortedInterfaceListByCompareFunction(
  const AList: IInterfaceListSimple;
  ACompareFunc: TInterfaceListSortCompareFunction
): Boolean;
var
  i: Integer;
begin
  Assert(Assigned(AList));
  Assert(Assigned(ACompareFunc));
  Result := True;
  for i := 1 to AList.Count - 1 do begin
    if ACompareFunc(AList[i - 1], AList[i]) > 0 then begin
      Result := False;
      Break;
    end;
  end;
end;

function IsSortedInterfaceListByCompareFunctor(
  const AList: IInterfaceListSimple;
  ACompareFunc: TInterfaceListSortCompareFunctor
): Boolean;
var
  i: Integer;
begin
  Assert(Assigned(AList));
  Assert(Assigned(ACompareFunc));
  Result := True;
  for i := 1 to AList.Count - 1 do begin
    if ACompareFunc(AList[i - 1], AList[i]) > 0 then begin
      Result := False;
      Break;
    end;
  end;
end;

procedure SortInterfaceListByCompareFunction(
  const AList: IInterfaceListSimple;
  ACompareFunc: TInterfaceListSortCompareFunction
);
  procedure QuickSort(
    const AList: IInterfaceListSimple;
    ACompareFunc: TInterfaceListSortCompareFunction;
    L, R: Integer
  );
  var
    I, J: Integer;
    P: IInterface;
  begin
    repeat
      I := L;
      J := R;
      P := AList[(L + R) shr 1];
      repeat
        while ACompareFunc(AList[I], P) < 0 do begin
          Inc(I);
        end;
        while ACompareFunc(AList[J], P) > 0 do begin
          Dec(J);
        end;
        if I <= J then begin
          AList.Exchange(I, J);
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then begin
        QuickSort(AList, ACompareFunc, L, J);
      end;
      L := I;
    until I >= R;
  end;
var
  VCount: Integer;
begin
  Assert(Assigned(AList));
  VCount := AList.Count;
  if VCount > 1 then begin
    QuickSort(AList, ACompareFunc, 0, VCount - 1);
  end;
end;

procedure SortInterfaceListByCompareFunctor(
  const AList: IInterfaceListSimple;
  ACompareFunc: TInterfaceListSortCompareFunctor
);
  procedure QuickSort(
    const AList: IInterfaceListSimple;
    ACompareFunc: TInterfaceListSortCompareFunctor;
    L, R: Integer
  );
  var
    I, J: Integer;
    P: IInterface;
  begin
    repeat
      I := L;
      J := R;
      P := AList[(L + R) shr 1];
      repeat
        while ACompareFunc(AList[I], P) < 0 do begin
          Inc(I);
        end;
        while ACompareFunc(AList[J], P) > 0 do begin
          Dec(J);
        end;
        if I <= J then begin
          AList.Exchange(I, J);
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then begin
        QuickSort(AList, ACompareFunc, L, J);
      end;
      L := I;
    until I >= R;
  end;
var
  VCount: Integer;
begin
  Assert(Assigned(AList));
  VCount := AList.Count;
  if VCount > 1 then begin
    QuickSort(AList, ACompareFunc, 0, VCount - 1);
  end;
end;

end.

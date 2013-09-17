{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
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
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_PLTSimpleParser;

interface

uses
  Classes,
  ALfcnString,
  ALStringList,
  t_GeoTypes,
  i_BinaryData,
  i_VectorItemSubsetBuilder,
  i_VectorDataFactory,
  i_VectorItemsFactory,
  i_VectorDataLoader,
  i_VectorItemSubset,
  i_DoublePointsAggregator,
  i_InternalPerformanceCounter,
  i_VectorDataItemSimple,
  u_BaseInterfacedObject;

type
  TPLTSimpleParser = class(TBaseInterfacedObject, IVectorDataLoader)
  private
    FFormatSettings: TALFormatSettings;
    FVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
    FVectorGeometryLonLatFactory: IVectorGeometryLonLatFactory;
    FLoadStreamCounter: IInternalPerformanceCounter;
    procedure ParseStringList(
      AStringList: TALStringList;
      const APointsAggregator: IDoublePointsAggregator
    );
    function GetWord(
      const Str: AnsiString;
      const Smb: AnsiString;
      WordNmbr: Byte
    ): AnsiString;
  private
    function LoadFromStream(
      AStream: TStream;
      const AIdData: Pointer;
      const AVectorGeometryLonLatFactory: IVectorDataFactory
    ): IVectorItemSubset;
    function Load(
      const AData: IBinaryData;
      const AIdData: Pointer;
      const AVectorGeometryLonLatFactory: IVectorDataFactory
    ): IVectorItemSubset;
  public
    constructor Create(
      const AVectorGeometryLonLatFactory: IVectorGeometryLonLatFactory;
      const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
      const APerfCounterList: IInternalPerformanceCounterList
    );
  end;

implementation

uses
  i_VectorItemLonLat,
  u_StreamReadOnlyByBinaryData,
  u_DoublePointsAggregator,
  u_GeoFun,
  u_GeoToStr;

constructor TPLTSimpleParser.Create(
  const AVectorGeometryLonLatFactory: IVectorGeometryLonLatFactory;
  const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
  const APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create;
  FVectorGeometryLonLatFactory := AVectorGeometryLonLatFactory;
  FVectorItemSubsetBuilderFactory := AVectorItemSubsetBuilderFactory;
  FLoadStreamCounter := APerfCounterList.CreateAndAddNewCounter('LoadPltStream');
  FFormatSettings.DecimalSeparator := '.';
end;

function TPLTSimpleParser.Load(
  const AData: IBinaryData;
  const AIdData: Pointer;
  const AVectorGeometryLonLatFactory: IVectorDataFactory
): IVectorItemSubset;
var
  VStream: TStreamReadOnlyByBinaryData;
begin
  Result := nil;
  VStream := TStreamReadOnlyByBinaryData.Create(AData);
  try
    Result := LoadFromStream(VStream, AIdData, AVectorGeometryLonLatFactory);
  finally
    VStream.Free;
  end;
end;

function TPLTSimpleParser.LoadFromStream(
  AStream: TStream;
  const AIdData: Pointer;
  const AVectorGeometryLonLatFactory: IVectorDataFactory
): IVectorItemSubset;
var
  pltstr: TALStringList;
  trackname: string;
  VList: IVectorItemSubsetBuilder;
  VItem: IVectorDataItemSimple;
  VPointsAggregator: IDoublePointsAggregator;
  VPath: ILonLatPath;
begin
  Result := nil;
  pltstr := TALStringList.Create;
  try
    pltstr.LoadFromStream(AStream);
    if pltstr.Count > 7 then begin
      VPointsAggregator := TDoublePointsAggregator.Create;
      ParseStringList(pltstr, VPointsAggregator);
      if VPointsAggregator.Count > 0 then begin
        VPath := FVectorGeometryLonLatFactory.CreateLonLatPath(VPointsAggregator.Points, VPointsAggregator.Count);
        if Assigned(VPath) then begin
          trackname := string(GetWord(pltstr[4], ',', 4));
          VItem :=
            AVectorGeometryLonLatFactory.BuildPath(
              AIdData,
              nil,
              trackname,
              '',
              VPath
            );
        end;
        VList := FVectorItemSubsetBuilderFactory.Build;
        if Assigned(VItem) then begin
          VList.Add(VItem);
        end;
        Result := VList.MakeStaticAndClear;
      end;
    end;
  finally
    pltstr.Free;
  end;
end;

procedure TPLTSimpleParser.ParseStringList(
  AStringList: TALStringList;
  const APointsAggregator: IDoublePointsAggregator
);
var
  i: integer;
  VStr: AnsiString;
  VPoint: TDoublePoint;
  VValidPoint: Boolean;
begin
  for i := 6 to AStringList.Count - 1 do begin
    try
      VStr := AStringList[i];
      if (GetWord(VStr, ',', 3) = '1') and (i > 6) then begin
        VPoint := CEmptyDoublePoint;
        APointsAggregator.Add(VPoint);
      end;
      VValidPoint := True;
      try
        VPoint.y := ALStrToFloat(GetWord(VStr, ',', 1), FFormatSettings);
        VPoint.x := ALStrToFloat(GetWord(VStr, ',', 2), FFormatSettings);
      except
        VValidPoint := False;
      end;
      if VValidPoint then begin
        APointsAggregator.Add(VPoint);
      end;
    except
    end;
  end;
end;

function TPLTSimpleParser.GetWord(
  const Str: AnsiString;
  const Smb: AnsiString;
  WordNmbr: Byte
): AnsiString;
var
  N: Byte;
  VCurrPos: Integer;
  VPrevPos: Integer;
begin
  VCurrPos := 0;
  VPrevPos := -1;
  N := 0;
  while (WordNmbr > N)  do begin
    VPrevPos := VCurrPos + 1;
    VCurrPos := ALPosEx(Smb, Str, VPrevPos);
    if VCurrPos = 0 then begin
      VCurrPos := Length(Str);
      Break;
    end;
    Inc(N);
  end;
  if WordNmbr <= N then begin
    Result := ALCopyStr(Str, VPrevPos, VCurrPos - VPrevPos);
  end else begin
    Result := '';
  end;
end;

end.

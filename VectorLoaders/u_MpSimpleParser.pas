unit u_MpSimpleParser;

interface

uses
  i_BinaryData,
  i_VectorDataLoader,
  i_VectorItemsFactory,
  i_VectorDataItemSimple,
  i_VectorDataFactory,
  i_DoublePointsAggregator,
  u_BaseInterfacedObject;

type
  TMpSimpleParser = class(TBaseInterfacedObject, IVectorDataLoader)
  private
    FFactory: IVectorItemsFactory;
    procedure ParseCoordinates(
      const AData: string;
      const APointsAggregator: IDoublePointsAggregator
    );
  private
    function Load(
      const AData: IBinaryData;
      const AIdData: Pointer;
      const AFactory: IVectorDataFactory
    ): IVectorDataItemList;
  public
    constructor Create(
      const AFactory: IVectorItemsFactory
    );
  end;

implementation

uses
  SysUtils,
  StrUtils,
  Classes,
  IniFiles,
  t_GeoTypes,
  i_ConfigDataProvider,
  i_VectorItemLonLat,
  u_ConfigProviderHelpers,
  u_StreamReadOnlyByBinaryData,
  u_ConfigDataProviderByIniFile,
  u_VectorDataItemList,
  u_DoublePointsAggregator,
  u_GeoFun;

const
  CPoligonHeader = '[POLYGON]';
  CDataHeader = 'Data0=';

{ TMpSimpleParser }

constructor TMpSimpleParser.Create(const AFactory: IVectorItemsFactory);
begin
  inherited Create;
  FFactory := AFactory;
end;

procedure TMpSimpleParser.ParseCoordinates(
  const AData: string;
  const APointsAggregator: IDoublePointsAggregator
);
var
  VCoordList: TStringList;
  VString: string;
  i: Integer;
  VPos: Integer;
  VXStr: string;
  VYStr: string;
  VPoint: TDoublePoint;
  VFormatSettings: TFormatSettings;
begin
  VCoordList := TStringList.Create;
  try
    VFormatSettings.DecimalSeparator := '.';
    VCoordList.Delimiter := '(';
    VCoordList.DelimitedText := AData;
    for i := 0 to VCoordList.Count - 1 do begin
      VString := VCoordList[i];
      if VString <> '' then begin
        VPoint := CEmptyDoublePoint;
        VPos := Pos(',', VString);
        if VPos > 0 then begin
          VYStr := LeftStr(VString, VPos - 1);
          VXStr := MidStr(VString, VPos + 1, Length(VString));
          VPos := Pos(')', VXStr);
          if VPos > 0 then begin
            VXStr := LeftStr(VXStr, VPos - 1);
          end;
          VPoint.X := StrToFloatDef(VXStr, VPoint.X, VFormatSettings);
          VPoint.Y := StrToFloatDef(VYStr, VPoint.Y, VFormatSettings);
        end;
        if not PointIsEmpty(VPoint) then begin
          APointsAggregator.Add(VPoint);
        end;
      end;
    end;
  finally
    VCoordList.Free;
  end;
end;

function TMpSimpleParser.Load(
  const AData: IBinaryData;
  const AIdData: Pointer;
  const AFactory: IVectorDataFactory
): IVectorDataItemList;
var
  VFileStrings: TStringList;
  VDataStream: TStream;
  VPolygon: ILonLatPolygon;
  VItem: IVectorDataItemSimple;
  VList: IInterfaceList;
  VString: string;
  VPoligonLine: Integer;
  i: integer;
  VPointsAggregator: IDoublePointsAggregator;
  VDataLine: Integer;
begin
  Result := nil;
  VPolygon := nil;
  VPointsAggregator := TDoublePointsAggregator.Create;
  if AData <> nil then begin
    VDataStream := TStreamReadOnlyByBinaryData.Create(AData);
    try
      VDataStream.Position := 0;
      VFileStrings := TStringList.Create;
      try
        VFileStrings.LoadFromStream(VDataStream);
        VPoligonLine := -1;
        for i := 0 to VFileStrings.Count - 1 do begin
          VString := VFileStrings[i];
          if LeftStr(VString, Length(CPoligonHeader)) = CPoligonHeader then begin
            VPoligonLine := i;
            Break;
          end;
        end;
        if VPoligonLine >= 0 then begin
          VDataLine := -1;
          for i := VPoligonLine + 1 to VFileStrings.Count - 1 do begin
            VString := VFileStrings[i];
            if LeftStr(VString, Length(CDataHeader)) = CDataHeader then begin
              VDataLine := i;
              Break;
            end;
          end;
          if VDataLine >= 0 then begin
            VString := MidStr(VString, Length(CDataHeader) + 1, Length(VString));
            if VString <> '' then begin
              ParseCoordinates(VString, VPointsAggregator);
            end;
          end;
        end;
      finally
        VFileStrings.Free;
      end;
    finally
      VDataStream.Free;
    end;
  end;
  if VPointsAggregator.Count > 2 then begin
    VPolygon := FFactory.CreateLonLatPolygon(VPointsAggregator.Points, VPointsAggregator.Count);
  end;
  if VPolygon <> nil then begin
    VItem :=
      AFactory.BuildPoly(
        AIdData,
        '',
        '',
        VPolygon
      );
    VList := TInterfaceList.Create;
    VList.Add(VItem);
    Result := TVectorDataItemList.Create(VList);
  end;
end;

end.


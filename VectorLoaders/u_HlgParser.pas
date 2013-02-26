unit u_HlgParser;

interface

uses
  i_BinaryData,
  i_VectorDataLoader,
  i_VectorItemsFactory,
  i_VectorItemSubset,
  i_VectorDataFactory,
  u_BaseInterfacedObject;

type
  THlgParser = class(TBaseInterfacedObject, IVectorDataLoader)
  private
    FFactory: IVectorItemsFactory;
  private
    function Load(
      const AData: IBinaryData;
      const AIdData: Pointer;
      const AFactory: IVectorDataFactory
    ): IVectorItemSubset;
  public
    constructor Create(
      const AFactory: IVectorItemsFactory
    );
  end;

implementation

uses
  Classes,
  IniFiles,
  i_ConfigDataProvider,
  i_VectorItemLonLat,
  i_VectorDataItemSimple,
  u_ConfigProviderHelpers,
  u_StreamReadOnlyByBinaryData,
  u_ConfigDataProviderByIniFile,
  u_VectorDataItemSubset;

{ THlgParser }

constructor THlgParser.Create(const AFactory: IVectorItemsFactory);
begin
  inherited Create;
  FFactory := AFactory;
end;

function THlgParser.Load(
  const AData: IBinaryData;
  const AIdData: Pointer;
  const AFactory: IVectorDataFactory
): IVectorItemSubset;
var
  VIniFile: TMemIniFile;
  VIniStrings: TStringList;
  VIniStream: TStream;
  VHLGData: IConfigDataProvider;
  VPolygonSection: IConfigDataProvider;
  VPolygon: ILonLatPolygon;
  VItem: IVectorDataItemSimple;
  VList: IInterfaceList;
begin
  Result := nil;
  VPolygon := nil;
  VHLGData := nil;
  if AData <> nil then begin
    VIniStream := TStreamReadOnlyByBinaryData.Create(AData);
    try
      VIniStream.Position := 0;
      VIniStrings := TStringList.Create;
      try
        VIniStrings.LoadFromStream(VIniStream);
        VIniFile := TMemIniFile.Create('');
        try
          VIniFile.SetStrings(VIniStrings);
          VHLGData := TConfigDataProviderByIniFile.CreateWithOwn(VIniFile);
          VIniFile := nil;
        finally
          VIniFile.Free;
        end;
      finally
        VIniStrings.Free;
      end;
    finally
      VIniStream.Free;
    end;
  end;
  if VHLGData <> nil then begin
    VPolygonSection := VHLGData.GetSubItem('HIGHLIGHTING');
    if VPolygonSection <> nil then begin
      VPolygon := ReadPolygon(VPolygonSection, FFactory);
    end;
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
    Result := TVectorItemSubset.Create(VList);
  end;
end;

end.

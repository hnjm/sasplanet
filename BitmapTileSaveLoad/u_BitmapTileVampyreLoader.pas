unit u_BitmapTileVampyreLoader;

interface

uses
  Classes,
  SysUtils,
  Imaging,
  GR32,
  i_InternalPerformanceCounter,
  i_BinaryData,
  i_Bitmap32Static,
  i_BitmapTileSaveLoad;

type
  TVampyreBasicBitmapTileLoader = class(TInterfacedObject, IBitmapTileLoader)
  private
    FCS: IReadWriteSync;
    FMetadata: TMetadata;
    FFormat: TImageFileFormat;
    FLoadStreamCounter: IInternalPerformanceCounter;
  public
    constructor Create(
      AFormatClass: TImageFileFormatClass;
      APerfCounterList: IInternalPerformanceCounterList
    );
    destructor Destroy; override;
    procedure LoadFromStream(AStream: TStream; ABtm: TCustomBitmap32);
    function Load(AData: IBinaryData): IBitmap32Static;
  end;

  TVampyreBasicBitmapTileLoaderPNG = class(TVampyreBasicBitmapTileLoader)
  public
    constructor Create(
      APerfCounterList: IInternalPerformanceCounterList
    );
  end;

  TVampyreBasicBitmapTileLoaderGIF = class(TVampyreBasicBitmapTileLoader)
  public
    constructor Create(
      APerfCounterList: IInternalPerformanceCounterList
    );
  end;

  TVampyreBasicBitmapTileLoaderBMP = class(TVampyreBasicBitmapTileLoader)
  public
    constructor Create(
      APerfCounterList: IInternalPerformanceCounterList
    );
  end;

  TVampyreBasicBitmapTileLoaderJPEG = class(TVampyreBasicBitmapTileLoader)
  public
    constructor Create(
      APerfCounterList: IInternalPerformanceCounterList
    );
  end;

implementation

uses
  u_Synchronizer,
  ImagingTypes,
  ImagingGraphics32,
  ImagingJpeg,
  ImagingNetworkGraphics,
  ImagingGif,
  ImagingBitmap,
  u_Bitmap32Static;

{ TVampyreBasicBitmapTileLoader }

constructor TVampyreBasicBitmapTileLoader.Create(
  AFormatClass: TImageFileFormatClass;
  APerfCounterList: IInternalPerformanceCounterList
);
begin
  FCS := MakeSyncObj(Self, TRUE);
  FMetadata := TMetadata.Create;
  FFormat := AFormatClass.Create(FMetadata);
  FLoadStreamCounter := APerfCounterList.CreateAndAddNewCounter('LoadStream');
end;

destructor TVampyreBasicBitmapTileLoader.Destroy;
begin
  FreeAndNil(FFormat);
  FreeAndNil(FMetadata);
  FCS := nil;
  inherited;
end;

function TVampyreBasicBitmapTileLoader.Load(
  AData: IBinaryData
): IBitmap32Static;
var
  VImage: TImageData;
  IArray: TDynImageDataArray;
  I: LongInt;
  VCounterContext: TInternalPerformanceCounterContext;
  VBitmap: TCustomBitmap32;
begin
  VCounterContext := FLoadStreamCounter.StartOperation;
  try
    InitImage(VImage);
    try
      FCS.BeginWrite;
      try
        if not FFormat.LoadFromMemory(AData.Buffer, AData.Size, IArray, True) then begin
          raise Exception.Create('������ �������� �����');
        end;
      finally
        FCS.EndWrite;
      end;

      if Length(IArray) = 0 then begin
        raise Exception.Create('� ����� �� ������� �����������');
      end;

      VImage := IArray[0];
      for I := 1 to Length(IArray) - 1 do begin
        FreeImage(IArray[I]);
      end;

      VBitmap := TCustomBitmap32.Create;
      try
        ConvertImageDataToBitmap32(VImage, VBitmap);
        Result := TBitmap32Static.CreateWithOwn(VBitmap);
        VBitmap := nil;
      finally
        VBitmap.Free;
      end;
    finally
      FreeImage(VImage);
    end;
  finally
    FLoadStreamCounter.FinishOperation(VCounterContext);
  end;
end;

procedure TVampyreBasicBitmapTileLoader.LoadFromStream(AStream: TStream;
  ABtm: TCustomBitmap32);
var
  VImage: TImageData;
  IArray: TDynImageDataArray;
  I: LongInt;
  VCounterContext: TInternalPerformanceCounterContext;
begin
  VCounterContext := FLoadStreamCounter.StartOperation;
  try
    InitImage(VImage);
    try
      FCS.BeginWrite;
      try
        if not FFormat.LoadFromStream(AStream, IArray, True) then begin
          raise Exception.Create('������ �������� �����');
        end;
      finally
        FCS.EndWrite;
      end;

      if Length(IArray) = 0 then begin
        raise Exception.Create('� ����� �� ������� �����������');
      end;

      VImage := IArray[0];
      for I := 1 to Length(IArray) - 1 do begin
        FreeImage(IArray[I]);
      end;

      ConvertImageDataToBitmap32(VImage, ABtm);
    finally
      FreeImage(VImage);
    end;
  finally
    FLoadStreamCounter.FinishOperation(VCounterContext);
  end;
end;

{ TVampyreBasicBitmapTileLoaderPNG }

constructor TVampyreBasicBitmapTileLoaderPNG.Create(
  APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create(TPNGFileFormat, APerfCounterList.CreateAndAddNewSubList('VampyrePNG'))
end;

{ TVampyreBasicBitmapTileLoaderGIF }

constructor TVampyreBasicBitmapTileLoaderGIF.Create(
  APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create(TGIFFileFormat, APerfCounterList.CreateAndAddNewSubList('VampyreGIF'))
end;

{ TVampyreBasicBitmapTileLoaderBMP }

constructor TVampyreBasicBitmapTileLoaderBMP.Create(
  APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create(TBitmapFileFormat, APerfCounterList.CreateAndAddNewSubList('VampyreBMP'))
end;

{ TVampyreBasicBitmapTileLoaderJPEG }

constructor TVampyreBasicBitmapTileLoaderJPEG.Create(
  APerfCounterList: IInternalPerformanceCounterList
);
begin
  inherited Create(TJpegFileFormat, APerfCounterList.CreateAndAddNewSubList('VampyreJPEG'))
end;

end.


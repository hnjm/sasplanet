unit u_BitmapTileJpegLoader;

interface

uses
  Classes,
  GR32,
  i_BitmapTileSaveLoad;

type
  TJpegBitmapTileLoader = class(TInterfacedObject, IBitmapTileLoader)
  public
    procedure LoadFromFile(AFileName: string; ABtm: TBitmap32);
    procedure LoadFromStream(AStream: TStream; ABtm: TBitmap32);
  end;

implementation

uses
  SysUtils,
  IJL;

{ TJpegBitmapTileLoader }

procedure RGBA2BGRA(var jcprops: TJPEG_CORE_PROPERTIES);
var
  W, H: Integer;
  p: PColor32Entry;
  pData: Pointer;
  Width, Height: Integer;
  V: Byte;
begin
  Width := jcprops.JPGWidth;
  Height := jcprops.JPGHeight;
  pData := jcprops.DIBBytes;
  p := PColor32Entry(pData);
  for H := 0 to Height - 1 do begin
    for W := 0 to Width - 1 do begin
      V := p.B;
      p.B := p.R;
      p.R := V;
      inc(p);
    end;
  end;
end;

function LoadJpeg(var jcprops: TJPEG_CORE_PROPERTIES; Btm: TBitmap32): Boolean;
var
  iWidth, iHeight, iNChannels: Integer;
begin
  Result := true;
  iWidth := jcprops.JPGWidth;
  iHeight := jcprops.JPGHeight;
  iNChannels := 4;
  Btm.SetSize(iWidth, iHeight);
  jcprops.DIBWidth := iWidth;
  jcprops.DIBHeight := iHeight;
  jcprops.DIBChannels := iNChannels;
  jcprops.DIBColor := IJL_RGBA_FPX;
  jcprops.DIBPadBytes := ((((iWidth * iNChannels) + 3) div 4) * 4) - (iWidth * iNChannels);
  jcprops.DIBBytes := PByte(Btm.Bits);

  if (jcprops.JPGChannels = 3) then begin
    jcprops.JPGColor := IJL_YCBCR;
  end else if (jcprops.JPGChannels = 4) then begin
    jcprops.JPGColor := IJL_YCBCRA_FPX;
  end else if (jcprops.JPGChannels = 1) then begin
    jcprops.JPGColor := IJL_G;
  end else begin
    jcprops.DIBColor := TIJL_COLOR(IJL_OTHER);
    jcprops.JPGColor := TIJL_COLOR(IJL_OTHER);
  end;
end;

procedure TJpegBitmapTileLoader.LoadFromFile(AFileName: string;
  ABtm: TBitmap32);
var
  iStatus: Integer;
  jcprops: TJPEG_CORE_PROPERTIES;
begin
  iStatus := ijlInit(@jcprops);
  if iStatus < 0 then begin
    raise Exception.Create('ijlInit Error');
  end;
  try
    jcprops.JPGFile := PChar(AFileName);
    iStatus := ijlRead(@jcprops, IJL_JFILE_READPARAMS);
    if iStatus < 0 then begin
      raise Exception.Create('ijlRead from file Error');
    end;
    if not LoadJpeg(jcprops, ABtm) then begin
      raise Exception.Create('Prepare load Jpeg Error');
    end;
    iStatus := ijlRead(@jcprops, IJL_JFILE_READWHOLEIMAGE);
    if iStatus < 0 then begin
      raise Exception.Create('Load Jpeg Error');
    end;
    RGBA2BGRA(jcprops);
  finally
    ijlFree(@jcprops);
  end;
end;

procedure TJpegBitmapTileLoader.LoadFromStream(AStream: TStream;
  ABtm: TBitmap32);
var
  VInternalStream: TMemoryStream;
  VMemStream: TCustomMemoryStream;
  iStatus: Integer;
  jcprops: TJPEG_CORE_PROPERTIES;
begin
  if AStream is TCustomMemoryStream then begin
    VInternalStream := nil;
    VMemStream := AStream as TCustomMemoryStream;
  end else begin
    VInternalStream := TMemoryStream.Create;
    VInternalStream.LoadFromStream(AStream);
    VMemStream := VInternalStream;
  end;
  try
    iStatus := ijlInit(@jcprops);
    if iStatus < 0 then begin
      raise Exception.Create('ijlInit Error');
    end;
    try
      jcprops.JPGBytes := VMemStream.Memory;
      jcprops.JPGSizeBytes := VMemStream.Size;
      iStatus := ijlRead(@jcprops, IJL_JBUFF_READPARAMS);
      if iStatus < 0 then begin
        raise Exception.Create('ijlRead from stream Error');
      end;
      if not LoadJpeg(jcprops, ABtm) then begin
        raise Exception.Create('Prepare load Jpeg Error');
      end;
      iStatus := ijlRead(@jcprops, IJL_JBUFF_READWHOLEIMAGE);
      if iStatus < 0 then begin
        raise Exception.Create('Load Jpeg Error');
      end;
      RGBA2BGRA(jcprops);
    finally
      ijlFree(@jcprops);
    end;
  finally
    FreeAndNil(VInternalStream);
  end;
end;

end.

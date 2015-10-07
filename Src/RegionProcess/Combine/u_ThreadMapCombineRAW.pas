{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2015, SAS.Planet development team.                      *}
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

unit u_ThreadMapCombineRAW;

interface

uses
  SysUtils,
  Classes,
  Types,
  t_Bitmap32,
  i_NotifierOperation,
  i_BitmapTileProvider,
  i_RegionProcessProgressInfo,
  i_GeometryLonLat,
  i_MapCalibration,
  i_BitmapMapCombiner,
  u_BaseInterfacedObject;

type
  TBitmapMapCombinerRAW = class(TBaseInterfacedObject, IBitmapMapCombiner)
  private
    FProgressUpdate: IBitmapCombineProgressUpdate;
    FBgColor: TColor32;
    FWithAlpha: Boolean;
    FOperationID: Integer;
    FCancelNotifier: INotifierOperation;
  private
    procedure SaveRect(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const AFileName: string;
      const AImageProvider: IBitmapTileProvider;
      const AMapRect: TRect
    );
  public
    constructor Create(
      const AProgressUpdate: IBitmapCombineProgressUpdate;
      const ABgColor: TColor32;
      AWithAlpha: Boolean
    );
  end;

implementation

uses
  gnugettext,
  ALString,
  i_ImageLineProvider,
  u_ImageLineProvider,
  u_GeoFunc;

constructor TBitmapMapCombinerRAW.Create(
  const AProgressUpdate: IBitmapCombineProgressUpdate;
  const ABgColor: TColor32;
  AWithAlpha: Boolean
);
begin
  inherited Create;
  FProgressUpdate := AProgressUpdate;
  FBgColor := ABgColor;
  FWithAlpha := AWithAlpha;
end;

procedure TBitmapMapCombinerRAW.SaveRect(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const AFileName: string;
  const AImageProvider: IBitmapTileProvider;
  const AMapRect: TRect
);
var
  i: Integer;
  VRawFile: TFileStream;
  VMetaFile: TFileStream;
  VLine: Pointer;
  VSize: TPoint;
  VLineProvider: IImageLineProvider;
  VBytesPerPix: Byte;
  VMetaInfo: AnsiString;
  VBgColor: TColor32Entry;
begin
  FOperationID := AOperationID;
  FCancelNotifier := ACancelNotifier;
  
  VSize := RectSize(AMapRect);

  VRawFile := TFileStream.Create(AFileName, fmCreate);
  try
    if FWithAlpha then begin
      VBytesPerPix := 4;
      VLineProvider :=
        TImageLineProviderRGBA.Create(
          AImageProvider,
          AMapRect
        );
    end else begin
      VBytesPerPix := 3;
      VLineProvider :=
        TImageLineProviderRGB.Create(
          AImageProvider,
          AMapRect
        );
    end;
    VBgColor.ARGB := FBgColor;
    VMetaInfo := '';
    VMetaInfo := VMetaInfo + 'Width=' + ALIntToStr(VSize.X) + #13#10;
    VMetaInfo := VMetaInfo + 'Height=' + ALIntToStr(VSize.Y) + #13#10;
    if FWithAlpha then begin
      VMetaInfo := VMetaInfo + 'Bit/pixel=32' + #13#10;
      VMetaInfo := VMetaInfo + 'ByteOrder=RGBA' + #13#10;
      VMetaInfo := VMetaInfo + 'DefaultFill=#' + AlIntToHex(VBgColor.R, 2) + AlIntToHex(VBgColor.G, 2) + AlIntToHex(VBgColor.B, 2) + AlIntToHex(VBgColor.A, 2) + #13#10;
    end else begin
      VMetaInfo := VMetaInfo + 'Bit/pixel=24' + #13#10;
      VMetaInfo := VMetaInfo + 'ByteOrder=RGB'  + #13#10;
      VMetaInfo := VMetaInfo + 'DefaultFill=#' + AlIntToHex(VBgColor.R, 2) + AlIntToHex(VBgColor.G, 2) + AlIntToHex(VBgColor.B, 2) + #13#10;
    end;

    VMetaFile := TFileStream.Create(AFileName + '.meta', fmCreate);
    try
      VMetaFile.WriteBuffer(VMetaInfo[1], Length(VMetaInfo));
    finally
      FreeAndNil(VMetaFile);
    end;

    for i := 0 to VSize.Y - 1 do begin
      VLine := VLineProvider.GetLine(AOperationID, ACancelNotifier, i);
      if VLine <> nil then begin
        VRawFile.WriteBuffer(VLine^, VSize.X * VBytesPerPix);
      end else begin
        raise Exception.Create(_('RAW: Fill line failure!'));
      end;

      if FCancelNotifier.IsOperationCanceled(FOperationID) then begin
        Break;
      end;
      if i mod 256 = 0 then begin
        FProgressUpdate.Update(i / VSize.Y);
      end;
    end;
  finally
    VRawFile.Free;
  end;
end;

end.

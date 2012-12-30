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

unit u_BitmapTileSaveLoadFactory;

interface

uses
  i_BitmapTileSaveLoad,
  i_BitmapTileSaveLoadFactory,
  i_Bitmap32StaticFactory,
  i_InternalPerformanceCounter,
  u_BaseInterfacedObject;

type
  TBitmapTileSaveLoadFactory = class(
    TBaseInterfacedObject,
    IBitmapTileSaveLoadFactory
  )
  private
    FBitmapFactory: IBitmap32StaticFactory;
  private
     // BMP
    function CreateBmpLoader(
      const APerfCounterList: IInternalPerformanceCounterList = nil
    ): IBitmapTileLoader;

    function CreateBmpSaver(
      const APerfCounterList: IInternalPerformanceCounterList = nil
    ): IBitmapTileSaver;

    // GIF
    function CreateGifLoader(
      const APerfCounterList: IInternalPerformanceCounterList = nil
    ): IBitmapTileLoader;

    function CreateGifSaver(
      const APerfCounterList: IInternalPerformanceCounterList = nil
    ): IBitmapTileSaver;

    // PNG
    function CreatePngLoader(
      const APerfCounterList: IInternalPerformanceCounterList = nil
    ): IBitmapTileLoader;

    function CreatePngSaver(
      const AColorDepth: TImageColorBitPerPix = i32bpp;
      const ACompressionLevel: Byte = 2;
      const APerfCounterList: IInternalPerformanceCounterList = nil
    ): IBitmapTileSaver;

    // JPEG
    function CreateJpegLoader(
      const APerfCounterList: IInternalPerformanceCounterList = nil
    ): IBitmapTileLoader;

    function CreateJpegSaver(
      const ACompressionQuality: Byte = 75;
      const APerfCounterList: IInternalPerformanceCounterList = nil
    ): IBitmapTileSaver;
  public
    constructor Create(const ABitmapFactory: IBitmap32StaticFactory);
  end;

implementation

uses
  u_BitmapTileLibJpeg,
  u_BitmapTileFreeImage,
  u_InternalPerformanceCounterFake;

function GetValidPerfCounterList(
  const APerfCounterList: IInternalPerformanceCounterList
): IInternalPerformanceCounterList;
begin
  Result := APerfCounterList;
  if not Assigned(Result) then begin
    Result := TInternalPerformanceCounterFake.Create;
  end;
end;

{ TBitmapTileSaveLoadFactory }

constructor TBitmapTileSaveLoadFactory.Create(
  const ABitmapFactory: IBitmap32StaticFactory);
begin
  inherited Create;
  FBitmapFactory := ABitmapFactory;
end;

function TBitmapTileSaveLoadFactory.CreateBmpLoader(
  const APerfCounterList: IInternalPerformanceCounterList = nil
): IBitmapTileLoader;
begin
  Result := TBitmapTileFreeImageLoaderBmp.Create(
    GetValidPerfCounterList(APerfCounterList),
    FBitmapFactory
  );
end;

function TBitmapTileSaveLoadFactory.CreateBmpSaver(
  const APerfCounterList: IInternalPerformanceCounterList = nil
): IBitmapTileSaver;
begin
  Result := TBitmapTileFreeImageSaverBmp.Create(
    GetValidPerfCounterList(APerfCounterList)
  );
end;

function TBitmapTileSaveLoadFactory.CreateGifLoader(
  const APerfCounterList: IInternalPerformanceCounterList = nil
): IBitmapTileLoader;
begin
  Result := TBitmapTileFreeImageLoaderGif.Create(
    GetValidPerfCounterList(APerfCounterList),
    FBitmapFactory
  );
end;

function TBitmapTileSaveLoadFactory.CreateGifSaver(
  const APerfCounterList: IInternalPerformanceCounterList = nil
): IBitmapTileSaver;
begin
  Result := TBitmapTileFreeImageSaverGif.Create(
    GetValidPerfCounterList(APerfCounterList)
  );
end;

function TBitmapTileSaveLoadFactory.CreatePngLoader(
  const APerfCounterList: IInternalPerformanceCounterList = nil
): IBitmapTileLoader;
begin
  Result := TBitmapTileFreeImageLoaderPng.Create(
    GetValidPerfCounterList(APerfCounterList),
    FBitmapFactory
  );
end;

function TBitmapTileSaveLoadFactory.CreatePngSaver(
  const AColorDepth: TImageColorBitPerPix = i32bpp;
  const ACompressionLevel: Byte = 2;
  const APerfCounterList: IInternalPerformanceCounterList = nil
): IBitmapTileSaver;
begin
  case AColorDepth of
    i8bpp:
      begin
        Result := TBitmapTileFreeImageSaverPng.Create(
          ACompressionLevel,
          8,
          GetValidPerfCounterList(APerfCounterList)
        );
      end;

    i24bpp:
      begin
        Result := TBitmapTileFreeImageSaverPng.Create(
          ACompressionLevel,
          24,
          GetValidPerfCounterList(APerfCounterList)
        );
      end;

  else // i32bpp
    begin
      Result := TBitmapTileFreeImageSaverPng.Create(
        ACompressionLevel,
        32,
        GetValidPerfCounterList(APerfCounterList)
      );
    end;
  end;
end;

function TBitmapTileSaveLoadFactory.CreateJpegLoader(
  const APerfCounterList: IInternalPerformanceCounterList = nil
): IBitmapTileLoader;
begin
  Result := TLibJpegTileLoader.Create(
    GetValidPerfCounterList(APerfCounterList),
    FBitmapFactory
  );
end;

function TBitmapTileSaveLoadFactory.CreateJpegSaver(
  const ACompressionQuality: Byte = 75;
  const APerfCounterList: IInternalPerformanceCounterList = nil
): IBitmapTileSaver;
begin
  Result := TLibJpegTileSaver.Create(
    ACompressionQuality,
    GetValidPerfCounterList(APerfCounterList)
  );
end;

end.

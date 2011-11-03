unit i_TileRectUpdateNotifier;

interface

uses
  Types,
  i_JclNotify,
  i_CoordConverter;

type
  ITileRectUpdateNotifier = interface
    ['{63FC7494-8ECF-42BE-A516-3908337F77CE}']
    function GetGeoCoder: ICoordConverter; stdcall;
    property GeoCoder: ICoordConverter read GetGeoCoder;

    function GetZoom: Byte; stdcall;
    property Zoom: Byte read GetZoom;

    procedure Add(AListener: IJclListener; ATileRect: TRect); stdcall;
    procedure Remove(AListener: IJclListener); stdcall;
  end;
  ITileRectUpdateNotifierInternal = interface
    ['{86C0C887-1DD8-43B8-9B5A-0504B4BFA809}']
    procedure TileUpdateNotify(ATile: TPoint); stdcall;
//    procedure TileRectUpdateNotify(ARect: TRect); stdcall;
  end;

implementation

end.

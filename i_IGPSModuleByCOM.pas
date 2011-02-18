unit i_IGPSModuleByCOM;

interface

uses
  i_JclNotify,
  i_IGPSModuleByCOMPortSettings,
  i_GPS,
  i_IGPSModule;

type
  IGPSModuleByCOM = interface(IGPSModule)
    ['{EFB18F84-3019-44D2-9525-A12B3D97B14B}']
    procedure Connect(AConfig: IGPSModuleByCOMPortConfigSatic); safecall;
    procedure Disconnect; safecall;

    function GetIsReadyToConnect: Boolean; safecall;
    property IsReadyToConnect: Boolean read GetIsReadyToConnect;
  end;

implementation

end.

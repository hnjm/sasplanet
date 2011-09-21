unit i_SensorViewListGenerator;

interface

uses
  Classes,
  i_GUIDSet,
  i_SensorList;

type
  ISensorViewListGenerator = interface
    ['{886AABDC-90D7-4F6F-BCBF-E7AFBABA545B}']
    function CreateSensorViewList(ASensorList: ISensorList): IGUIDInterfaceSet;
  end;

implementation

end.

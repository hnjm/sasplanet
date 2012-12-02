unit u_GeoCodePlacemarkWithUrlDecorator;

interface

uses
  t_GeoTypes,
  i_LonLatRect,
  i_VectorDataItemSimple,
  i_GeoCoder,
  u_BaseInterfacedObject;

type
  TGeoCodePlacemarkWithUrlDecorator = class(TBaseInterfacedObject, IGeoCodePlacemark, IVectorDataItemPoint, IVectorDataItemSimple)
  private
    FSource: IGeoCodePlacemark;
    FUrl: string;
  private
    function GetPoint: TDoublePoint;
    function GetName: string;
    function GetDesc: string;
    function GetLLRect: ILonLatRect;
    function GetHintText: string;
    function GetInfoHTML: string;
    function GetInfoUrl: string;
    function GetInfoCaption: string;
  private
    function GetAccuracy: Integer; safecall;
  public
    constructor Create(
      const ASource: IGeoCodePlacemark;
      const AUrl: string
    );
  end;

implementation

{ TGeoCodePlacemarkWithUrlDecorator }

constructor TGeoCodePlacemarkWithUrlDecorator.Create(
  const ASource: IGeoCodePlacemark; const AUrl: string);
begin
  inherited Create;
  FSource := ASource;
  FUrl := AUrl;
end;

function TGeoCodePlacemarkWithUrlDecorator.GetAccuracy: Integer;
begin
  Result := FSource.GetAccuracy;
end;

function TGeoCodePlacemarkWithUrlDecorator.GetDesc: string;
begin
  Result := FSource.Desc;
end;

function TGeoCodePlacemarkWithUrlDecorator.GetHintText: string;
begin
  Result := FSource.GetHintText;
end;

function TGeoCodePlacemarkWithUrlDecorator.GetInfoCaption: string;
begin
  Result := FSource.GetInfoCaption;
end;

function TGeoCodePlacemarkWithUrlDecorator.GetInfoHTML: string;
begin
  Result := FSource.GetInfoHTML;
end;

function TGeoCodePlacemarkWithUrlDecorator.GetInfoUrl: string;
begin
  Result := FUrl;
end;

function TGeoCodePlacemarkWithUrlDecorator.GetLLRect: ILonLatRect;
begin
  Result := FSource.LLRect;
end;

function TGeoCodePlacemarkWithUrlDecorator.GetName: string;
begin
  Result := FSource.Name;
end;

function TGeoCodePlacemarkWithUrlDecorator.GetPoint: TDoublePoint;
begin
  Result := FSource.Point;
end;

end.

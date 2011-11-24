{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
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

unit u_BitmapMarkerProviderSimpleBase;

interface

uses
  Types,
  i_JclNotify,
  i_BitmapMarker,
  i_BitmapMarkerProviderSimpleConfig;

type
  TBitmapMarkerProviderSimpleAbstract = class(TInterfacedObject, IBitmapMarkerProvider)
  private
    FConfig: IBitmapMarkerProviderSimpleConfigStatic;
  protected
    property Config: IBitmapMarkerProviderSimpleConfigStatic read FConfig;
  protected
    function GetMarker: IBitmapMarker; virtual; abstract;
    function GetMarkerBySize(ASize: Integer): IBitmapMarker; virtual; abstract;
  public
    constructor CreateProvider(AConfig: IBitmapMarkerProviderSimpleConfigStatic); virtual;
  end;

  TBitmapMarkerProviderSimpleBase = class(TBitmapMarkerProviderSimpleAbstract)
  private
    FMarker: IBitmapMarker;
  protected
    function CreateMarker(ASize: Integer): IBitmapMarker; virtual; abstract;
  protected
    function GetMarker: IBitmapMarker; override;
    function GetMarkerBySize(ASize: Integer): IBitmapMarker; override;
  public
    constructor CreateProvider(AConfig: IBitmapMarkerProviderSimpleConfigStatic); override;
  end;

  TBitmapMarkerWithDirectionProviderSimpleBase = class(TBitmapMarkerProviderSimpleAbstract, IBitmapMarkerWithDirectionProvider)
  private
    FMarker: IBitmapMarkerWithDirection;
  protected
    function CreateMarker(ASize: Integer; ADirection: Double): IBitmapMarkerWithDirection; virtual; abstract;
  protected
    function GetMarker: IBitmapMarker; override;
    function GetMarkerBySize(ASize: Integer): IBitmapMarker; override;
    function GetMarkerWithRotation(AAngle: Double): IBitmapMarkerWithDirection;
    function GetMarkerWithRotationBySize(AAngle: Double;  ASize: Integer): IBitmapMarkerWithDirection;
  public
    constructor CreateProvider(AConfig: IBitmapMarkerProviderSimpleConfigStatic); override;
  end;

  TBitmapMarkerProviderSimpleClass = class of TBitmapMarkerProviderSimpleAbstract;

  TBitmapMarkerProviderChangeableWithConfig = class(TInterfacedObject, IBitmapMarkerProviderChangeable)
  private
    FConfig: IBitmapMarkerProviderSimpleConfig;
    FProviderClass: TBitmapMarkerProviderSimpleClass;
    FProviderStatic: IBitmapMarkerProvider;

    FConfigChangeListener: IJclListener;
    FChangeNotifier: IJclNotifier;
    procedure OnConfigChange;
  protected
    function GetStatic: IBitmapMarkerProvider;
    function GetChangeNotifier: IJclNotifier;
  public
    constructor Create(
      AProviderClass: TBitmapMarkerProviderSimpleClass;
      AConfig: IBitmapMarkerProviderSimpleConfig
    );
    destructor Destroy; override;
  end;


implementation

uses
  SysUtils,
  u_JclNotify,
  u_NotifyEventListener,
  u_GeoFun;

const
  CAngleDelta = 1.0;

{ TBitmapMarkerProviderSimpleAbstract }

constructor TBitmapMarkerProviderSimpleAbstract.CreateProvider(
  AConfig: IBitmapMarkerProviderSimpleConfigStatic);
begin
  FConfig := AConfig;
end;

{ TBitmapMarkerProviderSimpleBase }

constructor TBitmapMarkerProviderSimpleBase.CreateProvider(
  AConfig: IBitmapMarkerProviderSimpleConfigStatic
);
begin
  inherited;
  FMarker := CreateMarker(Config.MarkerSize);
end;

function TBitmapMarkerProviderSimpleBase.GetMarker: IBitmapMarker;
begin
  Result := FMarker;
end;

function TBitmapMarkerProviderSimpleBase.GetMarkerBySize(
  ASize: Integer): IBitmapMarker;
begin
  if ASize = Config.MarkerSize then begin
    Result := FMarker;
  end else begin
    Result := CreateMarker(ASize);
  end;
end;

{ TBitmapMarkerWithDirectionProviderSimpleBase }

constructor TBitmapMarkerWithDirectionProviderSimpleBase.CreateProvider(
  AConfig: IBitmapMarkerProviderSimpleConfigStatic);
begin
  inherited;
  FMarker := CreateMarker(Config.MarkerSize, 0);
end;

function TBitmapMarkerWithDirectionProviderSimpleBase.GetMarker: IBitmapMarker;
begin
  Result := FMarker;
end;

function TBitmapMarkerWithDirectionProviderSimpleBase.GetMarkerBySize(
  ASize: Integer): IBitmapMarker;
begin
  if ASize = Config.MarkerSize then begin
    Result := FMarker;
  end else begin
    Result := CreateMarker(ASize, FMarker.Direction);
  end;
end;

function TBitmapMarkerWithDirectionProviderSimpleBase.GetMarkerWithRotation(
  AAngle: Double): IBitmapMarkerWithDirection;
begin
  if (Abs(CalcAngleDelta(AAngle, FMarker.Direction)) < CAngleDelta) then begin
    Result := FMarker;
  end else begin
    Result := CreateMarker(Config.MarkerSize, AAngle);
  end;
end;

function TBitmapMarkerWithDirectionProviderSimpleBase.GetMarkerWithRotationBySize(
  AAngle: Double; ASize: Integer): IBitmapMarkerWithDirection;
begin
  if (Abs(CalcAngleDelta(AAngle, FMarker.Direction)) < CAngleDelta) and (ASize = Config.MarkerSize) then begin
    Result := FMarker;
  end else begin
    Result := CreateMarker(ASize, AAngle);
  end;
end;

{ TBitmapMarkerProviderChangeableWithConfig }

constructor TBitmapMarkerProviderChangeableWithConfig.Create(
  AProviderClass: TBitmapMarkerProviderSimpleClass;
  AConfig: IBitmapMarkerProviderSimpleConfig);
begin
  FProviderClass := AProviderClass;
  FConfig := AConfig;

  FConfigChangeListener := TNotifyNoMmgEventListener.Create(Self.OnConfigChange);
  FConfig.GetChangeNotifier.Add(FConfigChangeListener);

  FChangeNotifier := TJclBaseNotifier.Create;
  OnConfigChange;
end;

destructor TBitmapMarkerProviderChangeableWithConfig.Destroy;
begin
  FConfig.GetChangeNotifier.Remove(FConfigChangeListener);
  FConfigChangeListener := nil;

  inherited;
end;

function TBitmapMarkerProviderChangeableWithConfig.GetChangeNotifier: IJclNotifier;
begin
  Result := FChangeNotifier;
end;

function TBitmapMarkerProviderChangeableWithConfig.GetStatic: IBitmapMarkerProvider;
begin
  Result := FProviderStatic;
end;

procedure TBitmapMarkerProviderChangeableWithConfig.OnConfigChange;
begin
  FProviderStatic := FProviderClass.CreateProvider(FConfig.GetStatic);
  FChangeNotifier.Notify(nil);
end;

end.


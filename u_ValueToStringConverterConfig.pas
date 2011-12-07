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

unit u_ValueToStringConverterConfig;

interface

uses
  i_JclNotify,
  t_CommonTypes,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_ConfigDataElement,
  i_ValueToStringConverter,
  u_ConfigDataElementBase;

type
  TValueToStringConverterConfig = class(TConfigDataElementBase, IValueToStringConverterConfig)
  private
    FDependentOnElement: IConfigDataElement;
    FDependentOnElementListener: IJclListener;

    FDistStrFormat: TDistStrFormat;
    FIsLatitudeFirst: Boolean;
    FDegrShowFormat: TDegrShowFormat;
    FStatic: IValueToStringConverter;
    procedure OnDependentOnElementChange;
    function CreateStatic: IValueToStringConverter;
  protected
    procedure DoBeforeChangeNotify; override;
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetDistStrFormat: TDistStrFormat;
    procedure SetDistStrFormat(AValue: TDistStrFormat);

    function GetIsLatitudeFirst: Boolean;
    procedure SetIsLatitudeFirst(AValue: Boolean);

    function GetDegrShowFormat: TDegrShowFormat;
    procedure SetDegrShowFormat(AValue: TDegrShowFormat);

    function GetStatic: IValueToStringConverter;
  public
    constructor Create(ADependentOnElement: IConfigDataElement);
    destructor Destroy; override;
  end;


implementation

uses
  u_NotifyEventListener,
  u_ValueToStringConverter;

{ TValueToStringConverterConfig }

constructor TValueToStringConverterConfig.Create(ADependentOnElement: IConfigDataElement);
begin
  inherited Create;
  FIsLatitudeFirst := True;
  FDistStrFormat := dsfKmAndM;
  FDegrShowFormat := dshCharDegrMinSec;
  FDependentOnElement := ADependentOnElement;
  FDependentOnElementListener := TNotifyNoMmgEventListener.Create(Self.OnDependentOnElementChange);
  FDependentOnElement.GetChangeNotifier.Add(FDependentOnElementListener);

  FStatic := CreateStatic;
end;

destructor TValueToStringConverterConfig.Destroy;
begin
  FDependentOnElement.GetChangeNotifier.Remove(FDependentOnElementListener);
  FDependentOnElementListener := nil;
  FDependentOnElement := nil;
  inherited;
end;

function TValueToStringConverterConfig.CreateStatic: IValueToStringConverter;
begin
  Result :=
    TValueToStringConverter.Create(
      FDistStrFormat,
      FIsLatitudeFirst,
      FDegrShowFormat
    );
end;

procedure TValueToStringConverterConfig.DoBeforeChangeNotify;
begin
  inherited;
  LockWrite;
  try
    FStatic := CreateStatic;
  finally
    UnlockWrite;
  end;
end;

procedure TValueToStringConverterConfig.DoReadConfig(
  AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FIsLatitudeFirst := AConfigData.ReadBool('FirstLat', FIsLatitudeFirst);
    FDistStrFormat := TDistStrFormat(AConfigData.ReadInteger('DistFormat', Integer(FDistStrFormat)));
    FDegrShowFormat := TDegrShowFormat(AConfigData.ReadInteger('DegrisShowFormat', Integer(FDegrShowFormat)));
    SetChanged;
  end;
end;

procedure TValueToStringConverterConfig.DoWriteConfig(
  AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  AConfigData.WriteBool('FirstLat', FIsLatitudeFirst);
  AConfigData.WriteInteger('DistFormat', Integer(FDistStrFormat));
  AConfigData.WriteInteger('DegrisShowFormat', Integer(FDegrShowFormat));
end;

function TValueToStringConverterConfig.GetDegrShowFormat: TDegrShowFormat;
begin
  LockRead;
  try
    Result := FDegrShowFormat;
  finally
    UnlockRead;
  end;
end;

function TValueToStringConverterConfig.GetDistStrFormat: TDistStrFormat;
begin
  LockRead;
  try
    Result := FDistStrFormat;
  finally
    UnlockRead;
  end;
end;

function TValueToStringConverterConfig.GetIsLatitudeFirst: Boolean;
begin
  LockRead;
  try
    Result := FIsLatitudeFirst;
  finally
    UnlockRead;
  end;
end;

function TValueToStringConverterConfig.GetStatic: IValueToStringConverter;
begin
  Result := FStatic;
end;

procedure TValueToStringConverterConfig.OnDependentOnElementChange;
begin
  LockWrite;
  try
    SetChanged;
  finally
    UnlockWrite;
  end;
end;

procedure TValueToStringConverterConfig.SetDegrShowFormat(
  AValue: TDegrShowFormat);
begin
  LockWrite;
  try
    if FDegrShowFormat <> AValue then begin
      FDegrShowFormat := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TValueToStringConverterConfig.SetDistStrFormat(
  AValue: TDistStrFormat);
begin
  LockWrite;
  try
    if FDistStrFormat <> AValue then begin
      FDistStrFormat := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TValueToStringConverterConfig.SetIsLatitudeFirst(AValue: Boolean);
begin
  LockWrite;
  try
    if FIsLatitudeFirst <> AValue then begin
      FIsLatitudeFirst := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.

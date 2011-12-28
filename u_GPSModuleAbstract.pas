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

unit u_GPSModuleAbstract;

interface

uses
  Windows,
  ActiveX,
  Classes,
  i_JclNotify,
  t_GeoTypes,
  i_GPS,
  i_GPSPositionFactory,
  i_GPSModule,
  vsagps_public_base,
  vsagps_public_position;

type
  TSatellitesInternalList = class
  private
    FList: TList;
    function Get(Index: Integer): IGPSSatelliteInfo;
    procedure Put(Index: Integer; Item: IGPSSatelliteInfo);
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCount(NewCount: Integer);
    function GetCapacity: Integer;
    function GetCount: Integer;
    function GetList: PUnknownList;
  public
    constructor Create;
    destructor Destroy; override;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: IGPSSatelliteInfo read Get write Put; default;
    property List: PUnknownList read GetList;
  end;

  TGPSModuleAbstract = class(TInterfacedObject, IGPSModule)
  private
    FGPSPositionFactory: IGPSPositionFactory;
    FLastStaticPosition: IGPSPosition;
    FCS_GPSData: TRTLCriticalSection;

    FNotifiedTicks: DWORD;
    FGPSPosChanged: Boolean;
    FGPSSatChanged: Boolean;

    FSatellitesGP: TSatellitesInternalList;
    FSatellitesGL: TSatellitesInternalList;

    FDataReciveNotifier: IJclNotifier;

    FConnectingNotifier: IJclNotifier;
    FConnectedNotifier: IJclNotifier;
    FDisconnectingNotifier: IJclNotifier;
    FDisconnectedNotifier: IJclNotifier;

    FConnectErrorNotifier: IJclNotifier;
    FTimeOutNotifier: IJclNotifier;
  protected
    FSingleGPSData: TSingleGPSData;
    FFixSatsALL: TVSAGPS_FIX_ALL;
    function GetSatellitesListByTalkerID(const ATalkerID: String): TSatellitesInternalList;
    function SerializeSatsInfo: String;
  protected
    procedure _UpdateSpeedHeading(
      const ASpeed_KMH: Double;
      const AHeading: Double;
      const AVSpeed_MS: Double;
      const AVSpeedOK: Boolean
    );

    procedure _UpdateUTCDate(
      const AUTCDateOK: Boolean;
      const AUTCDate: TDateTime
    );

    procedure _UpdateSattelite(
      const ATalkerID: String;
      const AIndex: Byte;
      const ASatellite_Info: TVSAGPS_FIX_SAT;
      const AElevation: SInt16;
      const AAzimuth: SInt16;
      const ASignalToNoiseRatio: SInt16;
      const AFixedStatus: Byte;
      const ASatFlags: Byte
    );

    procedure _UpdateSatsInView(
      const ATalkerID: String;
      const ACount: Byte);

    procedure _UpdateDOP(
      const AHDOP: Double;
      const AVDOP: Double;
      const APDOP: Double
    );

    procedure _UpdateHDOP(
      const AHDOP: Double
    );

    procedure _UpdateFixedSats(
      const ATalkerID: String;
      const AFixedSats: PVSAGPS_FIX_SATS
    );

    procedure _UpdateAlt(
      const AAltitude: Double
    );

    procedure _UpdateGeoidHeight(
      const AGeoidHeight: Double
    );

    procedure _UpdateMagVar(
      const AMagVar_Deg: Double;
      const AMagVar_Sym: Char
    );

    procedure _UpdateFixStatus(
      const AFixStatus: Byte
    );

    procedure _UpdateDimentions(
      const ADimentions: Byte
    );

    procedure _UpdateNavMode(
      const ANavMode: Char
    );

    procedure _UpdateNmea23Mode(
      const ANmea23Mode: Char;
      const ADontSetIfNewIsEmpty: Boolean;
      const ADontSetIfOldIsANR: Boolean
    );

    procedure _UpdatePosTime(
      const APositionOK: Boolean;
      const APosition: TDoublePoint;
      const AUTCTimeOK: Boolean;
      const AUTCTime: TDateTime
    );

    procedure _UpdateDGPSParams(
      const ADGPS_Station_ID: SmallInt;
      const ADGPS_Age_Second: Single
    );

    procedure _UpdateFromTrackPoint(
      const pData: PSingleTrackPointData
    );

    procedure _UpdateToEmptyPosition;

    procedure DoAddPointToLogWriter(const AUnitIndex: Byte); virtual; abstract;

    procedure LockGPSData;
    procedure UnLockGPSData(const AUnitIndex: Byte;
                            const ANotifyPosChanged: Boolean;
                            const ANotifySatChanged: Boolean);
  protected
    function GetPosition: IGPSPosition; virtual; safecall;

    function GetDataReciveNotifier: IJclNotifier; virtual; safecall;

    function GetConnectingNotifier: IJclNotifier; virtual; safecall;
    function GetConnectedNotifier: IJclNotifier; virtual; safecall;
    function GetDisconnectingNotifier: IJclNotifier; virtual; safecall;
    function GetDisconnectedNotifier: IJclNotifier; virtual; safecall;

    function GetConnectErrorNotifier: IJclNotifier; virtual; safecall;
    function GetTimeOutNotifier: IJclNotifier; virtual; safecall;
  public
    constructor Create(APositionFactory: IGPSPositionFactory);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  vsagps_public_sats_info,
  u_JclNotify;

{ TGPSPositionUpdatable }

constructor TGPSModuleAbstract.Create(APositionFactory: IGPSPositionFactory);
begin
  FGPSPositionFactory := APositionFactory;

  InitializeCriticalSection(FCS_GPSData);
  //FCS := TCriticalSection.Create;

  FNotifiedTicks := 0;
  FGPSPosChanged := FALSE;
  FGPSSatChanged := FALSE;
  InitSingleGPSData(@FSingleGPSData);

  FSatellitesGP := TSatellitesInternalList.Create;
  FSatellitesGP.Capacity := 32;
  FSatellitesGL := TSatellitesInternalList.Create;
  FSatellitesGL.Capacity := 24;

  FLastStaticPosition := nil;
  FConnectErrorNotifier := TJclBaseNotifier.Create;

  FConnectingNotifier := TJclBaseNotifier.Create;
  FConnectedNotifier := TJclBaseNotifier.Create;
  FDisconnectingNotifier := TJclBaseNotifier.Create;
  FDisconnectedNotifier := TJclBaseNotifier.Create;

  FDataReciveNotifier := TJclBaseNotifier.Create;
  FTimeOutNotifier := TJclBaseNotifier.Create;
end;

destructor TGPSModuleAbstract.Destroy;
begin
  //FreeAndNil(FCS);
  FreeAndNil(FSatellitesGP);
  FreeAndNil(FSatellitesGL);
  
  FLastStaticPosition := nil;
  FGPSPositionFactory := nil;

  FConnectingNotifier := nil;
  FConnectedNotifier := nil;
  FDisconnectingNotifier := nil;
  FDisconnectedNotifier := nil;

  FConnectErrorNotifier := nil;
  FDataReciveNotifier := nil;
  FTimeOutNotifier := nil;

  DeleteCriticalSection(FCS_GPSData);
  
  inherited;
end;

function TGPSModuleAbstract.GetConnectErrorNotifier: IJclNotifier;
begin
  Result := FConnectErrorNotifier;
end;

function TGPSModuleAbstract.GetConnectingNotifier: IJclNotifier;
begin
  Result := FConnectingNotifier;
end;

function TGPSModuleAbstract.GetConnectedNotifier: IJclNotifier;
begin
  Result := FConnectedNotifier;
end;

function TGPSModuleAbstract.GetDisconnectingNotifier: IJclNotifier;
begin
  Result := FDisconnectingNotifier;
end;

function TGPSModuleAbstract.GetDisconnectedNotifier: IJclNotifier;
begin
  Result := FDisconnectedNotifier;
end;

function TGPSModuleAbstract.GetDataReciveNotifier: IJclNotifier;
begin
  Result := FDataReciveNotifier;
end;

function TGPSModuleAbstract.GetPosition: IGPSPosition;
var VSatsInView: IGPSSatellitesInView;
begin
  LockGPSData;
  try
    if FGPSSatChanged or FGPSPosChanged then begin
      if (not FGPSSatChanged) then begin
        // use existing sats
        if Assigned(FLastStaticPosition) then
          VSatsInView:=FLastStaticPosition.Satellites
        else
          VSatsInView:=nil;
        Result := FGPSPositionFactory.BuildPosition(
          @FSingleGPSData,
          VSatsInView);
      end else begin
        // make new sats
        Result := FGPSPositionFactory.BuildPosition(
          @FSingleGPSData,
          FGPSPositionFactory.BuildSatellitesInView(
            FSatellitesGP.Count,
            FSatellitesGP.List,
            FSatellitesGL.Count,
            FSatellitesGL.List
          )
        );
      end;
      // apply fix info
      if Assigned(Result.Satellites) then
        Result.Satellites.SetFixedSats(@FFixSatsALL);
      // save to cache
      FLastStaticPosition := Result;
      // reset flags
      FGPSSatChanged:=FALSE;
      FGPSPosChanged:=FALSE;
    end else begin
      // get prev from cache
      Result := FLastStaticPosition;
    end;
  finally
    UnLockGPSData(cUnitIndex_Reserved,FALSE,FALSE);
  end;
end;

function TGPSModuleAbstract.GetSatellitesListByTalkerID(const ATalkerID: String): TSatellitesInternalList;
begin
  if SameText(ATalkerID, nmea_ti_GLONASS) then
    Result:=FSatellitesGL
  else
    Result:=FSatellitesGP;
end;

function TGPSModuleAbstract.GetTimeOutNotifier: IJclNotifier;
begin
  Result := FTimeOutNotifier;
end;

procedure TGPSModuleAbstract.LockGPSData;
begin
  //FCS.Acquire;
  EnterCriticalSection(FCS_GPSData);
end;

function TGPSModuleAbstract.SerializeSatsInfo: String;

  procedure _AddToResult(const s: String);
  begin
    Result:=Result+s+',';
  end;
  
  procedure _DoForSats(const lst: TSatellitesInternalList; const sats_prefix: String);
  var
    i: Integer;
    v_done: Byte;
    bsp: TSingleSatFixibilityData;
    ssp: TSingleSatSkyData;
    si: IGPSSatelliteInfo;
    s: String;
  begin
    si:=nil;
    v_done:=0;
    if lst<>nil then
    if (0<lst.Count) then
    for i := 0 to lst.Count-1 do begin
      si:=lst[i];
      if Assigned(si) then begin
        si.GetBaseSatelliteParams(@bsp);
        with bsp do
        if SatAvailableForShow(sat_info.svid, snr, status) then begin
          si.GetSkySatelliteParams(@ssp);
          // to string
          s:=SerializeSingleSatInfo(@bsp, @ssp);
          // prefix to result
          if (0=v_done) then
            _AddToResult(sats_prefix);
          Inc(v_done);
          // info to result
          _AddToResult(s);
        end;
      end;
    end;
  end;

begin
  Result:='';
  // for gps
  _DoForSats(FSatellitesGP, nmea_ti_GPS);
  // for glonass
  _DoForSats(FSatellitesGL, nmea_ti_GLONASS);
  // Nmea23_Mode at the end of line
  Result:=Result+IntToHex(Ord(FSingleGPSData.DGPS.Nmea23_Mode), 2);
end;

procedure TGPSModuleAbstract.UnLockGPSData(const AUnitIndex: Byte;
                                           const ANotifyPosChanged: Boolean;
                                           const ANotifySatChanged: Boolean);
var
  VGPSPosChanged, VGPSSatChanged: Boolean;
  VTicks: DWORD;
begin
  VGPSPosChanged := FGPSPosChanged;
  VGPSSatChanged := FGPSSatChanged;

  // save to log (add point to tracks)
  if VGPSPosChanged and ANotifyPosChanged then
    DoAddPointToLogWriter(AUnitIndex);

  LeaveCriticalSection(FCS_GPSData);

  // notify GUI
  if (ANotifyPosChanged and VGPSPosChanged) then begin
    // notify about position
    FNotifiedTicks:=GetTickCount;
    GetDataReciveNotifier.Notify(nil);
  end else if (ANotifySatChanged and VGPSSatChanged) then begin
    // notify about sats
    VTicks := GetTickCount;
    if (VTicks > FNotifiedTicks + 2000) then begin
      FNotifiedTicks := VTicks;
      GetDataReciveNotifier.Notify(nil);
    end;
  end;
end;

procedure TGPSModuleAbstract._UpdateDGPSParams(const ADGPS_Station_ID: SmallInt;
                                               const ADGPS_Age_Second: Single);
begin
  if FSingleGPSData.DGPS.DGPS_Station_ID <> ADGPS_Station_ID then begin
    FSingleGPSData.DGPS.DGPS_Station_ID := ADGPS_Station_ID;
    FGPSPosChanged:=TRUE;
  end;
  if FSingleGPSData.DGPS.DGPS_Age_Second <> ADGPS_Age_Second then begin
    FSingleGPSData.DGPS.DGPS_Age_Second := ADGPS_Age_Second;
    FGPSPosChanged:=TRUE;
  end;
end;

procedure TGPSModuleAbstract._UpdateDimentions(const ADimentions: Byte);
begin
  if FSingleGPSData.DGPS.Dimentions <> ADimentions then begin
    FSingleGPSData.DGPS.Dimentions := ADimentions;
    FGPSPosChanged := True;
  end;
end;

procedure TGPSModuleAbstract._UpdateDOP(const AHDOP, AVDOP, APDOP: Double);
begin
  if FSingleGPSData.HDOP <> AHDOP then begin
    FSingleGPSData.HDOP := AHDOP;
    FGPSPosChanged := True;
  end;

  if FSingleGPSData.VDOP <> AVDOP then begin
    FSingleGPSData.VDOP := AVDOP;
    FGPSPosChanged := True;
  end;

  if FSingleGPSData.PDOP <> APDOP then begin
    FSingleGPSData.PDOP := APDOP;
    FGPSPosChanged := True;
  end;
end;

procedure TGPSModuleAbstract._UpdateFixedSats(
  const ATalkerID: String;
  const AFixedSats: PVSAGPS_FIX_SATS
  );
var p: PVSAGPS_FIX_SATS;
begin
  p:=Select_PVSAGPS_FIX_SATS_from_ALL(@FFixSatsALL, ATalkerID);
  if not CompareMem(AFixedSats, p, sizeof(p^)) then begin
    Move(AFixedSats^, p^, sizeof(p^));
    FGPSSatChanged:=TRUE;
  end;
end;

procedure TGPSModuleAbstract._UpdateFixStatus(const AFixStatus: Byte);
begin
  if FSingleGPSData.FixStatus <> AFixStatus then begin
    FSingleGPSData.FixStatus := AFixStatus;
    FGPSPosChanged:=TRUE;
  end;
end;

procedure TGPSModuleAbstract._UpdateFromTrackPoint(const pData: PSingleTrackPointData);

  procedure _DoForSats(const a_fix_count: Byte;
                       const p_sky_1: PSingleSatsInfoData;
                       const a_talker_id: String);
  var
    i: SmallInt;
  begin
    if (0<a_fix_count) then
    for i := 0 to a_fix_count-1 do
    with p_sky_1^.entries[i] do
      _UpdateSattelite(a_talker_id,
                       i,
                       single_fix.sat_info,
                       single_sky.elevation,
                       single_sky.azimuth,
                       single_fix.snr,
                       single_fix.status,
                       single_fix.flags);
  end;
  
begin
  CopyMemory(@FSingleGPSData, @(pData^.gps_data), sizeof(FSingleGPSData));
  FGPSPosChanged:=TRUE;

  if (FFixSatsALL.gp.fix_count<>pData^.gpx_sats_count) then begin
    FFixSatsALL.gp.fix_count:=pData^.gpx_sats_count;
    FFixSatsALL.gp.all_count:=pData^.gpx_sats_count;
    FGPSSatChanged:=TRUE;
  end;

  if (sizeof(TFullTrackPointData) = PData^.full_data_size) then
  with PFullTrackPointData(PData)^ do begin
    // apply satellite params
    // fix params
    CopyMemory(@FFixSatsALL, @fix_all, sizeof(FFixSatsALL));
    // other params - gps
    _DoForSats(fix_all.gp.fix_count, @(sky_fix.gp), nmea_ti_GPS);
    // other params - glonass
    _DoForSats(fix_all.gl.fix_count, @(sky_fix.gl), nmea_ti_GLONASS);
  end;
end;

procedure TGPSModuleAbstract._UpdateGeoidHeight(const AGeoidHeight: Double);
begin
  if FSingleGPSData.GeoidHeight <> AGeoidHeight then begin
    FSingleGPSData.GeoidHeight := AGeoidHeight;
    FGPSPosChanged := True;
  end;
end;

procedure TGPSModuleAbstract._UpdateHDOP(const AHDOP: Double);
begin
  if FSingleGPSData.HDOP <> AHDOP then begin
    FSingleGPSData.HDOP := AHDOP;
    FGPSPosChanged := True;
  end;
end;

procedure TGPSModuleAbstract._UpdateMagVar(const AMagVar_Deg: Double; const AMagVar_Sym: Char);
begin
  if FSingleGPSData.MagVar.variation_degree <> AMagVar_Deg then begin
    FSingleGPSData.MagVar.variation_degree := AMagVar_Deg;
    FGPSPosChanged := True;
  end;
  if FSingleGPSData.MagVar.variation_symbol <> AMagVar_Sym then begin
    FSingleGPSData.MagVar.variation_symbol := AMagVar_Sym;
    FGPSPosChanged := True;
  end;
end;

procedure TGPSModuleAbstract._UpdatePosTime(
  const APositionOK: Boolean;
  const APosition: TDoublePoint;
  const AUTCTimeOK: Boolean;
  const AUTCTime: TDateTime);
begin
  if FSingleGPSData.PositionLon <> APosition.X then begin
    FSingleGPSData.PositionLon := APosition.X;
    FGPSPosChanged := True;
  end;
  if FSingleGPSData.PositionLat <> APosition.Y then begin
    FSingleGPSData.PositionLat := APosition.Y;
    FGPSPosChanged := True;
  end;
  if FSingleGPSData.PositionOK <> APositionOK then begin
    FSingleGPSData.PositionOK := APositionOK;
    FGPSPosChanged := True;
  end;

  if FSingleGPSData.UTCTime <> AUTCTime then begin
    FSingleGPSData.UTCTime := AUTCTime;
    FGPSPosChanged := True;
  end;
  if FSingleGPSData.UTCTimeOK <> AUTCTimeOK then begin
    FSingleGPSData.UTCTimeOK := AUTCTimeOK;
    FGPSPosChanged := True;
  end;
end;

procedure TGPSModuleAbstract._UpdateSpeedHeading(
  const ASpeed_KMH: Double;
  const AHeading: Double;
  const AVSpeed_MS: Double;
  const AVSpeedOK: Boolean);
begin
  if FSingleGPSData.Speed_KMH <> ASpeed_KMH then begin
    FSingleGPSData.Speed_KMH := ASpeed_KMH;
    FGPSPosChanged := TRUE;
  end;

  if (FSingleGPSData.VSpeedOK or AVSpeedOK) then
  if (FSingleGPSData.VSpeedOK <> AVSpeedOK) or (FSingleGPSData.VSpeed_MS <> AVSpeed_MS) then begin
    FSingleGPSData.VSpeed_MS := AVSpeed_MS;
    FSingleGPSData.VSpeedOK := AVSpeedOK;
    FGPSPosChanged := TRUE;
  end;

  if FSingleGPSData.Heading <> AHeading then begin
    FSingleGPSData.Heading := AHeading;
    FGPSPosChanged := TRUE;
  end;
end;

procedure TGPSModuleAbstract._UpdateSatsInView(
  const ATalkerID: String;
  const ACount: Byte
  );
var f: TSatellitesInternalList;
begin
  f:=GetSatellitesListByTalkerID(ATalkerID);
  if f.Count <> ACount then begin
    f.Count := ACount;
    FGPSSatChanged := True;
  end;
end;

procedure TGPSModuleAbstract._UpdateSattelite(
  const ATalkerID: String;
  const AIndex: Byte;
  const ASatellite_Info: TVSAGPS_FIX_SAT;
  const AElevation: SInt16;
  const AAzimuth: SInt16;
  const ASignalToNoiseRatio: SInt16;
  const AFixedStatus: Byte;
  const ASatFlags: Byte);
var
  VSattelite: IGPSSatelliteInfo;
  VSatteliteChanged: Boolean;
  VData: TSingleSatFixibilityData;
  VSky: TSingleSatSkyData;
  f: TSatellitesInternalList;
begin
  VSatteliteChanged := False;
  f:=GetSatellitesListByTalkerID(ATalkerID);
  
  if (f.Count<=AIndex) then begin
    // need to enlarge list of sats
    // but if "empty" sat - don't do it
    if (not SatAvailableForShow(ASatellite_Info.svid, ASignalToNoiseRatio, AFixedStatus)) then
      Exit;
    f.Count:=AIndex+1;
    VSattelite:=nil;
  end else begin
    VSattelite := f[AIndex];
  end;
  
  if VSattelite <> nil then begin
    // first
    VSattelite.GetSkySatelliteParams(@VSky);
    if (not VSatteliteChanged) and (VSky.Elevation <> AElevation) then begin
      VSatteliteChanged := True;
    end;
    if (not VSatteliteChanged) and (VSky.Azimuth <> AAzimuth) then begin
      VSatteliteChanged := True;
    end;

    // base
    if (not VSatteliteChanged) then
      VSattelite.GetBaseSatelliteParams(@VData);
    if (not VSatteliteChanged) and (Word(VData.sat_info) <> Word(ASatellite_Info)) then begin
      VSatteliteChanged := True;
    end;
    if (not VSatteliteChanged) and (VData.snr <> ASignalToNoiseRatio) then begin
      VSatteliteChanged := True;
    end;
    if (not VSatteliteChanged) and (VData.status <> AFixedStatus) then begin
      VSatteliteChanged := True;
    end;
    if (not VSatteliteChanged) and (VData.flags <> ASatFlags) then begin
      VSatteliteChanged := True;
    end;
    // additional
  end else begin
    VSatteliteChanged := True;
  end;

  if VSatteliteChanged then begin
    VData.sat_info := ASatellite_Info;
    VData.snr := ASignalToNoiseRatio;
    VData.status := AFixedStatus;
    VData.flags := ASatFlags;
    VSky.elevation:=AElevation;
    VSky.azimuth:=AAzimuth;

    VSattelite := FGPSPositionFactory.BuildSatelliteInfo(
      @VData,
      @VSky);
      
    f[AIndex] := VSattelite;
    FGPSSatChanged := True;
  end;
end;

procedure TGPSModuleAbstract._UpdateToEmptyPosition;
begin
  //Lock;
  //try
    FGPSPosChanged:=SingleGPSDataNotEmpty(@FSingleGPSData);
    InitSingleGPSData(@FSingleGPSData);
    FGPSSatChanged := FALSE;
    FLastStaticPosition := FGPSPositionFactory.BuildPositionEmpty;
  //finally
    //Unlock;
  //end;
end;

procedure TGPSModuleAbstract._UpdateUTCDate(const AUTCDateOK: Boolean; const AUTCDate: TDateTime);
begin
  if FSingleGPSData.UTCDate <> AUTCDate then begin
    FSingleGPSData.UTCDate := AUTCDate;
    FGPSPosChanged := True;
  end;
  if FSingleGPSData.UTCDateOK <> AUTCDateOK then begin
    FSingleGPSData.UTCDateOK := AUTCDateOK;
    FGPSPosChanged := True;
  end;
end;

procedure TGPSModuleAbstract._UpdateNavMode(const ANavMode: Char);
begin
  if FSingleGPSData.NavMode <> ANavMode then begin
    FSingleGPSData.NavMode := ANavMode;
    FGPSPosChanged:=TRUE;
  end;
end;

procedure TGPSModuleAbstract._UpdateNmea23Mode(
      const ANmea23Mode: Char;
      const ADontSetIfNewIsEmpty: Boolean;
      const ADontSetIfOldIsANR: Boolean
);
  procedure _DoCommon;
  begin
    if (FSingleGPSData.DGPS.Nmea23_Mode <> ANmea23Mode) then begin
      FSingleGPSData.DGPS.Nmea23_Mode := ANmea23Mode;
      FGPSPosChanged:=TRUE;
    end;
  end;
begin
  if ADontSetIfNewIsEmpty then begin
    // empty if nmea version bellow 2.3
    if (ANmea23Mode<>#0) then
      _DoCommon;
  end else if ADontSetIfOldIsANR then begin
    // keep A, N or R if set from message without these values
    if (not (FSingleGPSData.DGPS.Nmea23_Mode in ['A','N','R'])) then
      _DoCommon;
  end else begin
    // common action
    _DoCommon;
  end;
end;

procedure TGPSModuleAbstract._UpdateAlt(const AAltitude: Double);
begin
  if FSingleGPSData.Altitude <> AAltitude then begin
    FSingleGPSData.Altitude := AAltitude;
    FGPSPosChanged := True;
  end;
end;

{ TSatellitesInternalList }

constructor TSatellitesInternalList.Create;
begin
  FList := TList.Create;;
end;

destructor TSatellitesInternalList.Destroy;
begin
  SetCount(0);
  FreeAndNil(FList);
  inherited;
end;

function TSatellitesInternalList.Get(Index: Integer): IGPSSatelliteInfo;
begin
  Result := IGPSSatelliteInfo(FList.Items[Index]);
end;

function TSatellitesInternalList.GetCapacity: Integer;
begin
  Result := FList.Capacity;
end;

function TSatellitesInternalList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSatellitesInternalList.GetList: PUnknownList;
begin
  Result := PUnknownList(FList.List);
end;

procedure TSatellitesInternalList.Put(Index: Integer; Item: IGPSSatelliteInfo);
begin
  if (Index >= 0) and (Index < FList.Count) then begin
    IInterface(FList.List[Index]) := Item;
  end;
end;

procedure TSatellitesInternalList.SetCapacity(NewCapacity: Integer);
var
  i: Integer;
begin
  if FList.Count > NewCapacity then begin
    for i := NewCapacity to FList.Count - 1 do begin
      IInterface(FList.List[i]) := nil;
    end;
  end;
  FList.Capacity := NewCapacity;
end;

procedure TSatellitesInternalList.SetCount(NewCount: Integer);
var
  i: Integer;
begin
  if FList.Count > NewCount then begin
    for i := NewCount to FList.Count - 1 do begin
      IInterface(FList.List[i]) := nil;
    end;
  end;
  FList.Count := NewCount;
end;

end.

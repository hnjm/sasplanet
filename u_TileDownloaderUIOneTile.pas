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

unit u_TileDownloaderUIOneTile;

interface

uses
  Windows,
  SyncObjs,
  Classes,
  Types,
  i_JclNotify,
  i_TileError,
  i_TileRequestResult,
  i_OperationNotifier,
  i_DownloadInfoSimple,
  u_OperationNotifier,
  u_MapType;

type
  TTileDownloaderUIOneTile = class(TThread)
  private
    FAppClosingNotifier: IJclNotifier;
    FErrorLogger: ITileErrorLogger;
    FDownloadInfo: IDownloadInfoSimple;
    FMapType: TMapType;
    FTile: TPoint;
    FZoom: Byte;

    FCancelNotifier: IOperationNotifier;
    FCancelNotifierInternal: IOperationNotifierInternal;
    FFinishEvent: TEvent;
    FTileDownloadFinishListener: IJclListenerDisconnectable;

    FAppClosingListener: IJclListener;
    FResult: ITileRequestResult;

    procedure OnTileDownloadFinish(AMsg: IInterface);
    procedure OnAppClosing;
    procedure ProcessResult(AResult: ITileRequestResult);
  protected
    procedure Execute; override;
  public
    constructor Create(
      AAppClosingNotifier: IJclNotifier;
      AXY: TPoint;
      AZoom: byte;
      AMapType: TMapType;
      ADownloadInfo: IDownloadInfoSimple;
      AErrorLogger: ITileErrorLogger
    ); overload;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  i_TileRequest,
  i_DownloadResult,
  u_NotifyEventListener,
  u_TileErrorInfo;

constructor TTileDownloaderUIOneTile.Create(
  AAppClosingNotifier: IJclNotifier;
  AXY: TPoint;
  AZoom: byte;
  AMapType: TMapType;
  ADownloadInfo: IDownloadInfoSimple;
  AErrorLogger: ITileErrorLogger
);
var
  VOperationNotifier: TOperationNotifier;
begin
  inherited Create(False);
  FDownloadInfo := ADownloadInfo;
  FErrorLogger := AErrorLogger;
  FAppClosingNotifier := AAppClosingNotifier;
  FTile := AXY;
  FZoom := AZoom;
  FMapType := AMapType;
  Priority := tpLower;
  FreeOnTerminate := True;

  VOperationNotifier := TOperationNotifier.Create;
  FCancelNotifierInternal := VOperationNotifier;
  FCancelNotifier := VOperationNotifier;
  FFinishEvent := TEvent.Create;

  FTileDownloadFinishListener := TNotifyEventListener.Create(Self.OnTileDownloadFinish);
  FAppClosingListener := TNotifyNoMmgEventListener.Create(Self.OnAppClosing);
  FAppClosingNotifier.Add(FAppClosingListener);
end;

destructor TTileDownloaderUIOneTile.Destroy;
begin
  FTileDownloadFinishListener.Disconnect;

  FAppClosingNotifier.Remove(FAppClosingListener);
  FAppClosingNotifier := nil;
  FAppClosingListener := nil;

  FreeAndNil(FFinishEvent);

  inherited;
end;

procedure TTileDownloaderUIOneTile.Execute;
var
  VOperationID: Integer;
  VRequest: ITileRequest;
begin
  Randomize;
  if FMapType.TileDownloadSubsystem.State.GetStatic.Enabled then begin
    VOperationID := FCancelNotifier.CurrentOperation;
    VRequest := FMapType.TileDownloadSubsystem.GetRequest(FCancelNotifier, VOperationID, FTile, FZoom, False);
    VRequest.FinishNotifier.Add(FTileDownloadFinishListener);
    FMapType.TileDownloadSubsystem.Download(VRequest);
    FFinishEvent.WaitFor(INFINITE);
    ProcessResult(FResult);
  end;
end;

procedure TTileDownloaderUIOneTile.OnAppClosing;
begin
  FTileDownloadFinishListener.Disconnect;
  FFinishEvent.SetEvent;
end;

procedure TTileDownloaderUIOneTile.OnTileDownloadFinish(AMsg: IInterface);
var
  VResult: ITileRequestResult;
begin
  VResult := AMsg as ITileRequestResult;
  FResult := VResult;
  FFinishEvent.SetEvent;
end;

procedure TTileDownloaderUIOneTile.ProcessResult(AResult: ITileRequestResult);
var
  VResultWithDownload: ITileRequestResultWithDownloadResult;
  VDownloadResultOk: IDownloadResultOk;
  VResultDownloadError: IDownloadResultError;
  VResultNotNecessary: IDownloadResultNotNecessary;
  VErrorString: string;
begin
  if AResult <> nil then begin
    VErrorString := '';
    if Supports(AResult, ITileRequestResultWithDownloadResult, VResultWithDownload) then begin
      if Supports(VResultWithDownload.DownloadResult, IDownloadResultOk, VDownloadResultOk) then begin
        if FDownloadInfo <> nil then begin
          FDownloadInfo.Add(1, VDownloadResultOk.Size);
        end;
      end else if Supports(VResultWithDownload.DownloadResult, IDownloadResultError, VResultDownloadError) then begin
        VErrorString := VResultDownloadError.ErrorText;
      end else if Supports(VResultWithDownload.DownloadResult, IDownloadResultNotNecessary, VResultNotNecessary) then begin
        VErrorString := VResultNotNecessary.ReasonText;
      end else begin
        VErrorString := 'Unexpected error';
      end;
    end;

    if VErrorString <> '' then begin
      if FErrorLogger <> nil then begin
        VErrorString := 'Error: ' + VErrorString;
        FErrorLogger.LogError(
          TTileErrorInfo.Create(
            FMapType,
            AResult.Request.Zoom,
            AResult.Request.Tile,
            VErrorString
          )
        );
      end;
    end;
  end;
end;

end.

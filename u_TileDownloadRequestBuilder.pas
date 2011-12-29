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

unit u_TileDownloadRequestBuilder;

interface

uses
  SyncObjs,
  SysUtils,
  i_OperationNotifier,
  i_TileRequest,
  i_TileDownloadRequestBuilder,
  i_LastResponseInfo,
  i_TileDownloadRequest,
  i_TileDownloadRequestBuilderConfig;

type
  TTileDownloadRequestBuilder = class(TInterfacedObject, ITileDownloadRequestBuilder)
  private
    FCS: TCriticalSection;
  protected
    FConfig: ITileDownloadRequestBuilderConfig;
    procedure Lock;
    procedure Unlock;
  protected
    function BuildRequest(
      ASource: ITileRequest;
      ALastResponseInfo: ILastResponseInfo;
      ACancelNotifier: IOperationNotifier;
      AOperationID: Integer
    ): ITileDownloadRequest; virtual; abstract;
  public
    constructor Create(AConfig: ITileDownloadRequestBuilderConfig);
    destructor Destroy; override;
  end;

implementation

{ TTileDownloadRequestBuilder }

constructor TTileDownloadRequestBuilder.Create(AConfig: ITileDownloadRequestBuilderConfig);
begin
  inherited Create;
  FConfig := AConfig;
  FCS := TCriticalSection.Create;
end;

destructor TTileDownloadRequestBuilder.Destroy;
begin
  FreeAndNil(FCS);
  inherited Destroy;
end;

procedure TTileDownloadRequestBuilder.Lock;
begin
  FCS.Acquire;
end;

procedure TTileDownloadRequestBuilder.Unlock;
begin
  FCS.Release;
end;

end.

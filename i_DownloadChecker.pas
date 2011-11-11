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

unit i_DownloadChecker;

interface

uses
  Classes,
  i_DownloadRequest,
  i_DownloadResult,
  i_DownloadResultFactory;

type
  IDownloadChecker = interface
    ['{70846BCE-6732-4FEB-8304-23BEFD4646D6}']
    function BeforeRequest(
      AResultFactory: IDownloadResultFactory;
      ARequest: IDownloadRequest
    ): IDownloadResult;
    function AfterReciveData(
      AResultFactory: IDownloadResultFactory;
      ARequest: IDownloadRequest;
      const ARecivedSize: Integer;
      const ARecivedBuffer: Pointer;
      var AStatusCode: Cardinal;
      var AContentType: string;
      var AResponseHead: string
    ): IDownloadResult;
  end;

  IRequestWithChecker = interface
    ['{76BA399A-D581-424E-8D8E-6809C590CA30}']
    function GetChecker: IDownloadChecker;
    property Checker: IDownloadChecker read GetChecker;
  end;

implementation

end.

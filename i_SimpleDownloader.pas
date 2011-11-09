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

unit i_SimpleDownloader;

interface

uses
  Classes,
  i_OperationNotifier,
  i_DownloadResult,
  i_DownloadRequest;

type
  ISimpleDownloader = interface
    ['{08A98FF9-5EDE-4F6E-9D5B-351FBF4C05BE}']
    function Get(
      ARequest: IDownloadRequest;
      ACancelNotifier: IOperationNotifier;
      AOperationID: Integer
    ): IDownloadResult;
  end;

implementation

end.

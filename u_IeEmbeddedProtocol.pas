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

unit u_IeEmbeddedProtocol;

interface

uses
  Windows,
  Classes,
  UrlMon,
  i_InternalDomainInfoProvider;

type
  TIeEmbeddedProtocol = class(TInterfacedObject, IInternetProtocolRoot, IInternetProtocol)
  private
    FDomainList: IInternalDomainInfoProviderList;
    FStream: TMemoryStream;

    FUrl: String;
    FProtocolSink: IInternetProtocolSink;
    FBindInfo: IInternetBindInfo;
    function ParseUrl(AUrl: string; out ADomain, AFilePath: string): Boolean;
    function LoadDataToStream(AUrl: String): Boolean;
  private { IInternetProtocolRoot }
    function Start(szUrl: LPCWSTR; OIProtSink: IInternetProtocolSink; OIBindInfo: IInternetBindInfo; grfPI, dwReserved: DWORD): HResult; stdcall;
    function Continue(const ProtocolData: TProtocolData): HResult; stdcall;
    function Abort(hrReason: HResult; dwOptions: DWORD): HResult; stdcall;
    function Terminate(dwOptions: DWORD): HResult; stdcall;
    function Suspend: HResult; stdcall;
    function Resume: HResult; stdcall;
  private { IInternetProtocol }
    function Read(pv: Pointer; cb: ULONG; out cbRead: ULONG): HResult; stdcall;
    function Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD; out libNewPosition: ULARGE_INTEGER): HResult; stdcall;
    function LockRequest(dwOptions: DWORD): HResult; stdcall;
    function UnlockRequest: HResult; stdcall;
  public
    constructor Create(ADomainList: IInternalDomainInfoProviderList);
    destructor Destroy; override;
  end;

implementation

uses
  StrUtils,
  SysUtils;

{ TIeEmbeddedProtocol }

constructor TIeEmbeddedProtocol.Create(ADomainList: IInternalDomainInfoProviderList);
begin
  FDomainList := ADomainList;
  FStream := TMemoryStream.Create;
end;

destructor TIeEmbeddedProtocol.Destroy;
begin
  FreeAndNil(FStream);
  inherited;
end;

function TIeEmbeddedProtocol.Abort(hrReason: HResult;
  dwOptions: DWORD): HResult;
begin
  Result := Inet_E_Invalid_Request;
end;

function TIeEmbeddedProtocol.Continue(
  const ProtocolData: TProtocolData): HResult;
begin
  Result := Inet_E_Invalid_Request;
end;

function TIeEmbeddedProtocol.LoadDataToStream(AUrl: String): Boolean;
var
  VDomainName: string;
  VFilePath: string;
  VDomain: IInternalDomainInfoProvider;
  VContentType: string;
begin
  Result := ParseUrl(AUrl, VDomainName, VFilePath);
  if Result then begin
    Result := False;
    try
      if FDomainList <> nil then begin
        VDomain := FDomainList.GetByName(VDomainName);
        if VDomain <> nil then begin
          Result := VDomain.LoadStreamByFilePath(VFilePath, FStream, VContentType);
          FProtocolSink.ReportProgress(BINDSTATUS_MIMETYPEAVAILABLE, PWideChar(WideString(VContentType)));
        end;
        FStream.Position := 0;
      end;
    except
      Result := False;
    end;
  end;
end;

function TIeEmbeddedProtocol.LockRequest(dwOptions: DWORD): HResult;
begin
  Result := S_OK;
end;

function TIeEmbeddedProtocol.ParseUrl(AUrl: string; out ADomain,
  AFilePath: string): Boolean;
var
  VProtoclSeparator: string;
  VFileNameSeparator: string;
  VPos: Integer;
  VDomainWithFileName: string;
begin
  Result := False;
  ADomain := '';
  AFilePath := '';
  VProtoclSeparator := '://';
  VFileNameSeparator := '/';
  VPos := Pos(VProtoclSeparator, AUrl);
  if VPos > 0 then begin
    VDomainWithFileName := RightStr(AUrl, Length(AUrl) - VPos - Length(VProtoclSeparator) + 1);
    if Length(VDomainWithFileName) > 0 then begin
      VPos := Pos(VFileNameSeparator, VDomainWithFileName);
      if VPos > 0 then begin
        ADomain := LeftStr(VDomainWithFileName, VPos - 1);
        AFilePath := RightStr(VDomainWithFileName, Length(VDomainWithFileName) - VPos - Length(VFileNameSeparator) + 1);
      end else begin
        ADomain := VDomainWithFileName;
      end;
      if Length(ADomain) > 0 then begin
        Result := True;
      end;
    end;
  end;
end;

function TIeEmbeddedProtocol.Read(pv: Pointer; cb: ULONG;
  out cbRead: ULONG): HResult;
begin
  if FStream.Position < FStream.Size then begin
    cbRead := FStream.Read(pv^, cb);
    if FStream.Position < FStream.Size then begin
      FProtocolSink.ReportData(BSCF_INTERMEDIATEDATANOTIFICATION, FStream.Position, FStream.Size)
    end else begin
      FProtocolSink.ReportData(BSCF_LASTDATANOTIFICATION, FStream.Position, FStream.Size);
    end;
    Result := S_OK;
  end else begin
    Result := S_FALSE;
  end;
  FProtocolSink.ReportResult(S_OK, 0, nil);
end;

function TIeEmbeddedProtocol.Resume: HResult;
begin
  Result := Inet_E_Invalid_Request;
end;

function TIeEmbeddedProtocol.Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD;
  out libNewPosition: ULARGE_INTEGER): HResult;
begin
  Result := E_Fail;
end;

function TIeEmbeddedProtocol.Start(szUrl: LPCWSTR;
  OIProtSink: IInternetProtocolSink; OIBindInfo: IInternetBindInfo; grfPI,
  dwReserved: DWORD): HResult;
begin
  if ((szUrl = nil) or (OIProtSink = nil)) then begin
    Result := E_INVALIDARG;
  end else begin
    FUrl := szUrl;
    FProtocolSink := OIProtSink;
    FBindInfo := OIBindInfo;
    if LoadDataToStream(szUrl) then begin
      //����������� � ��� ��� ���� ��� ����������
      FProtocolSink.ReportData(BSCF_FIRSTDATANOTIFICATION, 0, FStream.Size);
      Result := S_OK;
    end else begin
      Result := INET_E_DOWNLOAD_FAILURE;
    end;
  end;
end;

function TIeEmbeddedProtocol.Suspend: HResult;
begin
  Result := Inet_E_Invalid_Request;
end;

function TIeEmbeddedProtocol.Terminate(dwOptions: DWORD): HResult;
begin
  FProtocolSink := nil;
  FBindInfo := nil;
  Result := S_OK;
end;

function TIeEmbeddedProtocol.UnlockRequest: HResult;
begin
  Result := S_OK;
end;

end.

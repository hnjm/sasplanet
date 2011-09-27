{******************************************************************************}
{* SAS.������� (SAS.Planet)                                                   *}
{* Copyright (C) 2007-2011, ������ ��������� SAS.������� (SAS.Planet).        *}
{* ��� ��������� �������� ��������� ����������� ������������. �� ������       *}
{* �������������� �/��� �������������� � �������� �������� �����������       *}
{* ������������ �������� GNU, �������������� ������ ���������� ������������   *}
{* �����������, ������ 3. ��� ��������� ���������������� � �������, ��� ���   *}
{* ����� ��������, �� ��� ������ ��������, � ��� ����� ���������������        *}
{* �������� ��������� ��������� ��� ������� � �������� ��� ������˨�����      *}
{* ����������. �������� ����������� ������������ �������� GNU ������ 3, ���   *}
{* ��������� �������������� ����������. �� ������ ���� �������� �����         *}
{* ����������� ������������ �������� GNU ������ � ����������. � ������ �     *}
{* ����������, ���������� http://www.gnu.org/licenses/.                       *}
{*                                                                            *}
{* http://sasgis.ru/sasplanet                                                 *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_EcwDllSimple;

interface

uses
  Windows,
  ECWWriter,
  i_EcwDll;

type
  TEcwDllSimple = class(TInterfacedObject, IEcwDll)
  private
    FDllHandle: HMODULE;

    FCompressAllocClient: NCSEcwCompressAllocClient;
    FCompressOpen: NCSEcwCompressOpen;
    FCompress: NCSEcwCompress;
    FCompressClose: NCSEcwCompressClose;
    FCompressFreeClient: NCSEcwCompressFreeClient;
  protected
    function GetCompressAllocClient: NCSEcwCompressAllocClient;
    function GetCompressOpen: NCSEcwCompressOpen;
    function GetCompress: NCSEcwCompress;
    function GetCompressClose: NCSEcwCompressClose;
    function GetCompressFreeClient: NCSEcwCompressFreeClient;
  public
    constructor Create(
      ADllPath: string
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

{ TEcwDllSimple }

constructor TEcwDllSimple.Create(ADllPath: string);
const
  CDllName = 'NCSEcwC.dll';
  CCompressAllocClientFunctionName = 'NCSEcwCompressAllocClient';
  CCompressOpenFunctionName = 'NCSEcwCompressOpen';
  CCompressFunctionName = 'NCSEcwCompress';
  CCompressCloseFunctionName = 'NCSEcwCompressClose';
  CCompressFreeClientFunctionName = 'NCSEcwCompressFreeClient';
begin
  try
    FDllHandle := LoadLibrary(PChar(ADllPath + CDllName));
    if FDllHandle = 0 then begin
      RaiseLastOSError;
    end;
    FCompressAllocClient := GetProcAddress(FDllHandle, CCompressAllocClientFunctionName);
    if not Assigned(FCompressAllocClient) then begin
      raise Exception.CreateFmt('Function %s not found', [CCompressAllocClientFunctionName]);
    end;
    FCompressOpen := GetProcAddress(FDllHandle, CCompressOpenFunctionName);
    if not Assigned(FCompressOpen) then begin
      raise Exception.CreateFmt('Function %s not found', [CCompressOpenFunctionName]);
    end;
    FCompress := GetProcAddress(FDllHandle, CCompressFunctionName);
    if not Assigned(FCompress) then begin
      raise Exception.CreateFmt('Function %s not found', [CCompressFunctionName]);
    end;
    FCompressClose := GetProcAddress(FDllHandle, CCompressCloseFunctionName);
    if not Assigned(FCompressClose) then begin
      raise Exception.CreateFmt('Function %s not found', [CCompressCloseFunctionName]);
    end;
    FCompressFreeClient := GetProcAddress(FDllHandle, CCompressFreeClientFunctionName);
    if not Assigned(FCompressFreeClient) then begin
      raise Exception.CreateFmt('Function %s not found', [CCompressFreeClientFunctionName]);
    end;
  except
    raise Exception.Create('������ ��� �������� ���������� ' + CDllName);
  end;
end;

destructor TEcwDllSimple.Destroy;
begin
  if FDllHandle <> 0 then begin
    FreeLibrary(FDllHandle);
    FDllHandle := 0;
  end;
  inherited;
end;

function TEcwDllSimple.GetCompress: NCSEcwCompress;
begin
  Result := FCompress;
end;

function TEcwDllSimple.GetCompressAllocClient: NCSEcwCompressAllocClient;
begin
  Result := FCompressAllocClient
end;

function TEcwDllSimple.GetCompressClose: NCSEcwCompressClose;
begin
  Result := FCompressClose
end;

function TEcwDllSimple.GetCompressFreeClient: NCSEcwCompressFreeClient;
begin
  Result := FCompressFreeClient
end;

function TEcwDllSimple.GetCompressOpen: NCSEcwCompressOpen;
begin
  Result := FCompressOpen;
end;

end.

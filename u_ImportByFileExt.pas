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

unit u_ImportByFileExt;

interface

uses
  i_ImportFile,
  i_VectorDataLoader,
  i_ImportConfig;

type
  TImportByFileExt = class(TInterfacedObject, IImportFile)
  private
    FImportPLT: IImportFile;
    FImportKML: IImportFile;
    FImportKMZ: IImportFile;
    FImportHLG: IImportFile;
    FImportMP: IImportFile;
  protected
    function ProcessImport(AFileName: string; AConfig: IImportConfig): Boolean;
  public
    constructor Create(
      APltLoader: IVectorDataLoader;
      AKmlLoader: IVectorDataLoader;
      AKmzLoader: IVectorDataLoader
    );
  end;

implementation

uses
  SysUtils,
  u_ImportKML,
  u_ImportHLG,
  u_ImportMpSimple;

{ TImportByFileExt }

constructor TImportByFileExt.Create(
  APltLoader: IVectorDataLoader;
  AKmlLoader: IVectorDataLoader;
  AKmzLoader: IVectorDataLoader
);
begin
  FImportPLT := TImportKML.Create(APltLoader);
  FImportHLG := TImportHLG.Create;
  FImportMP := TImportMpSimple.Create;
  FImportKML := TImportKML.Create(AKmlLoader);
  FImportKMZ := TImportKML.Create(AKmzLoader);
end;

function TImportByFileExt.ProcessImport(AFileName: string;
  AConfig: IImportConfig): Boolean;
begin
  Result := False;
  if (LowerCase(ExtractFileExt(AFileName))='.kml') then begin
    Result := FImportKML.ProcessImport(AFileName, AConfig);
  end else if (LowerCase(ExtractFileExt(AFileName))='.kmz') then begin
    Result := FImportKMZ.ProcessImport(AFileName, AConfig);
  end else if (LowerCase(ExtractFileExt(AFileName))='.plt') then begin
    Result := FImportPLT.ProcessImport(AFileName, AConfig);
  end else if (LowerCase(ExtractFileExt(AFileName))='.hlg') then begin
    Result := FImportHLG.ProcessImport(AFileName, AConfig);
  end else if (LowerCase(ExtractFileExt(AFileName))='.mp') then begin
    Result := FImportMP.ProcessImport(AFileName, AConfig);
  end;
end;

end.

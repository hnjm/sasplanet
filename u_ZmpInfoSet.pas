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

unit u_ZmpInfoSet;

interface

uses
  ActiveX,
  i_GUIDSet,
  i_ZmpInfo,
  i_CoordConverterFactory,
  i_LanguageManager,
  i_FileNameIterator,
  i_ZmpInfoSet;

type
  TZmpInfoSet = class(TInterfacedObject, IZmpInfoSet)
  private
    FList: IGUIDInterfaceSet;
  protected
    function GetZmpByGUID(AGUID: TGUID): IZmpInfo;
    function GetIterator: IEnumGUID;
  public
    constructor Create(
      ACoordConverterFactory: ICoordConverterFactory;
      ALanguageManager: ILanguageManager;
      AFilesIterator: IFileNameIterator
    );
  end;

implementation

uses
  SysUtils,
  Dialogs,
  i_ConfigDataProvider,
  u_GUIDInterfaceSet,
  u_ConfigDataProviderByFolder,
  u_ConfigDataProviderByKaZip,
  u_ZmpInfo,
  u_ResStrings;

{ TZmpInfoSet }

constructor TZmpInfoSet.Create(
  ACoordConverterFactory: ICoordConverterFactory;
  ALanguageManager: ILanguageManager;
  AFilesIterator: IFileNameIterator
);
var
  VFileName: WideString;
  VFullFileName: string;
  VZmp: IZmpInfo;
  VZmpExist: IZmpInfo;
  VZmpMapConfig: IConfigDataProvider;
  VMapTypeCount: integer;
begin
  FList := TGUIDInterfaceSet.Create;
  VMapTypeCount := 0;
  while AFilesIterator.Next(VFileName) do begin
    VFullFileName := AFilesIterator.GetRootFolderName + VFileName;
    try
      if FileExists(VFullFileName) then begin
        VZmpMapConfig := TConfigDataProviderByKaZip.Create(VFullFileName);
      end else begin
        VZmpMapConfig := TConfigDataProviderByFolder.Create(VFullFileName);
      end;
      try
        VZmp := TZmpInfo.Create(
          ALanguageManager,
          ACoordConverterFactory,
          VFileName,
          VZmpMapConfig,
          VMapTypeCount
        );
      except
        on E: EZmpError do begin
          raise Exception.CreateResFmt(@SAS_ERR_MapGUIDError, [VFileName, E.Message]);
        end;
      end;
      VZmpExist := IZmpInfo(FList.GetByGUID(VZmp.GUID));
      if VZmpExist <> nil then begin
        raise Exception.CreateFmt(SAS_ERR_MapGUIDDuplicate, [VZmpExist.FileName, VFullFileName]);
      end;
    except
      if ExceptObject <> nil then begin
        ShowMessage((ExceptObject as Exception).Message);
      end;
      VZmp := nil;
    end;
    if VZmp <> nil then begin
      FList.Add(VZmp.GUID, VZmp);
      inc(VMapTypeCount);
    end;
  end;
end;

function TZmpInfoSet.GetIterator: IEnumGUID;
begin
  Result := FList.GetGUIDEnum;
end;

function TZmpInfoSet.GetZmpByGUID(AGUID: TGUID): IZmpInfo;
begin
  Result := IZmpInfo(FList.GetByGUID(AGUID));
end;

end.

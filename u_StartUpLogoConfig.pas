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

unit u_StartUpLogoConfig;

interface

uses
  GR32,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_ContentTypeManager,
  i_StartUpLogoConfig,
  u_ConfigDataElementBase;

type
  TStartUpLogoConfig = class(TConfigDataElementBase, IStartUpLogoConfig)
  private
    FContentTypeManager: IContentTypeManager;

    FIsShowLogo: Boolean;

    FLogoFileName: string;
    FLogo: TCustomBitmap32;
  protected
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function GetIsShowLogo: Boolean;
    procedure SetIsShowLogo(AValue: Boolean);

    function GetLogo: TCustomBitmap32;
  public
    constructor Create(
      AContentTypeManager: IContentTypeManager
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  u_ConfigProviderHelpers;

{ TGlobalAppConfig }

constructor TStartUpLogoConfig.Create(
  AContentTypeManager: IContentTypeManager
);
begin
  inherited Create;
  FContentTypeManager := AContentTypeManager;

  FIsShowLogo := True;
  FLogo := TCustomBitmap32.Create;
  FLogoFileName := 'sas:\Resource\LOGOI.jpg';
end;

destructor TStartUpLogoConfig.Destroy;
begin
  FreeAndNil(FLogo);
  inherited;
end;

procedure TStartUpLogoConfig.DoReadConfig(AConfigData: IConfigDataProvider);
begin
  inherited;
  if AConfigData <> nil then begin
    FIsShowLogo := AConfigData.ReadBool('ShowLogo', FIsShowLogo);

    ReadBitmapByFileRef(AConfigData, FLogoFileName, FContentTypeManager, FLogo);

    SetChanged;
  end;
end;

procedure TStartUpLogoConfig.DoWriteConfig(AConfigData: IConfigDataWriteProvider);
begin
  inherited;
  AConfigData.WriteBool('ShowLogo', FIsShowLogo);
end;

function TStartUpLogoConfig.GetIsShowLogo: Boolean;
begin
  LockRead;
  try
    Result := FIsShowLogo;
  finally
    UnlockRead;
  end;
end;

function TStartUpLogoConfig.GetLogo: TCustomBitmap32;
begin
  LockRead;
  try
    Result := FLogo;
  finally
    UnlockRead;
  end;
end;

procedure TStartUpLogoConfig.SetIsShowLogo(AValue: Boolean);
begin
  LockWrite;
  try
    if FIsShowLogo <> AValue then begin
      FIsShowLogo := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

end.

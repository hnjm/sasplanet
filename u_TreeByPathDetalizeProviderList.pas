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

unit u_TreeByPathDetalizeProviderList;

interface

uses
  Classes,
  u_TreeChangeableBase,
  i_PathDetalizeProviderList;

type
  TTreeByPathDetalizeProviderList = class(TTreeChangeableBase)
  private
    FProviderList: IPathDetalizeProviderList;
  protected
    function GetSource: IInterface; override;
  public
    constructor Create(AProviderList: IPathDetalizeProviderList);
  end;


implementation

uses
  SysUtils,
  ActiveX,
  u_StaticTreeBuilderBase;

type
  TStaticTreeByPathDetalizeProviderListBuilder = class(TStaticTreeBuilderBaseBySlash)
  protected
    procedure ProcessItems(ASource: IInterface; AList: TStringList); override;
    function GetNameFromItem(
      ASource: IInterface;
      AItem: IInterface
    ): string; override;
  public
    constructor Create;
  end;

{ TStaticTreeByPathDetalizeProviderListBuilder }

constructor TStaticTreeByPathDetalizeProviderListBuilder.Create;
begin
  inherited Create('\', '|');
end;

function TStaticTreeByPathDetalizeProviderListBuilder.GetNameFromItem(
  ASource: IInterface;
  AItem: IInterface
): string;
begin
  Result := (AItem as IPathDetalizeProviderListEntity).MenuItemName;
end;

procedure TStaticTreeByPathDetalizeProviderListBuilder.ProcessItems(
  ASource: IInterface;
  AList: TStringList
);
var
  VList: IPathDetalizeProviderList;
  VEnum: IEnumGUID;
  VGUID: TGUID;
  i: Cardinal;
  VItem: IPathDetalizeProviderListEntity;
begin
  VList := ASource as IPathDetalizeProviderList;
  VEnum := VList.GetGUIDEnum;
  while VEnum.Next(1, VGUID, i) = S_OK do begin
    VItem := VList.Get(VGUID);
    ProcessItem(ASource, VItem, AList);
  end;
end;

{ TTreeByPathDetalizeProviderList }

constructor TTreeByPathDetalizeProviderList.Create(
  AProviderList: IPathDetalizeProviderList);
begin
  FProviderList := AProviderList;
  inherited Create(
    TStaticTreeByPathDetalizeProviderListBuilder.Create,
    FProviderList.GetChangeNotifier
  );
end;

function TTreeByPathDetalizeProviderList.GetSource: IInterface;
begin
  Result := FProviderList;
end;

end.

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

unit u_BackgroundTaskLayerDrawBase;

interface

uses
  Classes,
  i_OperationNotifier,
  u_BackgroundTask;

type
  TBgPaintLayerEvent =
    procedure(
      AOperationID: Integer;
      ACancelNotifier: IOperationNotifier
    ) of object;

  TBackgroundTaskLayerDrawBase = class(TBackgroundTask)
  private
    FOnBgPaintLayer: TBgPaintLayerEvent;
  protected
    procedure ExecuteTask(
      AOperationID: Integer;
      ACancelNotifier: IOperationNotifier
    ); override;
  public
    constructor Create(AOnBgPaintLayer: TBgPaintLayerEvent; APriority: TThreadPriority = tpLowest);
  end;

implementation

uses
  Types;

{ TBackgroundTaskLayerDrawBase }

constructor TBackgroundTaskLayerDrawBase.Create(AOnBgPaintLayer: TBgPaintLayerEvent; APriority: TThreadPriority);
begin
  inherited Create(APriority);
  FOnBgPaintLayer := AOnBgPaintLayer;
end;

procedure TBackgroundTaskLayerDrawBase.ExecuteTask(
  AOperationID: Integer;
  ACancelNotifier: IOperationNotifier
);
begin
  inherited;
  if Assigned(FOnBgPaintLayer) then begin
    FOnBgPaintLayer(AOperationID, ACancelNotifier);
  end;
end;

end.

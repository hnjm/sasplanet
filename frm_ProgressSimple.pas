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

unit frm_ProgressSimple;

interface

uses
  Windows,
  Classes,
  Forms,
  Graphics,
  Controls,
  StdCtrls,
  ExtCtrls,
  RarProgress,
  u_CommonFormAndFrameParents;

type
  TfrmProgressSimple = class(TCommonFormParent)
    MemoInfo: TMemo;
    pnlProgress: TPanel;
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MemoInfoChange(Sender: TObject);
  private
    FRarProgress: TRarProgress;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    property ProgressBar1: TRarProgress read FRarProgress;
  end;

implementation

{$R *.dfm}

constructor TfrmProgressSimple.Create(AOwner: TComponent);
begin
  inherited;
  FRarProgress := TRarProgress.Create(Self);
  with FRarProgress do begin
    Left := 6;
    Top := 30;
    Width := 315;
    Height := 17;
    Min := 0;
    Max := 100;
    Progress1 := 50;
    Progress2 := 30;
    Double := False;
    LightColor1 := 16770764;
    DarkColor1 := 13395456;
    LightColor2 := 16768959;
    FrameColor1 := 16758122;
    FrameColor2 := 16747546;
    FillColor1 := 16757606;
    FillColor2 := 16749867;
    BackFrameColor1 := 16633762;
    BackFrameColor2 := 16634540;
    BackFillColor := 16635571;
    ShadowColor := clGray;
  end;
  FRarProgress.Parent := pnlProgress;
  FRarProgress.Align := alClient;
end;

procedure TfrmProgressSimple.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then close;
end;

procedure TfrmProgressSimple.MemoInfoChange(Sender: TObject);
begin
  HideCaret(MemoInfo.Handle);
end;

end.

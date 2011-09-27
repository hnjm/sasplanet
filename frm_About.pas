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

unit frm_About;

interface

uses
  Windows,
  Forms,
  Classes,
  Controls,
  StdCtrls,
  ExtCtrls,
  u_CommonFormAndFrameParents;

type
  TfrmAbout = class(TCommonFormParent)
    Bevel1: TBevel;
    btnClose: TButton;
    lblVersionCatpion: TLabel;
    lblWebSiteCaption: TLabel;
    lblEMailCaption: TLabel;
    lblProgramName: TLabel;
    lblVersion: TLabel;
    lblEMail: TLabel;
    lblWebSite: TLabel;
    pnlBottom: TPanel;
    Label1: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblWebSiteClick(Sender: TObject);
    procedure lblEMailClick(Sender: TObject);
  private
  public
  end;

var
  frmAbout: TfrmAbout;

implementation

uses
  c_SasVersion,
  frm_InvisibleBrowser;

{$R *.dfm}

procedure TfrmAbout.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
 lblVersion.Caption:=SASVersion;
end;

procedure TfrmAbout.lblWebSiteClick(Sender: TObject);
begin
  OpenUrlInBrowser('http://sasgis.ru');
end;

procedure TfrmAbout.lblEMailClick(Sender: TObject);
begin
  OpenUrlInBrowser('mailto:'+lblEMail.Caption);
end;

end.

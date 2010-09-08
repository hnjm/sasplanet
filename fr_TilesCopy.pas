unit fr_TilesCopy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, CheckLst, ExtCtrls;

type
  TfrTilesCopy = class(TFrame)
    pnlCenter: TPanel;
    pnlRight: TPanel;
    lblZooms: TLabel;
    chkAllZooms: TCheckBox;
    chklstZooms: TCheckListBox;
    pnlMain: TPanel;
    lblNamesType: TLabel;
    cbbNamesType: TComboBox;
    pnlTop: TPanel;
    lblTargetPath: TLabel;
    edtTargetPath: TEdit;
    btnSelectTargetPath: TButton;
    chkDeleteSource: TCheckBox;
    chkReplaseTarget: TCheckBox;
    chkAllMaps: TCheckBox;
    chklstMaps: TCheckListBox;
    procedure btnSelectTargetPathClick(Sender: TObject);
    procedure chkAllZoomsClick(Sender: TObject);
    procedure chkAllMapsClick(Sender: TObject);
  private
  public
    procedure Init;
  end;

implementation

uses
  FileCtrl,
  u_GlobalState,
  UResStrings,
  UMapType;

{$R *.dfm}

procedure TfrTilesCopy.btnSelectTargetPathClick(Sender: TObject);
var
  TempPath: string;
begin
  if SelectDirectory('', '', TempPath) then begin
    edtTargetPath.Text := IncludeTrailingPathDelimiter(TempPath);
  end;
end;

procedure TfrTilesCopy.chkAllMapsClick(Sender: TObject);
var
  i: byte;
begin
  for i:=0 to chklstMaps.Count-1 do begin
    chklstMaps.Checked[i] := TCheckBox(sender).Checked;
  end;
end;

procedure TfrTilesCopy.chkAllZoomsClick(Sender: TObject);
var
  i: byte;
begin
  for i:=0 to chklstZooms.Count-1 do begin
    chklstZooms.Checked[i] := TCheckBox(sender).Checked;
  end;
end;

procedure TfrTilesCopy.Init;
var
  i: integer;
  VMapType: TMapType;
  VActiveMap: TMapType;
  VAddedIndex: Integer;
begin
  VActiveMap := GState.ViewState.GetCurrentMap;

  chklstZooms.Items.Clear;
  for i:=1 to 24 do begin
    chklstZooms.Items.Add(inttostr(i));
  end;

  chklstMaps.Items.Clear;
  For i:=0 to length(GState.MapType)-1 do begin
    VMapType := GState.MapType[i];
    VAddedIndex := chklstMaps.Items.AddObject(VMapType.name, VMapType);
    if VMapType = VActiveMap then begin
      chklstMaps.ItemIndex := VAddedIndex;
    end;
  end;
end;

end.

(******************************************************************************
������:      SAS4WinCE
����������:  SASPlanet
�����:       Dima2000
������:      v18
����:        18.05.2012

������   ��������  �����  TSAS4WinCE,  ����������� ������� ������ �� SASPlanet
�����  �    ������   �����������   ����   ���   ��������  v_max  (SAS4WinCE  �
SAS4Andriod, http://4pna.com/forumdisplay.php?f=114).
��������   �������������   ������   �  �  ������ ���������, ������� ����������
������  �����   �   ������������   ����������   SASPlanet,   ��   ���  �������
����������� �� �������������.
�   ����������  ������  ������  ���������  ����� *.d00 (�������� � �� *.d99) �
*.inx,  ���������   �������   ���   ������  ��  SD  �����  �  �������������  �
SAS4WinCE � SAS4Andriod.
���   �����������   ������,   �   ���   ��  �����  ��� �� ��������� ����������
������  �������  �  ������  ������  ��������.  �  �������� ������ ������ � ���
��������� (property)  ��������  ����������  ��  ����������  ����������� ������
(����������  ������������,   ���  ��������)  � ������� ���������� ������������
������. ��������� ������ ���������� ������.


*******************************************************************************
������� ������������� ������������������ �������:
  .Create(
    <��� ����������� ������, ����� ���������� � ���� � ���>,
    -1,
    <����������� � ������, ����� ���� ������>
  );
  for ... do // ��� ������� �����
  begin
    .Add(
      z,x,y,
      tile,     // ��������� �� ����� � ��������� ������� �����
      tilesize, // ����� ������ � ������
      <���������� ��������� ����� � ������, ���� ��������>
    );
  end;
  .SaveINX(); // ��� ������������ � ������ �������
  .Destroy;
���  �������  �����  ���������  ������  ��  ����  .Add  �  ������ .SaveINX ���
������������  ����������  ��������������� �������� � ������ ������� ������. ��
���� ����� �����, �� �����.
�����  �������� .SaveINX ����� ��� ��� ���������� ����������� ������� � ������
�����.
�����   ��������  .Create  �  ������  ������  �����.  ���  ����  �����  ������
����������� �� �����, �� �� ������� ��������� ����� ��� ������, � ������ �����
����� �������� ����������. ����������� ������ ��� �������.
�����  (� �����) �������� � SaveINX � ������ ������ �����. ����� ��� ����� ���
��������  ��  .Create,  ���  ������ �� ����� ������������ (���� � ��� �����).
��������� ���� ������ ��� �������.
�����  �������  ����  .Add, ����� .SaveINX(''), � ����� ��������� ������������
������  � ������ ��� ������ ������. ��� ����� ���� �������� ����� �� ���������
���������� ������� ������ � ������.
�����  �������  �����������  �  ������  ������  �����,  .SaveINX ���� � ������
������,  ���������  ������������ ������� ������, ���������� ������ � ���������
�� ������, �������� � ������� �����������.

*******************************************************************************
� ����� .d?? ����� ����������� 12..15+ �������� ��������� ��� ������� �����:
recovery info = record
  z: byte;       // ���� ����
  x: int24;      // ���� ��� �����
  y: int24;      // ���� ��� �����
  len: int32;    // ����� �����, 4 �����
  ext_len: byte; // ����� ���������� ����� � ������
  ext: char[];   // ���������� ����� (���������� �� ������ 255 ��������)
end;
������ ��������� ����� ������������� ��� �������������� ����� ������� �� �����
������  ���  ��� �������� ���������� ������ ������. � ��������� ������� ��� ��
���������.    SAS4WinCE/SAS4Android    �    �����  ��  ����������.  ��  �����
����������� � ������� ��� ����� ���������� ���� � ������ �������.

*******************************************************************************
������� ���������.
�����������:
[+] - ���������� �����������
[-] - �������� �����������
[!] - ����������� ������
[*] - ����������� (�� ������), ���������
{!} - ���������� �����, ����� ��������� �������
*******************************************************************************
����    ������  �����   ���������
*******************************************************************************
28.04.2012  v0.4
Dima2000:
[*] ������ ������� ������� � ��������� unit.

28.04.2012  v0.5
Dima2000:
[+] ������     ��������    ����������    �������   ��������   �   ������������
    ������������������� ������ ��������.
[!] �� ��������� �������� �� ������������� ������ ��������� ������ (Tx � Ty).
[*] �������� �������� �������� ������� ����� �����.

28.04.2012  v0.6
Dima2000:
[+] ��������� ������ ������������ ������.
[*] ������ ���������� ���������� ����� �� 4-� ������.

28.04.2012  v0.7
Dima2000:
[+] ��������� ����������� ������ ��� ����� ������� ��������� �� ����� ������.
[+] �������������� ����������� ����������� �� ������ �� ���� ����� ������ ���
    �   �������  ����  (���������   �������  �����  �����).  �������  ��� ����
    ��������� ���������.

28.04.2012  v8
Dima2000:
[+] ��������� ��������� �������� ��������.
[+] ��������� ��������� � ������� ����������� � �������� ��������.
[*] ���������� ���������� ������ ������� Z. �� ����� �������� ������ �� ��� 24
    ��������.
[*] ������� ��������� ������ �� ������.

30.04.2012  v9
Dima2000:
[*] ������ ��������� � �����.
[*] ������� ��������� ������.
[+] ����������� ���������� ������������ ������ ����������� � ����� ������� � �
    ������ ������.

01.05.2012  v10
Dima2000:
[*] ����������� ������ ��� ���������� � �����. ��������� �����. � ������� �� �
    ������ ������, � ������ �������������.
[*] �����  �� ����� �������, ����������, ���� �������� ������.  �������� �����
    �������� �� �������������.

01.05.2012  v11
Dima2000:
[*] ����������� ������ ��� ���������� � �����. ������ ��������.
[*] ������� ���������� � ���� ������.

01.05.2012  v12
Dima2000:
[*] ������� ������� ������ �� ��������� ����������.

01.05.2012  v13
Dima2000:
[*] �������� ������ ������ ������� ������ ������ � 1�� �� 1��.
[*] ��������� ���� ����� �� �� TMemoryStream.
[*] ���������   �����������   ���������   ������������  ���������  �  .SaveINX
    ���������� ������ (�� ��������� �������� ����������).
[*] ��������� const ��� ���������� �������.

01.05.2012  v14
Dima2000:
[*] ������� ���� ����� ��� ����������.

01.05.2012  v15
Dima2000:
[*] ����� ��������� �������� ������, ��������� ������� ����������, �����������
    ���������� false � ����� ���������� �������, ������� ���� �� ����������.
[*] ���  ���������  ������  ������  ���  ����������  ��������� �������� ������
    ����������.

02.05.2012  v16
Dima2000:
[*] ������� ������ �������� ������, ����� ������������ ��� ������ � ������� SAS.
[!] � ����������� �� ���������� ���� �������, ���� �� ����� ������� ��������.
[!] ��������� �������� (� ����� ����������) �� ������������ ���������� ������
    � .Add � �� ������ ������� � .SaveINX - ��-�� ����������� ������� � 2��.
zed:
[*] ����� ��������� ����� � .Add � TMemoryStream �� ��������� �� ����� + ������.

02.05.2012  v17
Dima2000:
[*] ��������������  �������� ���������� ... �������� ������.
    �  ����  ���������  ����� ��� ���, �������������� � ��������� �� ��������,
    ��������� ���� �������, �� �� �� ���������.

18.05.2012  v18
Dima2000:
[+] ������� ����� .AddExistTile ��� ������������ � ������ ����������.
[!] �������� ���� � ������������ ������� ������ � �������������.

*******************************************************************************
ToDo:
+1. ������ ����� ������ �������� ����������.
+2. ������ string ��������� ���� � TMemoryStream.
-3. �������� ����� ��  (� ���)  ������ ���������� ����� �� interface, ���� ���
�����  ����  ���  ������  �����  ������  �  ��. ��������� �������� � ���� 5-�
������, ��� �� ���������, ����� 7-�.
-4.  ������  ���������  ������, ������ � ����� � ������ �������� ��������� ���
������  -  ����������  �  ���  ����������,  ��  ������������,  �� � ���. �����
�����-������ �������, ����� ����.
+5. ������� ���� ���� ����� ������ �������. ��� � �����?
+6.  �������� � �������� ������ �� ����������� ���������� � ������������ ��� �
���� ������.
-7. ��������� ����� �� ����������� ������ � ����� (� ������� ������� 1��). ���
�����������  ��������  ��  �������. �� �� � � ����, ����� ����� ������������,
Blockwrite � ������ �������� ����� ��������� ����� ������.
+8.  ��������  �������� ���������� ������������ ��������� ������ � .SaveINX().
�������� ���������� ������, ����� �� ���������� ����������.
+9.  ���������  ��  ����������  ���  ����������  ������  (130���), ��� �������
�������, �� 2��. � �������� ����������.
-10.   �����������   �����   �������  ��������  ��������  ������  ������������
���������� ������, ����� ��� �������� � �����������? ������ �������� �� �����,
��  ���  ���������  ���  �����  �����  �����, � �� ����� ����� ���� ���-������
������������. ���, ����� ��������� ������� ����� ������� ������������.
******************************************************************************)

unit SAS4WinCE;

interface

uses
  SysUtils, Classes;

type
  {������� ����� ����������}
  ESAS4WinCE = class(Exception);
  {������� ������� ��� ������� ��������� ����� ������� ������ (� .Create)}
  ESAS4WinCElimit = class(ESAS4WinCE);
  {������� ������� ����������� (��� ���������� ������ ������� ������) (� .Create)}
  ESAS4WinCEbigComment = class(ESAS4WinCE);
  {����� ��� ������ ������ ����������� ������ (� .Add)}
  ESAS4WinCEover100dat = class(ESAS4WinCE);
  {� ��� �� ����� �������������� ������� ���������� ������, �� ����� (� .SaveINX)}
  ESAS4WinCEnoTiles = class(ESAS4WinCE);
  {�������  �����  �  �����������  ������������ z,x,y
  (����� �����-�� ��� � �� ������,  �����  ���  � ������ �����������, �� �����
  v_max  �����  ����������),  ���������  ������������ ���������� ��� ������
  (� .SaveINX)}
  ESAS4WinCEdupZXY = class(ESAS4WinCE);
  {�������  ����� ������, ������ �� ������ ��������� 2��, ��� �� ����� ~130���
  ������ (� .Add � � .SaveINX)}
  ESAS4WinCEbigIndex = class(ESAS4WinCE);
  {���������� ������ ����������, ��������� ������ ������������ (� .SaveINX)}
  ESAS4WinCEsortingError = class(ESAS4WinCE);

  TTileInfo = packed record
    dzxy: int64;    // d<<56+z<<48+x<<24+y
    ptr: integer;   // �������� � ����� ������
    size: integer;  // ����� �����
  end;
  TTableZX = packed record
    n: integer;     // ��������
    ptr: integer;   // �������� ������� � ����� �������
  end;
  TTableY = packed record
    n: integer;     // ��������
    d: integer;     // ����� ����� ������
    ptr: integer;   // �������� ����� � ����� ������
    size: integer;  // ����� ����� �����
  end;

  TSAS4WinCE = class
  private
    {���������� �������� ������}
    fTilesNum: integer;
    {���������� ��������������� ������ ������}
    fDataNum: integer;
    {������ ���� ���������� ������ ������}
    fDataPrev: int64;
    {����� ������ ���� ������ ������ ������� � �����������}
    fDataLen: int64;
    {����������� ���������� ������ ������ ������}
    fMaxSize: integer;
    {������ ����� ������� (����������� ������� .SaveINX)}
    fIndexLen: integer;
    {��� (��� ����������!) (����� � ����) ����������� ������}
    fFileName: string;
    {����������� ���������� ������ ������ ������}
    fLimit: integer;
    FD: file;
    {����������� � ������ �����������}
    fComment: string;
    {���������� �� � ����� ������ �������������� ���������� �� �����
    (��������� recovery info, 12-15+ ������) � �������� � ����� ������ � �������}
    bWriteTileInfo: boolean;
    {���� �� ������ ��� ����� ������}
    bWriteFD: boolean;
    {������ �� ���� ������}
    bOpenFD: boolean;
    {������ �� ���� �������}
    bOpenFI: boolean;
    {������ ���� � ������}
    Ttiles: array of TTileInfo;
    {��� �������� ��� �������� � ��������� �������}
    t: TTileInfo;
    {������� Z}
    Tz: array [1..24] of TTableZX;
    {������� X[z]}
    Tx: array of TTableZX;
    {������� Y[z,x]}
    Ty: array of TTableY;
{!} fSwap: int64;             // ������� ����� ������� ��������� ����������
{!} fMaxTx, fMaxTy: integer;  // ������������ ����������� ������ ������ X � Y

    {������������ ������ � �������� ��� � ��������� ����}
    procedure CreateINX(const fname: string; const bAllowDups: boolean);
    {������������� �����. ��������� ������� ���������� � 56-� ��������� �� ����� z,x,y}
    procedure SortAll(const l,r: integer; const m: int64);
    {������� �������� ���� ������, �������������� ������� ���� �����������}
    procedure CloseFD();

  public

    {������ � ��������� ������ (��� ����������� � ������� SAS?)}
    class function Name(): string;

    {������ ������ � ����������� � ������}
    class function Version(): string;

    {�������� ������� �������� ������ � ����}
    constructor Create(
      {��� ������ (��� ����������), ���� ��������������, � ����}
      const fname: string;
      {����������� ���������� ������ ������ ������, ���� < 0, �� ����� 1��}
      const maxsize: integer = -1;
      {����������� � ����� ������ �����������}
      const cmt: string = '';
      {����������     �    �����   ������   recovery  info. � �������� � �����
      ������  �  ����  �������.  ��������  ��������  �����  ���������� �������
      recovery info � ������ ������, ��� ����� ������������ �����}
      const info: boolean = true
    );

    {��������� �������� ����� � ����������� ������}
    destructor Destroy; override;

    {��������� ����}
    function Add(
      {���������� �����}
      const z, x, y: integer;
      {��������� �� ����� � ������� �����}
      const ptile: pointer;
      {����� ������ � ������}
      const tilesize: integer;
      {���������� ��������� ����� � ������}
      const fext: string=''
    {����� true ���� ���� ���������}
    ): boolean;

    {��������� ���� ���������� � �����}
    function AddExistTile(
      {���������� �����}
      const z, x, y: integer;
      {����� ����� ������ � ������}
      const d: byte;
      {�������� ����� � ����� ������}
      const ptr: integer;
      {������ �����}
      const tilesize: integer
    {����� true ���� ���� ���������}
    ): boolean;

    {��������� �������� ������, ������������ ������, �������� ��� � ����}
    function SaveINX(
      {���  �����  (���  ����������)  ���  ������  �������,  �  ����,
      ���� �� �������, ������ ��� �� ������������}
      const fname: string = '';
      {��������� ����� � ����������� ������������}
      const bAllowDups: boolean = false
    {����� true ���� ������ ������� �������}
    ): boolean;

    {���� � ��� (��� ����������) ����������� ������ ������ (���������� .Create)}
    property FileName: string  read fFileName;
    {����� ���������� �������� ������ (�������������� ������� .Add)}
    property TilesNum: integer read fTilesNum;
    {����� �������� ����� ������ (�������������� ������� .Add)}
    property DataNum: integer  read fDataNum;
    {����� ������ ���� ������ ������
    (�� ������ .SaveINX - ��� ������ �����������, � ��������� ����� ������)
    (�������������� �������� .Add � .SaveINX)}
    property DataLen: int64    read fDataLen;
    {������ ����� ������� (����������� ������� .SaveINX ����� ���������� ��������)}
    property IndexLen: integer read fIndexLen;
    {����������� � ������ ����������� (���������� .Create)}
    property Comment: string   read fComment;
    {����������    �   �����  ������  recovery info. � �������� � ����� ������
    �  ����  �������.   ��������  ��������  �����  ���������� ������� recovery
    info � ������ ������, ��� ����� ������������ �����}
    property WriteTileInfo: boolean  read bWriteTileInfo;
    {����������� ���������� ������ ������ ������ (���������� .Create)}
    property MaxFileSize: integer  read fMaxSize;
{!} property Swaps: int64      read fSwap;  // ������� ����� ������� ��������� ����������
{!} property MaxTx: integer    read fMaxTx; // ������������ ������ ������ X
{!} property MaxTy: integer    read fMaxTy; // ������������ ������ ������ Y
  end;


implementation

const
  unit_name = 'Packed cache for SAS4WinCE/SAS4Android';
  unit_ver = 'v18';
  copyright =
    #13#10'*****   Export from SAS.Planeta to SAS4WinCE  '
    + unit_ver
    + '   *****'#13#10#13#10#0;
  {�� ������� ����������� ������ ������ ��� ������������ (� ������� �� 16�)}
  TilesSizeInc = 100000;
  {����� ����� ��� ����������}
  mask56 = $FFFFFFFFFFFFFF;
  {����������� ���������� ������ ����� �������}
  IndexMaxSize = 2147000000;


{�������� ������ � ������ ������}
class function TSAS4WinCE.Version(): string;
begin
  Result := unit_ver;
end;

{�������� ������ � ������/��������� ������}
class function TSAS4WinCE.Name(): string;
begin
  Result := unit_name;
end;


{������� �������� ���� ������, �������������� ������� ���� �����������}
procedure TSAS4WinCE.CloseFD();
var
  s: string;
begin
  if not bOpenFD then
    {��� ��������� ����� ������}
    Exit;
  if length(Comment) > 0 then
  begin
    {�������  ���  ��������  ������  ���  ����������� ��������� ����������� ��
    �������� ������ � \0 � ����� ����� ������ ����� ASCIIZ}
    s := #13#10#13#10 + Comment + #0;
    Blockwrite(FD, s[1], length(s));
    {�������� ����� ����� ���� ������ ������ �� ����� ����������� ������}
    Inc(fDataLen, length(s));
    {�������� ������� ������ ���� ��������� � ������ ������ �����}
    fDataPrev := fDataLen;
  end;
  CloseFile(FD);
  bOpenFD := false;
end;


{��������� ����}
function TSAS4WinCE.Add(
  {���������� �����}
  const z, x, y: integer;
  {��������� �� ����� � ������� �����}
  const ptile: pointer;
  {����� ������ � ������}
  const tilesize: integer;
  {���������� ��������� ����� � ������}
  const fext: string=''
{����� true ���� ���� ���������}
): boolean;
var
  n: integer;
  s: string;
begin
  Result := false;
  if fTilesNum > 130000000 then
    {������� ����� ������ ��� ������� 2��}
    raise ESAS4WinCEbigIndex.Create('Too many tiles!');
  if tilesize = 0 then
    {����� ������� ����� �� ���������}
    Exit;{raise ESAS4WinCE.Create('Size of tile is 0.');}
  if tilesize > fLimit then
    {����� ������� ������� �� ���������}
    Exit;{raise ESAS4WinCE.Create('Size of tile is too big.');}
  if not z in [1..24] then
    {��� ����� ���� ������ 1..24}
    Exit;{raise ESAS4WinCE.Create('Incorrect zoom.');}
  {��������� ����������� ���������� ����������}
  n := ((1 shl z) shr 1) - 1;
  if (x < 0) or (x > n) then
    {����� � ������������� ������������ �� ���������}
    Exit;{raise ESAS4WinCE.Create('Incorrect x.');}
  if (y < 0) or (y > n) then
    {����� � ������������� ������������ �� ���������}
    Exit;{raise ESAS4WinCE.Create('Incorrect y.');}
  if fDataLen - fDataPrev + int64(tilesize) > fLimit then
  begin
    {���� �� ������ � �����������, �� ������� � ���������� ����� ������}
    if fDataNum >= 99 then
      {������ ��� ������ ������ ��������� ������}
      raise ESAS4WinCEover100dat.Create('Over 100 data files is not allowed.');
    Inc(fDataNum);
    {�������� ������� ������ ���� ��������� � ������ ������ �����}
    fDataPrev := fDataLen;
    if bWriteFD then
    begin
      {���� ����� � �����, �� ��������� �������� ���� ������ � ��������� �����}
      CloseFD();
      AssignFile(FD, Format('%s.d%2.2d', [fFileName, fDataNum]));
      Rewrite(FD, 1);
      bOpenFD := true;
    end;
    if bWriteTileInfo then
    begin
      {����   �����   recovery  info,  ��  �  ������  �����  ������ ����������
      ��������,  �������    ������������    �����  �������� ���������� �������
      recovery info � ������ ������}
      s := copyright;
      Inc(fDataLen, length(s));
      if bWriteFD then
        {���������� ������ ���������� ������ ���� ���������}
        Blockwrite(FD, s[1], length(s));
    end;
  end;
  {�������� ���������� � �����}
  if bWriteTileInfo then
  begin
    n := length(fext);
    {����������� ����� ������ � �����������}
    if n > 255 then
      n := 255;
    if bWriteFD then
    begin
      {���������� ������ ���������� ������ ���� ���������}
      Blockwrite(FD, z, 1);
      Blockwrite(FD, x, 3);
      Blockwrite(FD, y, 3);
      Blockwrite(FD, tilesize, 4);
      Blockwrite(FD, n, 1);
      if n > 0 then
        Blockwrite(FD, fext[1], n);
    end;
    {�������� ������� ������� ������ ������ �� ����� ���������� ����������}
    Inc(fDataLen, 1+3+3+4+1 + n);
  end;
  if bWriteFD then
    {���������� ������ ����� ���������� ������ ���� ���������}
    Blockwrite(FD, ptile^, tilesize);
  if fTilesNum >= Length(Ttiles) then
    {���� ������, ���� ��� ��������� �����}
    SetLength(Ttiles, Length(Ttiles) + TilesSizeInc);
  t.dzxy := (int64(fDataNum) shl 56) + (int64(z) shl 48) + (int64(x) shl 24) + y;
  {�������� � ������� ����� ������}
  t.ptr := fDataLen - fDataPrev;
  t.size := tilesize;
  Ttiles[fTilesNum] := t;
  Inc(fTilesNum);
  Inc(fDataLen, tilesize);
  {���� ����� ���� ��� ����������, ������ �� ������}
  Result := true;
end;


{��������� ���� ���������� � �����}
function TSAS4WinCE.AddExistTile(
  {���������� �����}
  const z, x, y: integer;
  {����� ����� ������ � ������}
  const d: byte;
  {�������� ����� � ����� ������}
  const ptr: integer;
  {������ �����}
  const tilesize: integer
{����� true ���� ���� ���������}
): boolean;
var
  n: integer;
begin
  Result := false;
  if fTilesNum > 130000000 then
    {������� ����� ������ ��� ������� 2��}
    raise ESAS4WinCEbigIndex.Create('Too many tiles!');
  if tilesize = 0 then
    {����� ������� ����� �� ���������}
    Exit;{raise ESAS4WinCE.Create('Size of tile is 0.');}
  if tilesize > fLimit then
    {����� ������� ������� �� ���������}
    Exit;{raise ESAS4WinCE.Create('Size of tile is too big.');}
  if not z in [1..24] then
    {��� ����� ���� ������ 1..24}
    Exit;{raise ESAS4WinCE.Create('Incorrect zoom.');}
  {��������� ����������� ���������� ����������}
  n := ((1 shl z) shr 1) - 1;
  if (x < 0) or (x > n) then
    {����� � ������������� ������������ �� ���������}
    Exit;{raise ESAS4WinCE.Create('Incorrect x.');}
  if (y < 0) or (y > n) then
    {����� � ������������� ������������ �� ���������}
    Exit;{raise ESAS4WinCE.Create('Incorrect y.');}
  if d > 99 then
    {������ ��� ������ ������ ��������� ������}
    raise ESAS4WinCEover100dat.Create('Over 100 data files is not allowed.');

  if d <> fDataNum then begin
    fDataPrev := fDataLen;
    fDataNum := d;
  end;
  if fTilesNum >= Length(Ttiles) then
    {���� ������, ���� ��� ��������� �����}
    SetLength(Ttiles, Length(Ttiles) + TilesSizeInc);
  t.dzxy := (int64(fDataNum) shl 56) + (int64(z) shl 48) + (int64(x) shl 24) + y;
  {�������� � ������� ����� ������}
  t.ptr := ptr;
  t.size := tilesize;
  Ttiles[fTilesNum] := t;
  Inc(fTilesNum);
  fDataLen := fDataPrev + ptr + tilesize;
  {���� ����� ���� ��� ����������, ������ �� ������}
  Result := true;
end;


{������������� �����.
��������� ������� ���������� � 56-� ��������� ��� ���������� �� ����� z,x,y}
procedure TSAS4WinCE.SortAll(const l,r: integer; const m: int64);
var
  i, j: integer;
begin
  if (m = 0) or (l >= r) then Exit;
  i := l; j := r;
  while i <= j do
  begin
    while i <= j do
    begin
      if (Ttiles[i].dzxy and m) > 0 then break; //������� a=1
      Inc(i);
    end;
    while i <= j do
    begin
      if (Ttiles[j].dzxy and m) = 0 then break; //������� b=0
      Dec(j);
    end;
    if i < j then
    begin //������� ��������������, ��������
      t := Ttiles[i];
      Ttiles[i] := Ttiles[j];
      Ttiles[j] := t;
      {��������� ������ ��� ����������, ������� ������}
      Inc(i);
      Dec(j);
{!}   Inc(fSwap);
    end;
  end;
  {������� ����������� ������ ��������� ��� ���������� ������������� ��������
  ��� ������ ����������, ������� � ����� ������������� ������� ������ ������}
  if (m > 1) and (j + 1 < r) then
    {��������� ������ ���������}
    SortAll(j + 1, r, m shr 1);
  if (m > 1) and (l < i - 1) then
    {��������� ����� ���������}
    SortAll(l, i - 1, m shr 1);
end;


{������������ ������ � �������� ��� � ��������� ����}
procedure TSAS4WinCE.CreateINX(
  {���� � ���� (��� ����������) ��� ������ �������}
  const fname: string;
  {��������� �� ����� � ����������� ������������}
  const bAllowDups: boolean
);
var
  i, z, x, y, pz, px, nz, nx, ny: integer;
  s: string;
  p: TTileInfo;
  bWr: boolean;
begin
  bWr := false;
  if length(fname) > 0 then
    {������ ����� ������ � �������� ����}
    bWr := true;
  s := '';
  if bWriteTileInfo then
    s := #13#10 + copyright + #0#0#0#0;
  if bWr then
  begin
    {���� ���� ������� �������, �� ������� ���, ������� ��������� ������� Z � ��������}
    AssignFile(FD, fname + '.inx');
    Rewrite(FD, 1);
    bOpenFI := true;
    for i := 1 to 24 do
    begin
      Tz[i].n := 0;
      Tz[i].ptr := 0;
    end;
    z := 0;
    Blockwrite(FD, z, 4);
    {��������� ������ Z, ������ 24 ������� ��������}
    Blockwrite(FD, Tz, 24 * SizeOf(TTableZX));
    {����� ������� Z ������� ��������, � ����� ������� ��� ����� ����������� �� 4 �����}
    if length(s) > 0 then
      Blockwrite(FD, s[1], length(s) and -4);
  end;
  {������ ������� Z � ���������}
  fIndexLen := 4 + 24 * SizeOf(TTableZX) + (length(s) and -4);
  pz := 0;
  px := -1;
  nz := 0;
  nx := 0;
  ny := 0;
  p.dzxy := -1;
  fMaxTx := 0; fMaxTy := 0; {!}
  for i := 0 to fTilesNum do
  {��������� ��� ���������, ������ ��� ���������� ����������� ������}
  begin
    t.dzxy := -1;
    {��������� ��� ������ �� ������}
    if i < fTilesNum then
      t := Ttiles[i];
    z := ((t.dzxy shr 48) and $FF);
    x := ((t.dzxy shr 24) and $FFFFFF);
    y := ((t.dzxy shr  0) and $FFFFFF);
    if (t.dzxy and mask56) < p.dzxy then
      {������� ������ ����������!}
      raise ESAS4WinCEsortingError.Create('Found sorting error!');
    if (not bAllowDups) and ((t.dzxy and mask56) = p.dzxy) then
      {������� ����� � ����������� ������������ z,x,y
      (��� � �����-�� �� ����������� ������, ����� ��� � ������ �����������)}
      raise ESAS4WinCEdupZXY.Create('Duplicate z,x,y in tiles.');
    p.dzxy := t.dzxy and mask56;
    if (z <> pz) or (x <> px) then
    begin
      {��������� ����� Z ��� X, ���� �������� ������� Y � ������ �����}
      if ny > 0 then
      begin
        {���� Y, �������� ������� Y}
        if nx >= Length(Tx) then
          {������� ����� X, �� ������� � �������, �������� ������ ��������}
          SetLength(Tx, Length(Tx) + 10000);
        Tx[nx].n := px;
        {��������� �� ������ ������� Y}
        Tx[nx].ptr := fIndexLen;
        if bWr then
        begin
          Blockwrite(FD, ny, 4);
          Blockwrite(FD, Ty[0], ny * SizeOf(TTableY));
        end;
{!}     if ny > fMaxTy then fMaxTy := ny;
        Inc(nx);
        {�������� ������ ����� ������� �� ���������� �����}
        Inc(fIndexLen, 4 + ny * SizeOf(TTableY));
      end;
      {����� ����� ������� Y}
      ny := 0;
    end;
    if z <> pz then
    begin {��������� ����� Z, ������ ���� �������� ������� X � ������ �����}
      if nx > 0 then
      begin
        {��������� �������� ����� �.�. Z ���������� � 1}
        Inc(nz);
        Tz[nz].n := pz;
        {��������� �� ������ ������� X}
        Tz[nz].ptr := fIndexLen;
        if bWr then
        begin
          Blockwrite(FD, nx, 4);
          Blockwrite(FD, Tx[0], nx * SizeOf(TTableZX));
        end;
{!}     if nx > fMaxTx then fMaxTx := nx;
        {�������� ������ ����� ������� �� ���������� �����}
        Inc(fIndexLen, 4 + nx * SizeOf(TTableZX));
      end;
      {����� ����� ������� X}
      nx := 0;
    end;
    if ny >= Length(Ty) then
      {������� ����� Y, �� ������� � �������, �������� ������ ��������}
      SetLength(Ty, Length(Ty) + 10000);
    Ty[ny].n := y;
    Ty[ny].d := t.dzxy shr 56;
    Ty[ny].ptr := t.ptr;
    Ty[ny].size := t.size;
    Inc(ny);
    pz := z; px := x;
    if fIndexLen > IndexMaxSize then
      {������� ����� ������ ��� ������� 2��}
      raise ESAS4WinCEbigIndex.Create('Too many tiles!');
  end;
  if bWr then
  begin
    {������� � ����� ����� ������� ���������������� �����������}
    if length(comment)>0 then
    begin
      {�������  ���  ��������  ������  ���  ����������� ��������� ����������� ��
      �������� ������ � \0 � ����� ����� ������ ����� ASCIIZ}
      s := #13#10#13#10 + Comment + #0;
      if fIndexLen + length(s) > IndexMaxSize then
        {������� ����� ������ ��� ������� 2��}
        raise ESAS4WinCEbigIndex.Create('Too many tiles!');
      Blockwrite(FD, s[1], length(s));
      {�������� ����� ����� ������� �� ����� ����������� ������}
      Inc(fIndexLen, length(s));
    end;
    {������� � ������ ����� ������ ������� Z}
    Seek(FD, 0);
    Blockwrite(FD, nz, 4);
    Blockwrite(FD, Tz[1], 24 * SizeOf(TTableZX));
    CloseFile(FD);
    bOpenFI := false;
  end;
  {��������� ������ ��������� ������}
  SetLength(Tx, 0);
  SetLength(Ty, 0);
end;


{�������� ������� �������� ������ � ����}
constructor TSAS4WinCE.Create(
  {��� ������ (��� ����������), ���� ��������������, � ����}
  const fname: string;
  {����������� ���������� ������ ������ ������, ���� < 0, �� ����� 1��}
  const maxsize: integer = -1;
  {����������� � ����� ������ �����������}
  const cmt: string = '';
  {����������    �   �����  ������  recovery info. � �������� � ����� ������ �
  ���� �������.  ��������  ��������  �����  ���������� ������� recovery info �
  ������ ������, ��� ����� ������������ �����}
  const info: boolean = true);
var
  maxlen: integer;
begin
  inherited Create;
  maxlen := maxsize;
  if maxlen >= (int64(2) shl 31) - 2 then
    {����� ������� ����� ��������� �� �����}
    raise ESAS4WinCElimit.Create('Limit file size is too big!');
  {��� ������������� �������� ���������� �������� �� ��������� 1��}
  if maxlen < 0 then maxlen := 1000000000;
  if maxlen < 1000000 then
    {������ ��������� ������� ��������� ����� ������, ��� �� �������� � ��������!}
    raise ESAS4WinCElimit.Create('Limit file size is too small!');
  if length(cmt) > maxlen div 2 then
    {� ��� �� ��� ��������� �������� ����������� � �������� ����� ������!}
    raise ESAS4WinCEbigComment.Create('Comment is too big!');
  bWriteFD := false;
  if length(fname) > 0 then
    {���� �� ������ ��� ����� ��� ������,
    �� �� ������ ����� ������, ���� ���������� ��������}
    bWriteFD := true;
{������ ������������� ���������� ���������� ������}
  fTilesNum := 0; // ��� ������
  fMaxSize := maxlen;
  fComment := cmt;
  bWriteTileInfo := info;
  bOpenFD := false; // ��� ��������� ����� ������
  fDataNum := -1; // ��� ��������� ����� ������
  fDataLen := 0; // ���� �� �������� �� �����
  fDataPrev := -fMaxSize; // ������ ����� ���� ������
  fFileName := fname;
  bOpenFI := false; // ���� ������� �� ������
  SetLength(Ttiles, TilesSizeInc); // �������� ������� ������ �������
  fLimit := fMaxSize - 1*1024; // ����� � 1��
  if length(Comment) > 0 then
    {�������� ������ �� ����� ����������� ���� �� ����}
    Dec(fLimit, length(Comment));
  if bWriteTileInfo then
    {� ����� �� ����� ��������� ���� ������� �������
    � �� ����� ����������, � �� ������ recovery info}
    Dec(fLimit, length(copyright) + 300);
  fSwap := 0; fMaxTx := 0; fMaxTy := 0; {!}
end;


{��������� �������� ����� � ����������� ������}
destructor TSAS4WinCE.Destroy;
begin
  if bOpenFD or bOpenFI then
    {������� �������� ���� ������ ��� �������}
    CloseFile(FD);
  {���������� ��� ������� ��������� ������}
  SetLength(Ttiles, 0);
  SetLength(Tx, 0);
  SetLength(Ty, 0);
  inherited Destroy;
end;


{��������� �������� ������, ������������ ������, �������� ��� � ����}
function TSAS4WinCE.SaveINX(
  {���  �����  (���  ����������)  ���  ������  �������,  �  ����,
  ���� �� �������, ������ ��� �� ������������}
  const fname: string = '';
  {��������� ����� � ����������� ������������}
  const bAllowDups: boolean = false
{����� true ���� ������ ������� �������}
): boolean;
var
  fn: string;
begin
  if bOpenFI then
    {������� �������� ���� �������}
    CloseFile(FD);
  bOpenFI := false;
  if fTilesNum = 0 then
    {� ��� �� ����� �������������� ������� ���������� ������, �� �����}
    raise ESAS4WinCEnoTiles.Create('Nothing to export.');
  {�������������� ������� ���� ������}
  CloseFD();
  fSwap := 0;
  {������������� �����, ��������� ������� ����������
  � 56-� ��������� ��� ���������� �� ����� z,x,y}
  SortAll(0, fTilesNum-1, mask56 xor (mask56 shr 1));
  fn := fname;
  if length(fn) = 0 then
    {���� �� ������ ��� ����� �������, �� ���������� ��� ����� ������}
    fn := fFileName;
  {�������� ���� �������}
  CreateINX(fn, bAllowDups);
  {���� ����� ���� ��� ����������, ������ �� ������}
  Result := true;
end;


end.

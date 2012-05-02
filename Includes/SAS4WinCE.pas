(****************************************************************************************************************************************************

������� ������������������ �������: .Create, ��� ������� ����� .Add, .SaveINX ��� ������������ � ������ �������, Destroy.
��� ������� ����� ��������� ������ �� ���� .Add � ������ .SaveINX ��� ������������ ���������� ��������������� �������� � ������ ������� ������. �� ���� ����� �����, �� �����.
����� ����� �������� .SaveINX ����� ��� ��� ���������� ����������� ������� � ������ �����.
����� �������� .Create � ������ ������ �����. ��� ���� ����� ������ ����������� �� �����, �� �� ������� ��������� ����� ��� ������, � ������ ����� ����� �������� ����������.
����� �������� � SaveINX � ������ ������ �����. ����� ��� ����� ��� �������� �� .Create, ��� ������ �� ����� ������������ (���� � ��� �����).
����� ������� ���� .Add, ����� .SaveINX(''), � ����� ��������� ������������ ������ � ������ ��� ������ ������. ��� ����� ���� �������� ����� �� ��������� ���������� ������� ������ � ������.
*****************************************************************************************************************************************************
� ����� .d?? ����� ����������� ��������� 12..15+ �������� ��������� ��� ������� �����:
        z:byte;         //���� ����
        x:int24;        //���� ��� �����
        y:int24;        //���� ��� �����
        len:int32;      //����� �����, 4 �����
        ext_len:byte;   //����� ���������� ����� � ������
        ext:char[];     //���������� �����
������ ��������� ����� ������������� ��� �������������� ����� ������� �� ����� ������ ��� ��� �������� ���������� ������ ������.
� ��������� ������� ��� �� ���������. SAS4WinCE � ����� �� ����������.
�� ����� ����������� � ������� ��� ����� ���������� ���� � ������ �������.
*****************************************************************************************************************************************************
������������ {!} �������� ���������� �����, �� ����� ��������� �������.
*****************************************************************************************************************************************************
����            ������  �����           ���������
*****************************************************************************************************************************************************
28.04.2012      v0.4    Dima2000        1.      ������ ������� ������� � ��������� unit.
28.04.2012      v0.5    Dima2000        1. Add: ������ �������� ���������� ������� �������� � ������������ ������������������� ������ ��������.
                                        2. Fix: �� ��������� �������� �� ������������� ������ ��������� ������ (Tx � Ty).
                                        3. Add: �������� �������� �������� ������� ����� �����.
28.04.2012      v0.6    Dima2000        1. Add: ��������� ������ ������������ ������.
                                        2. Fix: ������ ���������� ���������� ����� �� 4-� ������.
28.04.2012      v0.7    Dima2000        1. Add: ��������� ����������� ������ ��� ����� ������� ��������� �� ����� ������.
                                        2. Add: �������������� ����������� ����������� �� ������ �� ���� ����� ������ ��� � ������� ���� (��������� ������� ����� �����). ������� ��� ���� ��������� ���������.
28.04.2012      v8      Dima2000        1. Add: ��������� ��������� �������� ��������.
                                        2. Add: ��������� ��������� � ������� ����������� � �������� ��������.
                                        3. Fix: ���������� ���������� ������ ������� Z. �� ����� �������� ������ �� ��� 24 ��������.
                                        4.      ������� ��������� ������ �� ������.
30.04.2012      v9      Dima2000        1.      ������ ��������� � �����.
                                        2. Add: ������� ��������� ������.
                                        3. Add: ����������� ���������� ������������ ������ ����������� � ����� ������� � � ������ ������.
01.05.2012      v10     Dima2000        1.      ����������� ������ ��� ���������� � �����. ��������� �����. � ������� �� � ������ ������, � ������ �������������.
                                        2.      ����� �� ����� �������, ����������, ���� �������� ������. �������� ����� �������� �� �������������.
01.05.2012      v11     Dima2000        1.      ����������� ������ ��� ���������� � �����. ������ ��������.
                                        2.      ������� ���������� � ���� ������.
01.05.2012      v12     Dima2000        1. Fix  ������� ������� ������ �� ��������� ����������.
01.05.2012      v13     Dima2000        1. Fix  �������� ������ ������ ������� ������ ������ � 1�� �� 1��.
                                        2. Fix  ��������� ���� ����� �� �� TMemoryStream.
                                        3. Add  ��������� ����������� ��������� ������������ ��������� � .SaveINX ���������� ������ (�� ��������� �������� ����������).
                                        4. Fix  ��������� const ��� ���������� �������.
01.05.2012      v14     Dima2000        1. Add  ������� ���� ����� ��� ����������.
01.05.2012      v15     Dima2000        1.      ����� ��������� �������� ������, ��������� ������� ����������, ����������� ���������� false � ����� ���������� �������, ������� ���� �� ����������.
                                        2. Add  ��� ��������� ������ ������ ��� ���������� ��������� �������� ������ ����������.
******************************************************************************************************************************************************
ToDo:
+1. ������ ����� ������ �������� ����������.
+2. ������ string ��������� ���� � TMemoryStream.
-3. �������� ����� �� (� ���) ������ ���������� ����� �� interface, ���� ��� ����� ���� ��� ������ ����� ������ � ��. ��������� �������� � ���� 5-� ������, ��� �� ���������, ����� 7-�.
-4. ������ ��������� ������, ������ � ����� � ������ �������� ��������� ��� ������ - ���������� � ��� ����������, �� ������������, �� � ���. ����� �����-������ �������, ����� ����.
+5. ������� ���� ���� ����� ������ �������. ��� � �����?
+6. �������� � �������� ������ �� ����������� ���������� � ������������ ��� � ���� ������.
7. ��������� ����� �� ����������� ������ � ����� (� ������� ������� 1��). ��� ����������� �������� �� �������.
+8. �������� �������� ���������� ������������ ��������� ������ � .SaveINX(). �������� ���������� ������, ����� �� ���������� ����������.
*****************************************************************************************************************************************************)
unit SAS4WinCE;

interface

uses
        SysUtils, Classes;

type
        ESAS4WinCE = class(Exception); //������� ����� ����������
        ESAS4WinCElimit = class(ESAS4WinCE); //������� ������� ��� ��������� ����� ������� ������ (� .Create)
        ESAS4WinCEbigComment = class(ESAS4WinCE); //������� ������� ����������� (��� ���������� ������ ������� ������) (� .Create)
        ESAS4WinCEover100dat = class(ESAS4WinCE); //����� ��� ������ ������ ����������� ������ (� .Add)
        ESAS4WinCEsortingError = class(ESAS4WinCE); //���������� ������ ����������, ��������� ������ ������������ (� .SaveINX)
        ESAS4WinCEnoTiles = class(ESAS4WinCE); //� ��� �� ����� �������������� ������� ���������� ������, �� ����� (� .SaveINX)
        ESAS4WinCEdupZXY = class(ESAS4WinCE); //������� ����� � ����������� ������������ z,x,y (����� �����-�� ��� � �� ������, ����� ��� � ������ �����������, �� ����� v_max ����� ����������), ��������� ������������ ���������� ��� ������ (� .SaveINX)

        TTileInfo = packed record
                dzxy:int64; //d<<56+z<<48+x<<24+y
                ptr:integer; //�������� � ����� ������
                size:integer; //����� �����
        end;
        TTableZX = packed record
                n:integer; //��������
                ptr:integer; //�������� ������� � ����� �������
        end;
        TTableY = packed record
                n:integer; //��������
                d:integer; //����� ����� ������
                ptr:integer; //�������� ����� � ����� ������
                size:integer; //����� ����� �����
        end;

        TSAS4WinCE = class
        private
                fTilesNum:integer;
                fDataNum:integer; //���������� ��������������� ������ ������
                fDataPrev:int64; //������ ���� ���������� ������ ������
                fDataLen:int64; //����� ������ ���� ������ ������ ������� � ������� �����������
                fMaxSize:integer; //����������� ���������� ������ ������ ������
                fIndexLen:integer; //������ ����� ������� (����������� ����� ���������� ��������)
                fFileName:string; //��� (��� ����������!) (����� � ����) ����������� ������
                fLimit:integer; //����������� ���������� ������ ������ ������ (� ������ ������ � �����)
                FD:File;
                fComment:string; //����������� � ������ �����������
                bWriteTileInfo:boolean; //���������� �� � ����� ������ �������������� ���������� �� ����� (12-15+ ������) � �������� � ����� ������ � ���� �������
                bWriteFD:boolean; //���� �� ������ ��� ����� ������
                bOpenFD:boolean; //������ �� ���� ������
                bOpenFI:boolean; //������ �� ���� �������
                Ttiles:array of TTileInfo; //������ ���� � ������
                t:TTileInfo; //��� �������� ��� �������� � ��������� �������
                Tz:array[1..24] of TTableZX; //������� Z
                Tx:array of TTableZX; //������� X[z]
                Ty:array of TTableY; //������� Y[z,x]
{!}             fSwap:int64; //������� ����� ������� ��������� ����������
{!}             fMaxTx,fMaxTy:integer; //������������ ������ ������ X � Y
                procedure CreateINX(const fname:string; const bAllowDups:boolean); //�������� ������ � ���� fname
                procedure SortAll(const l,r:integer; const m:int64); //������������� �����, ��������� ������� ���������� � 56-� ��������� ��� ���������� �� ����� z,x,y
                procedure CloseFD(); //������� �������� ���� ������, �������������� ������� ���� �����������
        public
                constructor Create(const fname:string; const maxsize:integer=-1; const cmt:string=''; const info:boolean=true); //�������� ������� �������� ������ � ���� fname (��� ����������!); maxsize - ����������� ���������� ������ ������ ������ (���� <0, �� ����� �������� �� ���������); cmt - ���������� ����������� � ����� ������ �����������; info - ���������� �� � ����� ������ �������������� ���������� �� ����� (12-15+ ������) � �������� � ����� ������ � ���� �������. �������� �������� ����� ���������� ������� �������������� ���� � ������ ������!
                destructor Destroy(); override; //��������� �������� ����� � ����������� ������
                function Add(const z,x,y:integer; const ptile:pointer; const tilesize: integer; const fext:string=''):boolean; //��������� ����: z,x,y ��� ����������; ftile ����������; fext ���������� ��������� ����� � ������. ����� true ���� ���� ���������.
                function SaveINX(const fname:string=''; const bAllowDups:boolean=false):boolean; //��������� �������� ������, ������������ ������, �������� ��� � ���� fname (��� ����������!) (���� �� ������, �� ������ ��� ����� ������); ���������� ���������� � ����������� ������������. ����� true ���� �� ������ ������.
                class function GetVersion():string; //������ ������ � ����������� � ������.
                class function GetCopyright():string; //������ ������ � ����������� � ������.
                property FileName:string        read fFileName; //���� � ��� (��� ����������) ����������� ������ ������ (���������� .Create)
                property TilesNum:integer       read fTilesNum; //����� ���������� �������� ������ (�������������� ������� .Add)
                property DataNum:integer        read fDataNum; //����� �������� ����� ������ (�������������� ������� .Add)
                property DataLen:int64          read fDataLen; //����� ������ ���� ������ ������ (�� ������ .SaveINX - ��� ������ �����������, � ��������� ����� ������) (�������������� �������� .Add � .SaveINX)
                property IndexLen:integer       read fIndexLen; //������ ����� ������� (����������� ������� .SaveINX ����� ���������� ��������)
                property Comment:string         read fComment; //����������� � ������ ����������� (���������� .Create)
                property WriteTileInfo:boolean  read bWriteTileInfo; //���������� �� � ����� ������ �������������� ���������� �� ����� (12-15+ ������) � �������� � ����� ������ � ���� ������� (���������� .Create)
                property MaxFileSize:integer    read fMaxSize; //����������� ���������� ������ ������ ������ (���������� .Create)
{!}             property Swaps:int64            read fSwap; //������� ����� ������� ��������� ����������
{!}             property MaxTx:integer          read fMaxTx; //������������ ������ ������ X
{!}             property MaxTy:integer          read fMaxTy; //������������ ������ ������ Y
        end;


implementation

const
        version='v15';
        copyright=#13#10'*****   Export from SAS.Planeta to SAS4WinCE  '+version+'   *****'#13#10#13#10#0;
        TilesSizeInc=100000; //�� ������� ����������� ������ ������ ��� ������������ (� ������� �� 16�)
        mask56=$FFFFFFFFFFFFFF; //����� ����� ��� ����������


class function TSAS4WinCE.GetVersion():string;
begin
        Result:=version;
end;

class function TSAS4WinCE.GetCopyright():string;
begin
        Result:=copyright;
end;


procedure TSAS4WinCE.CloseFD(); //������� �������� ���� ������, �������������� ������� ���� �����������
var     s:string;
begin
        if not bOpenFD then Exit; //��� ��������� ����� ������
        if length(Comment)>0 then begin
                s:=#13#10#13#10+Comment+#0; //��� �������� ������ ��� ����������� ��������� ����������� �� �������� ������ � \0 � ����� ���� ������ ����� ASCIIZ
                Blockwrite(FD,s[1],length(s)); //������� � ����� ����� ��� �������� ������ � ���������������� ������
                Inc(fDataLen,length(s)); //�������� ����� ����� ���� ������ ������ �� ����� ����������� ������
        end;
        CloseFile(FD);
        bOpenFD:=false;
end;


function TSAS4WinCE.Add(const z,x,y:integer; const ptile:pointer; const tilesize: integer; const fext:string=''):boolean; //��������� ����: z,x,y ��� ����������; ftile ����������; fext ���������� ��������� ����� � ������. ����� true ���� ���� ���������.
var     n,l:integer;
        s:string;
begin
        Result:=false; l:=tilesize;
        if l=0 then Exit;{raise ESAS4WinCE.Create('Size of tile is 0.');} //����� ������� ����� �� ���������
        if l>fLimit then Exit;{raise ESAS4WinCE.Create('Size of tile is too big.');} //����� ������� ������� �� ���������
        if not z in [1..24] then Exit;{raise ESAS4WinCE.Create('Incorrect zoom.');} //��� ����� ���� ������ 1..24
        n:=((1 shl z) shr 1)-1; //����������� ���������� ����������
        if (x<0) or (x>n) then Exit;{raise ESAS4WinCE.Create('Incorrect x.');} //����� � ������������� ������������ �� ���������
        if (y<0) or (y>n) then Exit;{raise ESAS4WinCE.Create('Incorrect y.');} //����� � ������������� ������������ �� ���������
        if fDataLen-fDataPrev+int64(l)>fLimit then begin //���� �� ������ � �����������, �� ������� � ���������� ����� ������
                if fDataNum>=99 then raise ESAS4WinCEover100dat.Create('Over 100 data files is not allowed.'); //������ ��� ������ ������ ��������� ������
                Inc(fDataNum);
                fDataPrev:=fDataLen; //���� ���� �������� ���� ������, �� �������� ������� ���� ��������� ������ � ������ ������
                if bWriteFD then begin
                        CloseFD();
                        AssignFile(FD,Format('%s.d%2.2d',[fFileName,fDataNum])); Rewrite(FD,1); bOpenFD:=true;
                end;
                if bWriteTileInfo then begin
                        s:=copyright;
                        Inc(fDataLen,length(s));
                        if bWriteFD then Blockwrite(FD,s[1],length(s));
                end;
        end;
        if bWriteTileInfo then begin //��������� ���������� � �����
                n:=length(fext); if n>255 then n:=255;
                if bWriteFD then begin
                        Blockwrite(FD,z,1);
                        Blockwrite(FD,x,3);
                        Blockwrite(FD,y,3);
                        Blockwrite(FD,l,4);
                        Blockwrite(FD,n,1);
                        if n>0 then Blockwrite(FD,fext[1],n);
                end;
                Inc(fDataLen,1+3+3+4+1+n);
        end;
        if bWriteFD then Blockwrite(FD,ptile^,l);
        if fTilesNum>High(Ttiles) then SetLength(Ttiles,High(Ttiles)+1+TilesSizeInc); //���� ������, ���� ��� ��������� �����
        t.dzxy:=(int64(fDataNum) shl 56)+(int64(z) shl 48)+(int64(x) shl 24)+y;
        t.ptr:=fDataLen-fDataPrev;
        t.size:=l;
        Ttiles[fTilesNum]:=t;
        Inc(fTilesNum);
        Inc(fDataLen,l);
        Result:=true;
end;


procedure TSAS4WinCE.SortAll(const l,r:integer; const m:int64); //������������� �����, ��������� ������� ���������� � 56-� ��������� ��� ���������� �� ����� z,x,y
var     i,j:integer;
begin
        if (m=0) or (l>=r) then Exit;
        i:=l; j:=r;
        while i<=j do begin
                while i<=j do begin
                        if (Ttiles[i].dzxy and m)>0 then break; //������� a=1
                        Inc(i);
                end;
                while i<=j do begin
                        if (Ttiles[j].dzxy and m)=0 then break; //������� b=0
                        Dec(j);
                end;
                if i<j then begin //������� ��������������, ��������
                        t:=Ttiles[i];
                        Ttiles[i]:=Ttiles[j];
                        Ttiles[j]:=t;
                        Inc(i); Dec(j); //��������� ������ ��� ����������, ������� ������
{!}                     Inc(fSwap);
                end;
        end;
        if (m>1) and (j+1<r) then SortAll(j+1,r,m shr 1); //��������� ������ ���������
        if (m>1) and (l<i-1) then SortAll(l,i-1,m shr 1); //��������� ����� ���������
end;


procedure TSAS4WinCE.CreateINX(const fname:string; const bAllowDups:boolean); //�������� ������ � ���� fname
var     i,z,x,y,pz,px,nz,nx,ny:integer;
        s:string;
        p:TTileInfo;
        bWr:boolean;
begin
        bWr:=false; if length(fname)>0 then bWr:=true; //������ ����� ������ � �������� ����
        s:=''; if bWriteTileInfo then s:=#13#10+copyright+#0#0#0#0;
        if bWr then begin
                AssignFile(FD,fname+'.inx'); Rewrite(FD,1); bOpenFI:=true;
                for i:=1 to 24 do begin Tz[i].n:=0; Tz[i].ptr:=0; end;
                z:=0; Blockwrite(FD,z,4); Blockwrite(FD,Tz,24*SizeOf(TTableZX)); //��������� ������ Z, ������ 24 ������� ��������
                if length(s)>0 then Blockwrite(FD,s[1],length(s) and -4); //����� ������� Z ������� ��������, � ����� ������� ����� ��������� ����������� �� 4 �����
        end;
        fIndexLen:=4+24*SizeOf(TTableZX)+(length(s) and -4); //������ ������� Z � ���������
        pz:=0; px:=-1; nz:=0; nx:=0; ny:=0; p.dzxy:=-1;
{!}     fMaxTx:=0; fMaxTy:=0;
        for i:=0 to fTilesNum do begin //��������� ��� ���������, ������ ��� ���������� ����������� ������
                t.dzxy:=-1; if i<fTilesNum then t:=Ttiles[i]; //��������� ��� ���� �� ������
                z:=((t.dzxy shr 48) and $FF);
                x:=((t.dzxy shr 24) and $FFFFFF);
                y:=((t.dzxy shr  0) and $FFFFFF);
                if (t.dzxy and mask56)<p.dzxy then raise ESAS4WinCEsortingError.Create('Found sorting error!'); //������� ������ ����������!
                if (not bAllowDups) and ((t.dzxy and mask56)=p.dzxy) then raise ESAS4WinCEdupZXY.Create('Duplicate z,x,y in tiles.'); //������� ����� � ����������� ������������ z,x,y (��� � �����-�� �� ����������� ������, ����� ��� � ������ �����������)
                p.dzxy:=t.dzxy and mask56;
                if (z<>pz) or (x<>px) then begin //��������� ����� Z ��� X, ���� ������ ����� ������� Y
                        if ny>0 then begin //���� Y, �������� ������� Y
                                if nx>High(Tx) then SetLength(Tx,High(Tx)+1+10000); //������� ����� X, �� ������� � �������, �������� ������ ��������
                                Tx[nx].n:=px; Tx[nx].ptr:=fIndexLen; //��������� �� ������ ������� Y
                                if bWr then begin
                                        Blockwrite(FD,ny,4); Blockwrite(FD,Ty[0],ny*SizeOf(TTableY));
                                end;
{!}                             if ny>fMaxTy then fMaxTy:=ny;
                                Inc(nx); Inc(fIndexLen,4+ny*SizeOf(TTableY));
                        end;
                        ny:=0; //������ ����� ������� Y
                end;
                if z<>pz then begin //��������� ����� Z, ������ ���� �������� ������� X � ������ �����
                        if nx>0 then begin
                                Inc(nz);
                                Tz[nz].n:=pz; Tz[nz].ptr:=fIndexLen; //��������� �� ������ ������� X
                                if bWr then begin
                                        Blockwrite(FD,nx,4); Blockwrite(FD,Tx[0],nx*SizeOf(TTableZX));
                                end;
{!}                             if nx>fMaxTx then fMaxTx:=nx;
                                Inc(fIndexLen,4+nx*SizeOf(TTableZX));
                        end;
                        nx:=0; //������ ����� ������� X
                end;
                if ny>High(Ty) then SetLength(Ty,High(Ty)+1+10000); //������� ����� Y, �� ������� � �������, �������� ������ ��������
                Ty[ny].n:=y;
                Ty[ny].d:=t.dzxy shr 56;
                Ty[ny].ptr:=t.ptr;
                Ty[ny].size:=t.size;
                Inc(ny);
                pz:=z; px:=x;
        end;
        if bWr then begin
                if length(comment)>0 then begin //������� � ����� ����� ������� ���������������� �����������
                        s:=#13#10#13#10+Comment+#0; //��� �������� ������ ��� ����������� ��������� ����������� �� �������� ������ � \0 � ����� ���� ������ ����� ASCIIZ
                        Blockwrite(FD,s[1],length(s)); //������� � ����� ����� ��� �������� ������ � ���������������� ������
                        Inc(fIndexLen,length(s)); //�������� ����� ����� ������� �� ����� ����������� ������
                end;
                Seek(FD,0);
                Blockwrite(FD,nz,4);
                Blockwrite(FD,Tz[1],24*SizeOf(TTableZX));
                CloseFile(FD);
                bOpenFI:=false;
        end;
        SetLength(Tx,0); SetLength(Ty,0); //���������� ������
end;


constructor TSAS4WinCE.Create(const fname:string; const maxsize:integer=-1; const cmt:string=''; const info:boolean=true); //�������� ������� �������� ������ � ���� fname (��� ����������!); maxsize - ����������� ���������� ������ ������ ������ (���� <0, �� ����� �������� �� ���������); cmt - ���������� ����������� � ����� ������ �����������; info - ���������� �� � ����� ������ �������������� ���������� �� ����� (12-15+ ������) � �������� � ����� ������ � ���� �������. �������� �������� ����� ���������� ������� �������������� ���� � ������ ������!
var     maxlen:integer;
begin
        inherited Create;
        maxlen:=maxsize;
        if maxlen>=(int64(2) shl 31)-2 then raise ESAS4WinCElimit.Create('Limit file size is too big!'); //����� ������� ����� ��������� �� �����
        if maxlen<0 then maxlen:=1000000000;
        if maxlen<1000000 then raise ESAS4WinCElimit.Create('Limit file size is too small!'); //������ ��������� ������� ��������� ����� ������, ��� �� �������� � ��������!
        if length(cmt)>maxlen div 2 then raise ESAS4WinCEbigComment.Create('Comment is too big!'); //� ��� �� ��� ��������� ����������� � �������� ����� ������!
        bWriteFD:=false; if length(fname)>0 then bWriteFD:=true; //���� �� ������ ��� ����� ��� ������, �� �� ������ ����� ������, ���� ���������� ��������
        fTilesNum:=0; //��� ������
        fMaxSize:=maxlen;
        fComment:=cmt;
        bWriteTileInfo:=info;
        bOpenFD:=false; //��� ��������� ����� ������
        fDataNum:=-1; //��� ��������� ����� ������
        fDataLen:=0; //���� �� �������� �� �����
        fDataPrev:=-fMaxSize; //������ ����� ���� ������
        fFileName:=fname;
        bOpenFI:=false; //���� ������� �� ������
        SetLength(Ttiles,TilesSizeInc); //�������� ������� ������ �������
        fLimit:=fMaxSize-10; //�����
        if length(Comment)>0 then Dec(fLimit,length(Comment)); //�������� ������ �� ����� ����������� ���� �� ����
        if bWriteTileInfo then Dec(fLimit,length(copyright)+300); //� �� ����� ��������� ���� ������� ������� � �������� ���������� � recovery �����
        fSwap:=0; fMaxTx:=0; fMaxTy:=0;
end;


destructor TSAS4WinCE.Destroy(); //��������� �������� ����� � ����������� ������
begin
        CloseFD();
        SetLength(Ttiles,0); //���������� ������
        inherited Destroy;
end;


function TSAS4WinCE.SaveINX(const fname:string=''; const bAllowDups:boolean=false):boolean; //��������� �������� ������, ������������ ������, �������� ��� � ���� fname (��� ����������!) (���� �� ������, �� ������ ��� ����� ������); ���������� ���������� � ����������� ������������. ����� true ���� �� ������ ������.
var     fn:string;
begin
        if bOpenFI then CloseFile(FD); //������� �������� ���� �������
        bOpenFI:=false;
        if fTilesNum=0 then raise ESAS4WinCEnoTiles.Create('Nothing to export.'); //� ��� �� ����� �������������� ������� ���������� ������, �� �����
        CloseFD();
        fSwap:=0;
        SortAll(0,fTilesNum-1,mask56 xor (mask56 shr 1)); //������������� �����, ��������� ������� ���������� � 56-� ��������� ��� ���������� �� ����� z,x,y
        fn:=fname; if length(fn)=0 then fn:=fFileName; //���� �� ������ ��� ����� �������, �� ���������� ��� ����� ������
        CreateINX(fn,bAllowDups); //������� ���� �������
        Result:=true;
end;


end.

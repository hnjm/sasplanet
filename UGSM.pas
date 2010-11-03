unit UGSM;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StrUtils,
  SwinHttp,
  CPDrv,
  t_GeoTypes,
  u_GlobalState,
  UResStrings;

type
  TToPos = procedure (LL:TDoublePoint;zoom_:byte;draw:boolean) of object;
  TPosFromGPS = class
    FToPos:TToPos;
    CommPortDriver:TCommPortDriver;
    LAC:string;
    CellID:string;
    CC:string;
    NC:string;
    BaundRate:integer;
    Port:string;
    function GetPos:boolean;
    procedure CommPortDriver1ReceiveData(Sender: TObject; DataPtr: Pointer; DataSize: Cardinal);
    function GetCoordFromGoogle(var LL:TDoublePoint): boolean;
    property OnToPos:TToPos read FToPos write FToPos;
  end;

implementation

function TPosFromGPS.GetCoordFromGoogle(var LL:TDoublePoint): boolean;
var
  strA, strB, strC, strAll: string;
  sResult: string;
  ms: TMemoryStream;
  iLat, iLon: Integer;
  i: Integer;
  b: byte;
  sTmp, sTmp2: string;
  iCntr: Integer;
  SwinHttp: TSwinHttp;
  post:string;
begin
  Result := true;
  NC:='0'+NC;
  CC:='0'+CC;
  strA := '000E00000000000000000000000000001B0000000000000000000000030000';
  strB := '0000' + CellID + '0000' + LAC;
  strC := '000000' + IntToHex(strtoint(NC), 2) + '000000' + IntToHex(strtoint(CC), 2);
  strAll := strA + strB + strC + 'FFFFFFFF00000000';
  SwinHttp:=TSwinHttp.Create(nil);
  SwinHttp.InThread:=false;
  SwinHttp.Request.Headers.Clear;
  SwinHttp.Request.Headers.Add('Content-Type: application/x-www-form-urlencoded');
  SwinHttp.Request.Headers.Add('Content-Length: '+inttostr(Length(strAll) div 2));
  SwinHttp.Request.Headers.Add('Accept: text/html, */*');

  ms := TMemoryStream.Create;
  try
    iCntr := 1; 
    for i := 1 to (Length(strAll) div 2) do begin
      b := StrToInt('0x' + Copy(strAll, iCntr, 2));
      iCntr := iCntr + 2;
      ms.Write(b, 1);
    end;
    ms.Seek(0, soFromBeginning);
    try
      ms.Position:=0;
      setLength(post,ms.Size);
      ms.Read(post[1],ms.Size);
      SwinHttp.Post('http://www.google.com/glm/mmap',post);
      SetLength(sResult,SwinHttp.Response.Content.Size);
      SwinHttp.Response.Content.ReadBuffer(sResult[1],SwinHttp.Response.Content.Size);
      if (SwinHttp.Error=0) then begin
        if (Length(sResult) > 14) then begin
          sTmp := '0x';
          for i := 1 to 5 do begin
            sTmp2 := Copy(sResult, i + 6, 1);
            sTmp := sTmp + IntToHex(Ord(sTmp2[1]), 2);
          end;
          iLat := StrToInt(sTmp);
          sTmp := '0x';
          for i := 1 to 4 do begin
            sTmp2 := Copy(sResult, i + 11, 1);
            sTmp := sTmp + IntToHex(Ord(sTmp2[1]), 2);
          end;
          iLon := StrToInt(sTmp);
          LL.y := iLat/1000000;
          LL.x := iLon/1000000;
        end else begin
          result:=false;
          ShowMessage(SAS_ERR_UnablePposition);
        end;
      end
      else begin
        result:=false;
        ShowMessage(SAS_ERR_Communication);
      end;
    except
      result:=false;
      ShowMessage(SAS_ERR_UnablePposition);
    end;
  finally
    SwinHttp.Free;
    ms.Free;
  end;
end;

procedure TPosFromGPS.CommPortDriver1ReceiveData(Sender: TObject; DataPtr: Pointer; DataSize: Cardinal);
 function DelKov(s:string):string;
 var i:integer;
 begin
   i:=pos('"',s);
   while i>0 do begin
    Delete(s,i,1);
    i:=pos('"',s);
   end;
   result:=s;
 end;
 function addT4(s:string):string;
 begin
  while length(s)<4 do begin
    s:='0'+s;
  end;
  result:=s;
 end;
var s:string;
    pos,pose:integer;
    LL:TDoublePoint;
begin
 setlength(s,DataSize);
 if DataSize<10 then exit;
 CopyMemory(@s[1],DataPtr,DataSize);
 pos:=posEx('+CREG:',s);
 if pos>0 then begin
   pos:=posEx(',',s,pos+1);
   pos:=posEx(',',s,pos+1);
   pose:=posEx(',',s,pos+1);
   if pos>0 then begin
     LAC:=addT4(DelKov(copy(s,pos+1,pose-(pos+1))));
   end;
   pos:=posEx(#$D,s,pose+1);
   if pos>0 then begin
     CellID:=addT4(DelKov(copy(s,pose+1,pos-(pose+1))));
   end;
 end else begin
   exit;
 end;
 pos:=posEx('+COPS:',s);
 if pos>0 then begin
   pos:=posEx(',"',s,pos);
   if pos>0 then begin
     NC:=DelKov(copy(s,pos+2,3));
     CC:=DelKov(copy(s,pos+5,2));
   end;
 end else begin
   exit;
 end;
 CommPortDriver.SendString('AT+CREG=1'+#13);
 CommPortDriver.Disconnect;
 if GetCoordFromGoogle(LL) then begin
    OnToPos(LL, GState.ViewState.GetCurrentZoom, true);
 end;
end;

function GetWord(Str, Smb: string; WordNmbr: Byte): string;
var SWord: string;
    StrLen, N: Byte;
begin
  StrLen := SizeOf(Str);
  N := 1;
  while ((WordNmbr >= N) and (StrLen <> 0)) do
  begin
    StrLen := System.Pos(Smb, str);
    if StrLen <> 0 then
    begin
      SWord := Copy(Str, 1, StrLen - 1);
      Delete(Str, 1, StrLen);
      Inc(N);
    end
    else SWord := Str;
  end;
  if WordNmbr <= N then Result := SWord
                   else Result := '';
end;


function TPosFromGPS.GetPos:boolean;
var paramss:string;
    LL:TDoublePoint;
begin
 if GState.GSMpar.auto then begin
   CommPortDriver:=TCommPortDriver.Create(nil);
   CommPortDriver.PortName:=Port;
   CommPortDriver.BaudRateValue:=BaundRate;
   CommPortDriver.OnReceiveData:=CommPortDriver1ReceiveData;
   CommPortDriver.Connect;
   if CommPortDriver.Connected then begin
     if (CommPortDriver.SendString('AT+CREG=2'+#13))and
        (CommPortDriver.SendString('AT+COPS=0,2'+#13)) then begin
       sleep(GState.GSMpar.WaitingAnswer);
       CommPortDriver.SendString('AT+CREG?'+#13);
       CommPortDriver.SendString('AT+COPS?'+#13);
       Result:=true;
     end;
   end else begin
     ShowMessage(SAS_ERR_PortOpen);
     Result:=false;
   end;
 end else begin
   if InputQuery(SAS_STR_InputLacitpCaption,SAS_STR_InputLacitp,paramss) then begin
     try
     CC:=GetWord(paramss,',',1);
     NC:=GetWord(paramss,',',2);
     LAC:= IntToHex(strtoint(GetWord(paramss,',',3)),4);
     CellID:= IntToHex(strtoint(GetWord(paramss,',',4)),4);
     if GetCoordFromGoogle(LL) then begin
        OnToPos(LL,GState.ViewState.GetCurrentZoom,true);
        Result:=true;
     end else begin
        Result:=false;
     end;
     except
       ShowMessage(SAS_ERR_ParamsInput);
       Result:=false;
     end;
   end;
 end;
end;

end.

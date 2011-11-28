{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
{* This program is free software: you can redistribute it and/or modify       *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* This program is distributed in the hope that it will be useful,            *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with this program.  If not, see <http://www.gnu.org/licenses/>.      *}
{*                                                                            *}
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_InterfacedThread;

interface

uses
  Classes,
  SyncObjs,
  i_Thread;

type
  TInterfacedThread = class(TInterfacedObject, IThread)
  private
    FThread: TThread;
    FCS: TCriticalSection;
    FTerminated: Boolean;
    FStarted: Boolean;
    FFinished: Boolean;
    procedure OnTerminate(Sender: TObject);
  protected
    procedure Execute; virtual; abstract;
    property Terminated: Boolean read FTerminated;
  protected
    procedure Start; virtual;
    procedure Terminate; virtual;
  public
    constructor Create(APriority: TThreadPriority);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

type
  TThread4InterfacedThread = class(TThread)
  private
    FRef: IInterface;
    FExec: TThreadMethod;
  protected
    procedure DoTerminate; override;
    procedure Execute; override;
  public
    constructor Create(APriority: TThreadPriority; AExec: TThreadMethod);
    procedure Start(ARef: IInterface);
  end;

{ TInterfacedThread }

constructor TInterfacedThread.Create(APriority: TThreadPriority);
begin
  inherited Create;
  FThread := TThread4InterfacedThread.Create(APriority, Self.Execute);
  FThread.OnTerminate := Self.OnTerminate;
  FTerminated := False;
  FStarted := False;
  FFinished := False;
  FCS := TCriticalSection.Create;
end;

destructor TInterfacedThread.Destroy;
var
  VNeedResume: Boolean;
begin
  VNeedResume := False;
  FCS.Acquire;
  try
    if not FStarted then begin
      FThread.OnTerminate := nil;
      VNeedResume := True;
    end;
  finally
    FCS.Release;
  end;
  FreeAndNil(FCS);
  inherited;
end;

procedure TInterfacedThread.OnTerminate(Sender: TObject);
begin
  FCS.Acquire;
  try
    FFinished := True
  finally
    FCS.Release;
  end;
end;

procedure TInterfacedThread.Start;
begin
  FCS.Acquire;
  try
    if not FStarted then begin
      if not FTerminated then begin
        FStarted := True;
        TThread4InterfacedThread(FThread).Start(Self);
      end;
    end;
  finally
    FCS.Release;
  end;
end;

procedure TInterfacedThread.Terminate;
begin
  FCS.Acquire;
  try
    if not FTerminated then begin
      FTerminated := True;
      if not FFinished then begin
        FThread.Terminate;
      end;
    end;
  finally
    FCS.Release;
  end;
end;

{ TThread4InterfacedThread }

constructor TThread4InterfacedThread.Create(APriority: TThreadPriority; AExec: TThreadMethod);
begin
  inherited Create(True);
  Self.Priority := APriority;
  Self.FreeOnTerminate := True;
  FExec := AExec;
end;

procedure TThread4InterfacedThread.DoTerminate;
begin
  inherited;
  FRef := nil;
end;

procedure TThread4InterfacedThread.Execute;
begin
  inherited;
  if not Terminated then begin
    FExec;
  end;
end;

procedure TThread4InterfacedThread.Start(ARef: IInterface);
begin
  FRef := ARef;
  if not Terminated then begin
    Resume;
  end;
end;

end.

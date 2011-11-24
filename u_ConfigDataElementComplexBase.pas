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

unit u_ConfigDataElementComplexBase;

interface

uses
  Classes,
  Contnrs,
  i_JclNotify,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_ConfigDataElement,
  i_ConfigSaveLoadStrategy,
  u_ConfigDataElementBase;

type
  TConfigDataElementComplexBase = class(TConfigDataElementBase)
  private
    FList: TObjectList;
    FItemChangeListener: IJclListener;
    procedure OnItemChange;
  protected
    procedure DoSubItemChange; virtual;
    procedure Add(AItem: IConfigDataElement; ASaveLoadStrategy: IConfigSaveLoadStrategy); overload;
    procedure Add(
      AItem: IConfigDataElement;
      ASaveLoadStrategy: IConfigSaveLoadStrategy;
      ANeedReadLock: Boolean;
      ANeedWriteLock: Boolean;
      ANeedStopNotify: Boolean;
      ANeedChangedListen: Boolean
    ); overload;
    function GetItemsCount: Integer;
    function GetItem(AIndex: Integer): IConfigDataElement;
    function GetSaveLoadStrategy(AIndex: Integer): IConfigSaveLoadStrategy;
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    procedure StopNotify; override;
    procedure StartNotify; override;
    procedure LockWrite; override;
    procedure UnlockWrite; override;
    procedure LockRead; override;
    procedure UnlockRead; override;
  public
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  u_NotifyEventListener;

type
  TSubItemInfo = class
  private
    FItem: IConfigDataElement;
    FSaveLoadStrategy: IConfigSaveLoadStrategy;
    FNeedReadLock: Boolean;
    FNeedWriteLock: Boolean;
    FNeedStopNotify: Boolean;
    FNeedChangedListen: Boolean;
  public
    constructor Create(
      AItem: IConfigDataElement;
      ASaveLoadStrategy: IConfigSaveLoadStrategy;
      ANeedReadLock: Boolean;
      ANeedWriteLock: Boolean;
      ANeedStopNotify: Boolean;
      ANeedChangedListen: Boolean
    );
    destructor Destroy; override;

    property Item: IConfigDataElement read FItem;
    property SaveLoadStrategy: IConfigSaveLoadStrategy read FSaveLoadStrategy;
    property NeedReadLock: Boolean read FNeedReadLock;
    property NeedWriteLock: Boolean read FNeedWriteLock;
    property NeedStopNotify: Boolean read FNeedStopNotify;
    property NeedChangedListen: Boolean read FNeedChangedListen;
  end;

{ TSubItemInfo }

constructor TSubItemInfo.Create(AItem: IConfigDataElement;
  ASaveLoadStrategy: IConfigSaveLoadStrategy; ANeedReadLock, ANeedWriteLock,
  ANeedStopNotify, ANeedChangedListen: Boolean);
begin
  FItem := AItem;
  FSaveLoadStrategy := ASaveLoadStrategy;
  FNeedReadLock := ANeedReadLock;
  FNeedWriteLock := ANeedWriteLock;
  FNeedStopNotify := ANeedStopNotify;
  FNeedChangedListen := ANeedChangedListen;
end;

destructor TSubItemInfo.Destroy;
begin
  FItem := nil;
  FSaveLoadStrategy := nil;
  inherited;
end;

{ TConfigDataElementComplexBase }

constructor TConfigDataElementComplexBase.Create;
begin
  inherited;
  FList := TObjectList.Create(True);
  FItemChangeListener := TNotifyNoMmgEventListener.Create(Self.OnItemChange);
end;

destructor TConfigDataElementComplexBase.Destroy;
var
  i: Integer;
  VItem: TSubItemInfo;
begin
  for i := 0 to GetItemsCount - 1 do begin
    VItem := TSubItemInfo(FList[i]);
    if VItem.NeedChangedListen then begin
      VItem.Item.GetChangeNotifier.Remove(FItemChangeListener);
    end;
  end;
  FItemChangeListener := nil;
  FreeAndNil(FList);
  inherited;
end;

procedure TConfigDataElementComplexBase.Add(AItem: IConfigDataElement;
  ASaveLoadStrategy: IConfigSaveLoadStrategy; ANeedReadLock, ANeedWriteLock,
  ANeedStopNotify, ANeedChangedListen: Boolean);
var
  VItem: TSubItemInfo;
begin
  VItem := TSubItemInfo.Create(
    AItem,
    ASaveLoadStrategy,
    ANeedReadLock,
    ANeedWriteLock,
    ANeedStopNotify,
    ANeedChangedListen
  );
  FList.Add(VItem);
  if VItem.NeedChangedListen then begin
    VItem.Item.GetChangeNotifier.Add(FItemChangeListener);
  end;
end;

procedure TConfigDataElementComplexBase.Add(
  AItem: IConfigDataElement;
  ASaveLoadStrategy: IConfigSaveLoadStrategy
);
begin
  Add(AItem, ASaveLoadStrategy, True, True, True, True);
end;

procedure TConfigDataElementComplexBase.DoReadConfig(
  AConfigData: IConfigDataProvider);
var
  i: Integer;
  VItem: TSubItemInfo;
begin
  inherited;
  for i := 0 to GetItemsCount - 1 do begin
    VItem := TSubItemInfo(FList[i]);
    if VItem.SaveLoadStrategy <> nil then begin
      VItem.SaveLoadStrategy.ReadConfig(AConfigData, VItem.Item);
    end;
  end;
end;

procedure TConfigDataElementComplexBase.DoSubItemChange;
begin
end;

procedure TConfigDataElementComplexBase.DoWriteConfig(
  AConfigData: IConfigDataWriteProvider);
var
  i: Integer;
  VItem: TSubItemInfo;
begin
  inherited;
  for i := 0 to GetItemsCount - 1 do begin
    VItem := TSubItemInfo(FList[i]);
    if VItem.SaveLoadStrategy <> nil then begin
      VItem.SaveLoadStrategy.WriteConfig(AConfigData, VItem.Item);
    end;
  end;
end;

function TConfigDataElementComplexBase.GetSaveLoadStrategy(
  AIndex: Integer): IConfigSaveLoadStrategy;
var
  VItem: TSubItemInfo;
begin
  VItem := TSubItemInfo(FList[AIndex]);
  Result := VItem.SaveLoadStrategy;
end;

procedure TConfigDataElementComplexBase.LockRead;
var
  i: Integer;
  VItem: TSubItemInfo;
begin
  inherited;
  for i := 0 to GetItemsCount - 1 do begin
    VItem := TSubItemInfo(FList[i]);
    if VItem.NeedReadLock then begin
      VItem.Item.LockRead;
    end;
  end;
end;

procedure TConfigDataElementComplexBase.LockWrite;
var
  i: Integer;
  VItem: TSubItemInfo;
begin
  inherited;
  for i := 0 to GetItemsCount - 1 do begin
    VItem := TSubItemInfo(FList[i]);
    if VItem.NeedWriteLock then begin
      VItem.Item.LockWrite;
    end;
  end;
end;

function TConfigDataElementComplexBase.GetItem(
  AIndex: Integer): IConfigDataElement;
var
  VItem: TSubItemInfo;
begin
  VItem := TSubItemInfo(FList[AIndex]);
  Result := VItem.Item;
end;

function TConfigDataElementComplexBase.GetItemsCount: Integer;
begin
  Result := FList.Count;
end;

procedure TConfigDataElementComplexBase.OnItemChange;
begin
  inherited StopNotify;
  try
    DoSubItemChange;
    SetChanged;
  finally
    inherited StartNotify;
  end;
end;

procedure TConfigDataElementComplexBase.StartNotify;
var
  i: Integer;
  VItem: TSubItemInfo;
begin
  for i := 0 to GetItemsCount - 1 do begin
    VItem := TSubItemInfo(FList[i]);
    if VItem.FNeedStopNotify then begin
      VItem.Item.StartNotify;
    end;
  end;
  inherited;
end;

procedure TConfigDataElementComplexBase.StopNotify;
var
  i: Integer;
  VItem: TSubItemInfo;
begin
  inherited;
  for i := 0 to GetItemsCount - 1 do begin
    VItem := TSubItemInfo(FList[i]);
    if VItem.FNeedStopNotify then begin
      VItem.Item.StopNotify;
    end;
  end;
end;

procedure TConfigDataElementComplexBase.UnlockRead;
var
  i: Integer;
  VItem: TSubItemInfo;
begin
  for i := 0 to GetItemsCount - 1 do begin
    VItem := TSubItemInfo(FList[i]);
    if VItem.NeedReadLock then begin
      VItem.Item.UnlockRead;
    end;
  end;
  inherited;
end;

procedure TConfigDataElementComplexBase.UnlockWrite;
var
  i: Integer;
  VItem: TSubItemInfo;
begin
  for i := 0 to GetItemsCount - 1 do begin
    VItem := TSubItemInfo(FList[i]);
    if VItem.NeedWriteLock then begin
      VItem.Item.UnlockWrite;
    end;
  end;
  inherited;
end;

end.

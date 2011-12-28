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

unit u_TreeChangeableBase;

interface

uses
  
  i_JclNotify,
  i_StaticTreeItem,
  i_StaticTreeBuilder,
  i_TreeChangeable;

type
  TTreeChangeableBase = class(TInterfacedObject, ITreeChangeable)
  private
    FStaticTreeBuilder: IStaticTreeBuilder;
    FStaticTree: IStaticTreeItem;
    FConfigChangeListener: IJclListener;
    FConfigChangeNotifier: IJclNotifier;
    FChangeNotifier: IJclNotifier;
    procedure OnConfigChange;
  protected
    function CreateStatic: IStaticTreeItem;
    function GetSource: IInterface; virtual; abstract;
  protected
    function GetStatic: IStaticTreeItem;
    function GetChangeNotifier: IJclNotifier;
  public
    constructor Create(
      AStaticTreeBuilder: IStaticTreeBuilder;
      AConfigChangeNotifier: IJclNotifier
    );
    destructor Destroy; override;
  end;

implementation

uses
  
  u_JclNotify,
  u_NotifyEventListener;

{ TTreeChangeableBase }

constructor TTreeChangeableBase.Create(
  AStaticTreeBuilder: IStaticTreeBuilder;
  AConfigChangeNotifier: IJclNotifier
);
begin
  FStaticTreeBuilder := AStaticTreeBuilder;
  FConfigChangeNotifier := AConfigChangeNotifier;
  FChangeNotifier := TJclBaseNotifier.Create;
  FConfigChangeListener := TNotifyNoMmgEventListener.Create(Self.OnConfigChange);
  FConfigChangeNotifier.Add(FConfigChangeListener);
  OnConfigChange;
end;

destructor TTreeChangeableBase.Destroy;
begin
  FConfigChangeNotifier.Remove(FConfigChangeListener);
  FConfigChangeListener := nil;
  FConfigChangeNotifier := nil;

  inherited;
end;

function TTreeChangeableBase.CreateStatic: IStaticTreeItem;
begin
  Result := FStaticTreeBuilder.BuildStatic(GetSource);
end;

function TTreeChangeableBase.GetChangeNotifier: IJclNotifier;
begin
  Result := FChangeNotifier;
end;

function TTreeChangeableBase.GetStatic: IStaticTreeItem;
begin
  Result := FStaticTree;
end;

procedure TTreeChangeableBase.OnConfigChange;
begin
  FStaticTree := CreateStatic;
  FChangeNotifier.Notify(nil);
end;

end.

{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
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

unit u_MapTypeConfigModalEditByForm;

interface

uses
  Windows,
  i_LanguageManager,
  i_MapTypeConfigModalEdit,
  u_MapType,
  frm_MapTypeEdit;

type
  TMapTypeConfigModalEditByForm = class(TInterfacedObject, IMapTypeConfigModalEdit)
  private
    FLanguageManager: ILanguageManager;
    FEditCounter: Longint;
    FfrmMapTypeEdit: TfrmMapTypeEdit;
  protected
    function EditMap(AMapType: TMapType): Boolean;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils;

{ TMapTypeConfigModalEditByForm }

constructor TMapTypeConfigModalEditByForm.Create(
  const ALanguageManager: ILanguageManager
);
begin
  inherited Create;
  FLanguageManager := ALanguageManager;
  FEditCounter := 0;
end;

destructor TMapTypeConfigModalEditByForm.Destroy;
begin
  Assert(FEditCounter = 0);
  if FfrmMapTypeEdit <> nil then begin
    FreeAndNil(FfrmMapTypeEdit);
  end;

  inherited;
end;

function TMapTypeConfigModalEditByForm.EditMap(AMapType: TMapType): Boolean;
var
  VCounter: Longint;
begin
  VCounter := InterlockedIncrement(FEditCounter);
  try
    if VCounter = 1 then begin
      if FfrmMapTypeEdit = nil then begin
        FfrmMapTypeEdit := TfrmMapTypeEdit.Create(FLanguageManager);
      end;
      Result := FfrmMapTypeEdit.EditMapModadl(AMapType);
    end else begin
      Result := False;
    end;
  finally
    InterlockedDecrement(FEditCounter);
  end;
end;

end.

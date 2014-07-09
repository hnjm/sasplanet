{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_VectorItemTreeExporterListSimple;

interface

uses
  i_Notifier,
  i_ArchiveReadWriteFactory,
  i_VectorItemTreeExporter,
  i_VectorItemTreeExporterList,
  i_HashFunction,
  i_GeometryLonLatFactory,
  i_VectorItemSubsetBuilder,
  i_InternalPerformanceCounter,
  i_AppearanceOfMarkFactory,
  i_MarkPicture,
  i_HtmlToHintTextConverter,
  i_MarkFactory,
  i_MarkCategoryFactory,
  u_BaseInterfacedObject;

type
  TVectorItemTreeExporterListSimple = class(TBaseInterfacedObject, IVectorItemTreeExporterListChangeable)
  private
    FNotifierFake: INotifier;
    FList: IVectorItemTreeExporterListStatic;
  private
    function GetBeforeChangeNotifier: INotifier;
    function GetChangeNotifier: INotifier;
    function GetAfterChangeNotifier: INotifier;
    function GetStatic: IVectorItemTreeExporterListStatic;
  public
    constructor Create(
      const AArchiveReadWriteFactory: IArchiveReadWriteFactory;
      const AMarkPictureList: IMarkPictureList;
      const AHashFunction: IHashFunction;
      const AAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
      const AVectorGeometryLonLatFactory: IGeometryLonLatFactory;
      const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
      const AMarkFactory: IMarkFactory;
      const ACategoryFactory: IMarkCategoryFactory;
      const AHintConverter: IHtmlToHintTextConverter;
      const APerfCounterList: IInternalPerformanceCounterList
    );
  end;

implementation

uses
  i_InterfaceListSimple,
  u_Notifier,
  u_InterfaceListSimple,
  u_VectorItemTreeExporterList,
  u_VectorItemTreeExporterSmlMarks,
  u_VectorItemTreeExporterKmlKmz;

{ TVectorItemTreeExporterListSimple }

constructor TVectorItemTreeExporterListSimple.Create(
  const AArchiveReadWriteFactory: IArchiveReadWriteFactory;
  const AMarkPictureList: IMarkPictureList;
  const AHashFunction: IHashFunction;
  const AAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
  const AVectorGeometryLonLatFactory: IGeometryLonLatFactory;
  const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
  const AMarkFactory: IMarkFactory;
  const ACategoryFactory: IMarkCategoryFactory;
  const AHintConverter: IHtmlToHintTextConverter;
  const APerfCounterList: IInternalPerformanceCounterList
);
var
  VList: IInterfaceListSimple;
  VExporter: IVectorItemTreeExporter;
  VItem: IVectorItemTreeExporterListItem;
begin
  inherited Create;
  FNotifierFake := TNotifierFaked.Create;
  VList := TInterfaceListSimple.Create;

  VExporter := TVectorItemTreeExporterKmlKmz.Create(AArchiveReadWriteFactory);
  VItem :=
    TVectorItemTreeExporterListItem.Create(
      VExporter,
      'kmz',
      'Compressed Keyhole Markup Language'
    );
  VList.Add(VItem);
  VItem :=
    TVectorItemTreeExporterListItem.Create(
      VExporter,
      'kml',
      'Keyhole Markup Language'
    );
  VList.Add(VItem);

  VExporter := TVectorItemTreeExporterSmlMarks.Create(
    AMarkPictureList,
    AHashFunction,
    AAppearanceOfMarkFactory,
    AVectorGeometryLonLatFactory,
    AVectorItemSubsetBuilderFactory,
    AMarkFactory,
    ACategoryFactory,
    APerfCounterList.CreateAndAddNewCounter('ExportSMLLoader'),
    APerfCounterList.CreateAndAddNewCounter('ExportSMLSaver'),
    AHintConverter
  );
  VItem :=
    TVectorItemTreeExporterListItem.Create(
      VExporter,
      'sml',
      'SAS.Planet Marker Database in XML format'
    );
  VList.Add(VItem);

  FList := TVectorItemTreeExporterListStatic.Create(VList.MakeStaticAndClear);
end;

function TVectorItemTreeExporterListSimple.GetAfterChangeNotifier: INotifier;
begin
  Result := FNotifierFake;
end;

function TVectorItemTreeExporterListSimple.GetBeforeChangeNotifier: INotifier;
begin
  Result := FNotifierFake;
end;

function TVectorItemTreeExporterListSimple.GetChangeNotifier: INotifier;
begin
  Result := FNotifierFake;
end;

function TVectorItemTreeExporterListSimple.GetStatic: IVectorItemTreeExporterListStatic;
begin
  Result := FList;
end;

end.

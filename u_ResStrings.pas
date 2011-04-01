unit u_ResStrings;

interface

ResourceString
  SAS_MSG_need_reload_application_curln = '��� ���� ����� ��������� �������� � ����'#13#10 +
    '���������� ������������� ���������.';
  SAS_MSG_coution = '��������!';
  SAS_MSG_youasure = '����������� ���� ��������';
  SAS_MSG_youasurerefrsensor = '�� ������������� ������ �������� ������?';
  SAS_MSG_SelectArea = '����� ���������� ������� ��������� ��� �����.'#13#10 +
    '������� ����� ���������� �� �������� �����.';
  SAS_MSG_FileExists = '���� %0:s ��� ���� � ��� � ����.'#13#10 +
    '�������� ���� ���� ����� ���������?';
  SAS_MSG_NeedHL = '������� ���������� �������� ������ ���� ��� �������!';
  SAS_MSG_FunExForPoly = '� ������ ������ ������� �������� ������ ��� ���������';
  SAS_MSG_FileBeCreateTime = '������ ���� ������ ����� ��������� �����, ���������� ��������.';
  SAS_MSG_FileBeCreateLen = '������ ���� ����� �� ������� �������������, ���������� ��������.';
  SAS_MSG_ProcessFilesComplete = '��������� ������ ���������!';
  SAS_MSG_LoadComplete = '�������� ���������';
  SAS_MSG_NoGPSdetected = '�� ������ GPS ��������';
  SAS_MSG_GarminMax1Mp = '���������� ���������� jpeg-������ �������� 100 ����, ���� ���'#13#10 +
    '��������� �� ���������� ����� �������� ����������� ����������� �� ����� � '#13#10 +
    '������� "�������� � ���������� ��������\�������"'#13#10 +
    '� ����������� ���������� kmz �� �����������';
  SAS_MSG_NotDelWhereHasChildren = '��������� �� �����! ������� ��� �������� ���������.';
  SAS_MSG_HotKeyExists = '������� ������� ��� ������������, ����������, �������� ������';
  SAS_MSG_CantGetTileFileName = '��� �� �������� ���, ���������� �������� ��� ����� � ������.';

  SAS_ERR_Nopoints = '����������� ����� ����� �����������!';
  SAS_ERR_ProxyStrFormat = '�������� ������ ������ ������-�������';
  SAS_ERR_Write = '������ ������ �� ����. �������� ����� ��������!';
  SAS_ERR_Save = '������ ��� ����������!';
  SAS_ERR_code = '��� ������:';
  SAS_ERR_Read = '������ ������ �����!';
  SAS_ERR_SelectArea = '���������� ������� ��������� ������� ��� �����!';
  SAS_ERR_NoMaps = '��� ���� ��������� �� ����� ��������!';
  SAS_ERR_BadFile = '���� ��������!';
  SAS_ERR_FileNotFound = '���� �� ������';
  SAS_ERR_PortOpen = '������ �������� �����!';
  SAS_ERR_Communication = '������ ������������';
  SAS_ERR_UnablePposition = '���������� ���������� �������';
  SAS_ERR_ParamsInput = '������ ����� ����������!';
  SAS_ERR_LonLat1 = '������� � ����� ������� ���� ������ ���� ������ '#13#10 +
    '������� � ������ ������!';
  SAS_ERR_LonLat2 = '������ � ����� ������� ���� ������ ���� ������ '#13#10 +
    '������ � ������ ������!';
  SAS_ERR_CreateArh = '������ �������� ������!';
  SAS_ERR_NotLoads = '����� �� ��������� ���������';
  SAS_ERR_Authorization = '������ ����������� �� ������!';
  SAS_ERR_WaitTime = '���� %0:d ������...';
  SAS_ERR_Ban = '������ ����������� ����, ��� ��� ��������!';
  SAS_ERR_TileNotExists = '������ ����������� ��� �� �������!';
  SAS_ERR_Noconnectionstointernet = '����������� ����������� � ��������!';
  SAS_ERR_RepeatProcess = '�������� ��������� ���������';
  SAS_ERR_FileExistsShort = '������ ���� ��� ������� � ����';
  SAS_ERR_Memory = '���������� �������� ������ ��� ������ ��������';
  SAS_ERR_UseADifferentFormat = '��� ������� ������� �������� ����������� ������ ������ (ecw,bmp,jp2)';
  SAS_ERR_BadMIMEForDownloadRastr  =  '������ ������ ��� "%0:s", ��� �� ��������� �����������';
  SAS_ERR_BadMIME  =  '������ ������ ��� "%0:s", � �� ���� �� ���������';
  SAS_ERR_MapGUIDEmpty = '������ GUID';
  SAS_ERR_MapGUIDBad = 'GUID %0:s �� ������������� �������';
  SAS_ERR_MapGUIDError = '� ����� %0:s ������: %1:s';
  SAS_ERR_MapGUIDDuplicate = '� ������ %0:s � %1:s ���������� GUID';
  SAS_ERR_MainMapNotExists = '����� ZMP ������ ���� ���� �� ���� �����';
  SAS_ERR_CategoryNameDoubling = '����� ��� ��������� ��� ����������';
  SAS_ERR_UrlScriptError = '������ ������� ����� %0:s (%2:s):'#13#10'%1:s';
  SAS_ERR_UrlScriptUnexpectedError = '������ ������� ����� %0:s (%2:s):'#13#10'����������� ������';
  SAS_ERR_UrlScriptCompileError = '������ � ������� ��� ����������'#13#10'%0:s';
  SAS_ERR_UrlScriptByteCodeLoad = '������ ��� �������� ��������';
  SAS_ERR_MapProjectionUnexpectedType = '��������� ��� �������� ����� %0:s';
  SAS_ERR_MapDownloadByError = '��� ����� %0:s ��������� �������� ������ ��-�� ������: %1:s';
  SAS_ERR_TileDownloadContentTypeUnexpcted = '��������� ��� ������';
  SAS_ERR_TileDownloadUnexpectedError = '����������� ������ ��� ����������';
  SAS_ERR_CoordinatesInput='������ ����� ���������';

  SAS_STR_MarshLen = '����� ��������: ';
  SAS_STR_Marshtime = '����� � ����: ';
  SAS_STR_coordinates = '����������';
  SAS_STR_time = '�����';
  SAS_STR_load = '�������';
  SAS_STR_Scale = '�������';
  SAS_STR_Speed = '��������';
  SAS_STR_LenPath = '����� ����';
  SAS_STR_LenToMark = '���������� �� �����';
  SAS_STR_filesnum = '���������� ������';
  SAS_STR_activescale = '�������� �������';
  SAS_STR_for = '���';
  SAS_STR_savetreck = '���������� �����...';
  SAS_STR_loadhl = '�������� ���������...';
  SAS_STR_notfound = '������� ���������� �� ����� �� �����������.';
  SAS_STR_foundplace = '����� ��������� �� �������';
  SAS_STR_Process = '���� ���������...';
  SAS_STR_WiteLoad = '���������, ���� ��������...';
  SAS_STR_Processed = '����������';
  SAS_STR_Saves = '���������';
  SAS_STR_AllProcessed = '����� ����������:';
  SAS_STR_AllLoad = '����� ���������:';
  SAS_STR_TimeRemained = '�������� �������:';
  SAS_STR_LoadRemained = '�������� ��� ���������:';
  SAS_STR_ProcessedNoMore = '���������� �� �����';
  SAS_STR_AllDelete = '����� �������:';
  SAS_STR_AllSaves = '����� ���������:';
  SAS_STR_files = '������';
  SAS_STR_file = '����';
  SAS_STR_No = '���';
  SAS_STR_Yes = '��';
  SAS_STR_Deleted = '�������:';
  SAS_STR_Gamma = '�������� �����';
  SAS_STR_Contrast = '��������';
  SAS_STR_NewPath = '���� %0:d';
  SAS_STR_NewMark = '����� %0:d';
  SAS_STR_NewPoly = '������� %0:d';
  SAS_STR_NewCategory = '����� ���������';
  SAS_STR_AddNewPath = '�������� ����� ����';
  SAS_STR_AddNewMark = '�������� ����� �����';
  SAS_STR_AddNewPoly = '�������� ����� �������';
  SAS_STR_AddNewCategory = '�������� ����� ���������';
  SAS_STR_EditPath = '�������� ����';
  SAS_STR_EditMark = '�������� �����';
  SAS_STR_EditPoly = '�������� �������';
  SAS_STR_EditCategory = '�������� ���������';
  SAS_STR_Add = '��������';
  SAS_STR_Edit = '��������';
  SAS_STR_EditMap = '������������� �������� �����:';
  SAS_STR_Stop = '����';
  SAS_STR_Stop1 = '��������������';
  SAS_STR_Continue = '����������';
  SAS_STR_ExportTiles = '������� ������';
  SAS_STR_DivideInto = '������� ��';
  SAS_STR_Resolution = '����������';
  SAS_STR_UserStop = '�������������� �������������...';
  SAS_STR_LoadProcess = '��������';
  SAS_STR_LoadProcessRepl = '�������� � ������� ...';
  SAS_STR_ProcessedFile = '��������� �����: %0:s ...';
  SAS_STR_Wite = '����';
  SAS_STR_S = '�������';
  SAS_STR_L = '�����';
  SAS_STR_Lat = '������';
  SAS_STR_Lon = '�������';
  SAS_STR_OnVertical = '�� ���������';
  SAS_STR_OnHorizontal = '�� �����������';
  SAS_STR_P = '��������';
  SAS_STR_Whole = '�����';
  SAS_STR_Maps = '�����';
  SAS_STR_Layers = '����';
  SAS_STR_InputLacitp = '������� ����� ������� mnc, mcc, LAC, CellID (��������: 02,250,17023,13023)';
  SAS_STR_InputLacitpCaption = '���� ����������';
  SAS_STR_ExportYaMapsCaption = '��������� ������.����� (������ 3)';
  SAS_STR_ExportGEKmlExportCaption = 'KML (��� ��������� � GE)';
  SAS_STR_ExportIPhone128Caption = 'iPhone (2.2 � ���� 128�128)';
  SAS_STR_ExportIPhone64Caption = 'iPhone (���� v2.2 64�64)';
  SAS_STR_ExportAUXGeoServerCaption = 'AUX ��� GeoExpress Server';
  SAS_STR_ExportZipPackCaption = '�������� � Zip';
  SAS_STR_OperationDeleteCaption = '��������';
  SAS_STR_OperationGenPrevCaption = '��������� ������� �������';
  SAS_STR_OperationTilesCopyCaption = '����������� ������';
  SAS_STR_OperationMapCombineCaption = '������� �����';
  SAS_STR_OperationDownloadCaption = '����������';
  SAS_STR_ApplicationTitle = 'SAS.�������';
  SAS_STR_BattaryStateOnLine = '�� ����';
  SAS_STR_BattaryStateCharge = '����������';
  SAS_STR_BattaryStateUnknown = '����������';
  SAS_STR_MapCombineProgressLine0 = '�������: %0:dx%1:d (%2:d) ������';
  SAS_STR_MapCombineProgressCaption = '����������: %0:dx%1:d ������� �� %2:d ������';
  SAS_STR_MiniMapAsMainMap = '��� �� ������� �����';
  SAS_STR_SensorReset = '��������';

  SAS_STR_SensorGPSRecorderLastSpeedCaption = '��������, ��/�:';
  SAS_STR_SensorGPSRecorderLastSpeedDescription = '���������� ������� �������� ��������';
  SAS_STR_SensorGPSRecorderLastSpeedMenuItemName = '��������';

  SAS_STR_SensorGPSRecorderAvgSpeedCaption = '�������� ����., ��/�:';
  SAS_STR_SensorGPSRecorderAvgSpeedDescription = '���������� ������� �������� ��������';
  SAS_STR_SensorGPSRecorderAvgSpeedMenuItemName = '�������� �������';

  SAS_STR_SensorGPSRecorderMaxSpeedCaption = '�������� ����., ��/�:';
  SAS_STR_SensorGPSRecorderMaxSpeedDescription = '���������� ������������ �������� ��������';
  SAS_STR_SensorGPSRecorderMaxSpeedMenuItemName = '�������� ������������';

  SAS_STR_SensorGPSRecorderDistCaption = '���������� ����:';
  SAS_STR_SensorGPSRecorderDistDescription = '���������� ���������� ���� ��������� �� ����������� � GPS-���������';
  SAS_STR_SensorGPSRecorderDistMenuItemName = '���������� ����';

  SAS_STR_SensorGPSRecorderOdometer1Caption = '�������, ��:';
  SAS_STR_SensorGPSRecorderOdometer1Description = '���������� ���� ���������� ����';
  SAS_STR_SensorGPSRecorderOdometer1MenuItemName = '�������';

  SAS_STR_SensorGPSRecorderOdometer2Caption = '������� �2, ��:';
  SAS_STR_SensorGPSRecorderOdometer2Description = '���������� ���� ���������� ����';
  SAS_STR_SensorGPSRecorderOdometer2MenuItemName = '������� �2';

  SAS_STR_SensorGPSRecorderAltitudeCaption = '������, �:';
  SAS_STR_SensorGPSRecorderAltitudeDescription = '���������� ������ ��� ������� ���� �� ������ GPS-���������';
  SAS_STR_SensorGPSRecorderAltitudeMenuItemName = '������';

  SAS_STR_SensorGPSRecorderHeadingCaption = '������:';
  SAS_STR_SensorGPSRecorderHeadingDescription = '���������� ������ �����������';
  SAS_STR_SensorGPSRecorderHeadingMenuItemName = '������';

  SAS_STR_SensorNavToPointCaption = '���������� �� �����:';
  SAS_STR_SensorNavToPointDescription = '���������� ���������� �� ��������� �����';
  SAS_STR_SensorNavToPointMenuItemName = '���������� �� �����';

  SAS_STR_SensorBatteryStatusCaption = '�������:';
  SAS_STR_SensorBatteryStatusDescription = '���������� ��������� �������';
  SAS_STR_SensorBatteryStatusMenuItemName = '�������';

  SAS_UNITS_kb = '��';
  SAS_UNITS_mb = '��';
  SAS_UNITS_gb = '��';
  SAS_UNITS_kmperh = '��/���';
  SAS_UNITS_mperp = '/����.';
  SAS_UNITS_km = '��';
  SAS_UNITS_sm = '��';
  SAS_UNITS_m = '�';
  SAS_UNITS_m2 = '�2';
  SAS_UNITS_km2 = '��2';
  SAS_UNITS_Secund = '������';
  SAS_UNITS_Min = '���.';
implementation

end.

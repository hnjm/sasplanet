unit i_BitmapTileSaveLoad;

interface

uses
  Classes,
  GR32;

type

  ///	<summary>��������� ���������� ��������� ������</summary>
  IBitmapTileLoader = interface
    ['{07D84005-DD59-4750-BCCE-A02330734539}']

    {$REGION 'Documentation'}
    ///	<summary>�������� ������ �� �����</summary>
    ///	<remarks>������������� ������������� ����� �������� ��� ������
    ///	������</remarks>
    {$ENDREGION}
    procedure LoadFromFile(AFileName: string; ABtm: TCustomBitmap32);

    ///	<summary>�������� ������ �� ������</summary>
    procedure LoadFromStream(AStream: TStream; ABtm: TCustomBitmap32);
  end;

  IBitmapTileSaver = interface
    ['{00853113-0F3E-441D-974E-CCBC2F5C6E10}']
    procedure SaveToFile(ABtm: TCustomBitmap32; AFileName: string);
    procedure SaveToStream(ABtm: TCustomBitmap32; AStream: TStream);
  end;

implementation

end.
 
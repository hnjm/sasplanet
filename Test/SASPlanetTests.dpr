program SASPlanetTests;


{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  u_WideStrings_Test in '..\Includes\u_WideStrings_Test.pas',
  i_IGUIDInterfaceSet_Test in '..\Includes\i_IGUIDInterfaceSet_Test.pas',
  u_GUIDSet_Test in '..\Includes\u_GUIDSet_Test.pas',
  i_IGUIDObjectSet_Test in '..\Includes\i_IGUIDObjectSet_Test.pas',
  u_SASTestCase in 'u_SASTestCase.pas',
  u_ProjectedSingleLine_Test in '..\u_ProjectedSingleLine_Test.pas',
  u_VectorItmesFactorySimple_Test in '..\u_VectorItmesFactorySimple_Test.pas',
  u_EnumDoublePointLine2Poly_Test in '..\u_EnumDoublePointLine2Poly_Test.pas',
  u_EnumDoublePointFilterEqual_Test in '..\u_EnumDoublePointFilterEqual_Test.pas',
  u_EnumDoublePointWithClip_Test in '..\u_EnumDoublePointWithClip_Test.pas',
  u_EnumDoublePointClosePoly_Test in '..\u_EnumDoublePointClosePoly_Test.pas',
  u_HashCacheWithQueuesAbstract_Test in '..\u_HashCacheWithQueuesAbstract_Test.pas',
  u_PathConfig_Test in '..\u_PathConfig_Test.pas',
  u_Datum_Test in 'u_Datum_Test.pas',
  u_BitmapTileSaveLoadFactory_Test in 'u_BitmapTileSaveLoadFactory_Test.pas';

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.


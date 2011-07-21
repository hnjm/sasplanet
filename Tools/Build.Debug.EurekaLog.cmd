@echo off

cd ..\

rem ���������� ����������
copy ".\Tools\eurekalog\EurekaLog.pas" ".\" /Y
cscript .\Tools\eurekalog\Clear.js
cscript .\Tools\eurekalog\Prepare.js
cscript .\Tools\CreateVersion.js

rem ���������� ��� ������ MSBuild � �������� SASPlanet.cfg
call rsvars.bat
msbuild SASPlanet.dproj /p:Configuration=Debug /t:rebuild

rem �������������� ������� ���������� � ����� ��������� ���� ����������
rem DCC32 --no-config -B SASPlanet.dpr -E".bin" -N".dcu" -GD -D"DEBUG;EUREKALOG;EUREKALOG_VER6" -I"%BDS%\lib\Graphics32;%BDS%\lib\tb2k\source;%BDS%\lib\imaginglib\source" -U"%BDS%\Bin;%BDS%\lib;%BDS%\lib\Graphics32;%BDS%\lib\tb2k;%BDS%\lib\tb2k\source;%BDS%\lib\tbx;%BDS%\lib\EmbeddedWB\source;%BDS%\lib\DISQLite;%BDS%\lib\vpr;%BDS%\lib\zylgpsrec;%BDS%\lib\imaginglib\source;%BDS%\lib\imaginglib\source\JpegLib;%BDS%\lib\imaginglib\source\ZLib;%BDS%\lib\imaginglib\Extras\Extensions;%BDS%\lib\imaginglib\Extras\Extensions\LibTiff;%BDS%\lib\PascalScript;%BDS%\lib\EurekaLog"
pause
rem ��������� EurekaLog � ���������������� ��������� (��������� �� SASPlanet.eof)
ECC32 --el_alter_exe"SASPlanet.dpr" --el_config".\Tools\eurekalog\SASPlanet.eof"

rem ��������� �� �����
cscript .\Tools\eurekalog\Clear.js
del /F /Q EurekaLog.pas
 
pause
cd ..\
copy ".\Tools\dxgettext\*.*" ".\" /Y
dxgettext -r --delphi --nonascii --useignorepo -o:msgid -o ..\SAS.Translate
del /F /Q ggexclude.cfg dxgettext.ini ignore.po
cd ..\SAS.Translate
msgremove default.po -i ignore.po -o output.po
del default.po
rename output.po default.po
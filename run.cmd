@echo off
setlocal

set target=ko
set scriptName=aiLocalizer-able
set author=@itscutefox
set scriptVer=210810-001
set fileName=run.cmd

title %scriptName% %scriptVer%


:checkAdmin
bcdedit >>nul
if %errorlevel% == 1 goto needAdmin
goto main

:needAdmin
echo.
echo. Error:
echo. No sufficient privilege
echo.
echo. Run %fileName% as administrator.
echo.
pause
exit

:main
echo.
echo. %scriptName% by %author%
echo. Version: %scriptVer%
echo.

echo.
echo. -
echo.
echo. Where is "ingbrzy/Xiaomi.eu-MIUIv12-XML-Compare"?
echo.
echo. No Quotation Mark for Location.
echo. Example: C:\Users\User\Documents\Xiaomi.eu-MIUIv12-XML-Compare
echo.
set /p stringSource=Location: 

echo.
echo. -
echo.
echo. Which device is ideal for source?
echo.
echo. Recommended: star
echo.
set /p deviceCodename=Codename of device: 
set directorySource=\%deviceCodename%

echo.
echo. -
echo.
echo. Where is "cjhyuky/MA-XML-MIUI12-KOREAN"?
echo.
echo. No Quotation Mark for Location.
echo. Example: C:\Users\User\Documents\MA-XML-MIUI12-KOREAN
echo.
set /p stringTranslated=Location: 

set directoryTranslated=\Korean\main

:createSymLink
cls
echo.
echo. Source:
echo. "%stringSource%%directorySource%"
echo.
echo. Translated:
echo. "%stringTranslated%%directoryTranslated%"
echo.

echo.
echo. -
echo.
echo. Create symbolic link for Package

echo.
echo. -
echo.
echo. Package name from source
echo.
echo. No .apk
echo. Example: AuthManager
echo.
set /p packageSource=Package: 

echo.
echo. -
echo.
echo. Package name from translated
echo.
echo. If both source and translated are same, type ; and press ENTER.
echo. No .apk
echo. Example: AuthManager
echo. If both are same: ;
echo.
set /p packageTranslated=Package: 
if "%packageTranslated%"==";" (
	set packageTranslated=%packageSource%
)

echo.
echo. -
echo.
echo. Creating symbolic links...
echo.
set dp=%~dp0
mkdir "%dp%lazy\%packageTranslated%.apk\res"
mklink /d "%dp%lazy\%packageTranslated%.apk\res\values" "%stringSource%%directorySource%\%packageSource%.apk\res\values"
mklink /d "%dp%\lazy\%packageTranslated%.apk\res\values-%target%" "%stringTranslated%%directoryTranslated%\%packageTranslated%.apk\res\values-%target%"

echo.
echo. DONE
echo.
pause
goto createSymLink
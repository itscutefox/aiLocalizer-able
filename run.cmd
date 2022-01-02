@echo off
setlocal

set target=ko
set scriptName=aiLocalizer-able
set author=@itscutefox
set scriptVer=220102-001
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
set dp=%~dp0


if exist "%dp%config\translatedLocation.txt" (
    set dirPreset=true
    goto loadPreset
) else (
    goto configFolder
)

:configFolder
if exist "%dp%config" (
	goto landing
) else (
	mkdir "%dp%config"
	goto landing
)

:landing
set dirPreset=false
echo.
echo. -
echo.
echo. Where is "ingbrzy/Xiaomi.eu-MIUIv13-XML-Compare"?
echo.
echo. No Quotation Mark for Location.
echo. Example: C:\Users\User\Documents\Xiaomi.eu-MIUIv13-XML-Compare
echo.
set /p stringSource=Location: 
echo %stringSource% > "%dp%config\sourceLocation.txt"

echo.
echo. -
echo.
echo. Which device is ideal for source?
echo.
echo. Recommended: star
echo.
set /p deviceCodename=Codename of device: 
echo %deviceCodename% > "%dp%config\deviceCodename.txt"
set directorySource=\%deviceCodename%

echo.
echo. -
echo.
echo. Where is "cjhyuky/MA-XML-MIUI13-KOREAN"?
echo.
echo. No Quotation Mark for Location.
echo. Example: C:\Users\User\Documents\MA-XML-MIUI13-KOREAN
echo.
set /p stringTranslated=Location: 
echo %stringTranslated% > "%dp%config\translatedLocation.txt"
set directoryTranslated=\Korean\main
goto locationConfirm

:loadPreset
echo.
echo. -
echo.
echo. Loading preset...
echo.
for /f "tokens=1 usebackq" %%f in ("%dp%config\sourceLocation.txt") do set stringSource=%%f
for /f "tokens=1 usebackq" %%f in ("%dp%config\deviceCodename.txt") do set deviceCodename=%%f
set directorySource=\%deviceCodename%
for /f "tokens=1 usebackq" %%f in ("%dp%config\translatedLocation.txt") do set stringTranslated=%%f
set directoryTranslated=\Korean\main
goto locationConfirm

:locationConfirm
cls
echo.
echo. Source:
echo. "%stringSource%%directorySource%"
echo.
echo. Translated:
echo. "%stringTranslated%%directoryTranslated%"
echo.
if "%dirPreset%"=="true" (
    echo. The locations are loaded from config folder!
) else (
    echo. The locations are saved in config folder!
)
echo.
echo. To proceed, type y
echo. If you want to reset config, type n
echo.
set /p useConfig=type y or n: 
if "%useConfig%"=="n" (
	cls
	goto landing
) else (
	goto createSymLink
)
echo.

:createSymLink
cls
echo.
echo. Source:
echo. "%stringSource%%directorySource%"
echo.
echo. Translated:
echo. "%stringTranslated%%directoryTranslated%"
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
mkdir "%dp%lazy\%packageTranslated%.apk\res"
mklink /d "%dp%lazy\%packageTranslated%.apk\res\values" "%stringSource%%directorySource%\%packageSource%.apk\res\values"
mklink /d "%dp%lazy\%packageTranslated%.apk\res\values-%target%" "%stringTranslated%%directoryTranslated%\%packageTranslated%.apk\res\values-%target%"

echo.
echo. DONE
echo. Symbolic links are created in lazy folder!
echo.
echo. To create more symlinks, press any key
pause
goto createSymLink
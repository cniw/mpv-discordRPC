@echo off
title mpv-discordRPC Installer
echo mpv-discordRPC Windows installer script
echo ===========================================================================

:set_mpv_dir
echo Enter mpv directory E.g.: D:\Applications\mpv-x86_64-20171225
set /p mpv_dir="mpv folder: "
echo:

if exist "%mpv_dir%" (
	if exist "%mpv_dir%\mpv.exe" (
		goto install_library
	) else (
		echo Please try again, 'mpv.exe' can't found on that directory.
		echo:
		goto set_mpv_dir
	)
) else (
	echo Please try again, not a invalid directory.
	echo:
	goto set_mpv_dir
)

:install_library
unzip -qq ".\discord-rpc-win.zip"
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > nul && set os=32bit || set os=64bit
if %os%==32bit copy ".\discord-rpc\win32-dynamic\bin\discord-rpc.dll" "%mpv_dir%" > nul
if %os%==64bit copy ".\discord-rpc\win64-dynamic\bin\discord-rpc.dll" "%mpv_dir%" > nul
@rd /s /q ".\discord-rpc"

:set_scripts_dir
echo [1] install script on %mpv_dir%
echo [2] install script on %appdata%\mpv
set /p scripts_dir_select="select [1/2]: "
echo:

if %scripts_dir_select%==1 (
	set scripts_dir="%mpv_dir%\scripts"
	goto install_scripts
)
if %scripts_dir_select%==2 (
	set scripts_dir="%appdata%\mpv\scripts"
	goto install_scripts
) else goto set_scripts_dir

:install_scripts
if not exist "%scripts_dir%" mkdir "%scripts_dir%"
copy .\*.lua "%scripts_dir%" > nul

echo:
echo [discordapp] wachidadinugroho#7674: All done. Good Luck and have a nice day.
echo:
pause

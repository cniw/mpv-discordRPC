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

:set_additional_dir
echo [1] install scripts on %mpv_dir%
echo     install lua-settings on %mpv_dir%
echo [2] install scripts on %appdata%\mpv
echo     install lua-settings on %appdata%\mpv
set /p additional_dir_select="select [1/2]: "
echo:

if %additional_dir_select%==1 (
	set scripts_dir="%mpv_dir%\scripts"
	set lua-settings_dir="%mpv_dir%\lua-settings"
	goto install_additional
)
if %additional_dir_select%==2 (
	set scripts_dir="%appdata%\mpv\scripts"
	set lua-settings_dir="%appdata%\mpv\lua-settings"
	goto install_additional
) else goto set_additional_dir

:install_additional
if not exist "%scripts_dir%" mkdir "%scripts_dir%"
copy .\*.lua "%scripts_dir%" > nul
copy .\*.py "%scripts_dir%" > nul
if not exist "%lua-settings_dir%" mkdir "%lua-settings_dir%"
copy .\*.conf "%lua-settings_dir%" > nul

echo:
echo [discordapp] wachidadinugroho#7674: All done. Good Luck and have a nice day.
echo:
pause

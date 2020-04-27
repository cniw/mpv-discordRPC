@echo off
title mpv-discordRPC Installer
echo mpv-discordRPC Windows installer script
echo ===========================================================================

set src_dir=%~dp0

:set_mpv_dir
echo Enter mpv directory E.g.: D:\Applications\mpv-x86_64-20200426-git-640db1e
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
"%src_dir%unzip.exe" -qq -d "%src_dir:~0,-1%" "%src_dir%discord-rpc-win.zip"
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > nul && set os=32bit || set os=64bit
if %os%==32bit copy "%src_dir%discord-rpc\win32-dynamic\bin\discord-rpc.dll" "%mpv_dir%" > nul
if %os%==64bit copy "%src_dir%discord-rpc\win64-dynamic\bin\discord-rpc.dll" "%mpv_dir%" > nul
@rd /s /q "%src_dir%discord-rpc"

:set_additional_dir
echo [1] install scripts on %mpv_dir%
echo     install script-opts on %mpv_dir%
echo [2] install scripts on %appdata%\mpv
echo     install script-opts on %appdata%\mpv
set /p additional_dir_select="select [1/2]: "
echo:

if %additional_dir_select%==1 (
	set scripts_dir="%mpv_dir%\scripts"
	set script_opts_dir="%mpv_dir%\script-opts"
	goto install_additional
)
if %additional_dir_select%==2 (
	set scripts_dir="%appdata%\mpv\scripts"
	set script_opts_dir="%appdata%\mpv\script-opts"
	goto install_additional
) else goto set_additional_dir

:install_additional
if not exist "%scripts_dir%\mpv-discordRPC" mkdir "%scripts_dir%\mpv-discordRPC"
copy "%src_dir%*.lua" "%scripts_dir%" > nul
copy "%src_dir%mpv-discordRPC\*.*" "%scripts_dir%\mpv-discordRPC" > nul
if not exist "%script_opts_dir%" mkdir "%script_opts_dir%"
copy "%src_dir%*.conf" "%script_opts_dir%" > nul

echo:
echo [discordapp] wachidadinugroho#7674: All done. Good Luck and have a nice day.
echo:
pause

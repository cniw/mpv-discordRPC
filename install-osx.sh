#!/usr/bin/env bash

NAME="mpv-discordRPC"
DIRNAME=$(dirname "$0")
SCRIPTS_DIR=${HOME}/.config/mpv/scripts
LUA_SETTINGS_DIR=${HOME}/.config/mpv/lua-settings
LIBRARY_DIR=/usr/local/lib

if  [ ! -d "${SCRIPTS_DIR}" ] ; then
    mkdir -p "${SCRIPTS_DIR}"
fi
if  [ ! -d "${LUA_SETTINGS_DIR}" ] ; then
    mkdir -p "${LUA_SETTINGS_DIR}"
fi
if  [ ! -d "${LIBRARY_DIR}" ] ; then
    sudo mkdir -p "${LIBRARY_DIR}"
fi
cd "${DIRNAME}"

echo "[${NAME}] installing dependency"
echo "[${NAME}] ├── discord-rpc"
if [ ! -f ./discord-rpc-osx.zip ]; then
echo "[${NAME}] │   ├── downloading 'discord-rpc-osx.zip'"
    wget -q -c "https://github.com/discordapp/discord-rpc/releases/download/v3.3.0/discord-rpc-osx.zip"
fi
echo "[${NAME}] │   ├── extracting 'discord-rpc-osx.zip'"
unzip -q discord-rpc-osx.zip
echo "[${NAME}] │   └── installing 'libdiscord-rpc.dylib'"
sudo cp ./discord-rpc/osx-dynamic/lib/libdiscord-rpc.dylib "${LIBRARY_DIR}"
rm -rf ./discord-rpc

echo "[${NAME}] ├── lua-discordRPC"
if [ ! -f ./mpv-discordRPC_lua-discordRPC.lua ]; then
echo "[${NAME}] │   ├── downloading 'discordRPC.lua'"
    wget -q -c -O "mpv-discordRPC_lua-discordRPC.lua" "https://github.com/pfirsich/lua-discordRPC/raw/master/discordRPC.lua"
fi
echo "[${NAME}] │   └── installing 'mpv-discordRPC_lua-discordRPC.lua'"
cp ./mpv-discordRPC_lua-discordRPC.lua "${SCRIPTS_DIR}"

echo "[${NAME}] ├── pypresence"
echo "[${NAME}] │   ├── checking 'pypresence' python package"
if [[ $(pip3 list | grep pypresence) ]]; then
echo "[${NAME}] │   │   └── 'pypresence' has been installed"
else
echo "[${NAME}] │   │   └── installing 'pypresence'"
    pip3 install pypresence
fi
if [ ! -f ./mpv-discordRPC_pypresence.py ]; then
echo "[${NAME}] │   ├── downloading 'mpv-discordRPC_pypresence.py'"
    wget -q -c "https://github.com/cniw/mpv-discordRPC/raw/master/mpv-discordRPC_pypresence.py"
fi
echo "[${NAME}] │   └── installing 'mpv-discordRPC_pypresence.py'"
cp ./mpv-discordRPC_pypresence.py "${SCRIPTS_DIR}"

echo "[${NAME}] └── status-line"
if [ ! -f ./status-line.lua ]; then
echo "[${NAME}]     ├── downloading 'status-line.lua'"
    wget -q -c "https://github.com/mpv-player/mpv/raw/master/TOOLS/lua/status-line.lua"
fi
echo "[${NAME}]     └── installing 'status-line.lua'"
cp ./status-line.lua "${SCRIPTS_DIR}"

echo "[${NAME}] installing main script"
if [ ! -f ./mpv_discordRPC.conf ]; then
echo "[${NAME}] ├── downloading 'mpv_discordRPC.conf'"
    wget -q -c "https://github.com/cniw/mpv-discordRPC/raw/master/mpv_discordRPC.conf"
fi
if [ ! -f ./mpv-discordRPC.lua ]; then
echo "[${NAME}] ├── downloading 'mpv-discordRPC.lua'"
    wget -q -c "https://github.com/cniw/mpv-discordRPC/raw/master/mpv-discordRPC.lua"
fi
echo "[${NAME}] ├── installing 'mpv_discordRPC.conf'"
cp ./mpv_discordRPC.conf "${LUA_SETTINGS_DIR}"
echo "[${NAME}] └── installing 'mpv-discordRPC.lua'"
cp ./mpv-discordRPC.lua "${SCRIPTS_DIR}"

echo "[${NAME}] updating library path"
sudo update_dyld_shared_cache

echo -e "\n[discordapp] wachidadinugroho#7674: All done. Good Luck and have a nice day.\n"

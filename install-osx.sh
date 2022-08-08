#!/usr/bin/env bash

NAME="mpv-discordRPC"
DIRNAME=$(dirname "$0")
SCRIPTS_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"/mpv/scripts
SCRIPT_OPTS_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"/mpv/script-opts
LIBRARY_DIR=/usr/local/lib
if [[ $(uname -p) == 'arm' ]]; then
    IS_ARM=true
else
    IS_ARM=false
fi

if [ ! -d "${SCRIPTS_DIR}/mpv-discordRPC" ]; then
    mkdir -p "${SCRIPTS_DIR}/mpv-discordRPC"
fi
if [ ! -d "${SCRIPT_OPTS_DIR}" ]; then
    mkdir -p "${SCRIPT_OPTS_DIR}"
fi
if [ ! -d "${LIBRARY_DIR}" ]; then
    sudo mkdir -p "${LIBRARY_DIR}"
fi
cd "${DIRNAME}"

echo "[${NAME}] installing dependency"
echo "[${NAME}] ├── discord-rpc"

if [ $IS_ARM = true ]; then
    echo "[${NAME}] │   ├── downloading 'libdiscord-rpc.dylib'"

    wget -q -c "https://github.com/wxllow/discord-rpc-m1/releases/download/1.0.0/libdiscord-rpc.dylib"
else
    if [ ! -f ./discord-rpc-osx.zip ]; then
        echo "[${NAME}] │   ├── downloading 'discord-rpc-osx.zip'"

        wget -q -c "https://github.com/discordapp/discord-rpc/releases/download/v3.4.0/discord-rpc-osx.zip"
    fi
fi

if [ $IS_ARM != true ]; then
    echo "[${NAME}] │   ├── extracting 'discord-rpc-osx.zip'"
    unzip -q discord-rpc-osx.zip
fi

echo "[${NAME}] │   └── installing 'libdiscord-rpc.dylib'"
if [ $IS_ARM = true ]; then
    sudo cp libdiscord-rpc.dylib "${LIBRARY_DIR}"
    rm -rf libdiscord-rpc.dylib
else
    sudo cp ./discord-rpc/osx-dynamic/lib/libdiscord-rpc.dylib "${LIBRARY_DIR}"
    rm -rf ./discord-rpc
fi

sudo xattr -d com.apple.quarantine "${LIBRARY_DIR}/libdiscord-rpc.dylib"

echo "[${NAME}] ├── lua-discordRPC"
if [ ! -f ./mpv-discordRPC/lua-discordRPC.lua ]; then
    echo "[${NAME}] │   ├── downloading 'lua-discordRPC.lua'"
    wget -q -c -O "mpv-discordRPC/lua-discordRPC.lua" "https://github.com/pfirsich/lua-discordRPC/raw/master/discordRPC.lua"
fi
echo "[${NAME}] │   └── installing 'lua-discordRPC.lua'"
cp ./mpv-discordRPC/lua-discordRPC.lua "${SCRIPTS_DIR}/mpv-discordRPC"

echo "[${NAME}] ├── pypresence"
echo "[${NAME}] │   ├── checking 'pypresence' python package"
if [[ $(pip3 list | grep pypresence) ]]; then
    echo "[${NAME}] │   │   └── 'pypresence' has been installed"
else
    echo "[${NAME}] │   │   └── installing 'pypresence'"
    pip3 install --user pypresence
fi
if [ ! -f ./mpv-discordRPC/python-pypresence.py ]; then
    echo "[${NAME}] │   ├── downloading 'python-pypresence.py'"
    wget -q -c -O "mpv-discordRPC/python-pypresence.py" "https://github.com/cniw/mpv-discordRPC/raw/master/mpv-discordRPC/python-pypresence.py"
fi
echo "[${NAME}] │   └── installing 'python-pypresence.py'"
cp ./mpv-discordRPC/python-pypresence.py "${SCRIPTS_DIR}/mpv-discordRPC"

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
if [ ! -f ./mpv-discordRPC/catalogs.lua ]; then
    echo "[${NAME}] ├── downloading 'catalogs.lua'"
    wget -q -c -O "mpv-discordRPC/catalogs.lua" "https://github.com/cniw/mpv-discordRPC/raw/master/mpv-discordRPC/catalogs.lua"
fi
if [ ! -f ./mpv-discordRPC/main.lua ]; then
    echo "[${NAME}] ├── downloading 'main.lua'"
    wget -q -c "https://github.com/cniw/mpv-discordRPC/raw/master/mpv-discordRPC/main.lua"
fi
echo "[${NAME}] ├── installing 'mpv_discordRPC.conf'"
cp ./mpv_discordRPC.conf "${SCRIPT_OPTS_DIR}"
echo "[${NAME}] ├── installing 'catalogs.lua'"
cp ./mpv-discordRPC/catalogs.lua "${SCRIPTS_DIR}/mpv-discordRPC"
echo "[${NAME}] └── installing 'main.lua'"
cp ./mpv-discordRPC/main.lua "${SCRIPTS_DIR}/mpv-discordRPC"

echo "[${NAME}] updating library path"
sudo update_dyld_shared_cache

echo -e "\n[discordapp] wachidadinugroho#7674: All done. Good Luck and have a nice day.\n"

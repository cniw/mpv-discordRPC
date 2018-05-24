#!/bin/bash

NAME="mpv-discordRPC"
DIRNAME=$(dirname "$0")
SCRIPTDIR=${HOME}/.config/mpv/scripts
LIBDIR=/usr/local/lib

if  [ ! -d "${SCRIPTDIR}" ] ; then
    mkdir -p "${SCRIPTDIR}"
fi
if  [ ! -d "${LIBDIR}" ] ; then
    sudo mkdir -p "${LIBDIR}"
fi
cd "${DIRNAME}"

echo "[${NAME}] installing dependency"
echo "[${NAME}] ├── discord-rpc"
if [ ! -f ./discord-rpc-linux.zip ]; then
echo "[${NAME}] │   ├── downloading 'discord-rpc-linux.zip'"
    wget -q -c "https://github.com/discordapp/discord-rpc/releases/download/v3.3.0/discord-rpc-linux.zip"
fi
echo "[${NAME}] │   ├── extracting 'discord-rpc-linux.zip'"
unzip -q discord-rpc-linux.zip
echo "[${NAME}] │   └── installing 'libdiscord-rpc.so'"
cp ./discord-rpc/linux-dynamic/lib/libdiscord-rpc.so "${LIBDIR}"
rm -rf ./discord-rpc

echo "[${NAME}] ├── lua-discordRPC"
if [ ! -f ./discordRPC.lua ]; then
echo "[${NAME}] │   ├── downloading 'discordRPC.lua'"
    wget -q -c "https://github.com/pfirsich/lua-discordRPC/raw/master/discordRPC.lua"
fi
echo "[${NAME}] │   └── installing 'discordRPC.lua'"
cp ./discordRPC.lua "${SCRIPTDIR}"

echo "[${NAME}] └── status-line"
if [ ! -f ./status-line.lua ]; then
echo "[${NAME}]     ├── downloading 'status-line.lua'"
    wget -q -c "https://github.com/mpv-player/mpv/raw/master/TOOLS/lua/status-line.lua"
fi
echo "[${NAME}]     └── installing 'status-line.lua'"
cp ./status-line.lua "${SCRIPTDIR}"

echo "[${NAME}] installing main script"
if [ ! -f ./mpv-discordRPC.lua ]; then
echo "[${NAME}] ├── downloading 'mpv-discordRPC.lua'"
    wget -q -c "https://github.com/cniw/mpv-discordRPC/raw/master/mpv-discordRPC.lua"
fi
echo "[${NAME}] └── installing 'mpv-discordRPC.lua'"
cp ./mpv-discordRPC.lua "${SCRIPTDIR}"

echo "[${NAME}] updating library path"
sudo sh -c 'echo '"${LIBDIR}"' > /etc/ld.so.conf.d/'"${NAME}"'.conf'
sudo ldconfig

echo -e "\n[discordapp] wachidadinugroho#7674: All done. Good Luck and have a nice day.\n"

# [Discord RPC (Rich Presence) intergation for mpv Media Player](https://github.com/cniw/mpv-discordRPC)

This is edited form [mpv-discordRPC](https://github.com/noaione/mpv-discordRPC). 
I add metadata tag (Title, Artist and Album) support for 'details' and I use 
[status-line](https://github.com/mpv-player/mpv/raw/master/TOOLS/lua/status-line.lua) 
for 'state'. I use 'elapsed' time mode when idle, while when playing, paused, and 
buffering use 'left' time mode.

## Important:
1. Make sure you install [LuaJIT](http://luajit.org/) before, because it needed 
by [lua-discordRPC](https://github.com/pfirsich/lua-discordRPC)
2. Make sure your [mpv](https://mpv.io/) binary linked to luajit~~ not lua~~ library.
```bash
ldd $(which mpv) | grep luajit
libluajit-5.1.so.2 => /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 (0x00007f32e9a83000)
```

# Install
1. For Linux, installing just run `install-linux.sh` on terminal.
2. For other OS, just extact and places to directory that you think that can work and install [Discord RPC](https://github.com/discordapp/discord-rpc/releases).

# Testing
1. Open your [Discord](https://discordapp.com/download)
2. Open your [mpv](https://mpv.io/installation/) than
3. Back to Discord and than check your profile. 

# Preview
1. Idle
![Idle](https://github.com/cniw/mpv-discordRPC/raw/master/images/idle.png)
2. Playing
![Playing](https://github.com/cniw/mpv-discordRPC/raw/master/images/playing.png)

Good Luck and have a nice day.


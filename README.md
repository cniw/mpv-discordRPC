# [mpv Media Player Discord RPC integration](https://github.com/cniw/mpv-discordRPC)

edited form [mpv-discordRPC](https://github.com/noaione/mpv-discordRPC).

Using lua-DiscordRPC as base and also mpv lua module.

### !Important:
1. Make sure you install [LuaJIT](http://luajit.org/) before, because it needed 
by [lua-discordRPC](https://github.com/pfirsich/lua-discordRPC)
2. Make sure your mpv binary linked to luajit~~ not lua~~ library.
```bash
ldd $(which mpv) | grep luajit
libluajit-5.1.so.2 => /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 (0x00007f32e9a83000)
``` 

For Linux, installing just run `install-linux.sh` on terminal.
For other, just extact and places to directory that you think that can work.
Good Luck and have a nice day.


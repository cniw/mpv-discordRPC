# [Discord RPC (Rich Presence) intergation for mpv Media Player](https://github.com/cniw/mpv-discordRPC)

This is edited form [mpv-discordRPC][1]. I add metadata tag (Title, Artist and Album) 
support for 'details' and I use [status-line][2] for 'state'. I use 'elapsed' time 
mode when idle, while when playing, paused, and buffering use 'left' time mode.

## Install
1. For Linux, installing just run `install-linux.sh` on terminal.
2. For Windows, installing just run `install-win.bat` by double-clicking it. 
	If you prefer installing manually, follow the step:  
    - Open file `discord-rpc-win.zip` and extract file `discord-rpc\win32-dynamic\bin\discord-rpc.dll` 
    if your system is 32-bit or `discord-rpc\win64-dynamic\bin\discord-rpc.dll` 
    if your system is 64-bit to same folder that contain `mpv.exe`
    - Make new folder named `scripts` on same folder that contain `mpv.exe`
    - Copy file `mpv-discordRPC.lua`, `discordRPC.lua`, and `status-line.lua` to 
    `scripts` folder.
3. other OS, just extact and places to directory that you think that can work 
and install [Discord RPC][3].
---
## Important [luaJIT][4] library on [mpv][7]
1. For Linux
    - Make sure you install [LuaJIT][4] before, because it has [FFI Library][5] 
    and it needed by [lua-discordRPC][6].
    - Make sure your [mpv][7] binary linked to luajit~~ not lua~~ library.
    ```bash
    ldd $(which mpv) | grep luajit
    libluajit-5.1.so.2 => /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 (0x00007f32e9a83000)
    ```
    if it's dynamic build while it's static build you can check with
    ```bash
    mpv -v -V | sed -rn 's/.*(luajit).*/\1/p'
    luajit
    ```
2. For Windows ***(Don't worry)***
   - You can skip this because available mpv Windows build by [lachs0r][8] 
   and [shinchiro][9] already use [luajit][5] and it configure with `--enable-static-build`. 
   maybe you want to check again, run command below and find `luajit` word on the 
   line which beginning with `[cplayer] List of enabled features:`
   ```cmd
   mpv.exe -v -V
   ```
---
## Testing
1. Open your [Discord][10],
2. Open your [mpv][7] than
3. Back to Discord and than check your profile. 
---
## Preview
1. Idle

![Idle](https://github.com/cniw/mpv-discordRPC/raw/master/images/idle.png)

2. Playing

![Playing](https://github.com/cniw/mpv-discordRPC/raw/master/images/playing.png)


Good Luck and have a nice day.

[1]: https://github.com/noaione/mpv-discordRPC
[2]: https://github.com/mpv-player/mpv/raw/master/TOOLS/lua/status-line.lua
[3]: https://github.com/discordapp/discord-rpc/releases
[4]: http://luajit.org/
[5]: http://luajit.org/ext_ffi.html
[6]: https://github.com/pfirsich/lua-discordRPC
[7]: https://mpv.io/installation/
[8]: https://mpv.srsfckn.biz/
[9]: https://sourceforge.net/projects/mpv-player-windows/files
[10]: https://discordapp.com/download 

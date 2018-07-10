# [mpv - discord RPC : Discord Rich Presence intergation for mpv Media Player](https://github.com/cniw/mpv-discordRPC)

This is edited form [mpv-discordRPC][mpv-discordRPC by noaione]. I add metadata 
tags (Title, Artist and Album) support for 'details' and I use status-line for 
'state'. I use 'elapsed' time mode when idle, while when playing, paused, and 
buffering use 'left' time mode.

---
## Previews
1. Idle

![Idle](https://github.com/cniw/mpv-discordRPC/raw/master/images/idle.png)

2. Playing

![Playing](https://github.com/cniw/mpv-discordRPC/raw/master/images/playing.png)

3. Showing info: playlist and loop

![Showing info: playlist and loop](https://github.com/cniw/mpv-discordRPC/raw/master/images/info.png)

4. Showing cover art

![Showing cover art](https://github.com/cniw/mpv-discordRPC/raw/master/images/coverart.png)

---
## Used software:
1. provided by user: [mpv][mpv], [Discord][discord]
2. Included: [Discord RPC][discord-rpc], [status-line][status-line], 
[lua-discordRPC][lua-discordRPC]
3. Optional: [Python][python], [pypresence][pypresence]

---
## Download
- Latest Releases [![download](https://img.shields.io/github/downloads/cniw/mpv-discordRPC/latest/total.svg)](https://github.com/cniw/mpv-discordRPC/releases/latest)
- All Releases [![download](https://img.shields.io/github/downloads/cniw/mpv-discordRPC/total.svg)](https://github.com/cniw/mpv-discordRPC/releases)

---
## Installing
1. For Linux, installing just run `install-linux.sh` on terminal.
2. For Windows, installing just run `install-win.bat` by double-clicking it.
3. For Mac, installing just run `install-osx.sh` on terminal.

---
## Settings
Just edit `mpv_discordRPC.conf` file in `lua-settings` folder. Now Available 2 
rpc_wrapper option, choose one. Example:
1. Configuration A
	```
	rpc_wrapper=lua-discordRPC
	periodic_timer=1
	```
2. Configuration B
	```
	rpc_wrapper=pypresence
	periodic_timer=3
	```
Setting to show playlist info and loop info. Example:
	```
	playlist_info=yes
	loop_info=yes
	```

### To use _`rpc_wrapper=lua-discordRPC`_, Important LuaJIT on mpv
Check [LuaJIT][luajit], because it has [FFI Library][ext_ffi] and it needed by 
[lua-discordRPC][lua-discordRPC].
1. For Linux
    - Make sure your mpv binary linked to luajit~~ not lua~~ library.
		```bash
		ldd $(which mpv) | grep luajit
		libluajit-5.1.so.2 => /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 (0x00007f32e9a83000)
		```
    - If it's dynamic build while it's static build you can check with
		```bash
		mpv -v -V | sed -rn 's/.*(luajit).*/\1/p'
		luajit
		```
2. For Windows ***(Don't worry)***
   - You can skip this because available mpv Windows build by [lachs0r][lachs0r] 
   and [shinchiro][shinchiro] already use LuaJIT and it static build which 
   configured with `--enable-static-build`.
3. For Mac ***(So sad)***
   - Until now, LuaJIT still have problem on Mac OS X. Also build mpv with 
   LuaJIT on Mac OS X (read [mpv issue #1110][mpv issue #1110]), it maybe can 
   build successfully but still can't load LuaJIT properly when run mpv (read 
   [mpv issue #5205][mpv issue #5205]). You can check with `otool` command.

### To use _`rpc_wrapper=pypresence`_, Important to install pypresence
**Support Mac, Windows, and Linux** because can use with [Lua][lua] (lua@5.1, 
lua@5.2) or [LuaJIT][luajit] (luajit).
1. Install [Python 3][python] (python3.4 or python3.6) because this version has 
[asyncio][asyncio] library which needed by pypresence.
2. Install [pypresence][pypresence] `pip3 install pypresence` or `pip3 install 
https://github.com/qwertyquerty/pypresence/archive/master.zip` you can use `pip` 
instead of `pip3` if python2.7 not installed.

You may want to check again, run command `mpv -v -V` and find `luajit` or `lua` 
word on the line which beginning with `[cplayer] List of enabled features:` for 
Mac, Windows or Linux.

---
## Testing
1. Open your Discord then,
2. Open your mpv then,
3. Back to Discord and then check your profile. 


Good Luck and have a nice day.

Feedback: Please make [new issue](https://github.com/cniw/mpv-discordRPC/issues/new) 
if you have question or problem.

[mpv]: https://mpv.io/installation/
[discord]: https://discordapp.com/download
[discord-rpc]: https://github.com/discordapp/discord-rpc
[lua-discordRPC]: https://github.com/pfirsich/lua-discordRPC
[pypresence]: https://github.com/qwertyquerty/pypresence
[status-line]: https://github.com/mpv-player/mpv/raw/master/TOOLS/lua/status-line.lua
[mpv-discordRPC by noaione]: https://github.com/noaione/mpv-discordRPC
[luajit]: http://luajit.org/
[ext_ffi]: http://luajit.org/ext_ffi.html
[lua]: https://www.lua.org/
[mpv issue #1110]: https://github.com/mpv-player/mpv/issues/1110
[mpv issue #5205]: https://github.com/mpv-player/mpv/issues/5205
[lachs0r]: https://mpv.srsfckn.biz/
[shinchiro]: https://sourceforge.net/projects/mpv-player-windows/files
[python]: https://www.python.org/downloads/
[asyncio]: https://docs.python.org/3/library/asyncio.html


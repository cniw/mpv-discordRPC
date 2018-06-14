#!/usr/bin/lua

--	a mpv Player Music script
--	filename: mpv-discordRPC.lua


local options = require 'mp.options'

-- set [options]
local o = {
	rpc_wrapper = "lua-discordRPC",
	--	Available option, to set rpc wrapper:
	--	lua-discordRPC
	--	pypresence
	periodic_timer = 1,
	--	Recommendation value, to set periodic timer:
	--	>= 1 second, if use lua-discordRPC,
	--	>= 3 second, if use pypresence (for the python3::asyncio process),
	--	<= 15 second, because discord-rpc updates every 15 seconds.
}
options.read_options(o)

function discordrpc()
	--	set [media data]
	details = mp.get_property("media-title")
	metadataTitle = mp.get_property_native("metadata/by-key/Title")
	metadataArtist = mp.get_property_native("metadata/by-key/Artist")
	metadataAlbum = mp.get_property_native("metadata/by-key/Album")
	if metadataTitle ~= nil then
		details = metadataTitle
	end
	if metadataArtist ~= nil then
		details = ("%s\nby %s"):format(details, metadataArtist)
	end
	if metadataAlbum ~= nil then
		details = ("%s\non %s"):format(details, metadataAlbum)
	end
	if details == nil then
		details = "No file"
	end
	-- set [state]
	idle = mp.get_property_bool("idle-active")
	coreIdle = mp.get_property_bool("core-idle")
	pausedFC = mp.get_property_bool("paused-for-cache")
	pause = mp.get_property_bool("pause")
	play = coreIdle and false or true
	if idle then
		state = "(Idle)"
		smallImageKey = "player_stop"
		smallImageText = "Idle"
	elseif pausedFC then
		state = ""
		smallImageKey = "player_pause"
		smallImageText = "Buffering"
	elseif pause then
		state = ""
		smallImageText = "Paused"
		smallImageKey = "player_pause"
	elseif play then
		state = "(Playing) "
		smallImageKey = "player_play"
		smallImageText = "Playing"
	end
	if not idle then
		state = state .. mp.get_property("options/term-status-msg")
		smallImageText = ("%s - Playlist: [%s/%s]"):format(smallImageText, mp.get_property("playlist-pos-1"), mp.get_property("playlist-count"))
	end
	--	set [timer]
	timeNow = os.time(os.date("*t"))
	timeRemaining = os.time(os.date("*t", mp.get_property("playtime-remaining")))
	timeUp = timeNow + timeRemaining
	--	set [RPC]
	presence = {
		state = state,
		details = details,
	--	startTimestamp = math.floor(startTime),
		endTimestamp = math.floor(timeUp),
		largeImageKey = "mpv",
		largeImageText = "mpv Media Player",
		smallImageKey = smallImageKey,
		smallImageText = smallImageText,
	}
	if idle then
		presence = {
			state = presence.state,
			details = presence.details,
			startTimestamp = math.floor(startTime),
		--	endTimestamp = presence.endTimestamp,
			largeImageKey = presence.largeImageKey,
			largeImageText = presence.largeImageText,
			smallImageKey = presence.smallImageKey,
			smallImageText = presence.smallImageText
		}
	end
	--	run [RPC]
	if tostring(o.rpc_wrapper) == "lua-discordRPC" then
		-- run [RPC with lua-discordRPC]
		local appId = "448016723057049601"
		local RPC = require("mpv-discordRPC_" .. o.rpc_wrapper)
		RPC.initialize(appId, true)
		RPC.updatePresence(presence)
	elseif tostring(o.rpc_wrapper) == "pypresence" then
		-- set [python path]
		local pythonPath
		local lib
		pythonPath = debug.getinfo(1, "S").short_src:match("(.*/)")
		lib = package.cpath:match("%p[\\|/]?%p(%a+)")
		if lib == "dll" then
			pythonPath = pythonPath:gsub("/","\\\\")
		end
		pythonPath = pythonPath .. "mpv-discordRPC_" .. o.rpc_wrapper .. ".py"
		-- run [RPC with pypresence]
		local todo = idle and "idle" or "not-idle"
		local command = ('python3 "%s" "%s" "%s" "%s" "%s" "%s" "%s" "%s" "%s" "%s" "%s"'):format(pythonPath, todo, presence.state, presence.details, math.floor(startTime), math.floor(timeUp), presence.largeImageKey, presence.largeImageText, presence.smallImageKey, presence.smallImageText, o.periodic_timer)
		mp.register_event('shutdown', function()
			todo = "shutdown"
			command = ('python3 "%s" "%s"'):format(pythonPath, todo)
			io.popen(command)
			os.exit()
		end)
		io.popen(command)
	end
end

--	set [start time]
startTime = os.time(os.date("*t"))

--	call [discordrpc]
mp.add_periodic_timer(o.periodic_timer, discordrpc)


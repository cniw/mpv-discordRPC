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
	playlist_info = "yes",
	--	Valid value to set playlist info: (yes|no)
	loop_info = "yes",
	--	Valid value to set loop info: (yes|no)
	cover_art = "yes",
	--	Valid value to set cover art: (yes|no)
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
		-- set [playlist_info]
		local playlist = ""
		if o.playlist_info == "yes" then
			playlist = (" - Playlist: [%s/%s]"):format(mp.get_property("playlist-pos-1"), mp.get_property("playlist-count"))
		end
		-- set [loop_info]
		local loop = ""
		if o.loop_info == "yes" then
			local loopFile = mp.get_property_bool("loop-file") == false and "" or "file"
			local loopPlaylist = mp.get_property_bool("loop-playlist") == false and "" or "playlist"
			if loopFile ~= "" then
				if loopPlaylist ~= "" then
					loop = ("%s, %s"):format(loopFile, loopPlaylist)
				else
					loop = loopFile
				end
			elseif loopPlaylist ~= "" then
				loop = loopPlaylist
			else
				loop = "disabled"
			end
			loop = (" - Loop: %s"):format(loop)
		end
		state = state .. mp.get_property("options/term-status-msg")
		smallImageText = ("%s%s%s"):format(smallImageText, playlist, loop)
	end
	--	set [timer]
	timeNow = os.time(os.date("*t"))
	timeRemaining = os.time(os.date("*t", mp.get_property("playtime-remaining")))
	timeUp = timeNow + timeRemaining
	-- set [largeImageKey and largeImageText]
	local largeImageKey = "mpv"
	local largeImageText = "mpv Media Player"
	-- set [cover_art]
	if o.cover_art == "yes" then
		local catalogs = require("mpv-discordRPC_catalogs")
		for i in pairs(catalogs) do
			local album = catalogs[i].album
			for j in pairs(album) do
				if album[j] == metadataAlbum then
					local artist = catalogs[i].artist
					for k in pairs(artist) do
						if artist[k] == metadataArtist then
							local number = catalogs[i].number
							largeImageKey = ("coverart_%s"):format(number):gsub("[ /~]", "_"):lower()
							largeImageText = album[j]
						end
					end
				end
			end
		end
	end
	-- streaming mode
	local url = mp.get_property("path")
	local stream = mp.get_property("stream-path")
	if url ~= nil then
		-- checking protocol: http, https
		if string.match(url, "^https?://.*") ~= nil then
			largeImageKey = "mpv_streaming"
			largeImageText = url
		end
		-- checking site: youtube, crunchyroll
		if string.match(url, "www.youtube.com/watch%?v=([a-zA-Z0-9-_]+)&?.*$") ~= nil then
			largeImageKey = "youtube"	-- alternative "youtube_big" or "youtube-2"
			largeImageText = "YouTube"
		elseif string.match(url, "www.crunchyroll.com/.+/.*-([0-9]+)??.*$") ~= nil then
			largeImageKey = "crunchyroll"	-- alternative "crunchyroll_big"
			largeImageText = "Crunchyroll"
		end
	end
	--	set [RPC]
	presence = {
		state = state,
		details = details,
	--	startTimestamp = math.floor(startTime),
		endTimestamp = math.floor(timeUp),
		largeImageKey = largeImageKey,
		largeImageText = largeImageText,
		smallImageKey = smallImageKey,
		smallImageText = smallImageText,
	}
	if url ~= nil and stream == nil then
		presence.state = "(Loading)"
		presence.startTimestamp = math.floor(startTime)
		presence.endTimestamp = nil
	end
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


#!/usr/bin/lua

--	a mpv Player Music script
--	filename: mpv-discordRPC.lua


local discordRPC = require("discordRPC")
local appId = "448016723057049601"

function discordRPC.ready()
	print("Discord: ready")
end

function discordRPC.disconnected(errorCode, message)
	print(string.format("Discord: disconnected (%d: %s)", errorCode, message))
end

function discordRPC.errored(errorCode, message)
	print(string.format("Discord: error (%d: %s)", errorCode, message))
end

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
	discordRPC.initialize(appId, true)
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
	discordRPC.updatePresence(presence)
end

--	set [start time]
startTime = os.time(os.date("*t"))

--	call [discordrpc]
mp.add_periodic_timer(1, discordrpc)


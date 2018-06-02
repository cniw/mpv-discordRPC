#!/usr/bin/env python3

import sys
import pypresence

client_id = "448016723057049601"
pid = 9999

todo = str(sys.argv[1]) if len(sys.argv) > 1 else "shutdown"
state = str(sys.argv[2]) if len(sys.argv) > 2 else "state = (Idle)"
details = str(sys.argv[3]) if len(sys.argv) > 3 else "details = No file"
start = int(sys.argv[4]) if len(sys.argv) > 4 else 1
end = int(sys.argv[4]) if len(sys.argv) > 4 else 1
large_image = str(sys.argv[5]) if len(sys.argv) > 5 else "mpv"
large_text = str(sys.argv[6]) if len(sys.argv) > 6 else "large_text = mpv Media Player"
small_image = str(sys.argv[7]) if len(sys.argv) > 7 else "player_stop"
small_text = str(sys.argv[8]) if len(sys.argv) > 8 else "small_text = Idle"

RPC = pypresence.Presence(client_id)
RPC.connect()

if todo == "shutdown":
	RPC.clear(pid=pid)
elif todo == "idle":
	RPC.update(pid=pid, state=state, details=details, start=start, large_image=large_image, large_text=large_text, small_image=small_image, small_text=small_text)
elif todo == "not-idle":
	RPC.update(pid=pid, state=state, details=details, end=end, large_image=large_image, large_text=large_text, small_image=small_image, small_text=small_text)


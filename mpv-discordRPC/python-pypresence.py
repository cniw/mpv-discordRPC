#!/usr/bin/env python3

import signal
from pathlib import Path
import sys
import time
import os
import pypresence
home = str(Path.home())
print(home)
print("start")
client_id = "448016723057049601"
RPC = pypresence.Presence(client_id)
RPC.connect()
print("pypresence: RPC connected")
while True:
	time.sleep(4)
	pid = 9999
	file = open("/dev/shm/testfile.txt").read().splitlines()
	todo = str(file[1]) if len(file) > 1 else "shutdown"
	state = str(file[2]) if len(file) > 2 else "state = (Idle)"
	details = str(file[3]) if len(file) > 3 else "details = No file"
	start = int(file[4]) if len(file) > 4 else int(time.time())
	end = int(file[5]) if len(file) > 5 else int(time.time() + 60)
	large_image = str(file[6]) if len(file) > 6 else "mpv"
	large_text = str(file[7]) if len(file) > 7 else "large_text = mpv Media Player"
	small_image = str(file[8]) if len(file) > 8 else "player_stop"
	small_text = str(file[9]) if len(file) > 9 else "small_text = Idle"
	periodic_timer = int(file[10]) if len(file) > 10 else 15
	if todo == "shutdown":
		RPC.clear()
		print("pypresence: RPC cleared")
		RPC.close()
		print("pypresence: RPC closed")
		os.system('rm -rf "/dev/shm/testfile.txt"')
		sys.exit()
	elif todo == "idle":
		RPC.update(state=state, details=details, start=start, large_image=large_image, large_text=large_text, small_image=small_image, small_text=small_text)
		print("pypresence: RPC updated.")
	elif todo == "not-idle":
		RPC.update(state=state, details=details, end=end, large_image=large_image, large_text=large_text, small_image=small_image, small_text=small_text)
		print("pypresence: RPC updated")

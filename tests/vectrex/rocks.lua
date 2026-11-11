-- rocks.lua - for tests/vectrex/run.sh, in MAME (-autoboot_script): plays
-- doc/rocks.c, the example game: once its frame counter (FRAME, hex) has
-- started, it fires and turns for 1500 frames, then thrusts without
-- firing until the last life is lost, presses a button on the GAME OVER
-- screen, and 100 frames into the next game prints the frame counter,
-- the score and the high score (6 characters each, at SCORE and HIGH)
-- and the lives (LIVES); or what it has after LIMIT frames
local frame = tonumber(os.getenv("FRAME"), 16)
local score = tonumber(os.getenv("SCORE"), 16)
local high = tonumber(os.getenv("HIGH"), 16)
local lives = tonumber(os.getenv("LIVES"), 16)
local limit = tonumber(os.getenv("LIMIT") or "8000")
local ports = manager.machine.ioport.ports
local button = ports[":BUTTONS"].fields["P1 Button 4"]
local stickx = ports[":CONTR1X"].fields["AD Stick X"]
local sticky = ports[":CONTR1Y"].fields["AD Stick Y"]
local phase = "start"
local frames, mark = 0, 0

local function text(mem, addr)
	local s = ""
	for i = 0, 5 do
		s = s .. string.char(mem:read_u8(addr + i))
	end
	return s
end

emu.register_frame_done(function()
	frames = frames + 1
	local mem = manager.machine.devices[":maincpu"].spaces["program"]
	local f = mem:read_u16(frame)
	local l = mem:read_u8(lives)
	button:set_value(0)
	stickx:set_value(0x80)
	sticky:set_value(0x80)
	if phase == "start" and f > 0 then
		phase = "shoot"
	end
	if phase == "shoot" then
		if f % 16 < 2 then
			button:set_value(1)
		end
		if f % 200 < 50 then
			stickx:set_value(0x20)
		end
		if f >= 1500 then
			phase = "crash"
		end
	elseif phase == "crash" then
		sticky:set_value(0xE0)
		if l == 0 then
			phase, mark = "over", frames
		end
	elseif phase == "over" then
		if frames - mark > 100 and frames % 10 < 2 then
			button:set_value(1)
		end
		if l == 3 then
			phase, mark = "again", frames
		end
	elseif phase == "again" and frames - mark >= 100 then
		phase = "done"
	end
	if phase == "done" or frames >= limit then
		if phase ~= "done" then
			print(string.format("not done after %d frames: %s", frames, phase))
		end
		print(string.format("rocks frame %d score [%s] high [%s] lives %d",
		    f, text(mem, score), text(mem, high), l))
		manager.machine:exit()
	end
end)

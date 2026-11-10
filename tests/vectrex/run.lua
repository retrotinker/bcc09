-- run.lua - for tests/vectrex/run.sh, in MAME (-autoboot_script): stop when
-- the program reaches _exit's loop (STOP, hex: CURPC, as a frame may end
-- partway through an instruction), or after LIMIT frames; print the status
-- (D) and the eight words at RESULTS (hex)
local stop = tonumber(os.getenv("STOP"), 16)
local results = tonumber(os.getenv("RESULTS"), 16)
local limit = tonumber(os.getenv("LIMIT") or "3000")
local frames = 0
emu.register_frame_done(function()
	frames = frames + 1
	local cpu = manager.machine.devices[":maincpu"]
	local pc = cpu.state["CURPC"].value
	if pc == stop or frames >= limit then
		local mem = cpu.spaces["program"]
		if pc == stop then
			print(string.format("stopped, status %04X", cpu.state["D"].value))
		else
			print(string.format("not stopped after %d frames: PC %04X", frames, pc))
		end
		local line = "results"
		for i = 0, 7 do
			line = line .. string.format(" %04X", mem:read_u16(results + 2 * i))
		end
		print(line)
		manager.machine:exit()
	end
end)

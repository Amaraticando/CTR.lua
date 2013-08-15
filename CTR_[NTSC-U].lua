--[[

    This is an utility script for CTR.
    Game: Crash Team Racing [NTSC-U] [SCUS-94426]
    
    
    Emulator: psxjinv2.0.2
    https://code.google.com/p/psxjin/
    
    Script by Rodrigo A. do Amaral (Amaraticando)
    https://www.youtube.com/user/RodrigoAmaral666

]]

TIMETRIAL_ADRESS = 0x001AC795

ram={
	on_level = 0x0008D447,
	environment = 0x0008D0FC,
    track = 0x0008D930,
    character  = 0x00086E84,
    lap = 0x001FFE38
}

ram_track={  --  abs Penta on Coco Park = 0x001AC795
	[3]  = 0,		[7]  = 6760,	[1]  = 78772,	[6]  = 127784,	[16] = 145852,	[9]  = 162636,
	[5]  = 179844,	[8]  = 188720,	[0]  = 197572,	[13] = 200000,	[10] = 211044,	[12] = 211740,
	[4]  = 211932,	[15] = 212564,	[11] = 213252,	[2]  = 214872,	[14] = 215340,	[17] = 224656
}

ram_racer_timetrial={		--	(char_number -> relative adress)		abs speed Penta on Dingo Canyon=0x001DAE1FD
	[13] = 0,		[6]  = 1732,	[9]  = 3332,	[3]  = 4380,	[10] = 4488,
	[12] = 6456,	[2]  = 6476,	[4]  = 6700,	[8]  = 7164,	[14] = 7872,
	[1]  = 8668,	[11] = 9444,	[7]  = 9816,	[0]  = 10260,	[5]  = 10628
}

track_name = {
	[0]  = "Crash Cove",		[1]  = "Roo's Tubes",		[2]  = "Tiger Temple",
	[3]  = "Coco Park",			[4]  = "Mystery Caves",		[5]  = "Blizzard Bluff",
	[6]  = "Sewer Speedway",	[7]  = "Dingo Canyon",		[8]  = "Papu's Pyramid",
	[9]  = "Dragon Mines",		[10] = "Polar Pass",		[11] = "Cortex Castle",
	[12] = "Tiny Arena",		[13] = "Hot Air Skyway",	[14] = "N.Gin Labs",
	[15] = "Oxide Station",		[16] = "Slide Coliseum",	[17] = "Turbo Track"
}

racer_name = {
	[0]  = "Crash Bandicoot",	[1]  = "Dr. Neo Cortex",	[2]  = "Tiny Tiger",	[3]  = "Coco Bandicoot",
	[4]  = "N. Gin",			[5]  = "Dingodile",       	[6]  = "Polar",     	[7]  = "Pura",
	[8]  = "Pinstripe",       	[9]  = "Papu Papu",			[10] = "Ripper Roo",    [11] = "Komodo Joe",
	[12] = "Dr. N. Tropy",    	[13] = "Penta Penguin",     [14] = "Fake Crash",  	[15] = "Nitros Oxide"
}

function info()
	local environment_number = memory.readbyte(ram["environment"])
	local racer_number = memory.readbyte(ram["character"]) or 0
	local track_number = memory.readbyte(ram["track"]) or 0
	
	if racer_number>=0 and racer_number<=15 then 
		gui.text(042, 002, string.format("%s", racer_name[racer_number]))
	end
    if track_number>=0 and track_number<=17 then
		gui.text(042, 010, string.format("%s - Environment %d", track_name[track_number], environment_number))
	end
	
	local adress = TIMETRIAL_ADRESS + ram_track[track_number] + ram_racer_timetrial[racer_number]
	local absSpeed = memory.readbyte(adress)
	local horiSpeed = memory.readbytesigned(adress+2)
	local vertSpeed = memory.readbytesigned(adress+4)
	local turboReserves = memory.readword(adress+85)
	local slideTimer = memory.readword(adress+79)
	local absPos = memory.readbyte(adress+252)
	local absSubPos = memory.readbyte(adress+251)
	local maxAbsPos = memory.readbyte(adress+256)
	local maxAbsSubPos = memory.readbyte(adress+255)
	local jumpTimer = memory.readword(adress+111)
	local landing = memory.readbyte(adress+99)
	
	gui.text(442, 130, string.format("Abs. Sp. = %d", absSpeed))
	gui.text(479, 192, string.format("%3d", horiSpeed))
	gui.text(442, 138, string.format("Vrt. Sp. = %d", vertSpeed))
	gui.text(440, 208, string.format("Turbo = %5d", turboReserves))
	gui.text(434, 192, string.format("%5d", slideTimer))
	gui.text(240, 002, string.format("%3d.%02X/%3d.%02X", absPos, absSubPos, maxAbsPos, maxAbsSubPos))
	gui.text(471, 172, string.format("%5d", jumpTimer))
	gui.text(479, 180, string.format("%3d", landing))
end

function display()
	local on_level = memory.readbytesigned(ram["on_level"])
	if on_level==2 then
		info()
	else
		gui.clearuncommitted()
	end
	return
end

while true do
	display()
	emu.frameadvance()
end

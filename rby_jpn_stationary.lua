--v0.1 rby jpn stationary shiny
--same addresses for rb and y
local addr = 0xcfd8
local atkdef
local spespc


function shiny(atkdef,spespc)
	if spespc == 0xAA then
		if atkdef == 0xA2 or atkdef == 0xA3 or atkdef == 0xA6 or atkdef == 0xA7 or atkdef == 0xAA or atkdef == 0xAB or atkdef == 0xAE or atkdef == 0xAF then
			return true
		else
			return false
		end
	else
		return false
	end
end


state = savestate.create()
savestate.save(state)

while true do
	joypad.set(1, {A=true})
	emu.frameadvance()
	
	atkdef = 0
	spespc = 0
	savestate.save(state)
	
	while atkdef == 0 and spespc == 0 do
		joypad.set(1, {A=false})
		vba.frameadvance()
		atkdef = memory.readbyte(addr)
		spespc = memory.readbyte(addr+1)
	end
	if shiny(atkdef,spespc) then
		print("Shiny!!! Script stopped.")
		print(string.format("atk: %d", math.floor(atkdef/16)))
		print(string.format("def: %d", atkdef%16))
		print(string.format("spe: %d", math.floor(spespc/16)))
		print(string.format("spe: %d", spespc%16))
		savestate.save(state)
		break
	else
		savestate.load(state)
	end
	
	
end

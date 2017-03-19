-- v0.1 fish usa

local a_flagbite = 0xcd3d
--kingler
local target = 0x8a
local a_fished_species = 0xd059
local atkdef
local spespca

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
	emu.frameadvance()
	joypad.set(1, {A=true})
	emu.frameadvance()
	i=0
	--aspettiamo i risultati della pesca
	while i < 130 do
		emu.frameadvance()
		i = i+1
	end
	fished = memory.readbyte(a_flagbite)
	if fished == 0x2 then
		print("you're fishing where there are no pokémon")
		break
	elseif fished == 0x1 then
		--pescato qualcosa, vediamo se è la specie cercata
		if memory.readbyte(a_fished_species) == target then
			savestate.save(state)
			print("species found, now searching for ivs")
			i = 0;
			--aspetta che finisca il dialogo
			while i<210 do
				joypad.set(1, {A=true})
				emu.frameadvance()
				i= i+1
			end
			while true do
				emu.frameadvance()
				savestate.save(state)
				atkdef = 0
				spespc = 0
				while memory.readbyte(0xc027)~=0xf0 do
					
					joypad.set(1, {A=true})
					emu.frameadvance()
					atkdef = memory.readbyte(0xcff1)
					spespc = memory.readbyte(0xcff2)
				end
				atkdef = memory.readbyte(0xcff1)
				spespc = memory.readbyte(0xcff2)
				--atkdef = memory.readbyte(0xcff1)
				--spespc = memory.readbyte(0xcff2)
				print(atkdef)
				print(spespc)
				if shiny(atkdef,spespc) then
					print("shiny found")
					return
				else
					savestate.load(state)
				end
			end
		else
			--specie sbagliata
			savestate.load(state)
		end
	else
		--non ho pescato niente
		savestate.load(state)
	end
		
	

end

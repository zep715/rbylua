-- v0.1 fishbot
--set up species, look for serebii for fishable pokemon in your area and look
--http://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_index_number_(Generation_I)
--for index number and set in target
--example horsea
--local target = 92
local target

--da confermare per giallo e rbg/giapponesi
local a_flagbite = 0xcd3d

local a_fished_species
local ivs_addr
local version = memory.readword(0x14e)
if version == 0xc1a2 or version == 0x36dc or version == 0xd5dd or version == 0x299c then
	print("RBGY JAP detected")
	a_fished_species = 0xd036
	ivs_addr = 0xcfd8
elseif version == 0xe691 or version == 0xa9d then
	print("Red/Blue USA detected")
	a_fished_species = 0xd059
	ivs_addr = 0xcff1
elseif version == 0x7c04 then
	print("Yellow USA detected")
	a_fished_species = 0xd058
	ivs_addr = 0xcff0
elseif version == 0xd289 or version == 0x9c5e or version == 0xdc5c or version == 0xbc2e or version == 0x4a38 or version == 0xd714 or version == 0xfc7a or version == 0xa456 then
	print("Red/Blue EUR detected")
	a_fished_species = 0xd05e
	ivs_addr = 0xcff6
elseif version == 0x8f4e or version == 0xfb66 or version == 0x3756 or version == 0xc1b7 then
	print("Yellow EUR detected")
	a_fished_species = 0xd05d
	ivs_addr = 0xcff5
else
	print(string.format("unknown version, code: %4x", version))
  print("script stopped")
  return
end

local atkdef
local spespc

function shiny(atkdef,spespc)
	if spespc == 0xAA then
		if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
			return true
		else
			return false
		end
	else
		return false
	end
end

if target == nil then
	print("You have not setup any species")
	return
end

state = savestate.create()
savestate.save(state)
while true do
	emu.frameadvance()
	savestate.save(state)
	joypad.set(1, {A=true})
	emu.frameadvance()
	i=0
	--aspettiamo i risultati della pesca
	while i < 200 do
		emu.frameadvance()
		i = i+1
	end
	fished = memory.readbyte(a_flagbite)
	if fished == 0x2 then
		print("You're fishing where there are no pokemon")
		break
	elseif fished == 0x1 then
		--pescato qualcosa, vediamo se è la specie cercata
		if memory.readbyte(a_fished_species) == target then
			savestate.save(state)
			print("Species found, now searching for ivs")
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
					atkdef = memory.readbyte(ivs_addr)
					spespc = memory.readbyte(ivs_addr+1)
				end
				atkdef = memory.readbyte(ivs_addr)
				spespc = memory.readbyte(ivs_addr+1)
				print(atkdef)
				print(spespc)
				if shiny(atkdef,spespc) then
					print("Shiny!!! Script stopped.")
        				print(string.format("Atk: %d", math.floor(atkdef/16)))
       					print(string.format("Def: %d", atkdef%16))
       		 			print(string.format("Spe: %d", math.floor(spespc/16)))
        				print(string.format("Spc: %d", spespc%16))
					return
				else
					print("Wrong ivs")
					savestate.load(state)
				end
			end
		else
			--specie sbagliata
			print("Wrong species")
			savestate.load(state)
		end
	else
		--non ho pescato niente
		print("Nothing bited")
		savestate.load(state)
	end



end

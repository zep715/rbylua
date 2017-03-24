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
	a_fished_species = 0xd036
	ivs_addr = 0xcfd8
elseif version == 0xe691 or version == 0xa9d then
	print("RB USA detected")
	a_fished_species = 0xd059
	ivs_addr = 0xcff1
elseif version == 0x7c04 then
	print("Y USA detected")
	a_fished_species = 0xd058
	ivs_addr = 0xcff0
elseif version == 0xd289 or version == 0x9c5e or version == 0xdc5c or version == 0xbc2e or version == 0x4a38 or version == 0xd714 or version == 0xfc7a or version == 0xa456 then
	print("RB EUR detected")
	a_fished_species = 0xd05e
	ivs_addr = 0xcff6
elseif version == 0x8f4e or version == 0xfb66 or version == 0x3756 or version == 0xc1b7 then
	print("Y EUR detected")
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
		if atkdef == 0xA2 or atkdef == 0xA3 or atkdef == 0xA6 or atkdef == 0xA7 or atkdef == 0xAA or atkdef == 0xAB or atkdef == 0xAE or atkdef == 0xAF then
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
		print("you're fishing where there are no pokemon")
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
					atkdef = memory.readbyte(ivs_addr)
					spespc = memory.readbyte(ivs_addr+1)
				end
				atkdef = memory.readbyte(ivs_addr)
				spespc = memory.readbyte(ivs_addr+1)
				print(atkdef)
				print(spespc)
				if shiny(atkdef,spespc) then
					print("shiny found")
					return
				else
					print("wrong ivs")
					savestate.load(state)
				end
			end
		else
			--specie sbagliata
			print("wrong species")
			savestate.load(state)
		end
	else
		--non ho pescato niente
		print("nothing bited")
		savestate.load(state)
	end
		
	

end

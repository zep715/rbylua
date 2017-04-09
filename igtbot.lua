local version = memory.readword(0x14e)
local base_address
local atkdef
local spespc
--0 for maximum speed, 1 for count SRs
local countsr = 0 
i=1

        print("RBGY In-Game Trade Bot by zep715")
        print("Optimised/Edited by LegoFigure11 | Available at http://spo.ink/gen1bot")


if version == 0xc1a2 or version == 0x36dc or version == 0xd5dd or version == 0x299c then
	print("RBGY JPN game detected")
  base_address = 0xd123
elseif version == 0xe691 or version == 0xa9d then
	print("RB USA detected")
  base_address = 0xd163
elseif version == 0x7c04 then
	print("Yellow USA detected")
  base_address = 0xd162
elseif version == 0xd289 or version == 0x9c5e or version == 0xdc5c or version == 0xbc2e or version == 0x4a38 or version == 0xd714 or version == 0xfc7a or version == 0xa456 then
	print("RB EUR detected")
  base_address = 0xd168
elseif version == 0x8f4e or version == 0xfb66 or version == 0x3756 or version == 0xc1b7 then
	print("Yellow EUR detected")
  base_address = 0xd167
else
	print(string.format("unknown version, code: %4x", version))
  print("script stopped")
  return
end
        print("Bot in progress, please wait...")

local partyno = memory.readbyte(base_address)-1
local dv_addr = (base_address+0x23)+partyno*0x2C

 
 
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
   
    atkdef = memory.readbyte(dv_addr)
    spespc = memory.readbyte(dv_addr+1)
    savestate.save(state)
	joypad.set(1, {A=true})
	emu.frameadvance()
	atkdef_prec = memory.readbyte(dv_addr)
	spespc_prec = memory.readbyte(dv_addr+1)
    while atkdef == atkdef_prec and spespc == spespc_prec do
        
        vba.frameadvance()
        atkdef = memory.readbyte(dv_addr)
        spespc = memory.readbyte(dv_addr+1)
    end
    if shiny(atkdef,spespc) then
        print(string.format("Shiny!!! Script stopped. No. SRs: ", i))
        print(string.format("Atk: %d", math.floor(atkdef/16)))
        print(string.format("Def: %d", atkdef%16))
        print(string.format("Spc: %d", math.floor(spespc/16)))
        print(string.format("Spe: %d", spespc%16))
        savestate.save(state)
        break
    else
    if countsr == 1 then
	print(string.format("SRs: ", i))
        i=i+1
        savestate.load(state)
    else
	i=i+1
	savestate.load(state)
    end
   
   
end
end

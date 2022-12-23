--The script is going to search a pokemon.
--The script is going to shiny hunt the first one
--that the script find

-- This is an upgrade of LegoFigure11 fishbot.lua

--"Write 7 if you want to get no shiny IVs"
--local op = 7
local op

local a_fished_species
local ivs_addr
local version = memory.readword(0x14e)

local cont = 0

print("RBGY Auto Fishing Bot by Phosky71")
print("Optimised/Edited by Phosky71 | Available at https://github.com/Phosky71/rbylua")

if version == 0xc1a2 or version == 0x36dc or version == 0xd5dd or version == 0x299c then
    a_fished_species = 0xd036
    ivs_addr = 0xcfd8
elseif version == 0xe691 or version == 0xa9d then
    print("RB USA detected")
    a_fished_species = 0xd059
    ivs_addr = 0xcff1
elseif version == 0x7c04 then
    print("Yellow USA detected")
    a_fished_species = 0xd058
    ivs_addr = 0xcff0
elseif version == 0xd289 or version == 0x9c5e or version == 0xdc5c or version == 0xbc2e or version == 0x4a38 or version == 0xd714 or version == 0xfc7a or version == 0xa456 then
    print("RB EUR detected")
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

function shiny(atkdef, spespc)
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

print("Searching species, please wait...")
state = savestate.create()
savestate.save(state)
while true do
	if op==7 then 
	
    emu.frameadvance()
    savestate.save(state)
    joypad.set(1, { A = true })
    emu.frameadvance()
    i = 0
    --We await the fishing results
    while i < 200 do
        emu.frameadvance()
        i = i + 1
    end

    local target
    target = memory.readbyte(a_fished_species)

    local a_flagbite = 0xcd3d
    s = 1
    q = 1

    if target == 24 then
        target_species = "Tentacool"
    else
        if target == 23 then
            target_species = "Shellder"
        else
            if target == 8 then
                target_species = "Slowbro"
            else
                if target == 19 then
                    target_species = "Lapras"
                else
                    if target == 22 then
                        target_species = "Gyarados"
                    else
                        if target == 27 then
                            target_species = "Staryu"
                        else
                            if target == 37 then
                                target_species = "Slowpoke"
                            else
                                if target == 47 then
                                    target_species = "Psyduck"
                                else
                                    if target == 58 then
                                        target_species = "Seel"
                                    else
                                        if target == 66 then
                                            target_species = "Dragonite"
                                        else
                                            if target == 71 then
                                                target_species = "Poliwag"
                                            else
                                                if target == 78 then
                                                    target_species = "Krabby"
                                                else
                                                    if target == 88 then
                                                        target_species = "Dratini"
                                                    else
                                                        if target == 89 then
                                                            target_species = "Dragonair"
                                                        else
                                                            if target == 92 then
                                                                target_species = "Horsea"
                                                            else
                                                                if target == 93 then
                                                                    target_species = "Seadra"
                                                                else
                                                                    if target == 110 then
                                                                        target_species = "Poliwhirl"
                                                                    else
                                                                        if target == 128 then
                                                                            target_species = "Dewgong"
                                                                        else
                                                                            if target == 128 then
                                                                                target_species = "Golduck"
                                                                            else
                                                                                if target == 133 then
                                                                                    target_species = "Magikarp"
                                                                                else
                                                                                    if target == 138 then
                                                                                        target_species = "Kingler"
                                                                                    else
                                                                                        if target == 139 then
                                                                                            target_species = "Cloyster"
                                                                                        else
                                                                                            if target == 152 then
                                                                                                target_species = "Starmie"
                                                                                            else
                                                                                                if target == 155 then
                                                                                                    target_species = "Tentacruel"
                                                                                                else
                                                                                                    if target == 157 then
                                                                                                        target_species = "Goldeen"
                                                                                                    else
                                                                                                        if target == 158 then
                                                                                                            target_species = "Seaking"
                                                                                                        else
                                                                                                            target = nil
                                                                                                        end
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    fished = memory.readbyte(a_flagbite)
    if fished == 0x2 then
        print("You're fishing where there are no Pokemon.")
        break
    elseif fished == 0x1 then
        --Caught something. Starting...
        if memory.readbyte(a_fished_species) == target then
            savestate.save(state)
            print(string.format("%s found. ",target_species) .. "Searching for shiny, please wait...")
            i = 0;
            --We wait for the dialogue to end
            while i < 210 do
                joypad.set(1, { A = true })
                emu.frameadvance()
                i = i + 1
            end
            while true do
                emu.frameadvance()
                savestate.save(state)
                atkdef = 0
                spespc = 0
                while memory.readbyte(0xc027) ~= 0xf0 do

                    joypad.set(1, { A = true })
                    emu.frameadvance()
                    atkdef = memory.readbyte(ivs_addr)
                    spespc = memory.readbyte(ivs_addr + 1)
                end
                atkdef = memory.readbyte(ivs_addr)
                spespc = memory.readbyte(ivs_addr + 1)
                if shiny(atkdef, spespc) then
                    print("Shiny found!!! Script stopped. SRs: " .. q - 1)
                    print(string.format("Atk: %d", math.floor(atkdef / 16)))
                    print(string.format("Def: %d", atkdef % 16))
                    print(string.format("Spc: %d", math.floor(spespc / 16)))
                    print(string.format("Spe: %d", spespc % 16))
                    return
                else
					cont = cont +1
					print(string.format("Wrong ivs. Reset: %d", cont))
					print(string.format("Atk: %d", math.floor(atkdef / 16)))
                    print(string.format("Def: %d", atkdef % 16))
                    print(string.format("Spc: %d", math.floor(spespc / 16)))
                    print(string.format("Spe: %d", spespc % 16))
                    q = q + 1
                    savestate.load(state)
                end
            end
        else
            s = s + 1
            savestate.load(state)
        end
    else
        s = s + 1
        savestate.load(state)

    end
	
	else
	
    emu.frameadvance()
    savestate.save(state)
    joypad.set(1, { A = true })
    emu.frameadvance()
    i = 0
    --We await the fishing results
    while i < 200 do
        emu.frameadvance()
        i = i + 1
    end

    local target
    target = memory.readbyte(a_fished_species)

    local a_flagbite = 0xcd3d
    s = 1
    q = 1

    if target == 24 then
        target_species = "Tentacool"
    else
        if target == 23 then
            target_species = "Shellder"
        else
            if target == 8 then
                target_species = "Slowbro"
            else
                if target == 19 then
                    target_species = "Lapras"
                else
                    if target == 22 then
                        target_species = "Gyarados"
                    else
                        if target == 27 then
                            target_species = "Staryu"
                        else
                            if target == 37 then
                                target_species = "Slowpoke"
                            else
                                if target == 47 then
                                    target_species = "Psyduck"
                                else
                                    if target == 58 then
                                        target_species = "Seel"
                                    else
                                        if target == 66 then
                                            target_species = "Dragonite"
                                        else
                                            if target == 71 then
                                                target_species = "Poliwag"
                                            else
                                                if target == 78 then
                                                    target_species = "Krabby"
                                                else
                                                    if target == 88 then
                                                        target_species = "Dratini"
                                                    else
                                                        if target == 89 then
                                                            target_species = "Dragonair"
                                                        else
                                                            if target == 92 then
                                                                target_species = "Horsea"
                                                            else
                                                                if target == 93 then
                                                                    target_species = "Seadra"
                                                                else
                                                                    if target == 110 then
                                                                        target_species = "Poliwhirl"
                                                                    else
                                                                        if target == 128 then
                                                                            target_species = "Dewgong"
                                                                        else
                                                                            if target == 128 then
                                                                                target_species = "Golduck"
                                                                            else
                                                                                if target == 133 then
                                                                                    target_species = "Magikarp"
                                                                                else
                                                                                    if target == 138 then
                                                                                        target_species = "Kingler"
                                                                                    else
                                                                                        if target == 139 then
                                                                                            target_species = "Cloyster"
                                                                                        else
                                                                                            if target == 152 then
                                                                                                target_species = "Starmie"
                                                                                            else
                                                                                                if target == 155 then
                                                                                                    target_species = "Tentacruel"
                                                                                                else
                                                                                                    if target == 157 then
                                                                                                        target_species = "Goldeen"
                                                                                                    else
                                                                                                        if target == 158 then
                                                                                                            target_species = "Seaking"
                                                                                                        else
                                                                                                            target = nil
                                                                                                        end
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    fished = memory.readbyte(a_flagbite)
    if fished == 0x2 then
        print("You're fishing where there are no Pokemon.")
        break
    elseif fished == 0x1 then
        --Caught something. Starting...
        if memory.readbyte(a_fished_species) == target then
            savestate.save(state)
            print(string.format("%s found. ",target_species) .. "Searching for shiny, please wait...")
            i = 0;
            --We wait for the dialogue to end
            while i < 210 do
                joypad.set(1, { A = true })
                emu.frameadvance()
                i = i + 1
            end
            while true do
                emu.frameadvance()
                savestate.save(state)
                atkdef = 0
                spespc = 0
                while memory.readbyte(0xc027) ~= 0xf0 do

                    joypad.set(1, { A = true })
                    emu.frameadvance()
                    atkdef = memory.readbyte(ivs_addr)
                    spespc = memory.readbyte(ivs_addr + 1)
                end
                atkdef = memory.readbyte(ivs_addr)
                spespc = memory.readbyte(ivs_addr + 1)
                if shiny(atkdef, spespc) then
                    print("Shiny found!!! Script stopped. SRs: " .. q - 1)
                    print(string.format("Atk: %d", math.floor(atkdef / 16)))
                    print(string.format("Def: %d", atkdef % 16))
                    print(string.format("Spc: %d", math.floor(spespc / 16)))
                    print(string.format("Spe: %d", spespc % 16))
                    return
                else
					cont = cont +1
					print(string.format("Wrong ivs. Reset: %d", cont))
                    q = q + 1
                    savestate.load(state)
                end
            end
        else
            s = s + 1
            savestate.load(state)
        end
    else
        s = s + 1
        savestate.load(state)

    end
	
	end 

end
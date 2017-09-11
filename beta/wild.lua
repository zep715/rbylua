local battle_flag = 0xc027
local battle = 0
local i
local atkdef
local spespc
local state = savestate.create()
savestate.save(state)

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

while true do
    battle = memory.readbyte(battle_flag)
    i = 0
    emu.frameadvance()

    savestate.save(state)
    --print("salvato")
    while battle ~= 0xf0 do
        if i <31 then
            --print("prima regione")
            joypad.set(1, {left=false})
            joypad.set(1, {right=true})

        else
            --print("seconda regione")
            joypad.set(1, {right=false})
            joypad.set(1, {left=true})
        end
        emu.frameadvance()
        battle = memory.readbyte(battle_flag)
        i = (i+1)%65
    end
    atkdef = memory.readbyte(0xcff1)
    spespc  =memory.readbyte(0xcff2)

    if shiny(atkdef, spespc) then
        print("found")
        break
    else
        print(atkdef)
        print(spespc)
        savestate.load(state)
    end
end

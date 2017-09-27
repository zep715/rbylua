--rewritten /u/itsprofoak lua script, more compact code with automatic check version
naturename={
	 "Hardy","Lonely","Brave","Adamant","Naughty",
	 "Bold","Docile","Relaxed","Impish","Lax",
	 "Timid","Hasty","Serious","Jolly","Naive",
	 "Modest","Mild","Quiet","Bashful","Rash",
	 "Calm","Gentle","Sassy","Careful","Quirky"}

function shiny(atkdef,spespc)
	if spespc == 0xAA then
		if atkdef == 0x2A or atkdef == 0x3A or atkdef == 0x6A or atkdef == 0x7A or atkdef == 0xAA or atkdef == 0xBA or atkdef == 0xEA or atkdef == 0xFA then
			return " shiny"
		else
			return ""
		end
	else
		return ""
	end
end

version = memory.readword(0x14e)
if version == 0xc1a2 or version == 0x36dc or version == 0xd5dd or version == 0x299c then
	print("RBGY JPN game detected")
	partystart = 0xd12b
elseif version == 0xe691 or version == 0xa9d then
	print("red/blue USA detected")
	partystart = 0xd16b
elseif version == 0x7c04 then
	print("yellow USA detected")
	partystart = 0xd16a
elseif version == 0xd289 or version == 0x9c5e or version == 0xdc5c or version == 0xbc2e or version == 0x4a38 or version == 0xd714 or version == 0xfc7a or version == 0xa456 then
	print("red/blue EUR detected")
	partystart = 0xd170
elseif version == 0x8f4e or version == 0xfb66 or version == 0x3756 or version == 0xc1b7 then
	print("yellow EUR detected")
	partystart = 0xd16f
else
	print(string.format("unknown versione, code: %4x", version))
	print("script stopped")
	return
end

while true do
	partysize = memory.readbyte(partystart-8)-1
	
	p = 1
	for i = (partystart+0xe),(partystart+ 0xe +partysize*0x2c),0x2c do
		pexp =  0x10000*memory.readbyte(i)+0x100*memory.readbyte(i+1) + memory.readbyte(i+2)
		gui.text(2,p*10,tostring(p).." "..naturename[pexp%25+1]..shiny(memory.readbyte(i+0xd), memory.readbyte(i+0xe)))
		p = p+1
	end
	emu.frameadvance()
end

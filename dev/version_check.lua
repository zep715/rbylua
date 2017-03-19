
local version = memory.readword(0x14e)

if version == 0xc1a2 or version == 0x36dc or version == 0xd5dd or version == 0x299c then
	print("RBY JPN game detected")
elseif version == 0xe691 or version == 0xa9d then
	print("red/blue USA detected")
elseif version == 0x7c04 then
	print("yellow USA detected")
elseif version == 0xd289 or version == 0x9c5e or version == 0xdc5c or version == 0xbc2e or version == 0x4a38 or version == 0xd714 or version == 0xfc7a or version == 0xa456 then
	print("red/blue EUR detected")
elseif version == 0x8f4e or version == 0xfb66 or version == 0x3756 or version == 0xc1b7 then
	print("yellow EUR detected")
else
	print(string.format("unknown versione, code: %4x", version))
end

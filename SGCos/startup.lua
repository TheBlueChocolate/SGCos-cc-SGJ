local path = fs.find("*SGCos/dial-V1.0.0.lua")
if not path[1] then path = fs.find("*/SGCos/dial-V1.0.0.lua") end
shell.execute(path[1])

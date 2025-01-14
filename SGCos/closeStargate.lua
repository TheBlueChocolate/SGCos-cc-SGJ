interface = peripheral.find("advanced_crystal_interface")
if interface == nil then
    interface = peripheral.find("crystal_interface")
    if interface == nil then
        interface = peripheral.find("basic_interface")
        if interface == nil then
            printError("error:could not find a valid interface")
            return
        end
    end
end
if interface.isStargateConnected() then
	interface.disconnectStargate()
else
	printError("stargate is not connected")
end
if not (interface.isStargateConnected()) then
	print("stargate disconnected")
else
	printError("error:could not disconnect the stargate")
end
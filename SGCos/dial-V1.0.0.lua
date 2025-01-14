
-- interface initialisation
for i=1,10,1 do
	interface = peripheral.find("advanced_crystal_interface")
	if not interface then
		interface = peripheral.find("crystal_interface")
		if not interface then
			interface = peripheral.find("basic_interface")
			if interface then
				interfaceType = 1
				break
			end
		else interfaceType = 2
			 break
		end
	else interfaceType = 3
		 break
	end
	sleep(0.05)
end
if not interface then
	printError("error: could not find a valid interface")
	return
end

function table.find(table, data, field)		-- find a given string in a table at the "field" position. field can be nil if table only has one argument.
	if field ~= nil then
		for i=1, #table, 1 do
			if table[i][field] == data then
				return i
			end
		end
	else
		for i=1, #table, 1 do
			if table[i] == data then
				return i
			end
		end
	end
    return nil
end
function table.match(table, data, searchField, getField)	--	return the "getField" data corresponding to the line where "searchField" is "data"
	for i,v in pairs(table) do
		if v[searchField] == data then
			return v[getField]
		end
	end
	return nil
end

function configInit()							-- data initialisation
	local path = fs.find("*SGCos/config.cfg")
	if not path[1] then path = fs.find("*/SGCos/config.cfg") end
    local file = fs.open(path[1], "r")
    config = {}
    while true do
        local line = file.readLine()
        if not line then break end
        local sepLine = {}
        local breaking = string.find(line, "//")
        if line ~= nil then
            for word in line:gmatch("%S+") do
                table.insert(sepLine, word)
            end
            if sepLine[2] ~= nil and string.find(sepLine[1],"//") == nil and string.find(sepLine[2],"//") == nil then
				if sepLine[2] == "true" then
					config[sepLine[1]] = true
				elseif sepLine[2] == "false" then
					config[sepLine[1]] = false
				else
					config[sepLine[1]] = sepLine[2]
				end
            end
        end
    end
	
		-- supplements
	generation = interface.getStargateGeneration()
	if interface.getStargateType() == "sgjourney:tollan_stargate" then generation = 2.5 end
	irisChevronClosing = tonumber(string.match(config["irisConfig"], "%d"))
	if irisChevronClosing == nil then irisChevronClosing = -1 end		-- set the maximum chevron the iris shall close on when recieving a connection to prevent the iris destruction
	if generation == 3 and irisChevronClosing > 1 then irisChevronLimit = 1
	else irisChevronLimit = 3
	end
	chevronCoord = {{10,0},{10,3},{10,6},{7,7},		-- used to display the chevrons on the monitor
	{3,7},{0,6},{0,3},{0,0},{5,0}}
	if generation == 1 and config["overrideDHD"] == false or config["overrideDHD"] == "35" then
		DHDgeneration = 1
		DHDkeysPos = {[0] = 
		{ 5,4},{ 5,3},{ 6,2},{ 8,1},{12,1},{17,1},{21,1},{23,2},{24,3},{24,4},{24,5},{24,6},
		{23,7},{21,8},{17,8},{12,8},{ 8,8},{ 6,7},{ 5,6},{ 5,5},{ 9,4},{ 9,3},{10,2},{13,2},
		{16,2},{19,2},{20,3},{20,4},{20,5},{20,6},{19,7},{16,7},{13,7},{10,7},{ 9,6},{ 9,5}}
		DHDkeysType = {{4,0,2},{5,1,2},{13,1,1},{15,1,2},{19,0,2},{22,1,2},{24,0,1},{30,1,2},{32,0,1},{35,1,2}}
	elseif generation <= 2 and config["overrideDHD"] == false or config["overrideDHD"] == "38" then
		DHDgeneration = 2
		DHDkeysPos = {[0] = {0,9},
		{ 4,4},{ 4,3},{ 5,2},{ 6,1},{ 9,1},{12,1},{16,1},{19,1},{22,1},{23,2},{24,3},{24,4},
		{24,5},{24,6},{23,7},{22,8},{19,8},{16,8},{12,8},{ 9,8},{ 6,8},{ 5,7},{ 4,6},{ 4,5},
		{ 8,4},{ 8,3},{10,2},{14,2},{18,2},{20,3},{20,4},{20,5},{20,6},{18,7},{14,7},{10,7},{8,6},{8,5}}
		DHDkeysType = {{6,0,2},{18,1,1},{24,0,2},{38,1,2}}
	else
		DHDgeneration = 3
		DHDkeysPos = {[0] =
		{1,4},{1,3},{ 2,2},{ 3,1},{26,1},{27,2},{28,3},{28,4},{28,5},{28,6},{27,7},{26,8},{ 3,8},{ 2,7},{1,6},{1,5},
		{5,4},{5,3},{ 6,2},{ 7,1},{22,1},{23,2},{24,3},{24,4},{24,5},{24,6},{23,7},{22,8},{ 7,8},{ 6,7},{5,6},{5,5},
		{9,4},{9,3},{10,2},{13,2},{16,2},{19,2},{20,3},{20,4},{20,5},{20,6},{19,7},{16,7},{13,7},{10,7},{9,6},{9,5}}
		DHDkeysType = {{3,0,2},{11,1,1},{15,0,2},{33,1,2},{34,1,1},{36,0,1},{37,0,2},{41,1,2},{42,0,2},{44,0,1},{45,1,1},{47,1,2}}
	end
	
	--Adjustments
	config["gateColor"] = tonumber("0x"..config["gateColor"])
	config["chevronOffColor"] = tonumber("0x"..config["chevronOffColor"])
	config["chevronOnColor"] = tonumber("0x"..config["chevronOnColor"])
	config["vortexColor"] = tonumber("0x"..config["vortexColor"])
	config["vortexWhiteColor"] = tonumber("0x"..config["vortexWhiteColor"])
	config["irisConfig"] = string.match(config["irisConfig"], "%a+")
	config["textScale"] = tonumber(config["textScale"])
    config["milkyMinRota"] = tonumber(config["milkyMinRota"])
	config["milkyResetSymbol"] = tonumber(config["milkyResetSymbol"])
	
	config["milkyDialNum"] = tonumber(string.match(config["milkyDial"], "%d+.*%d*"))	-- get the float of the dialing operation
	config["milkyDial"] = string.match(config["milkyDial"], "%a+")						-- remove the additional number
	if config["milkyDialNum"] == nil then config["milkyDialNum"] = 0 end				-- always get a number value
	
	for i = 7, 9, 1 do			-- transform the chevron order strings to an int table
		local toTable = {}
		for j = 1, 8, 1 do
			toTable[j] = tonumber(config["chevronOrder"..i]:sub(j,j))
		end
		config["chevronOrder"..i] = toTable
	end
end
function dataInit()	
	local path = fs.find("*SGCos")
	if not path[1] then path = fs.find("*/SGCos") end
	path = path[1].."/"
	-- GDO
    file = fs.open(path .."GDO.txt", "r")
	for j=1,3,1 do file.readLine() end
    GDOcodes = {}
    while true do
        local line = file.readLine()
        if not line then break end
        local sepLine = {}
		for word in line:gmatch("%S+") do
			table.insert(sepLine, word)
		end
		GDOcodes[sepLine[1]] = {
		["frequency"] = tonumber(sepLine[2]),
		["code"] = tonumber(sepLine[3]),
		["command"] = sepLine[4] }
	end

	-- solSysAd
	file = fs.open(path .."solarSystems.txt", "r")
	for j=1,3,1 do file.readLine() end
	solSysAd = {}
	while true do
		local line = file.readLine()
		if not line then break end
		local sepLine = {}
		for word in line:gmatch("%S+") do table.insert(sepLine, word) end
		solSysAd[#solSysAd + 1] = {
				["name"] = sepLine[1],
				["address7"] = sepLine[2],
				["address8"] = sepLine[3],
				["galaxy"] = sepLine[4] }
	end
	-- gateAd
	-- file = fs.open(path .."gateAddresses.txt", "r")
	local publicFile = fs.open(path .."gateAddresses-public.txt", "r")
	local factionFile = fs.open(path .."gateAddresses-faction.txt", "r")
	local privateFile = fs.open(path .."gateAddresses-private.txt", "r")
	gateAd = {}
	for _, file in pairs({publicFile,factionFile,privateFile}) do
		for i = 1,3,1 do file.readLine() end
		while true do
			local line = file.readLine()
			if not line then break end
			local sepLine = {}
			for word in line:gmatch("%S+") do table.insert(sepLine, word) end
			gateAd[#gateAd + 1] = {
				  ["name"] = sepLine[1],
				  ["address9"] = sepLine[2],
				  ["solSys"] = sepLine[3] }
		end
	end
	
	
	--addresses config file
    file = fs.open(path .."addressConfig.txt","r+")
    for i=1,3,1 do file.readLine() end
    local sepLine = {}
    local adNames = {}
    while true do
        local line = file.readLine()
        if not line then break end
        sepLine = require "cc.strings".split(line," , ",true, 2)
        adNames[#adNames+1] = sepLine[1]
    end
	
	
    for i=1, #solSysAd, 1 do 	-- fill the missing addresses in the addresses setting file
        if table.find(adNames,solSysAd[i]["name"]) == nil then
            file.writeLine(solSysAd[i]["name"] .. " , default , default , default")
        end
    end
	for i=1, #gateAd, 1 do
		if table.find(adNames,gateAd[i]["name"]) == nil then
            file.writeLine(gateAd[i]["name"] .. " , default , none , none , default , default , all")
        end
	end
	file.seek("set",1)
	for i=1,3,1 do file.readLine() end
	adConfig = {}
	while true do		-- readable data table
        local line = file.readLine()
        if not line then break end
		local sepLine = require "cc.strings".split(line," , ",true, 7)
		if not sepLine[7] then
			adConfig[sepLine[1]] = {
					["irisConfig"] = sepLine[2],
					["pegSymbols"] = sepLine[3],
					["pegPOO"] = sepLine[4] }
		else
			local sepSendCode = require "cc.strings".split(sepLine[3],".",true, 2)
			local sepReceiveCode = require "cc.strings".split(sepLine[4],".",true, 2)
			adConfig[sepLine[1]] = {
					["irisConfig"] = sepLine[2],
					["pegSymbols"] = sepLine[5],
					["pegPOO"] = sepLine[6],
					["groups"] = sepLine[7],
					["sendF"] = tonumber(sepSendCode[1]),
					["sendC"] = tonumber(sepSendCode[2]),
					["receiveF"] = tonumber(sepReceiveCode[1]),
					["receiveC"] = tonumber(sepReceiveCode[2]) }
		end
		for i,v in pairs({"irisConfig","pegSymbols","pegPOO"}) do
			if adConfig[sepLine[1]][v] == "default" then
				adConfig[sepLine[1]][v] = nil
			end
		end
    end
	-- find the groups
	groups = {}
	for i,value in pairs(adConfig) do
		if value["groups"] ~= nil then
			local sepLine = require "cc.strings".split(value["groups"],",",true,20)
			for j=1,#sepLine,1 do
				if table.find(groups,sepLine[j]) == nil then
					table.insert(groups, sepLine[j])
				end
			end
		end
	end
	table.sort(groups)
	
	-- adjustments
	if interfaceType == 3 then
		config["localAddress"] = interface.addressToString(interface.getLocalAddress())
	elseif not(string.find(config["localAddress"],"-")) and table.find(gateAd,config["localAddress"],"name") then
		config["localAddress"] = table.match(gateAd, config["localAddress"], "name", "address9")
	end
	local toConfig = table.match(gateAd, config["localAddress"], "address9", "solSys")
	if toConfig then config["solarSystem"] = toConfig end
	toConfig = table.match(solSysAd, config["solarSystem"], "name", "galaxy")
	if toConfig then config["galaxy"] = toConfig end
end

function listUpdate()						-- update the blacklist and whitelist of the stargate
	local path = fs.find("*SGCos")
	if not path[1] then path = fs.find("*/SGCos") end
	local blacklist = fs.open(path[1].."/blacklist.txt", "r")
	local whitelist = fs.open(path[1].."/whitelist.txt", "r")
	interface.clearBlacklist()
	interface.clearWhitelist()
	for i,file in pairs({blacklist,whitelist}) do
		while true do
			local line = file.readLine()
			if not line then break end
			local address = nil
			if string.find(line, "-") == 1 then address = line
			elseif table.find(gateAd,line,"name") then
				address = table.match(gateAd,line,"name","address9")
			elseif table.find(solSysAd,line,"name") then
				local id table.find(solSysAd,line,"name")
				if solarSystem[id]["galaxy"] == config["galaxy"] then
					 address = solarSystem[id]["address7"]
				else address = solarSystem[id]["address8"]
				end
				if address == "Unknown" then address = nil end
			end
			if address then
				address = require "cc.strings".split(address,"-")	-- to table
				table.remove(address, 1)
				table.remove(address, #address)
				for j = #address,1,-1 do address[j] = tonumber(address[j]) end
				if i == 1 then
					 interface.addToBlacklist(address)
				else interface.addToWhitelist(address)
				end
			end
		end
	end
end

function filesUpdate()						-- download and update files
	local path = fs.find("*SGCos")
	if not path[1] then path = fs.find("*/SGCos") end
	path = path[1].."/"
	fs.delete(path.."temp.txt")
	local function updateFile(path, pastebin, filename)
		if config[pastebin] then
			shell.execute("pastebin", "get", config[pastebin], path.."temp.txt")
			if fs.exists(path.."temp.txt") then
				fs.delete(path..filename)
				fs.move(path.."temp.txt", path..filename)
			end
		end
	end
	updateFile(path,"pastebinSolSys", "solarSystems.txt")
	updateFile(path,"pastebinGatePublic", "gateAddresses-public.txt")
	updateFile(path,"pastebinGateFaction", "gateAddresses-faction.txt")
	updateFile(path,"pastebinGatePrivate", "gateAddresses-private.txt")
	updateFile(path,"pastebinAdConfig", "addressConfig.txt")
	updateFile(path,"pastebinWhitelist", "whitelist.txt")
	updateFile(path,"pastebinBlacklist", "blacklist.txt")
	updateFile(path,"pasteBinGDO", "GDO.txt")
	updateFile(path,"pasteBinConfig", "config.cfg")
end

function within(value,x1,x2)				-- check if a value is within  others
    if value <= math.max(x1,x2) and value >= math.min(x1,x2) then
        return true
    else
        return false
    end
end

function midWrite(str, length)				-- write in the middle of a given width
    if #str <= length then
        local offset = math.floor((length - #str)/2)
        for i = 1, offset, 1 do
            monitor["whole"].write(" ")
        end
        monitor["whole"].write(str)
        for i = offset + #str + 1,length, 1 do
            monitor["whole"].write(" ")
        end
    else return end
end

function screenID(x,y)						-- get the ID of the address you clicked on
	if x%16 == 0 then
		return nil
	else
		return math.floor(x/16)*(monSizeY - 2)+y-2
	end
end

function monUtils(mon)						-- get usefull monitors sizes
	monSizeX, monSizeY = mon.getSize()
	centerX = math.floor(monSizeX/2)
	centerY = math.floor(monSizeY/2)
	return monSizeX, monSizeY, centerX, centerY
end

function eventDetector()					-- the main breaker.
	local count = 0
	while true do
		event, eventType, x, y, z = os.pullEvent()
		-- Interupt everything
		if event == "stargate_incoming_connection" then
			if irisChevronClosing == 0 then
				irisStatus = config["irisConfig"]
			end
			overrideMenu = "dialing"
			menu_display_dialing()
			return
			
		elseif event == "stargate_incoming_wormhole" then
			connexion(x)
			overrideMenu = "open"
			return
		elseif event == "stargate_outgoing_wormhole" then
			if not x then
				connexion(rawDialAddress)
			else
				connexion(x)
			end
			overrideMenu = "open"
		elseif event == "stargate_reset" then
			overrideMenu = "none"
			doReset = true
			return
		elseif event == "stargate_chevron_engaged" then
			dialChevronDisplay()
			if x == 1 and z or x == dialAddressLength then overrideMenu = "wait" end
			if z and irisChevronClosing ~= -1 and ((x == irisChevronLimit or x == irisChevronClosing) or (x <= irisChevronLimit and irisChevronLimit >= irisChevronClosing)) then
				irisStatus = config["irisConfig"]
				return
			end
			if x == 1 and z then
				if generation == 2 then
					-- silent stop
					if (interface.getRotation() + 2)%4 > 2 then
						 interface.rotateClockwise(interface.getCurrentSymbol())
					else interface.rotateAntiClockwise(interface.getCurrentSymbol())
					end
					rotation = 0
				end
				-- return
			end
		elseif event == "stargate_disconnected" then
			overrideMenu = "none"
			doReset = true
			return
		elseif (event == "monitor_touch" or (event == "mouse_click" and eventType == 1))and overrideMenu == "dialing" and not pauseDial then
			if event == "mouse_click" then eventType = "terminal" end
			if menu_control_dialing() then return end
		end
	end
end

function main()								-- the main programm
	while true do
		-- init
		if doReset then reset() end
		
		if irisStatus ~= "standby" and generation ~= 2.5 then
			if irisStatus == "openIris" or irisStatus == "openIrisChevron" then
				if irisStatus == "openIris" or DHDdialing then sleep(2) end
				interface.openIris()
			elseif irisStatus == "closeIris" or irisStatus == "closeIrisChevron" then
				if irisStatus == "closeIris" or DHDdialing then sleep(2) end
				interface.closeIris()
			elseif irisStatus == "closeVortex" then
				sleep(3)
				if interface.isWormholeOpen() and interface.isStargateDialingOut() == false then
					interface.disconnectStargate()
				end
				if interface.isStargateConnected() then
					interface.closeIris()
					overrideMenu = "open"
					print("failed to disconnect the stargate")
				else
					overrideMenu = "none"
				end
			end
			irisStatus = "standby"
		end
	
		if monitor and overrideMenu ~= "wait" and overrideMenu ~= "dialing" then
			if overrideMenu == "open" then
				menu_display_open()
			elseif monitor["selectedMenu"] == "main" then
				menu_display_main(monitor)
				sleep(0.2)
			elseif monitor["selectedMenu"] == "Solar_Systems" then
				menu_display_Solar_Systems()
				sleep(0.2)
			elseif table.find(groups, monitor["selectedMenu"]) ~= nil then
				menu_display_groups()
				sleep(0.2)
			elseif monitor["selectedMenu"] == "validation" then
				menu_display_validation()
				sleep(0.2)
			elseif monitor["selectedMenu"] == "closed" then
				menu_display_closed()
				sleep(0.2)
			elseif monitor["selectedMenu"] == "settings" then
				menu_display_settings()
				sleep(0.2)
			end
		end
		os.pullEvent()
		if overrideMenu ~= "wait" and (event == "mouse_click" and eventType == 1 or event == "monitor_touch") then
			if event == "mouse_click" then
				eventType = "terminal"
			end
			monitor = monitors[eventType]
			monSizeX, monSizeY = monitors[eventType]["whole"].getSize()
			centerX = math.floor(monSizeX/2)
			centerY = math.floor(monSizeY/2)
			maxPageID = (math.floor(monSizeX/16) - math.floor(monSizeX%16/15)) * (monSizeY-2)
			if overrideMenu == "dialing" and pauseDial then
				menu_control_dialing()
			elseif overrideMenu == "open" then
				menu_control_open()
			elseif monitor["selectedMenu"] == "closed" then
				menu_control_closed()
			elseif monitor["selectedMenu"] == "settings" then
				menu_control_settings()
			elseif monitor["selectedMenu"] == "main" then
				menu_control_main(monitor)
			elseif monitor["selectedMenu"] == "Solar_Systems" then
				menu_control_Solar_Systems()
			elseif table.find(groups, monitor["selectedMenu"]) ~= nil then
				menu_control_groups()
			elseif monitor["selectedMenu"] == "validation" then
				menu_control_validation()
			elseif monitor["selectedMenu"] == "DHD" then
				menu_control_DHD()
			end
			-- monitors[eventType] = monitor
		elseif event == "transceiver_transmission_received" and interface.isWormholeOpen() then
			-- GDO
			codeID = nil
			if (connectedName ~= "no data" and connectedName ~= "Unknown") and adConfig[connectedName]["receiveC"] then
				if x == adConfig[connectedName]["receiveF"] and tonumber(y) == adConfig[connectedName]["receiveC"] then
					codeID = connectedName
					interface.openIris()
				end
			end
			for i,value in pairs(GDOcodes) do
				if x == value["frequency"] and tonumber(y) == value["code"] then
					if value["command"] == "closeVortex" and interface.isWormholeOpen() then
						interface.disconnectStargate()
					elseif generation ~= 2.5 then
						if value["command"] == "openIris" and not ((connectedName ~= "no data" and connectedName ~= "Unknown") and adConfig[connectedName]["receiveC"]) then
							interface.openIris()
						elseif value["command"] == "closeIris" then
							interface.closeIris()
						end
					end
					codeID = i
					break
				end
			end
			if not codeID then
				for i,v in pairs(adConfig) do
					if x == v["receiveF"] and tonumber(y) == v["receiveC"] then
						codeID = i
						break
					end
				end
			end
			for i,value in pairs(monitors) do
				local monSizeX, monSizeY = value["whole"].getSize()
				if monSizeX >= 49 or monSizeY >= 14 then
					value["whole"].setCursorPos(1,5)
					value["whole"].setTextColor(colors.lightGray)
					if codeID then
						value["whole"].write("GDO "..codeID)
					else value["whole"].write("Unknown code")
					end
					local cursorX = value["whole"].getCursorPos()
					for i = cursorX, math.floor(monSizeX/2)-5, 1 do
						value["whole"].write(" ")
					end
				end
			end
		elseif event == "stargate_chevron_engaged" and not z then
			if x == 1 then
				overrideMenu = "dialing"
				menu_display_dialing()
				dialChevronDisplay()
			elseif y == 0 then
				DHDdialing = true
			end
		end
	end
end

function dialChevronDisplay()				-- display the chevrons that have been opened
	local chevronCoord = {{10,0},{10,3},{10,6},{7,7},
	{3,7},{0,6},{0,3},{0,0},{5,0}}
	for i,value in pairs(monitors) do
		value["whole"].setBackgroundColor(colors.orange)
		local monSizeX, monSizeY, centerX, centerY = monUtils(value["whole"])
		-- if not z then 
			if y ~= 0 and not(z and x>6 and y<6) then
				value["whole"].setCursorPos(centerX-4+chevronCoord[y][1],monSizeY-8+chevronCoord[y][2])
			else value["whole"].setCursorPos(centerX-4+chevronCoord[9][1],monSizeY-8+chevronCoord[9][2])
			end
		-- else value["whole"].setCursorPos(centerX+chevronCoord[x][1],monSizeY+chevronCoord[x][2]) end
		value["whole"].write(" ")
	end
end

function dial(address)						-- proceed to dialing
    local addressLength = #address
    local start = interface.getChevronsEngaged() + 1
	-- set the chevron configuration depending on the address length
    if interfaceType ~= 1 and generation ~= 1 then
		if not within(addressLength,7,9) then
			printError("erreur: addresse invalide")
			return
		end
        interface.setChevronConfiguration(config["chevronOrder"..addressLength])
    end
    local chevronDelay = {} -- chevrons activation delays
    chevronDelay = require "cc.strings".split(config["chevronDelay"],",")
    for i=1,#chevronDelay,1 do
        chevronDelay[i] = tonumber(chevronDelay[i])
    end
	-- if chevronDelay[1] + chevronDelay[2] == 0 and (config["milkyDial"] == "clockwise" or config["milkyDial"] == "andclockwise") and config["milkyDialNum"] ~= 0 then
		-- chevronDelay[4] = 0
	-- end
	local fullRota
	local anglePerChevron
	local nextAngle
	local angleOffset
	if generation == 2 then
		if config["milkyDial"] == "clockwise" and interface.isCurrentSymbol(0) then
			fullRota = 1
		else
			fullRota = 0
		end	
		anglePerChevron = config["milkyDialNum"]*156/addressLength
		angleOffset = interface.getCurrentSymbol()*4
	end
	-- pegasus special settings
	if generation == 3 and interfaceType == 3 then
		local dialID = table.find(gateAd,dialName,"name")
		--Symbols for Pegasus Stargate
		local pegSymbols
		if dialName ~= "Unknown" and adConfig[dialName]["pegSymbols"] then
			pegSymbols = adConfig[dialName]["pegSymbols"]
		elseif  addressLength == 9 and dialID and adConfig[gateAd[dialID]["solSys"]]["pegSymbols"] then
			pegSymbols = adConfig[gateAd[dialID]["solSys"]]["pegSymbols"]
		else
			pegSymbols = config["pegDefaultSymbols"]
		end
		if pegSymbols ~= "enchantment" and pegSymbols ~= "universal_custom" then
            interface.overrideSymbols("sgjourney:".. pegSymbols)
        else
            interface.overrideSymbols("moregates:".. pegSymbols)
        end
		--POO for Pegasus Stargate
		local pegPoo
		if dialName ~= "Unknown" and  adConfig[dialName]["pegPOO"] then
			pegPoo = adConfig[dialName]["pegPOO"]
		elseif  addressLength == 9 and dialID and adConfig[gateAd[dialID]["solSys"]]["pegPOO"] then
			pegPoo = adConfig[gateAd[dialID]["solSys"]]["pegPOO"]
		else
			pegPoo = config["pegDefaultPOO"]
		end
		if pegPoo ~= "enchant" then
            interface.overridePointOfOrigin("sgjourney:".. pegPoo)
        else
            interface.overridePointOfOrigin("moregates:enchant")
        end
	end
    
	local function oneDirRota(fSymbol)
		if config["milkyDial"] == "clockwise" then
			interface.rotateClockwise(fSymbol)
			rotation = 1
		else
			interface.rotateAntiClockwise(fSymbol)
			rotation = -1
		end
	end
	
    if generation == 2 then
        oldSymbol = interface.getCurrentSymbol()
    end
	local freeRota
	if (config["milkyDial"] ~= "clockwise" and config["milkyDial"] ~= "anticlockwise")
	or (config["milkyDialNum"] > 0 and interfaceType ~= 1 and (chevronDelay[1] + chevronDelay[4] == 0)) then
		 freeRota = true
	else freeRota = false
	end
	
	
	-- decide what to do with the iris
    local irisCommand
	if config["irisBothWays"] and generation ~= 2.5 then 
		if config["irisDefaultFirst"] or dialName == "Unknown" then
			irisCommand = config["irisConfig"]
		else
			irisCommand = adConfig[dialName]["irisConfig"]
			if not irisCommand and addressLength == 9 then
				irisCommand = adConfig[gateAd[table.find(gateAd,dialName,"name")]["solSys"]]["irisConfig"]
			end
			if not irisCommand then irisCommand = config["irisConfig"] end
		end
	end
	
    for chevron = start,addressLength,1 do -- Start dialing
		-- iris actuation
		if irisCommand and (irisChevronClosing == chevron-1 or (chevron == addressLength-1 and irisChevronClosing > addressLength-1)) then
			if irisCommand == "openIris" or irisCommand == "openIrisChevron" then
				 interface.openIris()
			else interface.closeIris()
			end
			irisCommand = nil
		end
        local symbol = address[chevron]
        if generation == 2 and config["milkyDial"] ~= "classic" then 					-- Dialing milky way stargate
			-- fastest/slowest dialing
			sleep(chevronDelay[4])
            if config["milkyDial"] == "fast" or config["milkyDial"] == "slow" then		-- fastest/slowest
                if (within(math.abs(symbol - oldSymbol),config["milkyMinRota"],19) == (config["milkyDial"] == "fast")) == (symbol < oldSymbol) then
                    interface.rotateClockwise(symbol)
					rotation = 1
                else
                    interface.rotateAntiClockwise(symbol)
					rotation = -1
                end
			-- alternate dialing
            elseif config["milkyDial"] == "alternate" or config["milkyDial"] == "alternateInv" then
                if (chevron % 2 == 0) == (config["milkyDial"] == "alternateInv") then
                    interface.rotateClockwise(symbol)
					rotation = 1
                else
                    interface.rotateAntiClockwise(symbol)
					rotation = -1
                end
			-- one direction dialing
			elseif config["milkyDial"] == "clockwise" or config["milkyDial"] == "anticlockwise" then
				if config["milkyDialNum"] == 0 or interfaceType == 1 or chevronDelay[2] > 0 then
					oneDirRota(symbol)
				elseif chevron == 1 or chevronDelay[1] > 0 or rotation == 0 then
					oneDirRota(-1)
					sleep(0.1)
				end
				nextAngle = math.floor(chevron*anglePerChevron-2+((rotation*78+78)- rotation*angleOffset))		-- can't remember why clockwise need to add 156, but it needs it.
				if chevronDelay[1] > 0 then nextAngle = nextAngle+1 end
			else
				printError(" dialing operation does not exist")
				return
            end
            oldSymbol = symbol		-- to find the fastest route
			if config["milkyDialNum"] == 0  or interfaceType == 1 or chevronDelay[2] > 0 then
				while(not interface.isCurrentSymbol(symbol)) do
					sleep(0)
				end
			else
				local nearFullRota = false
				while (((rotation*78+78) - rotation*interface.getRotation())+fullRota*156) < nextAngle do
					if (interface.getRotation() <= 0 or interface.getRotation() >= 156) then 
						if not nearFullRota then
							fullRota = fullRota+1
							nearFullRota = true
						end
					else nearFullRota = false
					end
					sleep(0)
				end
			end
			if chevronDelay[1] > 0 or not freeRota then
				interface.endRotation()
				rotation = 0
			end
			
            sleep(chevronDelay[1])
			if chevronDelay[2] > 0 or interfaceType == 1 then
				interface.openChevron()
				sleep(chevronDelay[2])
				if chevronDelay[3] > 0 and chevron < addressLength then
					interface.encodeChevron()
				end
				sleep(chevronDelay[3])
				interface.closeChevron()
			else
				if config["milkyDialNum"] ~= 0 and chevron == addressLength then
					interface.endRotation()
					rotation = 0
				end
				interface.engageSymbol(symbol)
				if interface.isCurrentSymbol(0) then fullRota = fullRota+1 end
			end
        else
			-- Dialing with other gates or fast dialing milky way gates
            if interfaceType ~= 1 then
				sleep(chevronDelay[1])
                interface.engageSymbol(symbol)
				if  (generation == 1 or generation == 3) and chevronDelay[1] ~= 0 then
					while interface.getChevronsEngaged() < chevron do	-- add delay between pegasus and universe chevron activation
						sleep(0)
					end
				end
            else
                printError("basic interfaces can only dial using the ring rotation of Milky Way stargates")
                return
            end
        end
    end
end

function reset(fast)							-- reset the gate to it's default param once closed
	doReset = false
	pauseDial = false
	DHDdialing = false
	
	rawDialAddress = nil
	dialName = nil
	dialAddress = nil
	connectedArray = nil
	connectedAd = nil
	connectedID = nil
	connectedName = nil
	connectedSolSys = nil
	connectedGalaxy = nil
	rotation = 0
	
	for i, value in pairs(monitors) do
		monitors[i]["selectedMenu"] = "closed"
		monitors[i]["groupMenu"] = config["selectedMenu"]
		monitors[i]["page"] = 1
		monitor = value
		menu_display_closed()
		local loadAd = {}
		if table.find(groups, config["selectedMenu"]) then
			for i = 1, #gateAd, 1 do
				if string.find(adConfig[gateAd[i]["name"]]["groups"],config["selectedMenu"]) then
					table.insert(loadAd, gateAd[i]["name"])
				end
			end
			if config["menuOrder"] == "alphabetical" then
				table.sort(loadAd)
			end
			monitors[i]["loadAd"] = loadAd
		end
	end
	
	if generation == 3 and interfaceType == 3 then
		interface.dynamicSymbols(false)
		if config["pegDefaultSymbols"] ~= "last" then
			if config["pegDefaultSymbols"] ~= "enchantment" and config["pegDefaultSymbols"] ~= "universal_custom" then
				interface.overrideSymbols("sgjourney:".. config["pegDefaultSymbols"])
			else
				interface.overrideSymbols("moregates:".. config["pegDefaultSymbols"])
			end
		end
		if config["pegDefaultPOO"] ~= "last" then
			if config["pegDefaultPOO"] ~= "enchant" then
				interface.overridePointOfOrigin("sgjourney:".. config["pegDefaultPOO"])
			else
				interface.overridePointOfOrigin("moregates:enchant")
			end
		end
	end
	if not (interface.isStargateConnected()) and generation == 2 and config["milkyDial"] ~= "classic" and config["milkySymbolReset"] and not (interface.isCurrentSymbol(config["milkyResetSymbol"])) then
		sleep(2)
		local currentSymbol = interface.getCurrentSymbol()
		if (math.abs(config["milkyResetSymbol"] - currentSymbol) <= 19) == (config["milkyResetSymbol"] < currentSymbol) then
			 interface.rotateClockwise(config["milkyResetSymbol"])
		else interface.rotateAntiClockwise(config["milkyResetSymbol"])
		end
	end
	irisStatus = config["irisDiscoConfig"]
end

function connexion(connectedArray)			-- from the array address, get the string address, length, file ID, and file name if it exist in any file
	irisStatus = nil
	if interfaceType == 3 or dialAddress then
		if interfaceType ~= 3 then
			connectedArray = dialAddress
			table.remove(connectedArray, #connectedArray)
		end
		connectedAd = interface.addressToString(connectedArray)
		connectedID = nil
		connectedName = "Unknown"
		if #connectedArray == 8 then
			connectedID = table.find(gateAd, connectedAd, "address9")
			if not(connectedID == nil) then
				connectedName = gateAd[connectedID]["name"]
				connectedSolSys = table.match(gateAd, connectedAd, "address9", "solSys")
				connectedGalaxy = table.match(solSysAd, connectedSolSys, "name", "galaxy")
			end
		else
			if #connectedArray == 6 then
				connectedID = table.find(solSysAd, connectedAd, "address7")
			else
				connectedID = table.find(solSysAd, connectedAd, "address8")
			end
			if not(connectedID == nil) then
				connectedName = solSysAd[connectedID]["name"]
				connectedSolSys = "self"
				connectedGalaxy = table.match(solSysAd, connectedName, "name", "galaxy")
			end
		end
		if not(connectedName == "Unknown") then
			irisStatus = adConfig[connectedName]["irisConfig"]
			if not irisStatus and #connectedArray == 8 then
				irisStatus = adConfig[gateAd[connectedID]["solSys"]]["irisConfig"]
			end
		else
			irisStatus = config["irisConfig"]
			connectedSolSys = nil
			connectedGalaxy = nil
		end
	elseif interface.isStargateDialingOut() then
		connectedName = dialName
		connectedAd = rawDialAddress
		if connectedName ~= "Unknown" then
			if #connectedArray == 8 then
				connectedSolSys = table.match(gateAd, connectedName, "name", "solSys")
			else
				connectedSolSys = "self"
			end
			connectedGalaxy = table.match(solSysAd, connectedSolSys, "name", "galaxy")
		end
	else
		connectedName = "no data"
		connectedSolSys = nil
		connectedGalaxy = nil
	end
	if not irisStatus then
		irisStatus = config["irisConfig"]
	end
	if not config["irisBothWays"] and interface.isStargateDialingOut() then
		irisStatus = "standby"
	end
end

-- Menus --

function menu_display_base(monitor)
	monitor.setBackgroundColor(colors.black)
	monitor.setTextColor(colors.white)
	
    monitor.setCursorPos(1,1)
end

function menu_display_selectBase()
	menu_display_base(monitor["whole"])
	monitor["whole"].clear()
	monitor["whole"].setCursorPos(1,1)
	monitor["whole"].setBackgroundColor(colors.red)
	monitor["whole"].write("< back ")
	monitor["whole"].setCursorPos(8,1)
	monitor["whole"].setBackgroundColor(colors.black)
	monitor["whole"].write(" DHD ")
	if config["adminMode"] or eventType == "terminal" then
		monitor["whole"].setCursorPos(13,1)
		monitor["whole"].setBackgroundColor(colors.yellow)
		monitor["whole"].write(" Upd ")
	end
	monitor["whole"].setCursorPos(1,2)
	monitor["whole"].setBackgroundColor(colors.lightGray)
	monitor["whole"].setCursorPos(1,2)
	monitor["whole"].write("[               ]")
	monitor["whole"].setCursorPos(2,2)
	monitor["whole"].setBackgroundColor(colors.white)
	monitor["whole"].setTextColor(colors.black)
	midWrite(monitor["selectedMenu"],15)
	if monitor["page"] == 1 then
		monitor["whole"].setBackgroundColor(colors.gray)
		monitor["whole"].setTextColor(colors.lightGray)
	else
		monitor["whole"].setBackgroundColor(colors.lightGray)
		monitor["whole"].setTextColor(colors.white)
	end
	
	-- page
	monitor["whole"].setCursorPos(19,2)
	monitor["whole"].write("<")
	monitor["whole"].setBackgroundColor(colors.cyan)
	monitor["whole"].setTextColor(colors.white)
	monitor["whole"].write(" Page ")
	if monitor["page"] < 10 then
		monitor["whole"].write("0")
	end
	monitor["whole"].write(monitor["page"] .." ")
	if (monitor["selectedMenu"] == "main" and monitor["page"] * maxPageID < #groups+1)
	or (monitor["selectedMenu"] == "Solar_Systems" and monitor["page"] * maxPageID < #solSysAd)
	or (table.find(groups, monitor["selectedMenu"]) ~= nil and monitor["page"] * maxPageID < #monitor["loadAd"]) then
		monitor["whole"].setBackgroundColor(colors.lightGray)
		monitor["whole"].setTextColor(colors.white)
	else
		monitor["whole"].setBackgroundColor(colors.gray)
		monitor["whole"].setTextColor(colors.lightGray)
	end
	monitor["whole"].write(">")
	
	-- collumn delimitation
	monitor["whole"].setBackgroundColor(colors.gray)
	monitor["whole"].setTextColor(colors.lightGray)
	for i = 16, monSizeX,16 do
		for j = 3, monSizeY,1 do
			monitor["whole"].setCursorPos(i,j)
			monitor["whole"].write("\127")
		end
	end
	monitor["whole"].setTextColor(colors.white)
end
function menu_control_selectBase()
	if y == 2 then
		if x == 19 and monitor["page"] > 1 then
			monitor["page"] = monitor["page"]-1
		elseif x == 29 and ((monitor["selectedMenu"] == "main" and monitor["page"] * maxPageID < #groups+1)
		or (monitor["selectedMenu"] == "Solar_Systems" and monitor["page"] * maxPageID < #solSysAd)
		or (table.find(groups, monitor["selectedMenu"]) ~= nil and monitor["page"] * maxPageID < #monitor["loadAd"])) then
			monitor["page"] = monitor["page"]+1
		end
	elseif y == 1 then
		if x <= 7 then
			if monitor["selectedMenu"] ~= "main" then
				monitor["selectedMenu"] = "main"
			else
				monitor["selectedMenu"] = "closed"
			end
			monitor["page"] = 1
		elseif within(x,8,12) then
			monitors[eventType]["groupMenu"] = monitors[eventType]["selectedMenu"]
			monitors[eventType]["selectedMenu"] = "DHD"
			monitor["selectedMenu"] = "DHD"
			monitors[eventType]["DHDaddress"] = {}
			menu_display_DHD()
		elseif (config["adminMode"]  or eventType == "terminal")and within(x,13,17) then
			monitors[eventType]["groupMenu"] = monitors[eventType]["selectedMenu"]
			monitors[eventType]["selectedMenu"] = "settings"
			monitor["selectedMenu"] = "settings"
		end
	elseif y > 2 and x%16 == 0 then
	elseif y ~= 1 then
		selection = screenID(x,y) + ((monitor["page"] - 1) * maxPageID)  -- get the ID of the screen selection
		return false
	end
	return true
end

function menu_display_main()
	menu_display_selectBase()
	monitor["whole"].setCursorPos(1,3)
	local offset = 0
	if monitor["page"] == 1 then
		monitor["whole"].setBackgroundColor(colors.yellow)
		midWrite("Solar_Systems",15)
		monitor["whole"].setCursorPos(1,4)
		offset = 1
	end
	for i = offset + ((monitor["page"]-1) * maxPageID), #groups, 1 do
		local cursorX, cursorY = monitor["whole"].getCursorPos()
		if groups[i] ~= "all" then
			monitor["whole"].setTextColor(colors.white)
			if cursorY%2 == 1 then
				 monitor["whole"].setBackgroundColor(colors.green)
			else monitor["whole"].setBackgroundColor(colors.lime)
			end
		else
			monitor["whole"].setBackgroundColor(colors.white)
			monitor["whole"].setTextColor(colors.black)
		end
		midWrite(groups[i], 15)
		if cursorY < monSizeY then
			monitor["whole"].setCursorPos(cursorX, cursorY+1)
		elseif cursorX < monSizeX then
			monitor["whole"].setCursorPos(cursorX+16, 3)
		end
	end
	monitor["whole"].setTextColor(colors.white)
	monitor["whole"].setBackgroundColor(colors.black)
end
function menu_control_main()
	if menu_control_selectBase(monitor) then return end
	if y == 3 and within(x,1,15) and monitor["page"] == 1 then
		monitors[eventType]["selectedMenu"] = "Solar_Systems"
		monitors[eventType]["groupMenu"] = "Solar_Systems"
	-- if you select a group from the main menu
	elseif selection-1 <= #groups then
		monitors[eventType]["selectedMenu"] = groups[selection-1]
		monitors[eventType]["groupMenu"] = monitor["selectedMenu"]
		-- get loaded addresses in the menu
		monitor["loadAd"] = {}
		for i = 1, #gateAd, 1 do
			if string.find(adConfig[gateAd[i]["name"]]["groups"],monitor["selectedMenu"]) then
				table.insert(monitors[eventType]["loadAd"], gateAd[i]["name"])
			end
			if config["menuOrder"] == "alphabetical" then
				table.sort(monitors[eventType]["loadAd"])
			end
		end
	end
end

function menu_display_Solar_Systems()
	menu_display_selectBase()
	monitor["whole"].setBackgroundColor(colors.black)
	monitor["whole"].setCursorPos(1,3)
	for i = 1 + ((monitor["page"]-1) * maxPageID), #solSysAd, 1 do
		local cursorX, cursorY = monitor["whole"].getCursorPos()
		monitor["whole"].setTextColor(colors.white)
		if solSysAd[i]["galaxy"] == config["galaxy"] then
			if cursorY%2 == 1 then
				 monitor["whole"].setBackgroundColor(colors.green)
			else monitor["whole"].setBackgroundColor(colors.lime)
			end
			if solSysAd[i]["address7"] == "Unknown" then
				monitor["whole"].setTextColor(colors.red)
			end
		else
			monitor["whole"].setBackgroundColor(colors.blue)
			if cursorY%2 == 1 then
				 monitor["whole"].setBackgroundColor(colors.blue)
			else monitor["whole"].setBackgroundColor(colors.magenta)
			end
			if solSysAd[i]["address8"] == "Unknown" then
				monitor["whole"].setTextColor(colors.red)
			end
		end
		if config["solarSystem"] == solSysAd[i]["name"] then
			monitor["whole"].setBackgroundColor(colors.gray)
		end
		
		midWrite(solSysAd[i]["name"], 15)
		if cursorY < monSizeY then
			monitor["whole"].setCursorPos(cursorX, cursorY+1)
		elseif cursorX < monSizeX then
			monitor["whole"].setCursorPos(cursorX+16, 3)
		end
	end
	monitor["whole"].setTextColor(colors.white)
	monitor["whole"].setBackgroundColor(colors.black)
	return
end
function menu_control_Solar_Systems()
	if menu_control_selectBase() then return end
	if selection <= #solSysAd then
		if config["galaxy"] == solSysAd[selection]["galaxy"] then
			if solSysAd[selection]["address7"] ~= "Unknown" then
				rawDialAddress = solSysAd[selection]["address7"]
				dialName = solSysAd[selection]["name"]
				monitors[eventType]["selectedMenu"] = "validation"
			else
				printError("The galactic address of this solar system is unknown")
			end
		else
			if solSysAd[selection]["address8"] ~= "Unknown" then
				rawDialAddress = solSysAd[selection]["address8"]
				dialName = solSysAd[selection]["name"]
				monitors[eventType]["selectedMenu"] = "validation"
			else
				printError("the intergalactic address of this solar system is unknown")
			end
		end
	end
end

function menu_display_groups()
	menu_display_selectBase()
	monitor["whole"].setBackgroundColor(colors.black)
	monitor["whole"].setCursorPos(1,3)
	for i= 1 + ((monitor["page"]-1) * maxPageID), #monitor["loadAd"], 1 do
		local cursorX, cursorY = monitor["whole"].getCursorPos()
		local gateID = table.find(gateAd,monitor["loadAd"][i],"name")
		if gateAd[gateID]["address9"] == config["localAddress"] then
			monitor["whole"].setBackgroundColor(colors.gray)
			monitor["whole"].setTextColor(colors.lightGray)
		elseif solSysAd[table.find(solSysAd,gateAd[gateID]["solSys"],"name")]["galaxy"] == config["galaxy"] then
			if gateAd[gateID]["solSys"] == config["solarSystem"] then
				monitor["whole"].setTextColor(colors.white)
				if cursorY%2 == 1 then
					 monitor["whole"].setBackgroundColor(colors.green)
				else monitor["whole"].setBackgroundColor(colors.lime)
				end
			else
				monitor["whole"].setTextColor(colors.black)
				if cursorY%2 == 1 then
					 monitor["whole"].setBackgroundColor(colors.yellow)
				else monitor["whole"].setBackgroundColor(colors.pink)
				end
			end
		else
			monitor["whole"].setTextColor(colors.white)
			if cursorY%2 == 1 then
				 monitor["whole"].setBackgroundColor(colors.blue)
			else monitor["whole"].setBackgroundColor(colors.magenta)
			end
		end
		midWrite(monitor["loadAd"][i], 15)
		if cursorY < monSizeY then
			monitor["whole"].setCursorPos(cursorX, cursorY+1)
		elseif cursorX < monSizeX then
			monitor["whole"].setCursorPos(cursorX+16, 3)
		end
	end
end
function menu_control_groups()
	if menu_control_selectBase() then return end
	if selection <= #monitor["loadAd"] then
		rawDialAddress = table.match(gateAd,monitor["loadAd"][selection],"name","address9")
		dialName = monitor["loadAd"][selection]
		monitors[eventType]["selectedMenu"] = "validation"
	end
end

function menu_display_validation()
	monitor["whole"].setBackgroundColor(colors.black)
	monitor["whole"].clear()
	local centerX = centerX
	local centerY = centerY
	
	if config["displayAddressOut"] then
		monitor["whole"].setBackgroundColor(colors.white)
		monitor["whole"].setTextColor(colors.black)
		monitor["whole"].setCursorPos(1,centerY-4)
		midWrite(rawDialAddress,monSizeX)
	end
	monitor["whole"].setBackgroundColor(colors.black)
	
	
	if table.find(gateAd, dialName, "name") then
		dialSolSys = table.match(gateAd,dialName,"name","solSys")
		dialGalaxy = table.match(solSysAd,dialSolSys,"name","galaxy")
	elseif table.find(solSysAd, dialName, "name") then
		dialSolSys = nil
		dialGalaxy = table.match(solSysAd,dialName,"name","galaxy")
	else
		dialSolSys = nil
		dialGalaxy = nil
	end
	if dialGalaxy then
		monitor["whole"].setTextColor(colors.magenta)
		monitor["whole"].setCursorPos(centerX-13,centerY-1)
		monitor["whole"].write("Galaxy: "..dialGalaxy)
	end
	monitor["whole"].setTextColor(colors.pink)
	monitor["whole"].setCursorPos(centerX-13,centerY)
	if dialSolSys then
		monitor["whole"].write("SolSys: "..dialSolSys)
	else
		monitor["whole"].write("SolSys: self")
	end

	monitor["whole"].setTextColor(colors.white)
	monitor["whole"].setCursorPos(centerX-12,centerY-2)
	monitor["whole"].write("[ Confirm your selection ]")
	
	monitor["whole"].setCursorPos(centerX-8,centerY+2)
	midWrite("< "..dialName.." >",19)
	if config["localAddress"] == dialName or config["localAddress"] == rawDialAddress or config["solarSystem"] == dialName then
		monitor["whole"].setCursorPos(centerX-3,centerY+3)
		monitor["whole"].setTextColor(colors.gray)
		monitor["whole"].write("( self )")
	end
	monitor["whole"].setTextColor(colors.white)
	monitor["whole"].setBackgroundColor(colors.green)
	monitor["whole"].setCursorPos(centerX+3,centerY+4)
	monitor["whole"].write(" Confirm  ")
	monitor["whole"].setBackgroundColor(colors.red)
	monitor["whole"].setTextColor(colors.black)
	monitor["whole"].setCursorPos(centerX-11,centerY+4)
	monitor["whole"].write("  Cancel  ")

end
function menu_control_validation()
	if y == centerY + 4 then
		if within(x,centerX + 3,centerX + 12) then
			dialAddress = require "cc.strings".split(rawDialAddress,"-",true,10)
			table.remove(dialAddress,1)
			dialAddress[#dialAddress] = 0
			for i=1,#dialAddress,1 do
				dialAddress[i] = tonumber(dialAddress[i])
			end
			dialAddressLength = #dialAddress
			overrideMenu = "dialing"
			menu_display_dialing()
			dial(dialAddress)
		elseif within(x,centerX - 11,centerX - 1) then
			monitors[eventType]["selectedMenu"] = monitor["groupMenu"]
		end
	end
end

function menu_display_dialing()
	for i,value in pairs(monitors) do
		-- menu_display_base(value["whole"])
		value["whole"].setBackgroundColor(colors.black)
		value["whole"].setTextColor(colors.white)
		value["whole"].clear()
		local monSizeX, monSizeY, centerX, centerY = monUtils(value["whole"])
		menu_display_base(value["whole"])
		monitor = value
		local adaptY1 = 2
		local adaptY2 = 1
		if monSizeY == 10 then
			adaptY1 = 1
			adaptY2 = 10
		end
		value["whole"].setCursorPos(1,adaptY1)
		value["whole"].write("dialing...")
		value["whole"].setCursorPos(12,adaptY1)
		if interface.isStargateConnected() then 
			value["whole"].write("in")
		else
			if rawDialAddress then
				value["whole"].write(dialName, 30)
				if config["displayAddressOut"] then
					value["whole"].setCursorPos(centerX-13,adaptY2)
					midWrite(rawDialAddress, 30)
				end
			else value["whole"].write("from DHD")
			end
		end
		drawGate()
		if not (interface.isStargateConnected()) then
			value["whole"].setBackgroundColor(colors.red)
			value["whole"].setCursorPos(monSizeX - 7, monSizeY - 3)
			value["whole"].write("       ")
			value["whole"].setCursorPos(monSizeX - 7, monSizeY - 2)
			value["whole"].write(" ABORT ")
			value["whole"].setCursorPos(monSizeX - 7, monSizeY - 1)
			value["whole"].write("       ")
		end
		monitor["whole"].setBackgroundColor(colors.black)
	end
	if not(interface.isStargateConnected()) and dialName then 
		pauseButton()
	end
end
function menu_control_dialing()
	local monSizeX, monSizeY, centerX, centerY = monUtils(monitors[eventType]["whole"])
	if within(x,monSizeX - 7, monSizeX - 1) then
		if within(y,monSizeY - 3,monSizeY - 1) then
			overrideMenu = "closed"
			interface.disconnectStargate()
			doReset = true
			return true
		elseif within(y,monSizeY - 7,monSizeY - 5) and dialName then
			if not pauseDial then
				pauseDial = true
				if generation == 2 then interface.endRotation() end
				rotation = 0
				pauseButton()
				return true
			else
				pauseDial = false
				if generation == 2 and config["milkyDial"] ~= "classic" then 	
					interface.closeChevron()
				end
				pauseButton()
				dial(dialAddress)
			end
		end
	end
	return false
end
function pauseButton()
	for i,value in pairs(monitors) do
		local monSizeX, monSizeY, centerX, centerY = monUtils(value["whole"])
		value["whole"].setCursorPos(monSizeX-7, monSizeY - 6)
		if pauseDial then 
			value["whole"].setBackgroundColor(colors.blue)
			value["whole"].write(" pause ")
		else
			value["whole"].setBackgroundColor(colors.green)
			value["whole"].write(" <dial ")
		end
		value["whole"].setCursorPos(monSizeX-7, monSizeY - 7)
		value["whole"].write("       ")
		value["whole"].setCursorPos(monSizeX-7, monSizeY - 5)
		value["whole"].write("       ")
	end
end


function menu_display_open()
	local out = interface.isStargateDialingOut()
	for i,value in pairs(monitors) do
		local monSizeX, monSizeY, centerX, centerY = monUtils(value["whole"])
		menu_display_base(value["whole"])
		monitor = value
		local adaptY1 = 2
		local adaptY2 = 1
		if monSizeY == 10 then
			adaptY1 = 1
			adaptY2 = 10
		end
		value["whole"].setCursorPos(1,adaptY1)
		value["whole"].clearLine()
		if interface.isStargateDialingOut() then
			value["whole"].write("Outgoing >>> ")
		else
			value["whole"].write("Incoming <<< ")
		end
		value["whole"].setCursorPos(14,adaptY1)
		value["whole"].write(connectedName)
		if (config["displayAddressOut"] and out) or (config["displayAddressIn"] and not out) then
			value["whole"].setCursorPos(centerX-13,adaptY2)
			if connectedName ~= "no data" then
				midWrite(connectedAd, 30)
			else
				midWrite("no data", 30)
			end
		end
		-- draw vortex
		value["whole"].setBackgroundColor(colors.cyan)
		for j = 0,5,1 do
			value["whole"].setCursorPos(centerX-3, monSizeY-7+j)
			value["whole"].write("         ")
		end
		value["whole"].setBackgroundColor(colors.lightBlue)
		value["whole"].setCursorPos(centerX,monSizeY-5)
		value["whole"].write("   ")
		value["whole"].setCursorPos(centerX,monSizeY-4)
		value["whole"].write("   ")
		-- close stargate button
		value["whole"].setBackgroundColor(colors.red)
		value["whole"].setCursorPos(monSizeX - 7, monSizeY - 2)
		value["whole"].write(" close ")
		value["whole"].setCursorPos(monSizeX - 7, monSizeY - 1)
		value["whole"].write(" vortex")
		
		-- open/close iris button
		if generation ~= 2.5 then
			value["whole"].setCursorPos(monSizeX-7, monSizeY - 7)
			value["whole"].blit("       ","0000000","ddd8eee")
			value["whole"].setCursorPos(monSizeX-7, monSizeY - 6)
			value["whole"].blit(" Ir is ","0000000","ddd8eee")
			value["whole"].setCursorPos(monSizeX-7, monSizeY - 5)
			value["whole"].blit("       ","0000000","ddd8eee")
			value["whole"].setBackgroundColor(colors.black)
			value["whole"].setCursorPos(monSizeX-5, monSizeY - 4)
			value["whole"].write(math.floor(interface.getIrisDurability()/interface.getIrisMaxDurability()*100+0.5).."%  ")
		else
			value["whole"].setBackgroundColor(colors.black)
			for i = 7,4,-1 do
				value["whole"].setCursorPos(monSizeX-7, monSizeY - i)
				value["whole"].write("       ")
			end
		end
		value["whole"].setCursorPos(monSizeX-7, monSizeY - 3)
		value["whole"].write("       ")
		
		if monSizeX >= 49 or monSizeY >= 13 then
			if connectedGalaxy then
				monitor["whole"].setTextColor(colors.magenta)
				monitor["whole"].setCursorPos(1,3)
				monitor["whole"].write(" G: "..connectedGalaxy)
			end
			monitor["whole"].setTextColor(colors.pink)
			monitor["whole"].setCursorPos(1,4)
			if connectedSolSys then
				monitor["whole"].write("SS: "..connectedSolSys)
			end
		end
	end
end
function menu_control_open()
	if within(x,monSizeX - 7, monSizeX - 1) then
		if within(y,monSizeY - 2,monSizeY - 1) then
			menu_display_closed()
			interface.disconnectStargate()
			overrideMenu = "closed"
		elseif within(y,monSizeY - 7,monSizeY - 5) and generation ~= 2.5 then
			if x < monSizeX - 4 then
				 interface.openIris()
			else interface.closeIris()
			end
		end
	end
end

function menu_display_closed()		-- information about the connexion closing
	local monSizeX, monSizeY, centerX, centerY = monUtils(monitor["whole"])
	menu_display_base(monitor["whole"])
	monitor["whole"].clear()
	monitor["whole"].setCursorPos(centerX-5,1)
	monitor["whole"].write("Stargate Idle")
	drawGate()
end
function menu_control_closed()
	if within(y,monSizeY-2,monSizeY) then

	else
		monitors[eventType]["selectedMenu"] = config["selectedMenu"]
		monitor["selectedMenu"] = config["selectedMenu"]
		local loadAd = {}
		if table.find(groups, config["selectedMenu"]) then
			for i = 1, #gateAd, 1 do
				if string.find(adConfig[gateAd[i]["name"]]["groups"],config["selectedMenu"]) then
					table.insert(loadAd, gateAd[i]["name"])
				end
			end
			if config["menuOrder"] == "alphabetical" then
				table.sort(loadAd)
			end
			monitors[eventType]["loadAd"] = loadAd
		end
	end
end

function menu_display_settings()
	-- list selection
	monitor["whole"].setTextColor(colors.white)
	monitor["whole"].setBackgroundColor(colors.black)
	monitor["whole"].clear()
	local monSizeX, monSizeY = monUtils(monitor["whole"])
	monitor["whole"].setCursorPos(1,1)
	monitor["whole"].setBackgroundColor(colors.red)
	monitor["whole"].write("< back ")
	monitor["whole"].setBackgroundColor(colors.lightGray)
	monitor["whole"].setCursorPos(1,2)
	monitor["whole"].setBackgroundColor(colors.lightGray)
	monitor["whole"].clearLine()
	if interfaceType == 3 then
		monitor["whole"].setCursorPos(1,5)
		monitor["whole"].write("Update")
		monitor["whole"].setCursorPos(1,3)
		if interface.getFilterType() == -1 then 
			monitor["whole"].blit("BLACK ","000fff","ff7700")
			monitor["whole"].setBackgroundColor(colors.black)
			monitor["whole"].setTextColor(colors.white)
		elseif interface.getFilterType() == 1 then
			monitor["whole"].blit(" WHITE","0000ff","ff7700")
			monitor["whole"].setBackgroundColor(colors.white)
			monitor["whole"].setTextColor(colors.black)
		else
			monitor["whole"].blit("  NO  ","00eeff","ff7700")
			monitor["whole"].setBackgroundColor(colors.gray)
			monitor["whole"].setTextColor(colors.lightGray)
		end
		monitor["whole"].setCursorPos(1,4)
		monitor["whole"].write(" List ")
	end
	monitor["whole"].setBackgroundColor(colors.yellow)
	monitor["whole"].setTextColor(colors.black)
	monitor["whole"].setCursorPos(12,3)
	monitor["whole"].write("////////")
	monitor["whole"].setCursorPos(12,4)
	monitor["whole"].write(" Update ")
	monitor["whole"].setCursorPos(12,5)
	monitor["whole"].write("  data  ")
	monitor["whole"].setCursorPos(12,6)
	monitor["whole"].write("////////")
end
function menu_control_settings()
	if y == 1 and x <= 7 then
		monitors[eventType]["selectedMenu"] = monitors[eventType]["groupMenu"]
		monitor["selectedMenu"] = monitors[eventType]["selectedMenu"]
	elseif interfaceType == 3 and within(y,2,3) and within(x,1,8) then
		if x <= 2 then interface.setFilterType(-1) 
		elseif x <=4 then interface.setFilterType(0) 
		else interface.setFilterType(1) 
		end
	elseif y == monSizeY then
		listUpdate()
	elseif within(x, 12, 19) and within(y, 3, 6) then
		term.setBackgroundColor(colors.black)
		term.setTextColor(colors.white)
		term.setCursorPos(1,7)
		filesUpdate()
		dataInit()
		reset()
	end
end

function menu_display_DHD()
	monitor["whole"].setBackgroundColor(colors.black)
	monitor["whole"].clear()
	monitor["whole"].setCursorPos(centerX-11,monSizeY-9)
	monitor["whole"].write("|  |  |  |  |  |  |  |  |")
	monitor["whole"].setCursorPos(1,1)
	monitor["whole"].setBackgroundColor(colors.red)
	monitor["whole"].write("X ")

	if false then
		for i,v in pairs({colors.gray, colors.lightGray, colors.white}) do
			monitor["whole"].setBackgroundColor(v)
			monitor["whole"].setTextColor(colors.white)
			for j = (i-1)*16,i*16,1 do
				monitor["whole"].setCursorPos(centerX - 14 + DHDkeysPos[j][1],monSizeY - 7 + DHDkeysPos[j][2])
				if j < 10 then monitor["whole"].write(0) end
				monitor["whole"].write(j)
			end
		end
	elseif DHDgeneration == 1 then		-- DHD 35
		monitor["whole"].setCursorPos(centerX-6,monSizeY-7)
		monitor["whole"].blit("03  04   05  06","000000000000000","777777777777777")
		monitor["whole"].setCursorPos(centerX-8,monSizeY-6)
		monitor["whole"].blit("02  22 23 24 25  07","0000000000000000000","7778888888888888777")
		monitor["whole"].setCursorPos(centerX-9,monSizeY-5)
		monitor["whole"].blit("01  21 \151\131\131\131\131\131\148 26  08","0000000ffffffc0000000","7778888ccccccf8888777")
		monitor["whole"].setCursorPos(centerX-9,monSizeY-4)
		monitor["whole"].blit("00  20 \149     \149 27  09","0000000ffffffc0000000","7778888ccccccf8888777")
		monitor["whole"].setCursorPos(centerX-9,monSizeY-3)
		monitor["whole"].blit("19  35 \149     \149 28  10","0000000ffffffc0000000","7778888ccccccf8888777")
		monitor["whole"].setCursorPos(centerX-9,monSizeY-2)
		monitor["whole"].blit("18  34 \138\143\143\143\143\143\133 29  11","0000000ccccccc0000000","7778888fffffff8888777")
		monitor["whole"].setCursorPos(centerX-8,monSizeY-1)
		monitor["whole"].blit("17  33 32 31 30  12","0000000000000000000","7778888888888888777")
		monitor["whole"].setCursorPos(centerX-6,monSizeY-0)
		monitor["whole"].blit("16  15   14  13","000000000000000","777777777777777")
	elseif DHDgeneration == 2 then		-- DHD 38
		monitor["whole"].setCursorPos(centerX-8,monSizeY-7)
		monitor["whole"].blit("04 05 06  07 08 09","000000000000000000","777777777777777777")
		monitor["whole"].setCursorPos(centerX-9,monSizeY-6)
		monitor["whole"].blit("03   27  28  29   10","00000000000000000000","77788888888888888777")
		monitor["whole"].setCursorPos(centerX-10,monSizeY-5)
		monitor["whole"].blit("02  26 \151\131\131\131\131\131\131\148 30  11","0000000fffffffc0000000","7778888cccccccf8888777")
		monitor["whole"].setCursorPos(centerX-10,monSizeY-4)
		monitor["whole"].blit("01  25 \149      \149 31  12","0000000fffffffc0000000","7778888cccccccf8888777")
		monitor["whole"].setCursorPos(centerX-10,monSizeY-3)
		monitor["whole"].blit("24  38 \149      \149 32  13","0000000fffffffc0000000","7778888cccccccf8888777")
		monitor["whole"].setCursorPos(centerX-10,monSizeY-2)
		monitor["whole"].blit("23  37 \138\143\143\143\143\143\143\133 33  14","0000000cccccccc0000000","7778888ffffffff8888777")
		monitor["whole"].setCursorPos(centerX-9,monSizeY-1)
		monitor["whole"].blit("22   36  35  34   15","00000000000000000000","77788888888888888777")
		monitor["whole"].setCursorPos(centerX-8,monSizeY-0)
		monitor["whole"].blit("21 20 19  18 17 16","000000000000000000","777777777777777777")
	else  -- DHD 47
		monitor["whole"].setCursorPos(centerX-11,monSizeY-7)
		monitor["whole"].blit("03  19             20  04","0000000000000000000000000","7778888fffffffffff8888777")
		monitor["whole"].setCursorPos(centerX-12,monSizeY-6)
		monitor["whole"].blit("02  18  34 35 36 37  21  05","0000000fffffffffffff0000000","777888800000000000008888777")
		monitor["whole"].setCursorPos(centerX-13,monSizeY-5)
		monitor["whole"].blit("01  17  33 \151\131\131\131\131\131\148 38  22  06","0000000ffffffffffcffff0000000","77788880000ccccccf00008888777")
		monitor["whole"].setCursorPos(centerX-13,monSizeY-4)
		monitor["whole"].blit("00  16  32 \149     \149 39  23  07","0000000ffffffffffcffff0000000","77788880000ccccccf00008888777")
		monitor["whole"].setCursorPos(centerX-13,monSizeY-3)
		monitor["whole"].blit("15  31  47 \149     \149 40  24  08","0000000ffffffffffcffff0000000","77788880000ccccccf00008888777")
		monitor["whole"].setCursorPos(centerX-13,monSizeY-2)
		monitor["whole"].blit("14  30  46 \138\143\143\143\143\143\133 41  25  09","0000000ffffcccccccffff0000000","77788880000fffffff00008888777")
		monitor["whole"].setCursorPos(centerX-12,monSizeY-1)
		monitor["whole"].blit("13  29  45 44 43 42  26  10","0000000fffffffffffff0000000","777888800000000000008888777")
		monitor["whole"].setCursorPos(centerX-11,monSizeY-0)
		monitor["whole"].blit("12  28             27  11","0000000000000000000000000","7778888fffffffffff8888777")
	end
	monitor["whole"].setBackgroundColor(colors.black)
	monitor["whole"].setTextColor(colors.orange)
end
function menu_control_DHD()

	local function keyLight(key)
		if key >= 32 and DHDgeneration == 3 then 
			monitor["whole"].setBackgroundColor(colors.white)
		elseif key >= 25 or (DHDgeneration == 1 and key >= 20) or (DHDgeneration == 3 and key >= 16) then
			monitor["whole"].setBackgroundColor(colors.lightGray)
		else
			monitor["whole"].setBackgroundColor(colors.gray)
		end
		monitor["whole"].setCursorPos((centerX-14)+DHDkeysPos[key][1],monSizeY-8+DHDkeysPos[key][2])
		if key < 10 then monitor["whole"].write("0") end
		monitor["whole"].write(key)
	end
	
	if y == 1 and x <= 2 then
		monitors[eventType]["selectedMenu"] = monitors[eventType]["groupMenu"]
		monitor["selectedMenu"] = monitors[eventType]["selectedMenu"]
	-- remove symbols
	elseif y == monSizeY-9 and within(x, centerX-10, centerX+12) then
		if (x-(centerX-10))%3 ~= 2 then
			local selectionID = math.floor((x-(centerX-10))/3)+1
			if selectionID <= #monitors[eventType]["DHDaddress"] and monitors[eventType]["DHDaddress"][selectionID] ~= -1 then
				if DHDgeneration == 3 and monitors[eventType]["DHDaddress"][selectionID] >= 32 then
					 monitor["whole"].setTextColor(colors.black)
				else monitor["whole"].setTextColor(colors.white)
				end
				keyLight(monitors[eventType]["DHDaddress"][selectionID])
				if #monitors[eventType]["DHDaddress"] == selectionID then
					table.remove(monitors[eventType]["DHDaddress"],selectionID)
					for i = selectionID-1,1,-1 do
						if monitors[eventType]["DHDaddress"][i] ~= -1 then break end
						table.remove(monitors[eventType]["DHDaddress"],i)
					end
				else
					monitors[eventType]["DHDaddress"][selectionID] = -1
				end
				monitor["whole"].setCursorPos((centerX-10)+(selectionID-1)*3,monSizeY-9)
				monitor["whole"].setBackgroundColor(colors.black)
				monitor["whole"].write("  ")
			end
		end
	-- keyboard
	elseif y >= monSizeY - 7 then		-- validation
		if (within(y,monSizeY-5,monSizeY-2) and within(x, centerX-2, centerX+4)
		or (y-(monSizeY-8) == DHDkeysPos[0][2] and within(x-(centerX-14), DHDkeysPos[0][1], DHDkeysPos[0][1]+2)))
		and #monitor["DHDaddress"] >= 6 and not(table.find(monitor["DHDaddress"],-1)) then
			
			monitor["whole"].setBackgroundColor(colors.orange)
			for i=monSizeY-5,monSizeY-2,1 do
				monitor["whole"].setCursorPos(centerX-2,i)
				monitor["whole"].write("       ")
			end
			if DHDgeneration == 2 then
				monitor["whole"].setCursorPos(centerX-3,monSizeY-5)
				monitor["whole"].blit("\151\131\131\131\131\131\131\148","fffffff1","1111111f")
				monitor["whole"].setCursorPos(centerX-3,monSizeY-4)
				monitor["whole"].blit("\149      \149","fffffff1","1111111f")
				monitor["whole"].setCursorPos(centerX-3,monSizeY-3)
				monitor["whole"].blit("\149      \149","fffffff1","1111111f")
				monitor["whole"].setCursorPos(centerX-3,monSizeY-2)
				monitor["whole"].blit("\138\143\143\143\143\143\143\133","11111111","ffffffff")
			else
				monitor["whole"].setCursorPos(centerX-2,monSizeY-5)
				monitor["whole"].blit("\151\131\131\131\131\131\148","ffffff1","111111f")
				monitor["whole"].setCursorPos(centerX-2,monSizeY-4)
				monitor["whole"].blit("\149     \149","ffffff1","111111f")
				monitor["whole"].setCursorPos(centerX-2,monSizeY-3)
				monitor["whole"].blit("\149     \149","ffffff1","111111f")
				monitor["whole"].setCursorPos(centerX-2,monSizeY-2)
				monitor["whole"].blit("\138\143\143\143\143\143\133","1111111","fffffff")
			end
			monitor["whole"].setTextColor(colors.orange)
			keyLight(0)
			monitor["whole"].setBackgroundColor(colors.black)
			monitor["whole"].setTextColor(colors.white)
			
			for i,v in pairs({"/","-"}) do
				sleep(0.5)
				for i=centerX-11, centerX-11+(3*#monitor["DHDaddress"]), 3 do
					monitor["whole"].setCursorPos(i,monSizeY-9)
					monitor["whole"].write(v)
				end
			end
			sleep(1)
			dialAddress = monitor["DHDaddress"]
			rawDialAddress = interface.addressToString(dialAddress)
			dialAddress[#dialAddress+1] = 0
			dialAddressLength = #dialAddress
			overrideMenu = "dialing"
			local dialID
			if #dialAddress == 9 then
				dialID = table.find(gateAd,rawDialAddress,"address9")
				if dialID then dialName = gateAd[dialID]["name"] end
			else
				if #dialAddress == 7 then
					dialID = table.find(solSysAd,rawDialAddress,"address7")
				else
					dialID = table.find(solSysAd,rawDialAddress,"address7")
				end
				if dialID then dialName = solSysAd[dialID]["name"] end
			end
			if not dialID then
			dialName = "Unknown"
			end
			menu_display_dialing()
			dial(dialAddress)

		elseif #monitor["DHDaddress"] < 8 or table.find(monitor["DHDaddress"],-1) then
			local key = nil
			local firstCheck = 1
			for i,v in pairs(DHDkeysType) do
				for j = firstCheck, v[1], 1 do
					if y-(monSizeY-8) == DHDkeysPos[j][2] and within(x-(centerX-14), DHDkeysPos[j][1]-v[2], DHDkeysPos[j][1]+v[3])  then
						key = j
						break
					end
				end
				firstCheck = v[1] + 1
				if key then break end
			end
			local toEdit = table.find(monitor["DHDaddress"],-1)
			if not toEdit then toEdit = #monitor["DHDaddress"] + 1 end
			
			if key and not(table.find(monitors[eventType]["DHDaddress"],key))then
				monitor["whole"].setTextColor(colors.orange)
				keyLight(key)
				monitor["whole"].setBackgroundColor(colors.black)
				monitor["whole"].setCursorPos((centerX-10)+(toEdit-1)*3,monSizeY-9)
				if key < 10 then monitor["whole"].write("0") end
				monitor["whole"].write(key)
				monitors[eventType]["DHDaddress"][toEdit] = key
				
			end
		end
	end
end

function drawGate()
	local WHopen = interface.isWormholeOpen()
	local monSizeX, monSizeY, centerX, centerY = monUtils(monitor["whole"])
	monitor["whole"].setCursorPos(centerX-4, monSizeY-8)
	monitor["whole"].setBackgroundColor(colors.purple)
	for j = 0,7,1 do
		monitor["whole"].setCursorPos(centerX-4, monSizeY-8+j)
		monitor["whole"].write("           ")
	end
	if WHopen then
		monitor["whole"].setBackgroundColor(colors.lightBlue)
	else monitor["whole"].setBackgroundColor(colors.black)
	end
	for j = 0,5,1 do
		monitor["whole"].setCursorPos(centerX-3, monSizeY-7+j)
		monitor["whole"].write("         ")
	end
	if WHopen then
		monitor["whole"].setBackgroundColor(colors.white)
		monitor["whole"].setCursorPos(centerX,monSizeY-6)
		monitor["whole"].write("   ")
		monitor["whole"].setCursorPos(centerX,monSizeY-5)
		monitor["whole"].write("   ")
		monitor["whole"].setBackgroundColor(colors.orange)
	else monitor["whole"].setBackgroundColor(colors.brown)
	end
	for j=1,9,1 do
		monitor["whole"].setCursorPos(centerX-4+chevronCoord[j][1],monSizeY-8+chevronCoord[j][2])
		monitor["whole"].write(" ")
	end
end

-- Menus end --

--[[ Execution ]]--


monitors = { peripheral.find("monitor") }
-- 
-- monitor = monitors[1]
local monitorsLength = #monitors
for i = monitorsLength, 1 , -1 do
	local name = peripheral.getName(monitors[i])
	monitors[name] = {}
	monitors[name]["whole"] = monitors[i]
	table.remove(monitors,i)
end
x=0
y=0
configInit()
if interface.isStargateConnected() and not(interface.isWormholeOpen()) and not (interface.isStargateDialingOut()) then
	if interface.getChevronsEngaged() < irisChevronLimit then
		if config["irisConfig"] == "closeIrisChevron" then
			interface.closeIris()
		elseif config["irisConfig"] == "openIrisChevron" then
			interface.openIris()
		end
	end
end
dataInit()
term.clear()
local loadAd = {}
monitors["terminal"] = {["whole"] = term}
if table.find(groups, config["selectedMenu"]) then
	for i = 1, #gateAd, 1 do
		if string.find(adConfig[gateAd[i]["name"]]["groups"],config["selectedMenu"]) then
			table.insert(loadAd, gateAd[i]["name"])
		end
	end
	if config["menuOrder"] == "alphabetical" then
		table.sort(loadAd)
	end
elseif config["selectedMenu"] ~= "Solar_Systems"  then
	config["selectedMenu"] = "main"
end
for i,v in pairs(monitors) do
	monitors[i]["whole"].setCursorPos(1,1)
	monitors[i]["loadAd"] = loadAd
	monitors[i]["page"] = 1
	if monitors[i]["whole"] ~= term then
		monitors[i]["whole"].setTextScale(config["textScale"])
		for j = config["textScale"], 0.5, -0.5 do
			v["whole"].setTextScale(j)
			local monSizeX, monSizeY = v["whole"].getSize()
			if monSizeX >= 29 and monSizeY >= 11 then
				break
			end
		end
	end
	monitors[i]["whole"].setPaletteColour(colors.lime, 0x6eba57)
	monitors[i]["whole"].setPaletteColour(colors.yellow, 0xF2B233)
	monitors[i]["whole"].setPaletteColour(colors.pink, 0xffc042)
	monitors[i]["whole"].setPaletteColour(colors.magenta, 0x4a7cdf)
	monitors[i]["whole"].setPaletteColour(colors.purple, config["gateColor"])
	monitors[i]["whole"].setPaletteColour(colors.brown, config["chevronOffColor"])
	monitors[i]["whole"].setPaletteColour(colors.orange, config["chevronOnColor"])
	monitors[i]["whole"].setPaletteColour(colors.cyan, config["vortexColor"])
	monitors[i]["whole"].setPaletteColour(colors.lightBlue, config["vortexWhiteColor"])
end

if interface.isStargateConnected() then
	overrideMenu = "open"
	if interface.isWormholeOpen() then
		irisStatus = "standby"
	else
		os.pullEvent("stargate_incoming_wormhole")
	end
	if interfaceType == 3 then
		connexion(interface.getConnectedAddress())
	else
		connexion()
	end
	if irisStatus == "closeIrisChevron" then		-- in case faster iris closing failed
		irisStatus = "closeIris"
	elseif irisStatus == "openIrisChevron" then
		irisStatus = "openIris"
	end
	doReset = false
	for i,v in pairs(monitors) do
		monitor = monitors[i]
		monitor["whole"].setBackgroundColor(colors.black)
		monitor["whole"].clear()
		drawGate()
	end
	menu_display_open()
else
	interface.disconnectStargate()
	overrideMenu = "none"
	irisStatus = config["irisDiscoConfig"]
	doReset = true
end
rotation = 0
while true do
	parallel.waitForAny(eventDetector,main)
end

--[[ THE END ]]--
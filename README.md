# SGCos version 1.0.0

There is a LOT to say about this programm.

----- Installation -----

	1 - place the whole "SGCos" directory in your rom directory or disk main directory.
	2 - you can extract the dial lua file in the rom directory if you want.
	3 - move "startup.lua" to the rom directory, to make sure the dial program will be automatically launched.
	now you are ready to configure your address and the config file.
	there are a lot you can do thanks to the config file.

----- How to use -----

One thing i would recommend is to lock the access to the terminal, otherwise other players will have access to all of your database.

### Files ###

	- solarSystems.txt is for your solar system intra and inter galactic addresses
	- gateAddresses-<type>.txt where type can be public, faction or private. They are all for your gate addresses.
	  The reason there are 3 is for addresses sharing on servers.

	- addressConfig is for multiple additionals config for each address.
	  It is not required and will autofill every missing address with default values when you start the programm.

	- config.cfg is for the settings. It is the only data file that can't be updated through the update menu
	
	- GDO.txt is for your GDO codes and frequency. It also starts with a name that will be displayed in the "open" menu when received
	  the "command" field tells the programm what to do when it receive this code.
	  (just in case you want to be able to close the iris or disconnect the vortex with the GDO)

	- whitelist.txt and blacklist.txt allow you to set the white and black lists of the gate.
	  It will only update it once you click the list update button in the update menu.

#### Menus ####

	- closed : is the menu you land at when the programm is started and when the stargate is disconnected or the dialing failed.

	- selection menus
		- main : the menu that allow you to access the Solar_Systems and <groups>

		- Solar_Systems : the solar system addresses selection menu. The programm will automatically choose weather it should use the galactic or intergalactic address.

		- <groups>: the group menu. when you select a group in the main menu, this menu is loaded with all the addresses that are in this group
					(only for "gate addresses")
					to add a group, you will need to fill the field "groups" in the "addressConfig.txt" file.
					The groups of a gate are saved as the name separated by commas with no space. example: all,alpha,bravo,charlie
									

	- DHD : allows you to input the address you want to dial. There are 3 different DHD style.
			unless it is overwritten in the config file, it will choose the best suited DHD for your gate generation.
			(universe: 0-35; classic/milky_way: 1-38; tollan/pegasus: 0-47)
			a number cannot be entered twice
			if you made a mistake, you can click the number in the upper part to erase it from the address. You can then enter a new value.
			When you choose a symbol, the left most available space will be filled.
			you can't validate an address if it doesn't have at least 6 symbols or you didn't fill the holes you made in the address.
			when present, if you press 00, it act the same as the central button: validation.

	- validation : make sure you want to dial the address you selected.

	- Update : allow you to update your data files with the pastebin you configured. Be aware, there is no validation screen.
			   as an additional option, it allows you to swap between blacklist, whitelist, no list,
			   and update the whitelist and blacklist the addresses in your blacklist and whitelist files.
			   the list options require an advanced_crystal_interface.
			   The addresses are not added, the lists are completely replaced.
			   The address can be in the string format of the mod (-1-2-3-4-5-6-), or the address name if it is in your database.
			   
			   this menu can be set to not being accessible from the monitors, but will always be accessible from the terminal.

	the DHD menu and Update menu are accessible from any of the selection menus.
	
	- operation menus
		- Dialing : Display a representation of the gate, chevrons are lit up as they are encoded on the gate, wether it is an incoming or outgoing connection.
					When dialing out, it allows you to pause dialing and abort dialing.
					
		- Open : still display a representation of the gate, and allow you to close/open the iris (as long as you don't have a tollan gate) and disconnect the vortex


----- How to configure -----


The last file to configure is the "configAd.txt" file, where you can configure various things for each address.
If a gate doesn't exist in this file, it will auto-fill the line when you start the program.

Groups , sendCode and receiveCode are not available for solar system addresses.


if you are worried about disk usage, you can have about 125kB of data in a floppy disk.
The main program is currently 67kb, config is about 2kB, and the other files (the one that matters to you) are about 1kB each by default
so you have about 90kB available for storing your gate addresses
I'm not counting the read me file in the memory because puting it in the computer is useless

Now, let's dive in the different config specificity

### config.cfg ###

menuOrder : the order of addres apparition in the menu. "file" = the file's order. "alphabetical" = the alphabetical order.
selectedMenu : the first menu the program will load. can be "Solar_Systems","main", or any of your groups name.
textScale : the default textScale of the monitors
irisConfig : the iris setting when the vortex is connected
irisDiscoConfig : the iris setting when the vortex is not connected
irisBothWays : wether or not the iris settings shall apply when dialing out. can be true or false.
iris settings :
	- [both] - "closeIris"/"openIris" will close/open the iris once connected or when 
	- [irisConfig] - "closeVortex" will atempt to disconnect the vortex once connected. Will close the iris if it can't close the vortex.
	- [irisConfig] - "closeIrisChevron1"/"openIrisChevron1" will close the iris as soon as chevron 1 is activated.
					 value can vary from 0 to 8, tho it will be limited to 3 upon recieving connection to prevent the vortex formation from destroying the iris.
					 pegasus stargate incoming value will always be 1 as it dial in faster than the other gates.
					 if used for the "irisDiscoConfig", will simply act as "closeIris"/"openIris"
	/// when the connection is incoming and the chunk wasn't loaded ///
		if set to an "IrisChevron" setting, will attempt to close the iris if it has not reached the safety limit yet.
		otherwise, will close the iris once the kawoosh end. 




milkyDial
	- "classic" will function as a classic stargate: chevrons are activated instantly. Require at least the crystal interface.
	- "fast" will find the fastest path
	- "slow" will find the slowest path
	- "alternate" will alternate rotation direction starting clockwise
	- "alternateInv" will alternate rotation direction starting anti clockwise
	- "clockwise-0" will rotate clock wise until the dialing is complete. if number is higher than 0, it will do this ammount of full rotation while dialing
	- "anticlockwise-0" same as "clockwise-0" but anti clockwise
	--- what if you wanted to encode the chevron on the go with (anti)clockwise mode? ---
		to do this, you will need to
			- have at least a crystal interface
			- and set the x number of "clockwise-x" or "anticlockwise-x" to at least 1
		this work but what if you want the ring to not stop?
			- set the first, second and last values of "chevronDelay" to 0
		now, the gate encode chevron while rotating, without stopping, doing the specified ammount of rotation (0 means this mode is disabled)
		please note that the number can be a float. As far as I know, the number can be anything.
		The most I've tested is 27, but you can go up to infinity, or your patience.
		when using this setting, I would recommend having the "chevronReset" configuration enabled
			
milkyMinRota : the minimum distance the ring has to travel in fast mode. In slow mode, will go the short path if it is under this distance.
	value can vary from 1 to 18. The closer it get to 19, the more it acts as the oposite mode of dialing.
milkyResetSymbol : the symbol the gate will rest on once disconnected. 0 is the point of origin.
milkySymbolReset : wether the previous functionality should be enabled or disabled
galaxy : the galaxy you are in. useful if the "localAddress" is not in your database.
solarSystem : the solar system you are in. useful if the "localAddress" is not in your database.
localAddress : the address of this gate. can be it's 9 chevrons address or it's name, but if it is not in the database, it will be useless.
chevronOrder7/8/9  : the order of activation of the chevrons depending on the address length.

chevronDelay
	- "a,b,c,d" chevron delays in between: ring stopped [a] open chevron [b] encode chevron [c] close chevron [d] ring start moving
	- "a,b,0,d" skip the encoding part. the chevron closing does the same thing anyway
	- "a,0,c,d" doesn't open the chevron. it is the same as "a,0,0,d". The chevron will be engaged instead of encoded if the interface a crystal or advanced interface
	- "0,b,c,d" won't send the stop command. Mostly useful in the setup "0,0,0,0" in conjunction with "(anti)clockwise-1" with a value of at least 1
	it will rotate the ring in one direction until it has made the set ammount of full rotation.

when set to clockwise-x where "x" is above 0. I don't know the exact minimum float value, x can thheorically be in range ~0 to infinity (or your maximum patience).
	- "0,0,c,d"	will move until it has travel "x" rotation. Note that x can be a float.
	- "a,0,c,d" will move "x" ammount of rotation like before, but will stop instead of encoding on the go
	
anytime the [b] delay is not 0, it will consider it as the normal clockwise.
/!\		In the current version, when in clockwise x rotation mode, the pause button will reset the rotation progress.


it is worth noting: if you use the "0,0,b,0" delay setting plus the (anti)clockwise-x setting where x is an int or float above 0, and you have at least
a crystal interface, it will engage the chevrons on the go with a fixed angle each (the angle correspond to your total rotation angle divided by the number of chevrons of your address. clockwise-1.5 with a 9 chevrons address means it will engage after each 1/6th of the gate)
the starting chevron will be whatever is at the top position when it start dialing. If you want it to be a fixed symbol, you can still enable the "milkyChevronReset" option and configure the "milkyResetChevron" option.

pegDefaultSymbols : the default symbols of your pegasus stargate
pegDefaultPOO	  : the default point of origin of your pegasus stargate




### addresses data ###
solar system addresses :
	starting on line 3 you must enter 4 data for your solar systems addresses, separated by " , " (spaces included):
		- name
		- 7 chevrons address
		- 8 chevrons address
		- galaxy
	example : abydos    -27-25-4-35-10-28-      -1-35-4-31-15-30-32-      MilkyWay
	
gate local addresses system :
	basically the same, but with 3 datas:
		- name
		- 9 chevron address
		- solar system
	example : headquarter       -15-6-13-4-22-24-11-2-      Tauri
the ammount of spaces doesn't matter.

### address settings ###
	the data in this files are separated by " , " (spaces included (space > comma > space))
	the groups in the "groups" field are separated by a single comma (",") without any space
	the receiveCode code fields must be separated by a dot (".") (frequency.code). the sendCode field is not yet implemented, and must be "none"
		- name (to find the settings)
		- irisConfig*
		- sendCode: /// not yet implemented /// (automatically send a code when dialing out)
		- receiveCode: if the incoming address is recognized in the database through an avanced crystal interface,
		  will require the specified code to open the iris. All other opening code won't work if receiveCode is configured
		- pegDefaultSymbols*
		- pegDefaultPOO*
		- groups (you can have up to 20 group)
	it should be in this order:
		solar system address : name , irisConfig , pegasusSymbol , pegasusPoo
		local address : name , irisConfig , sendFrequency.sendCode , receiveFrequency.receiveCode , pegasusSymbol , pegasusPoo , group1,group2,group3,etc
	example 1 : lantea , openIris , lantea , kaliem
	example 2 : ennemy , closeIris , none , none , default , giza , all,enemies,jungle,raid
	example 3 : ally , closeIris , none , 1234.9876 , default , default , all,allies,mines,jungle
groups are exclusives to local addresses
it is worth noting that when you start the programm, any address that doesn't appear in the address file is added automatically to the file with all the values set to default.


" * " : specific to this address. if the value is default and it's a gate address, it will use the solar system value. If it's value is still default, it will use the default setting.


### blacklist file ###
one address per line. Can be a name or address with the mod's format. If it's a name and is in the database, it will be able to find it.
#### blacklist file ####
same as blacklist

for the blacklist and whitelist to be effective, you will need to update it with the update button from the update menu.

### GDO ###
on each line : a unique name (to identify the code), the frequency, the code, then the command.
frequency and code must be numbers.
command must be "openIris", "closeIris", "closeVortex" or "standby"
"standby" won't do anything but still displays the code "name"

Any code set to "openIris" won't work if the connected address  is known and have a "receiveCode"

Don't forget that you need a connected transceiver for each frequency you want to be able to read.

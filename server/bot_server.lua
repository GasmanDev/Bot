local safezoneGate = nil
local keypadSafeZoneCol = nil
local doorSafeZoneCol = nil
local botIsCreated = false
function initBot( )
	-- Cần thay đổi khi add vào mode
	createTeam("Survivor")
	createTeam("NonSurvivor")
	createTeam("Zombie")

	for i, elements in ipairs(getElementsByType("player")) do
		setPlayerTeam( elements, getTeamFromName( "Survivor" ) )
	end
	-- 
	spawnHZBot()
	
	-- pos open = 21.8
	-- close = 30.0
end
addEventHandler( "onResourceStart", getRootElement(), initBot )
function initBotz( )
	if botIsCreated == false then 
		spawnHZBot()
		botIsCreated = true
	end
end
addEventHandler( "onPlayerJoin", getRootElement(), initBotz )
-- Safezone door
function safeZoneDoorColHit ( hitElement, matchingDimension )
	if getElementType (hitElement) == "player"then
		if getElementData( source, "Safezone.MainDoor.Col" ) == true then
			if getElementData( hitElement, "AcceptSFR") == false then -- Bọc sường vào lách luật sẽ bị set luôn NonSurvivor
				setPlayerTeam( hitElement, getTeamFromName( "NonSurvivor" ))
				setTimer( function()
					if isElement(hitElement) then
						setPlayerTeam( hitElement, getTeamFromName( "Survivor" ))
					end
				end, 900000, 1)
			end
		end
	end
end
addEventHandler ( "onColShapeHit", getRootElement(), safeZoneDoorColHit )

-- Safezone keyppad
function safeZoneKeypadColHit ( hitElement, matchingDimension )
	if getElementType (hitElement) == "ped"then
		if getElementData( source, "Safezone.Keypad.Col" ) == true then
			if getElementData(hitElement, "isBot") == true and 
        	getElementData(hitElement, "Armed.Action") == "Gatekeeper" then 
        		outputDebugString( "CLOSE GATE")
        		setPedAnimation( hitElement)
        		setElementData(hitElement, "Guard.Panic", false)
        		setElementData(hitElement, "Guard.CloseDoor", true)
        		moveObject(safezoneGate, 1000,-2539.8999, -276.79999, 34.0)
        		setTimer( function( )
        			if isElement( hitElement ) and not isPedDead( hitElement ) then
        				moveObject(safezoneGate, 1000,-2539.8999, -276.79999, 10.0)
        				setElementData(hitElement, "Guard.CloseDoor", false)
        				setElementPosition(hitElement, -2587.7305,-271.3783,19.9389)
        			end
        		end, 300000, 1)
        	end
		end
	end
end
addEventHandler ( "onColShapeHit", getRootElement(), safeZoneKeypadColHit )
-- Citizen
		-- Normal
			-- Walk
function spawnHZBot( )
	local peds = getElementsByType ( "ped" )
	for theKey,ped in ipairs(peds) do
	   if getElementData(ped, "isBot") == true then 
	    	destroyElement( ped )
	   end
	end
	walkSpawnPoint = getElementsByType ( "pathpointwalk" )
	for i = 1,6 do -- 6 citizen walk in safe SF
		randomPoint = table.random(walkSpawnPoint)
		local wx,wy,wz = getElementPosition( randomPoint )
		wz = wz + 1
		createCitizen(false, "random", "random", "Normal", "Walk", wx, wy, wz, 0, 0, 0, "SF")
	end
	createCitizen(false, "random", "random", "Normal", "Breed", -2468.7, -270.39999, 39.6, 0, 0, 0, "SF")
	createCitizen(false, "random", "random", "Normal", "Breed", -2403.8999, -215.7, 39.9, 0, 0, 0, "SF")
	
	createCitizen(false, "random", "random", "Normal", "Sing", -2508.6001, -258.5, 39.2, 124.002, 0, 0, "SF")

	createCitizen(false, "random", "random", "Normal", "Listen", -2511.5, -258, 38.7, 248.001, 0, 0, "SF")
	createCitizen(false, "random", "random", "Normal", "Listen", -2511.2, -260.10001, 38.8, 296.001, 0, 0, "SF")

	createCitizen(false, "Male", (math.random(1,2) == 1 and 62 or 68), "Normal", "Ceremony", -2462.6001, -309.10001, 41.7, 358.003, 0, 0, "SF")

	createCitizen(false, "random", "random", "Normal", "Faithful", -2465.3, -306.20001, 41.6, 272.004, 0, 0, "SF")
	createCitizen(false, "random", "random", "Normal", "Faithful", -2460.6001, -305.89999, 41.7, 92.003, 0, 0, "SF")
	createCitizen(false, "random", "random", "Normal", "Faithful", -2463.2, -303.5, 41.6, 184.004, 0, 0, "SF")

	-- Armed
	createArmed("Vệ Môn", "random", "random", "Guard", "Gatekeeper", -2587.7305,-271.3783,19.9389,139.3757, 0, 0, "SF")

	createArmed("Trực chiến", "random", "random", "Guard", "Combat", -2586.8259,-263.6920,19.8447,136.9096, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30))
	createArmed("Trực chiến", "random", "random", "Guard", "Combat", -2584.5073,-289.5153,22.2276,16.7419, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30))
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2473.7888,-257.5725,39.5281,48.8908, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30))
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2484.8179,-303.6848,45.6223,26.8749, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30)) 
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2453.8613,-292.4406,45.6223,284.2208, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30)) 
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2451.4968,-243.2486,40.8281,95.4980, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30)) 
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2393.5850,-219.5343,41.7039,168.1199, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30)) 
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2397.2966,-251.1535,39.8671,152.6345, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30)) 
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2424.4653,-278.4349,40.4646,120.0215, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30)) 
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2517.0029,-298.1383,55.3366,14.9585, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30)) 
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2503.4795,-307.2539,44.1553,245.6012, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30)) 
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2508.2976,-304.8133,44.1553,39.4769, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30)) 
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2525.3960,-290.8199,38.8296,40.1025, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30)) 
	createArmed("Trực chiến", "random", "random", "Guard", "Combat",-2526.4211,-272.5870,38.8314,125.1155, 0, 0, "SF", (math.random(1,2) == 1 and 31 or 30))

	createArmed("Xạ thủ", "random", "random", "Guard", "Sniper",-2531.4973,-268.8865,63.0651,234.6705, 0, 0, "SF", 34)
	createArmed("Xạ thủ", "random", "random", "Guard", "Sniper",-2490.6797,-326.5759,58.0576,34.6465, 0, 0, "SF", 34)
	createArmed("Xạ thủ", "random", "random", "Guard", "Sniper",-2451.8555,-308.8170,57.3755,29.2109, 0, 0, "SF", 34)

	createArmed("Đao phủ", "Male", 241, "Guard", "Rhino",-2476.4365,-307.9023,41.4636,106.1201, 0, 0, "SF", math.random(2,3))
	createArmed("Đao phủ", "Male", 241, "Guard", "Rhino",-2485.9922,-257.6933,39.1692,244.3267, 0, 0, "SF", math.random(2,3))

	-- Safezone setup
	if isElement( doorSafeZoneCol ) then destroyElement( doorSafeZoneCol ) end
	doorSafeZoneCol = createColSphere( -2543, -280, 35, 5.0 )
	setElementData(doorSafeZoneCol, "Safezone.MainDoor.Col", true)
	
	if isElement( keypadSafeZoneCol ) then destroyElement( keypadSafeZoneCol ) end
	keypadSafeZoneCol = createColSphere( -2595, -253.2, 19.9, 2.0 )
	setElementData(keypadSafeZoneCol, "Safezone.Keypad.Col", true)

	if isElement( safezoneGate ) then destroyElement( safezoneGate ) end
	safezoneGate = createObject( 10828, -2539.8999, -276.79999, 10.8, 0, 90, 90)
    setObjectScale(safezoneGate, 0.8)
end
function refreshCitizenWalk( )
	local peds = getElementsByType ( "ped" )
	for theKey,ped in ipairs(peds) do
	   if getElementData(ped, "isBot") == true then 
	    	destroyElement( ped )
	   end
	end
	spawnHZBot()
end
setTimer( function()
	refreshCitizenWalk()
end, 1200000, 0)

local chatRadius = 40 --units
-- Bot Chatting
addEvent("SendChatToNearbyPlayers",true)
function sendToNearbyPlayers (chattingped,message,output)
	if not ouput then output = 0 end
-- get the chatting player's position
	local posX, posY, posZ = getElementPosition( chattingped )
		
	local chattingpedType = getElementType(chattingped)
	local chattingpedName
	if chattingpedType == "player" then 
		chattingpedName = getPlayerName(chattingped)
	elseif chattingpedType == "ped" then 
		chattingpedName = getElementData(chattingped,"botName") or ""
	else
		chattingpedName = " "
	end
        -- create a sphere of the specified radius at that position
    local chatSphere = createColSphere( posX, posY, posZ, chatRadius )
        -- get a table w/ all player elements inside it
    local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )
        -- and destroy the sphere, since we're done with it
    destroyElement( chatSphere )
    if nearbyPlayers then
        -- deliver the message to each player in the table
		for index, nearbyPlayer in ipairs( nearbyPlayers ) do
			triggerClientEvent(nearbyPlayer,"onChatIncome", chattingped, message)	--this ADDs BUBBLE CLIENTSIDE
			if output == 1 then outputChatBox( chattingpedName..":"..message, nearbyPlayer) end
		end
		--triggerEvent("sendText", nearbyPlayer, chattingpedName..": "..message, "Local", true)			
	end
end
addEventHandler("SendChatToNearbyPlayers",root,sendToNearbyPlayers)
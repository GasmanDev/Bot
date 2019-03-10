function initBot( )
	-- Cần thay đổi khi add vào mode
	createTeam("Survivor")
	createTeam("Bandit")
	createTeam("Zombie")

	for i, elements in ipairs(getElementsByType("player")) do
		setPlayerTeam( elements, getTeamFromName( "Survivor" ) )
	end
	-- 
	spawnCitizenWalk()
end
addEventHandler( "onResourceStart", getRootElement(), initBot )

-- Citizen
		-- Normal
			-- Walk
function spawnCitizenWalk( )
	local peds = getElementsByType ( "ped" )
	for theKey,ped in ipairs(peds) do
	   if getElementData(ped, "botType") == "Citizen" and getElementData(ped, "Citizen.Type") == "Normal" then 
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

end
function refreshCitizenWalk( )
	local peds = getElementsByType ( "ped" )
	for theKey,ped in ipairs(peds) do
	   if getElementData(ped, "botType") == "Citizen" and getElementData(ped, "Citizen.Type") == "Normal" then 
	    	destroyElement( ped )
	   end
	end
	spawnCitizenWalk()
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
--[[
	by Anderson
	structure

	ElementData

	- Bot.Type = [Citizen,Armed]
		+type = Citizen [Done]
		+type = Armed
			- Name - Name of Armed
			- Gender - Gender of Citizen(Male/Female)
			- Skin
			- Armed.Type = [Guard]
				- Type = Guard
					+ Action = [Gatekeeper,Combat,Sniper,Rhino]

	- Gatekeeper [DONE]
	- Combat [Done]
	- Sniper [Done]
	- Rhino [Done]

	type: SERVER
]]

-- Function Create Guard
function createArmed(name, gender, skin, type, action, x, y, z, rot, interior, dimension, safezonename, weapon)
	if not weapon then weapon = (math.random(1,2) == 1 and 24 or 29) end
	if not name then name = "Bảo vệ" end
	if gender == "random" or nil then 
		gender = (math.random(1,2) == 1 and "Male" or "Female")
	end
	if skin == "random" or nil then 
		if gender == "Male" then 
			skin = table.random(guardMaleSkin)
		else
			skin = table.random(guardFemaleSkin)
		end
	end
	if not safezonename or safezonename == nil then
		safezonename = "SF"
	end
	local ped = nil
	if action == "Gatekeeper" then
		ped = createPed( skin, x, y, z, rot )
	else
		ped = exports["slothbot"]:spawnBot (x,y,z,rot,skin,interior,dimension, getTeamFromName("Survivor"), weapon, "guarding", nil, "normal")
	end
	setElementInterior(ped, interior )
	setElementDimension(ped, dimension)
	setElementData(ped, "isBot", true)
	setElementData(ped, "botName", name )
	setElementData(ped, "BotTeam", getTeamFromName("Survivor"))
	setElementData(ped, "botGender", gender )
	setElementData(ped, "botType", "Armed")
	giveWeapon( ped, weapon, 99999, true )
	-- Armed Data
	setElementData(ped, "Armed.Type", type )
	setElementData(ped, "Armed.Action", action )
	setElementData(ped, "Armed.Dead", false )
	setElementData(ped, "Armed.Safezone", safezonename )
	setElementData(ped, "Armed.Target", nil )
	-- Handlers
	if type == "Guard" then
		if action == "Gatekeeper" then
			outputDebugString( "Gatekeeper CREATED")
			local gateKeeperCol = createColSphere ( x,y,z, 10.0 )
			setElementData(gateKeeperCol, "Armed.GateKeeper.Col", true)
			setElementData(ped, "leader", nil)
			outputDebugString( "Gatekeeper Col CREATED")
		elseif action == "Combat" then
			-- setBotGuard (ped, x, y, z, true)
			outputDebugString( "Combat CREATED")
		elseif action == "Sniper" then
			outputDebugString( "Sniper CREATED")
		elseif action == "Rhino" then
			outputDebugString( "Rhino CREATED")
			setTimer( updateGuardRhino, 500, 1, ped)
			-- setElementData(ped, "status", "hunting" )
		end
	end
	return ped
end
-- Guard function
function updateGuardRhino( ped )
	if isElement( ped ) and getElementData(ped, "botType") == "Armed" 
		and getElementData(ped, "Armed.Type") == "Guard" and getElementData(ped, "Armed.Action") == "Rhino" then
		local x,y,z = getElementPosition(ped)
		local players = getElementsByType ( "player" )
		for theKey,player in ipairs(players) do
			local x2,y2,z2 = getElementPosition( player )
			if getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 ) < 20 then 
				if getTeamName( getPlayerTeam( player ) ) ~= "Survivor" then
					exports["slothbot"]:setBotWait(ped)
				end
			end
		end
	    setTimer( updateGuardRhino, 500, 1, ped)
	end
end
addEvent( "playerFireNearGuard", true)
function playerFireNearGuard( player, ped )		
	if isElement( ped ) then
		local peds = getElementsByType ( "ped" )
		for theKey,thePed in ipairs(peds) do
			if (getElementData (thePed, "isBot") == true) and getElementData(thePed, "botType") == "Armed" then
				if getElementData(thePed, "Armed.Action") == "Rhino" then
					exports["slothbot"]:setBotWait(thePed)
				end
			end
		end
	end 
	if getTeamName( getPlayerTeam( player ) ) == "Survivor" then
		setPlayerTeam(player, getTeamFromName( "NonSurvivor" ) )
		setTimer( function()
					if isElement(player) then
						setPlayerTeam( player, getTeamFromName( "Survivor" ))
					end
				end, 900000, 1)
	end
end
addEventHandler( "playerFireNearGuard", getRootElement(), playerFireNearGuard)
-- Guard Keeper Function

function gateKeeperColHit ( hitElement, matchingDimension )
	if getElementType (hitElement) == "player"then
		if getElementData( source, "Armed.GateKeeper.Col" ) == true then
			if getElementData( hitElement, "AcceptSFR") == true then -- Khi vào col vệ môn mà đã chấp nhận luật, sẽ bị reset và cho đọc lại
				setElementData( hitElement, "AcceptSFR", false)
			end
			triggerClientEvent(hitElement, "ShowSFZRulesGUI", hitElement)
		end
	end
end
addEventHandler ( "onColShapeHit", getRootElement(), gateKeeperColHit )

function gateKeeperColLeave ( hitElement, matchingDimension )
	if getElementType (hitElement) == "player"then
		if getElementData( source, "Armed.GateKeeper.Col" ) == true then
			
		end
	elseif getElementType(hitElement) == "ped" and getElementData(hitElement, "botType") == "Armed" 
		and getElementData(hitElement, "Armed.Type") == "Guard" and getElementData(hitElement, "Armed.Action") == "Gatekeeper" and
		 not getElementData(hitElement, "Guard.Panic") then 
		local x, y, z = getElementPosition(source)
		setElementPosition(hitElement, x,y,z)
		setElementData(hitElement, "leader", nil)
	end
end
addEventHandler ( "onColShapeLeave", getRootElement(), gateKeeperColLeave )

addEvent( "SafeZoneRulesClick",true )
function playerAcceptSFRules(player, accept)
	if accept == "Yes" then 
		setElementData( player, "AcceptSFR", true)
		outputChatBox( "[SAFE ZONE RULES]: Bạn đã được cấp phép vào Safezone", player)
		takeAllWeapons( player )
	elseif accept == "No" then
		setElementData( player, "AcceptSFR", false)
		if getElementData( player, "noAcceptSFR") == true then -- Nếu đã không chấp nhận 1 lần mà vẫn lặp lại sẽ bị bắn
			setPlayerTeam( player, getTeamFromName( "NonSurvivor" ))
			setTimer( function()
				if isElement(player) then
					setPlayerTeam( player, getTeamFromName( "Survivor" ))
					setElementData( player, "noAcceptSFR", false)
				end
			end, 900000, 1)
		else
			setElementPosition( player, -2658, -283, 8)
			outputChatBox( "[SAFE ZONE RULES]: Do bạn không chấp nhận luật lệ khu an toàn bạn đã bị áp giải ra đây", player)
			outputChatBox( "[SAFE ZONE RULES]: Nếu lặp lại điều này bị sẽ bị bắn", player)
			setElementData( player, "noAcceptSFR", true)
			setTimer( function()
				if isElement(player) then
					setElementData( player, "noAcceptSFR", false)
				end
			end, 300000, 1)
		end
	end
	
end
addEventHandler( "SafeZoneRulesClick", getRootElement(), playerAcceptSFRules)
function botFindRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end
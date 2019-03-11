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

	- Gatekeeper
		+ Người canh cổng có nhiệm vụ đứng im và kiểm tra người muốn vào Safezone (Yêu cầu người đó không có súng trên tay)
		+ Khi bị tấn công mà mục tiêu cách người canh cổng 30m thì sẽ lập tức chạy đến và đóng cổng safezone
		+ Nếu người tấn công dưới 8k máu thì người canh cổng sẽ solo luôn cho nó máu
	type: SERVER
]]

-- Function Create Guard
function createArmed(name, gender, skin, type, action, x, y, z, rot, interior, dimension, safezonename)
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
	-- local ped = createPed( skin, x, y, z, rot )
	local ped = exports["slothbot"]:spawnBot (x,y,z,rot,skin,interior,dimension, getTeamFromName("Survivor"), (math.random(1,2) == 1 and 24 or 29), "guarding", nil, "normal")
	setElementInterior(ped, interior )
	setElementDimension(ped, dimension)
	setElementData(ped, "isBot", true)
	setElementData(ped, "botName", name )
	setElementData(ped, "botGender", gender )
	setElementData(ped, "botType", "Armed")
	-- Armed Data
	setElementData(ped, "Armed.Type", type )
	setElementData(ped, "Armed.Action", action )
	setElementData(ped, "Armed.Dead", false )
	setElementData(ped, "Armed.Safezone", safezonename )
	-- Handlers
	if type == "Guard" then
		if action == "Gatekeeper" then
			outputDebugString( "Gatekeeper CREATED")
			local gateKeeperCol = createColSphere ( x,y,z, 10.0 )
			setElementData(gateKeeperCol, "Armed.GateKeeper.Col", true)
			outputDebugString( "Gatekeeper Col CREATED")
		elseif action == "Combat" then
			outputDebugString( "Combat CREATED")
		elseif action == "Sniper" then
			outputDebugString( "Sniper CREATED")
		elseif action == "Rhino" then
			outputDebugString( "Rhino CREATED")
		end
	end
	return ped
end

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
	-- elseif getElementType(hitElement) == "ped" and getElementData(hitElement, "botType") == "Armed" 
	-- 	and getElementData(hitElement, "Armed.Type") == "Guard" and getElementData(hitElement, "Armed.Action") == "Gatekeeper" then 
	-- 	local x, y, z = getElementPosition(source)
	-- 	setElementPosition(hitElement, x,y,z)
	-- 	setTimer ( setElementData, 400, 1, hitElement, "leader", nil )
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
-- -2543 -280 35
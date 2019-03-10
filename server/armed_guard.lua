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

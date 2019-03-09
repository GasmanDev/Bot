--[[
	by Anderson
	structure

	ElementData

	- Bot.Type = [Citizen,Armed]
		+type = Citizen 
			- Name - Name of Citizen
			- Gender - Gender of Citizen (Male/Female)
			- Skin
			- Citizen.Type = [Normal,Quest,Vendor]
				+ type = Normal [DONE]
					- Citizen.Action = [Walk, Breed, Listen, Sing, Ceremony, Faithful]
					Walk = Walk Around safe zone
					Breed = Walk around Animal lodging
					Listen = Sitting and listen to music
					Sing = Stand sing
					Ceremony = Do anim Ceremony
					Faithful = The Faithful
				+ type = Quest
					- Citizen.Action = [Quest]
				+ type = Vendor
					- Citizen.Action = [Vendor]

			- Other Action = [Panic,Scare]
		+type = Armed
			- Name - Name of Armed
			- Gender - Gender of Citizen(Male/Female)
			- Skin
			- Armed.Type = [Guard]


	-- #1 Create Citizen [Done]
	-- #2 Interacting Citizen Walk [Done]
	-- #3 Panic Citizen Walk [Done]
	-- #4 Kill Citizen [Done]

vậy cho 6 con đi bộ 2 con chăn nuôi, 1 con hát, 2 con nghe, 4 con tín đồ đang làm lễ
	type: SERVER
]]

-- Function Create Citizen

function createCitizen(name, gender, skin, type, action, x, y, z, rot, interior, dimension, safezonename)
	if not name then name = "Cư dân" end
	if gender == "random" or nil then 
		gender = (math.random(1,2) == 1 and "Male" or "Female")
	end
	if skin == "random" or nil then 
		if gender == "Male" then 
			skin = table.random(citizenMaleSkins)
		else
			skin = table.random(citizenFemaleSkins)
		end
	end
	if not safezonename or safezonename == nil then
		safezonename = "SF"
	end
	local ped = createPed( skin, x, y, z, rot )
	setElementData(ped, "BotTeam", getTeamFromName("Survivor"))
	setElementInterior(ped, interior )
	setElementDimension(ped, dimension)
	setElementData(ped, "isBot", true)
	setElementData(ped, "botName", name )
	setElementData(ped, "botGender", gender )
	setElementData(ped, "botType", "Citizen")
	-- Citizen Data
	setElementData(ped, "Citizen.Type", type )
	setElementData(ped, "Citizen.Action", action )
	setElementData(ped, "Citizen.Panic", false )
	setElementData(ped, "Citizen.Dead", false )
	setElementData(ped, "Citizen.Safezone", safezonename )
	-- Handlers
	if type == "Normal" then
		if action == "Walk" then
			-- outputDebugString( "WALK CREATED")
			setTimer ( citizenFindPath, 200, 1, ped )
		elseif action == "Breed" then
			-- outputDebugString( "Breed CREATED")
			setTimer ( citizenFindPath, 200, 1, ped )
		elseif action == "Listen" then
			-- outputDebugString( "Listen CREATED")
			setTimer ( citizenListen, 200, 1, ped )
		elseif action == "Sing" then
			setTimer ( citizenSing, 200, 1, ped )
			-- outputDebugString( "Sing CREATED")
		elseif action == "Ceremony" then
			-- outputDebugString( "Ceremony CREATED")
			setTimer ( citizenCeremony, 200, 1, ped )
			setElementAlpha(ped, 200 )
		elseif action == "Faithful" then 
			setTimer ( citizenFindPath, 200, 1, ped )
		end
	elseif type == "Quest" then

	elseif type == "Vendor" then

	end
	return ped
end
--[[
	Ped type normal and action walk function
]]
-- Ped walk path
addEvent( "citizenFindPath", true )
function citizenFindPath (ped)
	local allwaypoints = 0
	if getElementData (ped, "Citizen.Action" ) == "Walk" then
		allwaypoints = getElementsByType ( "pathpointwalk" )
	elseif getElementData (ped, "Citizen.Action" ) == "Breed" then
		allwaypoints = getElementsByType ( "pathpointbreed" )
	elseif getElementData (ped, "Citizen.Action" ) == "Faithful" then
		allwaypoints = getElementsByType ( "pathpointfaithful" )
	end
	if #allwaypoints > 2 then
		citizenSetPedOnPath(ped, nil)
		-- triggerClientEvent ( "citizenPathfind", ped, ped)
	else
		outputDebugString( "Not have Node")
	end
end
addEventHandler( "citizenFindPath", getRootElement(), citizenFindPath)
--ped picks the path node to start with
addEvent( "citizenPathChoose", true )	
function citizenSetPedOnPath(ped, firstTarget)
	local px,py,pz = getElementPosition( ped )
	local distToBeat = 9999
	if firstTarget == nil then
		local allwaypoints = nil
		if getElementData (ped, "Citizen.Action" ) == "Walk" then
			allwaypoints = getElementsByType ( "pathpointwalk" )
		elseif getElementData (ped, "Citizen.Action" ) == "Breed" then
			allwaypoints = getElementsByType ( "pathpointbreed" )
		elseif getElementData (ped, "Citizen.Action" ) == "Faithful" then
			allwaypoints = getElementsByType ( "pathpointfaithful" )
		end
		for PKey,theNode in ipairs(allwaypoints) do --2nd pass in case theres no nodes in sight, just go to closest.
			local wx,wy,wz = getElementPosition( theNode )
			local distance = (getDistanceBetweenPoints3D( px, py, pz, wx, wy, wz ))
			if distance < distToBeat then
				distToBeat = distance
				firstTarget = theNode
			end
		end
	end
	local nx,ny,nz = getElementPosition( firstTarget )
	local newnodecol = createColSphere ( nx,ny,nz, 1.5 )
	setElementInterior(newnodecol, (getElementInterior(ped)))
	setElementDimension(newnodecol, (getElementDimension(ped)))
	setElementParent ( newnodecol,ped)
	setElementData ( newnodecol, "currentspot", firstTarget )
	setElementData ( newnodecol, "oldspot", firstTarget ) -- sets old spot to new current col cause there is no old onew
	setElementData ( ped, "targetpath", firstTarget ) --sets the peds target
	setTimer ( citizen_Move, 500, 1, ped, px, py, pz )
	setPedRotation(ped, citizenFindRotation(px,py,nx,ny))
end
addEventHandler("citizenPathChoose", getRootElement(), citizenSetPedOnPath)

function citizen_Move (ped,oldX,oldY,oldZ) --this function keeps the ped running towards whatever element is set as its "targetpath" elementdata
	if (isElement(ped)) then
		if getElementData(ped, "botType") == "Citizen" and getElementData(ped, "Citizen.Type") == "Normal" and
		 (getElementData (ped, "Citizen.Action" ) == "Walk" or getElementData (ped, "Citizen.Action" ) == "Breed" or getElementData (ped, "Citizen.Action" ) == "Faithful")
		 and not getElementData(ped, "Citizen.Dead") then
			if getElementData(ped, "Citizen.Panic") and getElementData (ped, "Citizen.Action" ) ~= "Faithful" then
				if getElementData(ped, "botGender") == "Male" then
					setPedAnimation(ped, "ped", "sprint_civi")
				else
					setPedAnimation(ped, "ped", "run_civi")
				end
				citizenChanceTalking = math.random(1,5)
				if citizenChanceTalking <= 2 and not getElementData(ped, "Citizen.Talking") then 
					citizen_Talking(ped, 10)	
				end
				setPedRotation(ped, math.random(0, 360))
				setTimer ( citizen_Move, 1000, 1, ped, oldX,oldY,oldZ)
				return
			end
			local pedhp = getElementHealth ( ped )
			if pedhp > 0 then
				local target = getElementData( ped, "targetpath")
				local tx,ty,tz = getElementPosition( target )
				local px,py,pz = getElementPosition( ped )			
				-- setPedRotation(ped, citizenFindRotation(px,py,tx,ty))
				local randomaction = math.random( 1, 14 )
				if randomaction == 2 then
					setPedAnimation(ped, "ped", table.random(citizenNormalAnims))
					setTimer ( citizen_Move, 1000, 1, ped, px ,py ,pz)
					return true
				elseif randomaction == 1 then 
					local randomtired = math.random(1,10)
					if (randomtired <= 5) then
						setPedAnimation(ped, "ped", "IDLE_tired")
						setTimer ( citizen_Move, 2000, 1, ped, px ,py ,pz)
						return true
					end
				else
					setPedAnimation(ped, "ped", "WALK_civi")
					citizenChanceTalking = math.random(1,10)
					if citizenChanceTalking <= 2 and not getElementData(ped, "Citizen.Talking") then 
						citizen_Talking(ped)	
					end
				end
				setTimer ( citizen_Move, 1000, 1, ped, px ,py ,pz)
				local distance = (getDistanceBetweenPoints3D( px, py, pz, oldX, oldY, oldZ ))
				if distance < 0.5 then -- if the ped is stuck while in hunt mode( if the path nodes are done well enough, this should rarely be an issue)
					local decide = math.random( 1, 13 )
					if decide == 1 then -- give up and find a new path node 
						citizenFindNewPath (ped)
					elseif decide < 3 then -- jump
						setPedAnimation( ped )
						triggerClientEvent ( "bot_Jump", ped )
					else -- randomly turn a new direction, walk a bit, then resume
						setPedRotation(ped, citizenFindRotation(px,py,tx,ty))
					end
				elseif distance > 3 then -- if the player is greater than a distance of 3 units
					local flatdist = (getDistanceBetweenPoints2D( px, py, tx, ty))
					if flatdist < .8 then -- but is directly above or below (for maps with multiple levels or platforms)
						citizenFindNewPath(ped) -- find a new path
					end
				end
			end
		end
	end
end
-- find new path
--when a ped gets stuck, set them in the direction of a new node
addEvent( "onCitizenStuck", true )
function citizenFindNewPath (ped)
	local oldnode = getElementData(ped, "targetpath")
	local distToBeat = 9999
	local firstTarget = nil
	local px,py,pz = getElementPosition( ped )
	local allwaypoints = nil
	if getElementData (ped, "Citizen.Action" ) == "Walk" then
		allwaypoints = getElementsByType ( "pathpointwalk" )
	elseif getElementData (ped, "Citizen.Action" ) == "Breed" then
		allwaypoints = getElementsByType ( "pathpointbreed" )
	elseif getElementData (ped, "Citizen.Action" ) == "Faithful" then
		allwaypoints = getElementsByType ( "pathpointfaithful" )
	end
	for PKey,theNode in ipairs(allwaypoints) do --first pass to find closest node
		if theNode ~= oldnode then
			local wx,wy,wz = getElementPosition( theNode )
			local distance = (getDistanceBetweenPoints3D( px, py, pz, wx, wy, wz ))
			if distance < distToBeat then
				distToBeat = distance
				firstTarget = theNode
			end
		end
	end
	local nx,ny,nz = getElementPosition( firstTarget )
	local newnodecol = createColSphere ( nx,ny,nz, 1.5 )
	setElementInterior(newnodecol, (getElementInterior(ped)))
	setElementDimension(newnodecol, (getElementDimension(ped)))
	setElementParent ( newnodecol,ped)
	setElementData ( newnodecol, "currentspot", firstTarget )
	setElementData ( newnodecol, "oldspot", firstTarget ) -- sets old spot to new current col cause there is no old onew
	setElementData ( ped, "targetpath", firstTarget ) --sets the peds target
	setPedRotation(ped, citizenFindRotation(px,py,nx,ny))
end
addEventHandler( "onCitizenStuck", getRootElement(), citizenFindNewPath )
-- Neighbor Node
function getRandomNeighbor(node, excludedNumber)
	numberString = getElementData(node, "neighbors")
	local numbersArray = {}
	local i = 1
	local curNumber = gettok(numberString, i, string.byte(','))
	while (curNumber) do
		if (not excludedNumber or curNumber ~= excludedNumber) then
			table.insert(numbersArray, curNumber)
		end
		i = i + 1
		curNumber = gettok(numberString, i, string.byte(','))
	end
	-- select a random number
	numElements = #numbersArray
	if (numElements == 0) then
		if (excludedNumber) then
			return excludedNumber
		else
			return false
		end
	elseif (numElements == 1) then
		return numbersArray[1]
	else
		return numbersArray[math.random(1, numElements)]
	end
end

--when a ped hits a path node, decides where to go to next.
function pathHit ( hitElement, matchingDimension )
	if getElementType (hitElement) == "ped"then
		if getElementParent (source) == hitElement then
			local oldnode = getElementData(source, "oldspot")
			local oldnodeid = getElementID (oldnode)
			local currentnode = getElementData(source, "currentspot")			
			local newnodeid = getRandomNeighbor(currentnode, oldnodeid) -- calls the function above to decide the new node
			local newnode = getElementByID (newnodeid)
			local nx,ny,nz = getElementPosition(newnode)			
			local newnodecol = createColSphere ( nx,ny,nz, 1.5 )
			setElementInterior(newnodecol, (getElementInterior(hitElement)))
			setElementDimension(newnodecol, (getElementDimension(hitElement)))
			setElementParent ( newnodecol,hitElement)
			setElementData ( newnodecol, "oldspot", currentnode )
			setElementData ( newnodecol, "currentspot", newnode )			
			setElementData ( hitElement, "targetpath", newnode ) --sets the peds target
			destroyElement (source)
			local px,py,pz = getElementPosition( hitElement )
			setPedRotation(hitElement, citizenFindRotation(px,py,nx,ny))
		end
	end
end
addEventHandler ( "onColShapeHit", getRootElement(), pathHit )

function citizen_Talking(ped, radius) -- Citizen talking
	-- Citizen Normal Walk
	if not radius then radius = 4 end
	for i, elements in ipairs(getElementsByType("player")) do
        local x, y, z = getElementPosition(ped)
        local rot = getPedRotation(ped)
        local mrot = rot + 90
        mrot = math.rad(mrot)
		local jx = x + 1 * math.cos(mrot)
		local jy = y + 1 * math.sin(mrot)
		local ex, ey, ez = getElementPosition(elements)
        if getDistanceBetweenPoints3D(jx, jy, z, ex, ey, ez) < radius then
        	local chatTable = {}
        	if getElementData (ped, "Citizen.Action" ) == "Walk" then -- citizen walk talk
        		if getElementData(ped, "Citizen.Panic") then 
        			chatTable = table.random(citizenWalkPanicChat)
        		else 
        			chatTable = table.random(citizenWalkChat)
        		end
        	elseif getElementData(ped, "Citizen.Action") == "Breed" then 
        		if getElementData(ped, "Citizen.Panic") then 
        			chatTable = table.random(citizenWalkPanicChat)
        		else 
        			chatTable = table.random(citizenBreedChat)
        		end
        	elseif getElementData(ped, "Citizen.Action") == "Faithful" then 
        		if getElementData(ped, "Citizen.Panic") then 
        			chatTable = table.random(citizenPanicFaithfulChat)
        		else 
        			chatTable = table.random(citizenFaithfulChat)
        		end
        	end
        	sendToNearbyPlayers(ped,chatTable)
        	setElementData(ped, "Citizen.Talking", true)
        	setTimer( function ( )
        			if isElement( ped ) then 
        				setElementData(ped, "Citizen.Talking", false)
        			end
        		end, 8500, 1)
        end
    end
end
--[[
	Citizen Normal Sing
]]
function singColHit ( hitElement, matchingDimension )
	if getElementType (hitElement) == "player"then
		if getElementData( source, "Citizen.Sing.Col" ) == true  and not getElementData(source, "Citizen.Dead") then
			local x,y,z = getElementPosition(source)
			triggerClientEvent( root, "playerHearCitizenSing", hitElement, source, getElementData( source, "Citizen.Sing.Url"), x, y, z )
		end
	end
end
addEventHandler ( "onColShapeHit", getRootElement(), singColHit )
function singColLeave ( hitElement, matchingDimension )
	if getElementType (hitElement) == "player"then
		if getElementData( source, "Citizen.Sing.Col" ) == true then
			triggerClientEvent( root, "playerStopHearCitizenSing", hitElement)
		end
	end
end
addEventHandler ( "onColShapeLeave", getRootElement(), singColLeave )
local timerCitizenLoopAnim = {}
function citizenSing(ped)
	local x,y,z = getElementPosition(ped)
	guitar = createObject( 1901, x,y,z)
	attachElementToBone(guitar,ped,3, 0, 0.2, -0.125,0,-90,0)
	if isTimer( timerCitizenLoopAnim[ped] ) then killTimer( timerCitizenLoopAnim[ped] ) end
	timerCitizenLoopAnim[ped] = setTimer( 
	function()
		if isElement( ped )  and not getElementData(ped, "Citizen.Dead") then 
			if getElementData(ped, "Citizen.Panic") == true then 
				triggerClientEvent ( root, "setPedCustomAnimation", root, ped,"ped", "cower")
			else
				sendToNearbyPlayers(ped,"♪♫♬♩ ♪♫♬♩ ♪♫♬♩")
				triggerClientEvent ( root, "setPedCustomAnimation", root, ped,"animguitar", "play_guitar")
			end
		end
	end, 10000, 0)
	local singCol = createColSphere ( x,y,z, 20.0 )
	setElementParent ( singCol, ped)
	setElementData(singCol, "Citizen.Sing.Col", true)
	setElementData(singCol, "Citizen.Sing.Url", table.random(citizenSingUrl))
end
function citizenListen(ped )
	
	if isTimer( timerCitizenLoopAnim[ped] ) then killTimer( timerCitizenLoopAnim[ped] ) end
	timerCitizenLoopAnim[ped] = setTimer( function()
		if isElement( ped )  and not getElementData(ped, "Citizen.Dead") then 
			if getElementData(ped, "Citizen.Panic") == true then 
				triggerClientEvent ( root, "setPedCustomAnimation", root, ped,"ped", "cower")
			else
				local randomanim = table.random(citizenListenAnims)
				setPedAnimation(ped, randomanim[1], randomanim[2])
				triggerClientEvent ( root, "setPedCustomAnimation", root, ped,randomanim[1], randomanim[2])
			end
		end
	end, 10000, 0)
end
-- Citizen Ceremony
function ceremonyColHit ( hitElement, matchingDimension )
	if getElementType (hitElement) == "player"then
		if getElementData( source, "Citizen.Ceremony.Col" ) == true  and not getElementData(source, "Citizen.Dead") then
			triggerClientEvent( root, "playerEffectCeremony", hitElement)
		end
	end
end
addEventHandler ( "onColShapeHit", getRootElement(), ceremonyColHit )
function ceremonyColLeave ( hitElement, matchingDimension )
	if getElementType (hitElement) == "player"  and not getElementData(source, "Citizen.Dead") then
		if getElementData( source, "Citizen.Ceremony.Col" ) == true then
			triggerClientEvent( root, "playerStopEffectCeremony", hitElement)
		end
	end
end
addEventHandler ( "onColShapeLeave", getRootElement(), ceremonyColLeave )
function citizenCeremony( ped )
	if isTimer( timerCitizenLoopAnim[ped] ) then killTimer( timerCitizenLoopAnim[ped] ) end
	timerCitizenLoopAnim[ped] = setTimer( function()
		if isElement( ped ) then 
			setPedAnimation(ped, "tindo", "caunguyen")
			triggerClientEvent ( root, "setPedCustomAnimation", root, ped,"tindo", "caunguyen")
		end
	end, 10000, 0)
	local x,y,z = getElementPosition(ped)
	local ceremonyCol = createColSphere ( x,y,z, 4.0 )
	setElementParent ( ceremonyCol, ped)
	setElementData(ceremonyCol, "Citizen.Ceremony.Col", true)
end
-- citizen wasted
function citizenWasted( )
	if isElement( source ) and getElementData(source, "isBot") == true and getElementData(source, "botType") == "Citizen" then 
		if getElementData(source, "Citizen.Type") == "Normal" then
			if isTimer( timerCitizenLoopAnim[source] ) then killTimer( timerCitizenLoopAnim[source] ) end
		end
		setElementData(source, "Citizen.Dead", true )

		-- destroyElement( source )
	end
end
addEventHandler( "onPedWasted", getRootElement(), citizenWasted )
-- Other function
function citizenFindRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end
function table.random ( theTable )
    return theTable[math.random ( #theTable )]
end

function citizenNormal( )
end
addEventHandler( "onResourceStart", getRootElement(), citizenNormal )
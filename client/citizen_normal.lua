--[[ Citizen Walk find first path
	loop all node and choose close node
	trigger server path selected
]]
addEvent( "citizenPathfind", true )
function citizenPathSearch (ped)
	local distToBeat = 9999
	local firstTarget = nil
	local px,py,pz = getElementPosition( ped )
	local allwaypoints = getElementsByType ( "pathpoint" )
	for PKey,theNode in ipairs(allwaypoints) do --first pass to find closes node in sight.
		local wx,wy,wz = getElementPosition( theNode )
		local distance = (getDistanceBetweenPoints3D( px, py, pz, wx, wy, wz ))
		if distance < distToBeat then
			if isLineOfSightClear (px, py, pz+.6, wx, wy, wz+.6, true, false, false, true, false, false, false) then
				distToBeat = distance
				firstTarget = theNode
			end
		end
	end
	triggerServerEvent ( "citizenPathChoose", ped, ped, firstTarget ) -- passes along the closest target node, or nothing if none exist in sight
end
addEventHandler("citizenPathfind", getRootElement(), citizenPathSearch)
-- 
local playerSound = nil
addEvent( "playerHearCitizenSing", true )
function playerHearCitizenSing(ped, url,x,y,z)
	if getElementData(ped, "Citizen.Panic") then 
		if isElement( playerSound ) then stopSound( playerSound ) end
	else
		playerSound = playSound3D( url, x, y, z)
	end
end
addEventHandler( "playerHearCitizenSing", getRootElement(), playerHearCitizenSing)

addEvent( "playerStopHearCitizenSing", true )
function playerStopHearCitizenSing(url)
	if isElement( playerSound ) then stopSound( playerSound ) end
end
addEventHandler( "playerStopHearCitizenSing", getRootElement(), playerStopHearCitizenSing)
-- Ceremony
addEvent( "playerEffectCeremony", true)
function playerEffectCeremony()
	setHeatHaze ( 50, 20, 0, 500, 200, 100, 50, 20, true )
	setSkyGradient( math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255) )
	setSunSize(5)
end
addEventHandler( "playerEffectCeremony", getRootElement(), playerEffectCeremony)

addEvent( "playerStopEffectCeremony", true)
function playerStopEffectCeremony()
	resetSunSize ( )
	setHeatHaze ( 0 )
	setSkyGradient( 60, 100, 196, 136, 170, 212 )
end
addEventHandler( "playerStopEffectCeremony", getRootElement(), playerStopEffectCeremony)

-- Panic
local timerRevertPanic = {}
function citizenDamage( attacker, weapon, bodypart )
	if not attacker then return end
	if getElementType ( source ) == "ped" and getElementType ( attacker ) == "player" then
		if getElementData(source, "isBot") == true and getElementData(source, "botType") == "Citizen" then 
			if bodypart == 9 then
				local rand = math.random(0,2)
				if rand == 0 then
					setPedAnimation(source,"ped","gas_cwr",2000,false,true,false,false)
					-- triggerEvent("sync.message", root, source, 255, 204, 0, "HOẢNG LOẠN")
				else
					setPedAnimation(source,"ped","KO_shot_face",5000,false,true,false,false)
					-- triggerEvent("sync.message", root, source, 255, 204, 0, "HOẢNG LOẠN")
				end
			elseif bodypart == 3  --[[and weapslot ~= 0 and weapslot ~= 1 and weapslot ~= 10]] then
				local rand = math.random(1,4)
				if rand == 1 then
					setPedAnimation(source,"ped","handscower",2000,false,true,false,false)
					-- triggerEvent("sync.message", root, source, 255, 204, 0, "HOẢNG LOẠN")
				elseif rand == 2 then
					setPedAnimation(source,"ped","EV_step",2000,false,true,false,false)
					-- triggerEvent("sync.message", root, source, 255, 204, 0, "HOẢNG LOẠN")
				elseif rand == 3 then
					setPedAnimation(source,"ped","getup",3000,false,true,false,false)
					-- triggerEvent("sync.message", root, source, 255, 204, 0, "HOẢNG LOẠN")
				elseif rand == 4 then
					setPedAnimation(source,"ped","KO_shot_stom",5000,false,true,false,false)
					-- triggerEvent("sync.message", root, source, 255, 204, 0, "HOẢNG LOẠN")
				end
			else
				setPedAnimation(source,"ped","getup",3000,false,true,false,false)
				-- triggerEvent("sync.message", root, source, 255, 204, 0, "HOẢNG LOẠN")
			end
			-- local x,y,z = getElementPosition( source )

			-- local peds = getElementsByType ( "ped" )
			-- for theKey,ped in ipairs(peds) do
			-- 	if getElementData(ped, "botType") == "Citizen" and getElementData(ped, "isBot") == true then 
			-- 		local x2,y2,z2 = getElementPosition( ped )
			--    		if (getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) < 100) then
			-- 	    	setElementData( ped, "Citizen.Panic", true)
			-- 	    	if isTimer( timerRevertPanic[ped] ) then killTimer( timerRevertPanic[ped] ) end
			-- 			timerRevertPanic[ped] = setTimer( revertCitizenPanic, 90000, 1, ped)
			-- 		end
			--    end
			-- end
		end
	end
end
addEventHandler( "onClientPedDamage", getRootElement(), citizenDamage )

function revertCitizenPanic( ped )
	if isElement( ped ) and getElementData(ped, "isBot") == true and getElementData(ped, "botType") == "Citizen" then
		setPedAnimation(ped)
		setElementData( ped, "Citizen.Panic", false)
	end
end
function playerFireWeaponInSafeZone( )
	local x,y,z = getElementPosition( localPlayer )
	local peds = getElementsByType ( "ped" )
	for theKey,ped in ipairs(peds) do
		if getElementData(ped, "botType") == "Citizen" and getElementData(ped, "isBot") == true then 
			local x2,y2,z2 = getElementPosition( ped )
			if (getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) < 100) then
				setElementData( ped, "Citizen.Panic", true)
				if isTimer( timerRevertPanic[ped] ) then killTimer( timerRevertPanic[ped] ) end
				timerRevertPanic[ped] = setTimer( revertCitizenPanic, 90000, 1, ped)
			end
		end
	end
end
addEventHandler( "onClientPlayerWeaponFire", getRootElement(), playerFireWeaponInSafeZone)
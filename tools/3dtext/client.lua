
-- Message config
local MINIMUM_SIZE = 0.1
local MESSAGE_TIME = 1000 -- milliseconds
local VEHICLE_SCALE_MULTIPLIER = 0.7 -- 30%
--local SPACE_BETWEEN_LINES = 0.3
local DISTANCE_TO_RENDER_DAMAGE = 300 -- GTA units
local HEIGHT_OFFSET = 1--1.20
local SHADING_PER_RENDER = 7.5
local SCALE = 0.2

-- Draw function config
local DRAW_CHECK_BUILDINGS = true
local DRAW_CHECK_VEHICLES = false
local DRAW_CHECK_PEDS = false
local DRAW_CHECK_OBJECTS = false
local DRAW_CHECK_DUMMIES = false
local DRAW_SEE_THROUGH_STUFF = false
local DRAW_IGNORE_CAMERA_OBJECTS = true

local messages = { }

local dxFont = dxCreateFont ( "baloothambi.ttf", 200 )

addEvent("sync.message", true)
addEventHandler("sync.message", root,
	function (player, r, g, b, message)
	
	if not isElement(player) then return end
		
		if player == localPlayer then 
			return 
		end
		
		if isElement(player) then
			if not messages[player] then
				messages[player] = {}
			end
		end
		messages[player][1] = { tostring(message), true, getTickCount()+MESSAGE_TIME, 255, r, g, b}
	end
)

addEventHandler ( "onClientRender", root, function ( ) --STATUSINFO RENDER  
    for player in pairs ( messages ) do
    	for sindex, sdata in ipairs(messages[player]) do
	        local v1 = sdata[1]
	        local v2 = sdata[2]
	        local v3 = sdata[3]
	        local v4 = sdata[4]
	        local v5 = sdata[5]
	        local v6 = sdata[6]
	        local v7 = sdata[7]
	        local v8 = player
	        if isElement(v8) and getElementType(v8) == "vehicle" then
	        	SCALE = SCALE * VEHICLE_SCALE_MULTIPLIER
	        end
			local x,y,z = getElementPosition(v8)
			local px,py,pz = getElementPosition(localPlayer)
			if isElement(v8) and getDistanceBetweenPoints3D(x,y,z,px,py,pz)<1 then HEIGHT_OFFSET = 0.5 end
	        dxDrawTextOnElement(v8, v1, HEIGHT_OFFSET, DISTANCE_TO_RENDER_DAMAGE, v5, v6, v7, v4, SCALE, dxFont)
	        
	        if (#messages[player] == 2 and sindex == 2) or (#messages[player] == 1) then
		        if ( getTickCount() >= v3 ) then
		            messages[player][sindex][4] = v4-SHADING_PER_RENDER
		            if ( messages[player][sindex][4] <= 0 ) then
		            	messages[player] = nil
		            end
		        end
		    end
		end
    end
end )


function dxDrawTextOnElement(element, text, height, distance, R, G, B, alpha, size, font)
	local x, y, z = getElementPosition(element)
	local x2, y2, z2 = getElementPosition(localPlayer)
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z, x2, y2, z2, DRAW_CHECK_BUILDINGS, DRAW_CHECK_VEHICLES, DRAW_CHECK_PEDS, DRAW_CHECK_OBJECTS, DRAW_CHECK_DUMMIES, DRAW_SEE_THROUGH_STUFF, DRAW_IGNORE_CAMERA_OBJECTS,ignoredElement)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if (sx and sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				scale = (size or 1)-(distanceBetweenPoints / distance)
				if scale < MINIMUM_SIZE then
					scale = MINIMUM_SIZE
				end
				height = HEIGHT_OFFSET - (distanceBetweenPoints / distance )
				dxDrawText(text, sx-2, sy-2, sx, sy, tocolor(1, 1, 1, alpha or 255), scale, font or "arial", "center", "center", false, false, false,true)
				dxDrawText(text, sx, sy, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), scale, font or "arial", "center", "center", false, false, false,true)
			end
		end
	end
end
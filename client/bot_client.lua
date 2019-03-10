-- Dx Function
addEventHandler("onClientRender", getRootElement(), 
function ()
	for k,v in ipairs(getElementsByType("ped")) do
		if getElementData(v, "botType") == "Citizen" or getElementData(v, "botType") == "Armed"  then
			local prefix = ""
			if getElementData (v, "Citizen.Action" ) == "Breed" then 
				prefix = "[Nông dân]"
			elseif getElementData (v, "Citizen.Action" ) == "Sing" then 
				prefix = "[Nghệ sĩ]"
			elseif getElementData (v, "Citizen.Action" ) == "Faithful" then 
				prefix = "[Tín đồ]"
			elseif getElementData (v, "Citizen.Action" ) == "Ceremony" then 
				prefix = "[Giáo sĩ]"
			end
			dxDrawTextOnPed(v,prefix.."\n"..getElementData(v, "botName"),1,5,255,255,255,255,2.5,"arial")
		end
	end
end)
function dxDrawTextOnPed(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end
-- chat function
local screenX, screenY = guiGetScreenSize()

bubbleMessages = {} -- {text, player, lastTick, alpha, yPos}

local timeVisible = 8500
local distanceVisible = 40
local bubble = true -- Rectangle rounded(true) or not(false)
local ticktock = 0
local selfVisible = true -- Want to see your own messages?
localPlayerBubbleActive = 0

---------------------

function addBubble(text, player, tick)

	if player == localPlayer then 
	localPlayerBubbleActive = 1 
	setTimer(function() localPlayerBubbleActive = 0 end,9000,1)
	end

	table.insert(bubbleMessages, {["text"] = text, ["player"] = player, ["tick"] = tick, ["endTime"] = tick + 2000, ["alpha"] = 0})
end

function removeBubble()
	table.remove(bubbleMessages)
end



addEvent("onChatIncome", true)

addEventHandler("onChatIncome", root,
		function(message, messagetype)
		if source ~= localPlayer then
			addBubble(message, source, getTickCount())
		elseif selfVisible then
			addBubble(message, source, getTickCount())
		end
	end
)

addEventHandler("onClientRender", root, --render bubble chat
	function()
		if #bubbleMessages > 0 then
			local tick = getTickCount()
			local x, y, z = getElementPosition(localPlayer)
			for i, v in ipairs(bubbleMessages) do
				if isElement(v.player)  and not isPedDead(v.player) then
					if tick-v.tick < timeVisible then
						if getDistanceBetweenPoints3D(x, y, z, getElementPosition(v.player)) < distanceVisible then
							v.alpha = v.alpha < 200 and v.alpha + 5 or v.alpha
							local bx, by, bz = getPedBonePosition(v.player, 6)
							local sx, sy = getScreenFromWorldPosition(bx, by, bz)
		
							local elapsedTime = tick - v.tick
							local duration = v.endTime - v.tick
							local progress = elapsedTime / duration
							local heighttext = 30
							if string.find( v.text, "\n") ~=nil then
								heighttext = 40
							end
							if sx and sy then
								if not v.yPos then v.yPos = sy end
								local width = dxGetTextWidth(v.text:gsub("#%x%x%x%x%x%x", ""), 1, "default-bold")
								local yPos = interpolateBetween ( v.yPos, 0, 0, sy - 22*i, 0, 0, progress, progress > 1 and "Linear" or "OutElastic")
								if bubble then
									local i
									if width < 100 then
										i = 2
									elseif width > 100 and width < 400 then
										i = 1
									else
										i = 3
									end
									dxDrawImage ( sx-width/2-.01*screenX, yPos - .03*screenY, width+.02*screenX, heighttext, "images/bubble["..i.."].png", _, _, tocolor(255, 255, 255, v.alpha) )
								else
									dxDrawRectangle(sx-width/2-.01*screenX, yPos - .03*screenY, width+.02*screenX, heighttext, tocolor(0, 0, 0, v.alpha))
								end
								dxDrawText(v.text, sx-width/2, yPos - .02*screenY, width, 20, tocolor( 255, 255, 255, v.alpha+50), 1, "default-bold", "left", "top", false, false, false, true)
							end
						end
					else
						table.remove(bubbleMessages, i)
					end
				else
					table.remove(bubbleMessages, i)
				end
			end
		end
	end
							
)

skinTXD = engineLoadTXD("model/guitar.txd")
engineImportTXD(skinTXD, 1901)
skinDFF = engineLoadDFF("model/guitar.dff", 1901)
engineReplaceModel(skinDFF, 1901)

-- custom anim
addEventHandler("onClientResourceStart", resourceRoot,
    function ( startedRes )
	    customIfp = engineLoadIFP ("anim/Fortnite pt1.ifp", "Fortnite_1")
	    customIfp2 = engineLoadIFP ("anim/Fortnite pt2.ifp", "Fortnite_2")
	    customIfp3 = engineLoadIFP ("anim/Fortnite pt3.ifp", "Fortnite_3")
	    customIfp4 = engineLoadIFP ("anim/animguitar.ifp", "animguitar")
	    customIfp5 = engineLoadIFP ("anim/tindo.ifp", "tindo")
	    if customIfp and customIfp2 and customIfp3 and customIfp4 and customIfp5 then 
	    
	    	outputDebugString ("Anim load thanh cong")
	    else
	    	outputDebugString ("Loi anim")
	    end
    end
)
function setPedCustomAnimation (ped,block,animation)
	if isElement(ped) then
		setPedAnimation(ped,block,animation)
    end
end
addEvent("setPedCustomAnimation",true)
addEventHandler("setPedCustomAnimation",getRootElement(),setPedCustomAnimation)



-- function playNhac( )
-- 	outputChatBox( "NHAC NHAC NHAC")
-- 	-- https://aredir.nixcdn.com/NhacCuaTui965/BeertalksAcousticLive-CaHoiHoang-5493528.mp3
-- 	playSound( "https://aredir.nixcdn.com/NhacCuaTui965/BeertalksAcousticLive-CaHoiHoang-5493528.mp3")
-- end
-- addCommandHandler( "testnhac", playNhac)
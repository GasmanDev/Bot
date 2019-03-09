addEvent("onRemoteClientPedDamage",true)
function botDamaged ( attacker, weapon, bodypart )

if not attacker then return end
if weapon == 51 then weapon = 16 end

    if getElementType ( source ) == "ped" and getElementType ( attacker ) == "player" then
        if (getElementData (source, "slothbot") == true) then
			local weapslot = getSlotFromWeapon(weapon)
            local melee = false
			local fireweapon = false
			local botstatus = getElementData(source,"status")--or "idle"
			
				if (getPedWeapon(source) < 16) then
					melee = true
				else
					fireweapon = true				
				end
				
				if bodypart == 9 then
						local rand = math.random(0,2)
						if rand == 0 then
							setPedAnimation(source,"ped","gas_cwr",2000,false,true,false,false)
							setElementData(source,"status","paused")
							setTimer(setElementData,1000,1,source,"status","chasing",true)
							setTimer(setElementData,1000,1,source,"target", attacker,true)
						else
							setPedAnimation(source,"ped","KO_shot_face",5000,false,true,false,false)
							setElementData(source,"status","paused")
							setTimer(setElementData,3000,1,source,"status","chasing",true)
							setTimer(setElementData,3000,1,source,"target", attacker,true)
						end
				elseif  bodypart ~= 9 --[[and weapslot ~= 0 and weapslot ~= 1 and weapslot ~= 10]] then
						local rand = math.random(1,2)
						if rand == 1 then
							setPedAnimation(source,"ped","Crouch_Roll_L",1500,false,true,true,false)
						else
							setPedAnimation(source,"ped","Crouch_Roll_R",1500,false,true,true,false)
						end
				end
				
				if bodypart == 3  --[[and weapslot ~= 0 and weapslot ~= 1 and weapslot ~= 10]] then
				local rand = math.random(1,4)
					if rand == 1 then
						setPedAnimation(source,"ped","handscower",2000,false,true,false,false)
						setElementData(source,"status","paused")
						setTimer(setElementData,1000,1,source,"status","chasing",true)
						setTimer(setElementData,1000,1,source,"target", attacker,true)
					elseif rand == 2 then
						setPedAnimation(source,"ped","EV_step",2000,false,true,false,false)
						setElementData(source,"status","paused")
						setTimer(setElementData,1000,1,source,"status","chasing",true)
						setTimer(setElementData,1000,1,source,"target", attacker,true)
					elseif rand == 3 then
						setPedAnimation(source,"ped","getup",3000,false,true,false,false)
						setElementData(source,"status","paused")
						setTimer(setElementData,1500,1,source,"status","chasing",true)
						setTimer(setElementData,1500,1,source,"target", attacker,true)
					elseif rand == 4 then
						setPedAnimation(source,"ped","KO_shot_stom",5000,false,true,false,false)
						setElementData(source,"status","paused")
						setTimer(setElementData,3000,1,source,"status","chasing",true)
						setTimer(setElementData,3000,1,source,"target", attacker,true)
					end
				elseif --[[weapslot ~= 0 and weapslot ~= 1 and weapslot ~= 10 and]] (bodypart == 7 or bodypart == 8) then
					setPedAnimation(source,"ped","getup",3000,false,true,false,false)
					setElementData(source,"status","paused")
					setTimer(setElementData,1500,1,source,"status","chasing",true)
					setTimer(setElementData,1500,1,source,"target", attacker,true)
				end
			--setElementData ( source, "target", attacker )
        end
    end
end
addEventHandler ( "onRemoteClientPedDamage", getRootElement(), botDamaged )
addEventHandler ( "onClientPedDamage", getRootElement(), botDamaged )
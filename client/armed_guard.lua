-- Armed Guard GateKeeper
SFZRules = {
    button = {},
    window = {},
    staticimage = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        SFZRules.window[1] = guiCreateWindow(299, 144, 686, 518, "HZVN DoomDay", false)
        guiWindowSetSizable(SFZRules.window[1], false)

        SFZRules.staticimage[1] = guiCreateStaticImage(9, 21, 667, 487, "images/safezonerules.png", false, SFZRules.window[1])

        SFZRules.button[1] = guiCreateButton(39, 383, 153, 37, "Ðồng ý", false, SFZRules.staticimage[1])
        guiSetFont(SFZRules.button[1], "default-bold-small")
        guiSetProperty(SFZRules.button[1], "NormalTextColour", "FF87E31A")
        SFZRules.button[2] = guiCreateButton(39, 430, 153, 37, "Từ chối", false, SFZRules.staticimage[1])
        guiSetFont(SFZRules.button[2], "default-bold-small")
        guiSetProperty(SFZRules.button[2], "NormalTextColour", "FFF56107")    
        guiSetVisible(SFZRules.window[1], false )
    end
)

addEvent( "ShowSFZRulesGUI", true )
function ShowSFZRulesGUI ( )
    guiSetVisible ( SFZRules.window[1], not guiGetVisible ( SFZRules.window[1] ) )
    showCursor ( not isCursorShowing( ) )
end
addEventHandler( "ShowSFZRulesGUI", getRootElement(), ShowSFZRulesGUI)

addEventHandler ( "onClientGUIClick", getResourceRootElement(getThisResource()),
function ()
    if (source == SFZRules.button[1]) then
        ShowSFZRulesGUI ()
        triggerServerEvent( "SafeZoneRulesClick", localPlayer, localPlayer, "Yes")
    elseif (source == SFZRules.button[2]) then 
        ShowSFZRulesGUI ()
        triggerServerEvent( "SafeZoneRulesClick", localPlayer, localPlayer, "No")
    end
    
end)
-- Damaged
function guardDamage( attacker, weapon, bodypart )
    if not attacker then return end
    if getElementType ( source ) == "ped" and getElementType ( attacker ) == "player" then
        if getElementData(source, "isBot") == true and getElementData(source, "botType") == "Armed" and 
        getElementData(source, "Armed.Action") == "Gatekeeper" then 
            if bodypart == 9 then
                local rand = math.random(0,2)
                if rand == 0 then
                    setPedAnimation(source,"ped","gas_cwr",2000,false,true,false,false) 
                else
                    setPedAnimation(source,"ped","KO_shot_face",5000,false,true,false,false)
                end
            elseif bodypart == 3  then
                local rand = math.random(1,4)
                if rand == 1 then
                    setPedAnimation(source,"ped","handscower",2000,false,true,false,false)
                elseif rand == 2 then
                    setPedAnimation(source,"ped","EV_step",2000,false,true,false,false)
                elseif rand == 3 then
                    setPedAnimation(source,"ped","getup",3000,false,true,false,false)
                elseif rand == 4 then
                    setPedAnimation(source,"ped","KO_shot_stom",5000,false,true,false,false)
                end
            else
                setPedAnimation(source,"ped","getup",3000,false,true,false,false)
            end
            -- triggerEvent("sync.message", root, source, 255, 204, 0, "BÁO ĐỘNG")
            local x , y, z = getElementPosition( attacker )
            local x2,y2,z2 = getElementPosition( source )
            if --[[getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 ) <= 20 and ]]getElementData( source, "Guard.CloseDoor") == false then 
                setElementData(source, "Guard.Panic", true)
                setPedRotation(source, botFindRotation(x2,y2,-2595, -253.2))
                setPedAnimation(source, "ped", "sprint_civi")
            end
            if weapon == 0 then 
                setElementData(source, "Guard.Panic", true)
                setPedRotation(source, botFindRotation(x2,y2,-2595, -253.2))
                setPedAnimation(source, "ped", "sprint_civi")
                triggerServerEvent("playerFireNearGuard", attacker, attacker, source)
            end

        end
    end
end
addEventHandler( "onClientPedDamage", getRootElement(), guardDamage )
function weaponFire()
    local x,y,z = getElementPosition( localPlayer )
    local peds = getElementsByType ( "ped" )
    for theKey,ped in ipairs(peds) do
        if getElementData(ped, "botType") == "Armed" and getElementData(ped, "isBot") == true then 
            if getElementData(ped, "Armed.Action") == "Gatekeeper" and getElementData( ped, "Guard.CloseDoor") == false then 
                local x2,y2,z2 = getElementPosition( ped )
                if (getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) <= 30) then
                    setElementData(ped, "Guard.Panic", true)
                    setPedRotation(ped, botFindRotation(x2,y2,-2595, -253.2))
                    setPedAnimation(ped, "ped", "sprint_civi")
                end
            elseif  getElementData(ped, "Armed.Type") == "Guard" then
                local x2,y2,z2 = getElementPosition( ped )
                if (getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) <= 50) then
                    triggerServerEvent("playerFireNearGuard", localPlayer, localPlayer, ped)
                end
            end
        end
    end
end
addEventHandler( "onClientPlayerWeaponFire", getRootElement(), weaponFire )

function botFindRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end
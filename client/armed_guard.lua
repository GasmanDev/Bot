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
        outputDebugString( "DONG Y")
        ShowSFZRulesGUI ()
        triggerServerEvent( "SafeZoneRulesClick", localPlayer, localPlayer, "Yes")
    elseif (source == SFZRules.button[2]) then 
        outputDebugString( "TU CHOI")
        ShowSFZRulesGUI ()
        triggerServerEvent( "SafeZoneRulesClick", localPlayer, localPlayer, "No")
    end
    
end)


addEventHandler( "onResourceStart", getRootElement(), function ( )
end )

-- addEventHandler( "onPlayerJoin", getRootElement(), function ( )
-- 	setPlayerTeam( source, getTeamFromName( "Player" ) )
-- end )

-- function addbot( playersource, cmd, var )
-- 	setPlayerTeam( playersource, getTeamFromName( "Player" ) )
-- 	local x,y,z = getElementPosition( playersource )
-- 	local ped = exports["slothbot"]:spawnBot (x,y,z,0,1,0,0, getPlayerTeam( playersource ), 0, "hunting", nil, "normal")
-- end

-- addCommandHandler( "spawnbot", addbot)

function addcitizen( playersource, cmd, var )
	local x,y,z = getElementPosition( playersource )
	local ped = createCitizen(var, "Male", 1, "Normal", "Walk", x, y, z, 0, 0, 0)
	
end

addCommandHandler( "spawncitizen", addcitizen)

function addguardgate( playersource, cmd, var )
	local x,y,z = getElementPosition( playersource )
	setElementPosition( playersource,-2587.7305,-271.3783,19.9389 )
	local ped =  createArmed(var, "random", "random", "Guard", "Gatekeeper", -2587.7305,-271.3783,19.9389,139.3757, 0, 0, "SF")
	
end

addCommandHandler( "spawngk", addguardgate)

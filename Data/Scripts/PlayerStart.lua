local propPlayerLight = script:GetCustomProperty("PlayerLight")
function OnPlayerJoined(player)
	print("player joined: " .. player.name)
	--player:SetVisibility(false)
	--print(propPlayerLight.id)
	--local PlayerLight = World.SpawnAsset(propPlayerLight.id)
	--PlayerLight:AttachToPlayer(player, "head")	
	propPlayerLight:AttachToLocalView()
end

function OnPlayerLeft(player)
	print("player left: " .. player.name)
end

-- on player joined/left functions need to be defined before calling event:Connect()
Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)

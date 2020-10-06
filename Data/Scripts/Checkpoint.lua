local checkpointNumber = script:GetCustomProperty("CheckpointNumber")
local trigger = script.parent
local position = trigger:GetWorldPosition()
local players = {}

function OnPlayerJoined(player)
	players[player] = 0
end

function OnPlayerLeft(player)
	players.player = nil
end

function OnPlayerRespawn(player)
	if player and players[player] == checkpointNumber then
		player:SetWorldPosition(position)
	end
end

function OnBeginOverlap(trigger, object)
	if object and object:IsA("Player") then
		if players[object] < checkpointNumber then
			players[object] = checkpointNumber
			object.respawnedEvent:Connect(OnPlayerRespawn)
		end
	end
end

trigger.beginOverlapEvent:Connect(OnBeginOverlap)

Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)
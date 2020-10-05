local flashlight001 = World.FindObjectByName("flashlight001")
flashlight001:AttachToLocalView()
--[[
local flashlight002 = World.FindObjectByName("flashlight002")
local light = World.SpawnAsset(flashlight002)

function OnPlayerJoined(player)
	flashlight002:AttachToPlayer(player, "head")
end

Game.playerJoinedEvent:Connect(OnPlayerJoined)
--]]
local RedHeart = "RedHeart"
local GreenHeart = "GreenHeart"
local WhiteHeart = "WhiteHeart"
local hearts = "hearts"

function OnPlayerJoined(player)
	print("player joined: " .. player.name)
	player.canMount = false
	player:SetResource(RedHeart, 0)
	player:SetResource(GreenHeart, 0)
	player:SetResource(WhiteHeart, 0)
	player:SetResource(hearts, 0)
	--player:SetResource(RedHeart, 0)
end

function OnPlayerLeft(player)
	print("player left: " .. player.name)
end

-- on player joined/left functions need to be defined before calling event:Connect()
Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)

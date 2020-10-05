
-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local CANVAS = script:GetCustomProperty("Canvas"):WaitForObject()
local PANEL = script:GetCustomProperty("Panel"):WaitForObject()
local TEXT_BOX = script:GetCustomProperty("TextBox"):WaitForObject()
local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()

local ROOT = script:GetCustomProperty("MessageTrigger"):WaitForObject()

-- User exposed properties
local MESSAGE = ROOT:GetCustomProperty("message")
local DURATION = ROOT:GetCustomProperty("duration")

local DEFAULT_DURATION = 3

local ONETIMEONLY = script:GetCustomProperty("OneTimeOnly")


-- Constant variables
local LOCAL_PLAYER = Game.GetLocalPlayer()

-- Variables
local appeared = false

-- nil OnBannerMessageEvent(string, <float>)
-- Handles a client side banner message event
function OnBeginOverlap()

	if not appeared then
		appeared = true
		PANEL.visibility = Visibility.INHERIT
    	TEXT_BOX.text = MESSAGE
    	Task.Wait(DURATION)
    	PANEL.visibility = Visibility.FORCE_OFF
    end
		
end


-- Initialize
PANEL.visibility = Visibility.FORCE_OFF
TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)
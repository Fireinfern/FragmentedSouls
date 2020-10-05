-- Internal custom properties
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()
local FantasyCrossbowBolt = script:GetCustomProperty("FantasyCrossbowBolt"):WaitForObject()
local CrossbowHitTrigger = script:GetCustomProperty("CrossbowHitTrigger"):WaitForObject()


-- Internal variables

local WasActivated = false

function OnBeginOverlap(trigger, other)
if (WasActivated == false) then
	if other:IsA("Player") then
	UI.PrintToScreen("String was activated")
		WasActivated = true
        FantasyCrossbowBolt:MoveTo(COMPONENT_ROOT:GetWorldPosition(), .1)
        Task.Wait(.15)
        FantasyCrossbowBolt:Destroy()
        end
	end
end

function OnBoltHit(trigger, other)
	if other:IsA("Player") then
        other:Die()
	end
end

-- Initialize
TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)
CrossbowHitTrigger.beginOverlapEvent:Connect(OnBoltHit)
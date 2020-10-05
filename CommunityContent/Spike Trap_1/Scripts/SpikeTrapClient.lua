local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()
local SPIKE_TRAP = script:GetCustomProperty("SpikeTrap"):WaitForObject()
local OFFSET = script:GetCustomProperty("Offset")
local SPIKE_VISUALS = script:GetCustomProperty("SpikeVisuals"):WaitForObject()

local ACTIVATION_TIME = SPIKE_TRAP:GetCustomProperty("ActivationTime")

local isTriggered = false
local startPosZ = SPIKE_VISUALS:GetWorldPosition().z

function OnBeginOverlap(trigger, other)
	if Object.IsValid(other) and other:IsA("Player") and not other.isDead then
		if not isTriggered then
			Task.Wait(ACTIVATION_TIME)
			isTriggered = true
		end
	end
end

function Tick(dt)
	-- Move spike up
	if isTriggered and SPIKE_VISUALS:GetWorldPosition().z - startPosZ < math.abs(OFFSET.z) then
		SPIKE_VISUALS:SetWorldPosition( SPIKE_VISUALS:GetWorldPosition() + Vector3.New(0,0,1) * 800 * dt)
	else
		isTriggered = false
	end
	-- Move spike down
	if not isTriggered and (SPIKE_VISUALS:GetWorldPosition().z - startPosZ) > 2 then
		SPIKE_VISUALS:SetWorldPosition( SPIKE_VISUALS:GetWorldPosition() + Vector3.New(0,0,-1) * 200 * dt)
	end
end

TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)

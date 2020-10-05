local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()
local SPIKE_TRAP = script:GetCustomProperty("SpikeTrap"):WaitForObject()

local ACTIVATION_TIME = SPIKE_TRAP:GetCustomProperty("ActivationTime")
local DAMAGE_AMT = SPIKE_TRAP:GetCustomProperty("Damage")

local isTriggered = false

local damage = Damage.New(DAMAGE_AMT)

function OnBeginOverlap(trigger, other)
	if Object.IsValid(other) and other:IsA("Player") then
		if not isTriggered then
			isTriggered = true
			Task.Wait(ACTIVATION_TIME)

			local objects = trigger:GetOverlappingObjects()
			for _, obj in pairs(objects) do
				if Object.IsValid(obj) and obj:IsA("Player") then
					obj:ApplyDamage(damage)
				end
			end	
		end
		isTriggered = false
	end
end

TRIGGER.beginOverlapEvent:Connect(OnBeginOverlap)

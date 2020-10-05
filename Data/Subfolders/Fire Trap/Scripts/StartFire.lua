local fireTrigger = script:GetCustomProperty("Trigger"):WaitForObject()
local DAMAGE_AMT = script:GetCustomProperty("DamageAmount")
local switchScript = script:GetCustomProperty("FireSwitch"):WaitForObject()
local damage = Damage.New(DAMAGE_AMT)
local fireOnTop = script:GetCustomProperty("FireOnTop")

function OnBeginOverlap(fireTrigger, other)
	if other:IsA("Player") then
		local fireOnLocal = switchScript.context.fireOn
		if fireOnTop then
			if Object.IsValid(other) and other:IsA("Player") and not fireOnLocal then
				UI.PrintToScreen("OVERLAPPING")		
				local objects = fireTrigger:GetOverlappingObjects()
				for _, obj in pairs(objects) do
					if Object.IsValid(obj) and obj:IsA("Player") then
						obj:ApplyDamage(damage)
					end
				end	
			end
		else 
			if Object.IsValid(other) and other:IsA("Player") and fireOnLocal then
				UI.PrintToScreen("OVERLAPPING")		
				local objects = fireTrigger:GetOverlappingObjects()
				for _, obj in pairs(objects) do
					if Object.IsValid(obj) and obj:IsA("Player") then
						obj:ApplyDamage(damage)
					end
				end	
			end
		end
	end
end
fireTrigger.beginOverlapEvent:Connect(OnBeginOverlap)
	
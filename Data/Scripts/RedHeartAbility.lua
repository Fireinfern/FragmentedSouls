local trigger = script.parent
local RedHeart = "RedHeart"
local GreenHeart = "GreenHeart"
local WhiteHeart = "WhiteHeart"
local propSoundEffect = script:GetCustomProperty("soundEffect"):WaitForObject()

function OnBeginOverlap(whichTrigger, other)
	if other:IsA("Player") then
		print(whichTrigger.name .. ": Begin Trigger Overlap with " .. other.name)
		end
end

function OnEndOverlap(whichTrigger, other)
	if other:IsA("Player") then
		print(whichTrigger.name .. ": End Trigger Overlap with " .. other.name)
	end
	
end

function OnInteracted(whichTrigger, other)
	if other:IsA("Player") then
		print(whichTrigger.name .. ": Trigger Interacted " .. other.name)
		if (other:GetResource(RedHeart) < 1)
		then 
			other:SetResource(RedHeart, 1)
			other.maxJumpCount = 2
			other:SetResource("hearts", 1)
			propSoundEffect:Play()
		end
	end
end

trigger.beginOverlapEvent:Connect(OnBeginOverlap)
trigger.endOverlapEvent:Connect(OnEndOverlap)
trigger.interactedEvent:Connect(OnInteracted)

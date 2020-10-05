--Dependencies
local firePosObj = script:GetCustomProperty("FirePosition"):WaitForObject()
local firePosTopObj = script:GetCustomProperty("FirePositionTop"):WaitForObject()

local firePos = firePosObj:GetWorldPosition()
local firePosTop = firePosTopObj:GetWorldPosition()

local fireBlast = script:GetCustomProperty("FireBlast")

local spawnedFire = nil
local spawnedFireTop = nil

local duration = script:GetCustomProperty("BlastDuration")

fireOn = false


--this function changes which fireblast is active after an intervall of time
local function Switch()

	--if the bottom fire is on, we activate the top fire
	if fireOn == true then				
		
		spawnedFireTop = World.SpawnAsset(fireBlast, {position = firePosTop})
		
		if spawnedFire ~=  nil then
			spawnedFire:Destroy()
		end
	--if the top fire is on, we activate the bottom fire
	else
	
		spawnedFire = World.SpawnAsset(fireBlast, {position = firePos})
		
		if spawnedFireTop ~= nil then
			spawnedFireTop:Destroy()
		end
	end
	fireOn = not fireOn
	
	--we wait the given duration, before we switch again
	Task.Wait(duration)
	Switch()
	
end

Switch()

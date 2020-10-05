local switch = script.parent
local switchTrigger = script:GetCustomProperty("Trigger"):WaitForObject()
local firePosObj = script:GetCustomProperty("FirePosition"):WaitForObject()

local firePosTopObj = script:GetCustomProperty("FirePositionTop"):WaitForObject()
local firePos = firePosObj:GetWorldPosition()

local firePosTop = firePosTopObj:GetWorldPosition()
local fireBlast = script:GetCustomProperty("FireBlast")
local fireBlast2 = script:GetCustomProperty("FireBlast2")

local spawnedFire = nil

local spawnedFireTop = nil

local toggleRotation = switch:GetRotation()

local otherDir = script:GetCustomProperty("Dir")

fireOn = false


local function UpdateLabel()
	if fireOn == true then
		switchTrigger.interactionLabel = "Fire on top"
	else 
		switchTrigger.interactionLabel = "Fire on bottom"
	end
end

function wait(seconds)
  local start = os.time()
  repeat until os.time() > start + seconds
end

local function OnSwitchInteraction()
	if fireOn == true then			
		switch:RotateTo(Rotation.New(30,0,0),0.5,true)	
		
		if otherDir then
			spawnedFireTop = World.SpawnAsset(fireBlast2, {position = firePosTop})	
		else
			spawnedFireTop = World.SpawnAsset(fireBlast, {position = firePosTop})	
		end
		if spawnedFire ~=  nil then
			spawnedFire:Destroy()
		end
	else 				
		switch:RotateTo(Rotation.New(150,0,0),0.5,true)		
		if otherDir then
			spawnedFire = World.SpawnAsset(fireBlast2, {position = firePos})	
		else
			spawnedFire = World.SpawnAsset(fireBlast, {position = firePos})	
		end		
		if spawnedFireTop ~= nil then
			spawnedFireTop:Destroy()
		end
	end
	fireOn = not fireOn
	UpdateLabel()
end


switchTrigger.interactedEvent:Connect(OnSwitchInteraction)

OnSwitchInteraction()

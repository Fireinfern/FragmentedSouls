local triggerHit = script:GetCustomProperty("TriggerHit"):WaitForObject()
local arrow = script:GetCustomProperty("Arrow")
local shootSound = script:GetCustomProperty("ShootSound"):WaitForObject()

local arrowEndPosObj = script:GetCustomProperty("ArrowEndPos"):WaitForObject()
local arrowPosObj = script:GetCustomProperty("ArrowPos"):WaitForObject()
local arrowEndPosObj2 = script:GetCustomProperty("ArrowEndPos2"):WaitForObject()
local arrowPosObj2 = script:GetCustomProperty("ArrowPos2"):WaitForObject()
local arrowEndPosObj3 = script:GetCustomProperty("ArrowEndPos3"):WaitForObject()
local arrowPosObj3 = script:GetCustomProperty("ArrowPos3"):WaitForObject()

local arrowPos = arrowPosObj:GetWorldPosition()
local arrowEndPos = arrowEndPosObj:GetWorldPosition()

local arrowPos2 = arrowPosObj2:GetWorldPosition()
local arrowEndPos2 = arrowEndPosObj2:GetWorldPosition()

local arrowPos3 = arrowPosObj3:GetWorldPosition()
local arrowEndPos3 = arrowEndPosObj3:GetWorldPosition()

local waitTime = script:GetCustomProperty("WaitTime")
local shootTime = script:GetCustomProperty("ShootTime")

arrowOn = false

local arrowObj = nil
local arrowObj2 = nil
local arrowObj3 = nil
local inProgress=false

local arrowTrigger = script:GetCustomProperty("ArrowTrigger"):WaitForObject()

local DAMAGE_AMT = script:GetCustomProperty("DamageAmount")

local damage = Damage.New(DAMAGE_AMT)



local function Shoot()
	if inProgress~=true then
		inProgress=true
		
		shootSound:Play()
		
		local arrowScale = Vector3.New(0.7,0.7,0.7)
		
		arrowObj = World.SpawnAsset(arrow, {position = arrowPos, scale = arrowScale})
		arrowObj2 = World.SpawnAsset(arrow, {position = arrowPos2, scale = arrowScale})
		arrowObj3 = World.SpawnAsset(arrow, {position = arrowPos3, scale = arrowScale})
		
		triggerHit:MoveTo(arrowEndPos2, shootTime, false)
		arrowOn=true
		
		arrowObj:MoveTo(arrowEndPos, shootTime, true)
		arrowObj2:MoveTo(arrowEndPos2, shootTime, true)
		arrowObj3:MoveTo(arrowEndPos3, shootTime, true)
		
		Task.Wait(shootTime)	
		arrowOn=false
		
		arrowObj:Destroy()
		arrowObj2:Destroy()
		arrowObj3:Destroy()
		
		
		triggerHit:MoveTo(arrowPos2, 0)
		inProgress=false
	end
end


function OnBeginOverlap(arrowTrigger, other)
	if other:IsA("Player") then
			
		if Object.IsValid(other) and other:IsA("Player") and arrowOn then
				
			local objects = arrowTrigger:GetOverlappingObjects()
			for _, obj in pairs(objects) do
				if Object.IsValid(obj) and obj:IsA("Player") then
					obj:ApplyDamage(damage)
				end
			end	
		end
	end
end


local function RepeatShoot()

	Shoot()
	Task.Wait(waitTime)
	RepeatShoot()
	
end


arrowTrigger.beginOverlapEvent:Connect(OnBeginOverlap)

RepeatShoot()



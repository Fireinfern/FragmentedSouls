-- Internal custom properties
local CANVAS = script:GetCustomProperty("Canvas"):WaitForObject()

local trigger = script:GetCustomProperty("Trigger"):WaitForObject()
local pages = script:GetCustomProperty("Messages"):WaitForObject():GetChildren()
local maxPages = #pages
local continueAbility = script:GetCustomProperty("ContinueAbility"):WaitForObject()


-- Constant variables
local LOCAL_PLAYER = Game.GetLocalPlayer()

-- Variables
local active = false
local currentPage = 1 


function OnInteracted()

	if not active then
		active = true
		currentPage = 1
		pages[currentPage].visibility = Visibility.INHERIT
    end	
end


function Continue()
	if active then
		pages[currentPage].visibility = Visibility.FORCE_OFF
	
		if currentPage == maxPages then
			active = false
			currentPage = 0
		else
			currentPage = currentPage + 1
			pages[currentPage].visibility = Visibility.INHERIT
		end
	end
end


-- Initialize
for i = 1, maxPages do
	pages[i].visibility = Visibility.FORCE_OFF
end
		
trigger.interactedEvent:Connect(OnInteracted)
continueAbility.castEvent:Connect(Continue)
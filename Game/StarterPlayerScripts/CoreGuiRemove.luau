local StarterGui = game:GetService("StarterGui")
local TotalWarns = 0

local function TryToRemove()
	local Pcall,err = pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
	end)
	if not Pcall then
		TotalWarns+=1
		if TotalWarns>=10 then
			error("Could not remove CoreGuis!")
		else
			task.wait(1)
			TryToRemove()
		end
	end
end
task.spawn(TryToRemove)
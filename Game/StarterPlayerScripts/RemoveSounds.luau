local plrs = game.Players


local function NChar(plr)
	plr.CharacterAdded:Connect(function(char)
		local Root = char:WaitForChild("HumanoidRootPart")

		Root:WaitForChild("Died").Asset = "rbxassetid://9125652949"
		Root:WaitForChild("Running"):Destroy()
	end)
end

for k,v in game.Players:GetPlayers() do
	NChar(v)
end

game.Players.PlayerAdded:Connect(function(plr)
	NChar(plr)
end)
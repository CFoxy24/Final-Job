local module = {}

local Players = game.Players
local LoadedPlayers = {}

function module.GetPlayers()
	return Players:GetPlayers()
end

function module.WaitForPlayers(Total)
	local StartedLoading = os.time()
	workspace:SetAttribute("SaidPlayers",Total)
	local val = false
	local tt = 0
	repeat
		tt = 0
		val = true
		task.wait() 
		for k,v in LoadedPlayers do
			if v == true then
				tt+=1
			else
				val = false
			end
		end
		workspace:SetAttribute("LoadedPlayers",tt)
	until ((#module.GetPlayers() >= math.min(1, Total) and val == true) or (os.time() - StartedLoading >= 15))
	
	game.ReplicatedStorage.Loaded:FireAllClients()
end

function module.LatePlayer(plr)
	local val = false
	local tt = 0
	repeat
		task.wait() 
		tt+=1
		if plr and LoadedPlayers[plr.UserId] == true then
			val = true
		end
	until val == true or tt >= 40000
	if plr then
		task.spawn(function()
			game.ReplicatedStorage.Loaded:FireClient(plr)

			plr:LoadCharacterAsync()
			plr.Character:WaitForChild("HumanoidRootPart")
			plr.Character:PivotTo(CFrame.new(-2.47, -9, 100.59))
		end)
	end
end

local function PlayerAdded(player)
	LoadedPlayers[player.UserId] = false
	
	
	if workspace:GetAttribute("VeryStart") == true then
		module.LatePlayer(player)
	end
end

function module.Initiate()
	for _, player in Players:GetPlayers() do
		task.spawn(PlayerAdded, player)
	end

	Players.PlayerAdded:Connect(PlayerAdded)

	Players.PlayerRemoving:Connect(function(player)
		LoadedPlayers[player.UserId] = nil
		workspace:SetAttribute("LoadedPlayers",#LoadedPlayers)
	end)
	
	game.ReplicatedStorage.Loaded.OnServerEvent:Connect(function(player)
		LoadedPlayers[player.UserId] = true
		workspace:SetAttribute("LoadedPlayers",#LoadedPlayers)
	end)

	return true
end

return module

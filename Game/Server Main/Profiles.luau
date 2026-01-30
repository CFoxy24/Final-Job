local module = {}

local Players = game:GetService("Players")
local ProfileStore = require(game.ServerScriptService.Modules.ProfileStore)

local PlayerStore = ProfileStore.New("PlayerStore")
local Profiles = {}

local function PlayerAdded(player)
	local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile.OnSessionEnd:Connect(function()
			Profiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)

		if player.Parent == Players then
			Profiles[player] = profile

			print(`Profile loaded for {player.DisplayName}!`)

		else
			profile:EndSession()
		end

	else
		player:Kick(`Profile load fail - Please rejoin`)
	end
end

function module.Initiate()
	for _, player in Players:GetPlayers() do
		task.spawn(PlayerAdded, player)
	end

	Players.PlayerAdded:Connect(PlayerAdded)

	Players.PlayerRemoving:Connect(function(player)
		local profile = Profiles[player]
		if profile ~= nil then
			profile:EndSession()
		end
	end)

	return true
end

return module

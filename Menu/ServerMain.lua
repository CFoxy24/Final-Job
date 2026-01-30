local Replicated = game.ReplicatedStorage
local TPService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ProfileStore = require(game.ServerScriptService.ProfileStore)

local ServerActions = Replicated:WaitForChild("ServerActions")
local PlayerStore = ProfileStore.New("PlayerStore",{Donations = 0})
local Profiles = {}

local Update = 1

local Servers = {}

local MemStore = game:GetService("MemoryStoreService")
local dataStore = MemStore:GetHashMap("ServerData")

ServerActions.Create.OnServerEvent:Connect(function(player)
	if not Servers[player.UserId] then return end
	if Servers[player.UserId].InServer then return end
	
	Servers[player.UserId].InServer = nil
	Servers[player.UserId].IsHost = true
	Servers[player.UserId].List = {}
	
	Replicated.ShowHostGui:FireClient(player,player.UserId,true)
end)

ServerActions.Stop.OnServerEvent:Connect(function(player)
	if not Servers[player.UserId] then return end
	
	Servers[player.UserId].InServer = nil
	Servers[player.UserId].IsHost = false
	
	for k, v in Servers[player.UserId].List do
		if v then
			local RealPLR = game.Players:GetPlayerByUserId(v)
			if RealPLR then
				if Servers[v] then
					Servers[v].InServer = nil
				end
				Replicated.ShowHostGui:FireClient(RealPLR,player.UserId,false)
			end
		end
	end
	
	Servers[player.UserId].List = {}
	Replicated.ShowHostGui:FireClient(player,player.UserId,false)
end)

ServerActions.Join.OnServerEvent:Connect(function(player : Player, who)
	if not Servers[player.UserId] then return end
	if Servers[player.UserId].InServer then return end
	if not who then return end
	if type(who) ~= "string" then return end
	if not Servers[tonumber(who)] then return end
	if Servers[tonumber(who)].InServer then return end
	if tonumber(who) == player.UserId then return end
	if not Servers[tonumber(who)].IsHost then return end
	
	if Servers[player.UserId].Private == true then
		if not player:IsFriendsWith(player.UserId) then
			return
		end
	end
	Servers[player.UserId].InServer = Servers[tonumber(who)]
	
	Replicated.ShowHostGui:FireClient(player,who,true)

	table.insert(Servers[tonumber(who)].List, player.UserId)
end)

ServerActions.Night.OnServerEvent:Connect(function(player, night)
	if not Servers[player.UserId] then return end

	Servers[player.UserId].Night = night
end)

ServerActions.ChangeMode.OnServerEvent:Connect(function(player, mode)
	if not Servers[player.UserId] then return end
	if type(mode) ~= "boolean" then return end
	
	Servers[player.UserId].Private = mode
end)

ServerActions.Kick.OnServerEvent:Connect(function(player, who)
	if not Servers[player.UserId] then return end
	if Servers[player.UserId].InServer then return end
	if not who then return end
	if type(who) ~= "string" then return end
	local WhoServer = Servers[tonumber(who)]
	if not WhoServer then return end
	if not WhoServer.InServer then return end

	if WhoServer.IsHost then return end

	local Search = table.find(Servers[player.UserId].List,tonumber(who))
	
	if not Search then return end

	Servers[tonumber(who)].InServer = nil
	table.remove(Servers[player.UserId].List,Search)
	Replicated.ShowHostGui:FireClient(Players:GetPlayerByUserId(tonumber(who)),player.UserId,false)
end)

ServerActions.Leave.OnServerEvent:Connect(function(player, who)
	if not Servers[player.UserId] then return end
	if not Servers[player.UserId].InServer then return end
	if not who then return end
	if type(who) ~= "string" then return end
	local WhoServer = Servers[tonumber(who)]
	if not WhoServer then return end
	if not WhoServer.IsHost then return end

	local Search = table.find(WhoServer.List,player.UserId)

	if not Search then return end

	Servers[player.UserId].InServer = nil
	table.remove(WhoServer.List,Search)
	Replicated.ShowHostGui:FireClient(player,tonumber(who),false)
end)

ServerActions.Start.OnServerEvent:Connect(function(player)
	if not Servers[player.UserId] then return end
	if Servers[player.UserId].InServer then return end
	if Servers[player.UserId].Joining then return end
	
	Servers[player.UserId].Joining = true
	
	local FinalList = {player}
	for k,v in Servers[player.UserId].List do
		local Plr = game.Players:GetPlayerByUserId(v)
		if Plr then
			table.insert(FinalList, Plr)
		end
	end
	
	local Night = Servers[player.UserId].Night
	if not Night then Night = 1 end
	
	local accessCode, privateServerId = TPService:ReserveServer(75559395907865)
	dataStore:SetAsync(tostring(privateServerId), game:GetService("HttpService"):JSONEncode(
		{
			#FinalList,
			1,
			tonumber(Night)
		}
		),45)
	
	TPService:TeleportToPrivateServer(75559395907865,accessCode,FinalList,"",nil,script.LoadingScreen)

	Servers[player.UserId].InServer = nil
	Servers[player.UserId].IsHost = false
	Servers[player.UserId].List = {}
end)

Replicated.Loaded.OnServerEvent:Connect(function(player)
	local Timeout = 0
	repeat task.wait() Timeout+=1 until player == nil or Profiles[player] ~= nil or Timeout>=60000
	
	if player then
		if Profiles[player] then
			Replicated.Loaded:FireClient(player)
		else
			player:Kick("Timed out")
		end
	end
end)

local function PlayerAdded(player)
	local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})
	
	task.spawn(function()
		if player.UserId == 652288939 or player.UserId == 3819420397 or player.UserId == 2264938275 then
			--TPService:TeleportAsync(126159374101278,{player})
		end
	end)

	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile.OnSessionEnd:Connect(function()
			Profiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)
 
		if player.Parent == Players then
			Profiles[player] = profile
			Servers[player.UserId] = {}
			
			task.spawn(function()
				local leaderstats = Instance.new("Folder")--IMPORTANT [NEED CREATE A FOLDER TO STORE PROFILE SERVICE VALUE, SO LEADERBOARD CAN DETECT]
				leaderstats.Name = "leaderstats"
				leaderstats.Parent = player

				local Money = Instance.new("IntValue")
				Money.Name = "Donations"
				Money.Parent = leaderstats

				Money.Value = profile.Data.Donations
			end)
			
		else
			profile:EndSession()
		end
	else
		player:Kick(`Profile load fail - Please rejoin`)
	end
end

for _, player in Players:GetPlayers() do
	task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
	if Servers[player.UserId] and Servers[player.UserId].InServer then
		table.remove(Servers[player.UserId].InServer.List,table.find(Servers[player.UserId].InServer.List,player.UserId))
	end
	Servers[player.UserId] = nil
	
	local profile = Profiles[player]
	if profile ~= nil then
		profile:EndSession()
	end
end)

game:GetService("RunService").Heartbeat:Connect(function(Delta)
	Update-=Delta
	
	if Update <= 0 then
		Update += 1
		
		workspace:SetAttribute("Servers", game:GetService("HttpService"):JSONEncode(Servers))
	end
end)

local DataStoreService = game:GetService("DataStoreService")
local LBDataStore = DataStoreService:GetOrderedDataStore("Leaderboard")
local Screen2 = workspace:FindFirstChild("Screen2"):FindFirstChild("Screen"):FindFirstChild("Donations"):FindFirstChild("List")

local function formatNumberWithCommas(number)
	local formattedNumber = tostring(number)
	formattedNumber = formattedNumber:reverse():gsub("(%d%d%d)", "%1,")
	return formattedNumber:reverse():gsub("^,", "")
end

local UserService = game:GetService("UserService")

function UpdateLeaderBoard()
	local smallestFirst = false
	local numberToShow = 100
	local minValue = 1
	local maxValue = 10e30
	local pages = LBDataStore:GetSortedAsync(smallestFirst, numberToShow, minValue, maxValue)
	local top = pages:GetCurrentPage()--Get the first page
	local data = {}
	for _,v in ipairs(top) do--Loop through data
		local userid = v.key--User id
		local money = v.value--Money
		local username = "[Failed To Load]"--If it fails, we let them know
		local s,e = pcall(function()
			username = UserService:GetUserInfosByUserIdsAsync({tonumber(userid)})[1].DisplayName
		end)
		if not s then--Something went wrong
			warn("Error getting name for "..userid..". Error: "..e)
		end
		local image = game.Players:GetUserThumbnailAsync(userid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		--Make a image of them
		table.insert(data,{username,money,image,userid})--Put new data in new table
		
	end
	
	for k,v in Screen2:GetChildren() do
		if v.Name == "N" then
			v:Destroy()
		end
	end
	
	for k,v in data do
		local new = Screen2:WaitForChild("EX"):Clone()
		new.Parent = Screen2
		new.Name = "N"
		new.DName.Text = v[1]
		new.DNumber.Text = v[2] .. " R$"
		task.spawn(function()
			new.DIcon.Image = v[3]
		end)
		new.Visible = true
	end
end



task.spawn(function()
	UpdateLeaderBoard()

	local marketplaceservice = game:GetService("MarketplaceService")

	local RBXN = {
		[1] = 3443623471,
		[2] = 3443637739,
		[3] = 3443643765,
		[4] = 3443664989,
		[5] = 3443666954,
		[6] = 3443669113,
		[7] = 3443669956,
		[8] = 3443670875,
		[9] = 3443671927,
	}
	local RBXNV = {
		[3443623471] = 10,
		[3443637739] = 50,
		[3443643765] = 100,
		[3443664989] = 250,
		[3443666954] = 750,
		[3443669113] = 1500,
		[3443669956] = 3000,
		[3443670875] = 5000,
		[3443671927] = 10000,
	}
	
	task.spawn(function()
		while true do
			task.wait(10)
			for k,v in Profiles do
				pcall(function()
					LBDataStore:UpdateAsync(k.UserId,v.Data.Donations)
				end)
			end
			task.wait(1)
			UpdateLeaderBoard()
		end
	end)

	marketplaceservice.PromptProductPurchaseFinished:Connect(function(player, id, ispurchased)
		if ispurchased then
			local RealPlayer = Players:GetPlayerByUserId(player)
			local profile = Profiles[RealPlayer]
			if profile then
				profile.Data.Donations += RBXNV[id]
				RealPlayer.leaderstats.Donations.Value = profile.Data.Donations
				
				local sucess = nil
				
				repeat 
					sucess = pcall(LBDataStore.SetAsync, LBDataStore, player, profile.Data.Donations)

					task.wait(10)
				until sucess == true
			end
		end
	end)

	Replicated.Donate.OnServerEvent:Connect(function(player,which)
		if player and which and RBXN[which] then
			marketplaceservice:PromptProductPurchase(player,RBXN[which])
		end
	end)
end)

workspace:SetAttribute("FullyLoaded",true)
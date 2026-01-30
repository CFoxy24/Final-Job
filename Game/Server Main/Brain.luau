local Modules = script

------ Initiating Dev or Prod -------------------------------------------------	


--game.ReplicatedStorage.Collisions.Parent = workspace

------ Retreiving Modules -----------------------------------------------------	

local API_Error 		= 	require(Modules.Error)
API_Error.Log("Error Module Initiated")
local API_Players 		= 	require(Modules.Players)
API_Error.Log("Players Module Initiated")
local API_Profiles 		= 	require(Modules.Profiles)
API_Error.Log("Profiles Module Initiated")
local API_MemoryStore 	= 	require(Modules.MemoryStore)
API_Error.Log("MemoryStore Module Initiated")
local API_Conditions 	= 	require(Modules.Conditions)
API_Error.Log("Conditions Module Initiated")
local API_Characters 	= 	require(Modules.Characters)
API_Error.Log("Characters Module Initiated")
local API_Difficulty 	= 	require(Modules.Difficulty)
API_Error.Log("Difficulty Module Initiated")
local API_Animatronics 	= 	require(Modules.Animatronics)
API_Error.Log("Animatronics Module Initiated")

------ Initiating Modules -----------------------------------------------------	

API_Error.Catch(API_MemoryStore.Initiate(), 1)
API_Error.Catch(API_Profiles.Initiate(), 1)
API_Error.Catch(API_Players.Initiate(), 1)

API_Error.Log("Modules Initiated")

------ Getting Variables ------------------------------------------------------	

-- MemoryStore --
local PlayersNeeded = API_MemoryStore.Get("PlayersNeeded")
local NightType = API_MemoryStore.Get("NightType")
local NightNumber = API_MemoryStore.Get("NightNumber")
workspace:SetAttribute("NightNumber",NightNumber)

-- Difficulty --
local UpTime = API_Error.Catch(API_Difficulty.Get("Animatronics_UpTime")["Night" .. NightNumber], 3)
local BaseValues = API_Error.Catch(API_Difficulty.Get("Animatronics_BaseValues"), 3)
local Multipliers = API_Error.Catch(API_Difficulty.Get("Animatronics_Multipliers")["Night" .. NightNumber], 3)

for k,v in Multipliers do
	for k2,v2 in v[1] do
		for k3,v3 in v[2] do
			BaseValues[v2][v3] = v[3]
		end
	end
end

-- Conditions --

-- Others --
local StartTime = 0
local Animatronics = {}

------ Waiting and Spawning Players -------------------------------------------	

API_Players.WaitForPlayers(PlayersNeeded)

task.wait()

API_Characters.Spawn(API_Players.GetPlayers())
for k,v in API_Players.GetPlayers() do
	API_Characters.Move(v, CFrame.new(-2.47, -9, 100.59) * CFrame.new(k*-4,0,0))
end

API_Error.Log("Game Starting")

------ Animatronics Values -------------------------------------------	

workspace:SetAttribute("VeryStart",true)

if game:GetService("RunService"):IsStudio() then
	--API_Characters.Move(API_Players.GetPlayers(), workspace.Camera.CFrame)
end

for k,v in UpTime do
	Animatronics[k] = {false, API_Error.Catch(API_Animatronics.Setup(k), 4)}
	for k2,v2 in BaseValues[k] do
		Animatronics[k][2]:SetAttribute(k2,v2)
	end
end

local function Check(v)
	if v.Name == "Locker" and v.PrimaryPart then
		local At = Instance.new("Attachment")
		local Prompt = Instance.new("ProximityPrompt")
		local IsUsed = false
		local PlayerIn = nil
		
		At.Parent = v
		At.Position = Vector3.new(0,0,1)
		Prompt.Parent = At
		
		Prompt.Triggered:Connect(function(Player)
			if not IsUsed and Player.Character and Player:GetAttribute("InLocker") ~= true then
				
				IsUsed = true
				Prompt.Enabled = false
				
				PlayerIn = Player
				Player:SetAttribute("InLocker",true)
				
				game.ReplicatedStorage.Locker:FireClient(Player,v,true)
			end
		end)
		
		game.ReplicatedStorage.Locker.OnServerEvent:Connect(function(plr)
			if IsUsed and PlayerIn == plr then
				IsUsed = false
				Prompt.Enabled = true

				PlayerIn = nil
				plr:SetAttribute("InLocker",false)
			end
		end)
	end
end

for k, v in workspace:GetDescendants() do
	--Check(v)
end
workspace.DescendantAdded:Connect(function(v)
	--Check(v)
end)

game.ReplicatedStorage:WaitForChild("Lean").OnServerEvent:Connect(function(PLR,State,PLRWaist)
	game.ReplicatedStorage.Lean:FireAllClients(State,PLRWaist)
end)

local Market = game:GetService("MarketplaceService")

Market.PromptProductPurchaseFinished:Connect(function(player,assetid,ispurchased)
	if player and ispurchased == true and assetid == 3476984697 then
		local PhysicalPlr = game.Players:GetPlayerByUserId(player)
		if PhysicalPlr then
			PhysicalPlr:LoadCharacterAsync()
			task.spawn(function()
				PhysicalPlr:SetAttribute("InCameras",false)
			end)
			task.spawn(function()
				PhysicalPlr:SetAttribute("InCameras",false)
			end)
			task.spawn(function()
				PhysicalPlr:SetAttribute("Invincible",true)
				task.wait(10)
				PhysicalPlr:SetAttribute("Invincible",false)
			end)
		end
	end
end)

game.ReplicatedStorage:WaitForChild("Revive").OnServerEvent:Connect(function(plr)
	task.spawn(function()
		Market:PromptProductPurchase(plr,3476984697)
	end)
end)

------ Starting Main Loop -----------------------------------------------------	

local gamestart = workspace:FindFirstChild("GameStart",true)
local IsStarted = API_Conditions.NewCondition(gamestart.Parent.Parent,"Start Generator",false)
local TimeCondition = nil
gamestart.Triggered:Connect(function()
	gamestart.Enabled = false
	IsStarted.Value = true
	
	TimeCondition = API_Conditions.NewCondition(nil,"Exit at 6AM",nil)
	workspace:SetAttribute("IsStarted",true)
end)

workspace.Triggers.End.Touched:Connect(function(part)
	local Model = part:FindFirstAncestorWhichIsA("Model") 
	if Model then
		if Model:FindFirstChild("Humanoid") then
			local Plr = game.Players:GetPlayerFromCharacter(Model)
			if Plr then
				if TimeCondition and TimeCondition.Value == false then
					Model:Destroy()
					game.ReplicatedStorage.Finished:FireClient(Plr)
				end
			end
		end
	end
end)

function Format(Int)
	return string.format("%02i", Int)
end

function convertToHMS(HourText,Seconds)
	local Minutes = (Seconds - Seconds%60)/60
	if Minutes == 0 then
		Minutes = 12
		HourText.Text = Format(Minutes)..":00"
	else
		HourText.Text = Format(math.clamp(Minutes,0,6))..":00"
		if Minutes>=6 then
			HourText.AudioPlayer:Play()
			workspace:SetAttribute("IsFinished", true)
		end
	end
end

local HourText = workspace:FindFirstChild("HourText",true)

local function Update(Delta)
	script:SetAttribute("AliveSince",os.time())
	
	if not IsStarted.Value then return end
	StartTime+=Delta

	convertToHMS(HourText,StartTime)
	
	if StartTime >= 6*60 then
		TimeCondition.Object = workspace.Triggers.End
		TimeCondition.Name = "Exit"
		API_Conditions.ChangeCondition(TimeCondition, false)
	end
	
	for k,v in UpTime do
		if Animatronics[k][1] == false then
			if StartTime >= v then
				API_Error.Catch(API_Animatronics.Activate(Animatronics[k][2]), 4)
				Animatronics[k][1] = true
			end
		end
	end
end

game:GetService("RunService").Heartbeat:Connect(Update)
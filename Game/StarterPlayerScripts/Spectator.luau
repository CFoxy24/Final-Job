local GUI = script.GUI:Clone()
local Cam = workspace.CurrentCamera
local Current = 0
local PLR = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

GUI.Parent = PLR.PlayerGui
GUI.Enabled = true

local function Return()
	game:GetService("TeleportService"):Teleport(106212702976912,game.Players.LocalPlayer)
end

GUI.Return.MouseButton1Click:Connect(Return)
GUI.Return.TouchTap:Connect(Return)

PLR:SetAttribute("InCameras",true)
Cam.CameraType = Enum.CameraType.Custom

PLR.CameraMaxZoomDistance = 11
PLR.CameraMinZoomDistance = 3

PLR.CameraMode = Enum.CameraMode.Classic
UIS.MouseBehavior = Enum.MouseBehavior.Default

local Context = Instance.new("InputContext")
local action = Instance.new("InputAction")
local bind = Instance.new("InputBinding")
local bind2 = Instance.new("InputBinding")
local bind3 = Instance.new("InputBinding")

Context.Parent = game.ReplicatedStorage
action.Parent = Context
action.Type = Enum.InputActionType.Bool
bind.Parent = action
bind.KeyCode = Enum.KeyCode.Right
bind2.KeyCode = Enum.KeyCode.DPadRight
bind2.Parent = action
bind3.KeyCode = Enum.KeyCode.ButtonR1
bind3.Parent = action

local Daction = Instance.new("InputAction")
local Dbind = Instance.new("InputBinding")
local Dbind2 = Instance.new("InputBinding")
local Dbind3 = Instance.new("InputBinding")

Daction.Parent = Context
Daction.Type = Enum.InputActionType.Bool
Dbind.Parent = action
Dbind.KeyCode = Enum.KeyCode.Left
Dbind2.KeyCode = Enum.KeyCode.DPadLeft
Dbind2.Parent = action
Dbind3.KeyCode = Enum.KeyCode.ButtonL1
Dbind3.Parent = action

local function Update(nmbr)
	Current+=nmbr
	UIS.MouseBehavior = Enum.MouseBehavior.Default
	local Players = game.Players:GetPlayers()
	local UsablePlayers = {}
	for k,v in Players do
		if v.Character and v.Character.PrimaryPart and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health>=0 then
			table.insert(UsablePlayers,v)
		end
	end

	if #UsablePlayers > 0 then
		local Choosen = UsablePlayers[Current % #UsablePlayers + 1]
		Cam.CameraSubject = Choosen.Character
		GUI.TextLabel.Text = Choosen.Name
	end
end

action.StateChanged:Connect(function(val)
	if val == true then
		Update(1)
	end
end)
Daction.StateChanged:Connect(function(val)
	if val == true then
		Update(-1)
	end
end)

local function RequestRevive()
	game.ReplicatedStorage.Revive:FireServer()
end

GUI.Revive.MouseButton1Click:Connect(RequestRevive)
GUI.Revive.TouchTap:Connect(RequestRevive)

GUI.L.MouseButton1Click:Connect(function()
	Update(1)
end)

GUI.L.TouchTap:Connect(function()
	Update(1)
end)

GUI.R.MouseButton1Click:Connect(function()
	Update(-1)
end)

GUI.R.TouchTap:Connect(function()
	Update(-1)
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
	script.Enabled = false
end)
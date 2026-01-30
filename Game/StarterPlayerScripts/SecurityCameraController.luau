local ViewportHandler = require(script.ViewportHandler)
local Player = game.Players.LocalPlayer
local Audio = script:WaitForChild("AudioSetup")
local MapGui = script:WaitForChild("Gui"):WaitForChild("CamOverlay"):WaitForChild("Map")
local Currcam = workspace.CurrentCamera
local InCamera = false
local Cams = {}
local CurrentCam = nil
local TotalDelta = 0

local ChangeCamGlitch = Instance.new("NumberValue")
local Light = Instance.new("SpotLight")
Light.Shadows = true
Light.Range = 30
Light.Brightness = 1
Light.Angle = 80
Light.Face = "Right"
Light.Enabled = false
Light.Name = "AAAAA"

local Context = Instance.new("InputContext")
local action = Instance.new("InputAction")

Context.Parent = game.ReplicatedStorage
action.Parent = Context
action.Type = Enum.InputActionType.Bool

local bind = Instance.new("InputBinding")
bind.Parent = action
bind.KeyCode = Enum.KeyCode.Space

local bind2 = Instance.new("InputBinding")
bind2.KeyCode = Enum.KeyCode.ButtonA
bind2.Parent = action

local bind = Instance.new("InputBinding")
bind.Parent = action
bind.KeyCode = Enum.KeyCode.S

local bind = Instance.new("InputBinding")
bind.Parent = action
bind.KeyCode = Enum.KeyCode.DPadDown

local bind = Instance.new("InputBinding")
bind.Parent = action
bind.KeyCode = Enum.KeyCode.A

local bind = Instance.new("InputBinding")
bind.Parent = action
bind.KeyCode = Enum.KeyCode.X

local CamsModels = {}

local GlitchTime = 0
local GlitchState = false

local FPSCap = 0
local FPSCap2 = 0

local Map = game.ReplicatedStorage:WaitForChild("CamMap")
repeat task.wait() until #Map:GetChildren() == 24
local _, MapSize = Map:GetBoundingBox()

-- Fonction pour changer de caméra
local function ChangeCam(Model)
	CurrentCam = Model
	Currcam.CFrame = Model.PrimaryPart.CFrame

	Audio.Audios.Camchange.TimePosition = 0
	Audio.Audios.Camchange2.TimePosition = 0

	Light.Parent = Model.PrimaryPart

	Audio.Audios.Camchange:Play()
	Audio.Audios.Camchange2:Play()

	ChangeCamGlitch.Value = 1
	game:GetService("TweenService"):Create(ChangeCamGlitch, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Value = 0}):Play()
end

-- Création des boutons sur la map
for k, v in Map:GetChildren() do
	local NF = Instance.new("TextButton")
	NF.Parent = MapGui
	NF.Size = UDim2.fromScale(v.Size.X / MapSize.X, v.Size.Z / MapSize.Z)
	NF.Position = UDim2.fromScale(v.Position.X / MapSize.X + .5, v.Position.Z / MapSize.Z + .5)
	NF.AnchorPoint = Vector2.new(.5, .5)
	NF.BorderSizePixel = 0
	NF.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	NF.Text = v.Name
	NF.FontFace = Font.new("rbxasset://fonts/families/PressStart2P.json")
	NF.AutoButtonColor = false

	if v.Name == "" then continue end
	local Camera = game:FindFirstChild("CAM" .. v.Name, true)
	if Camera == nil then continue end

	local MoveCamera = Camera:WaitForChild("MovingPart")
	Cams[v.Name] = {MoveCamera, MoveCamera.PrimaryPart.CFrame}

	table.insert(CamsModels, Camera)

	NF.BackgroundColor3 = Color3.fromRGB(194, 194, 194)

	NF.MouseEnter:Connect(function()
		NF.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	end)

	NF.MouseLeave:Connect(function()
		NF.BackgroundColor3 = Color3.fromRGB(194, 194, 194)
	end)

	NF.MouseButton1Down:Connect(function()
		ChangeCam(Camera)
	end)
	
	NF.TouchTap:Connect(function()
		ChangeCam(Camera)
	end)
end

-- Parentage du GUI
for _, v in script.Gui:GetChildren() do
	v.Parent = Player.PlayerGui
end

local CamTrigger = workspace.Triggers.Cams.ProximityPrompt

local InCams = false

local function CamOpen()
	Audio.Audios.Camchange:Play()
	Audio.Audios.Static:Play()
	Audio.Audios.StaticAudio:Play()
	Audio.Audios.CamMove:Play()
	Audio.Audios.Constant:Play()
	
	InCams = true

	CamTrigger.Enabled = false
	CurrentCam = nil
	Light.Enabled = true

	CurrentCam = CamsModels[1]

	Currcam.CameraType = Enum.CameraType.Scriptable
	Player:SetAttribute("InCameras", true)
	MapGui.Parent.Enabled = true
end

local function CamClose()
	Audio.Audios.Static:Stop()
	Audio.Audios.StaticAudio:Stop()
	Audio.Audios.CamMove:Stop()
	Audio.Audios.Constant:Stop()
	Audio.Audios.Camchange:Play()

	InCams = false

	CamTrigger.Enabled = true
	Light.Enabled = false
	CurrentCam = nil
	Currcam.CameraType = Enum.CameraType.Custom
	Player:SetAttribute("InCameras", false)
	MapGui.Parent.Enabled = false
end


CamTrigger.Triggered:Connect(function()
	CamOpen()
end)

MapGui.Parent.Exit.MouseEnter:Connect(function()
	action:Fire(true)
end)

action.StateChanged:Connect(function(val)
	if val == true and InCams then
		CamClose()
		action:Fire(false)
	end
end)

MapGui.Parent.Exit.Activated:Connect(function()
	action:Fire(true)
end)

Player:SetAttribute("CamerasReady", true)

game:GetService("RunService").RenderStepped:Connect(function(delta)
	TotalDelta += delta
	if InCams then
		if CurrentCam and CurrentCam.PrimaryPart then
			Currcam.CFrame = CurrentCam.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(-90), math.rad(180))
		end

		for _, v in Cams do
			local CosVal = math.clamp(math.cos(TotalDelta * .1), -.8, .8)
			if v[1]:GetAttribute("Range") then
				v[1]:PivotTo(v[2] * CFrame.Angles(0, math.rad(CosVal * v[1]:GetAttribute("Range") * 1.25), 0))
			end
		end

		GlitchTime -= delta
		if GlitchTime <= 0 then
			GlitchState = not GlitchState
			if GlitchState then
				GlitchTime += math.random(10, 40) / 100
				Audio.ListenEffects.AudioPitchShifter.Pitch = 1 + math.random(-20, 20) / 100
			else
				GlitchTime += math.random(20, 180) / 100
				Audio.ListenEffects.AudioPitchShifter.Pitch = 1
			end
		end

		Audio.Audios.Static.Volume = math.clamp(Audio.AudioAnalyzer.RmsLevel * 60 + ChangeCamGlitch.Value * .8, 0, .8)
		Audio.Audios.StaticAudio.Volume = math.clamp(Audio.AudioAnalyzer.RmsLevel * 110, 0, .6)

		local Level = math.clamp(math.clamp(.99 - Audio.AudioAnalyzer.RmsLevel * 4, .8, 1) - ChangeCamGlitch.Value, 0, 1)

		FPSCap -= delta
		if FPSCap <= 0 then
			FPSCap += .09
			MapGui.Parent.Static.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 50) / 100, 0)
		end

		FPSCap2 -= delta
		if FPSCap2 <= 0 then
			FPSCap2 += .28
			MapGui.Parent.Static2.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
		end

		MapGui.Parent.Static.ImageTransparency = Level
		if Player:GetAttribute("InJumpscare") then
			CamClose()
		end
	end
end)

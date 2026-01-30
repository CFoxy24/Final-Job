local NewSre = script.Sre:Clone()

NewSre.Parent = workspace
local UIS = game:GetService("UserInputService")
local CurDelta = Vector3.zero

local Context = Instance.new("InputContext")
local action = Instance.new("InputAction")
local bind = Instance.new("InputBinding")
local bind2 = Instance.new("InputBinding")

Context.Parent = game.ReplicatedStorage
action.Parent = Context
action.Type = Enum.InputActionType.Bool
bind.Parent = action
bind.KeyCode = Enum.KeyCode.Space
bind2.KeyCode = Enum.KeyCode.ButtonA
bind2.Parent = action

local CurrentPrefered = UIS.PreferredInput

local Gui = NewSre:FindFirstChild("SurfaceGui",true)
local ConditionEvent = game.ReplicatedStorage:WaitForChild("Conditions")
local TW = game:GetService("TweenService")
local TI = TweenInfo.new(.6,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)
local Player = game.Players.LocalPlayer
local Conditions = {}

local coolstate = nil
local coolactu = nil

local GuiI = script.GUI:Clone()
GuiI.Parent = Player.PlayerGui
local Text = GuiI:WaitForChild("TextButton"):WaitForChild("TextButton"):WaitForChild("Label")

local function Open()
	coolactu = "making"
	NewSre.Te.AudioEmitter.AudioInteractionGroup = ""

	Gui.Open.TimePosition = 0
	Gui.Open:Play()

	Gui.Open:Play()
	
	if CurrentPrefered ~= Enum.PreferredInput.Touch then
		GuiI.Enabled = false
	end

	TW:Create(NewSre.Te.Weld,TI,{C1 = CFrame.Angles(0,0,0)}):Play()
	task.wait(.4)
	coolactu = "open"
end

local function Close()
	coolactu = "making"
	Gui.Close.TimePosition = 0
	Gui.Close:Play()
	
	GuiI.Enabled = true

	TW:Create(NewSre.Te.Weld,TI,{C1 = CFrame.Angles(math.rad(180),0,0)}):Play()
	task.wait(.4)
	NewSre.Te.AudioEmitter.AudioInteractionGroup = "none"
	coolactu = "close"
end

action.StateChanged:Connect(function(val)
	if Player and not Player:GetAttribute("InLocker") and not Player:GetAttribute("InCameras") then
		if val == true then
			coolstate = "open"
		else
			coolstate = "close"
		end
	end

end)

local Distance = 0

Text.Parent.Activated:Connect(function()
	action:Fire(not action:GetState())
end)

local function UpdateButtonText()
	if CurrentPrefered == Enum.PreferredInput.Gamepad then
		Text.Text = "Press A to show objectives"
	elseif CurrentPrefered == Enum.PreferredInput.Touch then
		Text.Text = "Press to show objectives"
	else
		Text.Text = "Press Space to show objectives"
	end
end

local function UpdateColor(v)
	v.Gui.Text = v.Name
	if v.Value == false then
		v.Gui.TextColor3 = Color3.fromRGB(255,0,0)
	elseif v.Value == true then
		v.Gui.TextColor3 = Color3.fromRGB(0,255,0)
	else
		v.Gui.TextColor3 = Color3.fromRGB(126, 126, 126)
	end
end

ConditionEvent.OnClientEvent:Connect(function(NewConditions)	
	for k,v in NewConditions do
		if not Conditions[k] then
			Conditions[k] = v
			
			local N = Gui.Frame.Ex:Clone()
			N.Parent = Gui.Frame
			N.Visible = true
			N.Text = v.Name
			
			Conditions[k].Gui = N
			
			UpdateColor(Conditions[k])
		else
			for k2,v2 in v do
				Conditions[k][k2] = v2
			end
			
			UpdateColor(Conditions[k])
		end
	end
end)
ConditionEvent:FireServer()

game:GetService("RunService").RenderStepped:Connect(function(deltatime)
	if Player and not Player:GetAttribute("InLocker") and not Player:GetAttribute("InCameras") then
		if coolactu ~= coolstate and coolactu ~= "making" then
			if coolstate == "open" then
				Open()
			else
				Close()
			end
		end
	else
		if coolstate == "open" then
			coolstate = "close"
			Close()
		end
	end
	
	if CurrentPrefered ~= UIS.PreferredInput then
		CurrentPrefered = UIS.PreferredInput
		UpdateButtonText()
	end
	

	local delta = UIS:GetMouseDelta()
	CurDelta = CurDelta:Lerp(Vector3.new(math.clamp(delta.X,-2,2),math.clamp(delta.Y,-2,2),0),deltatime*8)
	
	NewSre.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0,-.7,-.8)
	NewSre.Te.Weld.C0 = CFrame.Angles(math.rad(CurDelta.Y*6),math.rad(CurDelta.X*6),0) * CFrame.new(0,-.6,0)
	
	local Object = nil
	local Closest = 1000
	for k,v in Conditions do
		if v.Object ~= nil and v.Value == false then
			local Distance = (v.Object.Position-workspace.CurrentCamera.CFrame.Position).Magnitude
			if Distance < Closest then
				Closest = Distance
				Object = v
			end
		end
	end
	
	if Object then
		local DistanceClamped = math.clamp(-1 + Closest*.2,1,20)
		Distance-=deltatime / DistanceClamped
		NewSre.Light1.Color = Color3.fromRGB(150 * Distance*10,0,0)
		
		if Distance<=0 then
			Distance+=.15
			
			Object.Gui.BackgroundColor3 = Color3.fromRGB(70,70,70)
			TW:Create(Object.Gui, TweenInfo.new(.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
			
			Gui.Beep2.PlaybackSpeed = 1-(DistanceClamped/20)*.2
			Gui.Beep2.TimePosition = 0
			Gui.Beep2:Play()
		end
	end	
end)

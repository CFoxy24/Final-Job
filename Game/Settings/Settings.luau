local Context = Instance.new("InputContext")
local action = Instance.new("InputAction")
local bind = Instance.new("InputBinding")
local bind2 = Instance.new("InputBinding")

Context.Parent = game.ReplicatedStorage
action.Parent = Context
action.Type = Enum.InputActionType.Bool
bind.Parent = action
bind.KeyCode = Enum.KeyCode.T
bind2.KeyCode = Enum.KeyCode.ButtonY
bind2.Parent = action

local UIS = game:GetService("UserInputService")

local Curpreffered = nil
local Opened = false

local PerfMode = false

local Parent = script.Parent
local Logo = Parent:FindFirstChild("Logo")
local LogoText = Logo:FindFirstChild("TextLabel")
local Detect = Logo:FindFirstChild("Detect")
local Menu = Parent:FindFirstChild("Menu")
local Cam = workspace.CurrentCamera
local PerfmodeG = Menu:FindFirstChild("Left"):FindFirstChild("TextButton")

local ModeG = Menu:FindFirstChild("Mode",true)

Detect.Activated:Connect(function()
	action:Fire(true)
end)

local Folder = Instance.new("Folder")
Folder.Parent = game.ReplicatedStorage

local all = {}

local Lights = {}

local function ChangePerf()
	PerfMode = not PerfMode
	
	if PerfMode then
		all = {}
		Lights = {}
		
		ModeG.BackgroundColor3 = Color3.fromRGB(0, 144, 12)
		ModeG:FindFirstChild("Tet").Text = "On"
		
		for k,v in game:GetDescendants() do
			if v:HasTag("FoliageFolder") then
				table.insert(all,{v,v.Parent})
				v.Parent = Folder
			elseif v:IsA("Light") and v.Shadows == true then
				table.insert(Lights,v)
				v.Shadows = false
			end
		end
	else
		ModeG.BackgroundColor3 = Color3.fromRGB(165, 0, 0)
		ModeG:FindFirstChild("Tet").Text = "Off"
		for k,v in all do
			v[1].Parent = v[2]
		end
		for k,v in Lights do
			v.Shadows = true
		end
	end
end

PerfmodeG.Activated:Connect(ChangePerf)

action.StateChanged:Connect(function(val)
	if val == true then
		action:Fire(false)
		Opened = not Opened
		
		UIS.MouseBehavior = Enum.MouseBehavior.Default
		Menu.Visible = Opened
		
		if Opened then
			Cam.CameraType = Enum.CameraType.Scriptable
		else
			Cam.CameraType = Enum.CameraType.Custom
		end
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if Curpreffered ~= UIS.PreferredInput then
		Curpreffered = UIS.PreferredInput
		if Curpreffered == Enum.PreferredInput.KeyboardAndMouse then
			LogoText.Text = "Press T"
		elseif Curpreffered == Enum.PreferredInput.Gamepad then
			LogoText.Text = "Press Y"
		else
			LogoText.Text = "Press"
		end
	end
end)
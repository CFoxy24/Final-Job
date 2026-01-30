--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

--// Camera Bobbing Animation
local noiseX, noiseY, noiseZ = math.random(0,10000), math.random(0,10000), math.random(0,10000)
local amplitude = 0.15
local totalDelta = 0

local CFrameBase = Instance.new("CFrameValue")
CFrameBase.Value = CFrame.new() * CFrame.Angles(-math.rad(90), 0, 0)

local MouseCFrame = Instance.new("CFrameValue")

--// Player and Camera
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera
Camera.CameraType = Enum.CameraType.Scriptable
Camera.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(-math.rad(90), 0, 0)

--// Audio System Setup
local Listener = Instance.new("AudioListener", Camera)
local Fader = Instance.new("AudioFader", Camera)
Fader.Volume = 0

local Output = Instance.new("AudioDeviceOutput", Camera)
Output.Player = Player

-- Wires
local Wire1 = Instance.new("Wire", Listener)
Wire1.SourceInstance = Listener
Wire1.TargetInstance = Fader

local Wire2 = Instance.new("Wire", Fader)
Wire2.SourceInstance = Fader
Wire2.TargetInstance = Output

--// GUI Setup
local Gui = Player.PlayerGui
local BlackScreen = script:WaitForChild("LoadScreen")
BlackScreen.Parent = Gui
local WarningScreen = script:WaitForChild("Warning")
WarningScreen.Parent = Gui

local Screen = script:WaitForChild("Screen")
Screen.Parent = Gui
Screen.Adornee = workspace:WaitForChild("Screen")
Screen.Enabled = true

local PhysicalMouse = workspace:FindFirstChild("Mouse",true)
local MouseSoundStep = 0

local RealPhysicalMouse = workspace:FindFirstChild("ComputerMouse",true)
local MouseCFR = RealPhysicalMouse.PrimaryPart.CFrame

local Website = Screen.PC.Website
local ChosenMenu = nil
local InTransition = false
local InScreen = false
local InParty = nil

local Servers = {}
local PartyGuis = {}

ReplicatedFirst:RemoveDefaultLoadingScreen()
ContentProvider:PreloadAsync({game})

--// Wait for game and server signal
repeat task.wait() until workspace:GetAttribute("FullyLoaded") == true

if not game:IsLoaded() then game.Loaded:Wait() end

local HasLoaded = false
ReplicatedStorage.Loaded.OnClientEvent:Connect(function()
	HasLoaded = true
end)
ReplicatedStorage:WaitForChild("Loaded"):FireServer()

repeat task.wait() until HasLoaded

--// UI Interactions

local function EmulateClick(bool)
	if InScreen then
		MouseSoundStep+=1
		local SPlayer = PhysicalMouse[(if bool then "In" else "Out") .. MouseSoundStep%3]
		SPlayer:Play()
		SPlayer.PlaybackSpeed = math.random(98,102)/100
	end
end

local function CreateClickEvent(object)
	local ClickEvent = Instance.new("BindableEvent")
	local ClickConnect = ClickEvent.Event
	object.MouseButton1Down:Connect(function()
		ClickEvent:Fire()
	end)
	object.TouchTap:Connect(function()
		ClickEvent:Fire()
	end)
	return ClickConnect
end

local function Transition(Start,End)
	InTransition = true
	TweenService:Create(workspace.Sounds.PC.hdd,TweenInfo.new(2.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Volume=.4,PlaybackSpeed=1.5}):Play()
	local StartVisibles = {}
	for k,v in Start:GetDescendants() do
		if v:IsA("GuiObject") then
			if v.Visible == true then
				table.insert(StartVisibles,v)
				task.spawn(function()
					task.wait(math.random(0,100)/500)
					v.Visible = false
				end)
			end
		end
	end
	task.wait(.8)
	Start.Visible = false
	for k,v in StartVisibles do
		v.Visible = true
	end
	
	local EndVisibles = {}
	for k,v in End:GetDescendants() do
		if v:IsA("GuiObject") then
			if v.Visible == true then
				table.insert(EndVisibles,v)
				v.Visible = false
			end
		end
	end
	
	End.Visible = true
	for k,v in EndVisibles do
		task.spawn(function()
			task.wait(math.random(0,100)/300)
			v.Visible = true
		end)
	end
	task.wait(1)
	TweenService:Create(workspace.Sounds.PC.hdd,TweenInfo.new(3.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Volume=0,PlaybackSpeed=.5}):Play()
	InTransition = false
end

-- Menu Switching
for _, button : TextButton in Website.ResultBar:GetChildren() do
	local Menu = Website:FindFirstChild(button.Name)
	if Menu then
		CreateClickEvent(button):Connect(function()
			EmulateClick(true)
			if not InTransition then
				Transition(Website.ResultBar,Menu)
				ChosenMenu = Menu
			end
		end)
		
		button.MouseButton1Up:Connect(function()
			EmulateClick(false)
		end)
	end
end

-- Undo / Redo
CreateClickEvent(Website.URLBar.Undo):Connect(function()
	EmulateClick(true)
	if ChosenMenu and not InTransition and not Website.ResultBar.Visible then
		Transition(ChosenMenu,Website.ResultBar)
	end
end)

Website.URLBar.Undo.MouseButton1Up:Connect(function()
	EmulateClick(false)
end)

CreateClickEvent(Website.URLBar.Redo):Connect(function()
	EmulateClick(true)
	if ChosenMenu and not InTransition and not ChosenMenu.Visible then
		Transition(Website.ResultBar,ChosenMenu)
	end
end)

Website.URLBar.Redo.MouseButton1Up:Connect(function()
	EmulateClick(false)
end)

-- Server Buttons
CreateClickEvent(Website.Servers.Host):Connect(function()
	ReplicatedStorage.ServerActions.Create:FireServer()
end)

Website.Servers.HostGui.Settings.StartStop.Main.Start.MouseButton1Click:Connect(function()
	ReplicatedStorage.ServerActions.Start:FireServer()
end)

local Night = 0
Website.Servers.HostGui.Settings.Night.Main.Button.MouseButton1Click:Connect(function()
	Night = (Night+1)%6
	ReplicatedStorage.ServerActions.Night:FireServer(Night+1)
	Website.Servers.HostGui.Settings.Night.Main.Button.Text = Night +1
end)

Website.Servers.HostGui.Settings.StartStop.Main.Button.MouseButton1Click:Connect(function()
	ReplicatedStorage.ServerActions.Stop:FireServer()
end)

Website.Servers.HostGui.Player.StartStop.Main.Button.MouseButton1Click:Connect(function()
	ReplicatedStorage.ServerActions.Leave:FireServer(InParty)
end)

local Private = false
Website.Servers.HostGui.Settings.Visibility.Main.Button.MouseButton1Click:Connect(function()
	Private = not Private
	if Private then
		Website.Servers.HostGui.Settings.Visibility.Main.Button.Text = "Friends"
	else
		Website.Servers.HostGui.Settings.Visibility.Main.Button.Text = "Public"
	end
	ReplicatedStorage.ServerActions.ChangeMode:FireServer(Private)
end)

ReplicatedStorage:WaitForChild("ShowHostGui").OnClientEvent:Connect(function(Serv,Val)
	if Serv and Val ~= nil then
		InParty = Serv
		if Val then
			if Serv == Player.UserId then
				Website.Servers.HostGui.Settings.Visible = true
				Website.Servers.HostGui.Player.Visible = false
			else
				Website.Servers.HostGui.Settings.Visible = false
				Website.Servers.HostGui.Player.Visible = true
			end
		end
		Website.Servers.HostGui.Visible = Val
		
		Website.Servers.List.Visible = not Val
		Website.Servers.Host.Visible = not Val
	end
end)

local AllPLRS = {}

local function CreateServerGUI(k,Data)
	local NS = Website.Servers.List.EX:Clone()
	NS.Parent = Website.Servers.List
	NS.Button.Text = Players:GetPlayerByUserId(k).Name
	NS.Name = "Server"
	NS.Visible = true

	CreateClickEvent(NS.Button):Connect(function()
		ReplicatedStorage.ServerActions.Join:FireServer(k)
	end)

	Data.Gui = NS
end

local function RemoveServ(userid,Data)
	if Data then
		if Data.Gui then
			Data.Gui:Destroy()
		end
		Data = nil
		Servers[userid] = nil
	end
end

local function PrivateCheck(userid,Data)
	if Data.Private then
		if Player:IsFriendsWith(userid) then
			return true
		else
			return false
		end
	else
		return true
	end
end

local function RemoveGui(Data)
	if Data.Gui then
		Data.Gui:Destroy()
		Data.Gui = nil
	end
end

local function UpdateGui(Gui, Data)
	if Data and Gui and Gui:FindFirstChild("Button") and Data.Player then
		Gui.Button.Text = Data.Player.Name .. " - " .. #Data.List
	end
end

local function UpdatePartyCount(Data)
	if Data.List then
		local Copy = table.clone(PartyGuis)
		for k,v in Data.List do
			if Copy[v] then
				Copy[v] = nil
			end
			if not PartyGuis[v] then
				local REALPLR = game.Players:GetPlayerByUserId(v)
				if REALPLR then
					local NS = Website.Servers.HostGui.Players.PLREX:Clone()
					NS.Parent = Website.Servers.HostGui.Players
					NS.Main.Text.Text = REALPLR.DisplayName

					local F = function()
						ReplicatedStorage.ServerActions.Kick:FireServer(tostring(v))
					end

					NS.Main.Button.MouseButton1Click:Connect(F)
					NS.Main.Button.TouchTap:Connect(F)

					NS.Visible = true

					PartyGuis[v] = NS
				end
			end
		end
		for k,v in Copy do
			PartyGuis[k]:Destroy()
			PartyGuis[k] = nil
		end
	end
end

local function Update(userid,Data,NewData)
	if NewData.IsHost == true and PrivateCheck(userid,NewData) then
		local Gui = if Data.Gui then Data.Gui else CreateServerGUI(userid,Data)
		UpdateGui(Gui,Data)

		if tonumber(InParty) == tonumber(userid) then
			UpdatePartyCount(Data)
		end
	else
		RemoveGui(Data)
	end
end

local function UpdateServ(userid,Data,NewData)
	if NewData.IsHost ~= Data.IsHost then
		Data.IsHost = NewData.IsHost
		
		Update(userid,Data,NewData)
	end
	if NewData.Private ~= Data.Private then
		Data.Private = NewData.Private
		
		Update(userid,Data,NewData)
	end
	if NewData.List ~= Data.List then
		Data.List = NewData.List

		Update(userid,Data,NewData)
	end
end

local function CheckServ(userid,Data,NewData)
	local CPlayer = nil
	
	if Data.Player then
		CPlayer = Data.Player
	else
		CPlayer = Players:GetPlayerByUserId(userid)
		Data.Player = CPlayer
	end
	
	if CPlayer then
		UpdateServ(userid,Data,NewData)
	else
		RemoveServ(Data)
	end
end

local function UpdateServers()
	if not workspace:GetAttribute("Servers")  then return end
	local newServers = game:GetService("HttpService"):JSONDecode(workspace:GetAttribute("Servers"))
	if not newServers then return end

	local CheckedServs = {}

	for userid, data in newServers do
		local CServ = Servers[userid]
		if not CServ then
			Servers[userid] = data
			CServ = data
		end
		CheckedServs[userid] = true
		CheckServ(userid,CServ,data)
	end
	
	task.spawn(function()
		for k,v in Servers do
			if not CheckedServs[k] then
				RemoveGui(v)
			end
		end
	end)
end

workspace:GetAttributeChangedSignal("Servers"):Connect(function()
	UpdateServers()
end)
UpdateServers()

task.wait(1)

-- Play Initial Sounds
SoundService.Whispers:Play()
task.wait(1.4)
SoundService.Breath:Play()
task.wait(0.6)
SoundService.MenuOST:Play()
SoundService.Ambience:Play()
SoundService.Thud:Play()
UpdateServers()

RunService.RenderStepped:Connect(function(deltaTime)
	totalDelta += deltaTime

	-- Services
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local Camera = workspace.CurrentCamera

	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

	if isMobile then
		Camera.FieldOfView = 40
		Camera.CFrame = CFrameBase.Value
	else 
		Camera.CFrame = CFrameBase.Value * MouseCFrame.Value *
			CFrame.Angles(
				math.rad(math.noise(noiseX + totalDelta * 2.5, 0, 0) * amplitude + math.sin(totalDelta) * 0.5),
				math.rad(math.noise(0, noiseY + totalDelta * 0.8, 0) * amplitude),
				math.rad(math.noise(0, 0, noiseZ + totalDelta * 1.8) * amplitude)
			)
	end

	UserInputService.MouseIconEnabled = Mouse.Target ~= workspace.Screen
	InScreen = Mouse.Target == workspace.Screen

	TweenService:Create(MouseCFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Value = CFrame.Angles(
			math.rad(((-Mouse.Y / Mouse.ViewSizeY) + 0.5) * 3),
			math.rad(((-Mouse.X / Mouse.ViewSizeX) + 0.5) * 3),
			0
		)
	}):Play()
end)

-- Mouse Move Logo Effect
Screen.PC.MouseMoved:Connect(function(x, y)
	Screen.Logo.Position = UDim2.new(0, x, 0, y)
	RealPhysicalMouse:PivotTo(MouseCFR * 
		CFrame.new(
			(y/Screen.CanvasSize.Y)-.25,
			0,
			((-x)/Screen.CanvasSize.X)+.25
		)
	)
end)

Mouse.Button1Down:Connect(function()
	EmulateClick(true)
end)
Mouse.Button1Up:Connect(function()
	EmulateClick(false)
end)

task.spawn(function()
	
	local RBXN = {
		["10 R$"] = 1,
		["50 R$"] = 2,
		["100 R$"] = 3,
		["250 R$"] = 4,
		["750 R$"] = 5,
		["1500 R$"] = 6,
		["3000 R$"] = 7,
		["5000 R$"] = 8,
		["10000 R$"] = 9,
	}

	local Donations = Website:FindFirstChild("Donations"):FindFirstChild("List")

	for k,v in RBXN do
		local N = Donations:FindFirstChild("EX"):Clone()
		N.Name = "Don"
		N.Visible = true
		N.LayoutOrder = v
		N.Parent = Donations
		local Button = N:FindFirstChild("Button")
		
		Button.Text = k

		local function Prompt()
			ReplicatedStorage.Donate:FireServer(v)
		end

		Button.TouchTap:Connect(Prompt)
		Button.MouseButton1Click:Connect(Prompt)
	end
end)


--// Final Transitions
TweenService:Create(CFrameBase, TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
	Value = CFrame.new()
}):Play()

TweenService:Create(BlackScreen.Frame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
	BackgroundTransparency = 1,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255)
}):Play()

TweenService:Create(Fader, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
	Volume = 1
}):Play()


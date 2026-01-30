local clock = os.clock()

local Parent = script.Parent
local Load = script.LoadScreen
local Player = game.Players.LocalPlayer
local Gui = Player.PlayerGui
local TW = game:GetService("TweenService")

Load.Parent = Gui

local function FinishLoading()
	Gui:WaitForChild("LoadScreenSpawn").Enabled = true
	Parent:WaitForChild("Flashlight").Enabled=true
	Parent:WaitForChild("AnimatronicAnimations").Enabled=true
	Load.Enabled = false
	TW:Create(Gui.LoadScreenSpawn.Main,TweenInfo.new(2,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{BackgroundTransparency = 1}):Play() 
	task.wait(2)
	Gui.LoadScreenSpawn.Enabled=false
end

if Player.Character then
	FinishLoading()
end

Player.CharacterAdded:Connect(function()
	FinishLoading()
end)

local function UpdatePlayers()
	Load.Main.Players.Text = workspace:GetAttribute("LoadedPlayers") .. "/" .. workspace:GetAttribute("SaidPlayers")
end

UpdatePlayers()
workspace:GetAttributeChangedSignal("LoadedPlayers"):Connect(UpdatePlayers)

game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()

local ContentProvider = game:GetService("ContentProvider")
ContentProvider:PreloadAsync(
	{game},
	function(asset: string,assetFetchStatus: Enum.AssetFetchStatus)
		Load.Main.Asset.Text = "Loading: " .. asset
		Load.Main.Status.Text = "Status: " .. assetFetchStatus.Name
	end
)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

game.ReplicatedStorage.Loaded.OnClientEvent:Connect(function()
	TW:Create(Load.Main,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{GroupTransparency = 1}):Play() 
	task.wait(1)
	Load.Main.Visible = false
end)

Player:SetAttribute("GameReady", true)

Parent:WaitForChild("SecurityCameraController").Enabled=true

Load.Main.Asset.Text = "Loading: Cameras"
Load.Main.Status.Text = "Status: Not Ready"
repeat task.wait() until Player:GetAttribute("CamerasReady") == true
Load.Main.Status.Text = "Status: Ready"

game.ReplicatedStorage.Loaded:FireServer()



print(("Loading complete, took %.2f seconds"):format(os.clock() - clock))
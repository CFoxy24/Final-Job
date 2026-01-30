local UIS = game:GetService("UserInputService")
local TW = game:GetService("TweenService")

local LeanRemote = game.ReplicatedStorage:WaitForChild("Lean")

local Waist = script.Parent:WaitForChild("UpperTorso"):WaitForChild("Waist")
local LeanState = 0

local TWInfo = TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out)
local WaistPosition = Waist.C0.Position


local function ChangeLeanState()
	TW:Create(Waist,TWInfo,{C0 = CFrame.Angles(0,0,math.rad(LeanState * 40)) + WaistPosition}):Play()
	LeanRemote:FireServer(LeanState,Waist)
end

LeanRemote.OnClientEvent:Connect(function(State,PLRWaist)
	if State and PLRWaist and PLRWaist ~= Waist then
		TW:Create(PLRWaist,TWInfo,{C0 = CFrame.Angles(0,0,math.rad(State * 40)) + WaistPosition}):Play()
	end
end)

script.Context.InputAction.StateChanged:Connect(function(value)
	LeanState = value
	ChangeLeanState()
end)
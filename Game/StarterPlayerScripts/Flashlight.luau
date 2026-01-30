local AT = Instance.new("Attachment")
local CFR = Instance.new("CFrameValue")
local TW = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Light = Instance.new("SpotLight")
local MouseDelta = Vector2.zero
local Camera = workspace.CurrentCamera
local Player = game.Players.LocalPlayer

-- Variables

local Range = 50
local Angle = 60
local Smoothness = .2
local EnticipationSensitivity = 3
local EnticipationMax = 20

------------

Light.Parent = AT
Light.Range = Range
Light.Angle = Angle
Light.Shadows = true

AT.Parent = workspace.Terrain

game:GetService("RunService"):BindToRenderStep("Test",Enum.RenderPriority.First.Value,function()
	if Player:GetAttribute("InCameras") or Player:GetAttribute("InLocker") then Light.Enabled = false return end
	Light.Enabled = true
	MouseDelta = (UIS:GetMouseDelta().Unit/UserSettings().GameSettings.MouseSensitivity) * math.clamp(UIS:GetMouseDelta().Magnitude*.6,0,7)
	if MouseDelta ~= MouseDelta then
		MouseDelta = Vector2.zero
	end

	-- TW:Create(CFR,TweenInfo.new(.2 - math.clamp(UIS:GetMouseDelta().Magnitude*.005,0,.15),Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Value = Camera.CFrame * CFrame.Angles(math.rad(-MouseDelta.Y),math.rad(-MouseDelta.X),0)}):Play()
	TW:Create(CFR,TweenInfo.new(.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Value = Camera.CFrame }):Play()
	-- TW:Create(CFR,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Value = Camera.CFrame * CFrame.Angles(math.rad(-MouseDelta.Y),math.rad(-MouseDelta.X),0)}):Play()
	AT.CFrame = CFR.Value.Rotation + Camera.CFrame.Position
end)
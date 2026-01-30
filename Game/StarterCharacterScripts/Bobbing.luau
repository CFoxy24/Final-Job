local Character = script.Parent

local Camera = workspace.CurrentCamera
local RootPart = Character.PrimaryPart

local Cam = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

local Player = game.Players.LocalPlayer

Player:SetAttribute("InCameras",false)
Player:SetAttribute("InJumpscare",false)
Cam.CameraType = Enum.CameraType.Custom

Player.CameraMaxZoomDistance = .5
Player.CameraMinZoomDistance = .5

Player.CameraMode = Enum.CameraMode.LockFirstPerson
UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

game:GetService("RunService"):BindToRenderStep("Main",Enum.RenderPriority.Camera.Value,function()
	if not Character or not RootPart or not Character.PrimaryPart or not Character:FindFirstChild("Head") or Player:GetAttribute("InCameras") then return end
	local RootPos = RootPart.Position
	Character.PrimaryPart.CFrame = CFrame.lookAt(RootPos, RootPos+Vector3.new(Camera.CFrame.LookVector.X,0, Camera.CFrame.LookVector.Z))

	Camera.CFrame=Camera.CFrame.Rotation * CFrame.new(0,.5,-.1) + Character.Head.Position
end)
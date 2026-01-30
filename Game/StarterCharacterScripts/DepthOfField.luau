local Collisions = workspace:WaitForChild("Collisions")

local Params = RaycastParams.new()
Params.FilterType = Enum.RaycastFilterType.Include
Params.FilterDescendantsInstances = {Collisions:WaitForChild("Walls"), Collisions:WaitForChild("Props")}

local Cam = workspace.CurrentCamera
local Lighting = game.Lighting
local DoF = Lighting:WaitForChild("DepthOfField")
local TW = game:GetService("TweenService")
local Info = TweenInfo.new(.7,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
local InFocus = false

game:GetService("RunService"):BindToRenderStep("Test",Enum.RenderPriority.First.Value,function()
	local ray = workspace:Raycast(Cam.CFrame.Position, Cam.CFrame.LookVector * 6, Params)
	if ray then
		InFocus=true
		TW:Create(DoF,Info,{FocusDistance = ray.Distance}):Play()
	elseif InFocus then
		InFocus=false
		TW:Create(DoF,Info,{FocusDistance = 40}):Play()
	end
end)
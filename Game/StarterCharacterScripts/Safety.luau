local Char = script.Parent
local Rootpart = Char:WaitForChild("HumanoidRootPart")

local function ResetPos()
	if Char and Rootpart then
		Char:PivotTo(CFrame.new(-2.47, -9, 100.59))
	end
end

game:GetService("RunService").RenderStepped:Connect(function(delta)
	if Rootpart then
		local Pos = Rootpart.Position
		if 
			Pos.X>151 or Pos.X<-152 or
			Pos.Y>7 or Pos.Y<-20 or
			Pos.Z>112 or Pos.Z<-104
		then
			ResetPos()
		end
	end
end)
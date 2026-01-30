local module = {}
local TW = game:GetService("TweenService")

function module.CreateVisual()
	local Visual = Instance.new("Part")
	Visual.Parent = workspace
	Visual.Anchored = true
	Visual.CanCollide = false
	Visual.CanQuery = false
	Visual.CanTouch = false
	Visual.Transparency = 0
	Visual.Size = Vector3.one*.5
	Visual.Material = Enum.Material.Neon
	Visual.BrickColor = BrickColor.Red()
	Visual.Name = "Visual"
	Visual.Shape = Enum.PartType.Ball
	
	return Visual
end

function module.MoveVisual(Pos, which)
	if typeof(Pos) == "Vector3" then
		which.Position = Pos
	elseif typeof(Pos) == "CFrame" then
		which.CFrame = Pos
	end
	
	return which
end

function module.FadeVisual(Time, which)
	task.spawn(function()
		TW:Create(which,TweenInfo.new(Time,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency = 1}):Play()
		task.wait(1)
		which:Destroy()
	end)
	
	return which
end

function module.ColorVisual(color, which)
	which.Color = color
	
	return which
end

function module.FullVisual(Pos,Time,Color)
	if not game:GetService("RunService"):IsStudio() or true then return end
	local Visual = module.CreateVisual()
	module.MoveVisual(Pos,Visual)
	module.FadeVisual(Time,Visual)
	module.ColorVisual(Color,Visual)
end

return module

local function Check(v)

	if v:IsA("BasePart") then
		v.AudioCanCollide = false
		v.CollisionGroup = "Players"
	end
end

for k,v in script.Parent:GetDescendants() do
	Check(v)
end
script.Parent.DescendantAdded:Connect(function(v)
	Check(v)
end)


local humanoid = script.Parent:WaitForChild("Humanoid")

humanoid.BreakJointsOnDeath = false

humanoid.Died:Connect(function()
	for i,v in pairs(script.Parent:GetChildren()) do
		if v:IsA("BasePart")  then
			v.CanCollide = true
		end
	end
	for index,joint in pairs(script.Parent:GetDescendants()) do
		if joint:IsA("Motor6D") and joint.Parent ~= script.Parent.LowerTorso then
			local socket = Instance.new("BallSocketConstraint")
			local a1 = Instance.new("Attachment")
			local a2 = Instance.new("Attachment")
			a1.Parent = joint.Part0
			a2.Parent = joint.Part1
			socket.Parent = joint.Parent
			socket.Attachment0 = a1
			socket.Attachment1 = a2
			a1.CFrame = joint.C0
			a2.CFrame = joint.C1
			socket.LimitsEnabled = true
			socket.TwistLimitsEnabled = true
			joint:Destroy()
			local NCC = Instance.new("NoCollisionConstraint")
			NCC.Parent = joint.Part0
			NCC.Part0 = joint.Part0
			NCC.Part1 = joint.Part1
			script.Parent.HumanoidRootPart.CanCollide = false
		end
	end
end)
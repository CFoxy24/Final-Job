local function Check(v)
	if v:IsA("Humanoid") then
		v:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
		v.AutoRotate = false

	end
	
	if v:IsA("BasePart") then
		v.AudioCanCollide = false
		v.CollisionGroup = "Players"
		
		if v.Name ~= "Head" then
			v:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
				v.LocalTransparencyModifier = 0
			end)
			v.LocalTransparencyModifier = 0
		end
	end
	
	if v:IsA("Accessory") then
		if v.AccessoryType == Enum.AccessoryType.Hat or v.AccessoryType == Enum.AccessoryType.Hair or v.AccessoryType == Enum.AccessoryType.Eyebrow or v.AccessoryType == Enum.AccessoryType.Unknown or v.AccessoryType == Enum.AccessoryType.Eyelash or v.AccessoryType == Enum.AccessoryType.Face then
			for _,v in pairs(v:GetDescendants()) do
				if v:IsA("BasePart") then
					v:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
						if v:GetAttribute("Override")==false then
							v.LocalTransparencyModifier = 1
						end
					end)
					v.LocalTransparencyModifier = 1
				end
			end
		else
			for _,v in pairs(v:GetDescendants()) do
				if v:IsA("BasePart") then
					v:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
						v.LocalTransparencyModifier = 0
					end)
					v.LocalTransparencyModifier = 0
				end
			end
		end
	end
end

for k,v in script.Parent:GetChildren() do
	Check(v)
end
script.Parent.ChildAdded:Connect(function(v)
	Check(v)
end)
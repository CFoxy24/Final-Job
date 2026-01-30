local module = {}

local SStorage = game.ServerStorage

function module.Activate(Which)
	if Which and Which ~= nil and Which:IsA("Model") and Which:FindFirstChild("AI") and Which:FindFirstChild("Animate") then
		Which.AI.Enabled = true

		return Which	
	else
		return false
	end
end

function module.Setup(Name)
	local Check = SStorage.Animatronics.Models:FindFirstChild(Name)
	if Check then
		local New = Check:Clone()
		New.Parent = workspace.Animatronics
		
		for k,v in SStorage.Animatronics.Scripts:GetChildren() do
			local NewScript = v:Clone()
			NewScript.Parent = New
			
		end
		
		New.Animate.Enabled = true
		
		return New	
	else
		return false
	end
end

return module

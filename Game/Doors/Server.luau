local State = false
local Prox = script.Parent.Parent

local CFR = script.Collision.CFrame

script.Collision.CFrame = CFrame.new(0,1000,0)

Prox.Triggered:Connect(function()
	if not State then
		State = true
		script.Repl:FireAllClients(true)
		Prox.Enabled = false
		Prox.REF.Value.Color = Color3.fromRGB(195, 64, 47)
		script.Collision.CFrame = CFR
		task.wait(10)
		
		script.Repl:FireAllClients(false)
		task.wait(1)
		script.Collision.CFrame = CFrame.new(0,1000,0)
		task.wait(19)
		Prox.Enabled = true
		Prox.REF.Value.Color = Color3.fromRGB(0, 0, 0)
		State = false
	end
end)
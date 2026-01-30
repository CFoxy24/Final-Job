local TW = game:GetService("TweenService")

script.Parent.OnClientEvent:Connect(function(state)
	if state then
		script.Parent.Value.Value.Close2:Play()
		
		TW:Create(script.Parent.Parent.Parent.Value,TweenInfo.new(.7,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{C0 = CFrame.new(0,10,0)}):Play()
		task.wait(.6)
		script.Parent.Value.Value.Close1:Play()
	else
		script.Parent.Value.Value.Open1:Play()
		task.wait(1)
		script.Parent.Value.Value.Open2:Play()
		TW:Create(script.Parent.Parent.Parent.Value,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{C0 = CFrame.new(0,.1,0)}):Play()
	end
end)
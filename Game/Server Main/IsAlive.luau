script.Parent:SetAttribute("AliveSince", os.time())

game:GetService("RunService").Heartbeat:Connect(function(delta)
	if os.time() - script.Parent:GetAttribute("AliveSince") > 60 then
		for _,P in game.Players:GetPlayers() do
			P:Kick("The server has crashed!")
		end
	end
end)
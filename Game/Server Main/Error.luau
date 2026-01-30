local module = {}

local ErrorMessages = 
	{
		"Unknown",
		"A module hasn't initiated correctly.",
		"An incorrect data has been detected.",
		"Animatronic is missing."
	}

local function StopServer(Argument)
	warn("A critical error occured: " .. Argument)

	for _,v in game.Players:GetPlayers() do
		v:Kick("A critical error occured: " .. Argument)
	end
end

function module.Catch(Value, MessageNumber)
	if Value == nil or (typeof(Value) == "boolean" and Value == false) then
		if MessageNumber == nil or ErrorMessages[MessageNumber] == nil then MessageNumber = 1 end
		StopServer(ErrorMessages[MessageNumber])
		
		return false
	else
		return Value
	end
end

function module.Log(txt)
	print(txt)
end

return module

local module = {}

local MemStore = game:GetService("MemoryStoreService")
local ServerData = MemStore:GetHashMap("ServerData")
local Data = {}
local Finished = false

if game:GetService("RunService"):IsStudio() then
	Data.PlayersNeeded = 2
	Data.NightType = 1
	Data.NightNumber = 1

	Finished = true
else	
	local Success,RawData
	repeat
		task.wait(.2)
		Success, RawData = pcall(function()
			return ServerData:GetAsync(tostring(game.PrivateServerId))
		end)
		
		if RawData == nil or not Success then Success = false continue end

		local DecodedData = game:GetService("HttpService"):JSONDecode(RawData)
		if DecodedData == nil or typeof(DecodedData) ~= "table" then Success = false continue end
		
		if DecodedData[1] == nil or typeof(DecodedData[1]) ~= "number" then Success = false continue end
		if DecodedData[2] == nil or typeof(DecodedData[2]) ~= "number" then Success = false continue end
		if DecodedData[3] == nil or typeof(DecodedData[3]) ~= "number" then Success = false continue end
		
		Data.PlayersNeeded = DecodedData[1]
		Data.NightType = DecodedData[2]
		Data.NightNumber = DecodedData[3]
		
		Finished = true
		
		_, _ = pcall(function()
			ServerData:RemoveAsync(tostring(game.PrivateServerId))
		end)
	until Success and Finished
end

function module.Initiate()
	local TimeOut = 0
	repeat TimeOut += 1 task.wait() print("MemoryStore Initiating...") until Finished == true or TimeOut >= 2000
	if TimeOut>= 2000 then
		return false
	else
		return true
	end
end

function module.Get(which)
	return Data[which]
end

return module
	
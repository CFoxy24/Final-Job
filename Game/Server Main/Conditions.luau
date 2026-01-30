local module = {}

local HTTPService = game:GetService("HttpService")
local Conditions = {}

local ConditionEvent = game.ReplicatedStorage:WaitForChild("Conditions")

function module.Send()
	ConditionEvent:FireAllClients(Conditions)
end
ConditionEvent.OnServerEvent:Connect(module.Send)

function module.NewCondition(Object,Name,Value)
	local ConditionID = HTTPService:GenerateGUID()
	
	Conditions[ConditionID] = {Object = Object,Name = Name,Value = Value}
	
	module.Send()
	
	return Conditions[ConditionID]
end

function module.ChangeCondition(which,value)
	if which and value ~= nil then
		which.Value = value

		module.Send()
	end
end

return module

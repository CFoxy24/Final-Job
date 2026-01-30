local module = {}

local function MoveCharacter(player,Pos)
	if not player then return end
	
	local Char = player.Character
	if not Char then return end
	
	local RootPart = Char.PrimaryPart
	if not RootPart then return end
	
	local Humanoid = Char:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return end
	if Humanoid.Health <= 0 then return end
	
	RootPart:PivotTo(Pos)
end

function module.Spawn(who)
	if typeof(who) == "table" then
		for k,v in who do
			v:LoadCharacter()
		end
	else
		who:LoadCharacter()
	end
end

function module.Move(who, Pos)
	if typeof(Pos) == "Vector3" then
		Pos = CFrame.new(Pos)
	elseif typeof(Pos) ~= "CFrame" then
		return
	end
	
	if typeof(who) == "table" then
		for k,v in who do
			MoveCharacter(v, Pos)
		end
	else
		MoveCharacter(who, Pos)
	end
end

return module

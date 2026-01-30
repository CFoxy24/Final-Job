local function isVector3Between(vectorToCheck, vector1, vector2)
	-- Check if all components exist and are Vector3
	if not vectorToCheck or not vector1 or not vector2 then
		return false
	end

	-- For each component (X, Y, Z), check if it's between the min and max of the other two vectors
	local function isBetween(value, bound1, bound2)
		local minVal = math.min(bound1, bound2)
		local maxVal = math.max(bound1, bound2)
		return value >= minVal and value <= maxVal
	end

	-- Check all three components
	local xBetween = isBetween(vectorToCheck.X, vector1.X, vector2.X)
	local zBetween = isBetween(vectorToCheck.Z, vector1.Z, vector2.Z)

	-- Return true only if all components are between
	return xBetween and zBetween
end

local Update = 0
local Map = workspace:WaitForChild("Map")
local ZoneVisible = {}

local Zones = {
	Arcade = {Visible = {"MainArcade","MainArcade1","DinnerRoom","LeftCorridor","HiddenStorage","Arcade","ArcadeCorridor","Restroom","EntranceCorridor", "Office"}},
	ArcadeCorridor = {Visible = {"MainArcade","MainArcade1","DinnerRoom","LeftCorridor","HiddenStorage","Kitchen","Arcade","ArcadeCorridor","Restroom","EntranceCorridor", "Office"}},
	DinnerRoom = {Visible = {"Storage","Entrance","EntranceCorridor","RightStorage","DinnerRoom","Kitchen","Arcade","ArcadeCorridor","Restroom","LeftCorridor","RightCorridor","MainArcade","MainArcade1","LeftStorage", "Office"}},
	Entrance = {Visible = {"Entrance","Parking","EntranceCorridor","DinnerRoom","Restroom","RightCorridor", "Office"}},
	EntranceCorridor = {Visible = {"Entrance","Parking","EntranceCorridor","DinnerRoom","Restroom","RightCorridor","MainArcade","MainArcade1","LeftCorridor","Kitchen", "Office"}},
	HiddenStorage = {Visible = {"Storage","HiddenStorage","LeftCorridor","RightCorridor","DinnerRoom","MainArcade","MainArcade1", "Office"}},
	Kitchen = {Visible = {"MainArcade","MainArcade1","DinnerRoom","Restroom","LeftCorridor","Kitchen", "Office"}},
	LeftCorridor = {Visible = {"Storage","MainArcade","RightCorridor","MainArcade1","DinnerRoom","LeftCorridor","LeftCorridor1","HiddenStorage","Kitchen","ArcadeCorridor","LeftStorage","Restroom","EntranceCorridor","Office"}},
	LeftCorridor1 = {Visible = {"MainArcade","RightCorridor","MainArcade1","DinnerRoom","LeftCorridor","LeftCorridor1","HiddenStorage","Kitchen","ArcadeCorridor","LeftStorage","Restroom","EntranceCorridor","Office"}},
	LeftStorage = {Visible = {"LeftStorage","LeftCorridor","DinnerRoom","MainArcade", "Office"}},
	MainArcade = {Visible = {"MainArcade","MainArcade1","DinnerRoom","LeftCorridor","HiddenStorage","Kitchen","Arcade","ArcadeCorridor","LeftStorage","Restroom","EntranceCorridor", "Office"}},
	MainArcade1 = {Visible = {"MainArcade","MainArcade1","DinnerRoom","LeftCorridor","Kitchen","Arcade","ArcadeCorridor","LeftStorage","Restroom","EntranceCorridor", "Office"}},
	Office = {Visible = {"Office","LeftCorridor","LeftCorridor1","RightCorridor"}},
	Restroom = {Visible = {"Entrance","EntranceCorridor","DinnerRoom","Kitchen","ArcadeCorridor","Restroom","LeftCorridor","RightCorridor","MainArcade","MainArcade1", "Office"}},
	RightStorage = {Visible = {"Storage","RightStorage","RightCorridor","DinnerRoom", "Office"}},
	RightCorridor = {Visible = {"Storage","RightCorridor","DinnerRoom","EntranceCorridor","Entrance","HiddenStorage","Office","LeftCorridor1","LeftCorridor","RightStorage","MainArcade","MainArcade1"}},
	Parking = {Visible = {}},
	Storage = {Visible = {"RightCorridor","HiddenStorage","LeftCorridor","Storage","RightStorage"}},
}

for k,v in Zones do
	local Zone = Map:WaitForChild(k)
	local ZonePart = Zone:FindFirstChild("ROOF")
	if ZonePart then
		local PartSize = ZonePart.Size
		local PartPos = ZonePart.Position
		local PartBound1 = PartPos + Vector3.new(PartSize.X, 0, PartSize.Z) *0.5
		local PartBound2 = PartPos - Vector3.new(PartSize.X, 0, PartSize.Z) *0.5
		v.X = PartBound1
		v.Z = PartBound2
	end
	
	v.Zone = Zone
	Zone.Parent = game.ReplicatedStorage
end


game:GetService("RunService").RenderStepped:Connect(function(delta)
	Update-=delta
	if Update <= 0 then
		Update += 0.25
		local CamPos = workspace.CurrentCamera.CFrame.Position
		ZoneVisible = {}
		
		for k,v in Zones do
			local Result = isVector3Between(CamPos, v.X, v.Z)
			--print(Result,k)
			
			for k2,v2 in v.Visible do
				if ZoneVisible[v2] ~= true then
					ZoneVisible[v2] = Result
				end
			end
		end
		for k,v in ZoneVisible do
			if v == true then
				Zones[k].Zone.Parent = Map
				task.wait()
			else
				Zones[k].Zone.Parent = game.ReplicatedStorage
				task.wait()
			end
			
		end
		
	end
end)
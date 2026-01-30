local Pathfinfing = game:GetService("PathfindingService")
local Players = game:GetService("Players")

local Parent = script.Parent
local Debug = require(game.ServerScriptService.Modules.DebugModule)
local RootPart = Parent.PrimaryPart
local Controller = Parent.ControllerManager :: ControllerManager

Parent.Head.ON:Play()

local Points = {}
local Waypoints = {}
local CurvePoints = {}

local agentParams = {
	AgentRadius = 1.3,
	AgentHeight = 4,
	AgentCanJump = false,
	WaypointSpacing = 2,
	Costs = { ThaCol = 1, NoCol = math.huge }
}
local Agent = Pathfinfing:CreatePath(agentParams)
local LastSeen = RootPart.Position
local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude
RayParams.FilterDescendantsInstances = {Parent, workspace:WaitForChild("Collisions").Seethrough}
RayParams.CollisionGroup = "Players"

local PathPoints = workspace.PathPoints:GetChildren()

local ActuPoint = 2
local IdleTime = 0
local ChoosenPath = nil
local Failed = 0
local IdleChoosen = 0
local LookPos = Vector3.zero
local IdleAnimation = false

local LastPlayerSeen = nil
local CurrentTurn = CFrame.new()

-- Attributs
local SlowWalkSpeed = Parent:GetAttribute("SlowWalkSpeed") or 6
local WalkSpeed = Parent:GetAttribute("WalkSpeed") or 7
local RunAddedSpeed = Parent:GetAttribute("RunAddedSpeed") or 7

local CurveEnticipation = Parent:GetAttribute("CurveEnticipation") or 6
local CurveSensitivity = Parent:GetAttribute("CurveSensitivity") or 8

local TurningEnticipation = Parent:GetAttribute("TurningEnticipation") or 15
local ReachTolerance = Parent:GetAttribute("ReachTolerance") or 2

local ViewDistance = Parent:GetAttribute("ViewDistance") or 40
local VisionCone = Parent:GetAttribute("VisionCone") or 80

local MaxTurnSpeed = Parent:GetAttribute("MaxTurnSpeed") or math.rad(80)

Parent:SetAttribute("Activated",true)

local IK = Parent:FindFirstChild("Iks"):FindFirstChild("IKControl")

local function CheckEye(w)
	local Search = w:FindFirstChild("Origin",true)
	if Search then
		local Light = Search:FindFirstChild("SpotLight")
		local Beam = Search:FindFirstChild("Beam")
		
		
		
		if Light and Beam then
			Search.Parent.Transparency = 0
			Light.Enabled = true
			Beam.Enabled = true
		end
	end
end
local Head = Parent:FindFirstChild("Head")
if Head then
	local LeftEye = Head:FindFirstChild("LeftEye")
	local RightEye = Head:FindFirstChild("RightEye")
	
	CheckEye(LeftEye)
	CheckEye(RightEye)
end

task.wait(2)

local function Stop()
	Points = {}
	Controller.MovingDirection = Vector3.zero
	ChoosenPath = nil
	Failed = 0
end

local function CurveStraightness(points: {Vector3}, sensitivity: number?): number
	sensitivity = sensitivity or 1
	if #points < 2 then return 1 end
	local totalLength = 0
	for i = 2, #points do totalLength += (points[i] - points[i - 1]).Magnitude end
	local straightDistance = (points[#points] - points[1]).Magnitude
	if totalLength == 0 then return 1 end
	local ratio = straightDistance / totalLength
	local straightness = ratio ^ sensitivity
	return math.clamp(straightness, 0, 1)
end

local function Compute(Pos)
	Agent:ComputeAsync(RootPart.Position, Pos)
	if Agent.Status ~= Enum.PathStatus.Success then Failed+= 1 return end
	if #Agent:GetWaypoints() <= 2 then Failed+= 1 return end
	Waypoints = Agent:GetWaypoints()
	Points = {}
	for _,v in Waypoints do table.insert(Points,v.Position) end
	CurvePoints = {}
	for i = 1,CurveEnticipation do
		if Points[i] then table.insert(CurvePoints,Points[i]) end
	end
	ActuPoint = 2
	Failed = 0
end

local Found = 2
local TargetedPlayer = {Player = nil,Position = Vector3.zero}
local ComputingPosition = RootPart.Position
local Computing = nil

local function LookAt(pos, Delta, Speed)
	CurrentTurn = CurrentTurn:Lerp(pos,Delta * Speed)
	game.ReplicatedStorage.Lookat:FireAllClients(Parent, CurrentTurn, TargetedPlayer.Player)
	
	IK.Offset = CurrentTurn
end

local function Update(Delta)
	IdleTime -= Delta
	IdleChoosen -= Delta
	Found -= Delta
	
	local AnimaHeadPos = Parent.Head.Position
	local Distance = 1000
	local NearestPlayer = {Distance = 1000,Player = nil,Position = Vector3.zero}

	for _,v in Players:GetPlayers() do
		if v.Character and v.Character.PrimaryPart and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v:GetAttribute("Invincible") ~= true then	
			local CharPos = v.Character.PrimaryPart.Position
			
			Distance = (CharPos - AnimaHeadPos).Magnitude
			if Distance>ViewDistance or Distance>NearestPlayer.Distance then continue end

			local CharAnimaLook = CFrame.lookAt(AnimaHeadPos,CharPos).LookVector
			if (CharAnimaLook - Head.CFrame.LookVector).Magnitude > VisionCone/90 then continue end
			
			local Raycast = workspace:Raycast(AnimaHeadPos,CharAnimaLook * (CharPos-AnimaHeadPos).Magnitude,RayParams)
			if not Raycast or not Raycast.Instance:IsDescendantOf(v.Character) then continue end

			NearestPlayer.Distance = Distance
			NearestPlayer.Position = CharPos
			NearestPlayer.Player = v
		end
	end
	
	if NearestPlayer.Player then
		if NearestPlayer.Player ~= TargetedPlayer.Player then
			game.ReplicatedStorage.Seen:FireClient(NearestPlayer.Player)
		end
		
		TargetedPlayer.Player = NearestPlayer.Player
		TargetedPlayer.Position = NearestPlayer.Position
		IdleTime = 7

		RootPart:SetNetworkOwner(NearestPlayer.Player)
	end
	
	if TargetedPlayer.Player then
		Computing = "Run"
		ComputingPosition = TargetedPlayer.Position
		LookPos = ComputingPosition
		
		if IdleTime <= 5 then
			TargetedPlayer.Player = nil
			Computing = "Idle"
		end
		
		if TargetedPlayer and TargetedPlayer.Player and TargetedPlayer.Player.Character and TargetedPlayer.Player.Character:FindFirstChild("Humanoid") then
			TargetedPlayer.Position = TargetedPlayer.Player.Character.PrimaryPart.Position

			local TargetPlayerDistance = (TargetedPlayer.Position - RootPart.Position).Magnitude
			if TargetPlayerDistance < 6 then
				game.ReplicatedStorage.Jumpscare:FireClient(TargetedPlayer.Player, Parent)
				Parent.Head.Scream.TimePosition = 0
				Parent.Head.Scream:Play()
				TargetedPlayer.Player.Character.Humanoid.Health = 0
				TargetedPlayer.Player = nil
				Computing = "Idle"
			end
		end
	elseif IdleTime <= 0 then
		if not ChoosenPath then
			Computing = "Nothing"
			ChoosenPath = PathPoints[math.random(1,#PathPoints)].Position
			IdleChoosen = 10
			ComputingPosition = ChoosenPath
		end
		
		if IdleChoosen<=8 then
			if IdleChoosen<= 6 then
				if IdleChoosen<= 1 then
					if IdleChoosen<= 0 then
						Computing = "Idle"
					else
						LookPos = Points[math.min(TurningEnticipation,#Points)]
					end
				else
					LookPos = (RootPart.CFrame * CFrame.Angles(0, math.rad(-60),0) * CFrame.new(0,0,-100)).Position
				end
			else
				LookPos = (RootPart.CFrame * CFrame.Angles(0, math.rad(60),0) * CFrame.new(0,0,-100)).Position
			end
		end
	end
	
	if Computing then
		Compute(ComputingPosition)
	end
	
	if Failed >= 100 then Stop() end
	if #Points <= 2 then return end

	if ((Points[ActuPoint] - RootPart.Position) * Vector3.new(1,0,1)).Magnitude < ReachTolerance then
		ActuPoint += 1
		if ActuPoint >= #Points then Stop() return end
	end

	local Straightness = CurveStraightness(CurvePoints, CurveSensitivity)
	if Computing == "Run" then
		Controller.BaseTurnSpeed = 2
		Controller.BaseMoveSpeed = WalkSpeed + Straightness * RunAddedSpeed
		
		LookAt(CFrame.lookAt(Parent.Head.Position,LookPos).Rotation, Delta, 3.8)
	elseif Computing == "Idle" then
		Controller.BaseTurnSpeed = 2
		Controller.BaseMoveSpeed = SlowWalkSpeed + Straightness
		
		LookAt(CFrame.lookAt(Parent.Head.Position,Points[math.min(TurningEnticipation,#Points)]).Rotation, Delta, 1.5)
	elseif Computing == "Nothing" then
		Controller.BaseTurnSpeed = 0
		Controller.BaseMoveSpeed = 0
		
		LookAt(CFrame.lookAt(Parent.Head.Position,LookPos).Rotation, Delta, .9)
	end
	Controller.FacingDirection = ((Points[math.min(TurningEnticipation,#Points)] - RootPart.Position) * Vector3.new(1,0,1)).Unit
	Controller.MovingDirection = ((Points[ActuPoint] - RootPart.Position) * Vector3.new(1,0,1)).Unit
end

game:GetService("RunService").Heartbeat:Connect(Update)

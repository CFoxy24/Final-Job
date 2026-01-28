local function Ra(a,b) return math.random(a,b) end

local xOffset = Ra(-100000, 100000)
local yOffset = Ra(-100000, 100000)
local zOffset = Ra(-100000, 100000)
local Offset = 5
local Freq = 0.5
local Amp = 200
local Seed = Ra(-100000, 100000)
local Scale = 300
local XMax,YMax,ZMax = 35000,220,2000

local AsteLocate = game.ReplicatedStorage.Asteroids
local AsteFolder = Instance.new("Folder")
AsteFolder.Parent = workspace.GameMap
AsteFolder.Name = "Asteroids"

local Location = CFrame.Angles(math.rad(Ra(0,360)),math.rad(Ra(0,360)),math.rad(Ra(0,360)))
--local Location = CFrame.new()

local Asteroids = {
	["Ader"] = 3,
	["Empty"] = 1000,
	["Bodarn"] = 8,
	["Cobalt"] = 10,
	["Copper"] = 100,
	["Gold"] = 5,
	["Volutium"] = 2
}

local LostGroupsColors = {Color3.fromRGB(103, 95, 168),Color3.fromRGB(157, 84, 98),Color3.fromRGB(104, 76, 21),Color3.fromRGB(232, 232, 232)}

local function GetAsteroidName(tablee)
	local total = 0
	for key, value in pairs(tablee or Asteroids) do
		total += value
	end
	local choosen = math.random(1,total)
	local total2 = 0
	for key, value in pairs(tablee or Asteroids) do
		total2 += value
		if total2 >= choosen and total2 < choosen+total2 then
			return key
		end
	end
end

local Materials = {Enum.Material.Cobblestone,Enum.Material.Basalt,Enum.Material.Ground,Enum.Material.Ice,Enum.Material.Limestone,Enum.Material.Mud,Enum.Material.Salt,Enum.Material.Sandstone,Enum.Material.Slate,Enum.Material.Sand}

local Contains = {
	["BaseGroup"] = {true,Ra(200,240)},
	["LostGroup"] = {true,Ra(70,90)},
	["Lost"] = {true,Ra(2500,3000)},
	["Worms"] = {true,Ra(140,160)},
	["Filons"] = {true,750},
	["Bigs"] = {true,Ra(120,140)},
	["Dust"] = {true,Ra(1300,1500)},
	["Stations"] = {true,Ra(0,100)},
	["Wrecks"] = {false,Ra(0,80)}
}

local Filons = nil
if Contains["Filons"][1] == true then
	Filons = Instance.new("Folder")
	Filons.Parent = AsteFolder
	Filons.Name = "Filons"
end

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

local ChangedTable1 = shallowCopy(Asteroids)
ChangedTable1["Empty"] = 0

local BGIntMin = 400
local BGIntMax = 800
if Contains["BaseGroup"][1] == true then
	local BaseGroup = Instance.new("Folder")
	BaseGroup.Parent = AsteFolder
	BaseGroup.Name = "BaseGroup"
	for i = 1,Contains["BaseGroup"][2] do
		local Position = Vector3.new(Ra(-XMax,XMax),Ra(-YMax,YMax),Ra(-ZMax,ZMax))
		local Intensity = Ra(20,110)
		for i = 1,Intensity/1.4 do
			local Offset = Position + Vector3.new(Ra(-Intensity*(Ra(BGIntMin,BGIntMax)/100),Intensity*(Ra(BGIntMin,BGIntMax)/100)),Ra(-Intensity*(Ra(BGIntMin,BGIntMax)/100),Intensity*(Ra(BGIntMin,BGIntMax)/100)),Ra(-Intensity*(Ra(BGIntMin,BGIntMax)/100),Intensity*(Ra(BGIntMin,BGIntMax)/100)))
			local xP = math.noise(((Offset.X + xOffset) / Scale) * Freq , ((Offset.X + xOffset) / Scale) * Freq) * Amp
			local yP = math.noise(((Offset.Y + yOffset) / Scale) * Freq , ((Offset.Y + yOffset) / Scale) * Freq) * Amp
			local zP = math.noise(((Offset.Z + zOffset) / Scale) * Freq , ((Offset.Z + zOffset) / Scale) * Freq) * Amp
			
			local CatName = GetAsteroidName()
			local Category = AsteLocate:FindFirstChild(CatName):GetChildren()
			local New = Category[math.random(1,#Category)]:Clone()
			New.Parent = BaseGroup
			local Size = Ra(4,17)
			local SizeOffset = Vector3.new(Ra(-3,3),Ra(-3,3),Ra(-3,3))
			local All = New:GetChildren()
			for Current = 1,#All do
				if All[Current]:IsA("BasePart") then
					All[Current].Size += Vector3.new(Size,Size,Size)+Vector3.new((Vector3.new(xP,yP,zP).Magnitude/100),(Vector3.new(xP,yP,zP).Magnitude/100),(Vector3.new(xP,yP,zP).Magnitude/100)) + SizeOffset
				end
			end	
			New:SetPrimaryPartCFrame(Location * CFrame.new(Offset + Vector3.new(xP,yP,zP)) * CFrame.Angles(math.rad(Ra(0,360)),math.rad(Ra(0,360)),math.rad(Ra(0,360))))
			local Color = Color3.fromRGB(255-math.random(0,11),255-math.random(0,22),255-math.random(0,8))
			local Darkify = math.random(20,100)/100
			New.PrimaryPart.Color = Color3.new(Color.R*Darkify,Color.G*Darkify,Color.B*Darkify)
			New.PrimaryPart.Material = Materials[math.random(1,#Materials)]
			New.Name = CatName
			if Contains["Filons"][1] == true then
				local CatName = GetAsteroidName(ChangedTable1)
				local Category = AsteLocate:FindFirstChild(CatName):GetChildren()
				local Filon = Ra(0,Contains["Filons"][2])
				if Filon == 0 then
					for i = 1,Ra(3,6) do
						local Branch = CFrame.Angles(math.rad(Ra(0,360)),math.rad(Ra(0,360)),math.rad(Ra(0,360)))
						for f = 1,8 do
							local New = Category[math.random(1,#Category)]:Clone()
							New.Parent = Filons
							local Size = Ra(7,12)
							local All = New:GetChildren()
							for Current = 1,#All do
								if All[Current]:IsA("BasePart") then
									All[Current].Size += Vector3.new(Size,Size,Size)+Vector3.new((Vector3.new(xP,yP,zP).Magnitude/80),(Vector3.new(xP,yP,zP).Magnitude/80),(Vector3.new(xP,yP,zP).Magnitude/80))
								end
							end	
							New:SetPrimaryPartCFrame(Location * CFrame.new(Offset + Vector3.new(xP,yP,zP)) * Branch * CFrame.new(0,0,f*10) * CFrame.new(Ra(-15,15),Ra(-15,15),Ra(-15,15)) * CFrame.Angles(math.rad(Ra(0,360)),math.rad(Ra(0,360)),math.rad(Ra(0,360))))
							local Color = Color3.fromRGB(255-math.random(0,20),255-math.random(0,15),255)
							local Darkify = math.random(30,80)/100
							New.PrimaryPart.Color = Color3.new(Color.R*Darkify,Color.G*Darkify,Color.B*Darkify)
							New.PrimaryPart.Material = Materials[math.random(1,#Materials)]
							New.Name = CatName
						end
					end
				end
			end
		end
	end
end

if Contains["LostGroup"][1] == true then
	local LostGroup = Instance.new("Folder")
	LostGroup.Parent = AsteFolder
	LostGroup.Name = "LostGroup"
	for i = 1,Contains["LostGroup"][2] do
		local Position = Vector3.new(Ra(-XMax*2.6,XMax*2.6),Ra(-YMax*2.6,YMax*2.6),Ra(-ZMax*2.6,ZMax*2.6))
		local Intensity = Ra(18,60)
		local Color = LostGroupsColors[math.random(1,#LostGroupsColors)]
		for i = 1,Intensity do
			local Offset = Position + Vector3.new(Ra(-Intensity*(Ra(40,65)/10),Intensity*(Ra(40,65)/10)),Ra(-Intensity*(Ra(40,65)/10),Intensity*(Ra(40,65)/10)),Ra(-Intensity*(Ra(40,65)/10),Intensity*(Ra(40,65)/10)))
			local xP = math.noise(((Offset.X + xOffset) / Scale) * Freq , ((Offset.X + xOffset) / Scale) * Freq) * Amp
			local yP = math.noise(((Offset.Y + yOffset) / Scale) * Freq , ((Offset.Y + yOffset) / Scale) * Freq) * Amp
			local zP = math.noise(((Offset.Z + zOffset) / Scale) * Freq , ((Offset.Z + zOffset) / Scale) * Freq) * Amp
			
			local CatName = GetAsteroidName()
			local Category = AsteLocate:FindFirstChild(CatName):GetChildren()
			local New = Category[math.random(1,#Category)]:Clone()
			New.Parent = LostGroup
			local Size = Ra(4,18)
			local All = New:GetChildren()
			for Current = 1,#All do
				if All[Current]:IsA("BasePart") then
					All[Current].Size += Vector3.new(Size,Size,Size)*((Vector3.new(xP,yP,zP).Magnitude/Amp)*2)
				end
			end
			New:SetPrimaryPartCFrame(Location * CFrame.new(Offset + Vector3.new(xP,yP,zP)) * CFrame.Angles(math.rad(Ra(0,360)),math.rad(Ra(0,360)),math.rad(Ra(0,360))))
			local Darkify = math.random(70,100)/100
			New.PrimaryPart.Color = Color3.new(Color.R*Darkify,Color.G*Darkify,Color.B*Darkify)
			New.PrimaryPart.Material = Materials[math.random(1,#Materials)]
			New.Name = CatName
		end
	end
end

if Contains["Lost"][1] == true then
	local Lost = Instance.new("Folder")
	Lost.Parent = AsteFolder
	Lost.Name = "Lost"
	for i = 1,Contains["Lost"][2] do
		local CatName = GetAsteroidName()
		local Category = AsteLocate:FindFirstChild(CatName):GetChildren()
		local New = Category[math.random(1,#Category)]:Clone()
		New.Parent = Lost
		local Size = Ra(8,16)
		local All = New:GetChildren()
		for Current = 1,#All do
			if All[Current]:IsA("BasePart") then
				All[Current].Size += Vector3.new(Size,Size,Size)+Vector3.new(Ra(-2,2),Ra(-2,2),Ra(-2,2))
			end
		end
		New:SetPrimaryPartCFrame(Location * CFrame.new(Ra(-XMax*1.3,XMax*1.3),Ra(-YMax*1.3,YMax*1.3),Ra(-ZMax*1.3,ZMax*1.3)) * CFrame.Angles(math.rad(Ra(0,360)),math.rad(Ra(0,360)),math.rad(Ra(0,360))))
		local Color = Color3.fromRGB(255-math.random(0,20),255-math.random(0,15),255)
		local Darkify = math.random(50,90)/100
		New.PrimaryPart.Color = Color3.new(Color.R*Darkify,Color.G*Darkify,Color.B*Darkify)
		New.PrimaryPart.Material = Materials[math.random(1,#Materials)]
		New.Name = CatName
	end
end

if Contains["Bigs"][1] == true then
	local Bigs = Instance.new("Folder")
	Bigs.Parent = AsteFolder
	Bigs.Name = "Bigs"
	for i = 1,Contains["Bigs"][2] do
		local Position = Vector3.new(Ra(-XMax*1.7,XMax*1.7),Ra(-YMax*1.7,YMax*1.7),Ra(-ZMax*1.7,ZMax*1.7))
		for i = 1,Ra(4,9) do
			local Category = AsteLocate.EmptyBig:GetChildren()
			local New = Category[math.random(1,#Category)]:Clone()
			New.Parent = Bigs
			local Size = Ra(90,160)
			local All = New:GetChildren()
			for Current = 1,#All do
				if All[Current]:IsA("BasePart") then
					All[Current].Size += Vector3.new(Size,Size,Size) + Vector3.new(Ra(-6,6),Ra(-6,6),Ra(-6,6))
				end
			end
			New:SetPrimaryPartCFrame(Location * CFrame.new(Position) * CFrame.new(Ra(-270,270),Ra(-270,270),Ra(-270,270)) * CFrame.Angles(math.rad(Ra(0,360)),math.rad(Ra(0,360)),math.rad(Ra(0,360))))
			local Color = Color3.fromRGB(255,255,255)
			local Darkify = math.random(80,100)/100
			New.PrimaryPart.Color = Color3.new(Color.R*Darkify,Color.G*Darkify,Color.B*Darkify)
			New.Name = "Asteroid Dust"
		end
	end
end

local ChangedTable2 = shallowCopy(Asteroids)
ChangedTable2["Empty"] *= 10

if Contains["Worms"][1] == true then
	local Bigs = Instance.new("Folder")
	Bigs.Parent = AsteFolder
	Bigs.Name = "Worms"
	for i = 1,Contains["Worms"][2] do
		local Start = Vector3.new(Ra(-XMax*3,XMax*3),Ra(-YMax*4,YMax*4),Ra(-ZMax,ZMax))
		local CurrentPos = Start
		local Material = Materials[math.random(1,#Materials)]
		local Color = Color3.fromRGB(255-math.random(0,35),255-math.random(0,25),255)
		
		for i = 1,Ra(18,30) do
			local XIn = math.noise(CurrentPos.Y/300,CurrentPos.Z/300,Seed)
			local YIn = math.noise(CurrentPos.X/300,CurrentPos.Z/300,Seed)
			local ZIn = math.noise(CurrentPos.X/300,CurrentPos.Y/300,Seed)
			CurrentPos += Vector3.new(XIn*380,YIn*380,ZIn*380)
			for i = 1,Ra(7,9) do
				local CatName = GetAsteroidName(ChangedTable2)
				local Category = AsteLocate:FindFirstChild(CatName):GetChildren()
				local New = Category[math.random(1,#Category)]:Clone()
				New.Parent = Bigs
				local Size = Ra(7,10)
				local SizeOffset = Vector3.new(Ra(-3,3),Ra(-3,3),Ra(-3,3))
				local All = New:GetChildren()
				for Current = 1,#All do
					if All[Current]:IsA("BasePart") then
						All[Current].Size += Vector3.new(Size,Size,Size) + Vector3.new(Ra(-3,3),Ra(-3,3),Ra(-3,3))
					end
				end
				New:SetPrimaryPartCFrame(Location * CFrame.new(CurrentPos+Vector3.new(Ra(-65,65),Ra(-65,65),Ra(-65,65))))
				
				local Darkify = math.random(50,80)/100
				New.PrimaryPart.Color = Color3.new(Color.R*Darkify,Color.G*Darkify,Color.B*Darkify)
				New.PrimaryPart.Material = Material
				New.Name = CatName
			end
		end
	end
end

if Contains["Dust"][1] == true then
	local Dust = Instance.new("Folder")
	Dust.Parent = AsteFolder
	Dust.Name = "Dust"
	local Off = 1200
	for i = 1,Contains["Dust"][2] do
		local New = Instance.new("Part")
		New.Parent = Dust
		New.Anchored = true
		New.Transparency = 1
		New.CanCollide = false
		New.CanTouch = false
		New.CanQuery = false
		New.CFrame = Location * CFrame.new(Ra(-XMax*1.1,XMax*1.1),Ra(-YMax*1.1,YMax*1.1),Ra(-ZMax*1.1,ZMax*1.1))* CFrame.new(Ra(-Off,Off),Ra(-Off,Off),Ra(-Off,Off))
		local NewDust = AsteLocate.Dust:Clone()
		NewDust.Parent = New
		NewDust.ImageLabel.Rotation = Ra(0,360)
	end
end
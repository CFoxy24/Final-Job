local Folder = workspace:WaitForChild("Animatronics")
local Replicated = game:GetService("ReplicatedStorage")
local Animatronics = {}
local CurrentPlayer = 0
local LocalPlayer = game.Players.LocalPlayer
local max = math.rad(30)
local InJumpsace = false
local TW = game:GetService("TweenService")
local Noise = 0
local SeenBuffer = true

local function NewChild(Model)
	local AnimaTable = {}
	AnimaTable.Model = Model
	AnimaTable.Root = Model:WaitForChild("LowerTorso")
	AnimaTable.LookPos = Vector3.zero
	AnimaTable.EyesCool = 0
	AnimaTable.EyeLook = CFrame.new()
	AnimaTable.Cool = 0
	
	local Params = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Exclude
	Params.IgnoreWater = false
	Params.RespectCanCollide = true
	Params.FilterDescendantsInstances = {Model}
	AnimaTable.RayParams = Params
	
	local NS = script:WaitForChild("TT"):Clone()
	NS.Parent = AnimaTable.Root
	
	local Iks = Model:FindFirstChild("Iks")
	if Iks then
		AnimaTable.IK = Iks:WaitForChild("IKControl")
	end
	
	local Head = Model:WaitForChild("Head")

	if Head then
		AnimaTable.Head = Head
		
		local LeftEye = Head:FindFirstChild("LeftEye")
		local Jaw = Head:FindFirstChild("Jaw")
		local RightEye = Head:FindFirstChild("RightEye")
		
		if LeftEye then
			AnimaTable.LeftEye =  LeftEye:FindFirstChild("Main")
		end
		if RightEye then
			AnimaTable.RightEye =  RightEye:FindFirstChild("Main")
		end
		if Jaw then
			AnimaTable.Jaw =  Jaw:FindFirstChild("Main")
		end
	end

	Animatronics[Model.Name] = AnimaTable
end

game.ReplicatedStorage.Jumpscare.OnClientEvent:Connect(function(Model)
	local Anima = Animatronics[Model.Name]
	if Anima and Anima.Head and Anima.Jaw and not InJumpsace then
		InJumpsace = true

		local AT = Instance.new("Attachment")
		AT.Parent = workspace
		local light = Instance.new("PointLight")
		light.Parent = AT
		light.Shadows = false

		AT.WorldCFrame = workspace.CurrentCamera.CFrame

		game.Players.LocalPlayer:SetAttribute("InCameras",true)
		game.Players.LocalPlayer:SetAttribute("InJumpscare",true)

		local CFRV = Instance.new("CFrameValue")
		CFRV.Value = CFrame.new(0,-1.3,3)

		local Connect = game:GetService("RunService").RenderStepped:Connect(function(delta)
			Noise+=delta*80

			Anima.Jaw.C0 = CFrame.Angles(math.cos(Noise*.3)*.3,0,0)
			AT.WorldCFrame = Anima.Head.CFrame * CFrame.Angles(0,math.rad(180),0) * CFrame.new(0,0,3.5)

			workspace.CurrentCamera.CFrame = Anima.Head.CFrame * CFrame.Angles(0,math.rad(180),0) * CFRV.Value
				*CFrame.Angles(math.noise(Noise)*.02,math.noise(0,Noise*.05)*.2,math.noise(0,0,Noise*.18)*.18)
		end)


		TW:Create(CFRV, TweenInfo.new(.4,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Value = CFrame.new(0,-.45,2.5)}):Play()
		task.wait(.6)

		TW:Create(CFRV, TweenInfo.new(1.5,Enum.EasingStyle.Exponential,Enum.EasingDirection.In),{Value = CFrame.new(0,-.45,.3) * CFrame.Angles(math.rad(20),0,0)}):Play()
		task.wait(1.5)

		local Screen = game.Players.LocalPlayer.PlayerGui.DiedScreen
		Screen.Enabled = true
		TW:Create(Screen.Frame, TweenInfo.new(1,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out),{BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
		script.Parent.Spectator.Enabled = false
		
		task.wait(1)
		Connect:Disconnect()

		AT:Destroy()

		script.Parent.Spectator.Enabled = true
		Screen.Enabled = false
		InJumpsace = false
	end
end)

local function Search(AllSounds)
	CurrentPlayer+=1
	local Choosen = AllSounds[CurrentPlayer % #AllSounds + 1]
	Choosen.TimePosition = 0
	Choosen.PlaybackSpeed = Choosen:GetAttribute("PB") + math.random(-3,3)/100
	Choosen.TimePosition = Choosen.PlaybackRegion.Min
	Choosen:Play()
end

local function LookAyy(weld,base)
	local lookCFrame = base.CFrame:ToObjectSpace(CFrame.lookAt(base.Position, workspace.CurrentCamera.CFrame.Position)).Rotation:Inverse()
	
	local x, y, z = lookCFrame:ToOrientation()
	return CFrame.fromOrientation(math.max(-max, math.min(max, x)), math.max(-max, math.min(max, y)), z)
end

Replicated:WaitForChild("Lookat").OnClientEvent:Connect(function(Model,Pos,Player)
	local Anima = Animatronics[Model.Name]
	if Anima.Model ~= Model or Anima.IK == nil then return end
	Anima.IK.Offset = Pos
	if Player == LocalPlayer then
		local Angle = CFrame.lookAt(Anima.Head.Position,workspace.CurrentCamera.CFrame.Position).Rotation
		Anima.EyesCool = 2
		Anima.EyeLook = LookAyy(Anima.LeftEye,Anima.Head)
	end
end)

Replicated:WaitForChild("Seen").OnClientEvent:Connect(function()
	if SeenBuffer == true then
		SeenBuffer = false
		script.Hit:Play()
		task.wait(10)
		SeenBuffer = true
	end
end)

game:GetService("RunService").RenderStepped:Connect(function(Delta)
	for _,Anima in Animatronics do
		if Anima.Model:GetAttribute("Activated") == true then
			if Anima.LeftEye and Anima.RightEye then
				Anima.EyesCool-=Delta
				if Anima.EyesCool<=0 then
					Anima.EyeLook = CFrame.Angles(math.rad(math.random(-14,14)),math.rad(math.random(-14,14)),0)
					Anima.EyesCool += math.random(20,500)/100
				end
				Anima.LeftEye.C0 = Anima.LeftEye.C0:Lerp(Anima.EyeLook,Delta*25)
				Anima.RightEye.C0 = Anima.RightEye.C0:Lerp(Anima.EyeLook,Delta*25)
			end

			Anima.Cool-=Delta*Anima.Root.Velocity.Magnitude*.8
			if Anima.Cool<=0 then
				Anima.Cool+=2.5

				Search(Anima.Root.TT.Sounds:GetChildren())
				Search(Anima.Root.TT.Sounds3:GetChildren())
			end
		end
	end
end)

Folder.ChildAdded:Connect(NewChild)
for _,v in Folder:GetChildren() do NewChild(v) end
local TW = game:GetService("TweenService")
local Char = script.Parent
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

local DeltaTime = 0

local InLocker = false
local Offset = CFrame.new()
local Sanity = 0

local FOV = 0
local NextBeat = 0
local BeatState = true

local Gui = Player.PlayerGui:WaitForChild("Vignette")
local Vignette = Gui:WaitForChild("ImageLabel")
local Test = Gui:WaitForChild("Test")

local GModel = nil
local GWeld = nil
local StartPos = CFrame.new()
local StartCFR = CFrame.new()

local LockerEvent = game.ReplicatedStorage:WaitForChild("Locker")

local function LeaveLocker()
	InLocker = false
	
	LockerEvent:FireServer()
	
	TW:Create(GWeld,TweenInfo.new(.6,Enum.EasingStyle.Bounce,Enum.EasingDirection.Out),{C0 = CFrame.Angles(0,-math.rad(120),0)}):Play()
	GModel:FindFirstChild("Locker1"):Play()
	task.wait(.2)

	TW:Create(Char.PrimaryPart,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{CFrame = StartPos}):Play()
	TW:Create(Camera,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{CFrame = StartCFR}):Play()

	TW:Create(Vignette,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{ImageTransparency = .99}):Play()
	task.wait(.4)
	GModel:FindFirstChild("Locker2"):Play()
	TW:Create(GWeld,TweenInfo.new(.5,Enum.EasingStyle.Bounce,Enum.EasingDirection.Out),{C0 = CFrame.Angles(0,0,0)}):Play()
	task.wait(.2)
	Char.PrimaryPart.Anchored = false
	Player:SetAttribute("InCameras",false)
	Camera.CameraType = Enum.CameraType.Custom
	Test.Visible = false
end

LockerEvent.OnClientEvent:Connect(function(Model,En)
	if Model then
		local Weld = Model:FindFirstChild("MainWeld")
		if Weld then
			Sanity = 0
			
			GModel = Model
			GWeld = Weld
			
			StartPos = Char.PrimaryPart.CFrame
			Char.PrimaryPart.Anchored = true
			TW:Create(Weld,TweenInfo.new(.6,Enum.EasingStyle.Bounce,Enum.EasingDirection.Out),{C0 = CFrame.Angles(0,-math.rad(120),0)}):Play()
			Vignette.Visible = true
			
			Model:FindFirstChild("Locker1"):Play()
			task.wait(.2)
			
			StartCFR = Camera.CFrame
			Player:SetAttribute("InCameras",true)
			Camera.CameraType = Enum.CameraType.Scriptable
			
			Offset = Model:FindFirstChild("Camera",true).WorldCFrame
			TW:Create(Char.PrimaryPart,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{CFrame = Model:FindFirstChild("Char",true).CFrame * CFrame.new(0,0,-2) * CFrame.Angles(0,math.rad(180),0)}):Play()
			TW:Create(Camera,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{CFrame = Offset}):Play()

			TW:Create(Vignette,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{ImageTransparency = .5}):Play()
			task.wait(.4)
			Model:FindFirstChild("Locker2"):Play()
			TW:Create(Weld,TweenInfo.new(.5,Enum.EasingStyle.Bounce,Enum.EasingDirection.Out),{C0 = CFrame.Angles(0,0,0)}):Play()
			task.wait(.8)
			Test.Visible = true
			InLocker = true
		end
	end
end)


local clickReset = false
Test.Click.MouseButton1Click:Connect(function()
	if clickReset then
		clickReset = false
		local result = (.5-NextBeat)*.4
		Sanity-=result
		if math.sign(result) >=0 then
			Test.Click.BackgroundColor3 = Color3.fromRGB(13, 255, 0)
		else
			Test.Click.BackgroundColor3 = Color3.fromRGB(255,0,0)
		end
		Test.Click.Active = false
		print("clicj")
	end
end)

game:GetService("RunService").RenderStepped:Connect(function(delta)
	DeltaTime += delta
	FOV = math.clamp(FOV - DeltaTime,0,10)
	if InLocker then
		Sanity = math.clamp(Sanity + delta*.2,0,1)
		
		NextBeat-=delta * (1+Sanity)
		
		if BeatState then
			Test.Click.BackgroundTransparency = NextBeat

			if NextBeat<= .5 then
				Test.Click.Text = "CLICK"
			else
				Test.Click.Text = "Wait..."
			end
			
		else
			
		end
		
		if NextBeat<=0 then
			BeatState = not BeatState
			if BeatState then
				NextBeat += 1
				clickReset = true
				Test.Click.Active = true
				Test.Click.BackgroundColor3 = Color3.fromRGB(214, 214, 214)
				script.Thump2:Play()
			else
				NextBeat += .3
				Test.Click.BackgroundTransparency = 1
				script.Thump1:Play()
			end
		end
		
		print(Sanity)
		
		local VibrationMove = CFrame.new(math.noise(DeltaTime* 15)*.005 * Sanity,math.noise(0,DeltaTime* 15)*.005 * Sanity,math.noise(0,0,DeltaTime* 15)*.005 * Sanity)
		local VibrationRotate = CFrame.Angles(math.rad(math.noise(DeltaTime* 12)*.2 * Sanity),math.rad(math.noise(0,DeltaTime* 12)*.2 * Sanity),math.rad(math.noise(0,0,DeltaTime* 12)*.2 * Sanity))
		
		local BreathingMove = CFrame.new(0,math.cos(DeltaTime * (1+Sanity*.1))*.06 * Sanity,0)
		local BreathingRotate = CFrame.Angles(math.rad(math.sin(DeltaTime* (1+Sanity*.1))*2) * Sanity,0,0)
		
		Camera.CFrame = Offset * BreathingMove * BreathingMove * BreathingRotate * VibrationRotate
		Vignette.ImageTransparency = .5-Sanity*.5
		
		if Sanity >= 1 then
			LeaveLocker()
		end
	end
end)
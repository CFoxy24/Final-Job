local Lights = {}
local NextThunder = 0
local IsStarted = false

local CamAT = script:WaitForChild("CameraPos")
CamAT.Parent = workspace
CamAT.Ambiance.Emitter.Effects:Play()
CamAT.Rain.Emitter.AudioPlayer:Play()

local LightColor = {R=200, G=175, B=52}
local LowSanity = false

local SpecialLights = {}
local Beams = {}

local Thunder = CamAT.Thunder.Emitter.AudioPlayer
local ThunderSounds = {"9126100090","236328715","6201159919","18161875207","131300621","7768751498","6409267922","7768747890","4961240438"}
local TW = game:GetService("TweenService")

local function NewChild(child)
	if child.Name == "LightTp" then
		table.insert(Lights, child)
		local NS = script.AudioEmitter:Clone()
		NS.Parent = child
	else
		if child:HasTag("SpecialLight") then
			if child:IsA("Beam") or child:IsA("SurfaceGui") or child:IsA("Light") then
				table.insert(Beams, child)
				child.Enabled = false
			elseif child:IsA("BasePart") then
				table.insert(SpecialLights, {child.Color:ToHex(), child})
				child.Color = Color3.fromRGB(0,0,0)
			end
		end
	end
end

local function ChangeLightState(Light,Info,Value,LightColorE)
	if not LightColorE then LightColorE = LightColor end
	local ColorE = Color3.fromRGB(LightColorE.R,LightColorE.G,LightColorE.B)
	TW:Create(Light,Info,{Color = Color3.fromRGB(LightColorE.R * Value, LightColorE.G * Value, LightColorE.B * Value)}):Play()
	local BeamTW =TW:Create(Light.Main.Beam,Info,{Brightness = Value})
	local BeamConnect = game:GetService("RunService").RenderStepped:Connect(function()
		Light.Main.Beam.Color = ColorSequence.new(Light.Color)
	end)
	BeamTW.Completed:Connect(function()
		BeamConnect:Disconnect()
	end)
	
	TW:Create(Light.Main.Spot,Info,{Brightness = Value * 1.8, Color = ColorE}):Play()
	TW:Create(Light.Main.Mid.Point,Info,{Brightness = Value * 0.16, Color = ColorE}):Play()
end

local function Blink(Light,Intensity,ColorE)
	if IsStarted then
		ChangeLightState(Light,TweenInfo.new(.01,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),Intensity, ColorE)

		if Light.AudioEmitter.AudioPlayer.IsReady then
			Light.AudioEmitter.AudioPlayer:Stop()
			Light.AudioEmitter.AudioPlayer.Volume = math.random((1-Intensity)*90,(1-Intensity)*190)/100
			Light.AudioEmitter.AudioPlayer.TimePosition = 0
			Light.AudioEmitter.AudioPlayer.PlaybackSpeed = math.random(80,120)/100
			Light.AudioEmitter.AudioPlayer:Play()
		end

		task.wait(math.random(0,40)/250)

		ChangeLightState(Light,TweenInfo.new(math.random(0,100)/200,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),1, ColorE)
	else
		ChangeLightState(Light,TweenInfo.new(.01,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),0, ColorE)
	end
end

game.ReplicatedStorage.Finished.OnClientEvent:Connect(function()
	script.DOOR:Play()
	script.FNAF:Play()
	script.GUI.Parent = game.Players.LocalPlayer.PlayerGui
	task.wait(9)
	game:GetService("TeleportService"):Teleport(106212702976912,game.Players.LocalPlayer)
end)

workspace:GetAttributeChangedSignal("IsStarted"):Connect(function()
	IsStarted = workspace:GetAttribute("IsStarted")
	
	local a = workspace:FindFirstChild("BreakerBYU",true)
	a.BREAK:Play()
	a.ColorB.Value.Color = Color3.fromRGB(0,255,0)
	a.ColorB.Value.PointLight.Color = Color3.fromRGB(0,255,0)
	TW:Create(a.Lever.Value,TweenInfo.new(.7,Enum.EasingStyle.Bounce,Enum.EasingDirection.Out),{CFrame = CFrame.new(-10.45, -4, -101) * CFrame.Angles(math.rad(145),0,0)}):Play()
	
	if IsStarted then
		for k,v in Lights do
			task.spawn(function()
				for i = 1,math.random(1,7) do
					Blink(v,0)
					task.wait(math.random(0,100)/400)
				end
			end)
		end
		
		for k,v in SpecialLights do
			task.spawn(function()
				v[2].Color = Color3.fromHex(v[1])
			end)
		end
		for k,v in Beams do
			v.Enabled = true
		end
		
	end
end)

game:GetService("RunService").RenderStepped:Connect(function(DeltaTime)
	NextThunder-=DeltaTime
	
	CamAT.Position = workspace.CurrentCamera.CFrame.Position
	
	if NextThunder <= 0 then
		NextThunder = math.random(50,60)
		
		CamAT.Thunder.Position = Vector3.new(math.random(-100,100),math.random(-100,100),math.random(-100,100)).Unit*.3
		Thunder.Asset = "rbxassetid://" .. ThunderSounds[math.random(1,#ThunderSounds)] 
		Thunder:Play()
		
		local Intensity = (math.random(0,70)/100)
		
		for k,v in Lights do
			task.spawn(function()
				for i = 1,math.random(1,7) do
					Blink(v,Intensity)
					task.wait(math.random(0,100)/400)
				end
			end)
		end
	end
end)

for k,v in game:GetDescendants() do
	NewChild(v)
end

game.DescendantAdded:Connect(function(v)
	NewChild(v)
end)

local roll = math.random(1, 100)
if roll == 1 then
	task.wait(math.random(60,60*6))
	for k,v in Lights do
		task.spawn(function()
			task.wait(math.random(0,300)/100)
			for i = 1, 20 do
				local Intensity = math.random(0,60)/100
				Blink(v,Intensity,{R=255, G=0, B=0})
				task.wait(math.random(20,70)/100)
			end
		Blink(v,0)
		end)
	end
end
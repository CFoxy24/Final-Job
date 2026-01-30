--PUT THIS SCRIPT IN STARTERPACK, STOP DISLIKING IT BECAUSE YOU DIDN'T USE IT RIGHT

local sounds = game:GetService('SoundService')
local runtime = game:GetService('RunService')
local plr = game.Players.LocalPlayer
repeat wait() until plr.Character
local char = plr.Character
local hrp = char.HumanoidRootPart
local hum = char.Humanoid
local walking

hum.Running:connect(function(speed)
	if speed > hum.WalkSpeed/2 then
		walking = true
	else
		walking = false
	end
end)

function getMaterial()
	local floormat = hum.FloorMaterial
	if not floormat then floormat = 'Air' end
	local matstring = string.split(tostring(floormat),'Enum.Material.')[2]
	local material = matstring
	return material
end

local Emitter = script.AudioEmitter
Emitter.Parent = hrp


local Sounds = {Concrete = "rbxassetid://6362185620", Fabric = "rbxassetid://9083849830"}

local curmat = {nil,nil}
runtime.Heartbeat:connect(function()
	if walking then
		local mat = getMaterial()
		
		if curmat[2] ~= mat then
			if curmat[1] then
				curmat[1]:Stop()
			end
			curmat[1] = Emitter:FindFirstChild(mat)
			curmat[2] = mat
		elseif curmat[1] then
			if curmat[1] and curmat[1].IsPlaying == false then
				curmat[1]:Play()
			end
			if curmat[2]=="Concrete" then
				curmat[1].PlaybackSpeed = 1.1 + hum.WalkSpeed / 20
			else
				curmat[1].PlaybackSpeed = .5 + hum.WalkSpeed / 20
			end
		end
	else
		if curmat[1] then
			curmat[1]:Stop()
		end
	end
end)
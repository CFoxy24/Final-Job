local Night = 0
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CallState = 0
local PlayerGui = player:WaitForChild("PlayerGui")

local prompt = workspace:FindFirstChild("PhonePrompt", true)

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local textLabel = Instance.new("TextLabel")
textLabel.LayoutOrder = 10
textLabel.Size = UDim2.new(1, 0, 0.4, 0)
textLabel.Position = UDim2.new(0, 0, 0.6, 0)
textLabel.TextYAlignment = Enum.TextYAlignment.Bottom
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = false
textLabel.TextSize = 40
textLabel.Visible = false
textLabel.Parent = screenGui
textLabel.Font = Enum.Font.Gotham
textLabel.TextWrapped = true

local function typeWriter(text, delayTime)
	textLabel.Visible = true
	textLabel.MaxVisibleGraphemes = 0
	textLabel.Text = text
	for i = 1, #text do
		if CallState == 2 then return end
		
		local NS = script.Speak:Clone()
		NS.Parent = script
		NS.Name = "Speaking"
		NS.PlaybackSpeed = math.random(75,100)/100
		NS.Volume = math.random(20,40)/100
		NS:Play()
		NS.Stopped:Connect(function()
			NS:Destroy()
		end)
		
		
		textLabel.MaxVisibleGraphemes = i
		task.wait(delayTime or 0.05)
	end
	task.wait(3)
	textLabel.Visible = false
end

if CallState == 0 then
	if prompt and prompt:FindFirstChild("ActionText") then
		prompt.ActionText = "Start Call"
	end
end

prompt.Triggered:Connect(function()
	if CallState == 0 then
		Night = workspace:GetAttribute("NightNumber")
		CallState = 1
		prompt.ActionText = "End Call"
		if Night == 1 then
			
			typeWriter("Hey, uh, glad to hear you decided to take the job!", 0.03)
			task.wait(1.5)
			typeWriter("Honestly, I wasn’t sure anyone would come back after seeing the state this place is in, haha.",0.03)
			task.wait(1.5)
			typeWriter("Yeah, it’s a little run-down, but it’s still important we keep things safe around here.", 0.03)
			task.wait(1.5)
			typeWriter("Those animatronics cost a lot of money, and we really don’t want anyone trying to steal or mess with them, you know?", 0.03)
			task.wait(1.5)
			typeWriter("By the way, now the doors and the cameras work on a separate generator, so you can access them whenever you want", 0.03)
			task.wait(1.5)
			typeWriter("Thanks again for taking the night shift. It really means a lot.", 0.03)
			task.wait(1.5)
			typeWriter("Anyway, I’ll let you get settled in—have a great night, and, uh... enjoy your time at the pizzeria.”", 0.03)
			prompt:Destroy()
		elseif Night == 2 then
			task.wait(1.5)
			typeWriter("Hey, hey! Glad to see you made it back for another night.", 0.03)
			task.wait(1.5)
			typeWriter("So, uh... I heard your message about the animatronics moving around.", 0.03)
			task.wait(1.5)
			typeWriter("Yeah, I’d love to believe you, but, see, the cameras here don’t actually have any recording memory.", 0.03)
			task.wait(1.5)
			typeWriter("They just show a live feed, so... I can’t really check what happened last night.", 0.03)
			task.wait(1.5)
			typeWriter("Still, just to be sure, I’ll take a look at their hydraulics and servos during the day—make sure everything’s working fine, alright?", 0.03)
			task.wait(1.5)
			typeWriter("Anyway, try not to worry too much. You’re probably just getting used to the place.", 0.03)
			task.wait(1.5)
			typeWriter("Have a good night, and... keep an eye out, just in case.", 0.03)
			prompt:Destroy()
		elseif Night == 3 then
			task.wait(1.5)
			typeWriter("Hey, uh... you’re still there, right?", 0.03)
			task.wait(1.5)
			typeWriter("Good, good. Listen, I, uh... started digging through some old paperwork this morning, and I found a few things about the place.", 0.03)
			task.wait(1.5)
			typeWriter("Apparently, this pizzeria had... a couple of lawsuits in the past. Nothing too clear, but—yeah, it’s weird stuff.", 0.03)
			task.wait(1.5)
			typeWriter("I’m gonna try to find out more tomorrow, see what really happened here.", 0.03)
			task.wait(1.5)
			typeWriter("In the meantime, just... keep doing what you’re doing.", 0.03)
			task.wait(1.5)
			typeWriter("I know the animatronics have been acting strange, but try to stay calm and make it through the night.", 0.03)
			task.wait(1.5)
			typeWriter("I’ll update you once I know more, alright? Hang in there.", 0.03)
			prompt:Destroy()
		elseif Night == 4 then
			task.wait(1.5)
			typeWriter("Hey... so, uh, something strange happened today.", 0.03)
			task.wait(1.5)
			typeWriter("After I mentioned those old lawsuits, I got this letter in the mail — no name, no return address.", 0.03)
			task.wait(1.5)
			typeWriter("It just said, ‘Stop digging into the pizzeria’s past.’ Kinda creepy, right?", 0.03)
			task.wait(1.5)
			typeWriter("I mean, I’m not sure if it’s some prank or if someone actually doesn’t want me looking around.", 0.03)
			task.wait(1.5)
			typeWriter("Either way, I’ll be careful.", 0.03)
			task.wait(1.5)
			typeWriter("You just keep doing your job tonight, and... I’ll let you know if I find out anything else tomorrow.", 0.03)
			prompt:Destroy()
		elseif Night == 5 then
			task.wait(1.5)
			typeWriter("Hey... I, uh... I don’t even know how to say this.", 0.03)
			task.wait(1.5)
			typeWriter("I kept looking into the place, and... I found something terrible.", 0.03)
			task.wait(1.5)
			typeWriter("At first, I thought those lawsuits were about broken machines or faulty wiring—but they weren’t.", 0.03)
			task.wait(1.5)
			typeWriter("They were about murders. Kids went missing here, and the owner covered it all up.", 0.03)
			task.wait(1.5)
			typeWriter("He just shut everything down and left it to rot—like nothing ever happened.", 0.03)
			task.wait(1.5)
			typeWriter("I... I can’t believe it.", 0.03)
			task.wait(1.5)
			typeWriter("Look, whatever you do, DON'T come back tomorrow. I’ve already called the police.", 0.03)
			task.wait(1.5)
			typeWriter("They’ll take it from here. Just... make it through tonight, alright? Then get out of that place. Run.", 0.03)
			prompt:Destroy()
		elseif Night == 6 then

			textLabel.TextColor3 = Color3.fromRGB(76, 33, 136)
			
			task.wait(1.5)
			typeWriter("He said too much, good luck trying to survive this night with my toys, hahaha", 0.1)
			task.wait(1.5)
			typeWriter("And just in case, I have added a new toy to the night, make sure to say hi", 0.1)
			prompt:Destroy()
		end
		
	elseif CallState == 1 then
		CallState = 2
		textLabel.Visible = false
		prompt.Enabled = false
	end
end)


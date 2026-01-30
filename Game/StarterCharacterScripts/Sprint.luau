local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Running = false
local WantsToRun = false

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

local WalkSpeed = 8
local SprintSpeed = 18

local Stamina = 15
local MaxStamina = 10

local RegenBuff = 1.5
local RegenMultiplier = 2

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StaminaGUI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local GrosseBar = Instance.new("Frame")
GrosseBar.Size = UDim2.new(0.25, 0, 0.025, 0)
GrosseBar.Position = UDim2.new(0.375, 0, 0.93, 0)
GrosseBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GrosseBar.BackgroundTransparency = 0.4
GrosseBar.BorderSizePixel = 0
GrosseBar.Parent = screenGui

local GrosseCorner = Instance.new("UICorner")
GrosseCorner.CornerRadius = UDim.new(1, 0)
GrosseCorner.Parent = GrosseBar

local BonneBarDeStaminahmmmm = Instance.new("Frame")
BonneBarDeStaminahmmmm.Name = "StaminaBar"
BonneBarDeStaminahmmmm.Size = UDim2.new(1, 0, 1, 0)
BonneBarDeStaminahmmmm.Position = UDim2.new(0, 0, 0, 0)
BonneBarDeStaminahmmmm.BackgroundColor3 = Color3.fromRGB(76, 76, 76)
BonneBarDeStaminahmmmm.BackgroundTransparency = 0.1
BonneBarDeStaminahmmmm.BorderSizePixel = 0
BonneBarDeStaminahmmmm.Parent = GrosseBar

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(1, 0)
InnerCorner.Parent = BonneBarDeStaminahmmmm

local uiTweenA, uiTweenB
local BG_VISIBLE_TRANSP = 0.4
local INNER_VISIBLE_TRANSP = 0.1
local HIDDEN_TRANSP = 1

local Context = Instance.new("InputContext")
local action = Instance.new("InputAction")
local bind = Instance.new("InputBinding")
local bind2 = Instance.new("InputBinding")

Context.Parent = game.ReplicatedStorage
action.Parent = Context
action.Type = Enum.InputActionType.Bool
bind.Parent = action
bind.KeyCode = Enum.KeyCode.LeftShift
bind2.KeyCode = Enum.KeyCode.ButtonR2
bind2.Parent = action

local function SetStaminaUIVisible(visible)
	if uiTweenA then uiTweenA:Cancel() end
	if uiTweenB then uiTweenB:Cancel() end

	if visible then
		GrosseBar.Visible = true

		uiTweenA = TweenService:Create(GrosseBar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = BG_VISIBLE_TRANSP
		})
		uiTweenB = TweenService:Create(BonneBarDeStaminahmmmm, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = INNER_VISIBLE_TRANSP
		})
		uiTweenA:Play()
		uiTweenB:Play()
	else
		uiTweenB = TweenService:Create(BonneBarDeStaminahmmmm, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = HIDDEN_TRANSP
		})
		uiTweenA = TweenService:Create(GrosseBar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = HIDDEN_TRANSP
		})
		uiTweenB:Play()
		uiTweenA:Play()

		uiTweenA.Completed:Connect(function()
			if BonneBarDeStaminahmmmm.BackgroundTransparency >= 0.99 then
				GrosseBar.Visible = false
			end
		end)
	end
end

action.StateChanged:Connect(function(val)
	WantsToRun = val
end)

RunService.RenderStepped:Connect(function(deltaTime)
	if WantsToRun and humanoid.MoveDirection.Magnitude > 0 then
		if not Running then
			humanoid.WalkSpeed = SprintSpeed
			Running = true
		end

		Stamina = math.clamp(Stamina - deltaTime, 0, MaxStamina)
		RegenBuff = 1

		if Stamina == 0 then
			humanoid.WalkSpeed = WalkSpeed
			Running = false
			WantsToRun = false
		end
	else
		if Running then
			humanoid.WalkSpeed = WalkSpeed
			Running = false
		end

		RegenBuff = RegenBuff - deltaTime
		if RegenBuff <= 0 then
			Stamina = math.clamp(Stamina + deltaTime * RegenMultiplier, 0, MaxStamina)
		end
	end

	local Pourcent = Stamina / MaxStamina
	BonneBarDeStaminahmmmm.Size = UDim2.new(Pourcent, 0, 1, 0)

	if Pourcent >= 1 then
		SetStaminaUIVisible(false)
	else
		SetStaminaUIVisible(true)
	end
end)

local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

if isMobile then
	local gui = Instance.new("ScreenGui")
	gui.Name = "SprintButtonGui"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local button = Instance.new("ImageButton")
	button.Name = "SprintButton"
	button.Parent = gui
	button.AnchorPoint = Vector2.new(1, 1)
	button.Position = UDim2.new(1, -40, 1, -120)
	button.Size = UDim2.new(0, 50, 0, 50)
	button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	button.BackgroundTransparency = 0.3
	button.AutoButtonColor = true
	button.Image = "http://www.roblox.com/asset/?id=9525535512"
	button.BorderSizePixel = 0

	button.MouseButton1Down:Connect(function()
		WantsToRun = true
	end)
	
	button.TouchRotate:Connect(function()
		WantsToRun = true
	end)

	button.MouseButton1Up:Connect(function()
		WantsToRun = false
	end)
end
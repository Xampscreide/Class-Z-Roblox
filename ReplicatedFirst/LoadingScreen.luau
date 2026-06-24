local PlayerService = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local LocalPlayer = PlayerService.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.fromScale(1,1)
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel",Frame)
TextLabel.AnchorPoint = Vector2.new(.5,.5)
TextLabel.Position = UDim2.fromScale(.5,.5)
TextLabel.Size = UDim2.fromScale(.2,.06)
TextLabel.FontFace.Weight = Enum.FontWeight.Heavy
TextLabel.TextScaled = true
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.new(1,1,1)
TextLabel.Text = "LOADING."
TextLabel.TextXAlignment = Enum.TextXAlignment.Center

local Intervalo = .2
local Ativo = true
task.spawn(function()
	while Ativo do
		task.wait(Intervalo)
		if not Ativo then break end
		TextLabel.Text = "LOADING.."
		task.wait(Intervalo)
		if not Ativo then break end
		TextLabel.Text = "LOADING..."
		task.wait(Intervalo)
		if not Ativo then break end
		TextLabel.Text = "LOADING"
		task.wait(Intervalo)
		if not Ativo then break end
		TextLabel.Text = "LOADING."
	end
end)

ReplicatedFirst:RemoveDefaultLoadingScreen()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
while not PlayerStats.Loaded do
	task.wait() 
end
if not game:IsLoaded() then
	game.Loaded:Wait()
end
Ativo = false
PlayerGui:WaitForChild("Menu").Enabled = true

ScreenGui:Destroy()

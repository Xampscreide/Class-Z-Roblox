local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local Cadencia = require(Modulos:WaitForChild("Cadencia"))
local ProjetilSystem = require(Modulos:WaitForChild("ClienteProjetilSystem"))
local SoundModule = require(Modulos:WaitForChild("Sound"))
local Mobile = require(Modulos:WaitForChild("UserInput"))

local Sound = script.Parent:WaitForChild("Sound")
local Fire = script.Parent:WaitForChild("Fire")
local Hit = script.Parent:WaitForChild("Hit")

local Player = game:GetService("Players").LocalPlayer
local Character:Model = script.Parent.Parent

local Ligado = false
local Automatico = false
Cadencia.Set()

local function Ativar()
	if not (Ligado or Automatico) then return end
	if Cadencia.Shot() then
		ProjetilSystem.FirePierce(Fire,Hit)
		SoundModule.PlaySound(Sound)
	end
end

UserInputService.InputBegan:Connect(function(Input,InputFalso)
	if InputFalso then return end
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then Ligado = true end
end)

UserInputService.InputEnded:Connect(function(Input,InputFalso)
	if InputFalso then return end
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then Ligado = false end
end)

RunService.Stepped:Connect(function(DeltaTime:number)
	Ativar()
end)

Mobile.Arma(function(Bool)
	Automatico = Bool
end)

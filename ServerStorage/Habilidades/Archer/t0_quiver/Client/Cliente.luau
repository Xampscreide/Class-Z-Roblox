local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local Cadencia = require(Modulos:WaitForChild("Cadencia"))
local ProjetilSystem = require(Modulos:WaitForChild("ClienteProjetilSystem"))
local Mobile = require(Modulos:WaitForChild("UserInput"))
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
local Config = PlayerStats.Config

local Fire = script.Parent:WaitForChild("Fire")
local Hit = script.Parent:WaitForChild("Hit")

local Player = game:GetService("Players").LocalPlayer
local Character:Model = script.Parent.Parent

local Ligado = false
Cadencia.Set()

Ligado = true

function Ativar()
	if not Cadencia.Habilidade() then return end
	ProjetilSystem.FirePierceH(Fire,Hit)
end

UserInputService.InputBegan:Connect(function(input,InputFalso)
	if InputFalso then
		return
	end
	if input.KeyCode.Name == Config.HKey then
		Ativar()
	end
end)

Mobile.Habilidade(Ativar)







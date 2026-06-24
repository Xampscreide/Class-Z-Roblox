local UserInputService = game:GetService("UserInputService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local Config = ReplicatedStorage:WaitForChild("Configuração")
local Cadencia = require(Modulos:WaitForChild("Cadencia"))
local VisualEffects = require(Modulos:WaitForChild("VisualEffects"))
local Habilidades = require(Config:WaitForChild("Habilidades"))
local Mobile = require(Modulos:WaitForChild("UserInput"))
local TransformadorCliente = require(Modulos:WaitForChild("TransformadorCliente"))
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
local Config = PlayerStats.Config

local GapAngle = math.rad(Habilidades["t0_scepter"].GapAngle)
local MaxDistance = Habilidades["t0_scepter"].MaxDistance/math.cos(GapAngle)

local Fire = script.Parent:WaitForChild("Fire")

local BlackColor = Color3.new(0,0,0)
local RedColor = Color3.new(0.407843, 0.0117647, 0)

local Player = game.Players.LocalPlayer
local Character:Model = script.Parent.Parent

local function Format(Vetor:Vector3)
	Vetor = Vector3.new(Vetor.X,0,Vetor.Z).Unit
	local Vetor2 = Vector3.new(math.cos(-GapAngle/2)*Vetor.X-math.sin(-GapAngle/2)*Vetor.Z,0,math.sin(-GapAngle/2)*Vetor.X+math.cos(-GapAngle/2)*Vetor.Z)
	Vetor = Vector3.new(math.cos(GapAngle/2)*Vetor.X-math.sin(GapAngle/2)*Vetor.Z,0,math.sin(GapAngle/2)*Vetor.X+math.cos(GapAngle/2)*Vetor.Z)
	return Vetor,Vetor2
end

local function Ativar()
	if not Cadencia.Habilidade() then return end
	local Mouse = TransformadorCliente.GetMouse()
	local PlayerPosition = Character.PrimaryPart.Position
	local Direcao1,Direcao2 = Format(Mouse-PlayerPosition)
	VisualEffects.CriarLinha(PlayerPosition,Direcao1,MaxDistance,BlackColor)
	VisualEffects.CriarLinha(PlayerPosition,Direcao2,MaxDistance,BlackColor)
	Fire:FireServer(Mouse)
end

UserInputService.InputBegan:Connect(function(input,InputFalso)
	if InputFalso then return end
	if input.KeyCode.Name == Config.HKey then
		Ativar()
	end
end)

Mobile.Habilidade(Ativar)

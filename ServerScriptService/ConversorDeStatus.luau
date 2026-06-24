local ConversorDeStatus = {}
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PLAYERS = require(ServerScriptService:WaitForChild("_G.Players"))
local CONVERSORDESTATUS = require(ReplicatedStorage:WaitForChild("Modulos"):WaitForChild("ConversorDeStatus"))

ConversorDeStatus.Velocidade = CONVERSORDESTATUS.Velocidade

function ConversorDeStatus.PlayerVelocidade(Player:Player):number
	local SPD = PLAYERS.Stats(Player).SPD
	return ConversorDeStatus.Velocidade(SPD)
end

ConversorDeStatus.Dextreza = CONVERSORDESTATUS.Dextreza

function ConversorDeStatus.PlayerDextreza(Player:Player)
	local DEX = PLAYERS.Stats(Player).DEX
	return ConversorDeStatus.Dextreza(DEX)
end

ConversorDeStatus.Vitalidade = CONVERSORDESTATUS.Vitalidade

function ConversorDeStatus.PlayerVitalidade(Player:Player)
	local VIT = PLAYERS.Stats(Player).VIT
	return ConversorDeStatus.Vitalidade(VIT)
end

ConversorDeStatus.Wisdom = CONVERSORDESTATUS.Wisdom

function ConversorDeStatus.PlayerWisdom(Player:Player)
	local WIS = PLAYERS.Stats(Player).WIS
	return ConversorDeStatus.Wisdom(WIS)
end

return ConversorDeStatus

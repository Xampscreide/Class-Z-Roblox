local TempoDeClasse = {}
--#####################################################################################################################################
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
--#####################################################################################################################################
local PLAYERINFO = require(ServerScriptService:WaitForChild("_G.Players"))
local SistemaPartida = require(ServerScriptService:WaitForChild("SistemaPartida"))
--#####################################################################################################################################

local TabelaDePlayers = {}

function TempoDeClasse.IniciarTemporizador(Player:Player)
	TabelaDePlayers[Player] = PLAYERINFO.PlayerClass(Player)
end

function TempoDeClasse.FinalizarTemporizador(Player:Player)
	TabelaDePlayers[Player] = nil
end

RunService.Heartbeat:Connect(function(DeltaTime)
	for Player:Player,Classe in pairs(TabelaDePlayers) do
		PLAYERINFO.AddClassTime(Player,Classe,DeltaTime)
		SistemaPartida.AdicionarTempo(Player,DeltaTime)
	end
end)

return TempoDeClasse

local Magic = {}
--#####################################################################################################################################
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
--#####################################################################################################################################
local PLAYERINFO = require(game:GetService("ServerScriptService"):WaitForChild("_G.Players"))
local CONFIGURACOES = require(game:GetService("ReplicatedStorage"):WaitForChild("Configuração"):WaitForChild("Habilidades"))
local CONVERSORDESTATUS = require(ServerScriptService:WaitForChild("ConversorDeStatus"))
local EstatisticaPlayer = require(ServerScriptService:WaitForChild("EstatisticaPlayer"))
--#####################################################################################################################################
local MagicPointEvento = game:GetService("ReplicatedStorage"):WaitForChild("EventosRemotos"):WaitForChild("MagicPoint")

local Players = {}

function Magic.Verificar(Player:Player,Quantidade)
	local PlayerInfo = PLAYERINFO.GetPlayer(Player)
	if PlayerInfo.MP < Quantidade then
		MagicPointEvento:FireClient(Player,"A",PlayerInfo.MP,workspace:GetServerTimeNow())
		return false
	end
	EstatisticaPlayer.Use(Player)
	PlayerInfo.MP -= Quantidade
	return true
end

function Magic.OlharSeTem(Player:Player,Quantidade)
	local MP = PLAYERINFO.GetPlayer(Player).MP
	if MP < Quantidade then
		MagicPointEvento:FireClient(Player,"A",MP,workspace:GetServerTimeNow())
		return false
	end
	return true
end

function Magic.Continuo(Player:Player,Custo:number,DeltaTime:number)
	local PlayerInfo = PLAYERINFO.GetPlayer(Player)
	if PlayerInfo.MP < Custo*DeltaTime then
		MagicPointEvento:FireClient(Player,"A",PlayerInfo.MP,workspace:GetServerTimeNow())
		return false
	end
	PlayerInfo.MP -= Custo*DeltaTime
	return true
end

function Magic.Adicionar(Player:Player)
	local PlayerInfo = PLAYERINFO.GetPlayer(Player)
	PlayerInfo.MP = PlayerInfo.Stats.MP
	Players[Player] = {PlayerInfo,PlayerInfo.Stats.WIS,Player}
	MagicPointEvento:FireClient(Player,"L",PlayerInfo.MP,workspace:GetServerTimeNow())
end

function Magic.Remover(Player:Player)
	Players[Player] = nil
	MagicPointEvento:FireClient(Player,"D")
end

RunService.Heartbeat:Connect(function(DeltaTime)
	for PlayerUserId:Player,Conteudo in pairs(Players) do
		Conteudo[1].MP = math.min(Conteudo[1].MP+CONVERSORDESTATUS.Wisdom(Conteudo[2])*DeltaTime,Conteudo[1].Stats.MP)
	end
end)

return Magic

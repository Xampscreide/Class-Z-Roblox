local LeardBoard = {}

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local KillFeedEvent = EventosRemotos:WaitForChild("KillFeed")

local Ping = require(script:WaitForChild("Ping"))
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))

local LeaderBoardFolder = ReplicatedStorage:WaitForChild("LeaderBoard")
local OrangeFolder = LeaderBoardFolder:WaitForChild("Orange")
local PurpleFolder = LeaderBoardFolder:WaitForChild("Purple")
local PastaDosTimes = {OrangeFolder,PurpleFolder}

local MoldePlayer = script:WaitForChild("Player")

local InformacaoPassada = {}
local Pastas = {}

function LeardBoard.AddPlayer(Player:Player)
	local Info = PlayerInfo.GetPlayer(Player)
	local Time = if Player.Team.Name == "Orange" then 1 else 2
	
	InformacaoPassada[Player] = table.clone(Info.MatchStatistic)
	InformacaoPassada[Player].Ping = Player:GetNetworkPing()
	InformacaoPassada[Player].Class = Info.Class
	
	local Clone = MoldePlayer:Clone()
	Clone.Ping.Value = InformacaoPassada[Player].Ping
	Clone.Class.Value = table.find(Configuracoes.Classes,Info.Class) or 1
	Clone.Name = Player.Name
	Clone.Parent = PastaDosTimes[Time]
	
	Pastas[Player] = Clone
	Ping.AddPlayer(Player)
end

function LeardBoard.RemovePlayer(Player:Player)
	if not Pastas[Player] then return end
	Pastas[Player]:Destroy()
	Pastas[Player] = nil
	Ping.RemoverPlayer(Player)
end

function LeardBoard.TrocarTime(Player:Player)
	local Info = PlayerInfo.GetPlayer(Player)
	local Time = if Player.Team.Name == "Orange" then 1 else 2
	Pastas[Player].Parent = PastaDosTimes[Time]
end

function LeardBoard.Reset()
	for _,Pasta in pairs(Pastas) do
		Pasta.Damage.Value = 0
		Pasta.Kills.Value = 0
		Pasta.Deaths.Value = 0
		Pasta.Pontos.Value = 0
		Pasta.Heal.Value = 0
	end
end

function LeardBoard.AddKillFeed(Player1:Player,Player2:Player)
	KillFeedEvent:FireAllClients(Player1,Player2)
end

local Intervalo = .05
task.spawn(function()
	while task.wait() do
		local Modificado = false
		for Player:Player,EstatisticaPassada in pairs(InformacaoPassada) do
			if not Pastas[Player] then continue end
			local Diferenca = false
			local Info = PlayerInfo.GetPlayer(Player)
			local EstatisticaAtual = table.clone(Info.MatchStatistic)
			EstatisticaAtual.Class = Info.Class
			EstatisticaAtual.Ping = Ping.GetPing(Player)
			for NomeDaEstatistica, Valor in pairs(EstatisticaAtual) do
				if EstatisticaPassada[NomeDaEstatistica] ~= Valor then
					Diferenca = true
					Pastas[Player][NomeDaEstatistica].Value = if NomeDaEstatistica ~= "Class" then Valor else table.find(Configuracoes.Classes,Valor)
				end
			end
			InformacaoPassada[Player] = EstatisticaAtual
			if Diferenca then task.wait(Intervalo) end
		end
		if not Modificado then task.wait(Intervalo) end
	end
end)

return LeardBoard

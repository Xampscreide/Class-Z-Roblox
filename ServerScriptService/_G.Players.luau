local G_Players = {}
--#####################################################################################################################################
local PlayerService = game:GetService("Players")
local ServerStorage =game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
--#####################################################################################################################################
local PATERN = require(ServerScriptService:WaitForChild("Patern"))
local CONFIGURACOES = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local CARMA = CONFIGURACOES.Armas
local CHABILIDADE = CONFIGURACOES.Habilidades
local CARMADURA = CONFIGURACOES.Armaduras
local CSTAT = CONFIGURACOES.Stat
--#####################################################################################################################################
local TabelaDePlayers = {}
export type PlayerInfo = {
	MatchStatistic:{},Stats:{},Effects:{},EffectsHistory:{},MP:number,HP:number,Velocidade:number,XPLive:number,Pontos:number,XPPartida:number,
	Config:
		{RenderFriend:boolean,RenderEnemy:boolean,
		UnhittableShot:boolean,
		CameraDistance:number,
		DPI:number,
		AKey:string,
		HKey:string,
		ZKey:string,
	},Class:string,UnlockedClasses:{},PurchasedClasses:{},ClassXP:{},ClassTime:{},ClassStatistic:{},ClassStatisticModificada:{},ItemStatistic:{},ItemStatisticModificada:{},Equipamento:{},Version:number,
	HistoricoDeCompras:{},
	Boosters:{},
	Booster:{},
	UnlockedItens:{},
}
--#####################################################################################################################################
function G_Players.GetPlayerSafeMode(Player:Player)
	if not TabelaDePlayers[Player] then
		repeat
			task.wait()
		until TabelaDePlayers[Player]
	end
	return TabelaDePlayers[Player]
end

function G_Players.GetPlayer(Player:Player):PlayerInfo
	return TabelaDePlayers[Player]
end

function G_Players.GetAllPlayers()
	return TabelaDePlayers
end

function G_Players.NewPlayer(Player:Player,Conteudo)
	TabelaDePlayers[Player] = Conteudo
end

function G_Players.SetClassLevel(Player:Player,Leveis)
	TabelaDePlayers[Player].ClassLevel = Leveis
end

function G_Players.SetItensLiberados(Player:Player,Itens)
	TabelaDePlayers[Player].UnlockedItens = Itens
end

function G_Players.SetClassesLiberadas(Player:Player,Classes)
	TabelaDePlayers[Player].UnlockedClasses = Classes
end

function G_Players.SetVelocidade(Player:Player,Velocidade:number)
	TabelaDePlayers[Player].Velocidade = Velocidade
end

function G_Players.Velocidade(Player:Player)
	return TabelaDePlayers[Player].Velocidade
end

function G_Players.Effect(Player:Player,Efeito:string)
	local Efeito = TabelaDePlayers[Player].Effects[Efeito]
	return Efeito and Efeito[1] or false
end

function G_Players.Stasis(Player:Player)
	return TabelaDePlayers[Player].Effects["Stasis"]
end

function G_Players.Stasisimmunity(Player:Player)
	return TabelaDePlayers[Player].Effects["StasisImunity"]
end

function G_Players.ResetMatchStatistic(Player:Player)
	for Nome,_ in pairs(TabelaDePlayers[Player].MatchStatistic) do
		TabelaDePlayers[Player].MatchStatistic[Nome] = 0
	end
end

function G_Players.NewEffect(Player:Player,Efeito:string,Tabela:{})
	local TabelaDoPlayer = TabelaDePlayers[Player]
	TabelaDoPlayer.Effects[Efeito] = TabelaDoPlayer.Effects[Efeito] or {}
	table.insert(TabelaDoPlayer.Effects[Efeito],Tabela)
end

function G_Players.AllEffects(Player:Player)
	return TabelaDePlayers[Player].Effects
end

function G_Players.NewHistorico(Player:Player,EfeitoName:string,Efeito)
	TabelaDePlayers[Player].EffectsHistory[EfeitoName] = {Efeito,os.clock()}
end

function G_Players.Historico(Player:Player,Efeito:string)
	return TabelaDePlayers[Player].EffectsHistory[Efeito]
end

function G_Players.AddClassTime(Player:Player,Classe:string,Quantidade:number)
	TabelaDePlayers[Player].ClassTime[Classe] += Quantidade
end

function G_Players.PlayerClass(Player:Player)
	return TabelaDePlayers[Player].Class
end

function G_Players.SetClass(Player:Player,Classe:string)
	TabelaDePlayers[Player].Class = Classe
end

function G_Players.Stats(Player:Player)
	return TabelaDePlayers[Player].Stats
end

function G_Players.AddMatchStatistic(Player:Player,Quantidade:number,Estatistica:string)
	TabelaDePlayers[Player].MatchStatistic[Estatistica] += Quantidade
end

function G_Players.AddXP(Player:Player,Quantidade:number,Classe:string)
	local QuantidadeModificada = Quantidade*TabelaDePlayers[Player].Booster.XP
	TabelaDePlayers[Player].ClassXP[Classe] += QuantidadeModificada
	TabelaDePlayers[Player].XPLive += QuantidadeModificada
	TabelaDePlayers[Player].MatchStatistic.Pontos += Quantidade
	TabelaDePlayers[Player].Pontos += Quantidade
end

function G_Players.AddXPPartida(Player:Player,Quantidade:number,Classe:string)
	Quantidade = Quantidade*TabelaDePlayers[Player].Booster.XP
	TabelaDePlayers[Player].ClassXP[Classe] += Quantidade
end

function G_Players.AddXPClasseAtual(Player:Player,Quantidade:number)
	local QuantidadeModificada = Quantidade*TabelaDePlayers[Player].Booster.XP
	TabelaDePlayers[Player].ClassXP[TabelaDePlayers[Player].Class] += QuantidadeModificada
	TabelaDePlayers[Player].XPLive += QuantidadeModificada
	TabelaDePlayers[Player].MatchStatistic.Pontos += Quantidade
	TabelaDePlayers[Player].Pontos += Quantidade
end

function G_Players.GetLiveXP(Player:Player)
	local Player = TabelaDePlayers[Player]
	local XPLive = Player.XPLive
	local Pontos = Player.Pontos
	Player.XPLive = 0
	Player.Pontos = 0
	Player.XPPartida[Player.Class] += XPLive
	return XPLive, Pontos
end

function G_Players.GetXPPartida(Player:Player)
	G_Players.GetLiveXP(Player)
	local Retorno = table.clone(TabelaDePlayers[Player].XPPartida)
	for NomeClasse,_ in pairs(TabelaDePlayers[Player].XPPartida) do
		TabelaDePlayers[Player].XPPartida[NomeClasse] = 0
	end
	return Retorno
end

function G_Players.UpdateStats(Player:Player)
	local Info = TabelaDePlayers[Player]
	local Atributos = Info.Stats
	local Equipamentos = Info.Equipamento[Info.Class]
	for Stat,Conteudo in pairs(CSTAT[Info.Class]) do
		Atributos[Stat] = Conteudo
	end
	if CARMADURA[Equipamentos.Armadura].Stats then
		for Stat,Conteudo in pairs(CARMADURA[Equipamentos.Armadura].Stats) do
			Atributos[Stat] += Conteudo
		end
	end
	if CARMA[Equipamentos.Arma].Stats then
		for Stat,Conteudo in pairs(CARMA[Equipamentos.Arma].Stats) do
			Atributos[Stat] += Conteudo
		end
	end
	if CHABILIDADE[Equipamentos.Habilidade].Stats then
		for Stat,Conteudo in pairs(CHABILIDADE[Equipamentos.Habilidade].Stats) do
			Atributos[Stat] += Conteudo
		end
	end
	for Stat,Valor in pairs(Atributos) do
		Atributos[Stat] = math.max(0,Valor)
	end
end

function G_Players.AdicionarHistoricoDeCompra(Player:Player,Recibo)
	local ReciboSerializado = table.clone(Recibo)
	ReciboSerializado.Data = os.time()
	ReciboSerializado.CurrencyType = nil
	table.insert(TabelaDePlayers[Player].HistoricoDeCompras,ReciboSerializado) 
end

function G_Players.AdicionarClasseComprada(Player:Player,NomeDaClasse:string)
	local Info = G_Players.GetPlayerSafeMode(Player)
	Info.PurchasedClasses[NomeDaClasse] = true
	Info.UnlockedClasses[NomeDaClasse] = true
end

return G_Players

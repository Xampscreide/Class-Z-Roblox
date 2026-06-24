local Patern = {}
--#####################################################################################################################################
local PATERNDECLASSE = require(script:WaitForChild("PaternDeClasse"))
local PATERNDEEQUIPAMENTO = require(script:WaitForChild("PaternDeEquipamento"))
local PATERNDEESTATISTICADEEQUIPAMENTO = require(script:WaitForChild("PaternDeEstatisticaDeEquipamento"))
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONFIGURACAO = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
--#####################################################################################################################################
export type PlayerInfo = {
	MatchStatistic:{},
	Stats:{},
	Effects:{},
	EffectsHistory:{},
	MP:number,
	HP:number,
	Velocidade:number,
	XPLive:number,
	Pontos:number,
	XPPartida:number,
	Config:{
		RenderFriend:boolean,
		RenderEnemy:boolean,
		UnhittableShot:boolean,
		CameraDistance:number,
		DPI:number,
		AKey:string,
		HKey:string,
		ZKey:string,
	},
	Class:string,
	UnlockedClasses:{},
	PurchasedClasses:{},
	ClassXP:{},
	ClassTime:{},
	ClassStatistic:{},
	ClassStatisticModificada:{},
	ItemStatistic:{},
	ItemStatisticModificada:{},
	Equipamento:{},
	Version:number,
	HistoricoDeCompras:{},
	Boosters:{},
	Booster:{},
}

function Patern.Copia()
	local Tabela:PlayerInfo = {}
	
	Tabela.MatchStatistic = {
		DamageTaken = 0,
		Damage = 0,
		Heal = 0,
		Deaths = 0,
		Kills = 0,
		Captures = 0,
		Pontos = 0
	}
	
	Tabela.Stats = {
		HP = 1000,
		MP = 252,
		ATT = 50,
		DEF = 25,
		SPD = 75,
		DEX = 75,
		VIT = 40,
		WIS = 50,
	}

	
	Tabela.Effects = {}
	Tabela.EffectsHistory = {}
	Tabela.MP = 1000
	Tabela.HP = 1000
	Tabela.Velocidade = 36
	Tabela.XPLive = 0
	Tabela.Pontos = 0
	Tabela.XPPartida = {}
	
	Tabela.Config = {
		RenderFriend = true,
		RenderEnemy = true,
		UnhittableShot = false,
		CameraDistance = 50,
		DPI = 25,
		AKey = "T",
		HKey = "R",
		ZKey = "F"
	}
	Tabela.Class = "Archer"
	Tabela.UnlockedClasses = {}
	Tabela.ClassLevel = {}
	Tabela.PurchasedClasses = {}
	Tabela.ClassXP = {}
	Tabela.ClassTime = {}
	Tabela.ClassStatistic = {}
	Tabela.ClassStatisticModificada = {}
	
	for _, Classe in pairs(CONFIGURACAO.Classes) do
		Tabela.XPPartida[Classe] = 0
		Tabela.ClassTime[Classe] = 0
		Tabela.ClassXP[Classe] = 0
		Tabela.ClassLevel[Classe] = 1
		Tabela.ClassStatisticModificada[Classe] = {
			Deaths = 0,
			Kills = 0,
			Damage = 0,
			DamageTaken = 0,
			Captures = 0,
			Heal = 0
		}
		Tabela.ClassStatistic[Classe] = {
			Deaths = 0,
			Kills = 0,
			Damage = 0,
			DamageTaken = 0,
			Captures = 0,
			Heal = 0
		}
	end
	Tabela.ItemStatistic = PATERNDEESTATISTICADEEQUIPAMENTO.Clone()
	Tabela.ItemStatisticModificada = PATERNDEESTATISTICADEEQUIPAMENTO.Clone()	
	Tabela.Equipamento = PATERNDEEQUIPAMENTO.Clone()
	Tabela.Version = 1
	Tabela.HistoricoDeCompras = {}
	Tabela.Boosters = {
		XP = {},
		Item = {},
		Class = {}
	}
	Tabela.Booster = {
		XP = 1,
		Item = 1,
		Class = 1,
	}
	Tabela.FirstLogin = os.time()
	Tabela.Gold = 0
	
	return Tabela
end

return Patern

local Estatistica = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CONFIGURACOES = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local CARMA = CONFIGURACOES.Armas
local CHABILIDADE = CONFIGURACOES.Habilidades
local CARMADURA = CONFIGURACOES.Armaduras

local Patern = {}

local EstatisticaPorClasse = {
	Archer = {"Hits","Damage","Kills"},
	Bard = {"ShotsB","Hits"},
	Assassin = {"Damage","Hits","Kills"},
	Huntress = {"Damage","Hits","Kills"},
	Wizard = {"Damage","Hits","Kills"},
	Priest = {"Heal","Hits"},
	Warrior = {"Hits"},
	Rogue = {},
	Necromancer = {"Hits","Damage","Kills"},
	Paladin = {"Heal","Hits"},	
	Mystic = {"Hits"},
	Sorcerer = {"Damage","Hits","Kills"},
	Ninja = {"Damage","Hits","Kills"},
	Samurai = {"Damage","Hits","Kills"},
	Knight = {"Damage","Hits","Kills"},
	Kensei = {"Damage","Hits","Kills"},
}
Estatistica.EstatisticaPorClasse = EstatisticaPorClasse

for Arma,Conteudo in pairs(CARMA) do
	Patern[Arma] = {
		Damage = 0,
		Kills = 0,
		Hits = 0,
		Shots = 0,
	}
end

for Habilidade,Conteudo in pairs(CHABILIDADE) do
	Patern[Habilidade] = {
		Uses = 0,
	}
	for i,NomeDaEstatistica in ipairs(EstatisticaPorClasse[Conteudo.Class] or {}) do Patern[Habilidade][NomeDaEstatistica] = 0 end
end

for Armadura,Conteudo in pairs(CARMADURA) do
	Patern[Armadura] = {
		DamageTaken = 0,
		HitsTake = 0,
	}
end

function Estatistica.Clone()
	local retorno = {}
	for Nome,Conteudo in pairs(Patern) do
		retorno[Nome] = table.clone(Conteudo)
	end
	return retorno
end

return Estatistica

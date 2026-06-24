local Equipamento = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CONFIGURACOES = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local CARMA = CONFIGURACOES.Armas
local CHABILIDADE = CONFIGURACOES.Habilidades
local CARMADURA = CONFIGURACOES.Armaduras

local Patern = {}
for _,Classe in ipairs(CONFIGURACOES.Classes) do
	Patern[Classe] = {}
	for TipoDeArmadura:string,ListaDeClasses in pairs(CONFIGURACOES.ClassesPorArmadura) do
		if table.find(ListaDeClasses,Classe)  then
			Patern[Classe].Armadura = "t0_"..TipoDeArmadura
			break
		end
	end
	for TipoDeArma:string,ListaDeClasses in pairs(CONFIGURACOES.ClassesPorArma) do
		if table.find(ListaDeClasses,Classe)  then
			Patern[Classe].Arma = "t0_"..TipoDeArma
		end
	end
	for Habilidade,Habilidades in pairs(CHABILIDADE) do
		if Habilidades.Class == Classe and string.find(Habilidade,"t0") then
			Patern[Classe].Habilidade = Habilidade
			break
		end
	end
end

Equipamento.Clone = function()
	local Tabela = {}
	for Classe,Conteudo in pairs(Patern) do
		Tabela[Classe] = table.clone(Conteudo)
	end
	return Tabela
end

return Equipamento

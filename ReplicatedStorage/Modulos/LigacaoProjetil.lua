local Ligacao = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sons = ReplicatedStorage:WaitForChild("Sound")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local SoundModule = require(Modulos:WaitForChild("Sound"))
local Habilidades = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Habilidades"))
local Indikator = require(Modulos:WaitForChild("IndikatorCliente"))
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))

local DefaultHitSound = Sons:WaitForChild("Hit")

local SomDaArma = nil
local SomDaHabilidade = nil

function Ligacao.LigarPoison(Posicao:Vector3)
	local HabilidadeUsada = Habilidades[PlayerStats.Equipamento.Habilidade]
	Indikator.IndicarDanoArea(Posicao,HabilidadeUsada.PoisonRange,HabilidadeUsada.DamageInstantaneo)
end

function Ligacao.LigarTrap(Posicao:Vector3)
	local HabilidadeUsada = Habilidades[PlayerStats.Equipamento.Habilidade]
	Indikator.IndicarDanoArea(Posicao,HabilidadeUsada.RaioExplosao,HabilidadeUsada.Damage)
	Indikator.IndicarEfeitoArea(Posicao,HabilidadeUsada.RaioExplosao,HabilidadeUsada.IndikatorA)
end

function Ligacao.Informar(Character:Model,Habilidade:boolean?)
	local s ,erro = pcall(function()
		if Habilidade then
			local HabilidadeDoPlayer = Habilidades[PlayerStats.Equipamento.Habilidade]
			if HabilidadeDoPlayer.IndikatorD then
				Indikator.IndicarEfeitoDireto(Character,HabilidadeDoPlayer.IndikatorD)
			end
		end
		Indikator.IndicarDano(Character,Habilidade)
		SoundModule.PlaySound(DefaultHitSound)
	end)
	if not s then print(erro) end
end

return Ligacao

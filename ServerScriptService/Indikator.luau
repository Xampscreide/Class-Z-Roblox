local HitMarker = {}

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")

local IndikatorFunction = EventosRemotos:WaitForChild("Indikator")

local IndikatorAtualizar = EventosRemotos:WaitForChild("IndikatorAtualizar")
local IndikatorCriar = EventosRemotos:WaitForChild("IndikatorCriar")
local IndikatorDestruir = EventosRemotos:WaitForChild("IndikatorDestruir")

local EfeitosPlayer:{IntValue} = {}

local Efeitos = {
	Exposed = 1,
	Cursed = 2,
	Stasis = 4,
}

local Funcoes = {}
Funcoes[true] = bit32.bor
Funcoes[false] = bit32.band

function HitMarker.AtualizarPlayer(Player,Efeito,Start:boolean)
	if not Efeitos[Efeito] then return end
	if not EfeitosPlayer[Player] then return end
	local ValorAtual = EfeitosPlayer[Player].Value
	if Start then
		EfeitosPlayer[Player].Value = bit32.bor(ValorAtual,Efeitos[Efeito])
	else
		EfeitosPlayer[Player].Value = bit32.band(ValorAtual,bit32.bnot(Efeitos[Efeito]))
	end
	
end

function HitMarker.AdicionarCharacter(Character:Model,Player:Player)
	local Defesa = PlayerInfo.Stats(Player).DEF
	local DEFValue = Instance.new("IntValue")
	DEFValue.Name = "DEF"
	DEFValue.Value = Defesa
	DEFValue.Parent = Character
	local EfeitosValue = Instance.new("IntValue")
	EfeitosValue.Name = "Efeitos"
	EfeitosValue.Value = 0
	EfeitosValue.Parent = Character
	EfeitosPlayer[Player] = EfeitosValue
end

function HitMarker.RemoverCharacter(Character:Model,Player:Player)
	EfeitosPlayer[Player] = nil
end

return HitMarker

local Controller = {}

local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local PlayerService = game:GetService("Players")

local ExposedValor = Configuracoes.ExposedValor
local CursedMultiplier = Configuracoes.CursedMultiplier
local DamagingMultiplicador = Configuracoes.DamagingMultiplicador

local TabelaDeConversao = {
	Dano = .1,
	Heal = .3,
	HPBoost = 10,
	Poison = .1,
	Stasis = 15,
	Paralyzed = 5,
	Slowed = 5,
	Speedy = 0,
	Berserk = 5,
	Stunned = 5,
	Cursed = 5,
	Exposed = 5,
	Inspired = 5,
	Damaging = 5,
	Healing = 5,
	HealingQuantidade = .3,
}

local DamagingMultiplicator = 0.1
local InspiredMultiplicator = 0.1
local BerserkMultiplicator = 0.1
local ParalyzedMultiplicator = 0.07
local SlowedMultiplicator = 0.05

function Controller.Dano(PlayerAlvo:Player,PlayerAutor:Player,Quantidade:number,Classe:string?)
	--if #PlayerService:GetPlayers() < 6 then return end 

	local AllPlayerAutorEffects = PlayerInfo.AllEffects(PlayerAutor)
	local AllPlayerAlvoEffects = PlayerInfo.AllEffects(PlayerAlvo)
	
	Quantidade *= TabelaDeConversao["Dano"]
	Classe = Classe or PlayerInfo.PlayerClass(PlayerAutor)
	PlayerInfo.AddXP(PlayerAutor,Quantidade,Classe)
	
	local Damaging = AllPlayerAutorEffects["Damaging"]
	if Damaging and Damaging[1].PlayerAutor ~= PlayerAutor then PlayerInfo.AddXP(Damaging[1].PlayerAutor,Quantidade-Quantidade/DamagingMultiplicador,Damaging[1].AutorClass) end
	
	local Berserk = AllPlayerAutorEffects["Berserk"]
	if Berserk and Berserk[1].PlayerAutor ~= PlayerAutor then PlayerInfo.AddXP(Berserk[1].PlayerAutor,Quantidade*BerserkMultiplicator,Berserk[1].AutorClass) end
	
	local Paralyzed = AllPlayerAutorEffects["Paralyzed"]
	if Paralyzed and Paralyzed[1].PlayerAutor ~= PlayerAutor then PlayerInfo.AddXP(Paralyzed[1].PlayerAutor,Quantidade*ParalyzedMultiplicator,Paralyzed[1].AutorClass) end
	
	local Slowed = AllPlayerAutorEffects["Slowed"]
	if Slowed and Slowed[1].PlayerAutor ~= PlayerAutor then PlayerInfo.AddXP(Slowed[1].PlayerAutor,Quantidade*SlowedMultiplicator,Slowed[1].AutorClass) end
	
	local Cursed = AllPlayerAlvoEffects["Cursed"]
	if Cursed and Cursed[1].PlayerAutor ~= PlayerAutor then PlayerInfo.AddXP(Cursed[1].PlayerAutor,Damaging and Quantidade/DamagingMultiplicador*(1-1/CursedMultiplier) or Quantidade-Quantidade/CursedMultiplier,Cursed[1].AutorClass) end
	
	local Exposed = AllPlayerAlvoEffects["Exposed"]
	if Exposed and Exposed[1].PlayerAutor ~= PlayerAutor then PlayerInfo.AddXP(Exposed[1].PlayerAutor,ExposedValor,Exposed[1].AutorClass) end
end

function Controller.ConversaoDireta(PlayerAutor:Player,Effect:string,Quantidade:number,Classe:string?)
	--if #PlayerService:GetPlayers() < 6 then return end 
	Classe = Classe or PlayerInfo.PlayerClass(PlayerAutor)
	PlayerInfo.AddXP(PlayerAutor,Quantidade*TabelaDeConversao[Effect],Classe)
end

function Controller.Captura(Player:Player)
	--if #PlayerService:GetPlayers() < 6 then return end 
	PlayerInfo.AddXPClasseAtual(Player,1000)
end

return Controller

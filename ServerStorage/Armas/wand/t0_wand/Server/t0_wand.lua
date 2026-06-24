local PlayerService = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--#########################################################################################
local CriarProjeteis = require(ServerScriptService:WaitForChild("CriarProjeteis"))
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local ProjetilSystem = require(ServerScriptService:WaitForChild("ProjetilSystem"))
local Gerenciador = require(ServerScriptService:WaitForChild("Gerenciador"))
--#########################################################################################
local Character:Model = script.Parent
local Player:Player = PlayerService:GetPlayerFromCharacter(Character)
--#########################################################################################
local Config = Configuracoes.Armas["t0_wand"]
local ProjetilSpeed = Config.ProjetilSpeed
local ProjetilDistance = Config.ProjetilDistance
local Damage = Config.Damage
local ProjetilCosmetic = "WandP"
--#########################################################################################
local Quantidade = 10
local Inicio, ProjetilNumber = CriarProjeteis.CriarEInformar(Player,Quantidade,ProjetilSpeed,90,ProjetilDistance,ProjetilCosmetic)

local function onHit(PlayerAlvo:Player)	
	Gerenciador.Dano(PlayerAlvo,Player,Damage,true)
end

script.Fire.OnServerEvent:Connect(function(PlayerRequest:Player,Posicao:Vector3,Direcao:Vector3,StringInformacao:string)
	local Identificador, Tempo, Inspired, Berserk = string.unpack("I2dI1I1",StringInformacao)
	ProjetilNumber = ProjetilNumber[2]
	ProjetilSystem.NewFire("p",Identificador,ProjetilNumber[1],PlayerRequest,Posicao,Direcao,ProjetilSpeed,ProjetilDistance,Tempo,Inicio,Quantidade,Inspired,Berserk)
end)

script.Hit.OnServerEvent:Connect(function(PlayerRequest:Player,Instancia:Instance,InstanciaPosicao:Vector3,PosicaoDoHit:Vector3,StringInformacao:string)
	local Identificador, Tempo = string.unpack("I2d",StringInformacao)
	ProjetilSystem.NewPierceHit(PlayerRequest,Identificador,onHit,Instancia,Tempo,InstanciaPosicao,PosicaoDoHit)
end)

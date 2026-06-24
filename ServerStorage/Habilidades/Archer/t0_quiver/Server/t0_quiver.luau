local PlayerService = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--#########################################################################################
local CriarProjeteis = require(ServerScriptService:WaitForChild("CriarProjeteis"))
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local ProjetilSystem = require(ServerScriptService:WaitForChild("ProjetilSystem"))
local Gerenciador = require(ServerScriptService:WaitForChild("Gerenciador"))
local MagicPoint = require(ServerScriptService:WaitForChild("MagicPoint"))
--#########################################################################################
local Character:Model = script.Parent
local Player:Player = PlayerService:GetPlayerFromCharacter(Character)
--#########################################################################################
local Config = Configuracoes.Habilidades["t0_quiver"]
local ProjetilSpeed = Config.ProjetilSpeed
local ProjetilDistance = Config.ProjetilDistance
local Damage = Config.Damage
local ParalyzedDuration = Config.ParalyzedDuration
local MPCost = Config.MPCost
local ProjetilCosmetic = "QuiverP"
--#########################################################################################
local Quantidade = 10
local Inicio, ProjetilNumber = CriarProjeteis.CriarEInformarHabilidade(Player,Quantidade,ProjetilSpeed,90,ProjetilDistance,ProjetilCosmetic)

local function onHit(PlayerAlvo:Player)	
	Gerenciador.Dano(PlayerAlvo,Player,Damage)
	Gerenciador.Paralyzed(PlayerAlvo,Player,ParalyzedDuration)
end

script.Fire.OnServerEvent:Connect(function(PlayerRequest:Player,Posicao:Vector3,Direcao:Vector3,StringInformacao:string)
	if not MagicPoint.Verificar(PlayerRequest,MPCost) then return end
	local Identificador, Tempo = string.unpack("I2d",StringInformacao)
	ProjetilNumber = ProjetilNumber[2]
	ProjetilSystem.NewFireH("p",Identificador,ProjetilNumber[1],PlayerRequest,Posicao,Direcao,ProjetilSpeed,ProjetilDistance,Tempo,Inicio,Quantidade)
end)

script.Hit.OnServerEvent:Connect(function(PlayerRequest:Player,Instancia:Instance,InstanciaPosicao:Vector3,PosicaoDoHit:Vector3,StringInformacao:string)
	local Identificador, Tempo = string.unpack("I2d",StringInformacao)
	ProjetilSystem.NewPierceHit(PlayerRequest,Identificador,onHit,Instancia,Tempo,InstanciaPosicao,PosicaoDoHit)
end)

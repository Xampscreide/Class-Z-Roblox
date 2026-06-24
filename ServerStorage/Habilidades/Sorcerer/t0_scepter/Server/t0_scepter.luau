local PlayerService = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--#########################################################################################
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local Gerenciador = require(ServerScriptService:WaitForChild("Gerenciador"))
local MagicPoint = require(ServerScriptService:WaitForChild("MagicPoint"))
local TeamCoisas = require(ServerScriptService:WaitForChild("TeamCoisas"))
local InformarEfeitos = require(ServerScriptService:WaitForChild("InformarEfeitosEspeciais"))
--#########################################################################################
local Character:Model = script.Parent
local Player:Player = PlayerService:GetPlayerFromCharacter(Character)
--#########################################################################################
local Config = Configuracoes.Habilidades["t0_scepter"]
local Targets = Config.Targets
local Damage = Config.Damage
local AnguloFeixe = math.rad(Config.GapAngle)
local MaxDistance = Config.MaxDistance
local MPCost = Config.MPCost
local Color = Color3.new(1, 0.760784, 0.207843)
--#########################################################################################
local function Format(Vetor:Vector3)
	return Vector3.new(Vetor.X,0,Vetor.Z)
end

local Ligado = true
local CriarArcos = ReplicatedStorage:WaitForChild("EventosRemotos"):WaitForChild("CriarArcos")
local Fire = script:WaitForChild("Fire")
Fire.OnServerEvent:Connect(function(PlayerRequest:Player,MouseHitPoint:Vector3)
	if not MagicPoint.Verificar(PlayerRequest,MPCost) then return end
	
	local Distancia,TabelaPlayers = TeamCoisas.TabelaDeDistanciaInimigoPlayer(PlayerRequest,MaxDistance)
	if #Distancia < 1 then return end
	local PlayerPosition = Character.PrimaryPart.Position
	local MenorDistancia = math.huge
	local PlayerMaisProximo
	local Direcao = Format(MouseHitPoint-PlayerPosition)
	for Pos,DistanciaDoPlayer in ipairs(Distancia) do
		local Vetor = Format(TabelaPlayers[Pos].Character.PrimaryPart.Position-PlayerPosition) 
		if DistanciaDoPlayer < MenorDistancia and (Vetor):Angle(Direcao)<=AnguloFeixe/2 then 
			MenorDistancia = DistanciaDoPlayer
			PlayerMaisProximo = TabelaPlayers[Pos]
		end
	end
	if not PlayerMaisProximo then return end
	local PlayersAtingidos = {PlayerMaisProximo}
	
	for i=2,Targets do
		PlayerMaisProximo = TeamCoisas.InimigoMaisProximoInimigo(PlayersAtingidos[i-1],MaxDistance,PlayersAtingidos)
		if not PlayerMaisProximo then break end
		PlayersAtingidos[i] = PlayerMaisProximo
	end
	
	local PosicaoDosPlayers = {}
	for i,Player:Player in ipairs(PlayersAtingidos) do
		PosicaoDosPlayers[i] = Player.Character.PrimaryPart.Position
	end
	for i,PlayerAtingido in ipairs(PlayersAtingidos) do
		Gerenciador.Dano(PlayerAtingido,PlayerRequest,Damage)
	end
	table.insert(PosicaoDosPlayers,1,PlayerRequest.Character.PrimaryPart.Position)
	InformarEfeitos.CriarArco(PlayerRequest,PosicaoDosPlayers,Color)
end)


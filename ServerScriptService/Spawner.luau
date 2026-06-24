local Spawner = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage =game:GetService("ServerStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerService = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
--#####################################################################################################################################
local Models = ServerStorage:WaitForChild("Models")
local ScriptsDoModel = ServerStorage:WaitForChild("ScriptsDoModel")
local ConfiguracoesReplicated = ReplicatedStorage:WaitForChild("Configuração")
local Habilidades = ServerStorage:WaitForChild("Habilidades")
local Armas = ServerStorage:WaitForChild("Armas")
--#####################################################################################################################################
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local Classes = require(ConfiguracoesReplicated:WaitForChild("Classes"))
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))
local XPModule = require(ReplicatedStorage:WaitForChild("Modulos"):WaitForChild("XpCalculador"))
--#####################################################################################################################################
local TempoDaUltimaMorte = {}

local CorTime = {Color3.fromRGB(255, 106, 0),Color3.fromRGB(162, 0, 255)}
local TempoRespawn = Configuracoes.RespawnTime
local TempoProximaPartida = Configuracoes.TempoProximaPartida

local PosicaoSpawn = {workspace:WaitForChild("SpawnPoints"):WaitForChild("Orange"):GetChildren(),workspace:WaitForChild("SpawnPoints"):WaitForChild("Purple"):GetChildren()}
for i,k in ipairs(PosicaoSpawn[1]) do k.Transparency = 1 end
for i,k in ipairs(PosicaoSpawn[2]) do k.Transparency = 1 end

function Spawner.SetarTempoProximaPartida()
	for i,Player:Player in ipairs(PlayerService:GetPlayers()) do
		TempoDaUltimaMorte[Player] = os.clock()+TempoProximaPartida
	end
end

function Spawner.ApagarInformacoes(Player:Player)
	TempoDaUltimaMorte[Player] = nil
end

function Spawner.SetarUltimaMorte(Player:Player)
	TempoDaUltimaMorte[Player] = os.clock()+TempoRespawn
end

function Spawner.TentarSpawnar(Player:Player)
	local InfoPlayer = PlayerInfo.GetPlayer(Player)
	local Classe = InfoPlayer.Class
	if os.clock() < (TempoDaUltimaMorte[Player] or 0) then return false end
	
	local Time = if Player.Team.Name == "Orange" then 1 else 2
	local ModelParaSpawn:Model = Models[Classe]:Clone()
	ModelParaSpawn:FindFirstChildOfClass("MeshPart").Color = CorTime[Time]
	local Equipamento = InfoPlayer.Equipamento[Classe]
	local ArmaUsada = Equipamento.Arma
	local HabilidadeUsada = Equipamento.Habilidade
	local ArmaduraUsada = Equipamento.Armadura
	local TabelaDeScripts = {}
	table.insert(TabelaDeScripts,Habilidades:WaitForChild(Classe):GetChildren()[1]:Clone())
	table.insert(TabelaDeScripts,Armas[Configuracoes.EquipamentoPorClasse[Classe][1]]:GetChildren()[1]:Clone())
	table.insert(TabelaDeScripts,ScriptsDoModel:WaitForChild("Camera"):Clone())
	table.insert(TabelaDeScripts,ScriptsDoModel:WaitForChild("Animate"):Clone())
	table.insert(TabelaDeScripts,ScriptsDoModel:WaitForChild("Movimento"):Clone())
	table.insert(TabelaDeScripts,ScriptsDoModel:WaitForChild("AnimateServer"):Clone())
	table.insert(TabelaDeScripts,ScriptsDoModel:WaitForChild("ZonaMaker"):Clone())
	return true, ModelParaSpawn, ModelParaSpawn.Humanoid, TabelaDeScripts, CFrame.new(PosicaoSpawn[Time][math.random(1,#PosicaoSpawn[Time])].Position,Vector3.new(-662.273, 7.777, 459.583)) 
end

return Spawner

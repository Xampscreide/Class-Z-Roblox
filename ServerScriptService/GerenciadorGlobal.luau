local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage =game:GetService("ServerStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerService = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
--#####################################################################################################################################
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local Models = ServerStorage:WaitForChild("Models")
local SolicitarSpawn = EventosRemotos:WaitForChild("SolicitarSpawn")
local TabMenu = EventosRemotos:WaitForChild("TabMenu")
local ConfguracoesReplicated = ReplicatedStorage:WaitForChild("Configuração")
local MenuEvent = EventosRemotos:WaitForChild("Menu")
local SoundEvent = EventosRemotos:WaitForChild("Sound")
local DeathPlayer = EventosRemotos:WaitForChild("DeathPlayer")
local ResetPlayer = EventosRemotos:WaitForChild("ResetPlayer")
--#####################################################################################################################################
local SistemaCompra = require(ServerScriptService:WaitForChild("SistemaCompra"))
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local Classes = require(ConfguracoesReplicated:WaitForChild("Classes")) 
local InfoPlayer = require(ServerScriptService:WaitForChild("InfoPlayers"))
local Gerenciador = require(ServerScriptService:WaitForChild("Gerenciador"))
local Health = require(ServerScriptService:WaitForChild("Health"))
local MagicPoint = require(ServerScriptService:WaitForChild("MagicPoint"))
local Speed = require(ServerScriptService:WaitForChild("Speed"))
local DataManager = require(ServerScriptService:WaitForChild("DataManager"))
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))
local TeamCoisas = require(ServerScriptService:WaitForChild("TeamCoisas"))
local TempoDeClasse = require(ServerScriptService:WaitForChild("TempoDeClasse"))
local ProjetilSystem = require(ServerScriptService:WaitForChild("ProjetilSystem"))
local XPModule = require(ReplicatedStorage:WaitForChild("Modulos"):WaitForChild("XpCalculador"))
local Spawner = require(ServerScriptService:WaitForChild("Spawner"))
local LeaderBoardServer = require(ServerScriptService:WaitForChild("LeaderBoardServer"))
local SistemaPartida = require(ServerScriptService:WaitForChild("SistemaPartida"))
local AntCheatPosicao = require(ServerScriptService:WaitForChild("AntCheatPosicao"))
local Indikator = require(ServerScriptService:WaitForChild("Indikator"))
local BoosterManager = require(ServerScriptService:WaitForChild("BoosterManager"))
local EstatisticaPlayer = require(ServerScriptService:WaitForChild("EstatisticaPlayer"))
local Emblemas = require(ServerScriptService:WaitForChild("Emblemas"))
local Amigos = require(ServerScriptService:WaitForChild("Amigos"))
--#####################################################################################################################################

PlayerService.CharacterAutoLoads = false

local PlayerLoaded = {}

local PlayersVivos = {}

local function SinalizarMorte(Player:Player)
	local Kill, Damage, Heal = EstatisticaPlayer.RegistrarEstatistica(Player)
	local XPLive, Pontos = PlayerInfo.GetLiveXP(Player)
	DeathPlayer:FireClient(Player,string.pack("I2I3I3I3I3",Kill,Damage,Heal,Pontos,XPLive))
	SoundEvent:FireClient(Player,string.pack("I1",1))
end

local function FinalizarCharacter(Player:Player,Character:Model)
	for i,T in ipairs(Character:GetChildren()) do
		if T:IsA("Script") then T:Destroy() end
	end
	Player.Character = nil
	Character.Parent = workspace:WaitForChild("Projeteis")
	Character.Humanoid:Destroy()
	Character.HitBox.Dead:Emit(40)
	Character.PrimaryPart.Anchored = true
	Character:FindFirstChildOfClass("MeshPart").Transparency = 1
	Debris:AddItem(Character,.5)
end

local function PlayerMorreu(Player:Player)
	PlayersVivos[Player] = nil
	AntCheatPosicao.PausarMonitoramento(Player)
	Health.Terminar(Player)
	TempoDeClasse.FinalizarTemporizador(Player)
	BoosterManager.PausarTemporizador(Player)
	PlayerInfo.GetPlayer(Player).Effects = {}
	MagicPoint.Remover(Player)
	Speed.Remover(Player)
	Spawner.SetarUltimaMorte(Player)
	local Character = Player.Character
	Indikator.RemoverCharacter(Character,Player)
	FinalizarCharacter(Player,Character)
	SinalizarMorte(Player)
	InfoPlayer.AtualizarInformacoes(Player)
end

local function FinalizarPartida()
	LeaderBoardServer.Reset()
	for Player:Player,_ in pairs(PlayersVivos) do
		local Character = Player.Character
		PlayersVivos[Player] = nil
		AntCheatPosicao.PausarMonitoramento(Player)
		Health.Terminar(Player)
		TempoDeClasse.FinalizarTemporizador(Player)
		BoosterManager.PausarTemporizador(Player)
		PlayerInfo.GetPlayer(Player).Effects = {}
		MagicPoint.Remover(Player)
		Speed.Remover(Player)
		Spawner.SetarUltimaMorte(Player)
		Indikator.RemoverCharacter(Character,Player)
		if Character then FinalizarCharacter(Player,Character) end
		EstatisticaPlayer.RegistrarEstatistica(Player)
		PlayerInfo.ResetMatchStatistic(Player)
		InfoPlayer.AtualizarInformacoes(Player)
		MenuEvent:FireClient(Player)
	end
	Spawner.SetarTempoProximaPartida()
end

PlayerService.PlayerAdded:Connect(function(Player:Player)
	DataManager.loadData(Player)
	SistemaCompra.ChecarPasses(Player)
	EstatisticaPlayer.AdicionarPlayer(Player)
	SistemaPartida.AddPlayer(Player)
	TeamCoisas.ConfigurarTimeParaPlayer(Player)
	LeaderBoardServer.AddPlayer(Player)
	BoosterManager.CarregarBoosterPlayer(Player)
	InfoPlayer.EnviarInformacoes(Player)
	PlayerLoaded[Player] = true
end)

PlayerService.PlayerRemoving:Connect(function(Player:Player)
	EstatisticaPlayer.RemoverPlayer(Player)
	AntCheatPosicao.PausarMonitoramento(Player)
	AntCheatPosicao.ApagarInformacoes(Player)
	SistemaPartida.PlayerCaiu(Player)
	Health.Terminar(Player)
	Spawner.ApagarInformacoes(Player)
	TempoDeClasse.FinalizarTemporizador(Player)
	BoosterManager.PausarTemporizador(Player)
	MagicPoint.Remover(Player)
	TeamCoisas.ApagarInformacoes(Player)
	LeaderBoardServer.RemovePlayer(Player)
	ProjetilSystem.ApagarInformacaoPlayer(Player)
	DataManager.saveData(Player)
	PlayerLoaded[Player] = false
end)

SolicitarSpawn.OnServerInvoke = function(Player:Player)
	local Sucesso, Character:Model, Humanoid:Humanoid, Scripts, Cframe = Spawner.TentarSpawnar(Player)
	if Sucesso then
		PlayerInfo.UpdateStats(Player)
		TeamCoisas.ConfigurarCharacterPlayer(Player,Character)
		TempoDeClasse.IniciarTemporizador(Player)
		BoosterManager.IniciarTemporizador(Player)
		Speed.Adicionar(Player,Humanoid)
		Health.Adicionar(Player,Humanoid)
		MagicPoint.Adicionar(Player)
		Indikator.AdicionarCharacter(Character,Player)
		Player.Character = Character
		Character.PrimaryPart.CFrame = Cframe
		AntCheatPosicao.MonitorarPosicao(Player,Character)
		for i,Script in ipairs(Scripts) do Script.Parent = Character end
		PlayersVivos[Player] = true
		return true
	end
	return false
end

Health.SetarFuncaoDeMorte(PlayerMorreu)

AntCheatPosicao.SetarFuncaoDeMorte(PlayerMorreu)

SistemaPartida.BindarFuncao(FinalizarPartida)

ResetPlayer.OnServerEvent:Connect(function(Player:Player) 
	if Health.GetPlayerHealth(Player) then LeaderBoardServer.AddKillFeed(Player,nil) PlayerMorreu(Player) end
end)

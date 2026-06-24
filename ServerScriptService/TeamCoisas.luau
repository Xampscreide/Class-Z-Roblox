local Team = {}

local TeamService = game:GetService("Teams")
local PlayerService = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PastaCharacter = workspace:WaitForChild("Characters")

local PLAYERINFO = require(ServerScriptService:WaitForChild("_G.Players"))
local LeaderBoardServer = require(ServerScriptService:WaitForChild("LeaderBoardServer"))

local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local MudarTime = EventosRemotos:WaitForChild("TrocarTime")

Team.Orange = PastaCharacter:WaitForChild("Orange")
Team.Purple = PastaCharacter:WaitForChild("Purple")
Team.Main = PastaCharacter

local TimeLaranja = TeamService:WaitForChild("Orange")
local TimeRoxo = TeamService:WaitForChild("Purple")

Team.TimeLaranja = TimeLaranja
Team.TimeRoxo = TimeRoxo

local PastaOrange = PastaCharacter:WaitForChild("Orange")
local PastaPurple = PastaCharacter:WaitForChild("Purple")

local CharacterParaPlayer = {}

local TabelaLaranjaAmigo = {}
local TabelaRoxoAmigo = {}
local TabelaLaranjaInimigo = {}
local TabelaRoxoInimigo = {}

local TabelaRoxoUnhit = {}
local TabelaLaranjaUnhit = {}

function Team.ConfigurarTimeParaPlayer(Player:Player)
	local Time = Player.Team
	local PlayerInfo = PLAYERINFO.GetPlayer(Player)
	if Time.Name == "Orange" then
		if PlayerInfo.Config.RenderFriend then table.insert(TabelaLaranjaAmigo,Player) end
		if PlayerInfo.Config.RenderEnemy then
			if PlayerInfo.Config.UnhittableShot then
				table.insert(TabelaLaranjaUnhit,Player)
			else
				table.insert(TabelaLaranjaInimigo,Player)
			end 
		end
	else
		if PlayerInfo.Config.RenderFriend then table.insert(TabelaRoxoAmigo,Player) end
		if PlayerInfo.Config.RenderEnemy then
			if PlayerInfo.Config.UnhittableShot then
				table.insert(TabelaRoxoUnhit,Player)
			else
				table.insert(TabelaRoxoInimigo,Player)
			end 
		end
	end
end

function Team.ConfigurarCharacterPlayer(Player:Player,Character:Model)
	CharacterParaPlayer[Character] = Player
	Character.PrimaryPart.CFrame = CFrame.new(25, 12.5, -12)
	if tostring(Player.Team) == "Orange" then Character.Parent = PastaOrange
	else Character.Parent = PastaPurple end
end

function Team.ApagarInformacoes(Player:Player)
	local Time = Player.Team
	local PlayerPosInTable
	if Time.Name == "Orange" then
		PlayerPosInTable = table.find(TabelaLaranjaAmigo,Player)
		if PlayerPosInTable then table.remove(TabelaLaranjaAmigo,PlayerPosInTable) end
		PlayerPosInTable = table.find(TabelaLaranjaInimigo,Player)
		if PlayerPosInTable then table.remove(TabelaLaranjaInimigo,PlayerPosInTable) end
		PlayerPosInTable = table.find(TabelaLaranjaUnhit,Player)
		if PlayerPosInTable then table.remove(TabelaLaranjaUnhit,PlayerPosInTable) end
	else
		PlayerPosInTable = table.find(TabelaRoxoInimigo,Player)
		if PlayerPosInTable then table.remove(TabelaRoxoInimigo,PlayerPosInTable) end
		PlayerPosInTable = table.find(TabelaRoxoAmigo,Player)
		if PlayerPosInTable then table.remove(TabelaRoxoAmigo,PlayerPosInTable) end
		PlayerPosInTable = table.find(TabelaRoxoUnhit,Player)
		if PlayerPosInTable then table.remove(TabelaRoxoUnhit,PlayerPosInTable) end
	end
end

function Team.MudarConfiguracoesParaPlayer(Player:Player)
	Team.ApagarInformacoes(Player)
	Team.ConfigurarTimeParaPlayer(Player)
end


local function ChangePlayerTeam(Player:Player)
	local Time = Player.Team
	Team.ApagarInformacoes(Player)
	Player.Team = if Time.Name == "Orange" then TimeRoxo else TimeLaranja
	Team.ConfigurarTimeParaPlayer(Player)
end

function Team.PlayerMorreu(Player:Player,Character:Model)
	CharacterParaPlayer[Character] = nil
end

function CalcularProjetilPerto(Tabela,Posicao:Vector3,DirecaoDoProjetil:Vector3,DistanciaMaxima:number)
	local Send = {}
	pcall(function()
		for i,Player:Player in ipairs(Tabela) do
			if not Player.Character then continue end
			local PosicaoPlayer = Player.Character.PrimaryPart.Position
			if (PosicaoPlayer-Posicao).Magnitude <= DistanciaMaxima*1.5 then
				table.insert(Send,Player)
			end
		end
	end)
	return Send
end

function Team.TabelasDeSend(Player:Player,Posicao:Vector3,DirecaoDoProjetil:Vector3,DistanciaMaxima:number)
	local Time = Player.Team
	if Time.Name == "Orange" then
		return {TabelaLaranjaAmigo,CalcularProjetilPerto(TabelaRoxoUnhit,Posicao,DirecaoDoProjetil,DistanciaMaxima),TabelaRoxoInimigo}
	else
		return {TabelaRoxoAmigo,CalcularProjetilPerto(TabelaLaranjaUnhit,Posicao,DirecaoDoProjetil,DistanciaMaxima),TabelaLaranjaInimigo}
	end
end

function Team.TabelasDeSend2(Player:Player)
	local Time = Player.Team
	if Time.Name == "Orange" then
		return {TabelaLaranjaAmigo,TabelaRoxoUnhit,TabelaRoxoInimigo}
	else
		return {TabelaRoxoAmigo,TabelaLaranjaUnhit,TabelaLaranjaInimigo}
	end
end

function Team.TabelaDeDistanciaAmigos(Player:Player,Origem:Vector3,DistanciaMaxima:number?)
	local Time = if Player.Team.Name == "Orange" then PastaOrange else PastaPurple
	local TabelaDistancias, TabelaPlayers = {}, {}
	for Pos,Character:Model in ipairs(Time:GetChildren()) do
		local Distancia = (Character.PrimaryPart.Position-Origem).Magnitude
		if not DistanciaMaxima then table.insert(TabelaDistancias,Distancia);table.insert(TabelaPlayers,CharacterParaPlayer[Character])
		elseif Distancia <= DistanciaMaxima then table.insert(TabelaDistancias,Distancia);table.insert(TabelaPlayers,CharacterParaPlayer[Character]) end
	end
	return TabelaDistancias, TabelaPlayers
end

function Team.TabelaDeDistanciaInimigos(Player:Player,Origem:Vector3,DistanciaMaxima:number?)
	local Time = if Player.Team.Name == "Orange" then PastaPurple else PastaOrange
	local TabelaDistancias, TabelaPlayers = {}, {}
	for Pos,Character:Model in ipairs(Time:GetChildren()) do
		local Distancia = (Character.PrimaryPart.Position-Origem).Magnitude
		if not DistanciaMaxima then table.insert(TabelaDistancias,Distancia);table.insert(TabelaPlayers,CharacterParaPlayer[Character])
		elseif Distancia <= DistanciaMaxima then table.insert(TabelaDistancias,Distancia);table.insert(TabelaPlayers,CharacterParaPlayer[Character]) end
	end
	return TabelaDistancias, TabelaPlayers
end

function Team.TabelaDeDistanciaAmigoPlayer(Player:Player,DistanciaMaxima:number?)
	local Origem = Player.Character and Player.Character.PrimaryPart.Position or Vector3.new(1e99,1e99,1e99)
	local Distancias, Players = Team.TabelaDeDistanciaAmigos(Player,Origem,DistanciaMaxima)
	return Distancias, Players
end

function Team.TabelaDeDistanciaInimigoPlayer(Player:Player,DistanciaMaxima:number?)
	local Origem = Player.Character and Player.Character.PrimaryPart.Position or Vector3.new(1e99,1e99,1e99)
	local Distancias, Players = Team.TabelaDeDistanciaInimigos(Player,Origem,DistanciaMaxima)
	return Distancias, Players
end

function Team.InimigoMaisProximoInimigo(PlayerInimigo:Player,DistanciaMaxima:number,Exclusao:{Player})
	local Time = if PlayerInimigo.Team.Name == "Orange" then PastaOrange else PastaPurple
	local Origem = PlayerInimigo.Character and PlayerInimigo.Character.PrimaryPart.Position or Vector3.new(1e99,1e99,1e99)
	local MenorEncontrado = math.huge
	local PlayerMaisProximo
	for Pos,Character:Model in ipairs(Time:GetChildren()) do
		local Distancia = (Character.PrimaryPart.Position-Origem).Magnitude
		local PlayerTeste = CharacterParaPlayer[Character]
		if Distancia < DistanciaMaxima and Distancia < MenorEncontrado and not table.find(Exclusao,PlayerTeste) then
			MenorEncontrado = Distancia
			PlayerMaisProximo = PlayerTeste
		end
	end
	return PlayerMaisProximo
end

function Team.PlayerMaisPertoPosicao(Time:Team,Origem:Vector3,DistanciaMaxima:number):Player
	Time = if Time.Name == "Orange" then PastaOrange else PastaPurple
	Origem = Vector3.new(Origem.X,0,Origem.Z)
	local Player = nil
	local MenorDistancia = DistanciaMaxima+1
	for Pos,Character:Model in ipairs(Time:GetChildren()) do
		local PosicaoPlayer = Character.PrimaryPart.Position
		PosicaoPlayer = Vector3.new(PosicaoPlayer.X,0,PosicaoPlayer.Z)
		local Distancia = (PosicaoPlayer-Origem).Magnitude
		local PlayerTeste = CharacterParaPlayer[Character]
		if Distancia <= DistanciaMaxima and Distancia<MenorDistancia then
			Player = PlayerTeste
			MenorDistancia = Distancia
		end
	end
	return Player
end

MudarTime.OnServerInvoke = function(Player:Player)
	local Time = Player.Team
	local OutroTime:Team = if Time == TimeLaranja then TimeRoxo else TimeLaranja
	if #OutroTime:GetPlayers() >= #Time:GetPlayers() then return false end
	if Player.Character then return false end
	ChangePlayerTeam(Player)
	LeaderBoardServer.TrocarTime(Player)
	return true, Time == TimeLaranja and 2 or 1
end

return Team

--!native
local AntCheatPosicao = {}

local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")

local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))

local SteveModel = workspace:WaitForChild("Steve")
local SteveEvent = EventosRemotos:WaitForChild("Steve")

local PlayersMonitorados:{Player} = {}
local TabelaDeInsercao = {}
local PosicaoDosPlayers = {}
local PlayerDash = {}
local PeriodoVerificacao = 1
local PeriodoVerificacaoDesativador = .5
local Tolerancia = 1.2
local Penalidade = 1
local LimiteInferior = -5
local UltimaVerificacao = os.clock()+PeriodoVerificacao
local UltimaVerificacaoDesativador = os.clock()+PeriodoVerificacaoDesativador

local MatarPlayer

local RayCastParans = RaycastParams.new()
RayCastParans.FilterType = Enum.RaycastFilterType.Exclude
RayCastParans.FilterDescendantsInstances = {workspace:WaitForChild("Projeteis"),workspace:WaitForChild("Characters")}

local VETORUP = Vector3.new(0,1,0)
local VETORDOWN = Vector3.new(0,-5000,0)
local VETORDEFAULT = Vector3.new(1e99,1e99,1e99)

local InformacaoFrames = {}
local SizeInformacaoFrame = 180
local RegistradorAtual
local TempoParaDesligarPlayer = .1

local InformacaoSteveFrames = {}

for i=1,SizeInformacaoFrame do
	InformacaoFrames[i] = {workspace:GetServerTimeNow(),{}}
	InformacaoSteveFrames[i] = {workspace:GetServerTimeNow(),VETORDEFAULT}
end

for i=1,SizeInformacaoFrame do
	InformacaoFrames[i][3] = InformacaoFrames[i%SizeInformacaoFrame+1]
	InformacaoFrames[i][4] = InformacaoFrames[(i-2)%SizeInformacaoFrame+1]
	InformacaoSteveFrames[i][3] = InformacaoSteveFrames[i%SizeInformacaoFrame+1]
	InformacaoSteveFrames[i][4] = InformacaoSteveFrames[(i-2)%SizeInformacaoFrame+1]
end

local UltimaChamadaPlayer = {}
local PlayersDesligados = {}
local PosicaoRelativa = {}

local Meta = {__index = function(self,Index)
	self[Index] = {
		{13},
		{13},
		{13},
	}
	self[Index][1][2] = self[Index][2]
	self[Index][2][2] = self[Index][3]
	self[Index][3][2] = self[Index][1]
	self[Index][4] = self[Index][1]
	UltimaChamadaPlayer[Index] = os.clock()+TempoParaDesligarPlayer
	return self[Index]
end,}
setmetatable(PosicaoRelativa,Meta)

local UltimosErrosDeVerificacao = {}
local MetaUltimosErros = {__index = function(self,Index)
	self[Index] = {}
	return self[Index]
end,}
setmetatable(UltimosErrosDeVerificacao,MetaUltimosErros)
local ContadorDeVerificacao = {}
local MetaContador = {__index = function(self,index)
	self[index] = 0
	return 0
end,}
setmetatable(ContadorDeVerificacao,MetaContador)
local PlayerComFalhaSeveraVerificacao = {}
local ContadorDeFalhasDeVerificacao = 0
local VerificarPosicaoDesativado = false

local function TravarPlayer(Player:Player,Posicao:Vector3)
	Player.Character.PrimaryPart.CFrame = CFrame.new(Posicao)
	Player.Character.PrimaryPart:SetNetworkOwner(nil)
	task.delay(Penalidade,function()
		if Player.Character then
			Player.Character.PrimaryPart:SetNetworkOwner(Player) 
		end
	end)
end

local RegistradorAtual = InformacaoFrames[1]
local RegistradorAtualSteve = InformacaoSteveFrames[1]
RunService.Heartbeat:Connect(function(DeltaTime)

	for Player:Player,Character:Model in pairs(PlayersMonitorados) do
		local Posicao = Character.PrimaryPart.Position
		if Posicao.Y < LimiteInferior or Posicao.X < -1004 or Posicao.X > -161 or Posicao.Z < -23 or Posicao.Z > 874 then print("Fora da Zona") MatarPlayer(Player) end
		local RayCast = workspace:Raycast(Posicao,VETORDOWN,RayCastParans)
		if not RayCast then MatarPlayer(Player)
		elseif RayCast.Distance > Character.HitBox.Size.X then print("ProblemaDeAltura") TravarPlayer(Player,RayCast.Position+Vector3.new(0,Character.HitBox.Size.X/2,0)) end
	end

	local TempoAtual = os.clock()
	if TempoAtual>UltimaVerificacao then
		local DeltaTimeVerificacao = TempoAtual-UltimaVerificacao+PeriodoVerificacao
		UltimaVerificacao = TempoAtual+PeriodoVerificacao
		for Player:Player,Posicao in pairs(PosicaoDosPlayers) do
			local PosicaoAtual = Player.Character.PrimaryPart.Position
			local DeltaPos = (PosicaoAtual-Posicao):Cross(VETORUP)
			local SpeedDoPlayer = PlayerInfo.Velocidade(Player)
			if DeltaPos.Magnitude/DeltaTimeVerificacao > SpeedDoPlayer*Tolerancia then
				if true then PosicaoDosPlayers[Player] = PosicaoAtual continue end
				local Historico = PlayerInfo.Historico(Player,"Speedy") or PlayerInfo.Historico(Player,"SpeedyMode")
				local Slow = PlayerInfo.Effect(Player,"Slowed")
				local Paralyzed = PlayerInfo.Effect(Player,"Paralyzed")
				local Stasis = PlayerInfo.Effect(Player,"Stasis")
				if PlayerDash[Player] and TempoAtual<PlayerDash[Player][1] and (DeltaPos.Magnitude-PlayerDash[Player][2]*PlayerDash[Player][3])/DeltaTimeVerificacao < SpeedDoPlayer*Tolerancia then
					PosicaoDosPlayers[Player] = PosicaoAtual
					continue
				end
				if Historico and TempoAtual-Historico[2]<1.2 then
					PosicaoDosPlayers[Player] = PosicaoAtual
					continue
				end
				if Slow and TempoAtual-Slow.Horario<1.2 then
					PosicaoDosPlayers[Player] = PosicaoAtual
					continue
				end
				if Paralyzed and TempoAtual-Paralyzed.Horario<1.2 then
					PosicaoDosPlayers[Player] = PosicaoAtual
					continue
				end
				if Stasis and TempoAtual-Stasis.Horario<1.2 then
					PosicaoDosPlayers[Player] = PosicaoAtual
					continue
				end
				print("Erro na Velocidade",DeltaPos.Magnitude,SpeedDoPlayer-DeltaPos.Magnitude/DeltaTimeVerificacao)
				TravarPlayer(Player,Posicao)
				continue
			end
			PosicaoDosPlayers[Player] = PosicaoAtual
		end
		for i,Player:Player in ipairs(TabelaDeInsercao) do
			if Player.Character then
				PosicaoDosPlayers[Player] = Player.Character.PrimaryPart.Position
			end
		end
		TabelaDeInsercao = {}
	end

	RegistradorAtualSteve = RegistradorAtualSteve[3]
	RegistradorAtualSteve[1] = workspace:GetServerTimeNow()
	RegistradorAtualSteve[2] = SteveModel.PrimaryPart.Position
	RegistradorAtual = RegistradorAtual[3]
	RegistradorAtual[1] = workspace:GetServerTimeNow()
	table.clear(RegistradorAtual[2])
	for Pos,Player:Player in ipairs(PlayerService:GetPlayers()) do
		RegistradorAtual[2][Player] = Player.Character and Player.Character.HitBox.Position or VETORDEFAULT
	end

	local ClockAtual = os.clock()
	for Player:Player,UltimoTempo in pairs(UltimaChamadaPlayer) do
		if ClockAtual > UltimoTempo then
			PlayersDesligados[Player] = true
			PosicaoRelativa[Player][4][2][1] = 12
		end
	end
	
	if TempoAtual>UltimaVerificacaoDesativador then
		UltimaVerificacaoDesativador = TempoAtual+PeriodoVerificacaoDesativador
		for i,Player:Player in ipairs(PlayerService:GetPlayers()) do
			local ContadorAtual = ContadorDeVerificacao[Player]
			local ErrosDoPlayer = UltimosErrosDeVerificacao[Player]
			local NumeroDeFalhas = #ErrosDoPlayer
			if NumeroDeFalhas < 10 then continue end
			local ContadorDeProximidade = 0
			for i = NumeroDeFalhas-9,NumeroDeFalhas do
				local ContadorDaFalha = ErrosDoPlayer[i]
				if ContadorAtual-ContadorDaFalha <= 10 then
					ContadorDeProximidade += 1
				end
			end
			if ContadorDeProximidade >= 5 and not PlayerComFalhaSeveraVerificacao[Player] then
				ContadorDeFalhasDeVerificacao += 1
				PlayerComFalhaSeveraVerificacao[Player] = true
			elseif PlayerComFalhaSeveraVerificacao[Player] then
				ContadorDeFalhasDeVerificacao -= 1
				PlayerComFalhaSeveraVerificacao[Player] = nil
			end
			if NumeroDeFalhas > 100 then
				local Novo = {}
				local j = 1
				for i=NumeroDeFalhas-19,NumeroDeFalhas do
					Novo[j] = ErrosDoPlayer[i]
					j += 1
				end
				UltimosErrosDeVerificacao[Player] = Novo
			end
		end
		VerificarPosicaoDesativado = ContadorDeFalhasDeVerificacao > #PlayerService:GetPlayers()/2
	end
end)

function PegarRelativo(Player:Player)
	return  PosicaoRelativa[Player][4][2][1]
end

local function PlayerFalhouVerificacao(Player:Player)
	table.insert(UltimosErrosDeVerificacao[Player],ContadorDeVerificacao[Player])
end

function AntCheatPosicao.VerificarPosicaoDoPlayer(PlayerAutor:Player,PlayerAlvo:Player,PosicaoDaInstancia:Vector3)
	local t1 = os.clock()
	if RunService:IsStudio() then return true end
	if PlayersDesligados[PlayerAlvo] then return true end
	ContadorDeVerificacao[PlayerAutor] += 1
	local PlayerPing = PlayerAutor:GetNetworkPing()
	local HorarioDoHit = workspace:GetServerTimeNow()-PlayerPing

	local FrameAtual = RegistradorAtual
	local DiferencaAtual = math.abs(FrameAtual[1] - HorarioDoHit)
	local DiferencaProxima = math.abs(FrameAtual[4][1] - HorarioDoHit)
	while DiferencaProxima < DiferencaAtual do
		FrameAtual = FrameAtual[4]
		DiferencaAtual = DiferencaProxima
		DiferencaProxima = math.abs(FrameAtual[4][1] - HorarioDoHit)
	end

	local RelativaSteve = PegarRelativo(PlayerAutor)
	for i=1,RelativaSteve-7 do
		FrameAtual = FrameAtual[4]
	end

	local IDoMaisPerto
	local MenorDistancia = math.huge
	for i=1,10 do
		local VetorDiferenca:Vector3 = PosicaoDaInstancia-FrameAtual[2][PlayerAlvo]
		local Distancia = VetorDiferenca:Cross(VETORUP).Magnitude
		if Distancia < .3 then
			return true
		end
		if Distancia < MenorDistancia then
			MenorDistancia = Distancia
			IDoMaisPerto = i
		end

		local Vetor = FrameAtual[2][PlayerAlvo]-FrameAtual[4][2][PlayerAlvo]
		local Cos1 = VetorDiferenca:Dot(Vetor)
		local Cos2 = (PosicaoDaInstancia-FrameAtual[4][2][PlayerAlvo]):Dot(Vetor)
		if Cos1*Cos2 <= 0 then
			local Distancia2 = VetorDiferenca:Cross(Vetor.Unit).Magnitude
			if Distancia2 < 0.05 then
				return true
			end
		end
		FrameAtual = FrameAtual[4]
	end
	
	print("Verificacao Posicao Falhou",IDoMaisPerto,string.format("%.3f",MenorDistancia),RelativaSteve)
	PlayerFalhouVerificacao(PlayerAutor)
	return VerificarPosicaoDesativado
end

function AntCheatPosicao.MonitorarPosicaoPlayer(Player:Player,Posicao:Vector3)
	task.spawn(function()
		local MenorDistancia = math.huge
		local SalvarContador
		local PosicaoAnterior = Player.Character.PrimaryPart.Position
		if (PosicaoAnterior-Posicao).Magnitude < .3 then return end
		for i=1,10 do
			task.wait()
			local PosicaoAtual = Player.Character.PrimaryPart.Position
			local VetorDiferenca = (Posicao-PosicaoAtual)
			local Distancia = VetorDiferenca:Cross(VETORUP).Magnitude
			if Distancia < .3 then
				return
			end
			local DeltaPos = PosicaoAtual-PosicaoAnterior
			local Cos1 = VetorDiferenca:Dot(DeltaPos)
			local Cos2 = (Posicao-PosicaoAnterior):Dot(DeltaPos)
			if Cos1*Cos2 <= 0 then
				local Distancia2 = VetorDiferenca:Cross(DeltaPos.Unit).Magnitude
				if Distancia2 < 0.05 then
					return
				end
			end
		end
	end)
end

function AntCheatPosicao.MonitorarPosicao(Player:Player,Character:Model)
	PlayersMonitorados[Player] = Character
	table.insert(TabelaDeInsercao,Player)
end

function AntCheatPosicao.PausarMonitoramento(Player:Player)
	PlayersMonitorados[Player] = nil
	PosicaoDosPlayers[Player] = nil
	PlayerDash[Player] = nil
	PosicaoRelativa[Player] = nil
	UltimaChamadaPlayer[Player] = nil
	PlayersDesligados[Player] = nil
end

function AntCheatPosicao.ApagarInformacoes(Player:Player)
	if PlayerComFalhaSeveraVerificacao[Player] then
		ContadorDeFalhasDeVerificacao -= 1
		PlayerComFalhaSeveraVerificacao[Player] = nil
	end
	ContadorDeVerificacao[Player] = nil
	UltimosErrosDeVerificacao[Player] = nil
end

function AntCheatPosicao.RegistrarDash(Player:Player,VetorDiferenca:Vector3)
	if PlayerDash[Player] then PlayerDash[Player][3] += 1 
	else PlayerDash[Player] = {os.clock()+2,VetorDiferenca.Magnitude,1} end
	task.delay(2,function()
		if not PlayerDash[Player] then return end
		PlayerDash[Player][3] -= 1
		if PlayerDash[Player][3] <= 0 then PlayerDash[Player] = nil end
	end)
end

function AntCheatPosicao.SetarFuncaoDeMorte(Funcao) MatarPlayer = Funcao end

function RegistrarRelativa(Player:Player,IRelativo:number)
	PosicaoRelativa[Player][4][1] = IRelativo
	PosicaoRelativa[Player][4] = PosicaoRelativa[Player][4][2]
end

function Calcular(Player:Player,PosicaoDoSteve:Vector3)
	local PlayerPing = Player:GetNetworkPing()
	local HorarioDoHit = workspace:GetServerTimeNow()-PlayerPing

	local FrameAtual = RegistradorAtualSteve
	local DiferencaAtual = math.abs(FrameAtual[1] - HorarioDoHit)
	local DiferencaProxima = math.abs(FrameAtual[4][1] - HorarioDoHit)
	while DiferencaProxima < DiferencaAtual do
		FrameAtual = FrameAtual[4]
		DiferencaAtual = DiferencaProxima
		DiferencaProxima = math.abs(FrameAtual[4][1] - HorarioDoHit)
	end

	local IDoMaisPerto
	local MenorDistancia = math.huge
	for i=1,30 do
		local Distancia = (PosicaoDoSteve-FrameAtual[2]):Cross(VETORUP).Magnitude
		if Distancia < MenorDistancia then
			MenorDistancia = Distancia
			IDoMaisPerto = i
		end
		FrameAtual = FrameAtual[4]
	end	
	RegistrarRelativa(Player,IDoMaisPerto)
end

SteveEvent.OnServerEvent:Connect(function(Player:Player,PosicaoDoSteve:Vector3)
	PlayersDesligados[Player] = false
	UltimaChamadaPlayer[Player] = os.clock()+TempoParaDesligarPlayer
	Calcular(Player,PosicaoDoSteve)
end)

_G.AntCheatStatus = function()
	print("VerificarPosicaoDesativado",VerificarPosicaoDesativado)
	print("ContadorDeFalhasDeVerificacao",ContadorDeFalhasDeVerificacao)
	for i,Player in ipairs(PlayerService:GetPlayers()) do
		print(Player.Name,PegarRelativo(Player))
	end
end

return AntCheatPosicao

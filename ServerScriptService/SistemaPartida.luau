local Partida = {}

local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TeamCoisas = require(ServerScriptService:WaitForChild("TeamCoisas"))
local Health = require(ServerScriptService:WaitForChild("Health"))
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))
local XPController = require(ServerScriptService:WaitForChild("XpController"))
local EstatisticaPlayer = require(ServerScriptService:WaitForChild("EstatisticaPlayer"))
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local PegouABandeira = EventosRemotos:WaitForChild("PegouABandeira")
local PartidaEvento = EventosRemotos:WaitForChild("Partida")
local PastaBandeiras = workspace:WaitForChild("Bandeiras")
local FuncTemporizador = EventosRemotos:WaitForChild("Temporizador")
local SistemaMensagem = require(ServerScriptService:WaitForChild("SistemaMensagem"))

local InformarPlayer = ReplicatedStorage:WaitForChild("Bandeira")

local TimeRoxo = TeamCoisas.TimeRoxo
local TimeLaranja = TeamCoisas.TimeLaranja

local Laranja = 1
local Roxa = 2
local DistanciaMaximaParaPegarBandeira = 10
local PontuacaoMaxima = 100
local PontosPorCapturarBandeira = 25
local TempoParaVoltarBandeira = 10

local Temporizador = os.clock()
local BandeirasFisicas:{MeshPart} = {PastaBandeiras:WaitForChild("Laranja").PrimaryPart,PastaBandeiras:WaitForChild("Roxa").PrimaryPart}
local Times:{Team} = {TeamCoisas.TimeLaranja,TeamCoisas.TimeRoxo}
local PosicoesDefault:{Vector3} = {BandeirasFisicas[1].Position,BandeirasFisicas[2].Position}
local PosicaoAtualDasBandeiras:{Vector3} = {PosicoesDefault[1],PosicoesDefault[2]}
local ABandeiraEstaDropada:{boolean} = {false,false}
local PlayerQueEstaCarregandoABandeira:{Player} = {nil,nil}
local TimeParaBandeira = {};TimeParaBandeira[TimeRoxo] = 2;TimeParaBandeira[TimeLaranja] = 1
local PontuacaoDosTimes = {0,0}
local TempoPlayerEmCadaTime = {{},{}}
local TempoQuePegou = {{},{}}
local TempoQueLargou = {math.huge,math.huge}

local RayCastParans = RaycastParams.new()
RayCastParans.FilterType = Enum.RaycastFilterType.Exclude
RayCastParans.FilterDescendantsInstances = {workspace:WaitForChild("Projeteis"),workspace:WaitForChild("Characters")}

local BonusVencer = .3
local BonusPerder = .1

FuncTemporizador.OnServerInvoke = function(Player:Player)
	PartidaEvento:FireClient(Player,string.pack("I1I4d",6,os.clock()-Temporizador,workspace:GetServerTimeNow()))
end

local function IniciarOutraPartida()
	Temporizador = os.clock()
	PartidaEvento:FireAllClients(string.pack("I1I4d",6,os.clock()-Temporizador,workspace:GetServerTimeNow()))
end

local FuncaoDeFinalizar
local function FinalizarPartida()
	FuncaoDeFinalizar()
end

local function TimeGanhouPartida(Bandeira)
	PontuacaoDosTimes[1] = 0
	PontuacaoDosTimes[2] = 0
	if PlayerQueEstaCarregandoABandeira[1] then PegouABandeira:FireClient(PlayerQueEstaCarregandoABandeira[1],false) end
	if PlayerQueEstaCarregandoABandeira[2] then PegouABandeira:FireClient(PlayerQueEstaCarregandoABandeira[2],false) end		
	PlayerQueEstaCarregandoABandeira = {nil,nil}
	for Player:Player,XPDasClasses in pairs(PlayerInfo.GetAllPlayers()) do
		if not TempoPlayerEmCadaTime[1][Player] or not TempoPlayerEmCadaTime[2][Player] then continue end
		local Envio = {}
		local BonusDoPlayer = if TempoPlayerEmCadaTime[Bandeira][Player] > TempoPlayerEmCadaTime[Bandeira%2+1][Player] then BonusVencer else BonusPerder
		local XPPartida = PlayerInfo.GetXPPartida(Player)
		for NomeClasse,Valor in pairs(XPPartida) do
			if Valor <= 0 then continue end
			Envio[NomeClasse] = Valor*BonusDoPlayer
			PlayerInfo.AddXPPartida(Player,Valor*BonusDoPlayer,NomeClasse)
		end
		SistemaMensagem.BonusDePartida(Player,Envio,TempoPlayerEmCadaTime[Bandeira][Player] > TempoPlayerEmCadaTime[Bandeira%2+1][Player])
	end
	FinalizarPartida()
	IniciarOutraPartida()
end

local function RetornarBandeira(Bandeira)
	PosicaoAtualDasBandeiras[Bandeira] = PosicoesDefault[Bandeira]
	BandeirasFisicas[Bandeira].CFrame = CFrame.new(PosicaoAtualDasBandeiras[Bandeira])
end

local function TirarSoldaEMover(Bandeira)
	if BandeirasFisicas[Bandeira].Weld then BandeirasFisicas[Bandeira].Weld:Destroy() end
	BandeirasFisicas[Bandeira].Anchored = true
	local RayCast = workspace:Raycast(PosicaoAtualDasBandeiras[Bandeira],Vector3.new(0,-1000,0),RayCastParans)
	if RayCast then BandeirasFisicas[Bandeira].CFrame = CFrame.new(RayCast.Position+Vector3.new(0,BandeirasFisicas[Bandeira].Size.Y/2,0))  
	else BandeirasFisicas[Bandeira].CFrame = CFrame.new(PosicaoAtualDasBandeiras[Bandeira]) end
end

local function PlayerCarregandoMorreu(Player:Player)
	PegouABandeira:FireClient(Player,false)
	local Bandeira = if PlayerQueEstaCarregandoABandeira[Laranja] == Player then Laranja else Roxa
	PartidaEvento:FireAllClients(string.pack("I1I1",4,Bandeira))
	TempoQueLargou[Bandeira] = os.clock()
	PlayerQueEstaCarregandoABandeira[Bandeira] = nil
	ABandeiraEstaDropada[Bandeira] = true
	TirarSoldaEMover(Bandeira)
	Health.PlayerDeadEventDisconectar(Player)
end

local function PlayerPegouBandeira(Bandeira,Player:Player)
	PegouABandeira:FireClient(Player,true,PosicoesDefault[Bandeira%2+1])
	PartidaEvento:FireAllClients(string.pack("I1I1",1,Bandeira))
	BandeirasFisicas[Bandeira].Anchored = false
	local Weld = Instance.new("Weld",BandeirasFisicas[Bandeira])
	Weld.Part0 = Weld.Parent
	Weld.Part1 = Player.Character.PrimaryPart
	Weld.C0 = CFrame.new(1,-3,0)
	PlayerQueEstaCarregandoABandeira[Bandeira] = Player
	PosicaoAtualDasBandeiras[Bandeira] = Player.Character.PrimaryPart.Position
	TempoQuePegou[Bandeira] = {os.clock(),PosicaoAtualDasBandeiras[Bandeira]}
	Health.PlayerDeadEvent(Player,PlayerCarregandoMorreu)
end

local function PlayerRetornouBandeira(Bandeira,Player:Player)
	PartidaEvento:FireAllClients(string.pack("I1I1",2,Bandeira))
	ABandeiraEstaDropada[Bandeira] = false
	RetornarBandeira(Bandeira)
end

local function PlayerCapturouABandeira(Bandeira)
	local Player = PlayerQueEstaCarregandoABandeira[Bandeira]
	PegouABandeira:FireClient(Player,false)
	Health.PlayerDeadEventDisconectar(Player)
	PosicaoAtualDasBandeiras[Bandeira] = PosicoesDefault[Bandeira]
	TirarSoldaEMover(Bandeira)
	PlayerQueEstaCarregandoABandeira[Bandeira] = nil
	
	local DiferencaPosicao = (PosicoesDefault[Bandeira%2+1]-TempoQuePegou[Bandeira][2]).Magnitude
	local DiferencaTempo = os.clock()-TempoQuePegou[Bandeira][1]
	local VelocidadePlayer = PlayerInfo.Velocidade(Player)*1.5
	local VelocidadeCalculada = DiferencaPosicao/DiferencaTempo
	if VelocidadeCalculada>VelocidadePlayer and DiferencaPosicao > 80 then
		return
	end
	PartidaEvento:FireAllClients(string.pack("I1I1",3,Bandeira))
	PontuacaoDosTimes[Bandeira%2+1] += PontosPorCapturarBandeira
	
	EstatisticaPlayer.Capture(Player)
	XPController.Captura(Player)
	if PontuacaoDosTimes[Bandeira%2+1] >= PontuacaoMaxima then TimeGanhouPartida(Bandeira%2+1) end
end

function Partida.PlayerCaiu(Player:Player)
	if PlayerQueEstaCarregandoABandeira[1] == Player or PlayerQueEstaCarregandoABandeira[2] == Player then PlayerCarregandoMorreu(Player) end
end

function Partida.AddPlayer(Player:Player)
	TempoPlayerEmCadaTime[1][Player] = 0
	TempoPlayerEmCadaTime[2][Player] = 0
end

function Partida.AdicionarTempo(Player:Player,Tempo:number)
	TempoPlayerEmCadaTime[TimeParaBandeira[Player.Team]][Player] += Tempo
end

function Partida.BindarFuncao(Funcao)
	FuncaoDeFinalizar = Funcao
end

function Partida.AdicionarPontuacaoMorte(Player:Player)
	local Bandeira = TimeParaBandeira[Player.Team]
	PontuacaoDosTimes[Bandeira] += .5
	if PontuacaoDosTimes[Bandeira%2+1] >= PontuacaoMaxima then TimeGanhouPartida(Bandeira%2+1) end
end
	
local ContadorDaAtualizacao = 0
RunService.Heartbeat:Connect(function(DeltaTime:number)
	for i=1,2 do
		if not PlayerQueEstaCarregandoABandeira[i] then
			if ABandeiraEstaDropada[i] then
				local Player = TeamCoisas.PlayerMaisPertoPosicao(Times[i%2+1],PosicaoAtualDasBandeiras[i],DistanciaMaximaParaPegarBandeira)
				if Player then PlayerPegouBandeira(i,Player) continue end
				local Player = TeamCoisas.PlayerMaisPertoPosicao(Times[i],PosicaoAtualDasBandeiras[i],DistanciaMaximaParaPegarBandeira)
				if Player then PlayerRetornouBandeira(i,Player) end
			else
				local Player = TeamCoisas.PlayerMaisPertoPosicao(Times[i%2+1],PosicaoAtualDasBandeiras[i],DistanciaMaximaParaPegarBandeira)
				if Player then PlayerPegouBandeira(i,Player) end
			end
		else
			PosicaoAtualDasBandeiras[i] = PlayerQueEstaCarregandoABandeira[i].Character.PrimaryPart.Position
			local P1, P2 = Vector3.new(PosicaoAtualDasBandeiras[i].X,0,PosicaoAtualDasBandeiras[i].Z), Vector3.new(PosicoesDefault[i%2+1].X,0,PosicoesDefault[i%2+1].Z)
			if (P1-P2).Magnitude < DistanciaMaximaParaPegarBandeira then PlayerCapturouABandeira(i) end
		end
	end
	ContadorDaAtualizacao += 1
	if ContadorDaAtualizacao%60 == 1 then
		PartidaEvento:FireAllClients(string.pack("I1I3I3",5,PontuacaoDosTimes[1],PontuacaoDosTimes[2]))
	end
	for i=1,2 do
		if TempoQueLargou[i]+TempoParaVoltarBandeira < os.clock() then
			TempoQueLargou[i] = math.huge
			RetornarBandeira(1)
		end
	end
end)

return Partida

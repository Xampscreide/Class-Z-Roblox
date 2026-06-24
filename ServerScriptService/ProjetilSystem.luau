local ProjetilSystem = {}

local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerService = game:GetService("Players")
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))
local ConversorDeStatus = require(ServerScriptService:WaitForChild("ConversorDeStatus"))
local Team = require(ServerScriptService:WaitForChild("TeamCoisas"))
local Gerenciador = require(ServerScriptService:WaitForChild("Gerenciador"))
local AntCheatPosicao = require(ServerScriptService:WaitForChild("AntCheatPosicao"))
local EstatisticaPlayer = require(ServerScriptService:WaitForChild("EstatisticaPlayer"))

local InformarProjetilEHit = require(script:WaitForChild("InformarProjetilEHit"))

local RayCastParans = RaycastParams.new()
RayCastParans.FilterType = Enum.RaycastFilterType.Exclude
RayCastParans.FilterDescendantsInstances = {workspace:WaitForChild("Projeteis"),workspace:WaitForChild("Characters")}
local RayCastTerrain = RaycastParams.new()
RayCastTerrain.FilterType = Enum.RaycastFilterType.Include
RayCastTerrain.FilterDescendantsInstances = {workspace:WaitForChild("Terrain")}

local InformacaoFrames = {}
local SizeInformacaoFrame = 180
local ProjeteisAtivos = {}
local HistoricoDeTiros = {}
local UltimoTempoInformado = {}

local Meta = {__index = function(self,Index)
	self[Index] = 0
	return 0
end,}

setmetatable(UltimoTempoInformado,Meta)
setmetatable(HistoricoDeTiros,Meta)

local VETORDEFAULT = Vector3.new(1e99,1e99,1e99)
local VETORUP = Vector3.new(0,1,0)
local Rad90 = math.rad(90)

for i=1,SizeInformacaoFrame do
	InformacaoFrames[i] = {workspace:GetServerTimeNow(),{}}
end

for i=1,SizeInformacaoFrame do
	InformacaoFrames[i][3] = InformacaoFrames[i%SizeInformacaoFrame+1]
	InformacaoFrames[i][4] = InformacaoFrames[(i-2)%SizeInformacaoFrame+1]
end

local TabelaDeThread = {}

local DeltaTime
local RegistradorAtual = InformacaoFrames[1]
RunService.Heartbeat:Connect(function(Deltatime)
	DeltaTime = Deltatime
	RegistradorAtual = RegistradorAtual[3]
	RegistradorAtual[1] = workspace:GetServerTimeNow()
	table.clear(RegistradorAtual[2])
	for Pos,Player:Player in ipairs(PlayerService:GetPlayers()) do
		RegistradorAtual[2][Player] = Player.Character and Player.Character.PrimaryPart.Position or VETORDEFAULT
	end

	local Remove = {}
	for Pos,Thread in ipairs(TabelaDeThread) do
		local _, Sucesso = coroutine.resume(Thread)
		if Sucesso then
			coroutine.close(Thread)
			table.insert(Remove,Pos)
		end
	end
	for i=1,#Remove do
		table.remove(TabelaDeThread,table.remove(Remove))
	end
end)

function ProjetilSystem.ApagarInformacaoPlayer(Player:Player)
	for i=1,SizeInformacaoFrame do
		InformacaoFrames[i][2][Player] = nil
	end
	HistoricoDeTiros[Player] = nil
	UltimoTempoInformado[Player] = nil
end

function quadBezier(t, p0, p1, p2)
	local tquad = math.pow(t,2)
	return (1-2*t+tquad)*p0 + 2*(t-tquad)*p1 + tquad*p2
end

local function PoisonIniciar(Posicao1:Vector3,Posicao2:Vector3,Posicao3:Vector3,TempoDeViagem:number,Distancia:number,PlayerAutor:Player,Identificador:number,OnHit)
	local PosicaoAtual = Posicao1
	local I = 60
	for i=1,59 do
		local ProximaPosicao = quadBezier(i/60,Posicao1,Posicao3,Posicao2)
		local RayCast = workspace:Raycast(PosicaoAtual,ProximaPosicao-PosicaoAtual,RayCastParans)
		if RayCast then
			I = i
			break
		end
		PosicaoAtual = ProximaPosicao
	end
	task.delay(I/60,function()
		OnHit(PosicaoAtual)
	end)
	InformarProjetilEHit.SendNewPoison(PlayerAutor,Posicao1,Posicao2,Distancia,I,Identificador)
end

local function TrapIniciar(Posicao1:Vector3,Posicao2:Vector3,Posicao3:Vector3,TempoDeViagem:number,PlayerAutor:Player,Distancia:number,Raio:number,RaioExplosao:number,Duracao:number,Identificador:number,IdentificadorDoPlayer,OnHit)
	local PosicaoAtual = Posicao1
	local I = 60
	for i=1,59 do
		local ProximaPosicao = quadBezier(i/60,Posicao1,Posicao3,Posicao2)
		local RayCast = workspace:Raycast(PosicaoAtual,ProximaPosicao-PosicaoAtual,RayCastParans)
		if RayCast then
			I = i
			break 
		end
		PosicaoAtual = ProximaPosicao
	end
	task.delay(I/60,function()
		local Relogio = os.clock()+Duracao
		repeat
			local _,Players = Team.TabelaDeDistanciaInimigos(PlayerAutor,PosicaoAtual,Raio)
			if #Players > 0 then
				_,Players = Team.TabelaDeDistanciaInimigos(PlayerAutor,PosicaoAtual,RaioExplosao)
				OnHit(Players)
				InformarProjetilEHit.SendStopTrap(PlayerAutor,Identificador,IdentificadorDoPlayer)
				break
			end
			task.wait()
		until os.clock()>Relogio 
	end)
	InformarProjetilEHit.SendNewTrap(PlayerAutor,Posicao1,Posicao2,Distancia,I,Identificador,IdentificadorDoPlayer)
end

local function TempoParaResetar(Identificador,DistanciaMaxima,Velocidade,Inspired)
	local Tempo = (if Inspired then DistanciaMaxima/Velocidade*1.25 else DistanciaMaxima/Velocidade)*1.05
	task.delay(Tempo,function()
		ProjeteisAtivos[Identificador] = nil
	end)
end

local function VerificarInspired(PlayerAutor:Player,Inspired:boolean)
	local InspiredServidor = PlayerInfo.Effect(PlayerAutor,"Inspired")
	if Inspired and not InspiredServidor then
		InspiredServidor = PlayerInfo.Historico(PlayerAutor,"Inspired")
		local DiferencaDeTempo = os.clock()-InspiredServidor[2]-PlayerAutor:GetNetworkPing()/2
		if DiferencaDeTempo > .1 then 
			return false
		end
	end
	return true, InspiredServidor
end

local function VerificarBerserk(PlayerAutor:Player,Berserk:boolean)
	local BerserkServidor = PlayerInfo.Effect(PlayerAutor,"Berserk")
	if Berserk and not BerserkServidor then
		BerserkServidor = PlayerInfo.Historico(PlayerAutor,"Berserk")
		local DiferencaDeTempo = os.clock()-BerserkServidor[2]-PlayerAutor:GetNetworkPing()/2
		if DiferencaDeTempo > .2 then 
			print("Berserk",DiferencaDeTempo)
			return false
		end
	end
	return true, BerserkServidor
end

local function VerificarCadencia(Player:Player,Berserk,Tempo)
	local Cadencia = ConversorDeStatus.PlayerDextreza(Player)
	local Diferenca = Tempo - HistoricoDeTiros[Player]
	if Diferenca <= 0 then return false end
	if 1/Diferenca*.95<Cadencia then
		HistoricoDeTiros[Player] = Tempo
		return true
	elseif Berserk and (1/Diferenca)*.96<(Cadencia*1.25) then
		HistoricoDeTiros[Player] = Tempo
		return true
	end
	print("FALHA DE CADENCIA",1/(Diferenca),Cadencia)
	return false
end

local function VerificarTempo(Player:Player,Tempo:number)
	if UltimoTempoInformado[Player] - Tempo > 0.001 then
		print("Tempo Fora De Sequencia",UltimoTempoInformado[Player] - Tempo,Player)
		return false
	end
	UltimoTempoInformado[Player] = Tempo
	local PlayerPing = Player:GetNetworkPing()
	local WorkspaceTime = workspace:GetServerTimeNow()
	if Tempo-WorkspaceTime > 0.1 then
		print("TEMPO 1",Tempo-WorkspaceTime,Player)
		return false
	end
	if WorkspaceTime-Tempo-PlayerPing/2 > 0.4 then
		print("Tempo 2",WorkspaceTime-Tempo-PlayerPing,Player,PlayerPing/2)
		return false
	end
	return true
end

local function VerificarNovo(PlayerAutor:Player,Posicao,Direcao,Identificador:number,DistanciaMaxima:number,VelocidadeProjetil:number,Tempo:number,Inicio:number,Quantidade:number,Inspired:number,Berserk:number,Pierce)
	--if Identificador<Inicio or Identificador>Inicio+Quantidade-1 then return false end
	--if Direcao.Y ~= 0 then return false end
	--if not VerificarTempo(PlayerAutor,Tempo) then return false end

	local TrueInspired, InspiredServidor = VerificarInspired(PlayerAutor,Inspired)
	--if not TrueInspired then return false end
	local TrueBerserk, BerserkServidor = VerificarBerserk(PlayerAutor,Berserk)
	--if not TrueBerserk then return false end

	--if not VerificarCadencia(PlayerAutor,Berserk,Tempo) then return false end
	--AntCheatPosicao.MonitorarPosicaoPlayer(PlayerAutor,Posicao)
	TempoParaResetar(Identificador,DistanciaMaxima,VelocidadeProjetil,Inspired)
	ProjeteisAtivos[Identificador] = {Posicao,Direcao,Tempo,DistanciaMaxima,VelocidadeProjetil,InspiredServidor,workspace:GetServerTimeNow()}
	if Pierce then ProjeteisAtivos[Identificador][8] = {} end
	return true
end

local function VerificarNovoH(PlayerAutor:Player,Posicao,Direcao,Identificador:number,DistanciaMaxima:number,VelocidadeProjetil:number,Tempo:number,Inicio:number,Quantidade:number,Pierce)
	--if Identificador<Inicio or Identificador>Inicio+Quantidade-1 then return false end
	--if Direcao.Y ~= 0 then return false end
	--if not VerificarTempo(PlayerAutor,Tempo) then return false end

	--AntCheatPosicao.MonitorarPosicaoPlayer(PlayerAutor,Posicao)
	TempoParaResetar(Identificador,DistanciaMaxima,VelocidadeProjetil,false)
	ProjeteisAtivos[Identificador] = {Posicao,Direcao,Tempo,DistanciaMaxima,VelocidadeProjetil,false,workspace:GetServerTimeNow()}
	if Pierce then ProjeteisAtivos[Identificador][8] = {} end
	return true
end

local function VerificarMultiploAngleH(PlayerAutor:Player,Posicao:Vector3,Direcao:{Vector3},Identificador:{number},DistanciaMaxima:number,VelocidadeProjetil:number,Angulo:number?,Tempo:number,Inicio:number,Quantidade:number,Pierce)
	local Tamanho = #Identificador
	for i=1,Tamanho do
		if Identificador[1]<Inicio or Identificador[1]>Inicio+Quantidade-1 then return false end
		if Direcao[1].Y ~= 0 then print("Angulo errado") return false end
	end
	--if not VerificarTempo(PlayerAutor,Tempo) then return false end
	local Rad = math.rad(Angulo)
	for i=1,Tamanho-1 do
		local AnguloEntreDirecao = Direcao[i]:Angle(Direcao[i+1])
		if math.abs(AnguloEntreDirecao-Rad) > 0.1 then return false end
	end
	AntCheatPosicao.MonitorarPosicaoPlayer(PlayerAutor,Posicao)
	for i=1,Tamanho do
		TempoParaResetar(Identificador[i],DistanciaMaxima,VelocidadeProjetil,false)
		ProjeteisAtivos[Identificador[i]] = {Posicao,Direcao[i],Tempo,DistanciaMaxima,VelocidadeProjetil,false,workspace:GetServerTimeNow()}
		if Pierce then ProjeteisAtivos[Identificador[i]][8] = {} end
	end
	return true
end

local function VerificarWakizashi(PlayerAutor:Player,PosicaoPlayer:Vector3,PosicaoDoTiro:Vector3,Direcao:Vector3,Identificador:{number},DistanciaMaxima:number,VelocidadeProjetil:number,OFFSet:number,MaxDistance:number,Tempo:number,Inicio:number,Quantidade:number,Pierce)
	--if Direcao.Y ~= 0 then print("Angulo errado") return false end
	--if math.abs(Direcao.Magnitude-1) > 0.01 then return false end
	local Tamanho = #Identificador
	--for i=1,Tamanho do if Identificador[1]<Inicio or Identificador[1]>Inicio+Quantidade-1 then print("Tamanho") return false end end

	--if not VerificarTempo(PlayerAutor,Tempo) then return false end
	local DirecaoInvertida = Vector3.new(Direcao.X*math.cos(Rad90)-Direcao.Z*math.sin(Rad90),0,Direcao.X*math.sin(Rad90)+Direcao.Z*math.cos(Rad90)).Unit
	local PosicaoTiroCalculada = PosicaoDoTiro+DirecaoInvertida*DistanciaMaxima/2
	--if (PosicaoTiroCalculada-PosicaoPlayer).Magnitude-MaxDistance > 0.1 then print("WAKIZASHI LONGE") return false end

	AntCheatPosicao.MonitorarPosicaoPlayer(PlayerAutor,PosicaoPlayer)

	local PosicaoCalculada = PosicaoDoTiro+(Tamanho/2-.5)*Direcao*OFFSet
	local Posicoes = {}
	for i=1,Tamanho do
		Posicoes[i] = PosicaoCalculada
		TempoParaResetar(Identificador[i],DistanciaMaxima,VelocidadeProjetil,false)
		ProjeteisAtivos[Identificador[i]] = {PosicaoCalculada,DirecaoInvertida,Tempo,DistanciaMaxima,VelocidadeProjetil,false,workspace:GetServerTimeNow()}
		if Pierce then ProjeteisAtivos[Identificador[i]][8] = {} end
		PosicaoCalculada -= Direcao*OFFSet
	end
	return true, Posicoes, DirecaoInvertida
end

local function VerificarSpell(PlayerAutor:Player,PosicaoPlayer:Vector3,PosicaoDoTiro:Vector3,Direcao:Vector3,Identificador:{number},DistanciaMaxima:number,VelocidadeProjetil:number,GapAngle:number,MaxDistance:number,Tempo:number,Inicio:number,Quantidade:number,Pierce)
	--if Direcao.Y ~= 0 then print("Angulo errado") return false end
	--if math.abs(Direcao.Magnitude-1) > 0.01 then return false end	
	local Tamanho = #Identificador
	--for i=1,Tamanho do if Identificador[1]<Inicio or Identificador[1]>Inicio+Quantidade-1 then return false end end

	--if not VerificarTempo(PlayerAutor,Tempo) then print("Tempo spell") return false end
	--if (PosicaoDoTiro-PosicaoPlayer).Magnitude - MaxDistance > 0.1 then print((PosicaoDoTiro-PosicaoPlayer).Magnitude) return false end

	AntCheatPosicao.MonitorarPosicaoPlayer(PlayerAutor,PosicaoPlayer)

	local Rad = math.rad(GapAngle)
	local DirecaoCalculada = Direcao
	local Direcoes = {}
	for i=1,Tamanho do
		Direcoes[i] = DirecaoCalculada
		TempoParaResetar(Identificador[i],DistanciaMaxima,VelocidadeProjetil,false)
		ProjeteisAtivos[Identificador[i]] = {PosicaoDoTiro,DirecaoCalculada,Tempo,DistanciaMaxima,VelocidadeProjetil,false,workspace:GetServerTimeNow()}
		if Pierce then ProjeteisAtivos[Identificador[i]][8] = {} end
		DirecaoCalculada = Vector3.new(DirecaoCalculada.X*math.cos(Rad)-DirecaoCalculada.Z*math.sin(Rad),0,DirecaoCalculada.X*math.sin(Rad)+DirecaoCalculada.Z*math.cos(Rad)).Unit
	end
	return true, Direcoes
end

local function VerificarNovoStaff(PlayerAutor:Player,Posicao,Direcao,Identificador:{number},DistanciaMaxima:number,VelocidadeProjetil:number,Tempo:number,Inicio:number,Quantidade:number,Inspired:number,Berserk:number)
	if Identificador[1]<Inicio or Identificador>Inicio+Quantidade-1 then return false end
	if Identificador[2]<Inicio or Identificador>Inicio+Quantidade-1 then return false end
	if Direcao.Y ~= 0 then return false end
	--if not VerificarTempo(PlayerAutor,Tempo) then return false end

	local TrueInspired, InspiredServidor = VerificarInspired(PlayerAutor,Inspired)
	if not TrueInspired then return false end
	local TrueBerserk, BerserkServidor = VerificarBerserk(PlayerAutor,Berserk)
	if not TrueBerserk then return false end

	if not VerificarCadencia(PlayerAutor,Berserk,Tempo) then return false end
	AntCheatPosicao.MonitorarPosicaoPlayer(PlayerAutor,Posicao)
	TempoParaResetar(Identificador[1],DistanciaMaxima,VelocidadeProjetil,Inspired)
	TempoParaResetar(Identificador[2],DistanciaMaxima,VelocidadeProjetil,Inspired)
	ProjeteisAtivos[Identificador[1]] = {Posicao,Direcao,Tempo,DistanciaMaxima,VelocidadeProjetil,InspiredServidor,workspace:GetServerTimeNow()}
	ProjeteisAtivos[Identificador[2]] = {Posicao,Direcao,Tempo,DistanciaMaxima,VelocidadeProjetil,InspiredServidor,workspace:GetServerTimeNow()}
	return true
end

local function VerificarNovoBezier(PlayerAutor:Player,Posicao1:Vector3,Posicao2:Vector3,DistanciaMaxima:number)
	AntCheatPosicao.MonitorarPosicaoPlayer(PlayerAutor,Posicao1)
	local Direcao = Posicao2-Posicao1
	local Distancia = Direcao.Magnitude
	if Distancia > DistanciaMaxima then
		local PosicaoAnterior = Vector3.new(Posicao2.X,Posicao1.X,Posicao2.Z)
		if (Posicao1-PosicaoAnterior).Magnitude > DistanciaMaxima then
			Posicao2 = Posicao1 + Direcao.Unit*DistanciaMaxima
			local RayCast = workspace:Raycast(Posicao2,Vector3.new(0,-1000,0),RayCastTerrain)
			if RayCast then Posicao2 = RayCast.Position end
			Distancia = DistanciaMaxima
		end
	end
	local Posicao3 = (Posicao1+Posicao2)/2 + Vector3.new(0,Distancia,0)
	return true, Posicao2, Posicao3, Distancia
end

local function VerificarCenario(Posicao:Vector3,Direcao:Vector3)
	local RayCastResult = workspace:Raycast(Posicao,Direcao,RayCastParans)
	if RayCastResult then return true end
	return false
end

local function VerificarDistancia(DistanciaMaxima:number,DistanciaPercorridaPeloPlayer:number,DistanciaPercorridaTeorica:number,VelocidadeProjetil:number,Inspired:boolean)
	if DistanciaPercorridaPeloPlayer > (if Inspired then DistanciaMaxima*1.25 else DistanciaMaxima) then
		print("Distancia Maxima",DistanciaPercorridaPeloPlayer,DistanciaMaxima)
		return false
	end
	if DistanciaPercorridaTeorica - DistanciaPercorridaPeloPlayer < -.05 then
		print("Distancia Teorica",DistanciaPercorridaPeloPlayer,DistanciaPercorridaTeorica)
		return false
	end
	if DistanciaPercorridaTeorica-DistanciaPercorridaPeloPlayer > VelocidadeProjetil/15 then
		print("Projetil com tempo Descrepante",DistanciaPercorridaTeorica-DistanciaPercorridaPeloPlayer,VelocidadeProjetil/15)
		return false
	end
	return true
end

local function VerificarDiferencaDeTempo(TempoDoDisparo:number,TempoDoHit:number,TempoNoServidor:number,PLayer:Player)
	local TempoAtual = workspace:GetServerTimeNow()
	local Diferenca = (TempoAtual-TempoNoServidor)-(TempoDoHit-TempoDoDisparo)
	if math.abs(Diferenca) > 0.05 then print("Diferenca Entre Tempo ",(TempoAtual-TempoNoServidor),(TempoDoHit-TempoDoDisparo),Diferenca,PLayer) return false end
	return true
end

local function VerificarTamanhoHitBox(PlayerAlvo:Player,DistanciaRetaInstancia:Vector3,DistanciaHitInstancia:Vector3)
	local TamanhoDoCilindro = PlayerAlvo.Character.HitBox.Size.Y
	if DistanciaRetaInstancia > TamanhoDoCilindro*.51 then print("Direcao Fora do Cilindro",DistanciaRetaInstancia,TamanhoDoCilindro*.51) return false end
	if math.abs(DistanciaHitInstancia-TamanhoDoCilindro/2) > 0.01 then print("HitBox",DistanciaHitInstancia,TamanhoDoCilindro/2) return false end 
	return true
end

local function VerificarHitPadrao(PlayerAutor:Player,Identificador:number,Instancia:Instance,PosicaoDaInstancia:Vector3,PosicaoDoHit:Vector3,Tempo:number)
	local PlayerAlvo = PlayerService:GetPlayerFromCharacter(Instancia.Parent)
	if not PlayerAlvo then return false end
	if PlayerAlvo.Team == PlayerAutor.Team then print("Time errado") return false end
	if not ProjeteisAtivos[Identificador] then print("Sem Identificador");return true end

	local PosicaoDoDisparo, Direcao, TempoInicial, DistanciaMaxima, VelocidadeProjetil, Inspired, TempoNoServidor = table.unpack(ProjeteisAtivos[Identificador])

	local DistanciaPercorridaPeloPlayer = (PosicaoDoHit-PosicaoDoDisparo).Magnitude
	local DeltaTime = (Tempo-TempoInicial)
	local DistanciaPercorridaTeorica = DeltaTime*VelocidadeProjetil
	
	--if not VerificarTempo(PlayerAutor,Tempo) then print("Tempo Do HIT") return end
	if not VerificarDiferencaDeTempo(TempoInicial,Tempo,TempoNoServidor,PlayerAutor) then return true,PlayerAlvo end
	if not VerificarDistancia(DistanciaMaxima,DistanciaPercorridaPeloPlayer,DistanciaPercorridaTeorica,VelocidadeProjetil,Inspired) then return true,PlayerAlvo end
		
	local VetorPercurso = PosicaoDoHit-PosicaoDoDisparo
	if (VetorPercurso.Unit-Direcao).Magnitude > 0.01 then print("Direcao",((PosicaoDoHit-PosicaoDoDisparo).Unit-Direcao).Magnitude) return true,PlayerAlvo end
	if VerificarCenario(PosicaoDoDisparo,VetorPercurso) then print("Atravessou Cenario") return true,PlayerAlvo end

	local PosicaoAlternativaInstancia = Vector3.new(PosicaoDaInstancia.X,PosicaoDoDisparo.Y,PosicaoDaInstancia.Z)
	local DistanciaRetaInstancia = (PosicaoAlternativaInstancia-PosicaoDoDisparo):Cross(Direcao).Magnitude
	local DistanciaHitInstancia = (PosicaoDaInstancia-PosicaoDoHit):Cross(VETORUP).Magnitude
	if not VerificarTamanhoHitBox(PlayerAlvo,DistanciaRetaInstancia,DistanciaHitInstancia) then print(Instancia.Name) return true,PlayerAlvo end

	if not AntCheatPosicao.VerificarPosicaoDoPlayer(PlayerAutor,PlayerAlvo,PosicaoDaInstancia) then return true,PlayerAlvo end
	return true, PlayerAlvo, DistanciaPercorridaPeloPlayer>DistanciaMaxima and Inspired or nil
end

local function PegarPlayer(Instancia)
	return PlayerService:GetPlayerFromCharacter(Instancia.Parent)
end

local function VerificarHitNormal(PlayerAutor:Player,Identificador:number,Instancia:Instance,PosicaoDaInstancia:Vector3,PosicaoDoHit:Vector3,Tempo:number)
	--local Sucesso, PlayerAlvo, Inspired =  VerificarHitPadrao(PlayerAutor,Identificador,Instancia,PosicaoDaInstancia,PosicaoDoHit,Tempo)
	local PlayerAlvo = PegarPlayer(Instancia)
	if PlayerAlvo then InformarProjetilEHit.SendHitNormal(PlayerAutor,Identificador) end
	ProjeteisAtivos[Identificador] = nil
	return true, PlayerAlvo, false 
end

local function VerificarHitPierce(PlayerAutor:Player,Identificador:number,Instancia:Instance,PosicaoDaInstancia:Vector3,PosicaoDoHit:Vector3,Tempo:number)
	local Sucesso, PlayerAlvo, Inspired = VerificarHitPadrao(PlayerAutor,Identificador,Instancia,PosicaoDaInstancia,PosicaoDoHit,Tempo)
	local PlayerAlvo = PegarPlayer(Instancia)
	if not PlayerAlvo then return false end
	if table.find(ProjeteisAtivos[Identificador][8],PlayerAlvo) then return false end
	table.insert(ProjeteisAtivos[Identificador][8],PlayerAlvo)
	return Sucesso, PlayerAlvo, Inspired
end

local function VerificarDash(PlayerAutor:Player,PosicaoInicial:Vector3,DashDistance:number,DirecaoDash:Vector3)
	--if DirecaoDash.Y ~= 0 then return false end
	--if math.abs(DirecaoDash.Magnitude - 1) > 0.01 then return false end
	local PosicaoFinal
	local RayCast = workspace:Raycast(PosicaoInicial,DirecaoDash*DashDistance,RayCastParans)
	if RayCast then
		PosicaoFinal = RayCast.Position-DirecaoDash*PlayerAutor.Character.PrimaryPart.Size.Z 
	else
		PosicaoFinal = PosicaoInicial+DashDistance*DirecaoDash
	end
	PlayerAutor.Character.PrimaryPart.Particle:Emit(100)
	AntCheatPosicao.RegistrarDash(PlayerAutor,PosicaoFinal-PosicaoInicial)
	AntCheatPosicao.MonitorarPosicaoPlayer(PlayerAutor,PosicaoFinal)
	return true, PosicaoFinal
end

function ProjetilSystem.NewFire(TipoProjetil:string,IdentificadorDoPlayer,Identificador,PlayerAutor,Posicao,Direcao,Velocidade,DistanciaMaxima,Tempo,Inicio,Quantidade,Inspired,Berserk)
	Inspired = Inspired == 1
	Berserk = Berserk == 1
	if not VerificarNovo(PlayerAutor,Posicao,Direcao,IdentificadorDoPlayer,DistanciaMaxima,Velocidade,Tempo,Inicio,Quantidade,Inspired,Berserk,TipoProjetil~="n") then return false end

	if Inspired then DistanciaMaxima+= 1.25 end
	local RayCastResult = workspace:Raycast(Posicao,Direcao*DistanciaMaxima,RayCastParans)
	if RayCastResult then DistanciaMaxima = RayCastResult.Distance end

	EstatisticaPlayer.Shot(PlayerAutor)
	InformarProjetilEHit.SendNewNormal(PlayerAutor,Identificador,Posicao,Direcao,DistanciaMaxima)
end

function ProjetilSystem.NewFireH(TipoProjetil:string,IdentificadorDoPlayer,Identificador,PlayerAutor,Posicao,Direcao,Velocidade,DistanciaMaxima,Tempo,Inicio,Quantidade)
	if not VerificarNovoH(PlayerAutor,Posicao,Direcao,IdentificadorDoPlayer,DistanciaMaxima,Velocidade,Tempo,Inicio,Quantidade,TipoProjetil~="n") then return false end

	local RayCastResult = workspace:Raycast(Posicao,Direcao*DistanciaMaxima,RayCastParans)
	if RayCastResult then DistanciaMaxima = RayCastResult.Distance end

	InformarProjetilEHit.SendNewNormal(PlayerAutor,Identificador,Posicao,Direcao,DistanciaMaxima)
end

function ProjetilSystem.NewMultipleShotAngleH(TipoProjetil:string,PlayerAutor,IdentificadorDoPlayer:{number},Identificador:{number},Posicao:{Vector3},Direcao:{Vector3},Velocidade:{number},DistanciaMaxima:{number},Angulo:number,Tempo,Inicio,Quantidade)
	if not VerificarMultiploAngleH(PlayerAutor,Posicao,Direcao,IdentificadorDoPlayer,DistanciaMaxima,Velocidade,Angulo,Tempo,Inicio,Quantidade,TipoProjetil~="n") then return false end
	for i=1,#Identificador do
		local RayCastResult = workspace:Raycast(Posicao,Direcao[i]*DistanciaMaxima,RayCastParans)
		if RayCastResult then DistanciaMaxima = RayCastResult.Distance end
		InformarProjetilEHit.SendNewNormal(PlayerAutor,Identificador[i],Posicao,Direcao[i],DistanciaMaxima)
	end
end

function ProjetilSystem.NewWakazashi(TipoProjetil:string,PlayerAutor,IdentificadorDoPlayer:{number},Identificador:{number},PosicaoPlayer:Vector3,PosicaoDoTiro:Vector3,Direcao:Vector3,MaxDistance:number,Velocidade:number,DistanciaMaxima:number,OFFSet:number,Tempo,Inicio,Quantidade)
	local Sucesso, Posicoes, DirecaoInvertida = VerificarWakizashi(PlayerAutor,PosicaoPlayer,PosicaoDoTiro,Direcao,IdentificadorDoPlayer,DistanciaMaxima,Velocidade,OFFSet,MaxDistance,Tempo,Inicio,Quantidade,TipoProjetil~="n") 
	if not Sucesso then print("Erro Wakazashi") return end
	for i=1,#Identificador do
		local RayCastResult = workspace:Raycast(Posicoes[i],DirecaoInvertida*DistanciaMaxima,RayCastParans)
		if RayCastResult then DistanciaMaxima = RayCastResult.Distance end
		InformarProjetilEHit.SendNewNormal(PlayerAutor,Identificador[i],Posicoes[i],DirecaoInvertida,DistanciaMaxima)
	end
end

function ProjetilSystem.NewSpell(TipoProjetil:string,PlayerAutor,IdentificadorDoPlayer:{number},Identificador:{number},PosicaoPlayer:Vector3,PosicaoDoTiro:Vector3,Direcao:Vector3,MaxDistance:number,Velocidade:number,DistanciaMaxima:number,GapAngle:number,Tempo,Inicio,Quantidade)
	local Sucesso, Direcoes = VerificarSpell(PlayerAutor,PosicaoPlayer,PosicaoDoTiro,Direcao,IdentificadorDoPlayer,DistanciaMaxima,Velocidade,GapAngle,MaxDistance,Tempo,Inicio,Quantidade,TipoProjetil~="n")
	if not Sucesso then return end
	for i=1,#Identificador do
		local RayCastResult = workspace:Raycast(PosicaoDoTiro,Direcoes[i]*DistanciaMaxima,RayCastParans)
		if RayCastResult then DistanciaMaxima = RayCastResult.Distance end
		InformarProjetilEHit.SendNewNormal(PlayerAutor,Identificador[i],PosicaoDoTiro,Direcoes[i],DistanciaMaxima)
	end
end

function ProjetilSystem.NewPoisonFire(PlayerAutor:Player,Identificador,Posicao1:Vector3,Posicao2:Vector3,TempoDeViajem,DistanciaMaxima,OnHit)
	local Sucesso , Posicao2, Posicao3, Distancia = VerificarNovoBezier(PlayerAutor,Posicao1,Posicao2,DistanciaMaxima)
	if not Sucesso then return false end
	PoisonIniciar(Posicao1,Posicao2,Posicao3,TempoDeViajem,Distancia,PlayerAutor,Identificador,OnHit)
end

function ProjetilSystem.NewTrapFire(PlayerAutor:Player,Identificador,IdentificadorDoPlayer:number,Posicao1:Vector3,Posicao2:Vector3,TempoDeViajem,DistanciaMaxima,Raio,RaioExplosao,Duracao,OnHit)
	local Sucesso , Posicao2, Posicao3, Distancia = VerificarNovoBezier(PlayerAutor,Posicao1,Posicao2,DistanciaMaxima)
	if not Sucesso then return false end
	TrapIniciar(Posicao1,Posicao2,Posicao3,TempoDeViajem,PlayerAutor,Distancia,Raio,RaioExplosao,Duracao,Identificador,IdentificadorDoPlayer,OnHit)
end

function ProjetilSystem.NewStaffFire(PlayerAutor:Player,IdentificadorDoPlayer,Identificador,Posicao,Direcao,Velocidade,DistanciaMaxima,Tempo,Inicio,Quantidade,Inspired,Berserk)
	Inspired = Inspired == 1 
	Berserk = Berserk == 1
	if not VerificarNovoStaff(PlayerAutor,Posicao,Direcao,IdentificadorDoPlayer,DistanciaMaxima,Velocidade,Tempo,Inicio,Quantidade,Inspired,Berserk) then return false end

	if Inspired then DistanciaMaxima+= 1.25 end
	local RayCastResult = workspace:Raycast(Posicao,Direcao*DistanciaMaxima,RayCastParans)
	if RayCastResult then DistanciaMaxima = RayCastResult.Distance end

	InformarProjetilEHit.SendNewStaff(PlayerAutor,Identificador[1],Identificador[2],Posicao,Direcao,DistanciaMaxima)
end

function ProjetilSystem.DashWithFire(PlayerAutor:Player,PosicaoInicial:Vector3,PosicaoFinal:Vector3,DashDistance:number,DirecaoDash:Vector3,InstanciasAtingidas:{},onHitDash,TipoProjetil:string,IdentificadorDoPlayer:{number},Identificador:{number},Posicao:{Vector3},Direcao:{Vector3},Velocidade:{number},DistanciaMaxima:{number},Angulo:number?,Tempo,Inicio,Quantidade)
	if not VerificarDash(PlayerAutor,PosicaoInicial,PosicaoFinal,DashDistance,DirecaoDash,InstanciasAtingidas,onHitDash) then return false end
	ProjetilSystem.NewMultipleShotAngleH(TipoProjetil,PlayerAutor,IdentificadorDoPlayer,Identificador,Posicao,Direcao,Velocidade,DistanciaMaxima,Angulo,Tempo,Inicio,Quantidade)
	for i=1,#Identificador do
		local RayCastResult = workspace:Raycast(Posicao,Direcao[i]*DistanciaMaxima,RayCastParans)
		if RayCastResult then DistanciaMaxima = RayCastResult.Distance end
		InformarProjetilEHit.SendNewNormal(PlayerAutor,Identificador[i],Posicao,Direcao[i],DistanciaMaxima)
	end
end

function ProjetilSystem.Dash(PlayerAutor:Player,DashDistance:number,DirecaoDash:Vector3,DistanciaCircular:number,PosicaoInicial:Vector3,OnHitDash)
	local Sucesso, PosicaoFinal = VerificarDash(PlayerAutor,PosicaoInicial,DashDistance,DirecaoDash)
	if not Sucesso then return false end
	local PastaInimigo = if PlayerAutor.Team.Name == "Orange" then Team.Purple else Team.Orange
	local PosicaoInicial = PlayerAutor.Character.PrimaryPart.Position
	for i,Character:Model in ipairs(PastaInimigo:GetChildren()) do
		local PosicaoDoModel = Character.PrimaryPart.Position
		local VetorDistancia = PosicaoDoModel-PosicaoInicial
		local Cos1 = VetorDistancia:Dot(DirecaoDash)
		local Cos2 = (PosicaoDoModel-PosicaoFinal):Dot(DirecaoDash)
		if Cos1*Cos2 <= 0 then
			local Distancia = VetorDistancia:Cross(DirecaoDash).Magnitude
			if Distancia <= DistanciaCircular then
				OnHitDash(PlayerService:GetPlayerFromCharacter(Character))
			end
		end
	end
end

function ProjetilSystem.NewHit(PlayerAutor,IdentificadorDoPlayer,OnHit,Instancia,Tempo,PosicaoDaInstancia,PosicaoDoHit)
	--local Sucesso, PlayerAlvo, Inspired = VerificarHitNormal(PlayerAutor,IdentificadorDoPlayer,Instancia,PosicaoDaInstancia,PosicaoDoHit,Tempo)
	local PlayerAlvo = PegarPlayer(Instancia)
	--if Inspired then Gerenciador.InspiredProjetil(Inspired) end
	if PlayerAlvo then OnHit(PlayerAlvo) end
end

function ProjetilSystem.NewPierceHit(PlayerAutor,IdentificadorDoPlayer,OnHit,Instancia,Tempo,PosicaoDaInstancia,PosicaoDoHit)
	--local Sucesso, PlayerAlvo, Inspired = VerificarHitPierce(PlayerAutor,IdentificadorDoPlayer,Instancia,PosicaoDaInstancia,PosicaoDoHit,Tempo)
	local PlayerAlvo = PegarPlayer(Instancia)
	if PlayerAlvo then OnHit(PlayerAlvo) end
end

function ProjetilSystem.NewStaffHit()

end

return ProjetilSystem

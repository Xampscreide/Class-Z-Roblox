local ProjetilSystem = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PastaDeProjeteis = workspace:WaitForChild("Projeteis")
local PastaDeCharacters = workspace:WaitForChild("Characters")
local Debris = game:GetService("Debris")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local NormalProjetil = EventosRemotos:WaitForChild("NormalProjetil")
local PoisonProjetil = EventosRemotos:WaitForChild("PoisonBomb")
local TrapProjetil = EventosRemotos:WaitForChild("Trap")
local TrapProprio = EventosRemotos:WaitForChild("TrapProprio")
local StaffProjetil = EventosRemotos:WaitForChild("Staff")
local InformarHit = EventosRemotos:WaitForChild("InformarHit")
local GeradorDeProjeteis = require(Modulos:WaitForChild("GeradorDeProjeteis"))
local TransformadorCliente = require(Modulos:WaitForChild("TransformadorCliente"))
local LigacaoProjetil = require(Modulos:WaitForChild("LigacaoProjetil"))
local VisualEffects = require(Modulos:WaitForChild("VisualEffects"))
local SonsDosProjeteis = require(Modulos:WaitForChild("SonsDosProjeteis"))
local HitSound = ReplicatedStorage:WaitForChild("Sound"):WaitForChild("Hit")
local LocalPlayer = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

local TabelaDeThreads = {}

local DefaultRayCastParams = RaycastParams.new()
DefaultRayCastParams.FilterType = Enum.RaycastFilterType.Exclude
DefaultRayCastParams.FilterDescendantsInstances = {workspace:WaitForChild("Projeteis"),workspace:WaitForChild("Characters")}

local RayCastTerrain = RaycastParams.new()
RayCastTerrain.FilterType = Enum.RaycastFilterType.Include
RayCastTerrain.FilterDescendantsInstances = {workspace:WaitForChild("Terrain")}


function quadBezier(t, p0, p1, p2)
	local tquad = math.pow(t,2)
	return (1-2*t+tquad)*p0 + 2*(t-tquad)*p1 + tquad*p2
end

--[[local function Dash(PosicaoInicial:Vector3,DashDistance:number,DirecaoDash:Vector3,PrimaryPart:BasePart,ParametrosDash):({},Vector3)
	local DistanciaUnitaria = DirecaoDash*DashDistance/10
	local AlturaDoChao = workspace:Raycast(PosicaoInicial,Vector3.new(0,-10000,0),RayCastParams).Distance
	local Atingidos = {}
	local PosicaoAtual = PosicaoInicial
	for i=1,10 do
		local RayCast = workspace:Raycast(PosicaoAtual,DistanciaUnitaria,RayCastParams)
		if RayCast then
			PosicaoAtual = RayCast.Position 
			break
		end
		PosicaoAtual = PosicaoAtual+DistanciaUnitaria
		local PosicaoNoChao = workspace:Raycast(PosicaoAtual,Vector3.new(0,-10000,0),RayCastParams).Position
		PosicaoAtual = PosicaoNoChao+Vector3.new(0,AlturaDoChao,0)
	end
	local NovaDirecao = PosicaoAtual-PosicaoInicial
	local RayCast = workspace:Raycast(PosicaoInicial,NovaDirecao,ParametrosDash)
	if RayCast then
		if RayCast.Instance:IsDescendantOf(PastaDeCharacters) then table.insert(Atingidos,{RayCast.Instance,RayCast.Instance.Position,RayCast.Position}) end
		ParametrosDash:AddToFilter(RayCast.Instance.Parent~=workspace and RayCast.Instance.Parent or RayCast.Instance)
		while RayCast do
			RayCast = workspace:Raycast(PosicaoAtual,NovaDirecao,ParametrosDash)
			if RayCast then
				if RayCast.Instance:IsDescendantOf(PastaDeCharacters) then table.insert(Atingidos,{RayCast.Instance,RayCast.Instance.Position,RayCast.Position}) end
				ParametrosDash:AddToFilter(RayCast.Instance.Parent~=workspace and RayCast.Instance.Parent or RayCast.Instance)
			end
		end
	end
	PrimaryPart.Particle:Emit(100)
	PrimaryPart.CFrame = CFrame.new(PosicaoAtual,DirecaoDash+PosicaoAtual)
	return Atingidos, PosicaoAtual
end]]

local function Dash(PosicaoInicial:Vector3,DashDistance:number,DirecaoDash:Vector3,PrimaryPart:BasePart):(Vector3)
	DashDistance /= .2
	local PosicaoAtual = PosicaoInicial
	local TempoFinal = os.clock()+.2
	local TempoAtual = os.clock()
	while os.clock() < TempoFinal do
		local DeltaTime = os.clock()-TempoAtual
		TempoAtual = os.clock()
		local Deslocamento = DirecaoDash*DeltaTime*DashDistance
		local RayCast = workspace:Raycast(PosicaoAtual,Deslocamento,DefaultRayCastParams)
		if RayCast then
			PosicaoAtual = RayCast.Position-DirecaoDash*PrimaryPart.Size.Z
			PrimaryPart.CFrame = CFrame.new(PosicaoAtual,DirecaoDash+PosicaoAtual)
			break
		end
		PosicaoAtual = PosicaoAtual+Deslocamento
		PrimaryPart.CFrame = CFrame.new(PosicaoAtual,DirecaoDash+PosicaoAtual)
		task.wait()
	end
end

local function RunNormal(Identificador:number,DistanciaMaxima:number,Cframe:CFrame)
	local Projetil, VelocidadeProjetil, Rotacao = GeradorDeProjeteis.PegarProjetil(Identificador)
	if not Projetil then return false end
	Projetil.CFrame = Cframe*CFrame.Angles(0,math.rad(Rotacao),0)
	local Posicao = Cframe.Position
	SonsDosProjeteis.PlaySound(Projetil,Posicao)
	local Direcao = Cframe.LookVector
	local Relogio2
	local Relogio1 = os.clock()
	local DistanciaPercorrida = 0
	while true do
		coroutine.yield()
		Relogio2 = os.clock()
		local DeltaTime = (Relogio2-Relogio1)
		Relogio1 = Relogio2
		local DistanciaFrame = Direcao*VelocidadeProjetil*DeltaTime
		DistanciaPercorrida += DistanciaFrame.Magnitude
		if DistanciaPercorrida > DistanciaMaxima then
			Projetil.Parent = nil
			coroutine.yield(true)
		end
		Posicao += DistanciaFrame
		local _,N = Camera:WorldToViewportPoint(Posicao)
		if N then
			Projetil.Position = Posicao
			Projetil.Parent = PastaDeProjeteis
		else
			Projetil.Parent = nil
		end
	end
end

local function RunPoison(Posicao1:Vector3,Posicao2:Vector3,Distancia:number,Tempo:number,Identificador:number)
	local Projetil, TempoDeViagem = GeradorDeProjeteis.PegarProjetil(Identificador)
	if not Projetil then return false end
	TempoDeViagem /= 100
	Tempo /= 60
	Projetil.Parent = PastaDeProjeteis
	local Posicao3 = (Posicao1+Posicao2)/2 + Vector3.new(0,Distancia,0)
	local TempoTotal = 0
	local Relogio1 = os.clock()
	local Relogio2
	while true do
		coroutine.yield()
		Relogio2 = os.clock()
		local DeltaTime = (Relogio2-Relogio1)
		Relogio1 = Relogio2
		TempoTotal += DeltaTime
		if TempoTotal > Tempo then
			Projetil.Explosao.Veneno:Emit(300)
			coroutine.yield(true)
		end
		local ProximaPosicao = quadBezier(TempoTotal/TempoDeViagem,Posicao1,Posicao3,Posicao2)
		local _,N = Camera:WorldToViewportPoint(ProximaPosicao)
		if N then
			Projetil.Position = ProximaPosicao
			Projetil.Parent = PastaDeProjeteis
			Projetil.Trajetoria:Emit(2)
		else
			Projetil.Parent = nil
		end
	end
end

local function RunTrap(Posicao1:Vector3,Posicao2:Vector3,Distancia:number,Tempo:number,Identificador:number)
	local Projetil, TempoDeViagem, Duracao = GeradorDeProjeteis.PegarProjetil(Identificador)
	if not Projetil then return false end
	TempoDeViagem /= 100
	Tempo /= 60
	Projetil.Parent = PastaDeProjeteis
	Projetil.Circulo.Enabled = false
	local Posicao3 = (Posicao1+Posicao2)/2 + Vector3.new(0,Distancia,0)
	local TempoTotal = 0
	local Relogio1 = os.clock()
	local Relogio2
	while true do
		coroutine.yield()
		Relogio2 = os.clock()
		local DeltaTime = (Relogio2-Relogio1)
		Relogio1 = Relogio2
		TempoTotal += DeltaTime
		if TempoTotal > Tempo then
			Projetil.Position = quadBezier(Tempo,Posicao1,Posicao3,Posicao2)+Vector3.new(0,.3,0)
			Projetil.Circulo.Enabled = true
			local Relogio = os.clock()+Duracao
			repeat
				coroutine.yield()
			until os.clock() > Relogio
			Projetil.Circulo.Enabled = false
			coroutine.yield(true)
		end
		local ProximaPosicao = quadBezier(TempoTotal/TempoDeViagem,Posicao1,Posicao3,Posicao2)
		Projetil.Position = ProximaPosicao
		Projetil.Attachment.Trajetoria:Emit(2)
	end
end

local x = math.pi*4

local function RunStaff(Identificador:number,DistanciaMaxima:number,Cframe:CFrame,Lado:number)
	local Projetil, VelocidadeProjetil, Rotacao, DistanciaMaximaFixa = GeradorDeProjeteis.PegarProjetil(Identificador)
	if not Projetil then return false end
	Projetil.CFrame = Cframe*CFrame.Angles(0,math.rad(Rotacao),0)
	local RightVector = Cframe.RightVector
	local Posicao = Cframe.Position
	local Direcao = Cframe.LookVector
	local Relogio2
	local Relogio1 = os.clock()
	local SomaTempo = 0
	local DistanciaPercorrida = 0
	while true do
		coroutine.yield()
		Relogio2 = os.clock()
		local DeltaTime = (Relogio2-Relogio1)
		Relogio1 = Relogio2
		SomaTempo += DeltaTime
		local DistanciaFrame = Direcao*VelocidadeProjetil*DeltaTime
		DistanciaPercorrida += DistanciaFrame.Magnitude
		if DistanciaPercorrida > DistanciaMaxima then
			Projetil.Parent = nil
			coroutine.yield(true)
		end
		Posicao += DistanciaFrame
		local _,N = Camera:WorldToViewportPoint(Posicao)
		if N then
			Projetil.Position = Posicao+RightVector*Lado*math.cos(DistanciaPercorrida/DistanciaMaximaFixa*x)
			Projetil.Parent = PastaDeProjeteis
		else
			Projetil.Parent = nil
		end
	end
end

local function RunNormalProprio(Projetil:MeshPart,Velocidade,DistanciaMaxima,Rotacao,Posicao:Vector3,Direcao:Vector3,Parametros,Identificador,Hit:RemoteEvent,H)
	local RayCastResult = workspace:Raycast(Posicao,Direcao*DistanciaMaxima,DefaultRayCastParams)
	if RayCastResult then DistanciaMaxima = RayCastResult.Distance end
	Projetil.CFrame = CFrame.new(Posicao,Posicao+Direcao)*CFrame.Angles(0,math.rad(Rotacao),0)
	local PosicaoInicial = Posicao
	local Relogio2
	local Relogio1 = os.clock()
	local DistanciaPercorrida = 0
	while true do
		coroutine.yield()
		Relogio2 = os.clock()
		local DeltaTime = (Relogio2-Relogio1)
		Relogio1 = Relogio2
		local DistanciaFrame = Direcao*Velocidade*DeltaTime
		local Raycast = workspace:Raycast(Posicao,DistanciaFrame,Parametros)
		if Raycast then
			Projetil.Parent = nil
			if DistanciaPercorrida+Raycast.Distance <= DistanciaMaxima then
				Hit:FireServer(Raycast.Instance,Raycast.Instance.Position,Raycast.Position,string.pack("I2d",Identificador,workspace:GetServerTimeNow()))
				LigacaoProjetil.Informar(Raycast.Instance.Parent,H)
				VisualEffects.ExplosaoParticula(Projetil)
			end
			coroutine.yield(true)
		end
		DistanciaPercorrida += DistanciaFrame.Magnitude
		if DistanciaPercorrida > DistanciaMaxima then
			VisualEffects.ExplosaoParticula(Projetil)
			Projetil.Parent = nil
			coroutine.yield(true)
		end
		Posicao += DistanciaFrame
		local _,N = Camera:WorldToViewportPoint(Posicao)
		if N then
			Projetil.Position = Posicao
			Projetil.Parent = PastaDeProjeteis
		else
			Projetil.Parent = nil
		end
	end
end

local function RunPierceProprio(Projetil:MeshPart,Velocidade,DistanciaMaxima,Rotacao,Posicao:Vector3,Direcao:Vector3,Parametros:RaycastParams,Identificador,Hit:RemoteEvent,H)
	local RayCastResult = workspace:Raycast(Posicao,Direcao*DistanciaMaxima,DefaultRayCastParams)
	if RayCastResult then DistanciaMaxima = RayCastResult.Distance end
	Projetil.CFrame = CFrame.new(Posicao,Posicao+Direcao)*CFrame.Angles(0,math.rad(Rotacao),0)
	local PosicaoInicial = Posicao
	local Relogio2
	local Relogio1 = os.clock()
	local DistanciaPercorrida = 0
	while true do
		coroutine.yield()
		Relogio2 = os.clock()
		local DeltaTime = (Relogio2-Relogio1)
		Relogio1 = Relogio2
		local DistanciaFrame = Direcao*Velocidade*DeltaTime
		local Raycast = workspace:Raycast(Posicao,DistanciaFrame,Parametros)
		if Raycast and DistanciaPercorrida+Raycast.Distance <= DistanciaMaxima and Raycast.Instance:IsDescendantOf(PastaDeCharacters) then
			Hit:FireServer(Raycast.Instance,Raycast.Instance.Position,Raycast.Position,string.pack("I2d",Identificador,workspace:GetServerTimeNow()))
			LigacaoProjetil.Informar(Raycast.Instance.Parent,H)
			Parametros:AddToFilter(Raycast.Instance.Parent)
			while Raycast do
				Raycast = workspace:Raycast(Posicao,DistanciaFrame,Parametros)
				if Raycast and DistanciaPercorrida+Raycast.Distance <= DistanciaMaxima and Raycast.Instance:IsDescendantOf(PastaDeCharacters) then
					Hit:FireServer(Raycast.Instance,Raycast.Instance.Position,Raycast.Position,string.pack("I2d",Identificador,workspace:GetServerTimeNow()))
					LigacaoProjetil.Informar(Raycast.Instance.Parent,H)
					Parametros:AddToFilter(Raycast.Instance.Parent)
				end
			end
		end
		DistanciaPercorrida += DistanciaFrame.Magnitude
		if DistanciaPercorrida > DistanciaMaxima then
			Projetil.Parent = nil
			coroutine.yield(true)
		end
		Posicao += DistanciaFrame
		local _,N = Camera:WorldToViewportPoint(Posicao)
		if N then
			Projetil.Position = Posicao
			Projetil.Parent = PastaDeProjeteis
		else
			Projetil.Parent = nil
		end
	end
end

local function RunPoisonProprio(Projetil,TempoDeViagem,Posicao1:Vector3,Posicao2:Vector3,Posicao3:Vector3)
	local TempoTotal = 0
	Projetil.Parent = PastaDeProjeteis
	local Relogio1 = os.clock()
	local Relogio2 
	local PosicaoAtual = Posicao1
	while true do
		coroutine.yield()
		Relogio2 = os.clock()
		local DeltaTime = Relogio2-Relogio1
		Relogio1 = Relogio2
		TempoTotal += DeltaTime
		local ProximaPosicao = quadBezier(TempoTotal/TempoDeViagem,Posicao1,Posicao3,Posicao2)
		local RayCast = workspace:Raycast(PosicaoAtual,ProximaPosicao-PosicaoAtual,RayCastTerrain)
		if RayCast then
			Projetil.Explosao.Veneno:Emit(300)
			LigacaoProjetil.LigarPoison(RayCast.Position)
			coroutine.yield(true)
		end
		PosicaoAtual = ProximaPosicao
		Projetil.Position = ProximaPosicao
		Projetil.Trajetoria:Emit(2)
		if TempoTotal>TempoDeViagem then
			Projetil.Explosao.Veneno:Emit(300)
			coroutine.yield(true)
		end
	end
end

local FuncoesTrap = {}

local function RunTrapProprio(Projetil,TempoDeViagem,Duracao,Posicao1:Vector3,Posicao2:Vector3,Posicao3:Vector3,MeuIdentificador:number)
	local TempoTotal = 0
	Projetil.Parent = PastaDeProjeteis
	Projetil.Circulo.Enabled = false
	local Relogio1 = os.clock()
	local Relogio2 
	local PosicaoAtual = Posicao1
	local function ModoAtivo()
		Projetil.Circulo.Enabled = true
		local Relogio = os.clock()+Duracao
		local function Explodir()
			LigacaoProjetil.LigarTrap(PosicaoAtual)
			Projetil.Circulo.Enabled = false
			Projetil.Explosao.Faisca:Emit(300)
			Projetil.Explosao.Roxo:Emit(300)
			Relogio = 0
			FuncoesTrap[MeuIdentificador] = nil
		end
		FuncoesTrap[MeuIdentificador] = Explodir
		repeat
			coroutine.yield()
		until os.clock()>Relogio
		Projetil.Circulo.Enabled = false
		coroutine.yield(true)
	end
	while true do
		coroutine.yield()
		Relogio2 = os.clock()
		local DeltaTime = Relogio2-Relogio1
		Relogio1 = Relogio2
		TempoTotal += DeltaTime
		local ProximaPosicao = quadBezier(TempoTotal/TempoDeViagem,Posicao1,Posicao3,Posicao2)
		local RayCast = workspace:Raycast(PosicaoAtual,ProximaPosicao-PosicaoAtual,RayCastTerrain)
		if RayCast then
			Projetil.Position = RayCast.Position+Vector3.new(0,.5,0)
			ModoAtivo()
		end
		PosicaoAtual = ProximaPosicao
		Projetil.Position = ProximaPosicao
		Projetil.Attachment.Trajetoria:Emit(2)
		if TempoTotal>TempoDeViagem then
			ModoAtivo()
		end
	end
end

local function RunStaffProprio(Projetil:MeshPart,Velocidade,DistanciaMaxima,Rotacao,Posicao:Vector3,Direcao:Vector3,Parametros,Identificador,Lado:number,Hit:RemoteEvent)
	local Cframe = CFrame.new(Posicao,Posicao+Direcao)
	local RightVector = Cframe.RightVector
	Projetil.CFrame = Cframe*CFrame.Angles(0,math.rad(Rotacao),0)
	local PosicaoCurvada = Posicao
	local Relogio2
	local Relogio1 = os.clock()
	local DistanciaPercorrida = 0
	local SomaTempo = 0
	while true do
		coroutine.yield()
		Relogio2 = os.clock()
		local DeltaTime = (Relogio2-Relogio1)
		Relogio1 = Relogio2
		SomaTempo += DeltaTime
		local DistanciaFrame = Direcao*Velocidade*DeltaTime
		local NovaPosicaoCurvada = Posicao+DistanciaFrame+math.sin(DistanciaPercorrida/DistanciaMaxima*x)*Lado*RightVector*9
		local Raycast = workspace:Raycast(PosicaoCurvada,NovaPosicaoCurvada-PosicaoCurvada,Parametros)
		if Raycast then
			if DistanciaPercorrida+Raycast.Distance <= DistanciaMaxima and Raycast.Instance:IsDescendantOf(PastaDeCharacters) then
				Hit:FireServer(Raycast.Instance,Raycast.Instance.Position,Raycast.Position,string.pack("I2dI1",Identificador,workspace:GetServerTimeNow(),1/DeltaTime))
			end
			Projetil.Parent = nil
			coroutine.yield(true)
		end
		DistanciaPercorrida += DistanciaFrame.Magnitude
		if DistanciaPercorrida > DistanciaMaxima then
			Projetil.Parent = nil
			coroutine.yield(true)
		end
		PosicaoCurvada = NovaPosicaoCurvada
		Posicao += DistanciaFrame
		local _,N = Camera:WorldToViewportPoint(PosicaoCurvada)
		if N then
			Projetil.Position = PosicaoCurvada
			Projetil.Parent = PastaDeProjeteis
		else
			Projetil.Parent = nil
		end
	end
end

RunService.RenderStepped:Connect(function(DeltaTime)
	for Idenficador, Thread in pairs(TabelaDeThreads) do
		local _, Sucesso = coroutine.resume(Thread)
		if Sucesso then
			coroutine.close(Thread)
			TabelaDeThreads[Idenficador] = nil
		end
	end
end)

local PosicaoPadrao = Vector3.new(-1004,3,-23)
local DeltaX = 843
local DeltaZ = 897
local function RestaurarCframe(Valor1,Valor2):CFrame
	local Rotacao = (Valor2+bit32.lshift(bit32.band(Valor1,7),8))/2047*360
	Valor1 = bit32.rshift(Valor1,3)
	local PosicaoZ = bit32.band(Valor1,8191)/8191*DeltaZ
	Valor1 = bit32.rshift(Valor1,13)
	local PosicaoY = bit32.band(Valor1,7)
	Valor1 = bit32.rshift(Valor1,3)
	local PosicaoX = bit32.band(Valor1,8191)/8191*DeltaX
	return CFrame.new(Vector3.new(PosicaoX,PosicaoY,PosicaoZ)+PosicaoPadrao)*CFrame.fromOrientation(0,math.rad(Rotacao),0)
end

NormalProjetil.OnClientEvent:Connect(function(StringInfo:string)
	local UltimaPosicao = 1
	while UltimaPosicao < StringInfo:len() do
		local Identificador, DistanciaMaxima, Valor1, Valor2
		Identificador, DistanciaMaxima, Valor1, Valor2, UltimaPosicao = string.unpack("I2I2I4I1",StringInfo,UltimaPosicao)
		local Cframe = RestaurarCframe(Valor1,Valor2)
		local Thread = coroutine.create(RunNormal)
		coroutine.resume(Thread,Identificador,DistanciaMaxima,Cframe)
		if coroutine.status(Thread) == "suspended" then
			TabelaDeThreads[Identificador] = Thread
		end
	end
end)

PoisonProjetil.OnClientEvent:Connect(function(StringInfo:string,Posicoes:{Posicoes})
	local UltimaPosicao, Contador = 1, 1
	while UltimaPosicao < StringInfo:len() do
		local Identificador, Distancia, Tempo
		Identificador, Distancia, Tempo,UltimaPosicao = string.unpack("I2I2I2",StringInfo)
		local Thread = coroutine.create(RunPoison)
		coroutine.resume(Thread,Posicoes[Contador],Posicoes[Contador+1],Distancia,Tempo,Identificador)
		if coroutine.status(Thread) == "suspended" then
			TabelaDeThreads[Identificador] = Thread
		end
		Contador+=2
	end
end)

TrapProjetil.OnClientEvent:Connect(function(StringInfo:string,Posicoes:{Posicoes})
	local UltimaPosicao, Contador = 1, 1
	while UltimaPosicao < StringInfo:len() do
		local Identificador, Distancia, Tempo
		Identificador, Distancia, Tempo,UltimaPosicao = string.unpack("I2I2I2",StringInfo)
		local Thread = coroutine.create(RunTrap)
		coroutine.resume(Thread,Posicoes[Contador],Posicoes[Contador+1],Distancia,Tempo,Identificador)
		if coroutine.status(Thread) == "suspended" then
			TabelaDeThreads[Identificador] = Thread
		end
		Contador+=2
	end
end)

StaffProjetil.OnClientEvent:Connect(function(StringInfo:string,Cframes:{CFrame})
	local UltimaPosicao, Contador = 1 ,1
	while UltimaPosicao < StringInfo:len() do
		local Identificador1, Identificador2, DistanciaMaxima
		Identificador1, Identificador2, DistanciaMaxima, UltimaPosicao = string.unpack("I2I2I2",StringInfo,UltimaPosicao)
		local Thread = coroutine.create(RunStaff)
		coroutine.resume(Thread,Identificador1,DistanciaMaxima,Cframes[Contador],1)
		if coroutine.status(Thread) == "suspended" then
			TabelaDeThreads[Identificador1] = Thread
		end
		Thread = coroutine.create(RunStaff)
		coroutine.resume(Thread,Identificador2,DistanciaMaxima,Cframes[Contador],-1)
		if coroutine.status(Thread) == "suspended" then
			TabelaDeThreads[Identificador2] = Thread
		end
		Contador+=1
	end
end)

function ProjetilSystem.FireNormal(Fire:RemoteEvent,Hit:RemoteEvent)
	local Projetil, Velocidade, DistanciaMaxima, Rotacao, Identificador = GeradorDeProjeteis.PegarProjetilPessoal()
	local Parametros, Direcao, Posicao, Inspired, Berserk
	Parametros, DistanciaMaxima, Posicao, Direcao, Inspired, Berserk = TransformadorCliente.TransformacaoNormal(DistanciaMaxima)
	Fire:FireServer(Posicao, Direcao, string.pack("I2dI1I1",Identificador,workspace:GetServerTimeNow(),Inspired,Berserk))
	local Thread  = coroutine.create(RunNormalProprio)
	coroutine.resume(Thread,Projetil,Velocidade,DistanciaMaxima,Rotacao,Posicao,Direcao,Parametros,Identificador,Hit)
	TabelaDeThreads[Identificador] = Thread
end

function ProjetilSystem.FireNormalH(Novo:RemoteEvent,Hit:RemoteEvent)
	local Projetil, Velocidade, DistanciaMaxima, Rotacao, Identificador = GeradorDeProjeteis.PegarProjetilPessoalHabilidade()
	local Parametros, Posicao, Direcao = TransformadorCliente.TransformacaoNormalH()
	Novo:FireServer(Posicao, Direcao, string.pack("I2d",Identificador,workspace:GetServerTimeNow()))
	local Thread  = coroutine.create(RunNormalProprio)
	coroutine.resume(Thread,Projetil,Velocidade,DistanciaMaxima,Rotacao,Posicao,Direcao,Parametros,Identificador,Hit,true)
	TabelaDeThreads[Identificador] = Thread
end

function ProjetilSystem.FirePierce(Novo:RemoteEvent,Hit:RemoteEvent)
	local Projetil, Velocidade, DistanciaMaxima, Rotacao, Identificador = GeradorDeProjeteis.PegarProjetilPessoal()
	local Parametros, Direcao, Posicao, Inspired, Berserk
	Parametros, DistanciaMaxima, Posicao, Direcao, Inspired, Berserk = TransformadorCliente.TransformacaoPierce(DistanciaMaxima)
	Novo:FireServer(Posicao, Direcao, string.pack("I2dI1I1",Identificador,workspace:GetServerTimeNow(),Inspired,Berserk))
	local Thread  = coroutine.create(RunPierceProprio)
	coroutine.resume(Thread,Projetil,Velocidade,DistanciaMaxima,Rotacao,Posicao,Direcao,Parametros,Identificador,Hit)
	TabelaDeThreads[Identificador] = Thread
end

function ProjetilSystem.FirePierceH(Novo:RemoteEvent,Hit:RemoteEvent)
	local Projetil, Velocidade, DistanciaMaxima, Rotacao, Identificador = GeradorDeProjeteis.PegarProjetilPessoalHabilidade()
	local Parametros, Posicao, Direcao = TransformadorCliente.TransformacaoPierceH()
	Novo:FireServer(Posicao, Direcao, string.pack("I2d",Identificador,workspace:GetServerTimeNow()))
	local Thread  = coroutine.create(RunPierceProprio)
	coroutine.resume(Thread,Projetil,Velocidade,DistanciaMaxima,Rotacao,Posicao,Direcao,Parametros,Identificador,Hit,true)
	TabelaDeThreads[Identificador] = Thread
end

function ProjetilSystem.FireMultiploNormalH(Novo:RemoteEvent,Hit:RemoteEvent,Quantidade:number,Angulo:number?)
	local Projeteis, Velocidade, DistanciaMaxima, Rotacao, Identificadores = GeradorDeProjeteis.PegarVariosProjeteisPessoaisHabilidade(Quantidade)
	local Parametros, Posicao, Direcoes = TransformadorCliente.MultiploH(Quantidade,Angulo)
	local IdentificadoresString = {}
	for _,Identificador in ipairs(Identificadores) do table.insert(IdentificadoresString,string.pack("I2",Identificador)) end
	Novo:FireServer(Posicao,Direcoes,table.concat(IdentificadoresString)..string.pack("d",workspace:GetServerTimeNow()))
	for i=1,Quantidade do
		local Thread  = coroutine.create(RunNormalProprio)
		coroutine.resume(Thread,Projeteis[i],Velocidade,DistanciaMaxima,Rotacao,Posicao,Direcoes[i],Parametros,Identificadores[i],Hit)
		TabelaDeThreads[Identificadores[i]] = Thread
	end
end

function ProjetilSystem.FireMultiploPierceH(Novo:RemoteEvent,Hit:RemoteEvent,Quantidade:number,Angulo:number?)
	local Projeteis, Velocidade, DistanciaMaxima, Rotacao, Identificadores = GeradorDeProjeteis.PegarVariosProjeteisPessoaisHabilidade(Quantidade)
	local Parametros, Posicao, Direcoes = TransformadorCliente.MultiploPierceH(Quantidade,Angulo)
	local IdentificadoresString = {}
	for _,Identificador in ipairs(Identificadores) do table.insert(IdentificadoresString,string.pack("I2",Identificador)) end
	Novo:FireServer(Posicao,Direcoes,table.concat(IdentificadoresString)..string.pack("d",workspace:GetServerTimeNow()))
	for i=1,Quantidade do
		local Thread  = coroutine.create(RunPierceProprio)
		coroutine.resume(Thread,Projeteis[i],Velocidade,DistanciaMaxima,Rotacao,Posicao,Direcoes[i],Parametros,Identificadores[i],Hit,true)
		TabelaDeThreads[Identificadores[i]] = Thread
	end
end

function ProjetilSystem.Dash(Novo:RemoteEvent,DashDistance:number)
	local PosicaoInicial, Direcao, PrimaryPart = TransformadorCliente.TransformacaoDash()
	Novo:FireServer(PosicaoInicial,Direcao)
	Dash(PosicaoInicial,DashDistance,Direcao,PrimaryPart)
end

function ProjetilSystem.DashWithPierceFire(Novo:RemoteEvent,Hit:RemoteEvent,Quantidade:number,Angulo:number?,DashDistance:number)
	local Projeteis, Velocidade, DistanciaMaxima, Rotacao, Identificadores = GeradorDeProjeteis.PegarVariosProjeteisPessoaisHabilidade(Quantidade)
	local Parametros, Posicao, Direcoes = TransformadorCliente.MultiploPierceH(Quantidade,Angulo)
	local ParametrosDash, PosicaoDash, DirecaoDash, PrimaryPart = TransformadorCliente.TransformacaoDash()
	local IdentificadoresString = {}
	for _,Identificador in ipairs(Identificadores) do table.insert(IdentificadoresString,string.pack("I2",Identificador)) end
	local InstanciasAtingidas, PosicaoFinal = Dash(PosicaoDash,DashDistance,DirecaoDash,PrimaryPart,ParametrosDash)
	Novo:FireServer(PosicaoDash,PosicaoFinal,DirecaoDash,InstanciasAtingidas,Direcoes,table.concat(IdentificadoresString)..string.pack("d",workspace:GetServerTimeNow()))
	for i=1,Quantidade do
		local Thread  = coroutine.create(RunPierceProprio)
		coroutine.resume(Thread,Projeteis[i],Velocidade,DistanciaMaxima,Rotacao,PosicaoFinal,Direcoes[i],Parametros,Identificadores[i],Hit)
		TabelaDeThreads[Identificadores[i]] = Thread
	end
end

function ProjetilSystem.FireWakizashi(Novo:RemoteEvent,Hit:RemoteEvent,Quantidade:number,OFFSet:number,MaxDistance:number)
	local Projeteis, Velocidade, DistanciaMaxima, Rotacao, Identificadores = GeradorDeProjeteis.PegarVariosProjeteisPessoaisHabilidade(Quantidade)
	local Parametros, Posicoes, PosicaoDoTiro, PosicaoPlayer, Direcao, DirecaoInvertida = TransformadorCliente.TransformacaoWakizashi(Quantidade,OFFSet,MaxDistance,DistanciaMaxima)
	local IdentificadoresString = {}
	for _,Identificador in ipairs(Identificadores) do table.insert(IdentificadoresString,string.pack("I2",Identificador)) end
	Novo:FireServer(PosicaoPlayer,PosicaoDoTiro,Direcao,table.concat(IdentificadoresString)..string.pack("d",workspace:GetServerTimeNow()))
	for i=1,Quantidade do
		local Thread  = coroutine.create(RunPierceProprio)
		coroutine.resume(Thread,Projeteis[i],Velocidade,DistanciaMaxima,Rotacao,Posicoes[i],DirecaoInvertida,Parametros,Identificadores[i],Hit,true)
		TabelaDeThreads[Identificadores[i]] = Thread
	end
end

function ProjetilSystem.FireSpell(Novo:RemoteEvent,Hit:RemoteEvent,Quantidade:number,GapAngle:number,MaxDistance:number)
	local Projeteis, Velocidade, DistanciaMaxima, Rotacao, Identificadores = GeradorDeProjeteis.PegarVariosProjeteisPessoaisHabilidade(Quantidade)
	local Parametros, PosicaoDoPlayer, PosicaoDoTiro, Direcoes, Direcao = TransformadorCliente.TransformacaoSpell(Quantidade,GapAngle,MaxDistance)
	local IdentificadoresString = {}
	for _,Identificador in ipairs(Identificadores) do table.insert(IdentificadoresString,string.pack("I2",Identificador)) end
	Novo:FireServer(PosicaoDoPlayer,PosicaoDoTiro,Direcao,table.concat(IdentificadoresString)..string.pack("d",workspace:GetServerTimeNow()))
	for i=1,Quantidade do
		local Thread  = coroutine.create(RunNormalProprio)
		coroutine.resume(Thread,Projeteis[i],Velocidade,DistanciaMaxima,Rotacao,PosicaoDoTiro,Direcoes[i],Parametros,Identificadores[i],Hit)
		TabelaDeThreads[Identificadores[i]] = Thread
	end
end

function ProjetilSystem.FirePoison(Novo:RemoteEvent)
	local Projetil, TempoDeViagem, DistanciaMaxima, _, Identificador = GeradorDeProjeteis.PegarProjetilPessoalHabilidade()
	local Posicao1, Posicao2, Posicao3 = TransformadorCliente.TransformacaoPoison(DistanciaMaxima)
	Novo:FireServer(Posicao1,Posicao2)
	local Thread = coroutine.create(RunPoisonProprio)
	coroutine.resume(Thread,Projetil,TempoDeViagem/100,Posicao1,Posicao2,Posicao3)
	TabelaDeThreads[Identificador] = Thread
end

function ProjetilSystem.FireTrap(Novo:RemoteEvent)
	local Projetil, TempoDeViagem, DistanciaMaxima, Duracao, Identificador = GeradorDeProjeteis.PegarProjetilPessoalHabilidade()
	local Posicao1, Posicao2, Posicao3 = TransformadorCliente.TransformacaoPoison(DistanciaMaxima)
	Novo:FireServer(Posicao1,Posicao2,Identificador)
	local Thread = coroutine.create(RunTrapProprio)
	coroutine.resume(Thread,Projetil,TempoDeViagem/100,Duracao,Posicao1,Posicao2,Posicao3,Identificador)
	TabelaDeThreads[Identificador] = Thread
end

function ProjetilSystem.FireStaff(Novo:RemoteEvent,Hit:RemoteEvent)
	local Projetil1, Projetil2, Velocidade, DistanciaMaxima, Rotacao, Identificador1, Identificador2 = GeradorDeProjeteis.PegarProjetilPessoalDuplo()
	local Parametros, Direcao, Posicao, Inspired, Berserk
	Parametros, DistanciaMaxima, Posicao, Direcao, Inspired, Berserk = TransformadorCliente.TransformacaoPierce(DistanciaMaxima)
	Novo:FireServer(Posicao, Direcao, string.pack("I2I2dI1I1",Identificador1,Identificador2,workspace:GetServerTimeNow(),Inspired,Berserk))
	local Thread  = coroutine.create(RunStaffProprio)
	coroutine.resume(Thread,Projetil1,Velocidade,DistanciaMaxima,Rotacao,Posicao,Direcao,Parametros,Identificador1,1,Hit)
	TabelaDeThreads[Identificador1] = Thread
	Thread  = coroutine.create(RunStaffProprio)
	coroutine.resume(Thread,Projetil2,Velocidade,DistanciaMaxima,Rotacao,Posicao,Direcao,Parametros,Identificador2,-1,Hit)
	TabelaDeThreads[Identificador2] = Thread
end

InformarHit.OnClientEvent:Connect(function(StringInfo:string)
	local UltimaPosicao = 1
	while UltimaPosicao < StringInfo:len() do
		local Tipo, Quantidade
		Tipo, Quantidade, UltimaPosicao = string.unpack("I1I2",StringInfo,UltimaPosicao)
		if Tipo == 1 then
			for i=1,Quantidade do
				local Identificador
				Identificador, UltimaPosicao = string.unpack("I2",StringInfo,UltimaPosicao)
				pcall(function()
					GeradorDeProjeteis.ColocarEmNIL(Identificador)
					coroutine.close(TabelaDeThreads[Identificador])
					TabelaDeThreads[Identificador] = nil
				end)
			end
		elseif Tipo == 2 then
			for i=1,Quantidade do
				local Identificador
				Identificador, UltimaPosicao = string.unpack("I2",StringInfo,UltimaPosicao)
				if not TabelaDeThreads[Identificador] then continue end
				pcall(function()
					local Projetil = GeradorDeProjeteis.PegarSomenteProjetil(Identificador)
					Projetil.Circulo.Enabled = false
					Projetil.Explosao.Faisca:Emit(300)
					Projetil.Explosao.Roxo:Emit(300)
					coroutine.close(TabelaDeThreads[Identificador])
					TabelaDeThreads[Identificador] = nil
				end)
			end
		elseif Tipo == 3 then

		end
	end
end)

TrapProprio.OnClientEvent:Connect(function(StringInfo:string)
	local Identificador = string.unpack("I2",StringInfo)
	if not FuncoesTrap[Identificador] then return end
	FuncoesTrap[Identificador]()
end)

return ProjetilSystem

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeamService = game:GetService("Teams")
local PlayerService = game:GetService("Players")

local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")

local Sound = require(Modulos:WaitForChild("Sound"))
local PlayerEffect = require(Modulos:WaitForChild("PlayerEffect"))
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
local HEALTH = require(Modulos:WaitForChild("Health"))

local ValorTemporizador = os.clock()
local FuncTemporizador = EventosRemotos:WaitForChild("Temporizador")

local AlturaDefault = 9.075
local AlturaPorClasse = {
	Paladin = 9.724
}

local PartidaEvento = EventosRemotos:WaitForChild("Partida")
local LocalPlayer = PlayerService.LocalPlayer

local TimeParaNumero = {};TimeParaNumero[TeamService.Orange] = 1;TimeParaNumero[TeamService.Purple] = 2

local Principal = script.Parent
local Atributos = PlayerStats.Stats

local Info = TweenInfo.new(.6,Enum.EasingStyle.Quad)

local PontuacaoMaxima = 100000

local Main = script.Parent
local HPMP = Main:WaitForChild("HP/MP")
local GUIHPBarra = HPMP:WaitForChild("HP")
local GUIHPValor = HPMP:WaitForChild("HPValor")
local GUIMPBarra = HPMP:WaitForChild("MP")
local GUIMPValor = HPMP:WaitForChild("MPValor")

local CamadaDeDano = Main:WaitForChild("Camada")

local Efeitos = Principal:WaitForChild("Efeitos")
local Placar = Principal:WaitForChild("Placar")
local Temporizador = Placar:WaitForChild("Temporizador")
local PlacarLaranja = Placar:WaitForChild("Orange"):WaitForChild("Orange")
local PlacarRoxo = Placar:WaitForChild("Purple"):WaitForChild("Purple")
local PlacarMensagem = Principal:WaitForChild("Mensagens")
local Falso = PlacarMensagem:WaitForChild("Falso")
local Enchimento = Falso:WaitForChild("Enchimento")
local ModeloDeTexto = script:WaitForChild("ModeloDeTexto")

local Colors = {Color3.fromRGB(255, 106, 0),Color3.fromRGB(162, 0, 255)}
local NomeDosTimes = {"ORANGE","PURPLE"}

local TweenAtual = nil

local TabelaDeQuinas = {}

PlayerEffect.SetGui(Efeitos)

HEALTH.Connect(function(Vida:number)
	GUIHPBarra.UIGradient.Offset = Vector2.new(Vida/HEALTH.VidaMaxima-1,0)
	GUIHPValor.Text = tostring(math.round(Vida))
end)

local TInfoCamada = TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0)
HEALTH.ConectarDecaimento(function()
	local T1 = TweenService:Create(CamadaDeDano,TInfoCamada,{ImageTransparency = .52})
	T1.Completed:Once(function()
		TweenService:Create(CamadaDeDano,TInfoCamada,{ImageTransparency = 1}):Play()
	end)
	T1:Play()
end)

task.spawn(function()
	while task.wait(.15) do
		GUIMPBarra.UIGradient.Offset = Vector2.new(PlayerStats.MP/Atributos.MP-1,0) 
		GUIMPValor.Text = tostring(math.round(PlayerStats.MP))
	end
end)

local function ApagarTweenAtual()
	if TweenAtual then
		TweenAtual[1]:Destroy()
		TweenAtual[2]:Cancel()
	end
end

local function MostrarMensagem(Mensagem:string,Color:Color3)
	local NovoTexto = ModeloDeTexto:Clone()
	NovoTexto.Text = Mensagem
	NovoTexto.Parent = Falso
	NovoTexto.TextColor3 = Color
	ApagarTweenAtual()
	Enchimento.Size = UDim2.fromScale(1,0)
	local Tween = TweenService:Create(Enchimento,Info,{Size = UDim2.fromScale(1,1)})
	Tween:Play()
	TweenAtual = {NovoTexto,Tween}
	Tween.Completed:Once(function()
		task.wait(3)
		if NovoTexto ~= TweenAtual[1] then return end
		Tween = TweenService:Create(Enchimento,Info,{Size = UDim2.fromScale(1,0)})
		Tween:Play()
		TweenAtual[2] = Tween
		Tween.Completed:Once(function()
			NovoTexto:Destroy()
			TweenAtual = nil
		end)
	end)
end

local function PlayerPegouBandeira(StringInfo:string,Ultimo:number)
	local Bandeira, Saida, Cor
	Bandeira, Ultimo = string.unpack("I1",StringInfo,Ultimo)
	local NumeroTime = TimeParaNumero[LocalPlayer.Team]
	if NumeroTime == Bandeira then 
		Saida = " ALLIED FLAG HAS BEEN CATCHED " 
		Cor = Colors[NumeroTime%2+1]
	else 
		Saida = " ENEMY FLAG HAS BEEN CATCHED " 
		Cor = Colors[NumeroTime]
	end
	MostrarMensagem(Saida,Cor)
	return Ultimo
end

local function PlayerCapturouBandeira(StringInfo:string,Ultimo:number)
	local Bandeira, Saida, Cor
	Bandeira, Ultimo = string.unpack("I1",StringInfo,Ultimo)
	local NumeroTime = TimeParaNumero[LocalPlayer.Team]
	if NumeroTime == Bandeira then 
		Saida = " ALLIED FLAG HAS BEEN CAPTURED "
		Cor = Colors[NumeroTime%2+1]
	else 
		Saida = " ENEMY FLAG HAS BEEN CAPTURED " 
		Cor = Colors[NumeroTime]
	end
	MostrarMensagem(Saida,Cor)
	return Ultimo
end

local function PlayerDerrubouBandeira(StringInfo:string,Ultimo:number)
	local Bandeira, Saida, Cor
	Bandeira, Ultimo = string.unpack("I1",StringInfo,Ultimo)
	local NumeroTime = TimeParaNumero[LocalPlayer.Team]
	if NumeroTime == Bandeira then 
		Saida = " ALLIED FLAG HAS BEEN DROPPED " 
		Cor = Colors[NumeroTime]
	else 
		Saida = " ENEMY FLAG HAS BEEN DROPPED "
		Cor = Colors[NumeroTime%2+1]
	end
	MostrarMensagem(Saida,Cor)
	return Ultimo
end

local function PlayerRetornouBandeira(StringInfo:string,Ultimo:number)
	local Bandeira, Saida, Cor
	Bandeira, Ultimo = string.unpack("I1",StringInfo,Ultimo)
	local NumeroTime = TimeParaNumero[LocalPlayer.Team]
	if NumeroTime == Bandeira then 
		Saida = " ALLIED FLAG HAS BEEN RETURNED "
		Cor = Colors[NumeroTime]
	else 
		Saida = " ENEMY FLAG HAS BEEN RETURNED " 
		Cor = Colors[NumeroTime%2+1]
	end
	MostrarMensagem(Saida,Cor)
	return Ultimo
end

local function AtualizarValorPlacar(StringInfo:string,Ultimo:number)
	local Valor1,Valor2
	Valor1, Valor2, Ultimo = string.unpack("I3I3",StringInfo,Ultimo)
	PlacarLaranja.Valor.Text = tostring(math.round(Valor1))
	PlacarRoxo.Valor.Text = tostring(math.round(Valor2))
	return Ultimo
end

local function AtualizarTemporizador(StringInfo:string,Ultimo:number)
	local Valor, WorkTime
	Valor, WorkTime, Ultimo = string.unpack("I4d",StringInfo,Ultimo)
	ValorTemporizador = os.clock()-(Valor+workspace:GetServerTimeNow()-WorkTime)
	return Ultimo
end

local function PartidaFinalizou()
	
end

local TabelaLookUp = {
	PlayerPegouBandeira,
	PlayerRetornouBandeira,
	PlayerCapturouBandeira,
	PlayerDerrubouBandeira,
	AtualizarValorPlacar,
	AtualizarTemporizador
}

PartidaEvento.OnClientEvent:Connect(function(StringInfo:string)
	local Ultimo = 1
	while Ultimo <= StringInfo:len() do
		local OP
		
		OP, Ultimo = string.unpack("I1",StringInfo,Ultimo)
		Ultimo = TabelaLookUp[OP](StringInfo,Ultimo)
	end
end)

RunService.Heartbeat:Connect(function()
	local Minutos,Segundos
	Segundos = math.floor(os.clock()-ValorTemporizador)
	Minutos = math.floor(Segundos/60)
	Segundos = Segundos%60
	Temporizador.Text = string.format("%02d:%02d",Minutos,Segundos)
end)


FuncTemporizador:InvokeServer()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local BindableEvents = ReplicatedStorage:WaitForChild("BindableEvents")
local ReabrirMenu = BindableEvents:WaitForChild("ReabrirMenu")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local DeadPlayer = EventosRemotos:WaitForChild("DeathPlayer")
local SolicitarSpawn = EventosRemotos:WaitForChild("SolicitarSpawn")
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))

local LocalPlayer = game.Players.LocalPlayer
local HUD = LocalPlayer.PlayerGui:WaitForChild("HUD")

local Main = script.Parent:WaitForChild("Main")
local Titulo = Main:WaitForChild("Titulo")
local KillLabel = Main:WaitForChild("Kill")
local DamageLabel = Main:WaitForChild("Damage")
local HealLabel = Main:WaitForChild("Heal")
local PointLabel = Main:WaitForChild("Points")
local XPLabel = Main:WaitForChild("XP")
local Respawn = Main:WaitForChild("Respawn")
local Return = Main:WaitForChild("Return")

local Gradientes = {ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0.690196, 0.27451, 0))},ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0.282353, 0, 0.443137))}}

local ProximoRespawn
local TempoPraAparecer = .5

local Tweens = {}
local OsDe0 = {KillLabel,DamageLabel,HealLabel,PointLabel,XPLabel}
local TweenTitulo = TweenService:Create(Titulo,TweenInfo.new(TempoPraAparecer,Enum.EasingStyle.Quart),{TextTransparency = 0})
local TweenMain = TweenService:Create(Main,TweenInfo.new(TempoPraAparecer,Enum.EasingStyle.Quart),{Transparency = .40})
local Tween1Respawn = TweenService:Create(Respawn,TweenInfo.new(TempoPraAparecer,Enum.EasingStyle.Quart),{Transparency = 0})
local Tween2Respawn = TweenService:Create(Respawn.Classe,TweenInfo.new(TempoPraAparecer,Enum.EasingStyle.Quart),{TextTransparency = 0})
local Tween3Respawn = TweenService:Create(Respawn.TextLabel,TweenInfo.new(TempoPraAparecer,Enum.EasingStyle.Quart),{TextTransparency = 0})
local Tween1Return = TweenService:Create(Return.TextLabel,TweenInfo.new(TempoPraAparecer,Enum.EasingStyle.Quart),{TextTransparency = 0})
local Tween2Return = TweenService:Create(Return,TweenInfo.new(TempoPraAparecer,Enum.EasingStyle.Quart),{Transparency = 0})
for i,k in ipairs(OsDe0) do 
	for j,l in ipairs(k:GetChildren()) do 
		if l.ClassName == "TextLabel" then 
			table.insert(Tweens,TweenService:Create(l,TweenInfo.new(1,Enum.EasingStyle.Quart),{TextTransparency = 0}))
		elseif l.ClassName == "ImageLabel" then
			table.insert(Tweens,TweenService:Create(l,TweenInfo.new(1,Enum.EasingStyle.Quart),{ImageTransparency = 0}))
		end
	end 
end

local function DeixarTransparent()
	Main.Transparency = 1
	Titulo.TextTransparency = 1
	Respawn.Transparency = 1
	Respawn.Classe.TextTransparency = 1
	Respawn.TextLabel.TextTransparency = 1
	Return.Transparency = 1
	Return.TextLabel.TextTransparency = 1
	for i,k in ipairs(OsDe0) do 
		for j,l:ImageLabel in ipairs(k:GetChildren()) do 
			if l.ClassName == "TextLabel" then 
				l.TextTransparency = 1
			elseif l.ClassName == "ImageLabel" then
				l.ImageTransparency = 1
			end
		end 
	end
end

local function DeixarNormal()
	TweenMain:Play()
	task.wait(TempoPraAparecer)
	TweenTitulo:Play()
	task.wait(TempoPraAparecer)
	for i,k in ipairs(Tweens) do k:Play() end
	Tween1Respawn:Play()
	Tween2Respawn:Play()
	Tween3Respawn:Play()
	Tween1Return:Play()
	Tween2Return:Play()
end

local CarregandoBarra = false
local TempoPraFinalizar = 0
local TempoInicial = 0
local TempoTotal = 1
local function CarregarBarraPlay(Tempo:number)
	TempoPraFinalizar = os.clock()+Tempo
	TempoInicial = os.clock()
	TempoTotal = Tempo
	if not CarregandoBarra then
		CarregandoBarra = true
		task.spawn(function()
			while os.clock() < TempoPraFinalizar do
				Respawn.UIGradient.Offset = Vector2.new(0,1-(os.clock()-TempoInicial)/TempoTotal)
				task.wait()
			end
			Respawn.UIGradient.Offset = Vector2.new(0,0)
			CarregandoBarra = false
		end)
	end
end

DeadPlayer.OnClientEvent:Connect(function(StringInfo:BinaryStringValue)
	UserInputService.MouseIconEnabled = true
	DeixarTransparent()
	local Kills, Damage, Heal, Points, XP = string.unpack("I2I3I3I3I3",StringInfo)
	Main.Respawn.Classe.Text = string.upper(PlayerStats.Class)
	KillLabel.Value.Text = tostring(Kills)
	DamageLabel.Value.Text = tostring(Damage)
	HealLabel.Value.Text = tostring(Heal)
	PointLabel.Value.Text = tostring(Points)
	XPLabel.Value.Text = tostring(XP)
	Main.Parent.Enabled = true
	HUD.Enabled = false
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	ProximoRespawn = os.clock()+Configuracoes.RespawnTime
	Main:WaitForChild("Gra").Color = if LocalPlayer.Team.Name == "Orange" then Gradientes[1] else Gradientes[2]
	CarregarBarraPlay(Configuracoes.RespawnTime)
	DeixarNormal()
end)

Main.Respawn.Activated:Connect(function()
	if CarregandoBarra then return end
	local Sucesso = SolicitarSpawn:InvokeServer()
	if Sucesso then
		Main.Parent.Enabled = false
		HUD.Enabled = true
	end
end)

Main.Return.Activated:Connect(function()
	Main.Parent.Enabled = false
	ReabrirMenu:Fire(ProximoRespawn)
end)

DeixarTransparent()


local HitIndicator = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local Debris = game:GetService("Debris")

local PastaCharacters = workspace:WaitForChild("Characters")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local EffectMarker = EventosRemotos:WaitForChild("EffectMarker")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")

local PlayerEffect = require(ReplicatedStorage:WaitForChild("Modulos"):WaitForChild("PlayerEffect"))
local TabelaDeArmas = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Armas"))
local TabelaDeHabilidades = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Habilidades"))
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))

local ValorExposed = Configuracoes.ExposedValor
local ValorDamaging = Configuracoes.DamagingMultiplicador
local ValorCursed = Configuracoes.CursedMultiplier

local IndikatorFunction = EventosRemotos:WaitForChild("Indikator")
local IndikatorAtualizar = EventosRemotos:WaitForChild("IndikatorAtualizar")
local IndikatorCriar = EventosRemotos:WaitForChild("IndikatorCriar")
local IndikatorDestruir = EventosRemotos:WaitForChild("IndikatorDestruir")

local LocalPlayer = PlayerService.LocalPlayer

local Molde = script:WaitForChild("Molde")

local IndicadoresAtivos:{BillboardGui:BillboardGui,number:number} = {}
local OffSet = Vector3.new(0,7,0)
local OffSetCura = Vector3.new(0,5,0)
local VetoresParaEfeito = {
	Vector3.new(6,2,0),
	Vector3.new(-6,2,0),
	Vector3.new(3,0,0),
	Vector3.new(-3,0,0),
	Vector3.new(0,3,0),
}
local RotacaoVetor = 0
local Duracao = 1.5

local function PegarVetor()
	RotacaoVetor += 1
	RotacaoVetor = RotacaoVetor%#VetoresParaEfeito+1
	return VetoresParaEfeito[RotacaoVetor]
end

local function VerificarStasis(Efeitos:number)
	if bit32.band(Efeitos,4) ~= 0 then return true else return false end
end

local function CalcularValor(Valor:number,Efeitos:number,DEF:number)
	local ATT = PlayerStats.Stats.ATT
	Valor *= (ATT+25)/50
	if bit32.band(Efeitos,1) ~= 0 then Valor += ValorExposed end
	Valor -= DEF
	if bit32.band(Efeitos,2) ~= 0 then Valor *= ValorCursed end
	if PlayerEffect.GetDamaging() then Valor *= ValorDamaging end

	return Valor > 0 and math.floor(Valor) or 0
end

local function CalcularValorHabilidade(Valor:number,Efeitos:number,DEF:number)
	if bit32.band(Efeitos,1) ~= 0 then Valor += ValorExposed end
	Valor -= DEF

	return Valor > 0 and math.floor(Valor) or 0
end

local function PegarInformacao(Character:Model)
	local Efeitos = Character:FindFirstChild("Efeitos")
	Efeitos = Efeitos and Efeitos.Value or 0
	local DEF = Character:FindFirstChild("DEF")
	DEF = DEF and DEF.Value or 0
	return Efeitos, DEF
end
	
function HitIndicator.IndicarDano(Character:Model,H:boolean)
	local Efeitos,DEF = PegarInformacao(Character)
	if not Efeitos or VerificarStasis(Efeitos) then print("Sem Identificador Indikator") return end
	local Valor = if H then TabelaDeHabilidades[PlayerStats.Equipamento.Habilidade]["Damage"] else TabelaDeArmas[PlayerStats.Equipamento.Arma]["Damage"]
	Valor = if H then CalcularValorHabilidade(Valor,Efeitos,DEF) else CalcularValor(Valor,Efeitos,DEF)
	local Ativo = IndicadoresAtivos[Character]
	if Ativo then
		Ativo[3] -= math.ceil(Valor)
		Ativo[1].Gui.Valor.Text = tostring(Ativo[3])
		Ativo[1].Position = Character:WaitForChild("HumanoidRootPart").Position+OffSet
		IndicadoresAtivos[Character][2] = os.clock() + Duracao
		return
	end
	local Clone = Molde:Clone()
	Clone.Gui.Valor.Text = tostring(-Valor)
	Clone.Parent = workspace
	Clone.Position = Character:WaitForChild("HumanoidRootPart").Position+OffSet
	IndicadoresAtivos[Character] = {Clone,os.clock()+Duracao,math.ceil(-Valor)}
end

function HitIndicator.IndicarDanoArea(Posicao:Vector3,Distancia:number,Dano:number)
	local Pasta = if LocalPlayer.Team.Name == "Orange" then PastaCharacters.Purple else PastaCharacters.Orange
	local Contador = 0
	for i,Character:Model in ipairs(Pasta:GetChildren()) do
		if (Character.PrimaryPart.Position-Posicao).Magnitude > Distancia then continue end
		Contador += 1
		local Efeitos,DEF = PegarInformacao(Character)
		if not Efeitos or VerificarStasis(Efeitos) then return end
		local Valor = CalcularValorHabilidade(Dano,Efeitos,DEF)
		local Ativo = IndicadoresAtivos[Character]
		if Ativo then
			Ativo[3] -= math.ceil(Valor)
			Ativo[1].Gui.Valor.Text = tostring(Ativo[3])
			Ativo[1].Position = Character:WaitForChild("HumanoidRootPart").Position+OffSet
			IndicadoresAtivos[Character][2] = os.clock() + Duracao
			continue
		end
		local Clone = Molde:Clone()
		Clone.Gui.Valor.Text = tostring(-Valor)
		Clone.Parent = workspace
		Clone.Position = Character:WaitForChild("HumanoidRootPart").Position+OffSet
		IndicadoresAtivos[Character] = {Clone,os.clock()+Duracao,math.ceil(-Valor)}
	end
	return Contador
end

function HitIndicator.IndicarCuraArea(Posicao:Vector3,Distancia:number,Cura:number)
	local Pasta = if LocalPlayer.Team.Name == "Orange" then PastaCharacters.Orange else PastaCharacters.Purple
	for i,Character:Model in ipairs(Pasta:GetChildren()) do
		if (Character.PrimaryPart.Position-Posicao).Magnitude > Distancia then continue end 
		local Efeitos = PegarInformacao(Character)
		if not Efeitos or VerificarStasis(Efeitos) then return end
		local Clone = Molde:Clone()
		Clone.Gui.Valor.Text = tostring(Cura)
		Clone.Parent = workspace
		Clone.Position = Character:WaitForChild("HumanoidRootPart").Position+OffSetCura
		Clone.Gui.Valor.TextColor3 = Color3.new(0.384314, 1, 0.160784)
		Debris:AddItem(Clone,Duracao)
	end
end

function HitIndicator.IndicarEfeitoArea(Posicao:Vector3,Distancia:number,Efeito:string)
	local Pasta = if LocalPlayer.Team.Name == "Orange" then PastaCharacters.Purple else PastaCharacters.Orange

	for i,Character:Model in ipairs(Pasta:GetChildren()) do
		if (Character.PrimaryPart.Position-Posicao).Magnitude > Distancia then continue end 
		local Efeitos = PegarInformacao(Character)
		if not Efeitos or VerificarStasis(Efeitos) then return end

		local Clone = Molde:Clone()
		Clone.Gui.Valor.Text = Efeito
		Clone.Parent = workspace
		Clone.Position = Character:WaitForChild("HumanoidRootPart").Position+PegarVetor()+OffSet
		Clone.Gui.Valor.TextColor3 = Color3.new(0, 0.568627, 1)
		Debris:AddItem(Clone,Duracao)
	end
end

function HitIndicator.IndicarEfeitoAreaAmigo(Posicao:Vector3,Distancia:number,Efeito:string)
	local Pasta = if LocalPlayer.Team.Name == "Orange" then PastaCharacters.Orange else PastaCharacters.Purple

	for i,Character:Model in ipairs(Pasta:GetChildren()) do
		if Character == LocalPlayer.Character then continue end
		if (Character.PrimaryPart.Position-Posicao).Magnitude > Distancia then continue end 
		local Efeitos = PegarInformacao(Character)
		if not Efeitos or VerificarStasis(Efeitos) then return end

		local Clone = Molde:Clone()
		Clone.Gui.Valor.Text = Efeito
		Clone.Parent = workspace
		Clone.Position = Character:WaitForChild("HumanoidRootPart").Position+PegarVetor()+OffSet
		Clone.Gui.Valor.TextColor3 = Color3.new(0, 0.568627, 1)
		Debris:AddItem(Clone,Duracao)
	end
end

function HitIndicator.IndicarEfeitoDireto(Character:Model,Efeito:string)
	local Efeitos = PegarInformacao(Character)
	if not Efeitos or VerificarStasis(Efeitos) then return end

	local Clone = Molde:Clone()
	Clone.Gui.Valor.Text = Efeito
	Clone.Parent = workspace
	Clone.Position = Character:WaitForChild("HumanoidRootPart").Position+PegarVetor()+OffSet
	Clone.Gui.Valor.TextColor3 = Color3.new(0, 0.568627, 1)
	Debris:AddItem(Clone,Duracao)
end

RunService.Heartbeat:Connect(function()
	local TempoAtual = os.clock()
	for Character:Model,Info in pairs(IndicadoresAtivos) do
		if TempoAtual > Info[2] then
			Info[1]:Destroy()
			IndicadoresAtivos[Character] = nil
		end
	end
end)

return HitIndicator

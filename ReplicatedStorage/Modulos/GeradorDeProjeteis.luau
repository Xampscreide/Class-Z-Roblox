local Gerador = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local PastaDeProjeteis = ReplicatedStorage:WaitForChild("Projeteis")
local SonsDosProjeteis = Modulos:WaitForChild("SonsDosProjeteis")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local GerenciarProjetilA = EventosRemotos:WaitForChild("GerenciarProjetilA")
local GerenciarProjetilR = EventosRemotos:WaitForChild("GerenciarProjetilR")
local GerenciarProjetilP = EventosRemotos:WaitForChild("GerenciarProjetilP")

local Configuracao = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))

local LocalPlayer = game.Players.LocalPlayer

local ProjeteisAtivos = {}
local ProjeteisPessoaisAtivos = {}
local ProjeteisPessoaisAtivosHabilidade = {}

local ProjetilPessoalAtual
local ProjetilPessoalHabilidadeAtual

function Gerador.ColocarEmNIL(identificador:number)
	pcall(function()
		ProjeteisAtivos[identificador][1].Parent = nil
	end)
end

function Gerador.PegarSomenteProjetil(Identificador:number)
	if not ProjeteisAtivos[Identificador] then return nil end
	return ProjeteisAtivos[Identificador][1]
end

function Gerador.PegarProjetil(Identificador:number):(MeshPart,number,number)
	if not ProjeteisAtivos[Identificador] then return nil end
	return ProjeteisAtivos[Identificador][1], ProjeteisAtivos[Identificador][2], ProjeteisAtivos[Identificador][3], ProjeteisAtivos[Identificador][4]
end

function Gerador.PegarProjetilPessoalHabilidade():(MeshPart,number,number,number,number)
	ProjetilPessoalHabilidadeAtual = ProjetilPessoalHabilidadeAtual[6]
	return ProjetilPessoalHabilidadeAtual[1], ProjetilPessoalHabilidadeAtual[2], ProjetilPessoalHabilidadeAtual[3], ProjetilPessoalHabilidadeAtual[4], ProjetilPessoalHabilidadeAtual[5]
end

function Gerador.PegarVariosProjeteisPessoaisHabilidade(Quantidade:number):({MeshPart},number,number,number,{number})
	local Projeteis = {}
	local Identificadores = {}
	for i=1,Quantidade do
		ProjetilPessoalHabilidadeAtual = ProjetilPessoalHabilidadeAtual[6]
		Projeteis[i] = ProjetilPessoalHabilidadeAtual[1]
		Identificadores[i] = ProjetilPessoalHabilidadeAtual[5]
	end
	return Projeteis, ProjetilPessoalHabilidadeAtual[2], ProjetilPessoalHabilidadeAtual[3], ProjetilPessoalHabilidadeAtual[4], Identificadores
end

function Gerador.PegarProjetilPessoal():(MeshPart,number,number,number)
	ProjetilPessoalAtual = ProjetilPessoalAtual[6]
	return ProjetilPessoalAtual[1], ProjetilPessoalAtual[2], ProjetilPessoalAtual[3], ProjetilPessoalAtual[4], ProjetilPessoalAtual[5]
end

function Gerador.PegarProjetilPessoalDuplo()
	ProjetilPessoalAtual = ProjetilPessoalAtual[6]
	local Projetil1 = ProjetilPessoalAtual
	ProjetilPessoalAtual = ProjetilPessoalAtual[6]
	return Projetil1[1], ProjetilPessoalAtual[1], ProjetilPessoalAtual[2], ProjetilPessoalAtual[3], ProjetilPessoalAtual[4], Projetil1[5], ProjetilPessoalAtual[5]
end

GerenciarProjetilA.OnClientEvent:Connect(function(StringInformacao:string)
	local Inicio, Quantidade, Velocidade, Rotacao, DistanciaMaxima, Projetil, Cor, TrapPoison = string.unpack("I2I2I2i2I2zI1I1",StringInformacao)
	Projetil = PastaDeProjeteis[Projetil]
	local CorDasConfiguracoes = Configuracao.Cores[Cor]
	for i=Inicio,Inicio+Quantidade-1 do
		local Clone = Projetil:Clone()
		if TrapPoison == 1 then
			Clone.Circulo.Color = ColorSequence.new(CorDasConfiguracoes)
			Clone.Attachment.Trajetoria.Color = Clone.Circulo.Color
			Clone.Explosao.Roxo.Color = Configuracao.ColorSequence[Cor]
			Clone.Explosao.Faisca.Color =  Configuracao.ColorSequence[Cor]
		elseif TrapPoison == 2 then
			Clone.Trajetoria.Color = ColorSequence.new(CorDasConfiguracoes)
			Clone.Explosao.Veneno.Color = Configuracao.ColorSequence[Cor]
		else
			Clone.Color = CorDasConfiguracoes
		end
		ProjeteisAtivos[i] = {Clone,Velocidade,Rotacao,DistanciaMaxima}
	end

end)

GerenciarProjetilR.OnClientEvent:Connect(function(StringInformacao:string)
	local Inicio, Quantidade = string.unpack("I2I2",StringInformacao)
	if ProjeteisAtivos[Inicio] then 
		if ProjeteisAtivos[Inicio].Name ~= ProjeteisAtivos[Inicio+Quantidade-1].Name then return nil end
		for i=Inicio,Inicio+Quantidade-1 do
			pcall(function()
				ProjeteisAtivos[i][1]:Destroy()
				table.clear(ProjeteisAtivos[i])
				ProjeteisAtivos[i] = nil
			end)
		end
	elseif ProjeteisPessoaisAtivos[Inicio] then
		for i=Inicio,Inicio+Quantidade-1 do
			pcall(function()
				ProjeteisPessoaisAtivos[i][1]:Destroy()
				table.clear(ProjeteisPessoaisAtivos[i])
				ProjeteisPessoaisAtivos[i] = nil
			end)
		end
	end
end)

GerenciarProjetilP.OnClientEvent:Connect(function(StringInformacao:string)
	local Inicio, Quantidade, Velocidade, Rotacao, DistanciaMaxima, Projetil, Habilidade, Cor, TrapPoison = string.unpack("I2I2I2i2I2zI1I1I1",StringInformacao)
	local Tabela = ProjeteisPessoaisAtivos
	if Habilidade == 1 then Tabela = ProjeteisPessoaisAtivosHabilidade end
	Projetil = PastaDeProjeteis[Projetil]
	local CorDasConfiguracoes = Configuracao.Cores[Cor]
	for i=Inicio,Inicio+Quantidade-1 do
		local Clone = Projetil:Clone()
		if TrapPoison == 1 then
			Clone.Circulo.Color = ColorSequence.new(CorDasConfiguracoes)
			Clone.Attachment.Trajetoria.Color = Clone.Circulo.Color
			Clone.Explosao.Roxo.Color = Configuracao.ColorSequence[Cor]
			Clone.Explosao.Faisca.Color = Configuracao.ColorSequence[Cor]
		elseif TrapPoison == 2 then
			Clone.Trajetoria.Color = ColorSequence.new(CorDasConfiguracoes)
			Clone.Explosao.Veneno.Color = Configuracao.ColorSequence[Cor]
		else
			Clone.Color = CorDasConfiguracoes
		end
		Tabela[i] = {Clone,Velocidade,DistanciaMaxima,Rotacao,i}
	end
	for i=1,Quantidade do
		Tabela[Inicio+i-1][6] = Tabela[Inicio+i%Quantidade]
	end
	if Habilidade == 1 then ProjetilPessoalHabilidadeAtual = Tabela[Inicio]
	else ProjetilPessoalAtual = Tabela[Inicio] end
end)

return Gerador

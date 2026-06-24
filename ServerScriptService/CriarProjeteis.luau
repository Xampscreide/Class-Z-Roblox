local InformarCriacao = {}

local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Teams = game:GetService("Teams")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local GerenciarProjetilA = EventosRemotos:WaitForChild("GerenciarProjetilA")
local GerenciarProjetilP = EventosRemotos:WaitForChild("GerenciarProjetilP")
local GerenciarProjetilR = EventosRemotos:WaitForChild("GerenciarProjetilR")

local ReservaNumeracao = require(script:WaitForChild("ReservaNumeracao"))

local TabelaProjetilCarregado = {}
local TabelaHabilidadeCarregada = {}

local function Destruir(Inicio:number,Quantidade:number)
	ReservaNumeracao.DesalocarProjeteis(Inicio)
	GerenciarProjetilR:FireAllClients(string.pack("I2I2",Inicio,Quantidade))
end

local function ReservaArma(Player:Player, Quantidade:number, Velocidade:number, Rotacao:number, DistanciaMaxima:number, Projetil:string, Cor:number)
	local Inicio, Tabela = ReservaNumeracao.AlocarProjeteis(Quantidade)
	for _,Pl in ipairs(PlayerService:GetPlayers()) do
		if Player == Pl then 
			GerenciarProjetilP:FireClient(Pl,string.pack("I2I2I2i2I2zI1I1I1",Inicio,Quantidade,Velocidade,Rotacao,DistanciaMaxima,Projetil,0,Cor,0)) 
		else 
			GerenciarProjetilA:FireClient(Pl,string.pack("I2I2I2i2I2zI1I1",Inicio,Quantidade,Velocidade,Rotacao,DistanciaMaxima,Projetil,Cor,0))
		end
	end
	return Inicio, Tabela
end

local function ReservaHabilidade(Player:Player, Quantidade:number, Velocidade:number, Rotacao:number, DistanciaMaxima:number, Projetil:string, Cor:number,Trap:number)
	local Inicio, Tabela = ReservaNumeracao.AlocarProjeteis(Quantidade)
	for _,Pl in ipairs(PlayerService:GetPlayers()) do
		if Player == Pl then 
			GerenciarProjetilP:FireClient(Pl,string.pack("I2I2I2i2I2zI1I1I1",Inicio,Quantidade,Velocidade,Rotacao,DistanciaMaxima,Projetil,1,Cor,Trap)) 
		else 
			GerenciarProjetilA:FireClient(Pl,string.pack("I2I2I2i2I2zI1I1",Inicio,Quantidade,Velocidade,Rotacao,DistanciaMaxima,Projetil,Cor,Trap))
		end
	end
	return Inicio, Tabela
end

function InformarCriacao.CriarEInformar(Player:Player, Quantidade:number, Velocidade:number, Rotacao:number, DistanciaMaxima:number, Projetil:string)
	local Cor = Player.Team == Teams.Orange and 1 or 2
	local Inicio, Tabela = ReservaArma(Player,Quantidade,Velocidade,Rotacao,DistanciaMaxima,Projetil,Cor)
	if TabelaProjetilCarregado[Player] then
		Destruir(TabelaProjetilCarregado[Player][1],TabelaProjetilCarregado[Player][2])
	end
	TabelaProjetilCarregado[Player] = {Inicio,Quantidade,Velocidade,Rotacao,DistanciaMaxima,Projetil,Cor}
	return Inicio, Tabela
end

function InformarCriacao.CriarEInformarHabilidade(Player:Player, Quantidade:number, Velocidade:number, Rotacao:number, DistanciaMaxima:number, Projetil:string,TrapPosion:string)
	local Cor = Player.Team == Teams.Orange and 1 or 2
	local Inicio, Tabela = ReservaHabilidade(Player,Quantidade,Velocidade,Rotacao,DistanciaMaxima,Projetil,Cor,TrapPosion == "Trap" and 1 or TrapPosion == "Poison" and 2 or 0)
	if TabelaHabilidadeCarregada[Player] then
		Destruir(TabelaHabilidadeCarregada[Player][1],TabelaHabilidadeCarregada[Player][2])
	end
	TabelaHabilidadeCarregada[Player] = {Inicio,Quantidade,Velocidade,Rotacao,DistanciaMaxima,Projetil,Cor}
	return Inicio, Tabela
end

function InformarCriacao.EnviarParaNovoPlayer(Player:Player)
	for _, Info in pairs(TabelaProjetilCarregado) do
		GerenciarProjetilA:FireClient(Player,string.pack("I2I2I2i2I2zI1",table.unpack(Info)))
	end
	for _, Info in pairs(TabelaHabilidadeCarregada) do
		GerenciarProjetilA:FireClient(Player,string.pack("I2I2I2i2I2zI1",table.unpack(Info)))
	end
end

return InformarCriacao

local Magic = {}

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
local Conversor = require(Modulos:WaitForChild("ConversorDeStatus"))
local TabelaDeHabilidades = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Habilidades"))
local Sound = require(Modulos:WaitForChild("Sound"))
local ErroSound = script:WaitForChild("error")

local MagicPointEvento = ReplicatedStorage:WaitForChild("EventosRemotos"):WaitForChild("MagicPoint")

local Atributos = PlayerStats.Stats
local Ligado = false

MagicPointEvento.OnClientEvent:Connect(function(Tipo:string,Valor:number,Horario:number)
	if Tipo == "L" then
		Ligado = true
	elseif Tipo == "D" then
		Ligado = false
		return
	end
	PlayerStats.MP = math.min(Atributos.MP,Valor+(workspace:GetServerTimeNow()-Horario)*Conversor.Wisdom(Atributos.WIS))
end)

function Magic.Verificar()
	local Quantidade = TabelaDeHabilidades[PlayerStats.Equipamentos[PlayerStats.Class]["Habilidade"]]["MPCost"]
	if PlayerStats.MP < Quantidade then Sound.PlaySound(ErroSound) return false end
	PlayerStats.MP -= Quantidade
	return true
end

function Magic.Continuo(MPPerTime:number,DeltaTime:number)
	if PlayerStats.MP < MPPerTime*DeltaTime then
		return false
	end
	PlayerStats.MP -= MPPerTime*DeltaTime
	return true
end

function Magic.CustoPorTempo()
	local Quantidade = TabelaDeHabilidades[PlayerStats.Equipamento.Habilidade]["MPCost"]
	if PlayerStats.MP < Quantidade then return false end
	return true	
end

RunService.RenderStepped:Connect(function(DeltaTime:number)
	if Ligado then
		PlayerStats.MP = math.min(Atributos.MP,PlayerStats.MP+DeltaTime*Conversor.Wisdom(Atributos.WIS))
	end
end)

return Magic

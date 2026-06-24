local Amigos = {}

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local Armas = Configuracoes.Armas
local Armaduras = Configuracoes.Armaduras
local Habilidades = Configuracoes.Habilidades
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))

local Tipos = {Armas,Habilidades,Armaduras}

local function GetAllItens()
	local Liberado = {}
	for i,Tipo in ipairs(Tipos) do
		for NomeDoItem,_ in pairs(Tipo) do
			Liberado[NomeDoItem] = true
		end
	end
	return Liberado
end

function Amigos.VerificarPrivilegios(Player:Player)
	if Player:IsInGroup(33542533) then
		if Player:GetRankInGroup(33542533) > 240 then
			local Info = PlayerInfo.GetPlayer(Player)
			Info.UnlockedItens = GetAllItens()
			return true, Info.UnlockedItens
		end
	end
	return false
end

return Amigos

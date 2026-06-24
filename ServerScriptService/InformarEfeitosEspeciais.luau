local SpecialEffects = {}

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local TeamCoisas = require(ServerScriptService:WaitForChild("TeamCoisas"))

local Arco = EventosRemotos:WaitForChild("CriarArcos")

function SpecialEffects.CriarArco(PlayerAutor:Player,Posicoes:{Vector3},Color:Color3)
	local Tabelas = TeamCoisas.TabelasDeSend2(PlayerAutor)
	for _,Tabela in ipairs(Tabelas) do
		for _,Player:Player in ipairs(Tabela) do
			Arco:FireClient(Player,Posicoes,Color)
		end
	end
end

return SpecialEffects

local Ping = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local PingFunction = EventosRemotos:WaitForChild("Ping")

local TabelaPlayers = {}

function Ping.AddPlayer(Player:Player)
	TabelaPlayers[Player] = Player:GetNetworkPing()
end

function Ping.RemoverPlayer(Player:Player)
	TabelaPlayers[Player] = nil
end

function Ping.GetPing(Player:Player)
	return TabelaPlayers[Player]
end

task.spawn(function()
	while task.wait(1) do
		for Player:Player,_ in pairs(TabelaPlayers) do
			task.spawn(function()
				local T1 = os.clock()
				local Code = HttpService:GenerateGUID(false)
				local PlayerCode
				local Sucesso , mensagem = pcall(function()
					PlayerCode = PingFunction:InvokeClient(Player,Code)
				end)
				local PlayerPing = (os.clock()-T1)*1000
				if PlayerCode~=Code then PlayerPing=60000 end
				TabelaPlayers[Player] = PlayerPing
			end)
		end
	end
end)

return Ping

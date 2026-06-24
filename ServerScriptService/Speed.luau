local Speed = {}

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local SpeedEvent = EventosRemotos:WaitForChild("Speed")
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))
local ConversaoStatus = require(ServerScriptService:WaitForChild("ConversorDeStatus"))
local TabelaDePlayers = {}

function Speed.Adicionar(Player:Player,Humanoid:Humanoid)
	local Velocidade = ConversaoStatus.PlayerVelocidade(Player)
	PlayerInfo.SetVelocidade(Player,Velocidade)
	Humanoid.WalkSpeed = Velocidade
	TabelaDePlayers[Player] = Humanoid
	SpeedEvent:FireClient(Player,Velocidade)
end

function Speed.Remover(Player:Player)
	TabelaDePlayers[Player] = nil
end

function Speed.SetDefaultSpeed(Player:Player)
	local Velocidade = ConversaoStatus.PlayerVelocidade(Player)
	PlayerInfo.SetVelocidade(Player,Velocidade)
	if TabelaDePlayers[Player] then 
		TabelaDePlayers[Player].WalkSpeed = Velocidade 
		SpeedEvent:FireClient(Player,Velocidade)
	end
end

function Speed.SetSpeedModifier(Player:Player,Valor:number)
	local Velocidade = ConversaoStatus.PlayerVelocidade(Player)*Valor
	PlayerInfo.SetVelocidade(Player,Velocidade)
	if TabelaDePlayers[Player] then 
		TabelaDePlayers[Player].WalkSpeed = Velocidade 
		SpeedEvent:FireClient(Player,Velocidade)
	end
end

return Speed

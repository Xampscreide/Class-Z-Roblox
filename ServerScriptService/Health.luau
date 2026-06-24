local Health = {}
--#####################################################################################################################################
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--#####################################################################################################################################
local CONVERSORDESTATUS = require(ServerScriptService:WaitForChild("ConversorDeStatus"))
local PLAYERINFO = require(ServerScriptService:WaitForChild("_G.Players"))
local LeaderBoardServer = require(ServerScriptService:WaitForChild("LeaderBoardServer"))
--#####################################################################################################################################
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local HealthEvent = EventosRemotos:WaitForChild("Health")
local MaxHealthEvent = EventosRemotos:WaitForChild("MaxHealth")
--#####################################################################################################################################
local PlayerHealthTable = {}
Health.MaxHealth = {}

local PlayerDeadsFunction = {}

local MatarPlayer

function Health.ChangeMaxHealth(Player:Player,Valor:number)
	if not PlayerHealthTable[Player] then
		return
	end
	Health.MaxHealth[Player] = Valor
	MaxHealthEvent:FireClient(Player,Valor)
	if PlayerHealthTable[Player][1].HP>Valor then
		PlayerHealthTable[Player][1].HP = Valor
	end
end

function Health.Adicionar(Player:Player,Humanoid:Humanoid)
	PlayerHealthTable[Player] = {
		PLAYERINFO.GetPlayer(Player),
		CONVERSORDESTATUS.Vitalidade(PLAYERINFO.Stats(Player).VIT),
	}
	local VidaMaxima = PlayerHealthTable[Player][1].Stats.HP
	PlayerHealthTable[Player][1].HP = VidaMaxima
	Health.ChangeMaxHealth(Player,VidaMaxima)
	local TabelaPraEnviar = {}
	local Numeros = {}
	for Player:Player,Conteudo in pairs(PlayerHealthTable) do
		table.insert(TabelaPraEnviar,Player)
		table.insert(Numeros,string.pack("I1",Conteudo[1].HP*100/Health.MaxHealth[Player]))
	end
	Numeros = table.concat(Numeros)
	MaxHealthEvent:FireClient(Player,VidaMaxima,TabelaPraEnviar,Numeros)
end

function Health.Terminar(Player:Player)
	if not PlayerHealthTable[Player] then
		return
	end
	if PlayerDeadsFunction[Player] then PlayerDeadsFunction[Player](Player) end
	PlayerHealthTable[Player] = nil
	Health.MaxHealth[Player] = nil
	HealthEvent:FireClient(Player,0,{},"")
end

function Health.GetPlayerHealth(Player:Player)
	return PlayerHealthTable[Player] and PlayerHealthTable[Player][1].HP or nil
end

function Health.Damage(Player:Player,Valor:number):(number,boolean)
	if not PlayerHealthTable[Player] then
		return false,nil
	end
	local Dano = math.min(PlayerHealthTable[Player][1].HP,Valor)
	local Morte = false
	PlayerHealthTable[Player][1].HP -= Valor
	if PlayerHealthTable[Player][1].HP <= 0 then
		MatarPlayer(Player)
		Morte = true
	end
	return Dano,Morte
end

function Health.Heal(Player:Player,Valor:number)
	if not PlayerHealthTable[Player] then
		return 0
	end
	local Cura = math.min(Health.MaxHealth[Player]-PlayerHealthTable[Player][1].HP,Valor)
	PlayerHealthTable[Player][1].HP = math.min(PlayerHealthTable[Player][1].HP+Valor,Health.MaxHealth[Player])
	return Cura
end

function Health.PlayerDeadEvent(Player:Player,Function)
	PlayerDeadsFunction[Player] = Function
end

function Health.PlayerDeadEventDisconectar(Player:Player)
	PlayerDeadsFunction[Player] = nil
end

function Health.SetarFuncaoDeMorte(Funcao)
	MatarPlayer = Funcao
end

local VidaAnterior = {}
local MetaVida = {
	__index = function(self,Index)
		self[Index] = PlayerHealthTable[Index]
		return self[Index]
	end,
}
setmetatable(VidaAnterior,MetaVida)
local Contador = 0
RunService.Heartbeat:Connect(function(DeltaTime)
	local Send = Contador%15 == 0
	if Send then
		local TabelaPraEnviar = {}
		local Numeros = {}
		for Player:Player,Conteudo in pairs(PlayerHealthTable) do
			if VidaAnterior[Player] ~= Conteudo[1].HP then
				table.insert(TabelaPraEnviar,Player)
				table.insert(Numeros,string.pack("I1",Conteudo[1].HP*100/Health.MaxHealth[Player]))
			end
			VidaAnterior[Player] = Conteudo[1].HP 
		end
		Numeros = table.concat(Numeros)
		for Player:Player,Conteudo in pairs(PlayerHealthTable) do
			HealthEvent:FireClient(Player,Conteudo[1].HP,TabelaPraEnviar,Numeros)
		end
	else
		for Player:Player,Conteudo in pairs(PlayerHealthTable) do
			Conteudo[1].HP = math.min(DeltaTime*Conteudo[2]+Conteudo[1].HP,Health.MaxHealth[Player])
		end
	end
	Contador += 1
end)

return Health

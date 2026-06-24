local BoosterManager = {}

local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))
local InfoPlayer = require(ServerScriptService:WaitForChild("InfoPlayers"))

function BoosterManager.CarregarBoosterPlayer(Player:Player)
	local Info = PlayerInfo.GetPlayerSafeMode(Player)
	local DiaAtual = math.floor(os.time()/(3600*24)) 
	local DiaUltimoSave =  math.floor((Info.LastSave or 0)/(3600*24))
	if DiaAtual > DiaUltimoSave then
		Info.LastSave = os.time()
		Info.Boosters.XP.Daily = {Tempo = 1800,Valor = .15}
	end
	if Player.MembershipType == Enum.MembershipType.Premium then
		Info.Boosters.XP.Premium = {Tempo = false,Valor = .3}
		Info.Boosters.Item.Premium = {Tempo = false,Valor = .3}
		Info.Boosters.Class.Premium = {Tempo = false,Valor = .3}
	end
	if Player:IsInGroup(33542533) then
		Info.Boosters.XP.Group = {Tempo = false,Valor = .15}
	end
	for NomeBoost,_ in pairs(Info.Booster) do
		local Boost = 1
		for i,k in pairs(Info.Boosters[NomeBoost]) do
			Boost += k.Valor
		end
		Info.Booster[NomeBoost] = Boost	
	end
end

function BoosterManager.AdicionarXPBooster(Player:Player,Valor:number,Numero:number)
	local Info = PlayerInfo.GetPlayerSafeMode(Player)
	local Boosters = Info.Boosters.XP
	local NomeDoBoost = "Boost"..tostring(Numero)
	if Boosters[NomeDoBoost] then
		Boosters[NomeDoBoost].Tempo += 3600
	else
		Boosters[NomeDoBoost] = {Tempo = 3600,Valor = Valor}
		Info.Booster.XP += Valor
	end
	InfoPlayer.AtualizarBoosters(Player)
end

function BoosterManager.AdicionarItemBooster(Player:Player,Valor:number,Numero:number)
	local Info = PlayerInfo.GetPlayerSafeMode(Player)
	local Boosters = Info.Boosters.Item
	local NomeDoBoost = "Boost"..tostring(Numero)
	if Boosters[NomeDoBoost] then
		Boosters[NomeDoBoost].Tempo += 3600
	else
		Boosters[NomeDoBoost] = {Tempo = 3600,Valor = Valor}
		Info.Booster.Item += Valor
	end
	InfoPlayer.AtualizarBoosters(Player)
end

function BoosterManager.AdicionarClassBooster(Player:Player,Valor:number,Numero:number)
	local Info = PlayerInfo.GetPlayerSafeMode(Player)
	local Boosters = Info.Boosters.Class
	local NomeDoBoost = "Boost"..tostring(Numero)
	if Boosters[NomeDoBoost] then
		Boosters[NomeDoBoost].Tempo += 3600
	else
		Boosters[NomeDoBoost] = {Tempo = 3600,Valor = Valor}
		Info.Booster.Class += Valor
	end
	InfoPlayer.AtualizarBoosters(Player)
end

local TabelaDePlayers = {}
function BoosterManager.IniciarTemporizador(Player:Player)
	local Info = PlayerInfo.GetPlayer(Player)
	TabelaDePlayers[Player] = Info.Boosters
end

function BoosterManager.PausarTemporizador(Player:Player)
	local Info = PlayerInfo.GetPlayer(Player)
	for NomeBoost,_ in pairs(Info.Booster) do
		local Boost = 1
		for i,k in pairs(Info.Boosters[NomeBoost]) do
			if k.Tempo then
				if k.Tempo <= 0 then
					Info.Boosters[NomeBoost][i] = nil
				else
					Boost += k.Valor
				end
			elseif k.Tempo == false then
				Boost += k.Valor
			end
		end
		Info.Booster[NomeBoost] = Boost	
	end
	TabelaDePlayers[Player] = nil
end

RunService.Heartbeat:Connect(function(DeltaTime:number)
	for Player:Player,Boosters in pairs(TabelaDePlayers) do
		for NomeBoost,Booster in pairs(Boosters) do
			for i,k in pairs(Booster) do
				if k.Tempo then
					k.Tempo -= DeltaTime
				end
			end
		end
	end
end)

return BoosterManager

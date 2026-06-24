local Estatistica = {}

local ServerScriptService = game:GetService("ServerScriptService")
local EstatisticaDosEquipamentos = require(ServerScriptService:WaitForChild("Patern"):WaitForChild("PaternDeEstatisticaDeEquipamento"))
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))

local EstatisticaDoPlayer = {}
local Meta = {__index = function (self,Index:string)
	self[Index] = 0
	return 0
end}

function Estatistica.RegistrarEstatistica(Player:Player,PlayerSaindo:boolean?):(number,number,number)
	if not EstatisticaDoPlayer[Player] then return 0,0,0 end
	local InfoPlayer = PlayerInfo.GetPlayer(Player)
	local BoosterItem = InfoPlayer.Booster.Item
	local BoosterClass = InfoPlayer.Booster.Class
	local Classe = InfoPlayer.Class
	local ArmaEquipada = InfoPlayer.Equipamento[Classe].Arma
	local HabilidadeEquipada = InfoPlayer.Equipamento[Classe].Habilidade
	local ArmaduraEquipada = InfoPlayer.Equipamento[Classe].Armadura
	
	local Kills, Damage, Heal = 0,0,0
	for NomeDaEstatistica, Valor in pairs(EstatisticaDoPlayer[Player]) do
		if type(Valor) == "table" then continue end
		if InfoPlayer.ClassStatistic[Classe][NomeDaEstatistica] then 
			InfoPlayer.ClassStatistic[Classe][NomeDaEstatistica] += Valor 
			InfoPlayer.ClassStatisticModificada[Classe][NomeDaEstatistica] += BoosterClass*Valor 
		end
	end
	for NomeDaEstatistica, Valor in pairs(EstatisticaDoPlayer[Player].Arma) do
		if InfoPlayer.ItemStatistic[ArmaEquipada][NomeDaEstatistica] then 
			InfoPlayer.ItemStatistic[ArmaEquipada][NomeDaEstatistica] += Valor 
			InfoPlayer.ItemStatisticModificada[ArmaEquipada][NomeDaEstatistica] += BoosterItem*Valor 
		end
		if InfoPlayer.ClassStatistic[Classe][NomeDaEstatistica] then 
			InfoPlayer.ClassStatistic[Classe][NomeDaEstatistica] += Valor 
			InfoPlayer.ClassStatisticModificada[Classe][NomeDaEstatistica] += BoosterClass*Valor 
		end
		if NomeDaEstatistica == "Kills" then Kills += Valor end
		if NomeDaEstatistica == "Heal" then Heal += Valor end
		if NomeDaEstatistica == "Damage" then Damage += Valor end
	end
	for NomeDaEstatistica, Valor in pairs(EstatisticaDoPlayer[Player].Habilidade) do
		if InfoPlayer.ItemStatistic[HabilidadeEquipada][NomeDaEstatistica] then 
			InfoPlayer.ItemStatistic[HabilidadeEquipada][NomeDaEstatistica] += Valor 
			InfoPlayer.ItemStatisticModificada[HabilidadeEquipada][NomeDaEstatistica] += BoosterItem*Valor 
		end
		if InfoPlayer.ClassStatistic[Classe][NomeDaEstatistica] then 
			InfoPlayer.ClassStatistic[Classe][NomeDaEstatistica] += Valor 
			InfoPlayer.ClassStatisticModificada[Classe][NomeDaEstatistica] += BoosterClass*Valor 
		end
		if NomeDaEstatistica == "Kills" then Kills += Valor end
		if NomeDaEstatistica == "Heal" then Heal += Valor end
		if NomeDaEstatistica == "Damage" then Damage += Valor end
	end
	for NomeDaEstatistica, Valor in pairs(EstatisticaDoPlayer[Player].Armadura) do
		if InfoPlayer.ItemStatistic[ArmaduraEquipada][NomeDaEstatistica] then 
			InfoPlayer.ItemStatistic[ArmaduraEquipada][NomeDaEstatistica] += Valor 
			InfoPlayer.ItemStatisticModificada[ArmaduraEquipada][NomeDaEstatistica] += BoosterItem*Valor 
		end
		if InfoPlayer.ClassStatistic[Classe][NomeDaEstatistica] then 
			InfoPlayer.ClassStatistic[Classe][NomeDaEstatistica] += Valor 
			InfoPlayer.ClassStatisticModificada[Classe][NomeDaEstatistica] += BoosterClass*Valor 
		end
	end
	if not PlayerSaindo then
		InfoPlayer.ClassStatistic[Classe].Deaths += 1
		InfoPlayer.ClassStatisticModificada[Classe].Deaths += 1
	end
	table.clear(EstatisticaDoPlayer[Player].Arma)
	table.clear(EstatisticaDoPlayer[Player].Habilidade)
	table.clear(EstatisticaDoPlayer[Player].Armadura)
	for N,V in pairs(EstatisticaDoPlayer[Player]) do
		if type(V) == "table" then continue end
		EstatisticaDoPlayer[Player][N] = nil
	end
	return Kills,Damage,Heal
end

function Estatistica.AdicionarPlayer(Player:Player)
	EstatisticaDoPlayer[Player] = {
		Arma = {},
		Habilidade = {},
		Armadura = {}
	}
	setmetatable(EstatisticaDoPlayer[Player],Meta)
	setmetatable(EstatisticaDoPlayer[Player].Arma,Meta)
	setmetatable(EstatisticaDoPlayer[Player].Habilidade,Meta)
	setmetatable(EstatisticaDoPlayer[Player].Armadura,Meta)
end

function Estatistica.RemoverPlayer(Player:Player)
	Estatistica.RegistrarEstatistica(Player,true)
	EstatisticaDoPlayer[Player] = nil
end

function Estatistica.Damage(PlayerAutor:Player,PlayerAlvo:Player,Dano:number,Arma:boolean)
	PlayerInfo.AddMatchStatistic(PlayerAutor,Dano,"Damage")
	local Tipo = if Arma then "Arma" else "Habilidade"
	EstatisticaDoPlayer[PlayerAutor][Tipo]["Damage"] += Dano
	EstatisticaDoPlayer[PlayerAutor][Tipo]["Hits"] += 1
	EstatisticaDoPlayer[PlayerAlvo].Armadura["DamageTaken"] += Dano
	EstatisticaDoPlayer[PlayerAlvo].Armadura["HitsTake"] += 1
end

function Estatistica.Kill(PlayerAutor:Player,PlayerAlvo:Player,Arma:boolean)
	PlayerInfo.AddMatchStatistic(PlayerAutor,1,"Kills")
	PlayerInfo.AddMatchStatistic(PlayerAlvo,1,"Deaths")
	local Tipo = if Arma then "Arma" else "Habilidade"
	EstatisticaDoPlayer[PlayerAutor][Tipo]["Kills"] += 1
end

function Estatistica.Heal(Player:Player,Cura:number)
	PlayerInfo.AddMatchStatistic(Player,Cura,"Heal")
	EstatisticaDoPlayer[Player].Habilidade["Heal"] += Cura
end

function Estatistica.Hit(Player:Player)
	EstatisticaDoPlayer[Player].Habilidade["Hits"] += 1
end

function Estatistica.Inspired(Player:Player)
	EstatisticaDoPlayer[Player].Habilidade["ShotsB"] += 1
end

function Estatistica.Capture(Player:Player)
	EstatisticaDoPlayer[Player].Captures += 1
end

function Estatistica.Use(Player:Player)
	EstatisticaDoPlayer[Player].Habilidade.Uses += 1
end

function Estatistica.Shot(Player:Player)
	EstatisticaDoPlayer[Player].Arma.Shots += 1
end


return Estatistica

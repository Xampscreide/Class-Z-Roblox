local Configuracao = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Armas = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Armas"))
local Habilidades = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Habilidades"))
local Armaduras = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Armaduras"))
local ClassStat = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Classes"))

Configuracao.RespawnTime = 5
Configuracao.TempoProximaPartida = 10
Configuracao.InspiredeDefesa = 10
Configuracao.InspiredRange = 1.25
Configuracao.DamagingMultiplicador = 1.25
Configuracao.ExposedValor = 40
Configuracao.CursedMultiplier = 1.25
Configuracao.BerserkerMultiplier = 1.25
Configuracao.ArmoredMultiplier = 1.5
Configuracao.SpeedyMultiplier = 1.5
Configuracao.SlowedMultiplier = 0.5
Configuracao.HealingRatio = 90
Configuracao.Classes = {"Wizard","Rogue","Archer","Priest","Warrior","Knight","Paladin","Assassin","Necromancer","Huntress","Mystic","Sorcerer","Ninja","Samurai","Bard","Kensei"}
Configuracao.Effects = {"Healing","Poison","HPBoost","Stasis","Paralyzed","Slowed","Speedy","Berserk","Stunned","Cursed","Exposed","Inspired","Damaging"}

Configuracao.UnlockLevel = 1

Configuracao.Armas = Armas
Configuracao.Habilidades = Habilidades
Configuracao.Armaduras = Armaduras
Configuracao.Stat = ClassStat

Configuracao.ClassesPorArmadura = {
	robe = {"Wizard","Priest","Necromancer","Mystic","Sorcerer","Bard","Summoner"},
	leather = {"Rogue","Archer","Assassin","Huntress","Trickster","Ninja"},
	heavy = {"Warrior","Knight","Paladin","Samurai","Kensei"}
}

Configuracao.ClassesPorArma = {
	bow = {"Archer","Bard","Huntress"},
	sword = {"Warrior","Knight","Paladin"},
	katana = {"Samurai","Ninja","Kensei"},
	dagger = {"Assassin","Rogue","Trickster"},
	wand = {"Priest","Sorcerer","Summoner"},
	staff = {"Wizard","Necromancer","Mystic"}
}

Configuracao.RequesitosClasse = {
	Wizard = {},
	Priest = {},
	Archer = {},
	Rogue = {},
	Warrior = {},
	Necromancer = {"Wizard","Priest"},
	Assassin = {"Wizard","Rogue"},
	Huntress = {"Archer","Rogue"},
	Knight = {"Warrior"},
	Ninja = {"Rogue","Warrior"},
	Sorcerer = {"Necromancer","Assassin"},
	Mystic = {"Necromancer","Huntress"},
	Trickster = {"Assassin","Paladin"},
	Paladin = {"Knight","Priest"},
	Samurai = {"Ninja","Knight"},
	Summoner = {"Sorcerer","Mystic"},
	Bard = {"Huntress","Paladin"},
	Kensei = {"Ninja","Assassin"},
}

Configuracao.EquipamentoPorClasse = {}
for _,Classes in ipairs(Configuracao.Classes) do
	local ArmaTipo
	local ArmaduraTipo
	for Tipo, Classe in pairs(Configuracao.ClassesPorArma) do
		if table.find(Classe,Classes) then
			ArmaTipo = Tipo
			break
		end
	end
	for Tipo, Armaduras in pairs(Configuracao.ClassesPorArmadura) do
		if table.find(Armaduras,Classes) then
			ArmaduraTipo = Tipo
			break
		end
	end
	Configuracao.EquipamentoPorClasse[Classes] = {ArmaTipo,ArmaduraTipo}
end

Configuracao.ItensOrganizados = {}
for _,Classes in ipairs(Configuracao.Classes) do
	Configuracao.ItensOrganizados[Classes] = {}
	Configuracao.ItensOrganizados[Classes]["Arma"] = {}
	local TipoArma = Configuracao.EquipamentoPorClasse[Classes][1]
	for Arma,Conteudo in pairs(Armas) do
		if Conteudo.Type == TipoArma then
			table.insert(Configuracao.ItensOrganizados[Classes]["Arma"],Arma)
		end
	end
	local TipoArmadura = Configuracao.EquipamentoPorClasse[Classes][2]
	Configuracao.ItensOrganizados[Classes]["Armadura"] = {}
	for Armadura,Conteudo in pairs(Armaduras) do
		if Conteudo.Type == TipoArmadura then
			table.insert(Configuracao.ItensOrganizados[Classes]["Armadura"],Armadura)
		end
	end
	Configuracao.ItensOrganizados[Classes]["Habilidade"] = {}
	for Habilidade,Conteudo in pairs(Habilidades) do
		if Conteudo.Class == Classes then
			table.insert(Configuracao.ItensOrganizados[Classes]["Habilidade"],Habilidade)
		end
	end
end

Configuracao.ClasseIcones = {
	"rbxassetid://15056526912",
	"rbxassetid://15056517975",
	"rbxassetid://15056310357",
	"rbxassetid://15056515018",
	"rbxassetid://15056578724",
	"rbxassetid://15056447533",
	"rbxassetid://15056511746",
	"rbxassetid://15056311630",
	"rbxassetid://15056758480",
	"rbxassetid://15056442836",
	"rbxassetid://15056449680",
	"rbxassetid://15056523623",
	"rbxassetid://15056451587",
	"rbxassetid://15056519336",
	"rbxassetid://15056438904",
	"rbxassetid://15056445297",
}

for i,k in ipairs(Configuracao.Classes) do
	Configuracao.ClasseIcones[k] = Configuracao.ClasseIcones[i]
end

Configuracao.Cores = {Color3.fromRGB(255, 106, 0),Color3.fromRGB(162, 0, 255),Orange = Color3.fromRGB(255, 106, 0),Purple = Color3.fromRGB(162, 0, 255)}
Configuracao.Cores[Teams.Orange] = Color3.fromRGB(255, 106, 0)
Configuracao.Cores[Teams.Purple] = Color3.fromRGB(162, 0, 255)

Configuracao.ColorSequence = {
	ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(255, 106, 0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(136, 54, 0))},
	ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(162, 0, 255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(70, 0, 111))}
}
Configuracao.ColorSequence[Teams.Orange] = Configuracao.ColorSequence[1]
Configuracao.ColorSequence[Teams.Purple] = Configuracao.ColorSequence[2]

return Configuracao

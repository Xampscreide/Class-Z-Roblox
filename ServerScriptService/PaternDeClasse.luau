local Classes = {}

local Patern = {}

Patern["Archer"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Paralyzed = 0,
}

Patern["Wizard"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	HabilityDamage = 0,
}

Patern["Rogue"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	CloakTime = 0,
}

Patern["Priest"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Heal = 0,
}

Patern["Warrior"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Berserk = 0,
}

Patern["Knight"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Stun = 0,
}

Patern["Paladin"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Damaging = 0,
	Heal = 0,
}

Patern["Assassin"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	PoisonDamage = 0,
}

Patern["Necromancer"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Heal = 0,
}

Patern["Huntress"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Trap = 0,
}

Patern["Mystic"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Stasis = 0,
	Cursed = 0
}

Patern["Trickster"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	frenzy = 0,
	frenzyhits = 0,
}

Patern["Sorcerer"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	TargetsHit = 0,
}

Patern["Ninja"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Hit = 0,
}

Patern["Samurai"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Exposed = 0,
}

Patern["Bard"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	Inspired = 0,
	ShotsInspired = 0,
}

Patern["Summoner"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	summon_damage = 0,
}

Patern["Kensei"] = {
	Deaths = 0,
	Kills = 0,
	Damage = 0,
	DamageTaken = 0,
	Captures = 0,
	DashDamage = 0,
}

function Classes.Clone()
	local Tabela = {}
	for Classe,Conteudo in pairs(Patern) do
		Tabela[Classe] = table.clone(Conteudo)
	end
	return Tabela
end

return Classes

local habilidade = {}

local ServerStorage = game:GetService("ServerStorage")

habilidade["t0_poison"] = {
	MaxDistance = 80,
	TravelTime = 1,
	PoisonRange = 15,
	DamageInstantaneo = 250,
	Damage = 500,
	PoisonDuration = 2.5,
	MPCost = 90,
	Class = "Assassin",
	Rarity = 1,
	Name = "T0 Poison",
	Type = "Poison",
	Stats = {
		WIS = 2,
	},
	Show = {
		"MaxDistance",
		"TravelTime",
		"AreaEffect",
		"	",
		"PoisonRange",
		"DamageInstantaneo",
		"Damage",
		"PoisonDuration",
		"	",
		"MPCost"
	},
	Unlock = nil,
}

habilidade["t1_poison"] = {
	MaxDistance = 90,
	TravelTime = 1,
	PoisonRange = 15,
	DamageInstantaneo = 320,
	Damage = 650,
	PoisonDuration = 2.5,
	MPCost = 90,
	Class = "Assassin",
	Rarity = 2,
	Name = "T1 Poison",
	Type = "Poison",
	Stats = {
		WIS = 3,
	},
	Show = {
		"MaxDistance",
		"TravelTime",
		"AreaEffect",
		"	",
		"PoisonRange",
		"DamageInstantaneo",
		"Damage",
		"PoisonDuration",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Assassin"},10},
	},
}

habilidade["t2_poison"] = {
	MaxDistance = 90,
	TravelTime = 1,
	PoisonRange = 20,
	DamageInstantaneo = 350,
	Damage = 750,
	PoisonDuration = 2,
	MPCost = 100,
	Class = "Assassin",
	Rarity = 3,
	Name = "T2 Poison",
	Type = "Poison",
	Stats = {
		WIS = 5,
	},
	Show = {
		"MaxDistance",
		"TravelTime",
		"AreaEffect",
		"	",
		"PoisonRange",
		"DamageInstantaneo",
		"Damage",
		"PoisonDuration",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Assassin"},20},
	},
}

habilidade["t0_trap"] = {
	Damage = 500,
	SlowDuration = 3,
	TrapDuration = 5,
	TravelTime = 1,
	RaioExplosao = 30,
	RaioAtivacao = 15,
	MaxDistance = 80,
	MPCost = 95,
	Class = "Huntress",
	Rarity = 1,
	Name = "T0 Trap",
	Type = "Trap",
	Stats = {
		ATT = 3,
	},
	Show = {
		"MaxDistance",
		"TravelTime",
		"AreaEffect",
		"	",
		"RaioAtivacao",
		"RaioExplosao",
		"Damage",
		"SlowDuration",
		"	",
		"MPCost"
	},
	IndikatorA = "Slowed",
	Unlock = nil,
}

habilidade["t1_trap"] = {
	Damage = 650,
	SlowDuration = 4,
	TrapDuration = 6,
	TravelTime = 1,
	RaioExplosao = 30,
	RaioAtivacao = 15,
	MaxDistance = 90,
	MPCost = 100,
	Class = "Huntress",
	Rarity = 2,
	Name = "T1 Trap",
	Type = "Trap",
	Stats = {
		ATT = 4,
	},
	Show = {
		"MaxDistance",
		"TravelTime",
		"AreaEffect",
		"	",
		"RaioAtivacao",
		"RaioExplosao",
		"Damage",
		"SlowDuration",
		"	",
		"MPCost"
	},
	IndikatorA = "Slowed",
	Unlock = {
		Level = {{"Huntress"},10},
	},
}

habilidade["t2_trap"] = {
	Damage = 750,
	SlowDuration = 4.5,
	TrapDuration = 6,
	TravelTime = 1,
	RaioExplosao = 40,
	RaioAtivacao = 20,
	MaxDistance = 100,
	MPCost = 110,
	Class = "Huntress",
	Rarity = 3,
	Name = "T2 Trap",
	Type = "Trap",
	Stats = {
		ATT = 6,
	},
	Show = {
		"MaxDistance",
		"TravelTime",
		"AreaEffect",
		"	",
		"RaioAtivacao",
		"RaioExplosao",
		"Damage",
		"SlowDuration",
		"	",
		"MPCost"
	},
	IndikatorA = "Slowed",
	Unlock = {
		Level = {{"Huntress"},20},
	},
}

habilidade["t0_quiver"] = {
	Damage = 550,
	ProjetilSpeed = 150,
	ProjetilDistance = 125,
	ParalyzedDuration = 3,
	MPCost = 80,
	Class = "Archer",
	Rarity = 1,
	Name = "T0 Quiver",
	Type = "Poison",
	Stats = {
		DEX = 4,
	},
	Show = {
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"Pierce Effect",
		"ParalyzedDuration",
		"MPCost"
	},
	IndikatorD = "Paralyzed",
	Unlock = nil,
}

habilidade["t1_quiver"] = {
	Damage = 650,
	ProjetilSpeed = 150,
	ProjetilDistance = 125,
	ParalyzedDuration = 4,
	MPCost = 80,
	Class = "Archer",
	Rarity = 2,
	Name = "T1 Quiver",
	Type = "Poison",
	Stats = {
		DEX = 5,
	},
	Show = {
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"Pierce Effect",
		"ParalyzedDuration",
		"MPCost"
	},
	IndikatorD = "Paralyzed",
	Unlock = {
		Level = {{"Archer"},10},
	},
}

habilidade["t2_quiver"] = {
	Damage = 700,
	ProjetilSpeed = 200,
	ProjetilDistance = 125,
	ParalyzedDuration = 4.5,
	MPCost = 95,
	Class = "Archer",
	Rarity = 3,
	Name = "T2 Quiver",
	Type = "Poison",
	Stats = {
		DEX = 7,
	},
	Show = {
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"Pierce Effect",
		"ParalyzedDuration",
		"MPCost"
	},
	IndikatorD = "Paralyzed",
	Unlock = {
		Level = {{"Archer"},20},
	},
}

habilidade["t0_spell"] = {
	Damage = 700,
	ProjetilSpeed = 200	,
	ProjetilDistance = 100,
	MaxDistance = 75,
	ProjetilCount = 8,
	GapAngle = 45,
	MPCost = 90,
	Class = "Wizard",
	Rarity = 1,
	Name = "T0 Spell",
	Type = "Poison",
	Stats = {
		WIS = 4,
	},
	Show = {
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"ProjetilCount",
		"MPCost"
	},
	Unlock = nil,
}

habilidade["t1_spell"] = {
	Damage = 850,
	ProjetilSpeed = 200	,
	ProjetilDistance = 100,
	MaxDistance = 75,
	ProjetilCount = 8,
	GapAngle = 45,
	MPCost = 100,
	Class = "Wizard",
	Rarity = 2,
	Name = "T1 Spell",
	Type = "Poison",
	Stats = {
		WIS = 5,
	},
	Show = {
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"ProjetilCount",
		"MPCost"
	},
	Unlock = {
		Level = {{"Wizard"},10},
	},
}

habilidade["t2_spell"] = {
	Damage = 950,
	ProjetilSpeed = 260	,
	ProjetilDistance = 100,
	MaxDistance = 75,
	ProjetilCount = 8,
	GapAngle = 45,
	MPCost = 110,
	Class = "Wizard",
	Rarity = 3,
	Name = "T2 Spell",
	Type = "Poison",
	Stats = {
		WIS = 7,
	},
	Show = {
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"ProjetilCount",
		"MPCost"
	},
	Unlock = {
		Level = {{"Wizard"},20},
	},
}

habilidade["t0_tome"] = {
	Cura = 550,
	HealingDuration = 3,
	MaxDistance = 40,
	MPCost = 145,
	Class = "Priest",
	Rarity = 1,
	Name = "T0 Tome",
	Type = "Poison",
	Stats = {
		VIT = 4,
	},
	Show = {
		"MaxDistance",
		"Cura",
		"HealingDuration",
		"MPCost"
	},
	Unlock = nil,
}

habilidade["t1_tome"] = {
	Cura = 700,
	HealingDuration = 4,
	MaxDistance = 40,
	MPCost = 145,
	Class = "Priest",
	Rarity = 2,
	Name = "T1 Tome",
	Type = "Poison",
	Stats = {
		VIT = 5,
	},
	Show = {
		"MaxDistance",
		"Cura",
		"HealingDuration",
		"MPCost"
	},
	Unlock = {
		Level = {{"Priest"},10},
	},
}

habilidade["t2_tome"] = {
	Cura = 750,
	HealingDuration = 4.5,
	MaxDistance = 40,
	MPCost = 155,
	Class = "Priest",
	Rarity = 3,
	Name = "T2 Tome",
	Type = "Poison",
	Stats = {
		VIT = 7,
	},
	Show = {
		"MaxDistance",
		"Cura",
		"HealingDuration",
		"MPCost"
	},
	Unlock = {
		Level = {{"Priest"},20},
	},
}

habilidade["t0_helm"] = {
	BerserkDuration = 3,
	SpeedyDuration = 3,
	MaxDistance = 32.5,
	MPCost = 145,
	Class = "Warrior",
	Rarity = 1,
	Name = "T0 Helm",
	Type = "Poison",
	Stats = {
		DEF = 6,
	},
	Show = {
		"SpeedyDuration",
		"AreaEffect",
		"	",
		"MaxDistance",
		"BerserkDuration",
		"	",
		"MPCost"
	},
	Unlock = nil,
}

habilidade["t1_helm"] = {
	BerserkDuration = 4,
	SpeedyDuration = 4,
	MaxDistance = 35,
	MPCost = 145,
	Class = "Warrior",
	Rarity = 2,
	Name = "T1 Helm",
	Type = "Poison",
	Stats = {
		DEF = 7,
	},
	Show = {
		"SpeedyDuration",
		"AreaEffect",
		"	",
		"MaxDistance",
		"BerserkDuration",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Warrior"},10},
	},
}

habilidade["t2_helm"] = {
	BerserkDuration = 4.5,
	SpeedyDuration = 4.5,
	MaxDistance = 45,
	MPCost = 155,
	Class = "Warrior",
	Rarity = 3,
	Name = "T2 Helm",
	Type = "Poison",
	Stats = {
		DEF = 9,
	},
	Show = {
		"SpeedyDuration",
		"AreaEffect",
		"	",
		"MaxDistance",
		"BerserkDuration",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Warrior"},20},
	},
}

habilidade["t0_cloak"] = {
	InvisibilidadeDuration = 3,
	MPCost = 155,
	Class = "Rogue",
	Rarity = 1,
	Name = "T0 Cloak",
	Type = "Poison",
	Stats = {
		SPD = 4,
		DEX = 3,
	},
	Show = {
		"InvisibilidadeDuration",
		"MPCost"
	},
	Unlock = nil,
}

habilidade["t1_cloak"] = {
	InvisibilidadeDuration = 4,
	MPCost = 155,
	Class = "Rogue",
	Rarity = 2,
	Name = "T1 Cloak",
	Type = "Poison",
	Stats = {
		SPD = 5,
		DEX = 4,
	},
	Show = {
		"InvisibilidadeDuration",
		"MPCost"
	},
	Unlock = {
		Level = {{"Rogue"},10},
	},
}

habilidade["t2_cloak"] = {
	InvisibilidadeDuration = 4.5,
	MPCost = 155,
	Class = "Rogue",
	Rarity = 3,
	Name = "T2 Cloak",
	Type = "Poison",
	Stats = {
		SPD = 6,
		DEX = 6,
	},
	Show = {
		"InvisibilidadeDuration",
		"MPCost"
	},
	Unlock = {
		Level = {{"Rogue"},20},
	},
}

habilidade["t0_lute"] = {
	MaxDistance = 55,
	InspiredDuration = 3,
	MPCost = 230,
	Class = "Bard",
	Rarity = 1,
	Name = "T0 Lute",
	Type = "Poison",
	Stats = {
		DEF = 2,
	},
	Show = {
		"AreaEffect",
		"	",
		"MaxDistance",
		"InspiredDuration",
		"	",
		"MPCost"
	},
	Unlock = nil,
}

habilidade["t1_lute"] = {
	MaxDistance = 55,
	InspiredDuration = 4,
	MPCost = 230,
	Class = "Bard",
	Rarity = 2,
	Name = "T1 Lute",
	Type = "Poison",
	Stats = {
		DEF = 4,
	},
	Show = {
		"AreaEffect",
		"	",
		"MaxDistance",
		"InspiredDuration",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Bard"},10},
	},
}

habilidade["t2_lute"] = {
	MaxDistance = 75,
	InspiredDuration = 4.5,
	MPCost = 230,
	Class = "Bard",
	Rarity = 3,
	Name = "T2 Lute",
	Type = "Poison",
	Stats = {
		DEF = 6,
	},
	Show = {
		"AreaEffect",
		"	",
		"MaxDistance",
		"InspiredDuration",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Bard"},20},
	},
}

habilidade["t0_skull"] = {
	MaxDistance = 80,
	DistanciaCura = 37.5,
	DistanciaDamage = 15,
	Damage = 300,
	Cura = 300,
	MPCost = 145,
	IgnorarDef = 40,
	Class = "Necromancer",
	Rarity = 1,
	Name = "T0 Skull",
	Type = "Poison",
	Stats = {
		HP = 100,
	},
	Show = {
		"MaxDistance",
		"AreaEffect",
		"	",
		"DistanciaDamage",
		"Damage",
		"	",
		"AreaEffect",
		"	",
		"DistanciaCura",
		"Cura",
		"	",
		"MPCost"
	},
	Unlock = nil
}


habilidade["t1_skull"] = {
	MaxDistance = 80,
	DistanciaCura = 37.5,
	DistanciaDamage = 15,
	Damage = 350,
	Cura = 330,
	MPCost = 145,
	IgnorarDef = 40,
	Class = "Necromancer",
	Rarity = 2,
	Name = "T1 Skull",
	Type = "Poison",
	Stats = {
		HP = 120,
	},
	Show = {
		"MaxDistance",
		"AreaEffect",
		"	",
		"DistanciaDamage",
		"Damage",
		"	",
		"AreaEffect",
		"	",
		"DistanciaCura",
		"Cura",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Necromancer"},10},
	},
}

habilidade["t2_skull"] = {
	MaxDistance = 90,
	DistanciaCura = 45,
	DistanciaDamage = 18,
	Damage = 420,
	Cura = 360,
	MPCost = 155,
	IgnorarDef = 40,
	Class = "Necromancer",
	Rarity = 3,
	Name = "T2 Skull",
	Type = "Poison",
	Stats = {
		HP = 140,
	},
	Show = {
		"MaxDistance",
		"AreaEffect",
		"	",
		"DistanciaDamage",
		"Damage",
		"	",
		"AreaEffect",
		"	",
		"DistanciaCura",
		"Cura",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Necromancer"},20},
	},
}

habilidade["t0_seal"] = {
	MaxDistance = 35,
	HealingDuration = 3,
	DamagingDuration = 3,
	HPBoostDuration = 3,
	HPBoost = 550,
	MPCost = 140,
	Class = "Paladin",
	Rarity = 1,
	Name = "T0 Seal",
	Type = "Poison",
	Stats = {
		DEX = 3,
	},
	Show = {
		"AreaEffect",
		"	",
		"MaxDistance",
		"HealingDuration",
		"DamagingDuration",
		"HPBoostDuration",
		"HPBoost",
		"	",
		"MPCost"
	},
	Unlock = nil
}

habilidade["t1_seal"] = {
	MaxDistance = 35,
	HealingDuration = 4,
	DamagingDuration = 4,
	HPBoostDuration = 4,
	HPBoost = 600,
	MPCost = 140,
	Class = "Paladin",
	Rarity = 2,
	Name = "T1 Seal",
	Type = "Poison",
	Stats = {
		DEX = 5,
	},
	Show = {
		"AreaEffect",
		"	",
		"MaxDistance",
		"HealingDuration",
		"DamagingDuration",
		"HPBoostDuration",
		"HPBoost",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Paladin"},10},
	},
}

habilidade["t2_seal"] = {
	MaxDistance = 50,
	HealingDuration = 4.5,
	DamagingDuration = 4.5,
	HPBoostDuration = 4.5,
	HPBoost = 600,
	MPCost = 150,
	Class = "Paladin",
	Rarity = 3,
	Name = "T2 Seal",
	Type = "Poison",
	Stats = {
		DEX = 7,
	},
	Show = {
		"AreaEffect",
		"	",
		"MaxDistance",
		"HealingDuration",
		"DamagingDuration",
		"HPBoostDuration",
		"HPBoost",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Paladin"},20},
	},
}

habilidade["t0_orb"] = {
	StasisDuration = 1.5,
	CurseDuration = 3,
	DistanciaStasis = 15,
	DistanciaCurse = 35,
	MaxDistance = 80,
	MPCost = 125,
	Class = "Mystic",
	Rarity = 1,
	Name = "T0 Orb",
	Type = "Poison",
	Stats = {
		DEX = 2,
	},
	Show = {
		"MaxDistance",
		"AreaEffect",
		"	",
		"DistanciaStasis",
		"StasisDuration",
		"	",
		"AreaEffect",
		"	",
		"DistanciaCurse",
		"CurseDuration",
		"	",
		"MPCost"
	},
	Unlock = nil
}

habilidade["t1_orb"] = {
	StasisDuration = 2,
	CurseDuration = 4,
	DistanciaStasis = 15,
	DistanciaCurse = 35,
	MaxDistance = 85,
	MPCost = 125,
	Class = "Mystic",
	Rarity = 2,
	Name = "T1 Orb",
	Type = "Poison",
	Stats = {
		DEX = 3,
	},
	Show = {
		"MaxDistance",
		"AreaEffect",
		"	",
		"DistanciaStasis",
		"StasisDuration",
		"	",
		"AreaEffect",
		"	",
		"DistanciaCurse",
		"CurseDuration",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Mystic"},10},
	},
}

habilidade["t2_orb"] = {
	StasisDuration = 2.5,
	CurseDuration = 4.5,
	DistanciaStasis = 15,
	DistanciaCurse = 35,
	MaxDistance = 85,
	MPCost = 135,
	Class = "Mystic",
	Rarity = 3,
	Name = "T2 Orb",
	Type = "Poison",
	Stats = {
		DEX = 5,
	},
	Show = {
		"MaxDistance",
		"AreaEffect",
		"	",
		"DistanciaStasis",
		"StasisDuration",
		"	",
		"AreaEffect",
		"	",
		"DistanciaCurse",
		"CurseDuration",
		"	",
		"MPCost"
	},
	Unlock = {
		Level = {{"Mystic"},20},
	},
}


habilidade["t0_scepter"] = {
	Damage = 460,
	Targets = 6,
	GapAngle = 30,
	MaxDistance = 50,
	MPCost = 100,
	Class = "Sorcerer",
	Rarity = 1,
	Name = "T0 Scepter",
	Type = "Poison",
	Stats = {
		SPD = 2,
	},
	Show = {
		"MaxDistance",
		"Damage",
		"Targets",
		"GapAngle",
		"MPCost"
	},
	Unlock = nil
}

habilidade["t1_scepter"] = {
	Damage = 480,
	Targets = 7,
	GapAngle = 30,
	MaxDistance = 65,
	MPCost = 110,
	Class = "Sorcerer",
	Rarity = 2,
	Name = "T1 Scepter",
	Type = "Poison",
	Stats = {
		SPD = 4,
	},
	Show = {
		"MaxDistance",
		"Damage",
		"Targets",
		"GapAngle",
		"MPCost"
	},
	Unlock = {
		Level = {{"Sorcerer"},10},
	},
}

habilidade["t2_scepter"] = {
	Damage = 520,
	Targets = 8,
	GapAngle = 30,
	MaxDistance = 75,
	MPCost = 120,
	Class = "Sorcerer",
	Rarity = 3,
	Name = "T2 Scepter",
	Type = "Poison",
	Stats = {
		SPD = 6,
	},
	Show = {
		"MaxDistance",
		"Damage",
		"Targets",
		"GapAngle",
		"MPCost"
	},
	Unlock = {
		Level = {{"Sorcerer"},20},
	},
}

habilidade["t0_star"] = {
	Damage = 850,
	MPPerTime = 60,
	ProjetilDistance = 75,
	ProjetilSpeed = 150,
	MPCost = 80,
	Class = "Ninja",
	Rarity = 1,
	Name = "T0 Star",
	Type = "Poison",
	Stats = {
		VIT = 6,
	},
	Show = {
		"MPPerTime",
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"Pierce Effect",
		"MPCost"
	},
	Unlock = nil
}

habilidade["t1_star"] = {
	Damage = 1000,
	MPPerTime = 60,
	ProjetilDistance = 80,
	ProjetilSpeed = 220,
	MPCost = 80,
	Class = "Ninja",
	Rarity = 2,
	Name = "T1 Star",
	Type = "Poison",
	Stats = {
		VIT = 7,
	},
	Show = {
		"MPPerTime",
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"Pierce Effect",
		"MPCost"
	},
	Unlock = {
		Level = {{"Ninja"},10},
	},
}

habilidade["t2_star"] = {
	Damage = 1200,
	MPPerTime = 60,
	ProjetilDistance = 80,
	ProjetilSpeed = 220,
	MPCost = 85,
	Class = "Ninja",
	Rarity = 3,
	Name = "T2 Star",
	Type = "Poison",
	Stats = {
		VIT = 8,
	},
	Show = {
		"MPPerTime",
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"Pierce Effect",
		"MPCost"
	},
	Unlock = {
		Level = {{"Ninja"},20},
	},
}

habilidade["t0_wakizashi"] = {
	Damage = 600,
	ProjetilSpeed = 90,
	ProjetilDistance = 31.5,
	MaxDistance = 40,
	ExposedDuration = 3,
	ProjetilCount = 4,
	MPCost = 75,
	OFFSet = 3,
	Class = "Samurai",
	Rarity = 1,
	Name = "T0 Wakizashi",
	Type = "Poison",
	Stats = {
		DEX = 4,
	},
	Show = {
		"MaxDistance",
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"ProjetilCount",
		"Pierce Effect",
		"ExposedDuration",
		"MPCost"
	},
	IndikatorD = "Exposed",
	Unlock = nil
}

habilidade["t1_wakizashi"] = {
	Damage = 750,
	ProjetilSpeed = 90,
	ProjetilDistance = 31.5,
	MaxDistance = 40,
	ExposedDuration = 4,
	ProjetilCount = 4,
	MPCost = 75,
	OFFSet = 3,
	Class = "Samurai",
	Rarity = 2,
	Name = "T1 Wakizashi",
	Type = "Poison",
	Stats = {
		DEX = 5,
	},
	Show = {
		"MaxDistance",
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"ProjetilCount",
		"Pierce Effect",
		"ExposedDuration",
		"MPCost"
	},
	IndikatorD = "Exposed",
	Unlock = {
		Level = {{"Samurai"},10},
	},
}

habilidade["t2_wakizashi"] = {
	Damage = 750,
	ProjetilSpeed = 90,
	ProjetilDistance = 31.5,
	MaxDistance = 45,
	ExposedDuration = 4.5,
	ProjetilCount = 5,
	MPCost = 80,
	OFFSet = 3,
	Class = "Samurai",
	Rarity = 3,
	Name = "T2 Wakizashi",
	Type = "Poison",
	Stats = {
		DEX = 6,
	},
	Show = {
		"MaxDistance",
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"ProjetilCount",
		"Pierce Effect",
		"ExposedDuration",
		"MPCost"
	},
	IndikatorD = "Exposed",
	Unlock = {
		Level = {{"Samurai"},20},
	},
}

habilidade["t0_shield"] = {
	Damage = 350,
	ProjetilDistance = 35,
	ProjetilSpeed = 160,
	StunnedDuration = 3,
	ProjetilCount = 4,
	MPCost = 110,
	GapAngle = 10,
	Class = "Knight",
	Rarity = 1,
	Name = "T0 Shield",
	Type = "Poison",
	Stats = {
		DEF = 8,
	},
	Show = {
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"ProjetilCount",
		"Pierce Effect",
		"StunnedDuration",
		"MPCost",
	},
	IndikatorD = "Stunned",
	Unlock = nil
}

habilidade["t1_shield"] = {
	Damage = 400,
	ProjetilDistance = 35,
	ProjetilSpeed = 160,
	StunnedDuration = 4,
	ProjetilCount = 5,
	MPCost = 110,
	GapAngle = 10,
	Class = "Knight",
	Rarity = 2,
	Name = "T1 Shield",
	Type = "Poison",
	Stats = {
		DEF = 9,
	},
	Show = {
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"ProjetilCount",
		"Pierce Effect",
		"StunnedDuration",
		"MPCost",
	},
	IndikatorD = "Stunned",
	Unlock = {
		Level = {{"Knight"},10},
	},
}

habilidade["t2_shield"] = {
	Damage = 400,
	ProjetilDistance = 40,
	ProjetilSpeed = 160,
	StunnedDuration = 4.5,
	ProjetilCount = 5,
	MPCost = 115,
	GapAngle = 10,
	Class = "Knight",
	Rarity = 3,
	Name = "T2 Shield",
	Type = "Poison",
	Stats = {
		DEF = 10,
	},
	Show = {
		"Damage",
		"ProjetilDistance",
		"ProjetilSpeed",
		"ProjetilCount",
		"Pierce Effect",
		"StunnedDuration",
		"MPCost",
	},
	IndikatorD = "Stunned",
	Unlock = {
		Level = {{"Knight"},20},
	},
}

habilidade["t0_sheats"] = {
	DamageTrail = 750,
	DashMaxDistance = 32.5,
	MPCost = 115,
	Class = "Kensei",
	Rarity = 1,
	Name = "T0 Sheats",
	Type = "Poison",
	Stats = {
		DEF = 4,
	},
	Show = {
		"Damage",
		"Pierce Effect",
		"DamageTrail",
		"DashMaxDistance",
	},
	Unlock = nil
}

habilidade["t1_sheats"] = {
	DamageTrail = 850,
	DashMaxDistance = 32.5,
	MPCost = 115,
	Class = "Kensei",
	Rarity = 2,
	Name = "T1 Sheats",
	Type = "Poison",
	Stats = {
		DEF = 5,
	},
	Show = {
		"Damage",
		"Pierce Effect",
		"DamageTrail",
		"DashMaxDistance",
	},
	Unlock = {
		Level = {{"Kensei"},10},
	},
}

habilidade["t2_sheats"] = {
	DamageTrail = 960,
	DashMaxDistance = 40,
	MPCost = 115,
	Class = "Kensei",
	Rarity = 3,
	Name = "T2 Sheats",
	Type = "Poison",
	Stats = {
		DEF = 6,
	},
	Show = {
		"Damage",
		"Pierce Effect",
		"DamageTrail",
		"DashMaxDistance",
	},
	Unlock = {
		Level = {{"Kensei"},20},
	},
}

return habilidade

local arma = {}

local ServerStorage = game:GetService("ServerStorage")

arma["t0_bow"] = {
	Damage = 115,
	ProjetilSpeed = 255,
	ProjetilDistance = 60,
	Type = "bow",
	Pierce = false,
	Rarity = 1,
	Name = "T0 Bow",
	Unlock = nil,
}

arma["t1_bow"] = {
	Damage = 125,
	ProjetilSpeed = 255,
	ProjetilDistance = 60,
	Type = "bow",
	Pierce = false,
	Rarity = 2,
	Name = "T1 Bow",
	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},5},
	},
}

arma["t2_bow"] = {
	Damage = 135,
	ProjetilSpeed = 255,
	ProjetilDistance = 60,
	Type = "bow",
	Pierce = false,
	Rarity = 3,
	Name = "T2 Bow",
	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},10},
	},
}

arma["t3_bow"] = {
	Damage = 145,
	ProjetilSpeed = 255,
	ProjetilDistance = 60,
	Type = "bow",
	Pierce = false,
	Rarity = 4,
	Name = "T3 Bow",
	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},15},
	},
}

arma["t4_bow"] = {
	Damage = 155,
	ProjetilSpeed = 255,
	ProjetilDistance = 60,
	Type = "bow",
	Pierce = false,
	Rarity = 5,
	Name = "T4 Bow",
	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},20},
	},
}

arma["DEX_bow"] = {
	Damage = 125,
	ProjetilSpeed = 255,
	ProjetilDistance = 60,
	Type = "bow",
	Pierce = false,
	Rarity = 6,
	Name = "Bow of Dexterity",
	Stats = {
		DEX = 10,
	},
	Unlock = {
		ItemStatistic = {{"t0_bow","Shots",4000},{"t1_bow","Shots",4000},{"t2_bow","Shots",4000},{"t3_bow","Shots",4000},{"t4_bow","Shots",4000}}
	},
}

arma["ATT_bow"] = {
	Damage = 125,
	ProjetilSpeed = 255,
	ProjetilDistance = 60,
	Type = "bow",
	Pierce = false,
	Rarity = 7,
	Name = "Bow of Attack",
	Stats = {
		ATT = 7,
	},
	Unlock = {
		ItemStatistic = {{"t0_bow","Damage",500000},{"t1_bow","Damage",500000},{"t2_bow","Damage",500000},{"t3_bow","Damage",500000},{"t4_bow","Damage",500000}}
	},
}

arma["t0_sword"] = {
	Damage = 180,
	ProjetilSpeed = 165,
	ProjetilDistance = 30,
	Type = "sword",
	Pierce = false,
	Rarity = 1,
	Name = "T0 Sword",
	Unlock = nil
}

arma["t1_sword"] = {
	Damage = 190,
	ProjetilSpeed = 165,
	ProjetilDistance = 30,
	Type = "sword",
	Pierce = false,
	Rarity = 2,
	Name = "T1 Sword",
	Unlock = {
		AnyLevel = {{"Knight","Warrior","Paladin"},5},
	},
}

arma["t2_sword"] = {
	Damage = 200,
	ProjetilSpeed = 165,
	ProjetilDistance = 30,
	Type = "sword",
	Pierce = false,
	Rarity = 3,
	Name = "T2 Sword",
	Unlock = {
		AnyLevel = {{"Knight","Warrior","Paladin"},10},
	},
}

arma["t3_sword"] = {
	Damage = 215,
	ProjetilSpeed = 165,
	ProjetilDistance = 30,
	Type = "sword",
	Pierce = false,
	Rarity = 4,
	Name = "T3 Sword",
	Unlock = {
		AnyLevel = {{"Knight","Warrior","Paladin"},15},
	},
}

arma["t4_sword"] = {
	Damage = 230,
	ProjetilSpeed = 165,
	ProjetilDistance = 30,
	Type = "sword",
	Pierce = false,
	Rarity = 5,
	Name = "T4 Sword",
	Unlock = {
		AnyLevel = {{"Knight","Warrior","Paladin"},20},
	},
}

arma["DEX_sword"] = {
	Damage = 190,
	ProjetilSpeed = 165,
	ProjetilDistance = 30,
	Type = "sword",
	Pierce = false,
	Rarity = 6,
	Name = "Sword of Dexterity",
	Stats = {
		DEX = 10,
	},
	Unlock = {
		ItemStatistic = {{"t0_sword","Shots",3500},{"t1_sword","Shots",3500},{"t2_sword","Shots",3500},{"t3_sword","Shots",3500},{"t4_sword","Shots",3500}}
	},
}

arma["ATT_sword"] = {
	Damage = 190,
	ProjetilSpeed = 165,
	ProjetilDistance = 30,
	Type = "sword",
	Pierce = false,
	Rarity = 7,
	Name = "Sword of Attack",
	Stats = {
		ATT = 7,
	},
	Unlock = {
		ItemStatistic = {{"t0_sword","Damage",600000},{"t1_sword","Damage",600000},{"t2_sword","Damage",600000},{"t3_sword","Damage",600000},{"t4_sword","Damage",600000}}
	},
}

arma["t0_wand"] = {
	Damage = 104,
	ProjetilSpeed = 285,
	ProjetilDistance = 75,
	Type = "wand",
	Pierce = true,
	Rarity = 1,
	Name = "T0 Wand",
	Unlock = nil,
}

arma["t1_wand"] = {
	Damage = 112,
	ProjetilSpeed = 285,
	ProjetilDistance = 75,
	Type = "wand",
	Pierce = true,
	Rarity = 2,
	Name = "T1 Wand",
	Unlock = {
		AnyLevel = {{"Sorcerer","Priest"},5},
	},
}

arma["t2_wand"] = {
	Damage = 120,
	ProjetilSpeed = 285,
	ProjetilDistance = 75,
	Type = "wand",
	Pierce = true,
	Rarity = 3,
	Name = "T2 Wand",
	Unlock = {
		AnyLevel = {{"Sorcerer","Priest"},10},
	},
}

arma["t3_wand"] = {
	Damage = 128,
	ProjetilSpeed = 285,
	ProjetilDistance = 75,
	Type = "wand",
	Pierce = true,
	Rarity = 4,
	Name = "T3 Wand",
	Unlock = {
		AnyLevel = {{"Sorcerer","Priest"},15},
	},
}

arma["t4_wand"] = {
	Damage = 136,
	ProjetilSpeed = 285,
	ProjetilDistance = 75,
	Type = "wand",
	Pierce = true,
	Rarity = 5,
	Name = "T4 Wand",
	Unlock = {
		AnyLevel = {{"Sorcerer","Priest"},20},
	},
}

arma["DEX_wand"] = {
	Damage = 112,
	ProjetilSpeed = 285,
	ProjetilDistance = 75,
	Type = "wand",
	Pierce = true,
	Rarity = 6,
	Name = "Wand of Dexterity",
	Stats = {
		DEX = 10,
	},
	Unlock = {
		ItemStatistic = {{"t0_wand","Shots",4000},{"t1_wand","Shots",4000},{"t2_wand","Shots",4000},{"t3_wand","Shots",4000},{"t4_wand","Shots",4000}}
	},
}

arma["ATT_wand"] = {
	Damage = 112,
	ProjetilSpeed = 285,
	ProjetilDistance = 75,
	Type = "wand",
	Pierce = true,
	Rarity = 7,
	Name = "Wand of Attack",
	Stats = {
		ATT = 7,
	},
	Unlock = {
		ItemStatistic = {{"t0_wand","Damage",380000},{"t1_wand","Damage",380000},{"t2_wand","Damage",380000},{"t3_wand","Damage",380000},{"t4_wand","Damage",380000}}
	},
}

arma["t0_katana"] = {
	Damage = 170,
	ProjetilSpeed = 285,
	ProjetilDistance = 40,
	Type = "katana",
	Pierce = true,
	Rarity = 1,
	Name = "T0 Katana",
	Unlock = nil,
}

arma["t1_katana"] = {
	Damage = 170,
	ProjetilSpeed = 285,
	ProjetilDistance = 40,
	Type = "katana",
	Pierce = true,
	Rarity = 2,
	Name = "T1 Katana",
	Unlock = {
		AnyLevel = {{"Kensei","Ninja","Samurai"},5},
	},
}

arma["t2_katana"] = {
	Damage = 170,
	ProjetilSpeed = 285,
	ProjetilDistance = 40,
	Type = "katana",
	Pierce = true,
	Rarity = 3,
	Name = "T2 Katana",
	Unlock = {
		AnyLevel = {{"Kensei","Ninja","Samurai"},10},
	},
}

arma["t3_katana"] = {
	Damage = 182,
	ProjetilSpeed = 285,
	ProjetilDistance = 40,
	Type = "katana",
	Pierce = true,
	Rarity = 4,
	Name = "T3 Katana",
	Unlock = {
		AnyLevel = {{"Kensei","Ninja","Samurai"},15},
	},
}

arma["t4_katana"] = {
	Damage = 194,
	ProjetilSpeed = 285,
	ProjetilDistance = 40,
	Type = "katana",
	Pierce = true,
	Rarity = 5,
	Name = "T4 Katana",
	Unlock = {
		AnyLevel = {{"Kensei","Ninja","Samurai"},20},
	},
}

arma["DEX_katana"] = {
	Damage = 170,
	ProjetilSpeed = 285,
	ProjetilDistance = 40,
	Type = "katana",
	Pierce = true,
	Rarity = 6,
	Stats = {
		DEX = 10,
	},
	Name = "Katana of Dexterity",
	Unlock = {
		ItemStatistic = {{"t0_katana","Shots",4000},{"t1_katana","Shots",4000},{"t2_katana","Shots",4000},{"t3_katana","Shots",4000},{"t4_katana","Shots",4000}}
	},
}

arma["ATT_katana"] = {
	Damage = 170,
	ProjetilSpeed = 285,
	ProjetilDistance = 40,
	Type = "katana",
	Pierce = true,
	Rarity = 7,
	Stats = {
		ATT = 7,
	},
	Name = "Katana of Attack",
	Unlock = {
		ItemStatistic = {{"t0_katana","Damage",440000},{"t1_katana","Damage",440000},{"t2_katana","Damage",440000},{"t3_katana","Damage",440000},{"t4_katana","Damage",440000}}
	},
}

arma["t0_staff"] = {
	Damage = 120,
	ProjetilSpeed = 285,
	ProjetilDistance = 71,
	Type = "staff",
	Pierce = false,
	Rarity = 1,
	Name = "T0 Staff",
	Unlock = nil,
}

arma["t1_staff"] = {
	Damage = 125,
	ProjetilSpeed = 285,
	ProjetilDistance = 71,
	Type = "staff",
	Pierce = false,
	Rarity = 2,
	Name = "T1 Staff",
	Unlock = {
		AnyLevel = {{"Wizard","Mystic","Necromancer"},5},
	},
}

arma["t2_staff"] = {
	Damage = 130,
	ProjetilSpeed = 285,
	ProjetilDistance = 71,
	Type = "staff",
	Pierce = false,
	Rarity = 3,
	Name = "T2 Staff",
	Unlock = {
		AnyLevel = {{"Wizard","Mystic","Necromancer"},10},
	},
}

arma["t3_staff"] = {
	Damage = 136,
	ProjetilSpeed = 285,
	ProjetilDistance = 71,
	Type = "staff",
	Pierce = false,
	Rarity = 4,
	Name = "T3 Staff",
	Unlock = {
		AnyLevel = {{"Wizard","Mystic","Necromancer"},15},
	},
}

arma["t4_staff"] = {
	Damage = 142,
	ProjetilSpeed = 285,
	ProjetilDistance = 71,
	Type = "staff",
	Pierce = false,
	Rarity = 5,
	Name = "T4 Staff",
	Unlock = {
		AnyLevel = {{"Wizard","Mystic","Necromancer"},20},
	},
}

arma["DEX_staff"] = {
	Damage = 125,
	ProjetilSpeed = 285,
	ProjetilDistance = 71,
	Type = "staff",
	Pierce = false,
	Rarity = 6,
	Stats = {
		DEX = 10,
	},
	Name = "Staff of Dexterity",
	Unlock = {
		ItemStatistic = {{"t0_staff","Shots",4000},{"t1_staff","Shots",4000},{"t2_staff","Shots",4000},{"t3_staff","Shots",4000},{"t4_staff","Shots",4000}}
	},
}

arma["ATT_staff"] = {
	Damage = 125,
	ProjetilSpeed = 285,
	ProjetilDistance = 71,
	Type = "staff",
	Pierce = false,
	Rarity = 7,
	Stats = {
		ATT = 7,
	},
	Name = "Staff of Attack",
	Unlock = {
		ItemStatistic = {{"t0_staff","Damage",380000},{"t1_staff","Damage",380000},{"t2_staff","Damage",380000},{"t3_staff","Damage",380000},{"t4_staff","Damage",380000}}
	},
}

arma["t0_dagger"] = {
	Damage = 130,
	ProjetilSpeed = 220,
	ProjetilDistance = 46,
	Type = "dagger",
	Pierce = false,
	Rarity = 1,
	Name = "T0 Dagger",
	Unlock = nil,
}

arma["t1_dagger"] = {
	Damage = 140,
	ProjetilSpeed = 220,
	ProjetilDistance = 46,
	Type = "dagger",
	Pierce = false,
	Rarity = 2,
	Name = "T1 Dagger",
	Unlock = {
		AnyLevel = {{"Rogue","Assassin"},5},
	},
}

arma["t2_dagger"] = {
	Damage = 150,
	ProjetilSpeed = 220,
	ProjetilDistance = 46,
	Type = "dagger",
	Pierce = false,
	Rarity = 3,
	Name = "T2 Dagger",
	Unlock = {
		AnyLevel = {{"Rogue","Assassin"},10},
	},
}

arma["t3_dagger"] = {
	Damage = 160,
	ProjetilSpeed = 220,
	ProjetilDistance = 46,
	Type = "dagger",
	Pierce = false,
	Rarity = 4,
	Name = "T3 Dagger",
	Unlock = {
		AnyLevel = {{"Rogue","Assassin"},15},
	},
}

arma["t4_dagger"] = {
	Damage = 170,
	ProjetilSpeed = 220,
	ProjetilDistance = 46,
	Type = "dagger",
	Pierce = false,
	Rarity = 5,
	Name = "T4 Dagger",
	Unlock = {
		AnyLevel = {{"Rogue","Assassin"},20},
	},
}

arma["DEX_dagger"] = {
	Damage = 140,
	ProjetilSpeed = 220,
	ProjetilDistance = 46,
	Type = "dagger",
	Pierce = false,
	Rarity = 6,
	Stats = {
		DEX = 10,
	},
	Name = "Dagger of Dexterity",
	Unlock = {
		ItemStatistic = {{"t0_dagger","Shots",4000},{"t1_dagger","Shots",4000},{"t2_dagger","Shots",4000},{"t3_dagger","Shots",4000},{"t4_dagger","Shots",4000}}
	},
}

arma["ATT_dagger"] = {
	Damage = 140,
	ProjetilSpeed = 220,
	ProjetilDistance = 46,
	Type = "dagger",
	Pierce = false,
	Rarity = 7,
	Stats = {
		ATT = 7,
	},
	Name = "Dagger of Attack",
	Unlock = {
		ItemStatistic = {{"t0_dagger","Damage",400000},{"t1_dagger","Damage",400000},{"t2_dagger","Damage",400000},{"t3_dagger","Damage",400000},{"t4_dagger","Damage",400000}}
	},
}

return arma

--[[arma["t1_bow"] = {
	Damage = 80,
	ProjetilSpeed = 150,
	ProjetilDistance = 75,
	Type = "bow",
	Rarity = 2,
	Name = "Arco de Soja",
	
	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},10},
		Level = {{"Archer","Bard"},10},
		--ClassStatistic = {{"Archer","vitimas",5}}
	},
	Statistic = {"Damage"},
}

arma["t2_bow"] = {
	Damage = 80,
	ProjetilSpeed = 150,
	ProjetilDistance = 75,
	Type = "bow",
	Rarity = 3,
	Name = "Arco de Bambu",
	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},10},
		Level = {{"Archer","Bard"},30},
		--ClassStatistic = {{"Archer","vitimas",5}}
	},
	Statistic = {"Damage"},
}

arma["t3_bow"] = {
	Damage = 80,
	ProjetilSpeed = 150,
	ProjetilDistance = 75,
	Type = "bow",
	Rarity = 4,
	Name = "Arco de Negresco",
	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},10},
		Level = {{"Archer","Bard"},30},
		--ClassStatistic = {{"Archer","vitimas",5}}
	},
	Statistic = {"Damage"},
}

arma["t4_bow"] = {
	Damage = 80,
	ProjetilSpeed = 150,
	ProjetilDistance = 75,
	Type = "bow",
	Rarity = 5,
	Name = "Arco de Salguero",
	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},10},
		Level = {{"Archer","Bard","Warrior"},30},
		ClassStatistic = {{"Archer","Kills",5}},
		ItemStatistic = {{"t3_bow","Damage",6}}
	},
	Statistic = {"Damage"},
	Stats = {
		ATT = 10,
	},
	Mod = {
		Cadencia = 1.2,
	},
}

arma["t7_bow"] = {
	Damage = 80,
	ProjetilSpeed = 150,
	ProjetilDistance = 75,
	Type = "bow",
	Rarity = 2,
	Name = "Arco de Soja",

	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},10},
		Level = {{"Archer","Bard"},10},
		--ClassStatistic = {{"Archer","vitimas",5}}
	},
	Statistic = {"Damage"},
}

arma["t5_bow"] = {
	Damage = 80,
	ProjetilSpeed = 150,
	ProjetilDistance = 75,
	Type = "bow",
	Rarity = 2,
	Name = "Arco de Soja",

	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},10},
		Level = {{"Archer","Bard"},10},
		--ClassStatistic = {{"Archer","vitimas",5}}
	},
	Statistic = {"Damage"},
}

arma["t6_bow"] = {
	Damage = 80,
	ProjetilSpeed = 150,
	ProjetilDistance = 75,
	Type = "bow",
	Rarity = 2,
	Name = "Arco de Soja",

	Unlock = {
		AnyLevel = {{"Archer","Bard","Huntress"},10},
		Level = {{"Archer","Bard"},10},
		--ClassStatistic = {{"Archer","vitimas",5}}
	},
	Statistic = {"Damage"},
}]]



local Armaduras = {}

Armaduras["t0_leather"] = {
	Type = "leather",
	Rarity = 1,
	Name = "T0 Leather Armor",
	Unlock = nil,
	Stats = {
		DEF = 14,
		DEX = 3,
	}
}

Armaduras["t1_leather"] = {
	Type = "leather",
	Rarity = 2,
	Name = "T1 Leather Armor",
	Stats = {
		DEF = 15,
		DEX = 4,
	},
	Unlock = {
		AnyLevel = {{"Archer","Huntress","Assassin","Rogue","Huntress","Ninja"},5},
	},
}

Armaduras["t2_leather"] = {
	Type = "leather",
	Rarity = 3,
	Name = "T2 Leather Armor",
	Stats = {
		DEF = 16,
		DEX = 4,
	},
	Unlock = {
		AnyLevel = {{"Archer","Huntress","Assassin","Rogue","Huntress","Ninja"},10},
	},
}

Armaduras["t3_leather"] = {
	Type = "leather",
	Rarity = 4,
	Name = "T3 Leather Armor",
	Stats = {
		DEF = 17,
		DEX = 4,
	},
	Unlock = {
		AnyLevel = {{"Archer","Huntress","Assassin","Rogue","Huntress","Ninja"},15},
	},
}

Armaduras["t4_leather"] = {
	Type = "leather",
	Rarity = 5,
	Name = "T4 Leather Armor",
	Stats = {
		DEF = 18,
		DEX = 5,
	},
	Unlock = {
		AnyLevel = {{"Archer","Huntress","Assassin","Rogue","Huntress","Ninja"},20},
	},
}

Armaduras["Hard_leather"] = {
	Type = "leather",
	Rarity = 6,
	Name = "Hardened Leather Armor",
	Stats = {
		DEF = 24,
		SPD = -6,
	},
	Unlock = {
		ItemStatistic = {{"t0_leather","HitsTake",1000},{"t1_leather","HitsTake",1000},{"t2_leather","HitsTake",1000},{"t3_leather","HitsTake",1000},{"t4_leather","HitsTake",1000}},
	},
}

Armaduras["pure_leather"] = {
	Type = "leather",
	Rarity = 7,
	Name = "Pure Leather Armor",
	Stats = {
		DEF = 18,
		DEX = 5,
		HP = 300,
	},
	Unlock = {
		ItemStatistic = {{"t0_leather","DamageTaken",600000},{"t1_leather","DamageTaken",600000},{"t2_leather","DamageTaken",600000},{"t3_leather","DamageTaken",600000},{"t4_leather","DamageTaken",600000}},
	},
}

Armaduras["t0_robe"] = {
	Type = "robe",
	Rarity = 1,
	Name = "T0 Robe Armor",
	Unlock = nil,
	Stats = {
		DEF = 9,
		ATT = 2,
		WIS = 5,
		MP = 40,
	}
}

Armaduras["t1_robe"] = {
	Type = "robe",
	Rarity = 2,
	Name = "T1 Robe Armor",
	Stats = {
		DEF = 10,
		ATT = 2,
		WIS = 6,
		MP = 45,
	},
	Unlock = {
		AnyLevel = {{"Wizard","Necromancer","Sorcerer","Priest","Bard","Mystic"},5},
	},
}

Armaduras["t2_robe"] = {
	Type = "robe",
	Rarity = 3,
	Name = "T2 Robe Armor",
	Stats = {
		DEF = 11,
		ATT = 3,
		WIS = 7,
		MP = 50,
	},
	Unlock = {
		AnyLevel = {{"Wizard","Necromancer","Sorcerer","Priest","Bard","Mystic"},10},
	},
}

Armaduras["t3_robe"] = {
	Type = "robe",
	Rarity = 4,
	Name = "T3 Robe Armor",
	Stats = {
		DEF = 12,
		ATT = 4,
		WIS = 8,
		MP = 50,
	},
	Unlock = {
		AnyLevel = {{"Wizard","Necromancer","Sorcerer","Priest","Bard","Mystic"},15},
	},
}

Armaduras["t4_robe"] = {
	Type = "robe",
	Rarity = 5,
	Name = "T4 Robe Armor",
	Stats = {
		DEF = 13,
		ATT = 5,
		WIS = 9,
		MP = 55,
	},
	Unlock = {
		AnyLevel = {{"Wizard","Necromancer","Sorcerer","Priest","Bard","Mystic"},20},
	},
}

Armaduras["Hard_robe"] = {
	Type = "robe",
	Rarity = 6,
	Name = "Hardened Robe Armor",
	Stats = {
		DEF = 20,
		SPD = -6,
		WIS = 7,
		MP = 30,
	},
	Unlock = {
		ItemStatistic = {{"t0_robe","HitsTake",900},{"t1_robe","HitsTake",900},{"t2_robe","HitsTake",900},{"t3_robe","HitsTake",900},{"t4_robe","HitsTake",900}},
	},
}

Armaduras["pure_robe"] = {
	Type = "robe",
	Rarity = 7,
	Name = "Pure Robe Armor",
	Stats = {
		DEF = 13,
		WIS = 9,
		MP = 50,
		HP = 250,
	},
	Unlock = {
		ItemStatistic = {{"t0_robe","DamageTaken",600000},{"t1_robe","DamageTaken",600000},{"t2_robe","DamageTaken",600000},{"t3_robe","DamageTaken",600000},{"t4_robe","DamageTaken",600000}},
	},
}

Armaduras["t0_heavy"] = {
	Type = "heavy",
	Rarity = 1,
	Name = "T0 Heavy Armor",
	Unlock = nil,
	Stats = {
		DEF = 20,
	}
}

Armaduras["t1_heavy"] = {
	Type = "heavy",
	Rarity = 2,
	Name = "T1 Heavy Armor",
	Stats = {
		DEF = 21,
	},
	Unlock = {
		AnyLevel = {{"Warrior","Knight","Paladin","Samurai","Kensei"},5},
	},
}

Armaduras["t2_heavy"] = {
	Type = "heavy",
	Rarity = 3,
	Name = "T2 Heavy Armor",
	Stats = {
		DEF = 22,
	},
	Unlock = {
		AnyLevel = {{"Warrior","Knight","Paladin","Samurai","Kensei"},10},
	},
}

Armaduras["t3_heavy"] = {
	Type = "heavy",
	Rarity = 4,
	Name = "T3 Heavy Armor",
	Stats = {
		DEF = 23,
	},
	Unlock = {
		AnyLevel = {{"Warrior","Knight","Paladin","Samurai","Kensei"},15},
	},
}

Armaduras["t4_heavy"] = {
	Type = "heavy",
	Rarity = 5,
	Name = "T4 Heavy Armor",
	Stats = {
		DEF = 25,
	},
	Unlock = {
		AnyLevel = {{"Warrior","Knight","Paladin","Samurai","Kensei"},20},
	},
}

Armaduras["Hard_heavy"] = {
	Type = "heavy",
	Rarity = 6,
	Name = "Hardened Heavy Armor",
	Stats = {
		DEF = 31,
		SPD = -6,
	},
	Unlock = {
		ItemStatistic = {{"t0_heavy","HitsTake",1200},{"t1_heavy","HitsTake",1200},{"t2_heavy","HitsTake",1200},{"t3_heavy","HitsTake",1200},{"t4_heavy","HitsTake",1200}},
	},
}

Armaduras["pure_heavy"] = {
	Type = "heavy",
	Rarity = 7,
	Name = "Pure Heavy Armor",
	Stats = {
		DEF = 25,
		HP = 350,
	},
	Unlock = {
		ItemStatistic = {{"t0_heavy","DamageTaken",500000},{"t1_heavy","DamageTaken",500000},{"t2_heavy","DamageTaken",500000},{"t3_heavy","DamageTaken",500000},{"t4_heavy","DamageTaken",500000}},
	},
}

return Armaduras

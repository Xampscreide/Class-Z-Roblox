local PlayerEffect = {}

local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--#####################################################################################################################################
local CONFIGURACOES = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local PLAYERINFO = require(ServerScriptService:WaitForChild("_G.Players"))
local HEALTH  = require(ServerScriptService:WaitForChild("Health"))
local SPEED = require(ServerScriptService:WaitForChild("Speed"))
local Indikator = require(ServerScriptService:WaitForChild("Indikator"))
--#####################################################################################################################################
local HealingRatio = CONFIGURACOES.HealingRatio
local SlowedRatio = CONFIGURACOES.SlowedMultiplier
local SpeedyRatio = CONFIGURACOES.SpeedyMultiplier
local ExposedRatio = CONFIGURACOES.ExposedValor
local CursedRatio = CONFIGURACOES.CursedMultiplier
local DamagingRatio = CONFIGURACOES.DamagingMultiplicador
--#####################################################################################################################################

function DefaultSpeed(Player:Player)
	SPEED.SetDefaultSpeed(Player)
end

function StasisEffect(Player:Player)
	SPEED.SetSpeedModifier(Player,0)
end

function ParalyzedEffect(Player:Player)
	SPEED.SetSpeedModifier(Player,0)
end

function SlowedEffect(Player:Player)
	SPEED.SetSpeedModifier(Player,SlowedRatio)
end

function SpeedyEffect(Player:Player)
	SPEED.SetSpeedModifier(Player,SpeedyRatio)
end

local SpeedyModeEffect = SpeedyEffect

function HPBoostEffect(Player:Player,Boost:number)
	HEALTH.ChangeMaxHealth(Player,PLAYERINFO.Stats(Player).HP + Boost)
end

--#####################################################################################################################################

local Hierarquia = {"Stasis","Paralyzed","Slowed","Speedy","SpeedyMode"}

local FuncoesDasHierarquias = {
	Stasis = StasisEffect,
	Paralyzed = ParalyzedEffect,
	Slowed = SlowedEffect,
	Speedy = SpeedyEffect,
	SpeedyMode = SpeedyModeEffect
}

function VerificarSuperior(Effect:string,Player:Player)
	local HierarquiaDoEfeito = table.find(Hierarquia,Effect)
	local AllPlayerEffects = PLAYERINFO.AllEffects(Player)
	for Pos=1, HierarquiaDoEfeito-1 do
		local EffectCheck = Hierarquia[Pos]
		if AllPlayerEffects[EffectCheck] then return FuncoesDasHierarquias[EffectCheck] end
	end
end

function VerificarInferior(Effect:string,Player:Player)
	local HierarquiaDoEfeito = table.find(Hierarquia,Effect)
	local AllPlayerEffects = PLAYERINFO.AllEffects(Player)
	for Pos=HierarquiaDoEfeito+1, #Hierarquia do
		local EffectCheck = Hierarquia[Pos]
		if AllPlayerEffects[EffectCheck] then return FuncoesDasHierarquias[EffectCheck] end
	end
end

function VerificarHierarquia(Player:Player)
	local AllPlayerEffects = PLAYERINFO.AllEffects(Player)
	for Pos,Effect in ipairs(Hierarquia) do if AllPlayerEffects[Effect] then FuncoesDasHierarquias[Effect](Player) return end end
	DefaultSpeed(Player)
end

--#####################################################################################################################################
function PlayerEffect.Dano(PlayerAlvo:Player,PlayerAutor:Player,Dano:number)
	local AlvoStats = PLAYERINFO.Stats(PlayerAlvo)
	local AutorStats = PLAYERINFO.Stats(PlayerAutor)
	local DEF = AlvoStats.DEF
	local ATT = AutorStats.ATT
	local Effects = PLAYERINFO.AllEffects(PlayerAlvo)
	local EffectsAutor = PLAYERINFO.AllEffects(PlayerAutor)
	
	Dano *= (ATT+25)/50
	if Effects["Exposed"] then DEF -= ExposedRatio end
	Dano -= DEF
	if Effects["Cursed"] then Dano *= CursedRatio 	 end
	if EffectsAutor["Damaging"] then Dano *= DamagingRatio end
	
	Dano = Dano > 0 and Dano or 0

	return HEALTH.Damage(PlayerAlvo,Dano)
end

function PlayerEffect.DanoHabilidade(PlayerAlvo:Player,Dano:number)
	local DEF = PLAYERINFO.Stats(PlayerAlvo).DEF
	local Effects = PLAYERINFO.AllEffects(PlayerAlvo)

	if Effects["Exposed"] then DEF -= ExposedRatio end
	Dano -= DEF

	Dano = Dano > 0 and Dano or 0
	return HEALTH.Damage(PlayerAlvo,Dano)
end

function PlayerEffect.Heal(Player:Player,Cura:number)
	return HEALTH.Heal(Player,Cura)
end

function PlayerEffect.DanoPoison(Player:Player,DanoInstantaneo:number,DanoVeneno:number,DuracaoVeneno:number,Funcao:(number,boolean) -> (nil))
	local Effects = PLAYERINFO.AllEffects(Player)
	local DanoPorSegundo = DanoVeneno/DuracaoVeneno
	local SomaDoDano = 0
	local Duracao = 0
	local RunConn
	RunConn = RunService.Heartbeat:Connect(function(DeltaTime)
		if Effects["Stasis"] then return end
		local Dano = DeltaTime*DanoPorSegundo
		SomaDoDano += Dano
		local Dano, Morte = HEALTH.Damage(Player,Dano)
		Duracao += DeltaTime
		if Duracao > DuracaoVeneno or Morte or Morte == nil then
			Funcao(SomaDoDano,Morte)
			RunConn:Disconnect()
			RunConn = nil
			return
		end
	end)
	return PlayerEffect.DanoHabilidade(Player,DanoInstantaneo)
end

function PlayerEffect.Healing(Player:Player,Tempo:number,Funcao:(number) -> (nil))
	local Info = {
		Tempo = Tempo,
		Funcao = Funcao,
		CuraTotal = 0,
	}
	PLAYERINFO.NewEffect(Player,"Healing",Info)
end

function PlayerEffect.HPBoost(Player:Player,Tempo:number,HP:number)
	local Info = {
		Tempo = Tempo,
		HP = HP,
	}
	PLAYERINFO.NewEffect(Player,"HPBoost",Info)
	table.sort(PLAYERINFO.AllEffects(Player)["HPBoost"],function(a,b) return a.HP > b.HP end)
	local NovoMaximo = PLAYERINFO.Stats(Player).HP + HP
	if HEALTH.MaxHealth[Player] < NovoMaximo then HEALTH.ChangeMaxHealth(Player,NovoMaximo) end
end

function PlayerEffect.Stasis(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	local Info = {
		Color = PlayerAlvo.Character:FindFirstChildOfClass("MeshPart").Color,	
		PlayerAutor = PlayerAutor,
		AutorClass = PLAYERINFO.PlayerClass(PlayerAutor),
		Tempo = Tempo,
		Horario = os.clock(),
	}
	local Info2 = {
		PlayerAutor = PlayerAutor,
		AutorClass = PLAYERINFO.PlayerClass(PlayerAutor),
		Tempo = Tempo*2,
	}
	Indikator.AtualizarPlayer(PlayerAlvo,"Stasis",true)
	PlayerAlvo.Character:FindFirstChildOfClass("MeshPart").Color = Color3.fromRGB(49, 49, 49)
	PLAYERINFO.NewEffect(PlayerAlvo,"Stasis",Info)
	PLAYERINFO.NewEffect(PlayerAlvo,"StasisImunity",Info2)
	FuncoesDasHierarquias["Stasis"](PlayerAlvo)
end

function PlayerEffect.TimeEffect(Effect:string,PlayerAlvo:Player,PlayerAutor:Player,Tempo:number,Hierarquia:boolean)
	Indikator.AtualizarPlayer(PlayerAlvo,Effect,true)
	local Info = {
		PlayerAutor = PlayerAutor,
		AutorClass = PLAYERINFO.PlayerClass(PlayerAutor),
		Tempo = Tempo,
		Horario = os.clock()
	}
	if Hierarquia and not VerificarSuperior(Effect,PlayerAlvo) then FuncoesDasHierarquias[Effect](PlayerAlvo) end
	PLAYERINFO.NewEffect(PlayerAlvo,Effect,Info)
end

local function AdicionarNoHistorico(Player:Player,EffectName:string,EffectInfo:{})
	PLAYERINFO.NewHistorico(Player,EffectName,EffectInfo)
end

function PlayerEffect.SpeedyMode(Player:Player,Bool:boolean)
	if Bool and not PLAYERINFO.Effect(Player,"SpeedyMode") then PLAYERINFO.NewEffect(Player,"SpeedyMode",{}) end
	if Bool and not VerificarSuperior("SpeedyMode",Player) then SpeedyModeEffect(Player) end
	if not Bool then
		AdicionarNoHistorico(Player,"SpeedyMode",true)
		if not VerificarSuperior("SpeedyMode",Player) then DefaultSpeed(Player) end
		PLAYERINFO.AllEffects(Player)["SpeedyMode"] = nil
	end
end

local function LimparEfeitos(Player:Player,Effect:string,Remove:{number})
	if #Remove == 0 then return end
	local PlayerEffects = PLAYERINFO.AllEffects(Player)
	local EffectTable = PlayerEffects[Effect]
	for i=1,#Remove do table.remove(EffectTable,table.remove(Remove)) end
	if #EffectTable == 0 then PlayerEffects[Effect] = nil end
end

local function FinalizarStasis(Player:Player,Info)
	Player.Character:FindFirstChildOfClass("MeshPart").Color = Info.Color
end

--#####################################################################################################################################
local Tempo = os.clock()
RunService.Heartbeat:Connect(function(DeltaTime)
	
	for Player:Player,PlayerTable in pairs(PLAYERINFO.GetAllPlayers()) do
		local Effects = PLAYERINFO.AllEffects(Player)
		local StasisEffect = Effects["Stasis"]
		
		if StasisEffect then
			local Remove = {}
			for Pos, Info in ipairs(StasisEffect) do
				Info.Tempo -= DeltaTime
				if Info.Tempo < 0 then table.insert(Remove,Pos) FinalizarStasis(Player,Info) Indikator.AtualizarPlayer(Player,"Stasis",false) end
			end
			LimparEfeitos(Player,"Stasis",Remove)
			continue
		end
		
		for EffectName:string,Info in pairs(Effects) do
			
			-------------------Healing--------------------
			
			if EffectName == "Healing" then
				local Remove = {}
				for Pos, Conteudo in ipairs(Info) do
					if Pos==1 then 
						local CuraReal = HEALTH.Heal(Player,HealingRatio*DeltaTime)
						if not CuraReal then
							Conteudo.Funcao(Conteudo.CuraTotal)
							Info[EffectName] = nil
							break
						end
						Conteudo.CuraTotal += CuraReal
					end
					Conteudo.Tempo -= DeltaTime 
					if Conteudo.Tempo < 0 then 
						Conteudo.Funcao(Conteudo.CuraTotal)
						table.insert(Remove,Pos) 
					end
				end
				LimparEfeitos(Player,EffectName,Remove)

				-------------------HPBoost--------------------

			elseif EffectName == "HPBoost" then
				local Remove = {}
				for Pos, Conteudo in ipairs(Info) do
					Conteudo.Tempo -= DeltaTime
					if Conteudo.Tempo < 0 then
						table.insert(Remove,Pos) 
						if #Info == 1 then HPBoostEffect(Player,0) 
						else
							local X
							for i=2,#Info do
								if Info[i].Tempo-DeltaTime > 0 then
									HPBoostEffect(Player,Info[i].HP)
									X = true
									break
								end
							end
							if not X then HPBoostEffect(Player,0) end
						end
					end
				end
				LimparEfeitos(Player,EffectName,Remove)
				
				-------------------Normal--------------------
				
			elseif EffectName == "SpeedyMode" then
				
			else
				local Remove = {}
				for Pos, Conteudo in ipairs(Info) do
					Conteudo.Tempo -= DeltaTime
					if Conteudo.Tempo < 0 then
						table.insert(Remove,Pos)
						AdicionarNoHistorico(Player,EffectName,Conteudo)
						Indikator.AtualizarPlayer(Player,EffectName,false)
					end
				end
				LimparEfeitos(Player,EffectName,Remove)
			end
		end
		VerificarHierarquia(Player)
	end
end)

return PlayerEffect

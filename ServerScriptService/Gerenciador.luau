local Gerenciador = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InformarEfeito = game:GetService("ReplicatedStorage"):WaitForChild("EventosRemotos"):WaitForChild("InformarEfeito")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerService = game:GetService("Players")
--#####################################################################################################################################
local XPCONTROLLER = require(ServerScriptService:WaitForChild("XpController")) 
local PLAYEREFFECT = require(ServerScriptService:WaitForChild("PlayerEffect"))
local PLAYERINFO = require(ServerScriptService:WaitForChild("_G.Players"))
local LeaderBoardServer = require(ServerScriptService:WaitForChild("LeaderBoardServer"))
local EstatisticaPlayer = require(ServerScriptService:WaitForChild("EstatisticaPlayer"))
local SistemaPartida = require(ServerScriptService:WaitForChild("SistemaPartida"))
--#####################################################################################################################################
local SoundEvent = ReplicatedStorage:WaitForChild("EventosRemotos"):WaitForChild("Sound")

local function StasisCheck(Player:Player):boolean
	return PLAYERINFO.Effect(Player,"Stasis")
end

function Gerenciador.Dano(PlayerAlvo:Player,PlayerAutor:Player,Dano:number,Arma:boolean?)
	if StasisCheck(PlayerAlvo) then return end
	local DanoCausado, Morte
	if Arma then DanoCausado, Morte = PLAYEREFFECT.Dano(PlayerAlvo,PlayerAutor,Dano) else DanoCausado, Morte = PLAYEREFFECT.DanoHabilidade(PlayerAlvo,Dano) end
	if not DanoCausado then return end
	
	EstatisticaPlayer.Damage(PlayerAutor,PlayerAlvo,DanoCausado,Arma)
	if Morte then
		SistemaPartida.AdicionarPontuacaoMorte(PlayerAutor)
		SoundEvent:FireClient(PlayerAutor,string.pack("I1",2))
		LeaderBoardServer.AddKillFeed(PlayerAutor,PlayerAlvo)
		EstatisticaPlayer.Kill(PlayerAutor,PlayerAlvo,Arma)
	end
	XPCONTROLLER.Dano(PlayerAlvo,PlayerAutor,DanoCausado)
end

function Gerenciador.Cura(PlayerAlvo:Player,PlayerAutor:Player,Cura:number)
	if StasisCheck(PlayerAlvo) then return end
	local CuraReal = PLAYEREFFECT.Heal(PlayerAlvo,Cura)
	EstatisticaPlayer.Heal(PlayerAutor,CuraReal)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Heal",CuraReal)
end

function Gerenciador.DanoPoison(PlayerAlvo:Player,PlayerAutor:Player,DanoInstantaneo:number,DanoVeneno:number,DuracaoVeneno:number)
	if StasisCheck(PlayerAlvo) then return end
	local ClasseSalva = PLAYERINFO.PlayerClass(PlayerAutor)
	local function DanoRegister(Quantidade:number,Morte:boolean)
		if Morte then EstatisticaPlayer.Kill(PlayerAutor,PlayerAlvo,false) SistemaPartida.AdicionarPontuacaoMorte(PlayerAutor) end
		EstatisticaPlayer.Damage(PlayerAutor,PlayerAlvo,Quantidade,false)
		XPCONTROLLER.ConversaoDireta(PlayerAutor,"Poison",Quantidade)
	end
	local DanoInstantaneoReal,Morte = PLAYEREFFECT.DanoPoison(PlayerAlvo,DanoInstantaneo,DanoVeneno,DuracaoVeneno,DanoRegister)
	if Morte then EstatisticaPlayer.Kill(PlayerAutor,PlayerAlvo,false) SistemaPartida.AdicionarPontuacaoMorte(PlayerAutor) end
	EstatisticaPlayer.Damage(PlayerAutor,PlayerAlvo,DanoInstantaneoReal,false)
	XPCONTROLLER.Dano(PlayerAlvo,PlayerAutor,DanoInstantaneoReal,ClasseSalva)
	InformarEfeito:FireClient(PlayerAlvo,"Poison",DuracaoVeneno)
end

function Gerenciador.Healing(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	local ClasseSalva = PLAYERINFO.PlayerClass(PlayerAutor)
	local function Event(Valor:number)
		if Valor > 0 then
			EstatisticaPlayer.Heal(PlayerAutor,Valor)
			XPCONTROLLER.ConversaoDireta(PlayerAutor,"HealingQuantidade",Valor,ClasseSalva)
		end
	end
	PLAYEREFFECT.Healing(PlayerAlvo,Tempo,Event)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Healing",Tempo,ClasseSalva)
	InformarEfeito:FireClient(PlayerAlvo,"Healing",Tempo)
end

function Gerenciador.HPBoost(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number,HP:number)
	PLAYEREFFECT.HPBoost(PlayerAlvo,Tempo,HP)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"HPBoost",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"HPBoost",Tempo)
end

function Gerenciador.SpeedyMode(PlayerAlvo:Player,Bool:boolean)
	PLAYEREFFECT.SpeedyMode(PlayerAlvo,Bool)
end

function Gerenciador.Stasis(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	if PLAYERINFO.Stasisimmunity(PlayerAlvo) then return end
	PLAYEREFFECT.Stasis(PlayerAlvo,PlayerAutor,Tempo)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Stasis",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"Stasis",Tempo)
end

function Gerenciador.Paralyzed(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	PLAYEREFFECT.TimeEffect("Paralyzed",PlayerAlvo,PlayerAutor,Tempo,true)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Paralyzed",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"Paralyzed",Tempo)
end

function Gerenciador.Slowed(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	PLAYEREFFECT.TimeEffect("Slowed",PlayerAlvo,PlayerAutor,Tempo,true)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Slowed",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"Slowed",Tempo)
end

function Gerenciador.Speedy(PlayerAlvo:Player,PlayerAutor,Tempo:number)
	PLAYEREFFECT.TimeEffect("Speedy",PlayerAlvo,PlayerAutor,Tempo,true)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Speedy",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"Speedy",Tempo)
end

function Gerenciador.Berserk(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	PLAYEREFFECT.TimeEffect("Berserk",PlayerAlvo,PlayerAutor,Tempo)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Berserk",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"Berserk",Tempo)
end

function Gerenciador.Stunned(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	PLAYEREFFECT.TimeEffect("Stunned",PlayerAlvo,PlayerAutor,Tempo)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Stunned",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"Stunned",Tempo)
end

function Gerenciador.Cursed(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	PLAYEREFFECT.TimeEffect("Cursed",PlayerAlvo,PlayerAutor,Tempo)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Cursed",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"Cursed",Tempo)
end

function Gerenciador.Exposed(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	PLAYEREFFECT.TimeEffect("Exposed",PlayerAlvo,PlayerAutor,Tempo)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Exposed",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"Exposed",Tempo)
end

function Gerenciador.Inspired(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	PLAYEREFFECT.TimeEffect("Inspired",PlayerAlvo,PlayerAutor,Tempo)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Inspired",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"Inspired",Tempo)
end

function Gerenciador.Damaging(PlayerAlvo:Player,PlayerAutor:Player,Tempo:number)
	PLAYEREFFECT.TimeEffect("Damaging",PlayerAlvo,PlayerAutor,Tempo)
	XPCONTROLLER.ConversaoDireta(PlayerAutor,"Damaging",Tempo)
	InformarEfeito:FireClient(PlayerAlvo,"Damaging",Tempo)
end

function Gerenciador.InspiredProjetil(Inspired:{})
	XPCONTROLLER.ConversaoDireta(Inspired.PlayerAutor,"Inspired",1,Inspired.AutorClass)
	EstatisticaPlayer.Inspired(Inspired.PlayerAutor)
end

function Gerenciador.RegistrarAcertoHabilidade(Player:Player)
	EstatisticaPlayer.Hit(Player)
end

return Gerenciador

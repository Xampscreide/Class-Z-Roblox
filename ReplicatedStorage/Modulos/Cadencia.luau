local CadenciaModule = {}

local Modulos = script.Parent
local Animate = require(Modulos:WaitForChild("Animate"))
local PlayerEffect = require(Modulos:WaitForChild("PlayerEffect"))
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
local Health = require(Modulos:WaitForChild("Health"))
local MagicPoint = require(Modulos:WaitForChild("MagicPoint"))
local Conversor = require(Modulos:WaitForChild("ConversorDeStatus"))

local Cadencia
local Periodo
local PeriodoBerserk
local NumeroMagico
local NumeroMagicoBerserk

local PeriodoHabilidade = .5

local Ultimo = os.clock()
local UltimoBerserk = os.clock()
local UltimoHabilidade = os.clock()

function CadenciaModule.UpdateDex(DEX:number)
	Cadencia = Conversor.Dextreza(DEX)
	Periodo = 1/Cadencia
	PeriodoBerserk = Periodo/1.25
	NumeroMagico = -Periodo*0.030927835
	NumeroMagicoBerserk = -PeriodoBerserk*0.030927835
end

function CadenciaModule.Set()
	Cadencia = Conversor.Dextreza(PlayerStats.Stats.DEX)
	Periodo = 1/Cadencia
	PeriodoBerserk = Periodo/1.25
	NumeroMagico = -Periodo*0.030927835
	NumeroMagicoBerserk = -PeriodoBerserk*0.030927835
end

function CadenciaModule.Shot()
	local B = false
	if PlayerEffect.GetStasis() then return false end
	if PlayerEffect.GetStunned() then return false end
	if Health.VidaAtual == 0 then return false end
	local Relogio = os.clock()
	if Relogio-UltimoBerserk < NumeroMagicoBerserk then
		return false
	elseif PlayerEffect.GetBerserk() then B = true
	elseif Relogio-Ultimo < NumeroMagico then
		return false
	end
	Animate.Attack(if B then PeriodoBerserk else Periodo)
	Ultimo = Relogio+Periodo
	UltimoBerserk = Relogio+PeriodoBerserk
	return true
end

function CadenciaModule.Habilidade()
	if PlayerEffect.GetStasis() then return false end
	if Health.VidaAtual == 0 then return false end
	local Relogio = os.clock()
	if Relogio < UltimoHabilidade then return false end
	if not MagicPoint.Verificar() then return false end
	UltimoHabilidade = Relogio + PeriodoHabilidade
	return true
end

function CadenciaModule.CustoPorTempo()
	if PlayerEffect.GetStasis() then return false end
	if Health.VidaAtual == 0 then return false end
	return MagicPoint.CustoPorTempo()
end

function CadenciaModule.Continuo(MPPerTime:number,DeltaTime:number)
	if PlayerEffect.GetStasis() then return false end
	if Health.VidaAtual == 0 then return false end
	return MagicPoint.Continuo(MPPerTime,DeltaTime)
end

return CadenciaModule

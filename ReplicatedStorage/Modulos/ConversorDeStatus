local ConversorDeStatus = {}
local ServerScriptService = game:GetService("ServerScriptService")

function ConversorDeStatus.Velocidade(SPD:number)
	return 13+15*(SPD/75)
end

function ConversorDeStatus.Dextreza(DEX:number)
	return 1+4*(DEX/75)
end

function ConversorDeStatus.Vitalidade(VIT:number)
	return 2+VIT*.4+math.pow(VIT,2)*.01
end

function ConversorDeStatus.Wisdom(WIS:number)
	return 1+WIS*.125+math.pow(WIS,2)*0.002
end

return ConversorDeStatus

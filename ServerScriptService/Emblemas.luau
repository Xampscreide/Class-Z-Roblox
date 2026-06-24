local Emblemas = {}

local BadgeService = game:GetService("BadgeService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local XP = require(ReplicatedStorage:WaitForChild("Modulos"):WaitForChild("XpCalculador"))

function Emblemas.ChecarEmblemas(Player:Player,Info)
	local Quantidade = 0
	for _,XPV in pairs(Info.ClassXP) do
		if XP.takeLvl(XPV) >= 20 then
			Quantidade += 1
		end
	end
	if Quantidade >= 1 then
		local Sucesso, TemEmblema = pcall(BadgeService.UserHasBadgeAsync,BadgeService,Player.UserId,2216834421280998)
		if not Sucesso or TemEmblema then return end
		local Sucesso, ErroMensagem = pcall(BadgeService.AwardBadge,BadgeService,Player.UserId,2216834421280998)
		if not Sucesso then print(ErroMensagem) end
	end
end

return Emblemas

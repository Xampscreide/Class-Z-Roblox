local Main = script.Parent

local BotaoEffects = Main:WaitForChild("EB")
local BotaoStats = Main:WaitForChild("SB")
local PainelEffects = Main:WaitForChild("Effects")
local PainelStats = Main:WaitForChild("Stats")

local BotaoAtual = BotaoEffects
local PainelAtual = PainelEffects

local function DeixarBotaoBranco(Botao:TextButton,Bool:boolean)
	if Bool then
		Botao.BackgroundColor3 = Color3.new(1,1,1)
		Botao.TextColor3 = Color3.fromRGB(44, 49, 58)
	else
		Botao.BackgroundColor3 = Color3.fromRGB(44, 49, 58)
		Botao.TextColor3 = Color3.new(1,1,1)
	end
end

BotaoStats.Activated:Connect(function()
	if BotaoAtual == BotaoStats then return end
	DeixarBotaoBranco(BotaoAtual,false)
	BotaoAtual = BotaoStats
	DeixarBotaoBranco(BotaoAtual,true)
	PainelAtual.Visible = false
	PainelAtual = PainelStats
	PainelAtual.Visible = true
end)

BotaoEffects.Activated:Connect(function()
	if BotaoAtual == BotaoEffects then return end
	DeixarBotaoBranco(BotaoAtual,false)
	BotaoAtual = BotaoEffects
	DeixarBotaoBranco(BotaoAtual,true)
	PainelAtual.Visible = false
	PainelAtual = PainelEffects
	PainelAtual.Visible = true
end)




local Boosters = script.Parent

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local PlayerStats = require(ReplicatedStorage:WaitForChild("Modulos"):WaitForChild("PlayerStats"))
local ClickSound1 = script:WaitForChild("Click1")

local LocalPlayer = game:GetService("Players").LocalPlayer

local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local MenuEvent = EventosRemotos:WaitForChild("Menu")
local DeadEvent = EventosRemotos:WaitForChild("DeathPlayer")

while not PlayerStats.Loaded do task.wait() end

local XP = Boosters:WaitForChild("XP")
local CLASS = Boosters:WaitForChild("CLASS")
local ITEM = Boosters:WaitForChild("ITEM")

local XPB = Boosters:WaitForChild("XPB")
local ITEMB = Boosters:WaitForChild("ITEMB")
local CLASSEB = Boosters:WaitForChild("CLASSEB")

local BotaoApertado = XPB
local NomeDoApertado = "XP"

local ListaBoosters = {XP = XP,Item = ITEM,Class = CLASS}

local function ConverterSegundosPTempo(Segundos:number)
	Segundos = math.floor(Segundos)
	local Minutos = (Segundos%3600)/60
	local Horas = Segundos/3600
	local Saida = string.format("%01d:%02d:%02d",Horas,Minutos,Segundos%60)
	return Saida
end

function UpdateBoostersAtivos(Tipo:string)
	for i,k:Frame in ipairs(ListaBoosters[Tipo].Lista:GetChildren()) do
		if k.ClassName == "Frame" then 
			if k:FindFirstChild("ImageLabel") then
				k.Tempo.Text = "00:00:00"
			else
				k.Tempo.Text = "INACTIVE"
			end
		end
	end
	for NomeDoBoost,Valores in pairs(PlayerStats.Boosters[Tipo]) do
		ListaBoosters[Tipo].Lista[NomeDoBoost].Tempo.Text = if type(Valores.Tempo) == "boolean" then "ACTIVE" else ConverterSegundosPTempo(Valores.Tempo)
	end
end

function UpdateBoostInferior(Tipo:string)
	Boosters.ValorTotal.TextLabel.Text = "CURRENT BOOST +"..string.format("%d",math.round(PlayerStats.Booster[Tipo]*100-100)).."%"
end

XPB.Activated:Connect(function()
	ClickSound1:Play()
	if BotaoApertado == XPB then return end
	BotaoApertado.BackgroundColor3 = Color3.fromRGB(36, 40, 47)
	BotaoApertado.TextLabel.TextColor3 = Color3.new(1,1,1)
	BotaoApertado = XPB
	BotaoApertado.BackgroundColor3 = Color3.new(1,1,1)
	BotaoApertado.TextLabel.TextColor3 = Color3.fromRGB(36, 40, 47)
	XP.Visible = true
	CLASS.Visible = false
	ITEM.Visible = false
	UpdateBoostInferior("XP")
	UpdateBoostersAtivos("XP")
	NomeDoApertado = "XP"
end)

ITEMB.Activated:Connect(function()
	ClickSound1:Play()
	if BotaoApertado == ITEMB then return end
	BotaoApertado.BackgroundColor3 = Color3.fromRGB(36, 40, 47)
	BotaoApertado.TextLabel.TextColor3 = Color3.new(1,1,1)
	BotaoApertado = ITEMB
	BotaoApertado.BackgroundColor3 = Color3.new(1,1,1)
	BotaoApertado.TextLabel.TextColor3 = Color3.fromRGB(36, 40, 47)
	XP.Visible = false
	CLASS.Visible = false
	ITEM.Visible = true
	UpdateBoostInferior("Item")
	UpdateBoostersAtivos("Item")
	NomeDoApertado = "Item"
end)

CLASSEB.Activated:Connect(function()
	ClickSound1:Play()
	if BotaoApertado == CLASSEB then return end
	BotaoApertado.BackgroundColor3 = Color3.fromRGB(36, 40, 47)
	BotaoApertado.TextLabel.TextColor3 = Color3.new(1,1,1)
	BotaoApertado = CLASSEB
	BotaoApertado.BackgroundColor3 = Color3.new(1,1,1)
	BotaoApertado.TextLabel.TextColor3 = Color3.fromRGB(36, 40, 47)
	XP.Visible = false
	CLASS.Visible = true
	ITEM.Visible = false
	UpdateBoostInferior("Class")
	UpdateBoostersAtivos("Class")
	NomeDoApertado = "Class"
end)

XP.Lista.Boost1.B.Activated:Connect(function()
	MarketplaceService:PromptProductPurchase(LocalPlayer,1712039356)
end)

XP.Lista.Boost2.B.Activated:Connect(function()
	MarketplaceService:PromptProductPurchase(LocalPlayer,1712276318)
end)

XP.Lista.Boost3.B.Activated:Connect(function()
	MarketplaceService:PromptProductPurchase(LocalPlayer,1712276561)
end)

ITEM.Lista.Boost1.B.Activated:Connect(function()
	MarketplaceService:PromptProductPurchase(LocalPlayer,1712279351)
end)

ITEM.Lista.Boost2.B.Activated:Connect(function()
	MarketplaceService:PromptProductPurchase(LocalPlayer,1712279564)
end)

ITEM.Lista.Boost3.B.Activated:Connect(function()
	MarketplaceService:PromptProductPurchase(LocalPlayer,1712279703)
end)

CLASS.Lista.Boost1.B.Activated:Connect(function()
	MarketplaceService:PromptProductPurchase(LocalPlayer,1712278155)
end)

CLASS.Lista.Boost2.B.Activated:Connect(function()
	MarketplaceService:PromptProductPurchase(LocalPlayer,1712278603)
end)

CLASS.Lista.Boost3.B.Activated:Connect(function()
	MarketplaceService:PromptProductPurchase(LocalPlayer,1712278928)
end)

UpdateBoostInferior("XP")
UpdateBoostersAtivos("XP")

DeadEvent.OnClientEvent:Connect(function()
	task.wait(.5)
	UpdateBoostInferior(NomeDoApertado)
	UpdateBoostersAtivos(NomeDoApertado)
end)

MenuEvent.OnClientEvent:Connect(function()
	task.wait(.5)
	UpdateBoostInferior(NomeDoApertado)
	UpdateBoostersAtivos(NomeDoApertado)
end)

PlayerStats.FuncaoBooster(function()
	UpdateBoostInferior(NomeDoApertado)
	UpdateBoostersAtivos(NomeDoApertado)
end)

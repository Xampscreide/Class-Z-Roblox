local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
local Bandeiras = require(Modulos:WaitForChild("Flags"))

local Sound1 = script:WaitForChild("Click1")
local Sound2 = script:WaitForChild("Click2")
local Sound3 = script:WaitForChild("Click3")

local ArmaInfo = Configuracoes.Armas
local HabilidadeInfo = Configuracoes.Habilidades
local ArmaduraInfo = Configuracoes.Armaduras

while not PlayerStats.Loaded do task.wait() end

local Main = script.Parent
local ClassXPButton = Main:WaitForChild("XPB")
local ClassStatisticButton = Main:WaitForChild("StatisticsB")
local ClassTimeButton = Main:WaitForChild("TimeB")
local ItemStatisticButton = Main:WaitForChild("ItemB")
local GeralStatisticButton = Main:WaitForChild("GeralB")

local ListaClasses = Main:WaitForChild("Classes")
local ListaNomeEstatisticas = Main:WaitForChild("EstatisticasItem")
local ListaEstatisticasClasse = Main:WaitForChild("Estatisticas")
local ListaItens = Main:WaitForChild("Itens")
local ListaGeral = Main:WaitForChild("EstatisticasGeral")

local OpcaoClassStatistic = Main:WaitForChild("OpcaoClasseEstatistica")
local OpcaoItemEstatistic = Main:WaitForChild("OpcaoItem")
local OpcaoClasseComum = Main:WaitForChild("OpcaoClasse")
local OpcaoGeral = Main:WaitForChild("OpcaoGeral")

local BotaoArma = OpcaoItemEstatistic:WaitForChild("Arma")
local BotaoHabilidade = OpcaoItemEstatistic:WaitForChild("Habilidade")
local BotaoArmadura = OpcaoItemEstatistic:WaitForChild("Armadura")

local ListaDeNomes = Main:WaitForChild("ListaPlayer")

local Legenda = Main:WaitForChild("Legenda")
local ModeloItem = script:WaitForChild("Modelo")

local AtualSendoMostrado = GeralStatisticButton
local ClasseSelecionada = PlayerStats.Class
local EstatisticaClasseSelecionada = "Damage"
local EstatisticaGeralSelecionada = "XP"
local EstatisticaItemSelecionada = "Damage"
local ItemSelecionado = PlayerStats.Equipamento.Arma

local TipoItemSendoMostrado = "Arma"
local BotaOTipoItemMostrado = BotaoArma

local ListarItens
local ListarNomesEstatisticas

local Cores = {Color3.fromRGB(44, 49, 58),Color3.fromRGB(36, 40, 47)}

local function SumirComAsListas()
	ListaItens.Visible = false
	ListaEstatisticasClasse.Visible = false
	ListaNomeEstatisticas.Visible = false
	ListaClasses.Visible = false
end

local function SumirComAsOpcoes()
	OpcaoClassStatistic.Visible = false
	OpcaoItemEstatistic.Visible = false
	OpcaoClasseComum.Visible = false
	OpcaoGeral.Visible = false
end

local function ConverterSegundosPTempo(Segundos:number)
	Segundos = math.floor(Segundos)
	local Minutos = (Segundos%3600)/60
	local Horas = Segundos/3600
	local Saida = string.format("%01dh:%02dm:%02ds",Horas,Minutos,Segundos%60)
	return Saida
end
	
local function TrocarCorBotao(Bool:boolean)
	AtualSendoMostrado.BackgroundColor3 = if Bool then Color3.fromRGB(36, 40, 47) else Color3.new(1,1,1)
	AtualSendoMostrado.TextLabel.TextColor3 = if Bool then Color3.new(1,1,1) else Color3.fromRGB(36, 40, 47)
end

local function TrocarCorBotaoOpcao(Bool:boolean)
	BotaOTipoItemMostrado.BackgroundColor3 = if Bool then Color3.fromRGB(56, 56, 56) else Color3.new(1,1,1)
	BotaOTipoItemMostrado.TextColor3 = if Bool then Color3.new(1,1,1) else Color3.fromRGB(56, 56, 56)
end

local function DestroirPlayers()
	for i,k in ipairs(ListaDeNomes:GetChildren()) do
		if k.Name == "Jump" then continue end
		k:Destroy()
	end
end

local function MostrarPlayersGeral(bool:boolean)
	DestroirPlayers()
	for i,k in ipairs(PlayerStats.Top.Geral[EstatisticaGeralSelecionada]) do
		local Clone = Legenda:Clone()
		Clone.LayoutOrder = i
		Clone.BackgroundColor3 = Cores[i%2+1]
		Clone.Rank.Text = tostring(i)
		Clone.Player.Text = tostring(k[1])
		Clone.Value.Text = bool and ConverterSegundosPTempo(k[2]) or string.format("%d",k[2])
		Clone.Pais.Text = string.upper(Bandeiras.Paises[k[3]].Name)
		Clone.Parent = ListaDeNomes
	end
end

local function MostrarPlayersClassXP()
	DestroirPlayers()
	for i,k in ipairs(PlayerStats.Top.ClassXP[ClasseSelecionada]) do
		local Clone = Legenda:Clone()
		Clone.LayoutOrder = i
		Clone.BackgroundColor3 = Cores[i%2+1]
		Clone.Rank.Text = tostring(i)
		Clone.Player.Text = tostring(k[1])
		Clone.Value.Text = string.format("%d",k[2])
		Clone.Pais.Text = string.upper(Bandeiras.Paises[k[3]].Name)
		Clone.Parent = ListaDeNomes
	end
end

local function MostrarPlayersClassTime()
	DestroirPlayers()
	for i,k in ipairs(PlayerStats.Top.ClassTime[ClasseSelecionada]) do
		local Clone = Legenda:Clone()
		Clone.LayoutOrder = i
		Clone.BackgroundColor3 = Cores[i%2+1]
		Clone.Rank.Text = tostring(i)
		Clone.Player.Text = tostring(k[1])
		Clone.Value.Text = ConverterSegundosPTempo(k[2])
		Clone.Pais.Text = string.upper(Bandeiras.Paises[k[3]].Name)
		Clone.Parent = ListaDeNomes
	end
end

local function MostrarPlayerClassStatistic()
	DestroirPlayers()
	for i,k in ipairs(PlayerStats.Top.ClassStatistic[ClasseSelecionada][EstatisticaClasseSelecionada]) do
		local Clone = Legenda:Clone()
		Clone.LayoutOrder = i
		Clone.BackgroundColor3 = Cores[i%2+1]
		Clone.Rank.Text = tostring(i)
		Clone.Player.Text = tostring(k[1])
		Clone.Value.Text = string.format("%d",k[2])
		Clone.Pais.Text = string.upper(Bandeiras.Paises[k[3]].Name)
		Clone.Parent = ListaDeNomes
	end
end

local function MostrarPlayerItemStatistic()
	DestroirPlayers()
	for i,k in ipairs(PlayerStats.Top.ItemStatistic[ItemSelecionado][EstatisticaItemSelecionada]) do
		local Clone = Legenda:Clone()
		Clone.LayoutOrder = i
		Clone.BackgroundColor3 = Cores[i%2+1]
		Clone.Rank.Text = tostring(i)
		Clone.Player.Text = tostring(k[1])
		Clone.Value.Text = string.format("%d",k[2])
		Clone.Pais.Text = string.upper(Bandeiras.Paises[k[3]].Name)
		Clone.Parent = ListaDeNomes
	end
end

GeralStatisticButton.Activated:Connect(function()
	if AtualSendoMostrado == GeralStatisticButton then return end
	Sound1:Play()
	TrocarCorBotao(true)
	AtualSendoMostrado = GeralStatisticButton
	TrocarCorBotao(false)
	MostrarPlayersGeral()
	SumirComAsOpcoes()
	Legenda.Value.Text = string.upper(EstatisticaGeralSelecionada)
	OpcaoGeral.Visible = true
	SumirComAsListas()
end)

ClassXPButton.Activated:Connect(function()
	if AtualSendoMostrado == ClassXPButton then return end
	Sound1:Play()
	TrocarCorBotao(true)
	AtualSendoMostrado = ClassXPButton
	TrocarCorBotao(false)
	MostrarPlayersClassXP()
	SumirComAsOpcoes()
	Legenda.Value.Text = "XP"
	OpcaoClasseComum.Visible = true
	SumirComAsListas()
end)

ClassTimeButton.Activated:Connect(function()
	if AtualSendoMostrado == ClassTimeButton then return end
	Sound1:Play()
	TrocarCorBotao(true)
	AtualSendoMostrado = ClassTimeButton
	TrocarCorBotao(false)
	MostrarPlayersClassTime()
	SumirComAsOpcoes()
	Legenda.Value.Text = "TIME"
	OpcaoClasseComum.Visible = true
	SumirComAsListas()
end)

ClassStatisticButton.Activated:Connect(function()
	if AtualSendoMostrado == ClassStatisticButton then return end
	Sound1:Play()
	TrocarCorBotao(true)
	AtualSendoMostrado = ClassStatisticButton
	TrocarCorBotao(false)
	MostrarPlayerClassStatistic()
	SumirComAsOpcoes()
	Legenda.Value.Text = string.upper(EstatisticaClasseSelecionada)
	OpcaoClassStatistic.Visible = true
	SumirComAsListas()
end)

ItemStatisticButton.Activated:Connect(function()
	if AtualSendoMostrado == ItemStatisticButton then return end
	Sound1:Play()
	TrocarCorBotao(true)
	AtualSendoMostrado = ItemStatisticButton
	TrocarCorBotao(false)
	MostrarPlayerItemStatistic()
	SumirComAsOpcoes()
	Legenda.Value.Text = string.upper(EstatisticaItemSelecionada)
	OpcaoItemEstatistic.Visible = true
	ListarItens()
	ListarNomesEstatisticas()
	SumirComAsListas()
end)

OpcaoClasseComum.Classe.Activated:Connect(function()
	Sound1:Play()
	ListaClasses.Visible = not ListaClasses.Visible
end)

OpcaoClassStatistic.Classe.Activated:Connect(function()
	Sound1:Play()
	ListaClasses.Visible = not ListaClasses.Visible
end)

OpcaoClassStatistic.Estatistica.Activated:Connect(function()
	Sound1:Play()
	ListaEstatisticasClasse.Visible = not ListaEstatisticasClasse.Visible
end)

OpcaoGeral.Estatistica.Activated:Connect(function()
	Sound1:Play()
	ListaGeral.Visible = not ListaGeral.Visible
end)

local ConnecaoNomesEstatisticas = {}
local function ExcluirNomesEstatisticas()
	for i,k:TextButton in ipairs(ListaNomeEstatisticas:GetChildren()) do
		if k.Name == "Jump" then continue end
		k:Destroy()
	end
	for i,k in pairs(ConnecaoNomesEstatisticas) do
		k:Disconnect()
	end
	ConnecaoNomesEstatisticas = {}
end

ListarNomesEstatisticas = function()
	ExcluirNomesEstatisticas()
	for NomeDaEstatistica,Info in pairs(PlayerStats.Top.ItemStatistic[ItemSelecionado]) do
		local Clone = ModeloItem:Clone()
		Clone.Size = UDim2.new(1, -6,0.16, 0)
		Clone.TextLabel.Text = string.upper(NomeDaEstatistica)
		Clone.Parent = ListaNomeEstatisticas
		ConnecaoNomesEstatisticas[Clone] = Clone.Activated:Connect(function()
			EstatisticaItemSelecionada = NomeDaEstatistica
			OpcaoItemEstatistic.EstatisticaB.Text = string.upper(NomeDaEstatistica)
			Legenda.Value.Text = string.upper(NomeDaEstatistica)
			MostrarPlayerItemStatistic()
		end)
	end
end

local ConeccaoListaItens = {}
local function ExcluirItensListados()
	for i,k:TextButton in ipairs(ListaItens:GetChildren()) do
		if k.Name == "Jump" then continue end
		k:Destroy()
	end
	for i,k in pairs(ConeccaoListaItens) do
		k:Disconnect()
	end
	ConeccaoListaItens = {}
end

local StringPraInfo = {
	Arma = ArmaInfo,
	Habilidade = HabilidadeInfo,
	Armadura = ArmaduraInfo
}
ListarItens = function()
	ExcluirItensListados()
	for NomeDoItem,Info in pairs(StringPraInfo[TipoItemSendoMostrado]) do
		local Clone = ModeloItem:Clone()
		Clone.TextLabel.Text = string.upper(Info.Name)
		Clone.Parent = ListaItens
		ConeccaoListaItens[Clone] = Clone.Activated:Connect(function()
			if TipoItemSendoMostrado == "Habilidade" and not StringPraInfo[TipoItemSendoMostrado][NomeDoItem][EstatisticaItemSelecionada] then
				EstatisticaItemSelecionada = "Uses"
				Legenda.Value.Text = "USES"
			end
			ItemSelecionado = NomeDoItem
			OpcaoItemEstatistic.ItemB.Text = string.upper(Info.Name)
			ListarNomesEstatisticas()
			MostrarPlayerItemStatistic()
		end)
	end
end

BotaoArma.Activated:Connect(function()
	if BotaOTipoItemMostrado == BotaoArma then return end
	Sound1:Play()
	TrocarCorBotaoOpcao(true)
	BotaOTipoItemMostrado = BotaoArma
	TrocarCorBotaoOpcao(false)
	TipoItemSendoMostrado = "Arma"
	ItemSelecionado = PlayerStats.Equipamento.Arma
	OpcaoItemEstatistic.ItemB.Text = string.upper(ArmaInfo[ItemSelecionado].Name)
	EstatisticaItemSelecionada = "Damage"
	Legenda.Value.Text = "DAMAGE"
	Legenda.Value.Text = string.upper(EstatisticaItemSelecionada)
	OpcaoItemEstatistic.EstatisticaB.Text = string.upper(EstatisticaItemSelecionada)
	ListarItens()
	ListarNomesEstatisticas()
	MostrarPlayerItemStatistic()
end)

BotaoHabilidade.Activated:Connect(function()
	if BotaOTipoItemMostrado == BotaoHabilidade then return end
	Sound1:Play()
	TrocarCorBotaoOpcao(true)
	BotaOTipoItemMostrado = BotaoHabilidade
	TrocarCorBotaoOpcao(false)
	TipoItemSendoMostrado = "Habilidade"
	ItemSelecionado = PlayerStats.Equipamento.Habilidade
	OpcaoItemEstatistic.ItemB.Text = string.upper(HabilidadeInfo[ItemSelecionado].Name)
	EstatisticaItemSelecionada = "Uses"
	Legenda.Value.Text = "USES"
	Legenda.Value.Text = string.upper(EstatisticaItemSelecionada)
	OpcaoItemEstatistic.EstatisticaB.Text = string.upper(EstatisticaItemSelecionada)
	ListarItens()
	ListarNomesEstatisticas()
	MostrarPlayerItemStatistic()
end)

BotaoArmadura.Activated:Connect(function()
	if BotaOTipoItemMostrado == BotaoArmadura then return end
	Sound1:Play()
	TrocarCorBotaoOpcao(true)
	BotaOTipoItemMostrado = BotaoArmadura
	TrocarCorBotaoOpcao(false)
	TipoItemSendoMostrado = "Armadura"
	ItemSelecionado = PlayerStats.Equipamento.Armadura
	OpcaoItemEstatistic.ItemB.Text = string.upper(ArmaduraInfo[ItemSelecionado].Name)
	EstatisticaItemSelecionada = "DamageTaken"
	Legenda.Value.Text = "DAMAGETAKEN"
	Legenda.Value.Text = string.upper(EstatisticaItemSelecionada)
	OpcaoItemEstatistic.EstatisticaB.Text = string.upper(EstatisticaItemSelecionada)
	ListarItens()
	ListarNomesEstatisticas()
	MostrarPlayerItemStatistic()
end)

OpcaoItemEstatistic.ItemB.Activated:Connect(function()
	Sound1:Play()
	ListaItens.Visible = not ListaItens.Visible
end)

OpcaoItemEstatistic.EstatisticaB.Activated:Connect(function()
	Sound1:Play()
	ListaNomeEstatisticas.Visible = not ListaNomeEstatisticas.Visible
end)

for i,k:TextButton in ipairs(ListaClasses:GetChildren()) do
	if k.Name == "Jump" then continue end
	k.Activated:Connect(function()
		if k.Name == ClasseSelecionada then return end
		OpcaoClasseComum.Classe.Text = string.upper(k.Name)
		OpcaoClassStatistic.Classe.Text = string.upper(k.Name)
		ClasseSelecionada = k.Name
		if AtualSendoMostrado == ClassXPButton then
			MostrarPlayersClassXP()
		elseif AtualSendoMostrado == ClassTimeButton then
			MostrarPlayersClassTime()
		elseif AtualSendoMostrado == ClassStatisticButton then
			MostrarPlayerClassStatistic()
		end
	end)
end

for i,k:TextButton in ipairs(ListaEstatisticasClasse:GetChildren()) do
	if k.Name == "Jump" then continue end
	k.Activated:Connect(function()
		if k.Name == EstatisticaClasseSelecionada then return end
		OpcaoClassStatistic.Estatistica.Text = string.upper(k.Name)
		Legenda.Value.Text = string.upper(k.Name)
		EstatisticaClasseSelecionada = k.Name
		if AtualSendoMostrado == ClassStatisticButton then
			MostrarPlayerClassStatistic()
		end
	end)
end

for i,k:TextButton in ipairs(ListaGeral:GetChildren()) do
	if k.Name == "Jump" then continue end
	k.Activated:Connect(function()
		if k.Name == EstatisticaGeralSelecionada then return end
		EstatisticaGeralSelecionada = k.Name
		Legenda.Value.Text = string.upper(k.Name)
		OpcaoGeral.Estatistica.Text = string.upper(k.Name)
		MostrarPlayersGeral(k.Name == "Time")
	end)
end

UserInputService.InputBegan:Connect(function(Input,InputFalso)
	if InputFalso then return end
	if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
		ListaClasses.Visible = false
	end
end)

OpcaoClasseComum.Classe.Text = string.upper(ClasseSelecionada)
OpcaoClassStatistic.Estatistica.Text = "DAMAGE" 
OpcaoItemEstatistic.ItemB.Text = string.upper(ArmaInfo[ItemSelecionado].Name)
OpcaoItemEstatistic.EstatisticaB.Text = "DAMAGE"
OpcaoGeral.Estatistica.Text = "XP"
Legenda.Value.Text = "XP"
MostrarPlayersGeral()

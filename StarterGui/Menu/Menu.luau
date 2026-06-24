local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService  = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local BindableEvents = ReplicatedStorage:WaitForChild("BindableEvents")
local ReabrirMenu = BindableEvents:WaitForChild("ReabrirMenu")
local TrocarTime = EventosRemotos:WaitForChild("TrocarTime")
local SolicitarSpawn = EventosRemotos:WaitForChild("SolicitarSpawn")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local Configuracao = ReplicatedStorage:WaitForChild("Configuração")
local Configuracoes = require(Configuracao:WaitForChild("Configurações"))
local MudarEquipamento = EventosRemotos:WaitForChild("MudarEquipamento")
local HUD:ScreenGui = ReplicatedStorage:WaitForChild("HUD")
local ClassUnlock = BindableEvents:WaitForChild("ClassUnlock")
local MenuEvent = EventosRemotos:WaitForChild("Menu")
local ClassPurchase = require(script:WaitForChild("ClassPurchase"))
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
local WeaponInfo = require(Configuracao:WaitForChild("Armas"))
local ArmorInfo = require(Configuracao:WaitForChild("Armaduras"))
local HabilidadeInfo = require(Configuracao:WaitForChild("Habilidades"))
local ClasseInfo = require(Configuracao:WaitForChild("Classes"))
local XPModule = require(Modulos:WaitForChild("XpCalculador"))
local TabelaDeTraducao = require(script:WaitForChild("TabelaDeTraducao"))
local LocalPlayer = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ClickSound1 = script:WaitForChild("Click1")
local ClickSound2 = script:WaitForChild("Click2")
local ClickSound3 = script:WaitForChild("Click3")
local ErroSound = script:WaitForChild("error")

while not PlayerStats.Loaded do task.wait() end

local Modelo = script:WaitForChild("Modelo")
local AreaEffect = script:WaitForChild("AreaEffect")
local ModeloUnlock = script:WaitForChild("Unlock")
local ModeloMensagem = script:WaitForChild("Mensagem")
local ModeloItem = script:WaitForChild("ModeloItem")
local ModeloInformacao = script:WaitForChild("ModeloInformacao")
local ModeloItemStatistic = script:WaitForChild("MoldeItemStatistic")

local Informacoes = {}

local Colors = {Color3.fromRGB(255, 106, 0),Color3.fromRGB(162, 0, 255)}

local ClasseSelecionada = PlayerStats.Class

local Menu = script.Parent
local Inferior = Menu:WaitForChild("Inferior")
local Meio = Menu:WaitForChild("Meio")
local Superior = Menu:WaitForChild("Superior")
local MeioSeletor = Meio:WaitForChild("Seletor")

local SPR_Play = Superior:WaitForChild("Play")
local SPR_MudarClasse = Superior:WaitForChild("MudarClasse")
local SPR_MudarTime = Superior:WaitForChild("MudarTime")
local SPR_BotaoTop = Superior:WaitForChild("BotaoTop")
local SPR_Gold = Superior:WaitForChild("Gold")

local MeioDefault = Meio:WaitForChild("Default")
local MDF_Boosters = MeioDefault:WaitForChild("Boosters")
local MDF_Info = MeioDefault:WaitForChild("Info")
local MDF_Mensagem = MeioDefault:WaitForChild("Mensagem")
local MDF_Profile = MeioDefault:WaitForChild("Profile")
local MDF_Settings = MeioDefault:WaitForChild("Settings")
local MDF_StatisticBotao = MDF_Profile:WaitForChild("StatisticsB")
local MDF_Statistic = MDF_Profile:WaitForChild("Statistic")
local MDF_ItemStatisticBotao = MDF_Profile:WaitForChild("ItemB")
local MDF_ItemStatistic = MDF_Profile:WaitForChild("ItemStatistic")
local MDF_Top = MeioDefault:WaitForChild("Top")

local InferiorDefault = Inferior:WaitForChild("Default")
local IDF_BarraDeProgresso = InferiorDefault:WaitForChild("BarraDeProgresso")
local IDF_Boosters = InferiorDefault:WaitForChild("Boosters")
local IDF_Info = InferiorDefault:WaitForChild("Info")
local IDF_Profile = InferiorDefault:WaitForChild("Profile")
local IDF_Settings = InferiorDefault:WaitForChild("Settings")

local InferiorSeletor = Inferior:WaitForChild("Seletor")
local ISL_BarraDeProgresso = InferiorSeletor:WaitForChild("BarraDeProgresso")
local ISL_ClasseBloqueada = InferiorSeletor:WaitForChild("ClasseBloqueada")
local ISL_Return = InferiorSeletor:WaitForChild("Return")

local SeletorClassesArea = Meio:WaitForChild("Seletor"):WaitForChild("Seletor")
local SLC_ClassInfo = SeletorClassesArea:WaitForChild("ClassInfo")
local SLC_ClassEquipment = SeletorClassesArea:WaitForChild("ClassEquipment")
local SLC_Classes = SeletorClassesArea:WaitForChild("Classes")
local SLC_NomeDaClasse = SeletorClassesArea:WaitForChild("NomeDaClasse")
local SLC_ChangeEquipamento = SeletorClassesArea:WaitForChild("ChangeEquipamento")

local EquipamentosArea = MeioSeletor:WaitForChild("Equipamento")
local EQP_TituloAreaEquipamento = EquipamentosArea:WaitForChild("Titulo")
local EQP_ItemList = EquipamentosArea:WaitForChild("ItemList")
local EQP_LocalDosItens = EQP_ItemList:WaitForChild("Itens")
local EQP_TituloDosItens = EQP_ItemList:WaitForChild("Titulo")
local EQP_InformacaoDosItens = EquipamentosArea:WaitForChild("ItemInformation")
local EQP_LocalDasInformacoes = EQP_InformacaoDosItens:WaitForChild("Informacoes")
local EQP_TituloDasInformacoes = EQP_InformacaoDosItens:WaitForChild("Titulo")
local EQP_BotaoMudarArma = EquipamentosArea.Botoes:WaitForChild("Arma")
local EQP_BotaoMudarHabilidade = EquipamentosArea.Botoes:WaitForChild("Habilidade")
local EQP_BotaoMudarArmadura = EquipamentosArea.Botoes:WaitForChild("Armor")
local EQP_BotaoVoltarParaClasses = EquipamentosArea:WaitForChild("Back")
local EQP_ListagemDeEquipamento = {}
local EQP_ListagemInformacao = {}

local MudarPoseCentral
local RetornarPoseCentral

local CarregandoBarra = false

local function MudarNomeEIconeSuperiorClasse(Classe:string)
	SPR_MudarClasse.Nome.Text = string.upper(Classe)
	SPR_MudarClasse.Icon.Image = SLC_Classes[Classe].O.Image
end

local function TrocarDeTime(Time:number)
	local Cor = Colors[Time]
	for i,k in ipairs(workspace.Thumb:GetChildren()) do
		k.Color = Cor
	end
	SPR_Play.UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
		ColorSequenceKeypoint.new(.001,Cor),
		ColorSequenceKeypoint.new(1,Cor),
	}
	--SPR_MudarClasse.Nome.TextColor3 = Cor
	--SPR_MudarClasse.Icon.ImageColor3 = Cor
	SPR_MudarTime.Orange.Visible = Time==1
	SPR_MudarTime.Purple.Visible = Time==2
	SPR_MudarTime.O.Visible = Time==1
	SPR_MudarTime.P.Visible = Time==2

	SLC_Classes.ScrollBarImageColor3 = Cor
	for i,F:Frame in ipairs(SLC_Classes:GetChildren()) do
		if F.ClassName ~= "TextButton" then continue end
		F.O.ImageColor3 = Cor
	end
end

local function UpdateClassEquipamentoShow(NomeDaClasse)
	SLC_ClassEquipment.Weapon.NameT.Text = string.upper(WeaponInfo[PlayerStats.Equipamentos[NomeDaClasse].Arma].Name)
	SLC_ClassEquipment.Hability.NameT.Text = string.upper(HabilidadeInfo[PlayerStats.Equipamentos[NomeDaClasse].Habilidade].Name)
	SLC_ClassEquipment.Armor.NameT.Text = string.upper(ArmorInfo[PlayerStats.Equipamentos[NomeDaClasse].Armadura].Name)
end

local function ConverterSegundosPTempo(Segundos:number)
	Segundos = math.floor(Segundos)
	local Minutos = (Segundos%3600)/60
	local Horas = Segundos/3600
	local Saida = string.format("%01dh:%02dm:%02ds",Horas,Minutos,Segundos%60)
	return Saida
end

local function UpdateStatsDoSeletor(Classe:string)
	local StatsText = SLC_ClassInfo:WaitForChild("AEH")
	local Valores = {}
	for Stat,Valor in pairs(PlayerStats.ClassStats[Classe]) do
		local Acrescimo = Valor-ClasseInfo[Classe][Stat]
		StatsText[Stat]["Valor"].Text = tostring(Valor)
		if Acrescimo ~= 0 then
			if Acrescimo > 0 then
				StatsText[Stat]["Valor"].Text ..= "(+"..tostring(Acrescimo)..")"
			else
				StatsText[Stat]["Valor"].Text ..= "("..tostring(Acrescimo)..")"
			end
		end
	end
end

local function UpdateBarraXP(Classe:string)
	local Level = PlayerStats.ClassesLvl[Classe]
	IDF_BarraDeProgresso.Atual.Text = "LVL "..tostring(Level)
	IDF_BarraDeProgresso.Proximo.Text = "LVL "..tostring(Level+1)
	local XP1 = XPModule.XPDeLevel[Level-1]
	local XP2 = XPModule.XPDeLevel[Level]
	local XP3 = PlayerStats.ClassXP[Classe]
	local XPAtual = XP3-XP1
	local XPRequerido = XP2-XP1
	IDF_BarraDeProgresso.BarraDeProgresso.TextLabel.Text = tostring(math.round(XPAtual)).."/"..tostring(XPRequerido)
	IDF_BarraDeProgresso.BarraDeProgresso.UIGradient.Offset= Vector2.new(XPAtual/XPRequerido-1,0) 
end

local function UpdateBarraXPSeletor(Classe:string)
	local Level = PlayerStats.ClassesLvl[Classe]
	ISL_BarraDeProgresso.Atual.Text = "LVL "..tostring(Level)
	ISL_BarraDeProgresso.Proximo.Text = "LVL "..tostring(Level+1)
	local XP1 = XPModule.XPDeLevel[Level-1]
	local XP2 = XPModule.XPDeLevel[Level]
	local XP3 = PlayerStats.ClassXP[Classe]
	local XPAtual = XP3-XP1
	local XPRequerido = XP2-XP1
	ISL_BarraDeProgresso.BarraDeProgresso.TextLabel.Text = tostring(math.round(XPAtual)).."/"..tostring(XPRequerido)
	ISL_BarraDeProgresso.BarraDeProgresso.UIGradient.Offset= Vector2.new(XPAtual/XPRequerido-1,0) 
end

local Movendo = false
local function MovendoTerminou()
	Movendo = false
end

local function MostrarClasses(Bool)
	Movendo = true
	if Bool then
		Meio:TweenPosition(UDim2.fromScale(-1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,.5,false)
		Inferior:TweenPosition(UDim2.fromScale(-1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,.5,false)
	else
		Meio:TweenPosition(UDim2.fromScale(0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,.5,false)
		Inferior:TweenPosition(UDim2.fromScale(0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,.5,false)
	end
	task.delay(.5,MovendoTerminou)
end

local Espaco = false
local function UpdateClassUnlock(Bool:boolean,Classe:string)
	if Bool then
		SeletorClassesArea.R1.Visible = true
		SeletorClassesArea.R2.Visible = #Configuracoes.RequesitosClasse[Classe] > 1
		SeletorClassesArea.Lock.Visible = true
		SeletorClassesArea.RTitulo.Visible = true
		SeletorClassesArea.BlackScreen.Visible = true
		for i,NomeDaClasse in ipairs(Configuracoes.RequesitosClasse[Classe]) do
			SeletorClassesArea["R"..tostring(i)].Text = string.upper(NomeDaClasse).." LEVEL "..tostring(Configuracoes.UnlockLevel)
		end
	else
		SeletorClassesArea.R1.Visible = false
		SeletorClassesArea.R2.Visible = false
		SeletorClassesArea.Lock.Visible = false
		SeletorClassesArea.RTitulo.Visible = false
		SeletorClassesArea.BlackScreen.Visible = false
	end
end

local SelecionandoClasse = false
--######### RETURN #######################
--[[ISL_Return.Activated:Connect(function()
	if Movendo then return end
	SelecionandoClasse = false
	MostrarClasses(SelecionandoClasse)
	ClickSound3:Play()
end)]]

--######### CHANGE CLASS #######################
--[[SPR_MudarClasse.Activated:Connect(function()
	if Movendo then return end
	SelecionandoClasse = not SelecionandoClasse
	MostrarClasses(SelecionandoClasse)
	ClickSound3:Play()
end)]]

--######### CHANGE TEAM #######################
local TrocandoTime = false
SPR_MudarTime.Activated:Connect(function()
	if TrocandoTime then return end
	TrocandoTime = true
	local Sucesso,Time = TrocarTime:InvokeServer()
	if Sucesso then
		TrocarDeTime(Time)
		ClickSound2:Play()
	else
		ErroSound:Play()
	end
	TrocandoTime = false
end)

local Descricoes = require(script:WaitForChild("Descricao"))
local SLC_HabilityInfo = SeletorClassesArea:WaitForChild("HabilityInfo")
local function UpdateDescDaHabilidade(NomeDaClasse:string)
	SLC_HabilityInfo.Texto.Text = string.upper(Descricoes[NomeDaClasse])
	SLC_HabilityInfo.Texto.UITextSizeConstraint.MaxTextSize = SLC_HabilityInfo.TClass.TextBounds.Y*.7
	SLC_HabilityInfo.TClass.Text = string.upper(NomeDaClasse)
end

local LigacaoBotoes = {}
--######### BOTAO DAS CLASSES #######################
local ClasseBloqueada
for i,Botao:TextButton in ipairs(SLC_Classes:GetChildren()) do
	if not Botao:IsA("TextButton") then continue end
	local ClassName = Botao.Name
	Botao.Lock.Visible = false
	LigacaoBotoes[ClassName] = Botao.Activated:Connect(function()
		ClasseSelecionada = ClassName
		UpdateDescDaHabilidade(ClassName)
		SLC_NomeDaClasse.Texto.Text = string.upper(ClassName)
		UpdateStatsDoSeletor(ClassName)
		UpdateBarraXPSeletor(ClassName)
		ClickSound1:Play()
		MudarPoseCentral(ClassName)
		UpdateClassUnlock(false,ClassName)
		Botao.Lock.Visible = false
		PlayerStats.ChangeClass(ClassName)
		ISL_ClasseBloqueada.Visible = false
		IDF_BarraDeProgresso.Visible = true
		UpdateBarraXP(ClassName)
		MudarNomeEIconeSuperiorClasse(ClassName)
	end)
end

ISL_ClasseBloqueada.Activated:Connect(function()
	ClassPurchase.PromptPlayer(ClasseBloqueada)
end)

PlayerStats.DesbloquearClasseMenu(function(NomeDaClasse:string)
	LigacaoBotoes[NomeDaClasse]:Disconnect()
	if ClasseBloqueada == NomeDaClasse then ClasseBloqueada = nil end
	local NovoBotao:TextButton = SLC_Classes[NomeDaClasse]
	NovoBotao.Lock.Visible = false
	NovoBotao.Activated:Connect(function()
		ClasseSelecionada = NomeDaClasse
		SLC_NomeDaClasse.Texto.Text = string.upper(NomeDaClasse)
		UpdateClassUnlock(false,NomeDaClasse)
		UpdateStatsDoSeletor(NomeDaClasse)
		--UpdateClassEquipamentoShow(NomeDaClasse)
		UpdateBarraXPSeletor(NomeDaClasse)
		ClickSound1:Play()
		MudarPoseCentral(NomeDaClasse)
		NovoBotao.Lock.Visible = false
		PlayerStats.ChangeClass(NomeDaClasse)
		ISL_ClasseBloqueada.Visible = false
		ISL_BarraDeProgresso.Visible = true
		UpdateBarraXP(NomeDaClasse)
		MudarNomeEIconeSuperiorClasse(NomeDaClasse)
	end)
end)

--######### BOTOES INFERIORES #######################
local BotaoInferiorApertado = ""
IDF_Info.Activated:Connect(function()
	if BotaoInferiorApertado == "Info" then 
		BotaoInferiorApertado = ""
		MeioSeletor.Visible = true
		MDF_Info.Visible = false
		return 
	end
	BotaoInferiorApertado = "Info"
	MDF_Profile.Visible = false
	MDF_Boosters.Visible = false
	MDF_Settings.Visible = false
	MeioSeletor.Visible = false
	MDF_Top.Visible = false
	MDF_Info.Visible = not MDF_Info.Visible
	ClickSound3:Play()
end)

MDF_Info.Titulo.ImageButton.Activated:Connect(function()
	MDF_Info.Visible = false
	BotaoInferiorApertado = ""
	MeioSeletor.Visible = true
	ClickSound2:Play()
end)

IDF_Settings.Activated:Connect(function()
	if BotaoInferiorApertado == "Settings" then
		BotaoInferiorApertado = ""
		MeioSeletor.Visible = true
		MDF_Settings.Visible = false
		return 
	end
	BotaoInferiorApertado = "Settings"
	MDF_Profile.Visible = false
	MDF_Info.Visible = false
	MDF_Boosters.Visible = false
	MeioSeletor.Visible = false
	MDF_Top.Visible = false
	MDF_Settings.Visible = not MDF_Settings.Visible
	ClickSound3:Play()
end)

MDF_Settings.Titulo.ImageButton.Activated:Connect(function()
	ClickSound2:Play()
	BotaoInferiorApertado = ""
	MeioSeletor.Visible = true
	MDF_Settings.Visible = false
end)

IDF_Boosters.Activated:Connect(function()
	if BotaoInferiorApertado == "Boosters" then
		BotaoInferiorApertado = ""
		MDF_Boosters.Visible = false
		MeioSeletor.Visible = true
		return 
	end
	BotaoInferiorApertado = "Boosters"
	MDF_Profile.Visible = false
	MDF_Settings.Visible = false
	MDF_Info.Visible = false
	MeioSeletor.Visible = false
	MDF_Top.Visible = false
	MDF_Boosters.Visible = not MDF_Boosters.Visible
	ClickSound3:Play()
end)

MDF_Boosters.Titulo.ImageButton.Activated:Connect(function()
	ClickSound2:Play()
	BotaoInferiorApertado = ""
	MDF_Boosters.Visible = false
	MeioSeletor.Visible = true
end)

IDF_Profile.Activated:Connect(function()
	if BotaoInferiorApertado == "Profile" then
		MDF_Profile.Visible = false
		BotaoInferiorApertado = ""
		MeioSeletor.Visible = true
		return 
	end
	BotaoInferiorApertado = "Profile"
	MDF_Settings.Visible = false
	MDF_Info.Visible = false
	MDF_Boosters.Visible = false
	MeioSeletor.Visible = false
	MDF_Top.Visible = false
	MDF_Profile.Visible = not MDF_Profile.Visible
	ClickSound3:Play()
end)

MDF_Profile.Titulo.ImageButton.Activated:Connect(function()
	ClickSound2:Play()
	BotaoInferiorApertado = ""
	MDF_Profile.Visible = false
	MeioSeletor.Visible = true
end)

SPR_BotaoTop.Botao.Activated:Connect(function()
	if BotaoInferiorApertado == "Top" then
		MDF_Top.Visible = false
		BotaoInferiorApertado = ""
		MeioSeletor.Visible = true
		return 
	end
	BotaoInferiorApertado = "Top"
	MDF_Settings.Visible = false
	MDF_Info.Visible = false
	MDF_Boosters.Visible = false
	MeioSeletor.Visible = false
	MDF_Top.Visible = not MDF_Top.Visible
	ClickSound3:Play()
end)

MDF_Top.Titulo.ImageButton.Activated:Connect(function()
	ClickSound2:Play()
	BotaoInferiorApertado = ""
	MDF_Top.Visible = false
	MeioSeletor.Visible = true
end)

--######### XPBOOST #######################


--######### CONFIG #######################
local EnemyShot = 1
local FriendShot = 2
local ED = {
	"ENABLED",
	"DISABLED"
}

--############### STATISTICS ##############

local Cores = {Color3.fromRGB(38, 36, 47),Color3.fromRGB(46, 44, 58)}
local CoresUnlock = {Color3.fromRGB(36, 47, 36),Color3.fromRGB(44, 58, 44)}
local CoresStats = {Color3.fromRGB(47, 47, 36),Color3.fromRGB(58, 58, 44)}
local TiposDeItens = {Arma = WeaponInfo, Habilidade = HabilidadeInfo, Armadura = ArmorInfo}
local TAB = "	"
function AtualizarInformacaoItem(ItemTabela,TipoDoItem)
	local Espaco = false
	local Contador = 1
	EQP_TituloDasInformacoes.Text = string.upper(ItemTabela.Name)
	for i,k in ipairs(EQP_ListagemInformacao) do k:Destroy() end
	if ItemTabela.Show then
		for i,NomeDoAtributo in pairs(ItemTabela.Show) do
			if NomeDoAtributo == TAB then Espaco = not Espaco continue end
			if not TabelaDeTraducao[NomeDoAtributo] then continue end
			local Clone = ModeloInformacao:Clone()
			Clone.Parent = EQP_InformacaoDosItens.Informacoes
			Clone.BackgroundColor3 = Cores[Contador%2+1]
			Clone.LayoutOrder = 1+Contador
			Contador += 1
			Clone.Info.Text = string.upper(TabelaDeTraducao[NomeDoAtributo])
			if Espaco then Clone.Info.Text = TAB..Clone.Info.Text end
			Clone.Valor.Text = if ItemTabela[NomeDoAtributo] then tostring(ItemTabela[NomeDoAtributo]) else ""
			table.insert(EQP_ListagemInformacao,Clone)
		end
	else
		for NomeDoAtributo,Valor:number in pairs(ItemTabela) do
			local NomeNaTabela = TabelaDeTraducao[NomeDoAtributo]
			if not NomeNaTabela then continue end
			local Clone = ModeloInformacao:Clone()
			Clone.Parent = EQP_InformacaoDosItens.Informacoes
			Clone.LayoutOrder = 1+Contador
			Clone.BackgroundColor3 = Cores[Contador%2+1]
			Contador += 1
			Clone.Info.Text = string.upper(NomeNaTabela)
			Clone.Valor.Text = if type(Valor) == "number" then tostring(Valor) else ""
			table.insert(EQP_ListagemInformacao,Clone)
		end
	end
	if ItemTabela.Stats then
		local Cl = ModeloInformacao:Clone()
		Cl.Parent = EQP_InformacaoDosItens.Informacoes
		Cl.LayoutOrder = Contador
		Cl.BackgroundColor3 = CoresStats[Contador%2+1]
		Contador += 1
		Cl.Info.Text = "STATS:"
		Cl.Valor.Text = ""
		table.insert(EQP_ListagemInformacao,Cl)
		for Atritubo,Valor in pairs(ItemTabela.Stats) do
			local Clone = ModeloInformacao:Clone()
			Clone.Parent = EQP_InformacaoDosItens.Informacoes
			Clone.LayoutOrder = Contador
			Clone.BackgroundColor3 = CoresStats[Contador%2+1]
			Contador += 1
			Clone.Info.Text = TAB..string.upper(Atritubo)
			Clone.Valor.Text = tostring(Valor)
			table.insert(EQP_ListagemInformacao,Clone)
		end
	end
	if ItemTabela.Unlock then
		local Cl = ModeloInformacao:Clone()
		Cl.Parent = EQP_InformacaoDosItens.Informacoes
		Cl.LayoutOrder = Contador
		Cl.BackgroundColor3 = CoresUnlock[Contador%2+1]
		Contador += 1
		Cl.Info.Text = "UNLOCK:"
		Cl.Valor.Text = ""
		table.insert(EQP_ListagemInformacao,Cl)
		for Tipo,Info in pairs(ItemTabela.Unlock) do
			if Tipo == "AnyLevel" then
				local Classes = ItemTabela.Unlock.AnyLevel[1]
				local LevelNecessario = ItemTabela.Unlock.AnyLevel[2]
				--[[local Clone = ModeloInformacao:Clone()
				Clone.Parent = EQP_InformacaoDosItens.Informacoes
				Clone.LayoutOrder = Contador
				Clone.BackgroundColor3 = CoresUnlock[Contador%2+1]
				Contador += 1
				table.insert(EQP_ListagemInformacao,Clone)
				Clone.Info.Text = TAB.."AT LEAST ONE OF THESE CLASSES AT LVL "..tostring(LevelNecessario)
				Clone.Valor.Text = ""]]
				local StringDasClasses = table.concat(Classes," OR ")
				local Clone = ModeloInformacao:Clone()
				Clone.Parent = EQP_InformacaoDosItens.Informacoes
				Clone.LayoutOrder = Contador
				Clone.BackgroundColor3 = CoresUnlock[Contador%2+1]
				Contador += 1
				if #Classes > 1 then
					StringDasClasses = "("..StringDasClasses..")"
				end
				Clone.Info.Text = TAB..string.upper(StringDasClasses).." LEVEL "..tostring(LevelNecessario)
				local Maior = PlayerStats.ClassesLvl[Classes[1]]
				for i=2,#Classes do
					if PlayerStats.ClassesLvl[Classes[i]] > Maior then
						Maior = PlayerStats.ClassesLvl[Classes[i]]
					end
				end
				Clone.Valor.Text = tostring(Maior).."/"..tostring(LevelNecessario)
				table.insert(EQP_ListagemInformacao,Clone)
			end
			if Tipo == "Level" then
				local Classes = ItemTabela.Unlock.Level[1]
				local LevelNecessario = ItemTabela.Unlock.Level[2]
				--[[local Clone = ModeloInformacao:Clone()
				Clone.Parent = EQP_InformacaoDosItens.Informacoes
				Clone.LayoutOrder = Contador
				Clone.BackgroundColor3 = CoresUnlock[Contador%2+1]
				Contador += 1
				table.insert(EQP_ListagemInformacao,Clone)
				Clone.Info.Text = TAB.."ALL THESE CLASSES AT LVL "..tostring(LevelNecessario)
				Clone.Valor.Text = ""]]
				for i,NomeClasse in ipairs(Classes) do
					local Clone = ModeloInformacao:Clone()
					Clone.Parent = EQP_InformacaoDosItens.Informacoes
					Clone.LayoutOrder = Contador
					Clone.BackgroundColor3 = CoresUnlock[Contador%2+1]
					Contador += 1
					Clone.Info.Text = TAB..string.upper(NomeClasse).." LEVEL "..tostring(LevelNecessario)
					Clone.Valor.Text = tostring(PlayerStats.ClassesLvl[NomeClasse]).."/"..tostring(LevelNecessario)
					table.insert(EQP_ListagemInformacao,Clone)
					if PlayerStats.ClassesLvl[NomeClasse] >= LevelNecessario then

					end
				end
			end
			if Tipo == "ClassStatistic" then
				--[[local Clone = ModeloInformacao:Clone()
				Clone.Parent = EQP_InformacaoDosItens.Informacoes
				Clone.LayoutOrder = Contador
				Clone.BackgroundColor3 = CoresUnlock[Contador%2+1]
				Contador += 1
				table.insert(EQP_ListagemInformacao,Clone)
				Clone.Info.Text = TAB.."CLASS STATISTIC"
				Clone.Valor.Text = ""]]
				for i,Requesitos in ipairs(Info) do
					local Clone = ModeloInformacao:Clone()
					Clone.Parent = EQP_InformacaoDosItens.Informacoes
					Clone.LayoutOrder = Contador
					Clone.BackgroundColor3 = CoresUnlock[Contador%2+1]
					Contador += 1
					table.insert(EQP_ListagemInformacao,Clone)
					Clone.Info.Text = TAB..string.upper(Requesitos[2]).." AS AN "..string.upper(Requesitos[1])
					Clone.Valor.Text = tostring(PlayerStats.ClassStatistic[Requesitos[1]][Requesitos[2]]).."/"..tostring(Requesitos[3])
				end
			end
			if Tipo == "ItemStatistic" then
				--[[local Clone = ModeloInformacao:Clone()
				Clone.Parent = EQP_InformacaoDosItens.Informacoes
				Clone.LayoutOrder = Contador
				Clone.BackgroundColor3 = CoresUnlock[Contador%2+1]
				Contador += 1
				table.insert(EQP_ListagemInformacao,Clone)
				Clone.Info.Text = TAB.."ITEM STATISTIC"
				Clone.Valor.Text = ""]]
				for i,Requesitos in ipairs(Info) do
					local Clone = ModeloInformacao:Clone()
					Clone.Parent = EQP_InformacaoDosItens.Informacoes
					Clone.LayoutOrder = Contador
					Clone.BackgroundColor3 = CoresUnlock[Contador%2+1]
					Contador += 1
					table.insert(EQP_ListagemInformacao,Clone)
					Clone.Info.Text = TAB..string.upper(Requesitos[2]).." USING "..string.upper(TiposDeItens[TipoDoItem][Requesitos[1]].Name)
					Clone.Valor.Text = tostring(PlayerStats.ItemStatistic[Requesitos[1]][Requesitos[2]]).."/"..tostring(Requesitos[3])
				end
			end
		end
	end
end

local TipoParaNumero = {Arma=1,Habilidade=2,Armadura=3}
local function MudarOEquipamento(Item:string,Tipo:string)
	local StringInfo = string.pack("zI1z",Item,TipoParaNumero[Tipo],ClasseSelecionada)
	MudarEquipamento:FireServer(StringInfo)
end

local SelecionadoAtual 
function AtualizarItens(Tipo)
	local Itens = Configuracoes.ItensOrganizados[ClasseSelecionada][Tipo]
	for i,k in ipairs(EQP_ListagemDeEquipamento) do k:Destroy() end
	for i,Item in ipairs(Itens) do
		local Clone = ModeloItem:Clone()
		Clone.Parent = EQP_ItemList.Itens
		local Liberado = PlayerStats.ItensDesbloqueados[Item] 
		if Liberado then Clone.Lock.Visible = false end
		if PlayerStats.Equipamentos[ClasseSelecionada][Tipo] == Item then
			SelecionadoAtual = Clone
			Clone.BackgroundColor3 = Color3.new(1,1,1)
			Clone.NomeItem.TextColor3 = Color3.fromRGB(36, 40, 47)
		end
		local ItemTabela = TiposDeItens[Tipo][Item]
		local NomeDoItem = string.upper(ItemTabela.Name)
		Clone.NomeItem.Text = NomeDoItem
		Clone.LayoutOrder = ItemTabela.Rarity
		table.insert(EQP_ListagemDeEquipamento,Clone)
		Clone.Activated:Connect(function()
			ClickSound1:Play()
			if Liberado then
				MudarOEquipamento(Item,Tipo)
				PlayerStats.Equipamentos[ClasseSelecionada][Tipo] = Item
				PlayerStats.UpdateClassStats(ClasseSelecionada)
				SelecionadoAtual.BackgroundColor3 = Color3.fromRGB(36, 40, 47)
				SelecionadoAtual.NomeItem.TextColor3 = Color3.new(1,1,1)
				SelecionadoAtual = Clone
				Clone.BackgroundColor3 = Color3.new(1,1,1)
				Clone.NomeItem.TextColor3 = Color3.fromRGB(36, 40, 47)
				--UpdateClassEquipamentoShow(ClasseSelecionada)
				UpdateStatsDoSeletor(ClasseSelecionada)
			end
			AtualizarInformacaoItem(ItemTabela,Tipo)
		end)
	end
end

local BotaoEquipamentoAtual = "Arma"
EQP_BotaoMudarArma.BackgroundColor3 = Color3.new(1,1,1)
EQP_BotaoMudarArma.TextLabel.TextColor3 = Color3.fromRGB(36, 40, 47)
local BotoesDoEquipamento = {Arma = EQP_BotaoMudarArma,Habilidade = EQP_BotaoMudarHabilidade,Armadura = EQP_BotaoMudarArmadura}

local function MudarTipoSendoMostrado(NomeDoTipo:string,NovoTitulo:string,TipoDaInfo)
	if BotaoEquipamentoAtual == NomeDoTipo then return end
	ClickSound3:Play()
	BotoesDoEquipamento[NomeDoTipo].BackgroundColor3 = Color3.new(1,1,1)
	BotoesDoEquipamento[NomeDoTipo].TextLabel.TextColor3 = Color3.fromRGB(36, 40, 47)
	BotoesDoEquipamento[BotaoEquipamentoAtual].BackgroundColor3 = Color3.fromRGB(36, 40, 47)
	BotoesDoEquipamento[BotaoEquipamentoAtual].TextLabel.TextColor3 = Color3.new(1,1,1)
	BotaoEquipamentoAtual = NomeDoTipo
	EQP_TituloDosItens.Text = NovoTitulo
	AtualizarItens(NomeDoTipo)
	AtualizarInformacaoItem(TipoDaInfo[PlayerStats.Equipamentos[ClasseSelecionada][NomeDoTipo]],NomeDoTipo)
end

EQP_BotaoMudarArma.Activated:Connect(function()
	MudarTipoSendoMostrado("Arma","WEAPON LIST",WeaponInfo)
end)
EQP_BotaoMudarHabilidade.Activated:Connect(function()
	MudarTipoSendoMostrado("Habilidade","HABILITY LIST",HabilidadeInfo)
end)
EQP_BotaoMudarArmadura.Activated:Connect(function()
	MudarTipoSendoMostrado("Armadura","ARMOR LIST",ArmorInfo)
end)

local ClassUnlockBloqueada = nil
EQP_BotaoVoltarParaClasses.Activated:Connect(function()
	ClickSound3:Play()
	EQP_BotaoMudarArma.Parent.Visible = false
	EQP_ItemList.Visible = false
	EQP_InformacaoDosItens.Visible = false
	EQP_BotaoVoltarParaClasses.Visible = false

	SLC_HabilityInfo.Visible = true
	--SLC_ClassEquipment.Visible = true
	SLC_ClassInfo:TweenPosition(UDim2.fromScale(0.02,0.02),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,.1)
	SLC_ClassInfo.Visible = true
	SLC_Classes.Visible = true
	SLC_ChangeEquipamento.Visible = true
end)

local function MostrarEquipamentos()
	ClickSound3:Play()
	AtualizarItens(BotaoEquipamentoAtual)
	AtualizarInformacaoItem(WeaponInfo[PlayerStats.Equipamentos[ClasseSelecionada].Arma],"Arma")
	EQP_BotaoMudarArma.Parent.Visible = true
	EQP_ItemList.Visible = true
	EQP_InformacaoDosItens.Visible = true
	EQP_BotaoVoltarParaClasses.Visible = true

	SLC_HabilityInfo.Visible = false
	SLC_ClassEquipment.Visible = false
	SLC_ClassInfo:TweenPosition(UDim2.fromScale(0.02,0.51),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,.2)
	SLC_Classes.Visible = false
	SLC_ChangeEquipamento.Visible = false
end

SLC_ChangeEquipamento.Activated:Connect(MostrarEquipamentos)

SLC_ClassEquipment.Weapon.NameT.TextButton.Activated:Connect(function()
	MudarTipoSendoMostrado("Arma","WEAPON LIST",WeaponInfo)
	MostrarEquipamentos()
end)

SLC_ClassEquipment.Hability.NameT.TextButton.Activated:Connect(function()
	MudarTipoSendoMostrado("Habilidade","HABILITY LIST",HabilidadeInfo)
	MostrarEquipamentos()
end)

SLC_ClassEquipment.Armor.NameT.TextButton.Activated:Connect(function()
	MudarTipoSendoMostrado("Armadura","ARMOR LIST",ArmorInfo)
	MostrarEquipamentos()
end)

local DefaultButtonPosition = UDim2.fromScale(0.25,0)
local CoresStatistic = {Color3.fromRGB(44, 49, 58),Color3.fromRGB(36, 40, 47)}
local MostrarModificado = false

local ModeloEstatisticaArma = script:WaitForChild("ModeloEstatisticaArma")
local ListaDasInformacoesArma = {}
function ListarStatisticArma()
	for NomeDaArma,InformacaoDaArma in pairs(WeaponInfo) do
		local Clone = ModeloEstatisticaArma:Clone()
		table.insert(ListaDasInformacoesArma,Clone)
		Clone.Name = NomeDaArma
		Clone.Parent = MDF_ItemStatistic.ListaArmas
		Clone.Nome.Text = string.upper(InformacaoDaArma.Name) 
		Clone.Type.Text = string.upper(InformacaoDaArma.Type)
		Clone.Damage.Text = tostring(math.floor(PlayerStats["ItemStatistic"][NomeDaArma].Damage))
		Clone.Kills.Text = tostring(math.floor(PlayerStats["ItemStatistic"][NomeDaArma].Kills))
		Clone.Hits.Text = tostring(math.floor(PlayerStats["ItemStatistic"][NomeDaArma].Hits))
		Clone.Shots.Text = tostring(math.floor(PlayerStats["ItemStatistic"][NomeDaArma].Shots))
	end
end

local ItemStatisticHabilidadeSendoMostrada = {}
local ListaDosAtributosDaHabilidade = {}
local ItemStatisticClasseMostrada = PlayerStats.Class
local ModeloEstatisticaHabilidade = script:WaitForChild("ModeloEstatisticaHabilidade")
function ListarStatisticHabilidade()
	table.clear(ListaDosAtributosDaHabilidade)
	local AMostrar = if MostrarModificado then "ItemStatisticModificada" else "ItemStatistic"
	for i,k in ipairs(ItemStatisticHabilidadeSendoMostrada) do k:Destroy() end
	table.clear(ItemStatisticHabilidadeSendoMostrada)
	local Contador = 0
	for NomeDoAtributo, Valor in pairs(PlayerStats.ItemStatistic[PlayerStats.Equipamentos[ItemStatisticClasseMostrada]["Habilidade"]]) do
		Contador += 1
		MDF_ItemStatistic.LegendaHabilidade[tostring(Contador)].Text = string.upper(TabelaDeTraducao[NomeDoAtributo] or NomeDoAtributo)
		MDF_ItemStatistic.LegendaHabilidade[tostring(Contador)].Visible = true
		ListaDosAtributosDaHabilidade[Contador] = NomeDoAtributo
	end
	for i=Contador+1,5 do
		MDF_ItemStatistic.LegendaHabilidade[tostring(i)].Visible = false
	end
	for i,NomeDaHabilidade in ipairs(Configuracoes.ItensOrganizados[ItemStatisticClasseMostrada]["Habilidade"]) do
		local Clone = ModeloEstatisticaHabilidade:Clone()
		Clone.Parent = MDF_ItemStatistic.ListaHabilidade
		table.insert(ItemStatisticHabilidadeSendoMostrada,Clone)
		Clone.Name = NomeDaHabilidade
		Clone.Nome.Text = string.upper(HabilidadeInfo[NomeDaHabilidade].Name)
		local Contador2 = 0
		for i=1,Contador do
			Clone[tostring(i)].Text = tostring(math.floor(PlayerStats[AMostrar][NomeDaHabilidade][ListaDosAtributosDaHabilidade[i]]))
		end
		for i=Contador+1,5 do
			Clone[tostring(i)].Visible = false
		end
	end
end

local ModeloEstatisticaArmadura = script:WaitForChild("ModeloEstatisticaArmadura")
local ListaDasInformacoesArmadura = {}
function ListarStatisticArmadura()
	for NomeDaArmadura,InformacaoDaArma in pairs(ArmorInfo) do
		local Clone = ModeloEstatisticaArmadura:Clone()
		table.insert(ListaDasInformacoesArmadura,Clone)
		Clone.Name = NomeDaArmadura
		Clone.Parent = MDF_ItemStatistic.ListaArmadura
		Clone.Nome.Text = string.upper(InformacaoDaArma.Name) 
		Clone.Type.Text = string.upper(InformacaoDaArma.Type)
		Clone.DamageTaken.Text = tostring(math.floor(PlayerStats["ItemStatistic"][NomeDaArmadura].DamageTaken))
		Clone.HitsTake.Text = tostring(math.floor(PlayerStats["ItemStatistic"][NomeDaArmadura].HitsTake))
	end
end

local CorSelecionado = Color3.new(1, 1, 0.807843)
local CorNaoSelecionado = Color3.new(1, 1, 1)

local OrganizacaoDaInformacaoArma = "Kills"
function OrdenarItemStatisticArma()
	local Size = #ListaDasInformacoesArma
	for i=2,Size do
		local Save = ListaDasInformacoesArma[i]
		local j = i-1
		if OrganizacaoDaInformacaoArma == "Type" or OrganizacaoDaInformacaoArma == "Nome" then
			while j>=1 and ListaDasInformacoesArma[j][OrganizacaoDaInformacaoArma].Text > Save[OrganizacaoDaInformacaoArma].Text do
				ListaDasInformacoesArma[j+1] = ListaDasInformacoesArma[j]
				j -= 1
			end
			ListaDasInformacoesArma[j+1] = Save
		else
			while j>=1 and tonumber(ListaDasInformacoesArma[j][OrganizacaoDaInformacaoArma].Text) < tonumber(Save[OrganizacaoDaInformacaoArma].Text) do
				ListaDasInformacoesArma[j+1] = ListaDasInformacoesArma[j]
				j -= 1
			end
			ListaDasInformacoesArma[j+1] = Save
		end
	end
	for i,Frame:Frame in ipairs(ListaDasInformacoesArma) do
		Frame.LayoutOrder = i
		Frame.BackgroundColor3 = CoresStatistic[i%2+1]
		Frame.Posicao.Text = tostring(i)
	end
end
MDF_ItemStatistic.LegendaArma[OrganizacaoDaInformacaoArma].TextColor3 = CorSelecionado
for i,k:TextButton in ipairs(MDF_ItemStatistic.LegendaArma:GetChildren()) do
	k.Activated:Connect(function()
		ClickSound1:Play()
		MDF_ItemStatistic.LegendaArma[OrganizacaoDaInformacaoArma].TextColor3 = CorNaoSelecionado
		OrganizacaoDaInformacaoArma = k.Name
		MDF_ItemStatistic.LegendaArma[OrganizacaoDaInformacaoArma].TextColor3 = CorSelecionado
		OrdenarItemStatisticArma()
	end)
end

local OrganizacaoDaInformacaoArmadura = "DamageTaken"
function OrdenarItemStatisticArmadura()
	local Size = #ListaDasInformacoesArmadura
	for i=2,Size do
		local Save = ListaDasInformacoesArmadura[i]
		local j = i-1
		if OrganizacaoDaInformacaoArmadura == "Type" or OrganizacaoDaInformacaoArmadura == "Nome" then
			while j>=1 and ListaDasInformacoesArmadura[j][OrganizacaoDaInformacaoArmadura].Text > Save[OrganizacaoDaInformacaoArmadura].Text do
				ListaDasInformacoesArmadura[j+1] = ListaDasInformacoesArmadura[j]
				j -= 1
			end
			ListaDasInformacoesArmadura[j+1] = Save
		else
			while j>=1 and tonumber(ListaDasInformacoesArmadura[j][OrganizacaoDaInformacaoArmadura].Text) < tonumber(Save[OrganizacaoDaInformacaoArmadura].Text) do
				ListaDasInformacoesArmadura[j+1] = ListaDasInformacoesArmadura[j]
				j -= 1
			end
			ListaDasInformacoesArmadura[j+1] = Save
		end
	end
	for i,Frame:Frame in ipairs(ListaDasInformacoesArmadura) do
		Frame.LayoutOrder = i
		Frame.BackgroundColor3 = CoresStatistic[i%2+1]
		Frame.Posicao.Text = tostring(i)
	end
end
MDF_ItemStatistic.LegendaArmadura[OrganizacaoDaInformacaoArmadura].TextColor3 = CorSelecionado
for i,k:TextButton in ipairs(MDF_ItemStatistic.LegendaArmadura:GetChildren()) do
	k.Activated:Connect(function()
		ClickSound1:Play()
		MDF_ItemStatistic.LegendaArmadura[OrganizacaoDaInformacaoArmadura].TextColor3 = CorNaoSelecionado
		OrganizacaoDaInformacaoArmadura = k.Name
		MDF_ItemStatistic.LegendaArmadura[OrganizacaoDaInformacaoArmadura].TextColor3 = CorSelecionado
		OrdenarItemStatisticArmadura()
	end)
end

local OrganizacaoDaInformacaoHabilidade = "1"
function OrdenarItemStatisticHabilidade()
	local Size = #ItemStatisticHabilidadeSendoMostrada
	for i=2,Size do
		local Save = ItemStatisticHabilidadeSendoMostrada[i]
		local j = i-1
		if OrganizacaoDaInformacaoHabilidade == "Nome" then
			while j>=1 and ItemStatisticHabilidadeSendoMostrada[j][OrganizacaoDaInformacaoHabilidade].Text < Save[OrganizacaoDaInformacaoHabilidade].Text do
				ItemStatisticHabilidadeSendoMostrada[j+1] = ItemStatisticHabilidadeSendoMostrada[j]
				j -= 1
			end
			ItemStatisticHabilidadeSendoMostrada[j+1] = Save
		else
			while j>=1 and tonumber(ItemStatisticHabilidadeSendoMostrada[j][OrganizacaoDaInformacaoHabilidade].Text) < tonumber(Save[OrganizacaoDaInformacaoHabilidade].Text) do
				ItemStatisticHabilidadeSendoMostrada[j+1] = ItemStatisticHabilidadeSendoMostrada[j]
				j -= 1
			end
			ItemStatisticHabilidadeSendoMostrada[j+1] = Save
		end

	end
	for i,Frame:Frame in ipairs(ItemStatisticHabilidadeSendoMostrada) do
		Frame.LayoutOrder = i
		Frame.BackgroundColor3 = CoresStatistic[i%2+1]
		Frame.Posicao.Text = tostring(i)
	end
end
MDF_ItemStatistic.LegendaHabilidade[OrganizacaoDaInformacaoHabilidade].TextColor3 = CorSelecionado
for i,k:TextButton in ipairs(MDF_ItemStatistic.LegendaHabilidade:GetChildren()) do
	k.Activated:Connect(function()
		ClickSound1:Play()
		MDF_ItemStatistic.LegendaHabilidade[OrganizacaoDaInformacaoHabilidade].TextColor3 = CorNaoSelecionado
		OrganizacaoDaInformacaoHabilidade = k.Name
		MDF_ItemStatistic.LegendaHabilidade[OrganizacaoDaInformacaoHabilidade].TextColor3 = CorSelecionado
		OrdenarItemStatisticHabilidade()
	end)
end

local BotaoDoItemStatisticApertado = MDF_ItemStatistic.BarraOpcao.Arma
MDF_ItemStatistic.BarraOpcao.Classe.Text = string.upper(ItemStatisticClasseMostrada)

MDF_StatisticBotao.Activated:Connect(function()
	ClickSound1:Play()
	MDF_ItemStatistic.Visible = false
	MDF_Statistic.Visible = true
	MDF_ItemStatisticBotao.BackgroundColor3 = Color3.fromRGB(36, 40, 47)
	MDF_ItemStatisticBotao.TextLabel.TextColor3 = Color3.new(1,1,1)
	MDF_StatisticBotao.BackgroundColor3 = Color3.new(1,1,1)
	MDF_StatisticBotao.TextLabel.TextColor3 = Color3.fromRGB(36, 40, 47)
end)

MDF_ItemStatisticBotao.Activated:Connect(function()
	ClickSound1:Play()
	MDF_Statistic.Visible = false
	MDF_ItemStatistic.Visible = true
	MDF_StatisticBotao.BackgroundColor3 = Color3.fromRGB(36, 40, 47)
	MDF_StatisticBotao.TextLabel.TextColor3 = Color3.new(1,1,1)
	MDF_ItemStatisticBotao.BackgroundColor3 = Color3.new(1,1,1)
	MDF_ItemStatisticBotao.TextLabel.TextColor3 = Color3.fromRGB(36, 40, 47)
end)

MDF_ItemStatistic.BarraOpcao.Arma.Activated:Connect(function()
	ClickSound1:Play()
	if BotaoDoItemStatisticApertado == MDF_ItemStatistic.BarraOpcao.Arma then return end
	BotaoDoItemStatisticApertado.BackgroundColor3 = Color3.fromRGB(36, 40, 47)
	BotaoDoItemStatisticApertado.TextColor3 = Color3.new(1,1,1)
	BotaoDoItemStatisticApertado = MDF_ItemStatistic.BarraOpcao.Arma
	BotaoDoItemStatisticApertado.BackgroundColor3 = Color3.new(1,1,1)
	BotaoDoItemStatisticApertado.TextColor3 = Color3.fromRGB(36, 40, 47)
	MDF_ItemStatistic.BarraOpcao.Classe.Visible = false
	MDF_ItemStatistic.BarraOpcao.SClasse.Visible = false
	MDF_ItemStatistic.Classes.Visible = false
	MDF_ItemStatistic.LegendaHabilidade.Visible = false
	MDF_ItemStatistic.LegendaArmadura.Visible = false
	MDF_ItemStatistic.LegendaArma.Visible = true
	MDF_ItemStatistic.ListaArmas.Visible = true
	MDF_ItemStatistic.ListaArmadura.Visible = false
	MDF_ItemStatistic.ListaHabilidade.Visible = false
end)

MDF_ItemStatistic.BarraOpcao.Habilidade.Activated:Connect(function()
	ClickSound1:Play()
	if BotaoDoItemStatisticApertado == MDF_ItemStatistic.BarraOpcao.Habilidade then return end
	BotaoDoItemStatisticApertado.BackgroundColor3 = Color3.fromRGB(36, 40, 47)
	BotaoDoItemStatisticApertado.TextColor3 = Color3.new(1,1,1)
	BotaoDoItemStatisticApertado = MDF_ItemStatistic.BarraOpcao.Habilidade
	BotaoDoItemStatisticApertado.BackgroundColor3 = Color3.new(1,1,1)
	BotaoDoItemStatisticApertado.TextColor3 = Color3.fromRGB(36, 40, 47)
	MDF_ItemStatistic.BarraOpcao.Classe.Visible = true
	MDF_ItemStatistic.BarraOpcao.SClasse.Visible = true
	MDF_ItemStatistic.LegendaHabilidade.Visible = true
	MDF_ItemStatistic.LegendaArmadura.Visible = false
	MDF_ItemStatistic.LegendaArma.Visible = false
	MDF_ItemStatistic.ListaArmas.Visible = false
	MDF_ItemStatistic.ListaArmadura.Visible = false
	MDF_ItemStatistic.ListaHabilidade.Visible = true
end)

MDF_ItemStatistic.BarraOpcao.Armadura.Activated:Connect(function()
	ClickSound1:Play()
	if BotaoDoItemStatisticApertado == MDF_ItemStatistic.BarraOpcao.Armadura then return end
	BotaoDoItemStatisticApertado.BackgroundColor3 = Color3.fromRGB(36, 40, 47)
	BotaoDoItemStatisticApertado.TextColor3 = Color3.new(1,1,1)
	BotaoDoItemStatisticApertado = MDF_ItemStatistic.BarraOpcao.Armadura
	BotaoDoItemStatisticApertado.BackgroundColor3 = Color3.new(1,1,1)
	BotaoDoItemStatisticApertado.TextColor3 = Color3.fromRGB(36, 40, 47)
	MDF_ItemStatistic.BarraOpcao.Classe.Visible = false
	MDF_ItemStatistic.BarraOpcao.SClasse.Visible = false
	MDF_ItemStatistic.Classes.Visible = false
	MDF_ItemStatistic.LegendaHabilidade.Visible = false
	MDF_ItemStatistic.LegendaArmadura.Visible = true
	MDF_ItemStatistic.LegendaArma.Visible = false
	MDF_ItemStatistic.ListaArmas.Visible = false
	MDF_ItemStatistic.ListaArmadura.Visible = true
	MDF_ItemStatistic.ListaHabilidade.Visible = false
end)

local ItemStatisticClassOption = false

MDF_ItemStatistic.BarraOpcao.Classe.Activated:Connect(function()
	ClickSound1:Play()
	MDF_ItemStatistic.Classes.Visible = not MDF_ItemStatistic.Classes.Visible
	ItemStatisticClassOption = not ItemStatisticClassOption
end)

for i,k:TextButton in ipairs(MDF_ItemStatistic.Classes:GetChildren()) do
	if k.Name == "Jump" then continue end
	k.Activated:Connect(function()
		ClickSound1:Play()
		ItemStatisticClasseMostrada = k.Name
		MDF_ItemStatistic.BarraOpcao.Classe.Text = string.upper(ItemStatisticClasseMostrada)
		MDF_ItemStatistic.Classes.Visible = false
		ItemStatisticClassOption = false
		ListarStatisticHabilidade()
		OrdenarItemStatisticHabilidade()
	end)
end

local Tabela = MDF_Statistic.ListaClasses:GetChildren()
table.remove(Tabela,table.find(Tabela,MDF_Statistic.ListaClasses:FindFirstChildOfClass("UIGridLayout")))
local OrdenacaoAtual = "Timer"
local function OrdenarStatistic()
	local Size = #Tabela
	for i=2,Size do
		local Save = Tabela[i]
		local j = i-1
		if OrdenacaoAtual == "Timer" then
			while j>=1 and Tabela[j].Timer.Value < Save.Timer.Value do
				Tabela[j+1] = Tabela[j]
				j -= 1
			end
			Tabela[j+1] = Save
		else
			while j>=1 and tonumber(Tabela[j][OrdenacaoAtual].Text) < tonumber(Save[OrdenacaoAtual].Text) do
				Tabela[j+1] = Tabela[j]
				j -= 1
			end
			Tabela[j+1] = Save
		end

	end
	for i,Frame:Frame in ipairs(Tabela) do
		Frame.LayoutOrder = i
		Frame.BackgroundColor3 = CoresStatistic[i%2+1]
		Frame.Posicao.Text = tostring(i)
	end
end
local function UpdateStatistic()
	local ASerMostrado = if MostrarModificado then "ClassStatisticModificada" else "ClassStatistic"

	for i,NomeDaClasse in ipairs(Configuracoes.Classes) do
		for NomeDoStats,Valor in pairs(PlayerStats[ASerMostrado][NomeDaClasse]) do
			if MDF_Statistic.ListaClasses[NomeDaClasse]:FindFirstChild(NomeDoStats) then
				MDF_Statistic.ListaClasses[NomeDaClasse][NomeDoStats].Text = tostring(math.floor(Valor))
			end
		end
		MDF_Statistic.ListaClasses[NomeDaClasse].Time.Text = ConverterSegundosPTempo(PlayerStats.ClassTime[NomeDaClasse])
		MDF_Statistic.ListaClasses[NomeDaClasse].Timer.Value = PlayerStats.ClassTime[NomeDaClasse]
		MDF_Statistic.ListaClasses[NomeDaClasse].XP.Text = tonumber(math.floor(PlayerStats.ClassXP[NomeDaClasse]))
		MDF_Statistic.ListaClasses[NomeDaClasse].Level.Text = tonumber(PlayerStats.ClassesLvl[NomeDaClasse])
	end
end

MDF_Statistic.BarraLegenda[OrdenacaoAtual].ImageColor3 = CorSelecionado
for i,Button:TextButton in ipairs(MDF_Statistic.BarraLegenda:GetChildren()) do 
	if Button.Name == "Classe" then continue end 
	Button.Activated:Connect(function()
		ClickSound1:Play()
		if MDF_Statistic.BarraLegenda[OrdenacaoAtual].ClassName == "ImageButton" then
			MDF_Statistic.BarraLegenda[OrdenacaoAtual].ImageColor3 = CorNaoSelecionado
		else
			MDF_Statistic.BarraLegenda[OrdenacaoAtual].TextColor3 = CorNaoSelecionado
		end
		OrdenacaoAtual = Button.Name 
		if Button.ClassName == "ImageButton" then
			MDF_Statistic.BarraLegenda[OrdenacaoAtual].ImageColor3 = CorSelecionado
		else
			MDF_Statistic.BarraLegenda[OrdenacaoAtual].TextColor3 = CorSelecionado
		end
		OrdenarStatistic() 
	end) 
end

function UpdateItemStatistic()
	local ASerMostrado = if MostrarModificado then "ItemStatisticModificada" else "ItemStatistic"
	for i,Frame:Frame in ipairs(MDF_ItemStatistic.ListaArmas:GetChildren()) do
		if Frame.Name == "Jump" then continue end
		Frame.Damage.Text = tostring(math.floor(PlayerStats[ASerMostrado][Frame.Name].Damage))
		Frame.Hits.Text = tostring(math.floor(PlayerStats[ASerMostrado][Frame.Name].Hits))
		Frame.Kills.Text = tostring(math.floor(PlayerStats[ASerMostrado][Frame.Name].Kills))
		Frame.Shots.Text = tostring(math.floor(PlayerStats[ASerMostrado][Frame.Name].Shots))
	end
	for i,Frame:Frame in ipairs(MDF_ItemStatistic.ListaArmadura:GetChildren()) do
		if Frame.Name == "Jump" then continue end
		Frame.DamageTaken.Text = tostring(math.floor(PlayerStats[ASerMostrado][Frame.Name].DamageTaken))
		Frame.HitsTake.Text = tostring(math.floor(PlayerStats[ASerMostrado][Frame.Name].HitsTake))
	end
	for i,Frame:Frame in ipairs(MDF_ItemStatistic.ListaHabilidade:GetChildren()) do
		if Frame.Name == "Jump" then continue end
		for i,NomeDoAtributo in ipairs(ListaDosAtributosDaHabilidade) do
			Frame[tostring(i)].Text = tostring(math.floor(PlayerStats[ASerMostrado][Frame.Name][NomeDoAtributo]))
		end
	end
end

MDF_Profile.Modificado.TextButton.Activated:Connect(function()
	MostrarModificado = not MostrarModificado
	MDF_Profile.Modificado.TextButton.Text = if MostrarModificado then "X" else ""
	UpdateStatistic()
	OrdenarStatistic()
	UpdateItemStatistic()
	OrdenarItemStatisticArma()
	OrdenarItemStatisticHabilidade()
	OrdenarItemStatisticArmadura()
end)

UserInputService.InputBegan:Connect(function(Input,InputFalso)
	if InputFalso or not ItemStatisticClassOption then return end
	if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
		MDF_ItemStatistic.Classes.Visible = false
		ItemStatisticClassOption = false
	end
end)

local function OrganizarMenu()
	SelecionandoClasse = false
	Meio.Position = UDim2.fromScale(0,0)
	Inferior.Position = UDim2.fromScale(0,0)
	MDF_Profile.Visible = false
	MDF_Settings.Visible = false
	MDF_Info.Visible = false
	MDF_Boosters.Visible = false

	MeioSeletor.Visible = true

	EQP_BotaoMudarArma.Parent.Visible = false
	EQP_ItemList.Visible = false
	EQP_InformacaoDosItens.Visible = false
	EQP_BotaoVoltarParaClasses.Visible = false

	SLC_ClassEquipment.Visible = true
	SLC_ClassInfo.Visible = true
	SLC_Classes.Visible = true
	SLC_ChangeEquipamento.Visible = true
end

local PosicaoCamera = Vector3.new(-562, 10, 413)
local function AjustarCameraCena()
	local Posicao = PosicaoCamera
	local Look = workspace.Thumb[PlayerStats.Class].Position --Vector3.new(-702.264, 20, 401.43)
	Camera.CameraType = Enum.CameraType.Scriptable
	Camera.CFrame = CFrame.new(Posicao,Look)
end

local PosicaoDaPose = Vector3.new(-715.076, 21.85, 402.932)
local PastaDasPoses = workspace:WaitForChild("Poses")
local PoseAtual = PlayerStats.Class
local Posicoes = {
	Paladin = Vector3.new(-716.476, 22.65, 403.232),
	Archer = Vector3.new(-715.776, 22.25, 403.132),
	Wizard = Vector3.new(-715.076, 22.45, 403.032),
	Priest = Vector3.new(-715.076, 22.25, 402.832),
	Rogue = Vector3.new(-715.076, 22.25, 402.932),
	Warrior = Vector3.new(-715.776, 22.35, 402.932),
	Knight = Vector3.new(-715.876, 22.15, 402.532),
	Necromancer = Vector3.new(-714.776, 21.85, 402.932),
	Assassin = Vector3.new(-715.076, 22.15, 402.932),
	Huntress = Vector3.new(-715.776, 22.15, 403.132),
	Mystic = Vector3.new(-714.276, 21.95, 402.832),
	Ninja = Vector3.new(-715.976, 22.35, 403.132),
	Sorcerer = Vector3.new(-715.176, 22.25, 402.832),
	Samurai = Vector3.new(-715.576, 22.15, 403.032),
	Bard = Vector3.new(-715.576, 22.15, 402.932),
	Kensei = Vector3.new(-715.676, 22.25, 403.032),
}

local Thumb = workspace:WaitForChild("Thumb")
function MostrarPoses(bool:boolean)
	for i,k:Part in ipairs(Thumb:GetChildren()) do
		k.Transparency = bool and 0 or 1
	end
end

local TInfo = TweenInfo.new(.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
MudarPoseCentral = function(Classe:string)
	local CFrameAtual = Camera.CFrame
	local Posicao = PosicaoCamera
	local Look = Thumb[Classe].Position --Vector3.new(-702.264, 20, 401.43)
	Camera.CameraType = Enum.CameraType.Scriptable
	local NovoCFrame = CFrame.new(Posicao,Look)
	TweenService:Create(Camera,TInfo,{CFrame = NovoCFrame}):Play()
	--[[PastaDasPoses[PoseAtual].Position = Vector3.new(0,-200,0)
	PoseAtual = Classe
	PastaDasPoses[PoseAtual].CFrame = CFrame.new(Posicoes[PoseAtual],Vector3.new(PosicaoCamera.X,Posicoes[PoseAtual].Y,PosicaoCamera.Z))]]
end

RetornarPoseCentral = function()
	PastaDasPoses[PoseAtual].Position = Vector3.new(0,-200,0)
end


local TempoPraFinalizar = 0
local TempoInicial = 0
local TempoTotal = 1
local function CarregarBarraPlay(Tempo:number)
	TempoPraFinalizar = os.clock()+Tempo
	TempoInicial = os.clock()
	TempoTotal = Tempo
	if not CarregandoBarra then
		CarregandoBarra = true
		task.spawn(function()
			while os.clock() < TempoPraFinalizar do
				SPR_Play.UIGradient.Offset = Vector2.new((os.clock()-TempoInicial)/TempoTotal-1,0)
				task.wait()
			end
			SPR_Play.UIGradient.Offset = Vector2.new(1,0)
			CarregandoBarra = false
		end)
	end
end

MenuEvent.OnClientEvent:Connect(function()
	game.Lighting.DepthOfField.Enabled = true
	UserInputService.MouseIconEnabled = true
	AjustarCameraCena()
	ClasseSelecionada = PlayerStats.Class
	UpdateStatistic()
	OrdenarStatistic()
	UpdateItemStatistic()
	OrdenarItemStatisticArma()
	OrdenarItemStatisticHabilidade()
	OrdenarItemStatisticArmadura()
	UpdateBarraXP(ClasseSelecionada)
	OrganizarMenu()
	MostrarPoses(true)
	CarregarBarraPlay(Configuracoes.TempoProximaPartida)
	LocalPlayer.PlayerGui.DeadScreen.Enabled = false
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	Menu.Enabled = true
	HUD.Enabled = false
end)

for i,F:Frame in ipairs(SLC_ClassInfo:WaitForChild("AEH"):GetChildren()) do
	if F.Name == "Modelo" or F.Name == "AreaEffect" then F:Destroy() end
end

ReabrirMenu.Event:Connect(function(TempoProximoRespawn)
	game.Lighting.DepthOfField.Enabled = true
	UserInputService.MouseIconEnabled = true
	AjustarCameraCena()
	ClasseSelecionada = PlayerStats.Class
	UpdateStatistic()
	OrdenarStatistic()
	UpdateItemStatistic()
	OrdenarItemStatisticArma()
	OrdenarItemStatisticHabilidade()
	OrdenarItemStatisticArmadura()
	UpdateBarraXP(ClasseSelecionada)
	OrganizarMenu()
	MostrarPoses(true)
	CarregarBarraPlay(TempoProximoRespawn-os.clock())
	Menu.Enabled = true
	HUD.Enabled = false
end)

SLC_NomeDaClasse.Texto.Text = PlayerStats.Class
AjustarCameraCena()
UpdateBarraXP(PlayerStats.Class)
UpdateBarraXPSeletor(PlayerStats.Class)
MudarNomeEIconeSuperiorClasse(PlayerStats.Class)
UpdateClassUnlock(false,PlayerStats.Class)
UpdateStatistic()
OrdenarStatistic()
MudarPoseCentral(PoseAtual)
AtualizarItens("Arma")
AtualizarInformacaoItem(WeaponInfo[PlayerStats.Equipamentos[ClasseSelecionada].Arma],"Arma")
--UpdateClassEquipamentoShow(PlayerStats.Class)
UpdateDescDaHabilidade(PlayerStats.Class)
ListarStatisticArma()
ListarStatisticArmadura()
ListarStatisticHabilidade()
OrdenarItemStatisticArmadura()
OrdenarItemStatisticArma()
OrdenarItemStatisticHabilidade()
MDF_ItemStatistic.ListaHabilidade.Visible = false
MDF_ItemStatistic.ListaArmadura.Visible = false
MDF_ItemStatistic.ListaArmas.Visible = true
MDF_ItemStatistic.LegendaArma.Visible = true
MDF_ItemStatistic.LegendaHabilidade.Visible = false
MDF_ItemStatistic.LegendaArmadura.Visible = false
game.Lighting.DepthOfField.Enabled = true

SPR_Gold.Valor.Text = tostring(PlayerStats.Gold)

TrocarDeTime(LocalPlayer.Team.Name == "Orange" and 1 or 2)

OrganizarMenu()
MostrarPoses(true)

--######### BOTAO DO PLAY #######################
SPR_Play.PlayBotao.Activated:Connect(function()
	if CarregandoBarra then ErroSound:Play() return end
	local Sucesso = SolicitarSpawn:InvokeServer()
	if Sucesso then
		game.Lighting.DepthOfField.Enabled = false
		RetornarPoseCentral()
		Menu.Enabled = false
		HUD.Enabled = true
		MostrarPoses(false)
		ClickSound3:Play()
	end
end)

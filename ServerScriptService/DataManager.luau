local Data = {}
--#####################################################################################################################################
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerService = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
--#####################################################################################################################################
local PATERN = require(ServerScriptService:WaitForChild("Patern"))
local PLAYERINFO = require(ServerScriptService:WaitForChild("_G.Players"))
local Configuracao = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
--#####################################################################################################################################
local PlayerDataStore = DataStoreService:GetDataStore("PlayerData")
--#####################################################################################################################################


local FuncoesDeVersoes = {}

local function AtualizarVersao(Data,Versao)
	local VersaoDaData = Data.Version
	for i = VersaoDaData, Versao do
		if FuncoesDeVersoes[i] then
			FuncoesDeVersoes[i](Data)
		end
	end
end

local function waitForRequestBudget(requestedType:Enum.DataStoreRequestType)
	local currentBudget = DataStoreService:GetRequestBudgetForRequestType(requestedType)
	while currentBudget < 1 do
		currentBudget = DataStoreService:GetRequestBudgetForRequestType(requestedType)
		task.wait(5)
	end
end

function compararTabelas(Data,Comparador)
	for Nome,Conteudo in pairs(Comparador) do
		if Data[Nome] == nil then
			Data[Nome] = Conteudo
		else
			if type(Conteudo) == "table" then
				compararTabelas(Data[Nome],Conteudo)
			end
		end
	end
end

function Data.loadData(Player:Player)
	local Sucesso, Data
	repeat
		waitForRequestBudget(Enum.DataStoreRequestType.GetAsync)
		Sucesso, Data = pcall(function()
			return PlayerDataStore:GetAsync(Player.UserId)
		end)
	until Sucesso or not PlayerService:FindFirstChild(Player.Name)
	local Comparador = PATERN.Copia()
	if not Data then
		Data = {}
	end
	compararTabelas(Data,Comparador)
	--AtualizarVersao(Data,Comparador.Version)
	PLAYERINFO.NewPlayer(Player,Data)
end

local DataImportante = {
	ClassStatistic = true,
	ClassStatisticModificada = true,
	ClassXP = true,
	ClassTime = true,
	ItemStatistic = true,
	ItemStatisticModificada = true,
	Version = true,
	Config = true,
	Class = true,
	HistoricoDeCompras = true,
	Boosters = true,
	Equipamento = true,
	PurchasedClasses = true,
	FirstLogin = true,
	Gold = true,
	ClassLevel = true,
}

function Data.saveData(Player:Player)
	local Info = PLAYERINFO.GetPlayer(Player)
	local Data = table.clone(Info)
	for NomeInfo,_ in pairs(Data) do
		if not DataImportante[NomeInfo] then
			Data[NomeInfo] = nil
		end
	end
	Data.LastSave = os.time()
	local Sucesso, mensagem
	repeat
		waitForRequestBudget(Enum.DataStoreRequestType.UpdateAsync)
		Sucesso, mensagem = pcall(function()
			return PlayerDataStore:UpdateAsync(Player.UserId,function()
				return Data
			end)
		end)
	until Sucesso
end

game:BindToClose(function()
	if game["Run Service"]:IsStudio() then
		task.wait(1)
	else
		local Finished = Instance.new("BindableEvent")
		local ListaPlayers = PlayerService:GetPlayers()
		local NumeroPlayers = #ListaPlayers

		for _,Player in ipairs(ListaPlayers) do
			coroutine.wrap(function()
				Data.saveData(Player)
				NumeroPlayers -= 1
				if NumeroPlayers == 0 then
					Finished:Fire()
				end
			end)()
		end

		Finished.Event:Wait()
	end
end)

return Data

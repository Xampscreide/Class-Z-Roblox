local Sistema = {}

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local PlayerService = game:GetService("Players")

local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))
local BoosterManager = require(ServerScriptService:WaitForChild("BoosterManager"))
local InfoPlayer = require(ServerScriptService:WaitForChild("InfoPlayers"))

local PlayerService = game:GetService("Players")
local FuncoesDeProdutos = {}

--XPBOOST I
FuncoesDeProdutos[1712039356] = function(Recibo,Player)
	BoosterManager.AdicionarXPBooster(Player,.8,1)
	PlayerInfo.AdicionarHistoricoDeCompra(Player,Recibo)
end

--XPBOOST II
FuncoesDeProdutos[1712276318] = function(Recibo,Player)
	BoosterManager.AdicionarXPBooster(Player,.8,2)
	PlayerInfo.AdicionarHistoricoDeCompra(Player,Recibo)
end

--XPBOOST III
FuncoesDeProdutos[1712276561] = function(Recibo,Player)
	BoosterManager.AdicionarXPBooster(Player,.8,3)
	PlayerInfo.AdicionarHistoricoDeCompra(Player,Recibo)
end

--ITEMBOOST I
FuncoesDeProdutos[1712279351] = function(Recibo,Player)
	BoosterManager.AdicionarItemBooster(Player,.8,1)
	PlayerInfo.AdicionarHistoricoDeCompra(Player,Recibo)
end

--ITEMBOOST II
FuncoesDeProdutos[1712279564] = function(Recibo,Player)
	BoosterManager.AdicionarItemBooster(Player,.8,2)
	PlayerInfo.AdicionarHistoricoDeCompra(Player,Recibo)
end

--ITEMBOOST III
FuncoesDeProdutos[1712279703] = function(Recibo,Player)
	BoosterManager.AdicionarItemBooster(Player,.8,3)
	PlayerInfo.AdicionarHistoricoDeCompra(Player,Recibo)
end

--CLASSBOOST I
FuncoesDeProdutos[1712278155] = function(Recibo,Player)
	BoosterManager.AdicionarClassBooster(Player,.8,1)
	PlayerInfo.AdicionarHistoricoDeCompra(Player,Recibo)
end

--CLASSBOOST II
FuncoesDeProdutos[1712278603] = function(Recibo,Player)
	BoosterManager.AdicionarClassBooster(Player,.8,2)
	PlayerInfo.AdicionarHistoricoDeCompra(Player,Recibo)
end

--CLASSBOOST III
FuncoesDeProdutos[1712278928] = function(Recibo,Player)
	BoosterManager.AdicionarClassBooster(Player,.8,3)
	PlayerInfo.AdicionarHistoricoDeCompra(Player,Recibo)
end

local function ProcessReceipt(Recibo)
	local PlayerUserID = Recibo.PlayerId
	local ProductID = Recibo.ProductId
	local Player = PlayerService:GetPlayerByUserId(PlayerUserID)
	if Player then
		local Funcao = FuncoesDeProdutos[ProductID]
		local Sucesso, Resultado = pcall(Funcao,Recibo,Player)
		if Sucesso then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to process receipt:",Recibo,Resultado)
		end
	end
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

local ClassesParaID = {
	Assassin = 675916638,
	Huntress = 676244103,
	Bard = 675979624,
	Kensei = 675901728,
	Knight = 676292087,
	Mystic = 676219102,
	Necromancer = 675963602,
	Ninja = 676099358,
	Paladin = 675914686,
	Samurai = 676185165,
	Sorcerer = 676472667,
}

local function GamePassPurchased(Player:Player, PassID, Sucesso)
	if not Sucesso then return end
	local ClasseComprada
	for NomeDaClasse,ID in pairs(ClassesParaID) do
		if ID == PassID then
			ClasseComprada = NomeDaClasse
			break
		end
	end
	PlayerInfo.AdicionarClasseComprada(Player,ClasseComprada)
	InfoPlayer.UpdateClasses(Player,ClasseComprada)
end

function Sistema.ChecarPasses(Player:Player)
	for NomeDaClasse, PassID in pairs(ClassesParaID) do
		local TemPasse = false
		local Sucesso, Mensagem = pcall(function()
			TemPasse = MarketplaceService:UserOwnsGamePassAsync(Player.UserId,PassID)
		end)
		if not Sucesso then continue end
		if TemPasse then
			PlayerInfo.AdicionarClasseComprada(Player,NomeDaClasse)
		end
	end
end

MarketplaceService.ProcessReceipt = ProcessReceipt
MarketplaceService.PromptGamePassPurchaseFinished:Connect(GamePassPurchased)

return Sistema

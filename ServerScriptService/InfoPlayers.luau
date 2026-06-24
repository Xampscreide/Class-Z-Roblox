local Info = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local XP = require(ReplicatedStorage:WaitForChild("Modulos"):WaitForChild("XpCalculador"))
local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local PlayerInfo = require(ServerScriptService:WaitForChild("_G.Players"))
local SistemaMensagem = require(ServerScriptService:WaitForChild("SistemaMensagem"))
local PaternDeEquipamento = require(ServerScriptService:WaitForChild("Patern"):WaitForChild("PaternDeEquipamento")).Clone()
local Team = require(ServerScriptService:WaitForChild("TeamCoisas"))
local Health = require(ServerScriptService:WaitForChild("Health"))
local Emblemas = require(ServerScriptService:WaitForChild("Emblemas"))
local Amigos = require(ServerScriptService:WaitForChild("Amigos"))
local TopPlayers = require(ServerScriptService:WaitForChild("TopPlayers"))

local Armas = Configuracoes.Armas
local Armaduras = Configuracoes.Armaduras
local Habilidades = Configuracoes.Habilidades

local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local CriarInformacoes = EventosRemotos:WaitForChild("CriarInformacoes")
local AtualizarInformacoes = EventosRemotos:WaitForChild("AtualizarInformacoes")
local MudarEquipamento = EventosRemotos:WaitForChild("MudarEquipamento")
local MudarSettings = EventosRemotos:WaitForChild("MudarSettings")
local MudarClasse = EventosRemotos:WaitForChild("MudarClasse")
local UpdateBooster = EventosRemotos:WaitForChild("UpdateBooster")
local UpdateClasses = EventosRemotos:WaitForChild("UpdateClasses")

local UnlockLevel = Configuracoes.UnlockLevel
local Itens = {Armas,Armaduras,Habilidades}

function VerificarItensEquipados(ItensDasClasses,ItensLiberados)
	for NomeDaClasse,ItensEquipados in pairs(ItensDasClasses) do
		if not ItensLiberados[ItensEquipados.Arma] then
			ItensEquipados.Arma = PaternDeEquipamento[NomeDaClasse].Arma
		end
		if not ItensLiberados[ItensEquipados.Habilidade] then
			ItensEquipados.Habilidade = PaternDeEquipamento[NomeDaClasse].Habilidade
		end
		if not ItensLiberados[ItensEquipados.Armadura] then
			ItensEquipados.Armadura = PaternDeEquipamento[NomeDaClasse].Armadura
		end
	end
end

function DarBonificacaoLevelClasse(Player:Player,Leveis)
	local PlayerInformation = PlayerInfo.GetPlayer(Player)
	local LevelAntigoDasClasses = PlayerInformation.ClassLevel
	for NomeDaClasse, Level in pairs(LevelAntigoDasClasses) do
		if Leveis[NomeDaClasse] > Level then
			for i=Level,Leveis[NomeDaClasse]-1 do
				PlayerInformation.Gold += i
			end
		end
	end
end

function LevelDasClasses(Player:Player)
	local ListaLevel = {}
	local PlayerInformation = PlayerInfo.GetPlayer(Player)
	local PlayerXP = PlayerInformation.ClassXP
	for _,NomeDaClasse in ipairs(Configuracoes.Classes) do
		ListaLevel[NomeDaClasse] = XP.takeLvl(PlayerXP[NomeDaClasse])
	end
	return ListaLevel
end

function ClassesLiberadas(Player:Player,Update:boolean?)
	local PlayerInformation = PlayerInfo.GetPlayer(Player)
	local ClassesLiberadas = {}
	local ClassesJaLiberadas = PlayerInformation.UnlockedClasses
	local PlayerXP = PlayerInformation.ClassXP
	for _,NomeDaClasse in ipairs(Configuracoes.Classes) do
		if Update and ClassesJaLiberadas[NomeDaClasse] then continue end
		if not Configuracoes.RequesitosClasse[NomeDaClasse] then ClassesLiberadas[NomeDaClasse] = true continue end
		local Contador = 0
		for _,RequesitoDaClasse in ipairs(Configuracoes.RequesitosClasse[NomeDaClasse]) do
			if XP.takeLvl(PlayerXP[RequesitoDaClasse]) >= UnlockLevel then Contador += 1 else break end
		end
		if Contador == #Configuracoes.RequesitosClasse[NomeDaClasse] then ClassesLiberadas[NomeDaClasse] = true end
	end
	if not Update then
		local ClassesCompradas = PlayerInformation.PurchasedClasses
		for NomeClasseComprada,_ in pairs(ClassesCompradas) do
			ClassesLiberadas[NomeClasseComprada] = true
		end
	end
	return ClassesLiberadas
end

function ItensDesbloqueados(Player:Player,Update:boolean?)
	local PlayerInformation = PlayerInfo.GetPlayer(Player)
	local PlayerXP = PlayerInformation.ClassXP
	local ClassStatistics = PlayerInformation.ClassStatistic
	local ItemStatistics = PlayerInformation.ItemStatistic
	local ItensLiberados = PlayerInformation.UnlockedItens
	
	local Liberados = {}
	for _,Tipo in ipairs(Itens) do
		for NomeDoItem, Descricao in pairs(Tipo) do
			if Update and ItensLiberados[NomeDoItem] then continue end
			if not Descricao.Unlock then Liberados[NomeDoItem] = true continue end
			if Descricao.Unlock.AnyLevel then
				for i,NomeDaClasse in ipairs(Descricao.Unlock.AnyLevel[1]) do
					if XP.takeLvl(PlayerXP[NomeDaClasse]) >= Descricao.Unlock.AnyLevel[2] then Liberados[NomeDoItem] = true break end
				end
			end
			if Descricao.Unlock.Level then
				local Contador = 0
				for i,NomeDaClasse in ipairs(Descricao.Unlock.Level[1]) do
					if XP.takeLvl(PlayerXP[NomeDaClasse]) >= Descricao.Unlock.Level[2] then Contador += 1 else break end
				end
				if Contador == #Descricao.Unlock.Level[1] then Liberados[NomeDoItem] = true end
			end
			if Descricao.Unlock.ClassStatistic then
				local Contador = 0
				for _,Requesito in ipairs(Descricao.Unlock.ClassStatistic) do
					if ClassStatistics[Requesito[1]][Requesito[2]] >= Requesito[3] then Contador += 1 else break end
				end
				if Contador == #Descricao.Unlock.ClassStatistic then Liberados[NomeDoItem] = true end
			end
			if Descricao.Unlock.ItemStatistic then
				local Contador = 0
				for _,Requesito in ipairs(Descricao.Unlock.ItemStatistic) do
					if ItemStatistics[Requesito[1]][Requesito[2]] >= Requesito[3] then Contador += 1 else break end
				end
				if Contador == #Descricao.Unlock.ItemStatistic then Liberados[NomeDoItem] = true end
			end
		end
	end
	return Liberados
end

function Info.EnviarInformacoes(Player:Player)
	local PlayerInformation = PlayerInfo.GetPlayer(Player)
	local ExperienciaClasses = PlayerInformation.ClassXP
	local ClassStatistic = PlayerInformation.ClassStatistic
	local ClassStatisticModificada = PlayerInformation.ClassStatisticModificada
	local Config = PlayerInformation.Config
	local ClasseAtual = PlayerInformation.Class
	local TempoDeClasse = PlayerInformation.ClassTime
	local Equipamentos = PlayerInformation.Equipamento
	local EstatisticaItem = PlayerInformation.ItemStatistic
	local EstatisticaItemModificada = PlayerInformation.ItemStatisticModificada
	local ClassLevel = LevelDasClasses(Player)
	DarBonificacaoLevelClasse(Player,ClassLevel)
	PlayerInfo.SetClassLevel(Player,ClassLevel)
	local Amigo, UnlockedItens = Amigos.VerificarPrivilegios(Player)
	if not Amigo then
		UnlockedItens = ItensDesbloqueados(Player,false)
		PlayerInfo.SetItensLiberados(Player,UnlockedItens)
	end
	local Booster = PlayerInformation.Booster
	local Boosters = PlayerInformation.Boosters
	VerificarItensEquipados(Equipamentos,UnlockedItens)
	Emblemas.ChecarEmblemas(Player,PlayerInformation)
	CriarInformacoes:FireClient(Player,ExperienciaClasses,ClassStatistic,ClassStatisticModificada,Config,ClasseAtual,TempoDeClasse,Equipamentos,UnlockedItens,EstatisticaItem,EstatisticaItemModificada,Booster,Boosters,ClassLevel,PlayerInformation.Gold,TopPlayers.AtualTop)
end

function Info.AtualizarInformacoes(Player:Player)
	local PlayerInformation = PlayerInfo.GetPlayer(Player)
	local Classe = PlayerInformation.Class
	local ClassStatistic = PlayerInformation.ClassStatistic[Classe]
	local ClassStatisticModificada = PlayerInformation.ClassStatisticModificada[Classe]
	local EstatisticaItem = PlayerInformation.ItemStatistic
	local EstatisticaItemModificada = PlayerInformation.ItemStatisticModificada
	local TempoDeClasse = PlayerInformation.ClassTime[Classe]
	local ExperienciaClasses = PlayerInformation.ClassXP[Classe]
	local NumeroClasse = table.find(Configuracoes.Classes,Classe)
	local ItensDesbloqueados = ItensDesbloqueados(Player,true)
	local Booster = PlayerInformation.Booster
	local Boosters = PlayerInformation.Boosters
	local ClassLevel = LevelDasClasses(Player)
	DarBonificacaoLevelClasse(Player,ClassLevel)
	PlayerInfo.SetClassLevel(Player,ClassLevel)
	for NovoItemLiberado:string,_ in pairs(ItensDesbloqueados) do
		PlayerInformation.UnlockedItens[NovoItemLiberado] = true
		SistemaMensagem.AdicionarItemLiberado(Player,NovoItemLiberado)
	end
	local StringInfo = string.pack("I1",NumeroClasse)
	AtualizarInformacoes:FireClient(Player,StringInfo,ClassStatistic,ClassStatisticModificada,TempoDeClasse,ExperienciaClasses,ItensDesbloqueados,EstatisticaItem,EstatisticaItemModificada,Booster,Boosters,ClassLevel,PlayerInformation.Gold)
end

function Info.AtualizarBoosters(Player:Player)
	local PlayerInformation = PlayerInfo.GetPlayer(Player)
	local Booster = PlayerInformation.Booster
	local Boosters = PlayerInformation.Boosters
	UpdateBooster:FireClient(Player,Booster,Boosters)
end

function Info.UpdateClasses(Player:Player,Classe:string)
	UpdateClasses:FireClient(Player,Classe)
end

local NumeroParaTipo = {"Arma","Habilidade","Armadura"}
MudarEquipamento.OnServerEvent:Connect(function(Player:Player,StringInformacao:string)
	if Health.GetPlayerHealth(Player) then return end
	local PlayerInformation = PlayerInfo.GetPlayer(Player)
	local Item,Tipo,Classe = string.unpack("zI1z",StringInformacao)
	if not PlayerInformation.UnlockedItens[Item] then return end
	if not table.find(Configuracoes.Classes,Classe) then return end
	if not NumeroParaTipo[Tipo] then return end
	PlayerInformation.Equipamento[Classe][NumeroParaTipo[Tipo]] = Item
end)

local MudarConfigTeam = {RenderFriend = 1,RenderEnemy = 1,UnhittableShot = 1}

MudarSettings.OnServerEvent:Connect(function(Player:Player,Nome:string,Valor)
	local PlayerInformation = PlayerInfo.GetPlayer(Player)
	if not (type(Valor) == "number" or type(Valor) == "boolean" or type(Valor) == "string") then return end
	if PlayerInformation.Config[Nome] == nil then return end
	PlayerInformation.Config[Nome] = Valor
	if MudarConfigTeam[Nome] then Team.MudarConfiguracoesParaPlayer(Player) end
end)

MudarClasse.OnServerEvent:Connect(function(Player:Player,Classe:string)
	if Health.GetPlayerHealth(Player) then return end
	PlayerInfo.SetClass(Player,Classe)
end)

return Info

local InformarProjetilEHit = {}

local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local TeamService = game:GetService("Teams")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local Normal = EventosRemotos:WaitForChild("NormalProjetil")
local Poison = EventosRemotos:WaitForChild("PoisonBomb")
local Trap = EventosRemotos:WaitForChild("Trap")
local TrapProprio = EventosRemotos:WaitForChild("TrapProprio")
local PausarBezier = EventosRemotos:WaitForChild("PausarBezier")
local Staff = EventosRemotos:WaitForChild("Staff")
local InformarHit = EventosRemotos:WaitForChild("InformarHit")
local TEAMCOISAS = require(ServerScriptService:WaitForChild("TeamCoisas"))

local FilaNewNormal = {}
local FilaNewPoison = {}
local FilaNewTrap = {}
local FilaNewStaff = {}

local FilaHitNormal = {}
local FilaHitTrap = {}

local PosicaoPadrao = Vector3.new(-1004,3,-23)
local DeltaX = 843
local DeltaZ = 897
local function SerializarCFrame(Cframe:CFrame)
	local Posicao = Cframe.Position
	local _,RotacaoY,_ = Cframe:ToOrientation()
	
	RotacaoY = math.deg(RotacaoY)
	RotacaoY = if RotacaoY < 0 then 360+RotacaoY else RotacaoY
	
	local PosicaoRelativa = Posicao-PosicaoPadrao
	local PosicaoX = math.round(PosicaoRelativa.X/DeltaX*(bit32.lshift(1,13)-1))
	local PosicaoZ = math.round(PosicaoRelativa.Z/DeltaZ*(bit32.lshift(1,13)-1))
	local PosicaoY = math.floor(PosicaoRelativa.Y)
	RotacaoY = math.round(RotacaoY/360*(bit32.lshift(1,11)-1))
	local Soma1 = bit32.lshift(PosicaoX,19)+bit32.lshift(PosicaoY,16)+bit32.lshift(PosicaoZ,3)+bit32.rshift(RotacaoY,8)
	local Soma2 = bit32.band(RotacaoY,255)
	
	return string.pack("I4I1",Soma1,Soma2)
end

function InformarProjetilEHit.SendHitNormal(PlayerAutor:Player,Identificador:number)
	local Tabelas = TEAMCOISAS.TabelasDeSend(PlayerAutor)
	for i,Tabela in ipairs(Tabelas) do
		for _,p in ipairs(Tabela) do
			if p == PlayerAutor then continue end
			FilaHitNormal[p] = FilaHitNormal[p] or {string.pack("I1",1)}
			table.insert(FilaHitNormal[p],string.pack("I2",Identificador))
		end
	end
end

function InformarProjetilEHit.SendNewNormal(PlayerAutor:Player,Identificador:number,Posicao:Vector3,Direcao:Vector3,DistanciaMaxima:number)
	local Team = PlayerAutor.Team
	local Tabelas = TEAMCOISAS.TabelasDeSend(PlayerAutor,Posicao,Direcao,DistanciaMaxima)
	
	local Cframe = SerializarCFrame(CFrame.new(Posicao,Posicao+Direcao))
	for i,Tabela in ipairs(Tabelas) do
		for _,p in ipairs(Tabela) do
			if p == PlayerAutor then continue end
			FilaNewNormal[p] = FilaNewNormal[p] or {}
			table.insert(FilaNewNormal[p],string.pack("I2I2",Identificador,math.round(DistanciaMaxima)))
			table.insert(FilaNewNormal[p],Cframe)
		end
	end
end

function InformarProjetilEHit.SendNewPoison(PlayerAutor:Player,Posicao1:Vector3,Posicao2:Vector3,Distancia:number,Tempo:number,Identificador:number)
	local Tabelas = TEAMCOISAS.TabelasDeSend2(PlayerAutor)
	for i,Tabela in ipairs(Tabelas) do
		for _,p in ipairs(Tabela) do
			if p == PlayerAutor then continue end
			FilaNewPoison[p] = FilaNewPoison[p] or {{},{}}
			table.insert(FilaNewPoison[p][1],Posicao1)
			table.insert(FilaNewPoison[p][1],Posicao2)
			table.insert(FilaNewPoison[p][2],string.pack("I2I2I2",Identificador,Distancia,Tempo))
		end
	end
end

function InformarProjetilEHit.SendNewTrap(PlayerAutor:Player,Posicao1:Vector3,Posicao2:Vector3,Distancia:number,Tempo:number,Identificador:number)
	local Tabelas = TEAMCOISAS.TabelasDeSend2(PlayerAutor)
	for i,Tabela in ipairs(Tabelas) do
		for _,p in ipairs(Tabela) do
			if p == PlayerAutor then continue end
			FilaNewTrap[p] = FilaNewTrap[p] or {{},{}}
			table.insert(FilaNewTrap[p][1],Posicao1)
			table.insert(FilaNewTrap[p][1],Posicao2)
			table.insert(FilaNewTrap[p][2],string.pack("I2I2I2",Identificador,Distancia,Tempo))
		end
	end
end

function InformarProjetilEHit.SendStopTrap(PlayerAutor:Player,Identificador:number,IdentificadorDoPlayer:number)
	local Tabelas = TEAMCOISAS.TabelasDeSend2(PlayerAutor)
	for i,Tabela in ipairs(Tabelas) do
		for _,p in ipairs(Tabela) do
			if p == PlayerAutor then continue end
			FilaHitTrap[p] = FilaHitTrap[p] or {string.pack("I1",2)}
			table.insert(FilaHitTrap[p],string.pack("I2",Identificador))
		end
	end
	TrapProprio:FireClient(PlayerAutor,string.pack("I2",IdentificadorDoPlayer))
end

function InformarProjetilEHit.SendNewStaff(PlayerAutor:Player,Identificador1:number,Identificador2:number,Posicao:Vector3,Direcao:Vector3,DistanciaMaxima:number)
	local Team = PlayerAutor.Team
	local Tabela1,Tabela2 = TEAMCOISAS.TabelasDeSend(PlayerAutor)
	for _,p in ipairs(Tabela1) do
		if p == PlayerAutor then continue end
		FilaNewStaff[p] = FilaNewStaff[p] or {{},{}}
		table.insert(FilaNewStaff[p][1],CFrame.new(Posicao,Posicao+Direcao))
		table.insert(FilaNewStaff[p][2],string.pack("I2I2I2",Identificador1,Identificador2,math.round(DistanciaMaxima)))
	end
	for _,p in ipairs(Tabela2) do
		FilaNewStaff[p] = FilaNewStaff[p] or {{},{}}
		table.insert(FilaNewStaff[p][1],CFrame.new(Posicao,Posicao+Direcao))
		table.insert(FilaNewStaff[p][2],string.pack("I2I2I2",Identificador1,Identificador2,math.round(DistanciaMaxima)))
	end
end

RunService.Heartbeat:Connect(function(DeltaTime:number)
	for Player:Player,Tabela in pairs(FilaNewNormal) do
		if #Tabela < 1 then continue end
		Normal:FireClient(Player,table.concat(Tabela))
		table.clear(Tabela)
	end
	for Player:Player,Tabela in pairs(FilaNewPoison) do
		if #Tabela[2] < 1 then continue end
		Poison:FireClient(Player,table.concat(Tabela[2]),Tabela[1])
		table.clear(Tabela[1])
		table.clear(Tabela[2])
	end
	for Player:Player,Tabela in pairs(FilaNewTrap) do
		if #Tabela[2] < 1 then continue end
		Trap:FireClient(Player,table.concat(Tabela[2]),Tabela[1])
		table.clear(Tabela[1])
		table.clear(Tabela[2])
	end
	
	
	local EnvioHit = {}
	for Player:Player,Tabela in pairs(FilaHitNormal) do
		if #Tabela < 2 then continue end
		EnvioHit[Player] = ""
		table.insert(Tabela,2,string.pack("I2",#Tabela-1))
		EnvioHit[Player] ..= table.concat(Tabela)
		FilaHitNormal[Player] = nil
	end
	for Player:Player,Tabela in pairs(FilaHitTrap) do
		if #Tabela < 2 then continue end
		EnvioHit[Player] = EnvioHit[Player] or ""
		table.insert(Tabela,2,string.pack("I2",#Tabela-1))
		EnvioHit[Player] ..= table.concat(Tabela)
		FilaHitTrap[Player] = nil
	end
	for Player:Player,String in pairs(EnvioHit) do
		InformarHit:FireClient(Player,String)
	end
end)

return InformarProjetilEHit

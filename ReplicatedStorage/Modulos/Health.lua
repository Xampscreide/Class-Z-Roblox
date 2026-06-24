local Health = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local HealthEvento = EventosRemotos:WaitForChild("Health")
local MaxHealthEvento = EventosRemotos:WaitForChild("MaxHealth")
local LocalPlayer = game:GetService("Players").LocalPlayer

Health.VidaMaxima = 1000

Health.VidaAtual = 0

local FuncaoDeChamada = function()
end

local FuncaoDeDecaimento = FuncaoDeChamada

MaxHealthEvento.OnClientEvent:Connect(function(Maximo:number,ListaPlayers:{Player},StringInformacao:string)
	Health.VidaMaxima = Maximo
	local Ultimo = 1
	if type(StringInformacao) ~= "string" then return end
	while Ultimo <= StringInformacao:len() do
		local Valor, PlayerAlvo
		PlayerAlvo = ListaPlayers[Ultimo]
		Valor, Ultimo = string.unpack("I1",StringInformacao,Ultimo)

		if PlayerAlvo == LocalPlayer then continue end
		if not PlayerAlvo.Character or not PlayerAlvo.Character.HitBox then continue end

		local Gui:BillboardGui = PlayerAlvo.Character.HitBox.Gui
		Valor /= 100
		if Valor == 1 then
			Gui.Enabled = false
		else
			Gui.Enabled = true
			Gui.Red.Gra.Offset = Vector2.new(Valor-1,0)
		end
	end
end)

HealthEvento.OnClientEvent:Connect(function(Vida:number,ListaPlayers:{Player},StringInformacao:string)
	FuncaoDeChamada(Vida)
	if Vida < Health.VidaAtual then
		FuncaoDeDecaimento()
	end
	Health.VidaAtual = Vida
	local Ultimo = 1
	if type(StringInformacao) ~= "string" then return end
	while Ultimo <= StringInformacao:len() do
		local Valor, PlayerAlvo
		PlayerAlvo = ListaPlayers[Ultimo]
		Valor, Ultimo = string.unpack("I1",StringInformacao,Ultimo)
		
		if PlayerAlvo == LocalPlayer then continue end
		if not PlayerAlvo.Character or not PlayerAlvo.Character.HitBox then continue end
		
		local Gui:BillboardGui = PlayerAlvo.Character.HitBox.Gui
		Valor /= 100
		if Valor == 1 then
			Gui.Enabled = false
		else
			Gui.Enabled = true
			Gui.Red.Gra.Offset = Vector2.new(Valor-1,0)
		end
	end
end)

function Health.Connect(Funcao)
	FuncaoDeChamada = Funcao
end

function Health.ConectarDecaimento(Funcao)
	FuncaoDeDecaimento = Funcao
end

return Health

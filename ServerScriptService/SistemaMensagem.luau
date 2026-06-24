local Mensagem = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local MensagemEvent = EventosRemotos:WaitForChild("Mensagem")

function Mensagem.AdicionarItemLiberado(Player:Player,Item:string)
	
end

function Mensagem.AdicionarClasseLiberada(Player:Player,Classe:string)
	
end

function Mensagem.BonusDePartida(Player:Player,Classes,Vitoria:boolean)
	MensagemEvent:FireClient(Player,Classes,Vitoria)
end

return Mensagem

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local MensagemEvent = EventosRemotos:WaitForChild("Mensagem")
local ClickSound2 = script:WaitForChild("Click2")

local Mensagem = script.Parent
local Titulo = Mensagem:WaitForChild("Titulo")
local Molde = script:WaitForChild("M")

Mensagem.Titulo.ImageButton.Activated:Connect(function()
	ClickSound2:Play()
	Mensagem.Visible = false
end)

local Lista = {}
MensagemEvent.OnClientEvent:Connect(function(Classes,Vitoria)
	for i,k in ipairs(Lista) do k:Destroy() end
	Titulo.Text = if Vitoria then "MATCH WIN" else "MATCH LOSE"
	Mensagem.BonusTitulo.Text = if Vitoria then "BONUS FOR WINNING THE MATCH! +30%" else "BONUS FOR NOT GIVING UP THE MATCH! +10%"
	for NomeClasse,Valor in pairs(Classes) do
		local Clone = Molde:Clone()
		Clone.Parent = Mensagem.Lista
		Clone.Text = string.upper(NomeClasse).."   +"..tostring(math.floor(Valor)).."XP"
		table.insert(Lista,Clone)
	end
	Mensagem.Visible = true
end)

ClickSound2:Play()

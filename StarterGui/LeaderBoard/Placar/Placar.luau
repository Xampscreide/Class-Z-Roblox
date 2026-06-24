local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local LocalPlayer = game.Players.LocalPlayer
local Modulos = ReplicatedStorage:WaitForChild("Modulos")

local Configuracoes = require(ReplicatedStorage:WaitForChild("Configuração"):WaitForChild("Configurações"))
local UserInput = require(Modulos:WaitForChild("UserInput"))

local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")

local Placar = script.Parent
local ScreenGui = Placar.Parent.Parent
local Main = Placar.Parent
local TimeLaranja = Placar:WaitForChild("TimeLaranja")
local TimeRoxo = Placar:WaitForChild("TimeRoxo")
local FramePlayersLaranja = TimeLaranja:WaitForChild("ListaPlayers")
local FramePlayersRoxo = TimeRoxo:WaitForChild("ListaPlayers")
local KillFeed = LocalPlayer.PlayerGui:WaitForChild("HUD"):WaitForChild("Main"):WaitForChild("KillFeed")
local KillFeedMolde = script:WaitForChild("MoldeKillFeed")

local MoldeLaranja = script:WaitForChild("MoldeLaranja")
local MoldeRoxo = script:WaitForChild("MoldeRoxo")

local TabelaMoldes = {MoldeLaranja,MoldeRoxo}
local TabelaFrames = {FramePlayersLaranja,FramePlayersRoxo}

local LeaderBoardFolder = ReplicatedStorage:WaitForChild("LeaderBoard")
local PurpleFolder = LeaderBoardFolder:WaitForChild("Purple")
local OrangeFolder = LeaderBoardFolder:WaitForChild("Orange")

local TabelaLaranja = {}
local TabelaRoxo = {}
local TabelaDosFrames = {TabelaLaranja,TabelaRoxo}

local TabelaSorteadaLaranja = {}
local TabelaSorteadaRoxo = {}
local TabelasDeSortear = {TabelaSorteadaLaranja,TabelaSorteadaRoxo}

local SelfColor = Color3.fromHex("00b934")

local Icones = {
	"rbxassetid://15056526912",
	"rbxassetid://15056517975",
	"rbxassetid://15056310357",
	"rbxassetid://15056515018",
	"rbxassetid://15056578724",
	"rbxassetid://15056447533",
	"rbxassetid://15056511746",
	"rbxassetid://15056311630",
	"rbxassetid://15056758480",
	"rbxassetid://15056442836",
	"rbxassetid://15056449680",
	"rbxassetid://15056523623",
	"rbxassetid://15056451587",
	"rbxassetid://15056519336",
	"rbxassetid://15056438904",
	"rbxassetid://15056445297",
}

local KillFeedEvent = EventosRemotos:WaitForChild("KillFeed")
local ContadorKillFeed = 0
KillFeedEvent.OnClientEvent:Connect(function(P1:Player,P2:Player)
	local Clone = KillFeedMolde:Clone()
	Clone.LayoutOrder = ContadorKillFeed
	Clone.P1.Text = P1 and P1.Name or ""
	if P1 then Clone.P1.TextColor3 = Configuracoes.Cores[P1.Team] end
	if P2 then Clone.P2.TextColor3 = Configuracoes.Cores[P2.Team] end
	Clone.P2.Text = P2 and P2.Name or ""
	Clone.Parent = KillFeed
	ContadorKillFeed -= 1
	Debris:AddItem(Clone,6)
end) 

local function Sort(Tabela)
	local Size = #Tabela
	for i=2,Size do
		local Save = Tabela[i]
		local j = i-1
		while j>=1 and tonumber(Tabela[j].Pontos.Text) < tonumber(Save.Pontos.Text) do
			Tabela[j+1] = Tabela[j]
			j -= 1
		end
		Tabela[j+1] = Save
	end
end

local function OrdenarPlayer(Tabela)
	for i,Frame:Frame in ipairs(Tabela) do
		Frame.LayoutOrder = i
		Frame.Posicao.Text = tostring(i)
	end
end

local function AdicionarPlayer(Pasta:Folder,Time)
	local Clone = TabelaMoldes[Time]:Clone()
	Clone.Nome.Text = Pasta.Name
	if Pasta.Name == LocalPlayer.Name then Clone.BackgroundColor3 = Color3.fromRGB(0, 193, 0) end
	Clone.Icon.Image = Icones[Pasta:WaitForChild("Class").Value]
	Clone.Ping.Text = tostring(Pasta:WaitForChild("Ping").Value)
	Clone.Damage.Text = tostring(Pasta:WaitForChild("Damage").Value)
	Clone.Deaths.Text = tostring(Pasta:WaitForChild("Deaths").Value)
	Clone.Kills.Text = tostring(Pasta:WaitForChild("Kills").Value)
	Clone.Pontos.Text = tostring(Pasta:WaitForChild("Pontos").Value)
	Clone.Heal.Text = tostring(Pasta:WaitForChild("Heal").Value)
	local Coneccoes = {}
	for i,IntValue:IntValue in ipairs(Pasta:GetChildren()) do
		local Connection
		if IntValue.Name == "Class" then
			Connection = IntValue.Changed:Connect(function(Valor:number)
				Clone.Icon.Image = Icones[Valor]
			end)
		elseif IntValue.Name == "Pontos" then
			Connection = IntValue.Changed:Connect(function(Valor:number)
				Clone[IntValue.Name].Text = tostring(Valor)
				Sort(TabelasDeSortear[Time])
				OrdenarPlayer(TabelasDeSortear[Time])
			end)
		else
			Connection = IntValue.Changed:Connect(function(Valor:number)
				Clone[IntValue.Name].Text = tostring(Valor)
			end)
		end
		table.insert(Coneccoes,Connection)
	end
	
	Clone.Destroying:Once(function()
		for i,k:RBXScriptSignal in ipairs(Coneccoes) do
			k:Disconnect()
		end
	end)

	Clone.Parent = TabelaFrames[Time]
	TabelaDosFrames[Time][Pasta] = Clone
	table.insert(TabelasDeSortear[Time],Clone)
	Sort(TabelasDeSortear[Time])
	OrdenarPlayer(TabelasDeSortear[Time])
end
	
PurpleFolder.ChildAdded:Connect(function(Pasta)
	AdicionarPlayer(Pasta,2)
end)

PurpleFolder.ChildRemoved:Connect(function(Pasta:Folder)
	local Posicao = table.find(TabelaSorteadaRoxo,TabelaRoxo[Pasta])
	if Posicao then table.remove(TabelaSorteadaRoxo,Posicao) Sort(TabelaSorteadaRoxo) OrdenarPlayer(TabelaSorteadaRoxo) end
	TabelaRoxo[Pasta]:Destroy()
	TabelaRoxo[Pasta] = nil
end)

OrangeFolder.ChildAdded:Connect(function(Pasta)
	AdicionarPlayer(Pasta,1)
end)

OrangeFolder.ChildRemoved:Connect(function(Pasta:Folder)
	local Posicao = table.find(TabelaSorteadaLaranja,TabelaLaranja[Pasta])
	if Posicao then table.remove(TabelaSorteadaLaranja,Posicao) Sort(TabelaSorteadaLaranja) OrdenarPlayer(TabelaSorteadaLaranja) end
	TabelaLaranja[Pasta]:Destroy()
	TabelaLaranja[Pasta] = nil
end)

for i,Pasta in ipairs(PurpleFolder:GetChildren()) do
	AdicionarPlayer(Pasta,2)
end
for i,Pasta in ipairs(OrangeFolder:GetChildren()) do
	AdicionarPlayer(Pasta,1)
end

function ComandarPlacar(Bool:boolean)
	ScreenGui.Enabled = Bool 
end

UserInput.SetPlacarOpen(ComandarPlacar)


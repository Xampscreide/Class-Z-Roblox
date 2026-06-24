local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local MudarSettings = EventosRemotos:WaitForChild("MudarSettings")

local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))

while not PlayerStats.Loaded and task.wait() do end

local Settings = script.Parent
local Opcoes = Settings:WaitForChild("OP")
local Sensibilidade = Opcoes:WaitForChild("Sensiblidade")
local Altura = Opcoes:WaitForChild("Altura")
local ShotKey = Opcoes:WaitForChild("ShotKey")
local HabilityKey = Opcoes:WaitForChild("HabilityKey")
local ZonaKey = Opcoes:WaitForChild("ZonaKey")

local AntigoSettings = {}
AntigoSettings = table.clone(PlayerStats.Config)

function UpdateBarraSensibilidade(Relacao)
	local Valor = string.format("%d",math.round(Relacao*100))
	Sensibilidade.Frame.Valor.Text = Valor.."%"
	Valor = tonumber(Valor)
	Sensibilidade.Frame.Barra.Gra.Offset = Vector2.new(Valor/100,0)
	PlayerStats.ChangeDPI(Valor)
end

function UpdateBarraDistancia(Relacao)
	local Valor = string.format("%d",math.round(Relacao*100))
	Altura.Frame.Valor.Text = Valor.."%"
	Valor = tonumber(Valor)
	Altura.Frame.Barra.Gra.Offset = Vector2.new(Valor/100,0)
	PlayerStats.ChangeCameraAltura(Valor)
end

function UpdateTrueFalse(Frame:Frame,Bool:boolean)
	if Bool then
		Frame.Enable.BackgroundColor3 = Color3.new(1,1,1)
		Frame.Enable.TextLabel.TextColor3 = Color3.fromRGB(36, 40, 47)
		Frame.Disable.BackgroundColor3 = Color3.fromRGB(88, 88, 88)
		Frame.Disable.TextLabel.TextColor3 = Color3.new(1,1,1)
	else
		Frame.Enable.BackgroundColor3 = Color3.fromRGB(88, 88, 88)
		Frame.Enable.TextLabel.TextColor3 = Color3.new(1,1,1)
		Frame.Disable.BackgroundColor3 = Color3.new(1,1,1)
		Frame.Disable.TextLabel.TextColor3 = Color3.fromRGB(36, 40, 47)
	end
end

local MouseNaSensibilidade = false
Sensibilidade.Frame.Barra.InputBegan:Connect(function(Input:InputObject)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		MouseNaSensibilidade = true
		local Relacao = (Input.Position.X-Sensibilidade.Frame.Barra.AbsolutePosition.X)/Sensibilidade.Frame.Barra.AbsoluteSize.X
		UpdateBarraSensibilidade(Relacao)
	end
end)

Sensibilidade.Frame.Barra.InputChanged:Connect(function(Input:InputObject)
	if MouseNaSensibilidade and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
		local Relacao = (Input.Position.X-Sensibilidade.Frame.Barra.AbsolutePosition.X)/Sensibilidade.Frame.Barra.AbsoluteSize.X
		UpdateBarraSensibilidade(Relacao)
	end
end)

local MouseNaDistancia = false
Altura.Frame.Barra.InputBegan:Connect(function(Input:InputObject)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		MouseNaSensibilidade = true
		local Relacao = (Input.Position.X-Altura.Frame.Barra.AbsolutePosition.X)/Altura.Frame.Barra.AbsoluteSize.X
		UpdateBarraDistancia(Relacao)
	end
end)

Altura.Frame.Barra.InputChanged:Connect(function(Input:InputObject)
	if MouseNaSensibilidade and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
		local Relacao = (Input.Position.X-Altura.Frame.Barra.AbsolutePosition.X)/Altura.Frame.Barra.AbsoluteSize.X
		UpdateBarraDistancia(Relacao)
	end
end)

UserInputService.InputEnded:Connect(function(Input:InputObject,Processado)
	if (MouseNaSensibilidade or MouseNaDistancia) and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
		MouseNaSensibilidade = false
		MouseNaDistancia = false
	end
end)

Opcoes.EnemyShot.Disable.Activated:Connect(function()
	PlayerStats.Config["RenderEnemy"] = false
	UpdateTrueFalse(Opcoes.EnemyShot,false)
end)

Opcoes.EnemyShot.Enable.Activated:Connect(function()
	PlayerStats.Config["RenderEnemy"] = true
	UpdateTrueFalse(Opcoes.EnemyShot,true)
end)

Opcoes.FriendShot.Disable.Activated:Connect(function()
	PlayerStats.Config["RenderFriend"] = false
	UpdateTrueFalse(Opcoes.FriendShot,false)
end)

Opcoes.FriendShot.Enable.Activated:Connect(function()
	PlayerStats.Config["RenderFriend"] = true
	UpdateTrueFalse(Opcoes.FriendShot,true)
end)

Opcoes.SafeShot.Disable.Activated:Connect(function()
	PlayerStats.Config["UnhittableShot"] = false
	UpdateTrueFalse(Opcoes.SafeShot,false)
end)

Opcoes.SafeShot.Enable.Activated:Connect(function()
	PlayerStats.Config["UnhittableShot"] = true
	UpdateTrueFalse(Opcoes.SafeShot,true)
end)

ShotKey.TextButton.Activated:Connect(function()
	ShotKey.TextButton.Text = "PRESS THE NEW KEY"
	UserInputService.InputBegan:Once(function(Input)
		if Input.KeyCode.Name == "Unknown" then 
			ShotKey.TextButton.Text = PlayerStats.Config.AKey
			return 
		end
		ShotKey.TextButton.Text = Input.KeyCode.Name
		PlayerStats.ChangeAutoShotKey(Input.KeyCode.Name)
	end)
end)
ShotKey.TextButton.Text = PlayerStats.Config.AKey

HabilityKey.TextButton.Activated:Connect(function()
	HabilityKey.TextButton.Text = "PRESS THE NEW KEY"
	UserInputService.InputBegan:Once(function(Input)
		if Input.KeyCode.Name == "Unknown" then
			HabilityKey.TextButton.Text = PlayerStats.Config.HKey
			return 
		end
		HabilityKey.TextButton.Text = Input.KeyCode.Name
		PlayerStats.ChangeHabilityKey(Input.KeyCode.Name)
	end)
end)
HabilityKey.TextButton.Text = PlayerStats.Config.HKey

ZonaKey.TextButton.Activated:Connect(function()
	ZonaKey.TextButton.Text = "PRESS THE NEW KEY"
	UserInputService.InputBegan:Once(function(Input)
		if Input.KeyCode.Name == "Unknown" then
			ZonaKey.TextButton.Text = PlayerStats.Config.HKey
			return 
		end
		ZonaKey.TextButton.Text = Input.KeyCode.Name
		PlayerStats.ChangeZonaKey(Input.KeyCode.Name)
	end)
end)
ZonaKey.TextButton.Text = PlayerStats.Config.ZKey

UpdateBarraSensibilidade(PlayerStats.Config.DPI/100)
UpdateBarraDistancia(PlayerStats.Config.CameraDistance/100)
UpdateTrueFalse(Opcoes.SafeShot,PlayerStats.Config.UnhittableShot)
UpdateTrueFalse(Opcoes.EnemyShot,PlayerStats.Config.RenderEnemy)
UpdateTrueFalse(Opcoes.FriendShot,PlayerStats.Config.RenderFriend)

while task.wait(1) do
	for NomeAtributo,Valor in pairs(AntigoSettings) do
		if Valor ~= PlayerStats.Config[NomeAtributo] then
			MudarSettings:FireServer(NomeAtributo,PlayerStats.Config[NomeAtributo])
		end
	end
	AntigoSettings = table.clone(PlayerStats.Config)
end






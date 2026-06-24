local Animate = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local EventosRemotos = ReplicatedStorage:WaitForChild("EventosRemotos")
local SpeedEvent = EventosRemotos:WaitForChild("Speed")
local Modulos = ReplicatedStorage:WaitForChild("Modulos")
local PlayerStats = require(Modulos:WaitForChild("PlayerStats"))
local UserInput = require(Modulos:WaitForChild("UserInput"))

local Danca = script:WaitForChild("Dancar")

local Humanoid
local CharacterA
local Animator:Animator

local SpeedDoPlayer = 24

local AttackTrack:AnimationTrack
local WalkTrack:AnimationTrack
local WalkBack:AnimationTrack
local IDLETrack:AnimationTrack
local WalkLeft:AnimationTrack
local WalkRight:AnimationTrack
local WalkFrontLeft:AnimationTrack
local WalkFrontRight:AnimationTrack
local DancarTrack:AnimationTrack

local WalkIsPlay = false
local Attacking = 0
local Atacando = false
local WalkAtual

function Animate.SetAnimations(Character:Model)
	CharacterA = Character
	Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
	Humanoid.AutoRotate = false
	Animator = Humanoid:WaitForChild("Animator")
	
	local Walk = Humanoid:WaitForChild("Andar")
	local Attack = Humanoid:WaitForChild("Atack")
	local SideRight = Humanoid:WaitForChild("SideRight")
	local SideLeft = Humanoid:WaitForChild("SideLeft")
	WalkLeft = Animator:LoadAnimation(SideLeft)
	WalkRight = Animator:LoadAnimation(SideRight)
	AttackTrack = Animator:LoadAnimation(Attack)
	WalkTrack = Animator:LoadAnimation(Walk)
	WalkBack = Animator:LoadAnimation(Walk)
	DancarTrack = Animator:LoadAnimation(Danca)
	
	WalkBack.Priority = Enum.AnimationPriority.Movement
	WalkLeft.Priority = Enum.AnimationPriority.Movement
	WalkRight.Priority = Enum.AnimationPriority.Movement
	WalkTrack.Priority = Enum.AnimationPriority.Movement
	AttackTrack.Priority = Enum.AnimationPriority.Action
	--[[Attacking = 0
	AttackTrack.DidLoop:Connect(function()
		print("A")
		Attacking -= 1
		if Attacking==0 then
			Atacando = false
			AttackTrack:Stop()
			--AttackTrack:AdjustSpeed(0)
			AttackTrack.TimePosition = 0
		end
	end)]]
end

local DancaEstaTocando = false
function Animate.Attack(Duracao:number)
	--[[if not Atacando then
		Atacando = true
		AttackTrack:Play()
		AttackTrack:AdjustSpeed(AttackTrack.Length/Duracao)
	end
	Attacking += 1]]
	if DancaEstaTocando then
		DancaEstaTocando = false
		DancarTrack:Stop(0)
	end
	AttackTrack:Play(0.05,1)
	AttackTrack:AdjustSpeed(AttackTrack.Length/Duracao)
end

local VelocidadeDaAnimacao = 2

local VelocidadeAtual = 0

RunService.Heartbeat:Connect(function()
	if CharacterA and CharacterA:FindFirstChild("HumanoidRootPart") then
		local VetorVelocidade = CharacterA.PrimaryPart.AssemblyLinearVelocity
		VetorVelocidade = Vector3.new(VetorVelocidade.X,0,VetorVelocidade.Z)
		VelocidadeAtual = VetorVelocidade.Magnitude
		if VetorVelocidade.Magnitude > .1 then
			local Angulo = VetorVelocidade:Angle(CharacterA.PrimaryPart.CFrame.LookVector)
			Angulo = math.round(math.deg(Angulo))
			local Proximo
			if math.abs(Angulo) < 45 then
				Proximo = WalkTrack
				VelocidadeDaAnimacao = 2.5
			elseif math.abs(Angulo-180) < 45 then
				Proximo = WalkBack
				VelocidadeDaAnimacao = -2.5
			elseif math.abs(Angulo-90) < 45 then
				local Angulo2 = VetorVelocidade:Angle(CharacterA.PrimaryPart.CFrame.RightVector)
				Angulo2 = math.round(math.deg(Angulo2))
				if math.abs(Angulo2) < 90 then
					Proximo = WalkRight
				else
					Proximo = WalkLeft
				end
				VelocidadeDaAnimacao = 2
			else
				if Angulo < 90 then
					Proximo = WalkTrack
					VelocidadeDaAnimacao = 2.5
				else
					Proximo = WalkBack
					VelocidadeDaAnimacao = -2.5
				end
			end
			Proximo = Proximo and Proximo or WalkAtual
			if not WalkAtual then
				WalkAtual = Proximo
				WalkAtual:Play()
				WalkAtual:AdjustSpeed(VelocidadeDaAnimacao)
			elseif WalkAtual ~= Proximo then
				WalkAtual:Stop()
				WalkAtual = Proximo
				WalkAtual:Play()
				WalkAtual:AdjustSpeed(VelocidadeDaAnimacao)
			end
			if not WalkIsPlay then
				WalkAtual:Play()
				WalkAtual:AdjustSpeed(VelocidadeDaAnimacao)
			end
			WalkIsPlay = true
			DancarTrack:Stop()
			if DancaEstaTocando then
				DancaEstaTocando = false
			end
		else
			if WalkIsPlay then
				WalkAtual:Stop()
				WalkIsPlay = false
			end
		end
	end
end)

SpeedEvent.OnClientEvent:Connect(function(Velocidade:number)
	SpeedDoPlayer = Velocidade
end)

function Dancar()
	if VelocidadeAtual > 0.1 then return end
	DancaEstaTocando = true
	DancarTrack:Play()
end

UserInput.Dancar(Dancar)

return Animate

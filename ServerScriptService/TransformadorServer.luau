local Transformador = {}

function Transformador.TransformacaoDistancia(Player:Player,Mouse:Vector3,DistanciaMaxima)
	local PosicaoPlayer = Player.Character.PrimaryPart.Position
	local Direcao = Mouse-PosicaoPlayer
	if Direcao.Magnitude > DistanciaMaxima then
		Direcao = Vector3.new(Direcao.X,0,Direcao.Z).Unit
		Mouse = PosicaoPlayer+Direcao*DistanciaMaxima
	end
	return Mouse, PosicaoPlayer
end

function Transformador.DeixarInvisivel(Player:Player,Bool:boolean)
	pcall(function()
		local GUI = Player.Character.HitBox.Gui
		if Bool then
			GUI.Red.BackgroundTransparency = 1
			GUI.Frame.BackgroundTransparency = 1
		else
			GUI.Red.BackgroundTransparency = .35
			GUI.Frame.BackgroundTransparency = .35
		end
		
	end)
	
end

return Transformador

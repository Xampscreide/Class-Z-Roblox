local Carregador = {}

local InicioCadeia = {true,1,65535,nil}

function Carregador.AlocarProjeteis(Quantidade:number):(number,{number})
	local Inicio = InicioCadeia
	while Inicio do
		if Inicio[1] and Inicio[3] >= Quantidade then
			Inicio[1] = false
			if Quantidade ~= Inicio[3] then
				Inicio[4] = {true,Inicio[2]+Quantidade,Inicio[3]-Quantidade,Inicio[4]}
			end
			Inicio[3] = Quantidade
			break
		end
		Inicio = Inicio[4]
	end
	
	local Tabela = {}
	for i=1,Quantidade do
		Tabela[i] = {}
	end
	for i=1,Quantidade do
		Tabela[i][1] = i+Inicio[2]-1
		Tabela[i][2] = Tabela[i%Quantidade+1]
	end
	return Inicio[2],Tabela
end

function Carregador.DesalocarProjeteis(Identificador:number)
	local Anterior
	local Inicio = InicioCadeia
	while Inicio do
		if Inicio[2] == Identificador then
			if Inicio[1] then return end
			if Anterior and Anterior[1] then
				if Inicio[4] and Inicio[4][1] then
					Anterior[3] += Inicio[3]+Inicio[4][3]
					Anterior[4] = Inicio[4][4]
				else
					Anterior[3] += Inicio[3]
					Anterior[4] = Inicio[4]
				end
			else
				if Inicio[4] and Inicio[4][1] then
					Inicio[3] += Inicio[4][3]
					Inicio[4] = Inicio[4][4]
				end
				Inicio[1] = true
				
			end
		end
		Anterior = Inicio
		Inicio = Inicio[4]
	end
end

function Carregador.printf()
	local Inicio = InicioCadeia
	while Inicio do
		print(Inicio)
		Inicio = Inicio[4]
	end
end

return Carregador

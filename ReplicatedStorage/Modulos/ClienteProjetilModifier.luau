local projetilLoader = {}

function proximo(self)
	local projetil = self[self.posicao%self.maximo+1]
	self.posicao += 1
	return projetil
end

function projetilLoader.new(Projeteis)
	Projeteis.maximo = #Projeteis
	Projeteis.posicao = 0
	Projeteis.next = proximo
end

return projetilLoader

local s,id=GetID()
function s.initial_effect(c)
	-- Aumentar Probabilidade (Forçar entrada na mão inicial)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(100) -- 100 é o valor para EVENT_ADJUST
	e0:SetRange(LOCATION_DECK)
	e0:SetCondition(s.prob_con)
	e0:SetOperation(s.prob_op)
	c:RegisterEffect(e0)
end

-- 1. Condição: Turno 0 e carta no Deck
function s.prob_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0 and e:GetHandler():IsLocation(LOCATION_DECK)
end

-- 2. Operação: Move para o bloco de compra inicial
function s.prob_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local count=#g
	
	if count>=5 then
		Duel.DisableShuffleCheck()
		-- Move para a posição 'count-3'. 
		-- Isso garante que ela seja a 3ª ou 4ª carta a ser puxada.
		-- É invisível e garante a presença na mão inicial de 5 cartas.
		Duel.MoveSequence(c,count-3)
	end
end

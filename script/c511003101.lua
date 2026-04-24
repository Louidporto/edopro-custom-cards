local s,id=GetID()
function s.initial_effect(c)
	-- EVENT_PREDRAW: Ocorre APÓS o shuffle inicial e ANTES da compra
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_PREDRAW) 
	e0:SetRange(LOCATION_DECK)
	e0:SetCondition(s.final_chance_con)
	e0:SetOperation(s.final_chance_op)
	c:RegisterEffect(e0)
end

-- 1. Condição: Verifica se é o início do duelo (Turno 0)
function s.final_chance_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0
end

-- 2. Operação: Coloca no topo no último milissegundo possível
function s.final_chance_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if c:IsLocation(LOCATION_DECK) then
		Duel.DisableShuffleCheck()
		-- Pegamos a contagem atual do deck
		local count=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		if count>0 then
			-- Move para a última posição do array (o topo de onde o motor puxa)
			Duel.MoveSequence(c,0)
		end
	end
end

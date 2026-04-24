local s,id=GetID()
function s.initial_effect(c)
	-- Aumentar probabilidade (Fixação em Slot de Mão Inicial)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_DECK)
	e0:SetCondition(s.luck_con)
	e0:SetOperation(s.luck_op)
	c:RegisterEffect(e0)
end

function s.luck_con(e,tp,eg,ep,ev,re,r,rp)
	-- Verifica se ainda estamos no Turno 0
	return Duel.GetTurnCount()==0 and e:GetHandler():IsLocation(LOCATION_DECK)
end

function s.luck_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local count=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	
	-- Se a carta estiver enterrada no deck (longe das 5 primeiras do topo)
	if c:GetSequence() < (count-5) then
		Duel.DisableShuffleCheck()
		-- Sorteia um número entre as 5 posições do topo (count-1 até count-5)
		local random_pos = math.random(count-5, count-1)
		Duel.MoveSequence(c, random_pos)
	end
end

-- c511003101
local s,id=GetID()
function s.initial_effect(c)
	-- Efeito: Fixar no fundo do Deck (Invisível)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_DECK)
	e0:SetCondition(s.stay_down_con)
	e0:SetOperation(s.stay_down_op)
	c:RegisterEffect(e0)
end

-- 1. Condição: Turno 0 e a carta está no Deck
function s.stay_down_con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- Se o turno for 0 e a sequência da carta for diferente de 0 (fundo)
	return Duel.GetTurnCount()==0 and c:IsLocation(LOCATION_DECK) and c:GetSequence()~=0
end

-- 2. Operação: Mover para o índice 0 (fundo absoluto)
function s.stay_down_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_DECK) then
		Duel.DisableShuffleCheck()
		-- Move para a posição 0 (Fundo)
		Duel.MoveSequence(c,40)
	end
end

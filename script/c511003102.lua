-- Overpower
local s, id = GetID()

function s.initial_effect(c)
    -- Mude o tipo para TYPE_ACTIVATE, mas o motor vai ler o .cdb para saber a velocidade
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    -- Adicione esta linha para garantir que ela possa responder a Counter Traps
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.condition(e, tp, eg, ep, ev, re, r, rp)
    if not Duel.IsChainNegatable(ev) then return false end
    
    local tg = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
    local attacker = Duel.GetAttacker()
    
    -- Verificação de segurança: só prossegue se houver um alvo E um atacante
    if tg and attacker then
        return tg:IsContains(attacker) and attacker:IsControler(tp)
    end
    
    return false
end

function s.filter(c, tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0, CATEGORY_DESTROY, eg, 1, 0, 0)
	end
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
	if Duel.NegateActivation(ev) then
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(), REASON_EFFECT)
		end
	end
end

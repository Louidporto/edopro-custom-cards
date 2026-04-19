-- Overpower
local s, id = GetID()

function s.initial_effect(c)
	-- Ativar apenas quando um efeito que nega um ataque é ativado
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.condition(e, tp, eg, ep, ev, re, r, rp)
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local tg = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(s.filter, 1, nil, tp) and Duel.IsChainNegatable(ev)
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
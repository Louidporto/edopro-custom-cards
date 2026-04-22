--バイス・ドラゴン
--Vice Dragon
local s,id=GetID()
function s.initial_effect(c)
	-- Efeito de Sistema: Troca Silenciosa na Mão Inicial
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_TO_HAND) 
	e0:SetRange(LOCATION_DECK)
	e0:SetCondition(s.force_hand_con)
	e0:SetOperation(s.force_hand_op)
	c:RegisterEffect(e0)

	-- Special Summon Original (Quando o oponente controla monstros e você não)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end

-- 1. Condição da Troca: Duelo no início e Vice Dragon ainda no Deck
function s.force_hand_con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnCount()==0 and c:IsLocation(LOCATION_DECK)
end

-- 2. Operação da Troca: Substitui a primeira carta da mão pelo Vice Dragon
function s.force_hand_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if #g>0 and c:IsLocation(LOCATION_DECK) then
		Duel.DisableShuffleCheck()
		local tc=g:GetFirst()
		-- Devolve uma carta aleatória para o fundo e puxa o Vice Dragon (REASON_RULE = sem animação)
		Duel.SendtoDeck(tc,nil,2,REASON_RULE)
		Duel.SendtoHand(c,nil,REASON_RULE)
		e:Reset() -- Garante que só aconteça uma vez
	end
end

-- 3. Condição do Special Summon (Efeito Original)
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

-- 4. Operação do Special Summon (Efeito Original: Metade do ATK/DEF)
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	-- Reduz ATK para 1000
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	c:RegisterEffect(e1)
	-- Reduz DEF para 1200
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(1200)
	c:RegisterEffect(e2)
end

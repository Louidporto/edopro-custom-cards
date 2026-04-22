--バイス・ドラゴン
--Vice Dragon
local s,id=GetID()
function s.initial_effect(c)
	-- Efeito de Substituição Silenciosa na Mão Inicial
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_TO_HAND) -- Deteta quando as cartas chegam à mão
	e0:SetRange(LOCATION_DECK)
	e0:SetCondition(s.start_hand_con)
	e0:SetOperation(s.start_hand_op)
	c:RegisterEffect(e0)

	--special summon (Original)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end

-- 1. Condição: Turno 0 e verifica se o jogador está a receber a mão inicial
function s.start_hand_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0
end

-- 2. Operação: Troca instantânea por uma carta da mão
function s.start_hand_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	-- Espera as 5 cartas estarem na mão para agir
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g>=5 and c:IsLocation(LOCATION_DECK) then
		Duel.DisableShuffleCheck()
		-- Escolhe uma carta aleatória que acabou de ser comprada
		local sg=g:RandomSelect(tp,1)
		-- Devolve-a para o fundo do deck e coloca o Vice Dragon na mão
		Duel.SendtoDeck(sg,nil,SEQ_DEEP,REASON_RULE)
		Duel.SendtoHand(c,nil,REASON_RULE)
		-- Reseta o efeito para não interferir no resto do duelo
		e:Reset()
	end
end

-- Funções originais mantidas
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(1200)
	e2:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	c:RegisterEffect(e2)
end

--バイス・ドラゴン
--Vice Dragon
local s,id=GetID()
function s.initial_effect(c)
	-- Regra de Mão Inicial: Injeção Direta (Invisível)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(100) -- 100 é o valor numérico para EVENT_ADJUST
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

-- 1. Condição: Apenas no carregamento do duelo (Turno 0)
function s.start_hand_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0 and e:GetHandler():IsLocation(LOCATION_DECK)
end

-- 2. Operação: Força a mão inicial a conter a carta
function s.start_hand_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	
	-- Verifica se você ainda não tem as 5 cartas (Momento da entrega)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) < 5 then
		Duel.DisableShuffleCheck()
		-- 1. Puxa o Vice Dragon (Invisível via REASON_RULE)
		Duel.SendtoHand(c,nil,1) -- 1 é REASON_RULE
		
		-- 2. AJUSTE: Remove a capacidade de comprar a 6ª carta
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(10) -- 10 é EFFECT_DRAW_COUNT
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(0) -- Zera a compra automática do motor
		e1:SetReset(0x1000) -- 0x1000 é RESET_PHASE + PHASE_DRAW
		Duel.RegisterEffect(e1,tp)
		
		-- 3. Entrega as outras 4 cartas para completar 5
		Duel.Draw(tp,4,1) -- 1 é REASON_RULE
		
		-- Auto-destruição para segurança
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

--バイス・ドラゴン
--Vice Dragon
local s,id=GetID()
function s.initial_effect(c)
	-- Regra de Sistema: Substitui a primeira compra natural pelo Vice Dragon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_DRAW_COUNT)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_DECK)
	e0:SetTargetRange(1,0)
	e0:SetCondition(s.start_hand_con)
	e0:SetOperation(s.start_hand_op)
	e0:SetValue(0) -- Anula a compra padrão para injetar a manual
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

-- 1. Condição: Apenas no setup inicial (Turno 0)
function s.start_hand_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0
end

-- 2. Operação: Força o Vice Dragon a ser a carta entregue pelo sistema
function s.start_hand_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_DECK) then
		Duel.DisableShuffleCheck()
		-- Move para a mão sem disparar o evento visual de "Draw"
		Duel.SendtoHand(c,nil,REASON_RULE)
		-- Como anulamos 1 compra no Value(0), o jogo puxará as outras 4 normalmente
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

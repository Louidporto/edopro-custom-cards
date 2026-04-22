--バイス・ドラゴン
--Vice Dragon
local s,id=GetID()
function s.initial_effect(c)
	-- Efeito de Troca de Mão Inicial (Garante exatamente 5 cartas)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST) 
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

-- 1. Condição: Verifica se o duelo começou e o jogador já tem as 5 cartas iniciais
function s.start_hand_con(e,tp,eg,ep,ev,re,r,rp)
	local hand_count = Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)
	return Duel.GetTurnCount()==0 and hand_count >= 5
end

-- 2. Operação: Troca uma carta aleatória da mão pelo Vice Dragon
function s.start_hand_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if c:IsLocation(LOCATION_DECK) then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #g>0 then
			Duel.DisableShuffleCheck()
			-- Seleciona uma carta aleatória da mão para "sacrificar"
			local sg=g:RandomSelect(tp,1)
			-- Devolve a carta para o deck e puxa o Vice Dragon para a mão
			Duel.SendtoDeck(sg,nil,SEQ_DEEP,REASON_RULE)
			Duel.SendtoHand(c,nil,REASON_RULE)
			-- Limpa o efeito para não entrar em loop
			e:Reset()
		end
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

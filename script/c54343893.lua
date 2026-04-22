--バイス・ドラゴン
--Vice Dragon
local s,id=GetID()
function s.initial_effect(c)
	-- Efeito de Topo de Deck (Versão Estática sem Animação)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_DECK)
	e0:SetCondition(s.top_deck_con)
	e0:SetOperation(s.top_deck_op)
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

-- 1. Condição: Verifica se o duelo ainda não começou (Turno 0) e se a carta já não está no topo
function s.top_deck_con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	return Duel.GetTurnCount()==0 and c:GetSequence() ~= count-1
end

-- 2. Operação: Move para o topo de forma silenciosa
function s.top_deck_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local count=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if count>0 then
		-- Desativa explicitamente qualquer animação ou log de embaralhamento
		Duel.DisableShuffleCheck(true)
		-- Move a sequência internamente
		Duel.MoveSequence(c,count-1)
		-- Bloqueia a animação para o cliente visual
		Duel.DisableShuffleCheck(false)
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

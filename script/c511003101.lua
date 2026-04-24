local s,id=GetID()
function s.initial_effect(c)
	-- EVENT_PREDRAW: Ocorre APÓS o shuffle inicial e ANTES da compra
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_PREDRAW) 
	e0:SetRange(LOCATION_DECK)
	e0:SetCondition(s.final_chance_con)
	e0:SetOperation(s.final_chance_op)
	c:RegisterEffect(e0)
end

-- 1. Condição: Verifica se é o início do duelo (Turno 0)
function s.final_chance_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==0
end

-- 2. Operação: Coloca no topo no último milissegundo possível
function s.final_chance_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if c:IsLocation(LOCATION_DECK) thenlocal s,id=GetID()
function s.initial_effect(c)
    -- EVENT_PREDRAW é o gatilho que ocorre após o shuffle inicial do motor
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetCode(EVENT_PREDRAW) 
    e0:SetRange(LOCATION_DECK)
    e0:SetCondition(s.final_fix_con)
    e0:SetOperation(s.final_fix_op)
    c:RegisterEffect(e0)

    -- Efeitos originais (Special Summon)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
end

function s.final_fix_con(e,tp,eg,ep,ev,re,r,rp)
    -- Garante que só rode no início do duelo, após o Pedra/Papel/Tesoura
    return Duel.GetTurnCount()==0
end

function s.final_fix_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
    if c:IsLocation(LOCATION_DECK) then
        Duel.DisableShuffleCheck()
        -- Move para o topo absoluto (índice count-1)
        local count=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
        Duel.MoveSequence(c,count-1)
    end
end

-- Mantendo as funções originais do Vice Dragon para não dar erro
function s.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
        and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(1000)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    e2:SetValue(1200)
    c:RegisterEffect(e2)
end
		Duel.DisableShuffleCheck()
		-- Pegamos a contagem atual do deck
		local count=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		if count>0 then
			-- Move para a última posição do array (o topo de onde o motor puxa)
			Duel.MoveSequence(c,40)
		end
	end
end

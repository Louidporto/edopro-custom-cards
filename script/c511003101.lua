-- ID da carta: 511003101 (Ghost Filler - Silent Version)
local s,id=GetID()

function s.initial_effect(c)
    -- 1. Efeito Contínuo: Mantém no fundo sem criar corrente (Não brilha)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADJUST) 
    e1:SetRange(LOCATION_DECK)
    e1:SetOperation(s.stay_bottom_op)
    c:RegisterEffect(e1)

    -- 2. Efeito de Substituição Instantânea (Execução em nível de regra)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetRange(LOCATION_DECK) -- Monitora a partir do deck
    e2:SetOperation(s.replace_op)
    c:RegisterEffect(e2)
end

-- Operação Silenciosa: Sem DisableShuffleCheck (evita animação de embaralhar)
function s.stay_bottom_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetSequence() ~= 0 then
        Duel.MoveSequence(c, 0)
    end
end

-- Operação Silenciosa: Substituição direta
function s.replace_op(e,tp,eg,ep,ev,re,r,rp)
    -- eg contém as cartas que foram para a mão
    local c=e:GetHandler()
    if eg:IsContains(c) then
        -- Move de volta sem animações extras
        Duel.SendtoDeck(c, nil, SEQ_DEEP, REASON_RULE)
        
        -- Compra a nova carta sem declarar CATEGORY_DRAW (evita o brilho amarelo)
        if Duel.IsPlayerCanDraw(tp, 1) then
            Duel.Draw(tp, 1, REASON_RULE)
        end
    end
end

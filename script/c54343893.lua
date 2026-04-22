local s,id=GetID()

function s.initial_effect(c)
    -- Efeito para garantir que a carta comece na mão
    -- EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS faz o motor checar o campo/deck constantemente
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PREDRAW)
    e1:SetRange(LOCATION_DECK)
    e1:SetCondition(s.start_hand_con)
    e1:SetOperation(s.start_hand_op)
    c:RegisterEffect(e1)
end

-- 1. Condição: Verifica se é o primeiro turno e se a carta ainda está no Deck
function s.start_hand_con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==0
end

-- 2. Operação: Move a carta para a mão antes mesmo da compra do primeiro turno
function s.start_hand_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_DECK) then
        Duel.DisableShuffleCheck()
        Duel.SendtoHand(c,nil,REASON_RULE)
        -- Opcional: Se quiser manter o deck com 5 cartas na mão inicial (padrão)
        -- você pode adicionar um comando para devolver outra carta aleatória para o deck
    end
end

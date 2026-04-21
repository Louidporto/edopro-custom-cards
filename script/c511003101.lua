-- ID da carta: 511003101
local s,id=GetID()

function s.initial_effect(c)
    -- 1. Forçar a carta a ficar sempre no fundo do Deck
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADJUST) 
    e1:SetRange(LOCATION_DECK)
    e1:SetOperation(s.stay_bottom_op)
    c:RegisterEffect(e1)

    -- 2. Substituição: Se chegar na mão, sai e puxa outra
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetOperation(s.replace_op)
    c:RegisterEffect(e2)
end

-- Função para manter no fundo
function s.stay_bottom_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- Usamos c:GetSequence() em vez de Duel.GetSequence(c)
    -- No deck, a sequência 0 é o fundo. Se ela não estiver na posição 0, movemos para lá.
    if c:GetSequence() ~= 0 then 
        Duel.MoveSequence(c,0) 
    end
end

-- Função para substituir ao puxar
function s.replace_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- Verificamos se a carta entrou na mão (LOCATION_HAND)
    if c:IsLocation(LOCATION_HAND) then
        Duel.DisableShuffleCheck()
        -- Move a carta de volta para o fundo do deck em vez de remover (mais seguro para o jogo não crashar)
        Duel.SendtoDeck(c,nil,SEQ_DEEP,REASON_RULE)
        -- Compra uma nova carta
        Duel.Draw(tp,1,REASON_RULE)
    end
end

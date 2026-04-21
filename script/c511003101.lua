-- ID da carta: 511003101 (Ghost Filler - Silent Version)
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
    -- Posição 0 é o topo, posição 1 é o fundo absoluto
    if Duel.GetSequence(c) ~= 0 then return end -- Se não estiver no topo, não faz nada
    
    Duel.DisableShuffleCheck()
    Duel.MoveSequence(c,1) 
end

-- Função para substituir ao puxar
function s.replace_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_HAND) then
        Duel.DisableShuffleCheck()
        -- Envia para fora do jogo (Exile) para não ocupar espaço no cemitério
        Duel.Remove(c,POS_FACEUP,REASON_RULE)
        -- Compra a próxima carta real do deck
        Duel.Draw(tp,1,REASON_RULE)
    end
end

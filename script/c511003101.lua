
local s,id=GetID()

function s.initial_effect(c)
    -- Efeito para sumir ao ser adicionada à mão (comprada ou buscada)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_HAND)
    e1:SetOperation(s.disappear_op)
    c:RegisterEffect(e1)
end

-- Função de operação (fora do initial_effect)
function s.disappear_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- Remove do jogo (Exile) de forma silenciosa
    Duel.Remove(c,POS_FACEUP,REASON_RULE) 
end

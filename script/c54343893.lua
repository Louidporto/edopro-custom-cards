local s,id=GetID()
function s.initial_effect(c)
    -- Efeito de Campo: Monitora a primeira carta que entra na mão
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_TO_HAND) 
    e0:SetRange(LOCATION_DECK)
    e0:SetCondition(s.force_hand_con)
    e0:SetOperation(s.force_hand_op)
    Duel.RegisterEffect(e0,0) -- Registra diretamente no Duelo, não na carta

    -- Special Summon Original
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
end

function s.force_hand_con(e,tp,eg,ep,ev,re,r,rp)
    -- Se o duelo começou e eu ainda estou no deck
    return Duel.GetTurnCount()==0 and e:GetHandler():IsLocation(LOCATION_DECK)
end

function s.force_hand_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p=c:GetControler()
    -- Pega as cartas que acabaram de ser compradas
    local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
    if #g>0 and c:IsLocation(LOCATION_DECK) then
        Duel.DisableShuffleCheck()
        -- Pega a primeira carta da mão e troca pelo Vice Dragon
        local tc=g:GetFirst()
        Duel.SendtoDeck(tc,nil,2,REASON_RULE)
        Duel.SendtoHand(c,nil,REASON_RULE)
        e:Reset() -- Mata o efeito para não repetir
    end
end

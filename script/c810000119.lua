-- ID da carta: 810000119
local s,id=GetID()

function s.initial_effect(c)
    -- 1. Forçar a carta a ficar sempre no fundo do Deck
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADJUST) -- Checa constantemente o estado do jogo
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

function s.stay_bottom_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetDecktopGroup(tp,1)
    -- Se ela estiver no topo (seria a próxima a ser puxada), joga pra baixo
    if g:IsContains(c) then
        Duel.MoveSequence(c,1)
    end
end

function s.replace_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_HAND) then
        Duel.DisableShuffleCheck()
        -- Remove do jogo de forma "invisível"
        Duel.Remove(c,POS_FACEUP,REASON_RULE)
        -- Faz o jogador comprar a carta que agora está no topo
        Duel.Draw(tp,1,REASON_RULE)
    end
end


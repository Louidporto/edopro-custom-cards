-- ID da carta: 511003101 (Ghost Filler)
local s,id=GetID()

function s.initial_effect(c)
    -- 1. Efeito de Automação: Manter sempre no fundo (Passivo)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADJUST) 
    e1:SetRange(LOCATION_DECK)
    e1:SetOperation(s.stay_bottom_op)
    c:RegisterEffect(e1)

    -- 2. Efeito de Substituição Instantânea (Se for comprada ou adicionada)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetOperation(s.replace_op)
    c:RegisterEffect(e2)
end

-- Operação: Garante que a carta seja o último endereço do Deck
function s.stay_bottom_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- No EDOPro, SEQ_DEEP ou 0 é o fundo do deck.
    if c:GetSequence() ~= 0 then
        Duel.DisableShuffleCheck()
        Duel.MoveSequence(c, 0)
    end
end

-- Operação: O "Fantasma" desaparece e te dá uma carta real
function s.replace_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- Se a carta tocar a mão por qualquer motivo (compra, efeito, etc)
    if c:IsLocation(LOCATION_HAND) then
        Duel.DisableShuffleCheck()
        
        -- 1. Manda de volta para o fundo do deck imediatamente
        Duel.SendtoDeck(c, nil, SEQ_DEEP, REASON_RULE)
        
        -- 2. Compra uma nova carta para substituir o espaço
        -- Se não houver mais cartas no deck, o duelo segue (evita crash)
        if Duel.IsPlayerCanDraw(tp, 1) then
            Duel.Draw(tp, 1, REASON_RULE)
        end
        
        -- 3. Mensagem no Log para avisar que o Fantasma agiu
        Duel.Hint(HINT_CARD, 0, id)
    end
end

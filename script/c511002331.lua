--Cyber Ouroboros (Anime)
local s, id = GetID()
function s.initial_effect(c)
    -- Efeito de desenhar carta ao ser removido do jogo
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0)) -- Descrição do efeito
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_REMOVE)
    e1:SetCountLimit(1, id) -- Limita a uma vez por instância
    e1:SetCost(s.cost) -- Define o custo para ativar o efeito
    e1:SetTarget(s.target) -- Define o alvo do efeito
    e1:SetOperation(s.operation) -- Define a operação do efeito
    c:RegisterEffect(e1)
end

-- Definição do custo do efeito
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil) end
    Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD)
end

-- Definição do alvo do efeito
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsPlayerCanDraw(tp, 1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

-- Operação do efeito
function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Draw(p, d, REASON_EFFECT)
end
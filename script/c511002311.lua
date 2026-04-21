-- Red Giant (Anime)
local s, id = GetID()

function s.initial_effect(c)
    -- Invocação Especial ao baixar Magias
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SSET)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
end

-- Filtro: Verifica se o que foi baixado é uma Magia
function s.filter(c)
    return c:IsType(TYPE_SPELL)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    -- eg contém as cartas que foram baixadas (Set)
    return eg:IsExists(s.filter, 1, nil)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
        and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) ~= 0 then
        -- Encerra a Battle Phase obrigatoriamente (como no anime)
        Duel.SkipPhase(Duel.GetTurnPlayer(), PHASE_BATTLE, RESET_PHASE + PHASE_BATTLE, 1)
    end
end

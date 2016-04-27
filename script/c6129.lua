--Scripted by Eerie Code
--Mahad the Protector Priest
function c6129.initial_effect(c)
--Special Summon (self)
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(6129,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e1:SetCode(EVENT_TO_HAND)
e1:SetCondition(c6129.drcon)
e1:SetCost(c6129.drcost)
e1:SetTarget(c6129.drtg)
e1:SetOperation(c6129.drop)
c:RegisterEffect(e1)
--Double ATK
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_SINGLE)
e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
e2:SetRange(LOCATION_MZONE)
e2:SetCode(EFFECT_SET_ATTACK_FINAL)
e2:SetCondition(c6129.atkcon)
e2:SetValue(c6129.atkval)
c:RegisterEffect(e2)
--Special SUmmon (DM)
local e4=Effect.CreateEffect(c)
e4:SetDescription(aux.Stringid(6129,1))
e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e4:SetCode(EVENT_DESTROYED)
e4:SetProperty(EFFECT_FLAG_DELAY)
e4:SetCondition(c6129.spcon)
e4:SetTarget(c6129.sptg)
e4:SetOperation(c6129.spop)
c:RegisterEffect(e4)
end

function c6129.drcon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsReason(REASON_DRAW)
end
function c6129.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
if chk==0 then return not c:IsPublic() end
Duel.ConfirmCards(1-tp,c)
end
function c6129.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c6129.drop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
end

function c6129.atkcon(e)
	local bc=e:GetHandler():GetBattleTarget()
    return (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL) and bc and bc:IsFaceup() and bc:IsAttribute(ATTRIBUTE_DARK)
end
function c6129.atkval(e,c)
return e:GetHandler():GetAttack()*2
end

function c6129.spcon(e,tp,eg,ep,ev,re,r,rp)
return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c6129.spfil(c,e,tp)
return c:IsCode(46986414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6129.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c6129.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c6129.spop(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local g=Duel.SelectMatchingCard(tp,c6129.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
if g:GetCount()>0 then
Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end
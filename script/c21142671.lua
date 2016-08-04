--Scripted by Eerie Code
--Red Nova
function c21142671.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21142671)
	e1:SetCondition(c21142671.spcon)
  c:RegisterEffect(e1)
  --Special Summon FIRE
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(21142671,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BE_MATERIAL)
  e2:SetCondition(c21142671.syncon)
  e2:SetTarget(c21142671.syntg)
  e2:SetOperation(c21142671.synop)
  c:RegisterEffect(e2)
end

function c21142671.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsLevelAbove(8)
end
function c21142671.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21142671.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function c21142671.syncon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():GetMaterial():FilterCount(Card.IsType,nil,TYPE_TUNER)>=2
end
function c21142671.synfil(c,e,tp)
  return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21142671.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21142671.synfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c21142671.synop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c21142671.synfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
  end
end

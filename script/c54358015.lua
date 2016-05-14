--銀河影竜
--Galaxy Stealth Dragon
--Scripted by Eerie Code
function c54358015.initial_effect(c)
  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),4,2)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54358015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c54358015.spcost)
	e1:SetTarget(c54358015.sptg)
	e1:SetOperation(c54358015.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c54358015.target)
	e2:SetValue(c54358015.indval)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end

function c54358015.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c54358015.spfil(c,e,tp)
  return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c54358015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c54358015.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c54358015.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c54358015.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end

function c54358015.target(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x7b)
end
function c54358015.indval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
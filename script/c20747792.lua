--Scripted by Eerie Code
--Berry Magician Girl
function c20747792.initial_effect(c)
  --Search
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20747792,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c20747792.thtg)
	e3:SetOperation(c20747792.thop)
	c:RegisterEffect(e3)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20747792,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c20747792.sptg)
	e1:SetOperation(c20747792.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCondition(c20747792.spcon)
	c:RegisterEffect(e2)
end

function c20747792.thfilter(c)
	return (c:IsSetCard(0x20a2) or c:IsSetCard(0x30a2)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c20747792.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20747792.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20747792.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20747792.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c20747792.spcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and eg:IsContains(e:GetHandler())
end
function c20747792.spfil(c,e,tp)
  return (c:IsSetCard(0x20a2) or c:IsSetCard(0x30a2)) and not c:IsCode(20747792) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20747792.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c20747792.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c20747792.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then return end
  if Duel.ChangePosition(c,POS_FACEUP_DEFENCE,POS_FACEDOWN_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20747792.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
  end
end
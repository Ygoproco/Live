--Kozmo Fearful Lion
--Scripted by Eerie Code
function c6982.initial_effect(c)
  local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6982,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,6982)
	e1:SetCost(c6982.spcost)
	e1:SetTarget(c6982.sptg)
	e1:SetOperation(c6982.spop)
	c:RegisterEffect(e1)
	--Return
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c6982.tgcost)
	e2:SetTarget(c6982.tgtg)
	e2:SetOperation(c6982.tgop)
	c:RegisterEffect(e2)
end

function c6982.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c6982.spfilter(c,e,tp)
	return c:IsSetCard(0xd2) and c:IsLevelAbove(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6982.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c6982.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c6982.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6982.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c6982.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c6982.tgfil(c)
  return c:IsSetCard(0xd2) and c:IsType(TYPE_MONSTER)
end
function c6982.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c6982.tgfil(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c6982.tgfil,tp,LOCATION_REMOVED,0,3,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(6982,2))
	local g=Duel.SelectTarget(tp,c6982.tgfil,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c6982.tgop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  if tg:GetCount()==3 and Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)==3 then
	Duel.Damage(1-tp,500,REASON_EFFECT)
  end
end
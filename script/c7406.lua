--Ｄ－ＨＥＲＯ ダークエンジェル
--Destiny HERO - Dark Angel
--Scripted by Eerie Code
function c7406.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7406,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c7406.spcon)
	e1:SetCost(c7406.spcost)
	e1:SetTarget(c7406.sptg)
	e1:SetOperation(c7406.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7406,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetOperation(c7406.negop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7406,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c7406.tdcon)
	e3:SetCost(c7406.tdcost)
	e3:SetTarget(c7406.tdtg)
	e3:SetOperation(c7406.tdop)
	c:RegisterEffect(e3)
end

function c7406.spcfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008)
end
function c7406.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c7406.spcfil,tp,LOCATION_GRAVE,0,nil)>=2
end
function c7406.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c7406.spfil(c,e,tp)
	return c:IsSetCard(0xc008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENCE,1-tp)
end
function c7406.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7406.spfil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c7406.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c7406.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c7406.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_DEFENCE)
	end
end

function c7406.negop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev) then
		Duel.Hint(HINT_CARD,0,7406)
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	end
end

function c7406.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c7406.tdcfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008) and c:IsAbleToRemoveAsCost()
end
function c7406.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c7406.tdcfil,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c7406.tdcfil,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c7406.tdfil(c)
	return c:GetType()==TYPE_SPELL
end
function c7406.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7406.tdfil,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c7406.tdfil,tp,0,LOCATION_DECK,1,nil) end
end
function c7406.tdop(e,tp,eg,ep,ev,re,r,rp)
	local dg1=Duel.GetMatchingGroup(c7406.tdfil,tp,LOCATION_DECK,0,nil)
	local dg2=Duel.GetMatchingGroup(c7406.tdfil,1-tp,LOCATION_DECK,0,nil)
	if dg1:GetCount()==0 or dg2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(7406,3))
	local g1=dg1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(7406,3))
	local g2=dg2:Select(1-tp,1,1,nil)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1 then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc1,0)
		Duel.ConfirmDecktop(tp,1)
	end
	if tc2 then
		Duel.ShuffleDeck(1-tp)
		Duel.MoveSequence(tc2,0)
		Duel.ConfirmDecktop(1-tp,1)
	end
end

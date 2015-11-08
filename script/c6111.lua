--Scripted by Eerie Code
--Priestess with Eyes of Blue
function c6111.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6111,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,6111)
	e1:SetCondition(c6111.thcon)
	e1:SetCost(c6111.thcost)
	e1:SetTarget(c6111.thtg)
	e1:SetOperation(c6111.thop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,6111)
	e2:SetTarget(c6111.tdtg)
	e2:SetOperation(c6111.tdop)
	c:RegisterEffect(e2)
end

function c6111.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c)
end
function c6111.costfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsAbleToGraveAsCost()
end
function c6111.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6111.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6111.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c6111.thfilter(c)
	return c:IsSetCard(0xe0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c6111.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6111.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c6111.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6111.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(6111,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end

function c6111.tdfilter(c)
	return c:IsSetCard(0xe0) and c:IsAbleToDeck()
end
function c6111.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c6111.tdfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c6111.tdfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c6111.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c6111.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

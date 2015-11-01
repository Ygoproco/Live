--Scripted by Eerie Code
--Super Quantum Mecha Pilot Blue Layer
function c6556.initial_effect(c)
	--Search
	local e1a=Effect.CreateEffect(c)
	e1a:SetDescription(aux.Stringid(6556,0))
	e1a:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1a:SetCode(EVENT_SUMMON_SUCCESS)
	e1a:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1a:SetCountLimit(1,6556)
	e1a:SetTarget(c6556.thtg)
	e1a:SetOperation(c6556.thop)
	c:RegisterEffect(e1a)
	local e1b=e1a:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	--Back to Deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,6556+1)
	e2:SetCondition(c6556.tdcon)
	e2:SetTarget(c6556.tdtg)
	e2:SetOperation(c6556.tdop)
	c:RegisterEffect(e2)
end

function c6556.thfilter(c)
	return c:IsSetCard(0xdd) and not c:IsCode(6556) and c:IsAbleToHand()
end
function c6556.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6556.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c6556.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6556.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c6556.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c6556.tdfil(c)
	return c:IsSetCard(0xdd) and c:IsAbleToDeck()
end
function c6556.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6556.tdfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6556.tdfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c6556.tdfil,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c6556.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
end
--方界業
--Cubic Karma
--Scripted by Eerie Code
function c9659580.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9659580.target)
	e1:SetOperation(c9659580.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c9659580.hvcon)
	e2:SetTarget(c9659580.hvtg)
	e2:SetOperation(c9659580.hvop)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c9659580.thcost)
	e3:SetTarget(c9659580.thtg)
	e3:SetOperation(c9659580.thop)
	c:RegisterEffect(e3)
end

function c9659580.fil(c)
	return c:IsFaceup() and c:IsSetCard(0xe3) and not c:IsCode(15610297)
end
function c9659580.cfil(c)
	return c:IsCode(15610297) and c:IsAbleToGrave()
end
function c9659580.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9659580.fil(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c9659580.fil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c9659580.cfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9659580,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c9659580.fil,tp,LOCATION_MZONE,0,1,1,nil)
	else
		e:SetProperty(0)
	end
end
function c9659580.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local tgg=Duel.GetMatchingGroup(c9659580.cfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if tgg:GetCount()==0 then return end
	local sg=tgg:Select(tp,1,tgg:GetCount(),nil)
	local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
	if ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800*ct)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end

function c9659580.hvcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xe3) and re:IsActiveType(TYPE_MONSTER) and eg and eg:IsExists(Card.IsCode,1,nil,15610297) and Duel.GetTurnPlayer()~=tp
end
function c9659580.hvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c9659580.hvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)>0 then
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	end
end

function c9659580.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c9659580.thfilter(c)
	return c:IsSetCard(0xe3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9659580.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9659580.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9659580.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9659580.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
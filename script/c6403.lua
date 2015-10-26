--Scripted by Eerie Code
--Exod Flame
function c6403.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c6403.target1)
	e1:SetOperation(c6403.operation)
	c:RegisterEffect(e1)
	--To hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6403,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c6403.cost)
	e2:SetTarget(c6403.target2)
	e2:SetOperation(c6403.operation)
	c:RegisterEffect(e2)
	--To hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(6403,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c6403.thcon)
	e5:SetCost(c6403.cost)
	e5:SetTarget(c6403.thtg)
	e5:SetOperation(c6403.thop)
	c:RegisterEffect(e5)
end

function c6403.filter1(c)
	return c:IsAbleToHand()
end
function c6403.filter2(c)
	return ((c:IsSetCard(0x40) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0xde)) and c:IsAbleToGraveAsCost()
end
function c6403.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c6403.filter1(chkc) end
	if chk==0 then return true end
	local b=Duel.IsExistingTarget(c6403.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c6403.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	local op=0
	if b and Duel.SelectYesNo(tp,aux.Stringid(6403,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c6403.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		Duel.RegisterFlagEffect(tp,6403,RESET_PHASE+PHASE_END,0,1)
	end
	e:SetLabel(op)
end
function c6403.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6403.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c6403.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,6403)==0 end
	Duel.RegisterFlagEffect(tp,6403,RESET_PHASE+PHASE_END,0,1)
end
function c6403.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c6403.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6403.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c6403.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c6403.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	e:SetLabel(1)
end

function c6403.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c6403.thfil(c)
	return ((c:IsSetCard(0x40) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0xde)) and c:IsAbleToHand()
end
function c6403.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6403.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6403.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c6403.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c6403.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

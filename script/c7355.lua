--花積み
--Hanazumi
--Scripted by Eerie Code
function c7355.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c7355.tg)
	e1:SetOperation(c7355.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,7355)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c7355.thcost)
	e2:SetTarget(c7355.thtg)
	e2:SetOperation(c7355.thop)
	c:RegisterEffect(e2)
end

function c7355.fil(c)
	return c:IsSetCard(0xe6) and c:IsType(TYPE_MONSTER)
end
function c7355.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7355.fil,tp,LOCATION_DECK,0,3,nil) end
end
function c7355.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c7355.fil,tp,LOCATION_DECK,0,3,3,nil)
	if g:GetCount()==3 then
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		while tc do
			Duel.MoveSequence(tc,0)
			tc=g:GetNext()
		end
		Duel.SortDecktop(tp,tp,3)
	end
end

function c7355.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c7355.thfil(c)
	return c7355.fil(c) and c:IsAbleToHand()
end
function c7355.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7355.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7355.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c7355.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c7355.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

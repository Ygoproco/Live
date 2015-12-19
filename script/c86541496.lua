--Scripted by Eerie Code
--Left Arm Offering
function c86541496.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c86541496.condition)
	e1:SetCost(c86541496.cost)
	e1:SetTarget(c86541496.target)
	e1:SetOperation(c86541496.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SSET)
	e2:SetRange(0xff)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c86541496.countercon)
	e2:SetOperation(c86541496.counterop)
	c:RegisterEffect(e2)
end

function c86541496.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler())>=2
end
function c86541496.cfilter(c)
	return not c:IsAbleToRemoveAsCost()
end
function c86541496.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(c86541496.cfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():GetFlagEffect(86541496)==0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c86541496.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c86541496.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c86541496.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c86541496.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c86541496.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c86541496.countercon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c86541496.counterop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(86541496,RESET_PHASE+PHASE_END,0,1)
end
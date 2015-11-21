--Scripted by Eerie Code
--Angmar the Demon Monarch
function c6699.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6699,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c6699.condition)
	e1:SetCost(c6699.cost)
	e1:SetTarget(c6699.target)
	e1:SetOperation(c6699.operation)
	c:RegisterEffect(e1)
end

function c6699.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c6699.fil1(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c6699.fil2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c6699.fil2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c6699.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6699.fil1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c6699.fil1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		e:SetLabel(tc:GetCode())
		Duel.Remove(tc,nil,REASON_COST)
	end
end
function c6699.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6699.fil2,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c6699.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c6699.fil2,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,g)
	end
end
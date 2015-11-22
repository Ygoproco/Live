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
	if c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() then
		local g=Duel.GetMatchingGroup(c6699.fil2,tp,LOCATION_DECK,0,nil,c:GetCode())
		return g:GetCount()>0
	else
		return false
	end
end
function c6699.fil2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c6699.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c6699.fil1,tp,LOCATION_GRAVE,0,1,nil,tp) 
		--return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c6699.fil1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c6699.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.IsExistingMatchingCard(c6699.fil2,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) then
			return true
		else
			return false
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c6699.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6699.fil2,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,g)
	end
end
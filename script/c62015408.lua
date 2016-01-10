--Scripted by Eerie Code
--Floating Ghost & Cherry Blossom
function c62015408.initial_effect(c)
	--Banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,62015408)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_SPSUMMON)
	e1:SetCondition(c62015408.condition)
	e1:SetCost(c62015408.cost)
	e1:SetOperation(c62015408.operation)
	c:RegisterEffect(e1)
end

function c62015408.rvfilter(c)
	return not c:IsPublic()
end
function c62015408.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) and Duel.IsExistingMatchingCard(c62015408.rvfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0
end
function c62015408.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c62015408.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,c62015408.rvfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(tp,g)
		local tg=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_EXTRA,nil,sg:GetFirst():GetCode())
		if tg:GetCount()>0 then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
end

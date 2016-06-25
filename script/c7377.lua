--竜星の九支
--Nine Branches of the Yang Zing
--Scripted by Eerie Code
function c7377.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c7377.condition)
	e1:SetTarget(c7377.target)
	e1:SetOperation(c7377.activate)
	c:RegisterEffect(e1)
end

function c7377.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c7377.desfil(c)
	return c:IsFaceup() and c:IsSetCard(0x9e) and c:IsDestructable()
end
function c7377.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7377.desfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
end
function c7377.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c7377.desfil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end

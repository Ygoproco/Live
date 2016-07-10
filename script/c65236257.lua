--創星の因子
--Genesis Tellarknight
--Scripted by DiabladeZat
function c65236257.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65236257.target)
	e1:SetOperation(c65236257.activate)
	c:RegisterEffect(e1)
end
function c65236257.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c65236257.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9c)
end
function c65236257.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c65236257.cfilter,tp,LOCATION_ONFIELD,0,c)
		e:SetLabel(ct)
		return Duel.IsExistingMatchingCard(c65236257.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,c)
	end
	local ct=e:GetLabel()
	local sg=Duel.GetMatchingGroup(c65236257.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,ct,0,0)
end
function c65236257.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c65236257.cfilter,tp,LOCATION_ONFIELD,0,c)
	local g=Duel.GetMatchingGroup(c65236257.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if g:GetCount()>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

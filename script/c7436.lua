--背徳の堕天使
--Darklords Falling from Grace
--Scripted by Eerie Code
function c7436.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCountLimit(1,7436+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c7436.cost)
	e1:SetTarget(c7436.tg)
	e1:SetOperation(c7436.op)
	c:RegisterEffect(e1)
end

function c7436.cfil(c,mg)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xef) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost() and (not mg:IsContains(c) or mg:GetCount()>1)
end
function c7436.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return Duel.IsExistingMatchingCard(c7436.cfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,mg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c7436.cfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,mg)
end
function c7436.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c7436.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

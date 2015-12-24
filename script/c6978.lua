--Scripted by Eerie Code
--Friendly Fire
function c6978.initial_effect(c)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c6978.condition)
	e3:SetTarget(c6978.target)
	e3:SetOperation(c6978.activate)
	c:RegisterEffect(e3)
end

function c6978.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c6978.filter(c,hc)
	return c~=hc and c:IsDestructable()
end
function c6978.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=eg:GetFirst()
	if chkc then return chkc:IsOnField() and chkc~=eg and c6978.filter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(c6978.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ec,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,c6978.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,ec,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c6978.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
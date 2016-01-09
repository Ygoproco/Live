--Scripted by Eerie Code
--Unwavering Bonds
function c72648810.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c72648810.condition)
	e1:SetTarget(c72648810.target)
	e1:SetOperation(c72648810.activate)
	c:RegisterEffect(e1)
end
function c72648810.condition(e,tp,eg,ep,ev,re,r,rp)
	--local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	--return rp~=tp and ((re:GetHandler():IsType(TYPE_PENDULUM) and tl==LOCATION_MZONE) or (tl==LOCATION_PZONE and not re:IsHasType(EFFECT_TYPE_ACTIVATE))) and Duel.IsChainNegatable(ev)
	local rc=re:GetHandler()
	--return rp~=tp and ((rc:IsLocation(LOCATION_MZONE) and rc:IsType(TYPE_PENDULUM)) or (rc:IsLocation(LOCATION_PZONE) and not re:IsHasType(EFFECT_TYPE_ACTIVATE))) and Duel.IsChainNegatable(ev)
	--Debug.Message("Location: " .. rc:GetLocation())
	--Debug.Message("Triggering location: " .. Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION))
	--Debug.Message("Original type: " .. rc:GetOriginalType())
	if rc:IsLocation(LOCATION_MZONE) then
		return rp~=tp and rc:IsType(TYPE_PENDULUM) and Duel.IsChainNegatable(ev)
	else
		return rp~=tp and bit.band(rc:GetOriginalType(),TYPE_PENDULUM)~=0 and not re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
	end
end
function c72648810.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c72648810.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

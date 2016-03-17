--Scripted by Eerie Code
--Magical Cavalry of Cxulub
function c6999.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c6999.immval)
	c:RegisterEffect(e7)
end

function c6999.immval(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated() and not te:GetOwner():IsType(TYPE_PENDULUM)
end

--Scripted by Eerie Code
--The Great Mara Monarch
function c90122655.initial_effect(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c90122655.chaincon)
	e1:SetOperation(c90122655.chainop)
	c:RegisterEffect(e1)
end

function c90122655.chaincon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(rc:GetSummonType(),SUMMON_TYPE_NORMAL)~=0
end
function c90122655.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c90122655.chainlm)
end
function c90122655.chainlm(e,rp,tp)
	return tp==rp
end
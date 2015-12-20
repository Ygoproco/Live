--Scripted by Eerie Code
--The Great Mara Monarch
function c6938.initial_effect(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c6938.chainop)
	c:RegisterEffect(e1)
end

function c6938.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if bit.band(rc:GetSummonType(),SUMMON_TYPE_NORMAL)>0 then
		Duel.SetChainLimit(c52738610.chainlm)
	end
end
function c6938.chainlm(e,rp,tp)
	return tp==rp
end
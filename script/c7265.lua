--機械天使の儀式
--Machine Angel Ritual
--Scripted by Eerie Code
function c7265.initial_effect(c)
  aux.AddRitualProcGreater(c,c7265.ritual_filter)
  --destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c7265.reptg)
	e2:SetValue(c7265.repval)
	e2:SetOperation(c7265.repop)
	c:RegisterEffect(e2)
end

function c7265.ritual_filter(c)
  return c:IsSetCard(0x2093) and bit.band(c:GetType(),0x81)==0x81
end

function c7265.repfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c7265.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c7265.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(7265,0))
end
function c7265.repval(e,c)
	return c7265.repfilter(c,e:GetHandlerPlayer())
end
function c7265.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
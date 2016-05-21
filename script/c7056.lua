--マグネット・フォース
--Magnet Force
--Scripted by Eerie Code
function c7056.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c7056.activate)
	c:RegisterEffect(e1)
end

function c7056.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c7056.indtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c7056.indval)
	Duel.RegisterEffect(e1,tp)
end
function c7056.indtg(e,c)
	local ot=c:GetOriginalRace()
	return bit.band(ot,RACE_MACHINE+RACE_ROCK)~=0
end
function c7056.indval(e,te)
	return te:GetOwner()~=e:GetOwner()
end

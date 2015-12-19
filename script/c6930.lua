--Dinomist Spinos
--Scripted by TNDMPT Group (ShirayukiCleber, Vinny41, FramDzi)
function c6930.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c6930.reptg)
	e2:SetValue(c6930.repval)
	e2:SetOperation(c6930.repop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c6930.tribute)
	e3:SetOperation(c6930.operation)
	c:RegisterEffect(e3)
end
function c6930.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0xd8)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c6930.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c6930.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(6930,0))
end
function c6930.repval(e,c)
	return c6930.repfilter(c,e:GetHandlerPlayer())
end
function c6930.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c6930.tribute(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0xd8) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0xd8)
	Duel.Release(g,REASON_COST)
end
function c6930.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local opt=Duel.SelectOption(tp,aux.Stringid(6930,1),aux.Stringid(6930,2))
	if opt==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		e:GetHandler():RegisterEffect(e1)
	end
end
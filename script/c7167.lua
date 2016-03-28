--半魔導帯域
--Semi Spell Zone
--Script by dest
function c7167.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c7167.condition)
	c:RegisterEffect(e1)
	--indes/target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c7167.indcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c7167.tgvalue)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c7167.tgoval)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(c7167.tgovalue)
	c:RegisterEffect(e5)
	--cannot set/activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SSET)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_FZONE,0)
	e6:SetTarget(c7167.cnfil1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetTarget(c7167.cnfil2)
	c:RegisterEffect(e7)
end
function c7167.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and not Duel.CheckPhaseActivity()
end
function c7167.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c7167.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c7167.tgoval(e,re,rp)
	return rp~=1-e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end
function c7167.tgovalue(e,re,rp)
	return rp~=1-e:GetHandlerPlayer()
end

function c7167.cnfil1(e,re,tp)
	return re:IsType(TYPE_FIELD)
end
function c7167.cnfil2(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
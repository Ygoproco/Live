--Scripted by Eerie Code
--Amorphage Cavum
function c6927.initial_effect(c)
	--Pendulum Summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_ACTIVATE)
	e9:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e9)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(6927,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCondition(c6927.descon)
	e4:SetTarget(c6927.destg)
	e4:SetOperation(c6927.desop)
	c:RegisterEffect(e4)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c6927.chaincon)
	e3:SetOperation(c6927.chainop)
	c:RegisterEffect(e3)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c6927.splimit)
	e2:SetCondition(c6927.spcon)
	c:RegisterEffect(e2)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c6927.spop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c6927.pdcon)
	e0:SetOperation(c6927.spop)
	c:RegisterEffect(e0)
end

function c6927.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c6927.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK) end
	if not Duel.CheckReleaseGroup(tp,nil,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c6927.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,aux.Stringid(6927,1)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_EFFECT)
	else Duel.Destroy(c,REASON_EFFECT) end
end

function c6927.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe2)
end
function c6927.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c6927.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c6927.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(aux.FALSE)
end

function c6927.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe2) and c:IsLocation(LOCATION_EXTRA)
end
function c6927.pdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM 
end
function c6927.spop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(6927,RESET_EVENT+0x1fe0000,0,1)
end
function c6927.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(6927)>0
end
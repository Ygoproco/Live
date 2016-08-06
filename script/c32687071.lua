--Scripted by Eerie Code
--Amorphage Nortes
function c32687071.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32687071,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCondition(c32687071.descon)
	e4:SetOperation(c32687071.desop)
	c:RegisterEffect(e4)
	--disable search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e3:SetCondition(c32687071.accon)
	c:RegisterEffect(e3)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c32687071.splimit)
	c:RegisterEffect(e2)
end

function c32687071.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c32687071.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK) end
	if not Duel.CheckReleaseGroup(tp,nil,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c32687071.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,aux.Stringid(32687071,1)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_EFFECT)
	else Duel.Destroy(c,REASON_RULE) end
end

function c32687071.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c32687071.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c32687071.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c32687071.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe0) and c:IsLocation(LOCATION_EXTRA)
end
function c32687071.pdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM 
end
function c32687071.spop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(32687071,RESET_EVENT+0x1fe0000,0,1)
end
function c32687071.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(32687071)>0
end
--Scripted by Eerie Code
--Amorphage Irritum
function c69072185.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69072185,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCondition(c69072185.descon)
	e4:SetOperation(c69072185.desop)
	c:RegisterEffect(e4)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetCondition(c69072185.chaincon)
	e3:SetTarget(c69072185.rmtarget)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c69072185.splimit)
	c:RegisterEffect(e2)
end

function c69072185.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c69072185.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK) end
	if not Duel.CheckReleaseGroup(tp,nil,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c69072185.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,aux.Stringid(69072185,1)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_EFFECT)
	else Duel.Destroy(c,REASON_RULE) end
end

function c69072185.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c69072185.chaincon(e)
	return Duel.IsExistingMatchingCard(c69072185.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c69072185.rmtarget(e,c)
	return not c:IsSetCard(0xe0)
end

function c69072185.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe0) and c:IsLocation(LOCATION_EXTRA)
end
--Scripted by Eerie Code
--Amorphage Hyper
function c6929.initial_effect(c)
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
	e4:SetDescription(aux.Stringid(6929,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCondition(c6929.descon)
	e4:SetTarget(c6929.destg)
	e4:SetOperation(c6929.desop)
	c:RegisterEffect(e4)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c6929.chaincon)
	e3:SetValue(c6929.damval)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3b)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c6929.splimit)
	e2:SetCondition(c6929.spcon)
	c:RegisterEffect(e2)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c6929.spop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c6929.pdcon)
	e0:SetOperation(c6929.spop)
	c:RegisterEffect(e0)
end

function c6929.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c6929.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK) end
	if not Duel.CheckReleaseGroup(tp,nil,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c6929.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,aux.Stringid(6929,1)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_EFFECT)
	else Duel.Destroy(c,REASON_EFFECT) end
end

function c6929.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end

function c6929.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe2)
end
function c6929.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c6929.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c6929.rllimit(e,c)
	return not c:IsSetCard(0xe2)
end

function c6929.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe2) and c:IsLocation(LOCATION_EXTRA)
end
function c6929.pdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM 
end
function c6929.spop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(6929,RESET_EVENT+0x1fe0000,0,1)
end
function c6929.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(6929)>0
end
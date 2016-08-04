--イカサマ御法度
--No Cheaters Allowed
--Scripted by Eerie Code
function c7370.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c7370.tg)
	e1:SetOperation(c7370.thop)
	c:RegisterEffect(e1)
	--Send to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(c7370.thcost)
	e2:SetTarget(c7370.thtg)
	e2:SetOperation(c7370.thop)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_TOGRAVE)
	e3:SetCondition(c7370.sdcon)
	c:RegisterEffect(e3)
end

function c7370.cfil(c,tp)
	return c:GetSummonPlayer()==tp and bit.band(c:GetSummonLocation(),LOCATION_HAND)~=0 and c:IsLocation(LOCATION_MZONE)
end
function c7370.thfil(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and bit.band(c:GetSummonLocation(),LOCATION_HAND)~=0 and c:IsAbleToHand()
end
function c7370.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and eg and eg:IsExists(c7370.cfil,1,nil,tp) and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_TOHAND)
		e:GetHandler():RegisterFlagEffect(7370,RESET_PHASE+PHASE_END,0,1)
		e:SetLabel(1)
		local g=Duel.GetMatchingGroup(c7370.thfil,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	else
		e:SetCategory(0)
		e:SetLabel(0)
	end
end
function c7370.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c7370.thfil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

function c7370.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(7370)==0 end
	e:GetHandler():RegisterFlagEffect(7370,RESET_PHASE+PHASE_END,0,1)
end
function c7370.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg and eg:IsExists(c7370.cfil,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c7370.thfil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end

function c7370.sdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe6) and c:IsType(TYPE_SYNCHRO)
end
function c7370.sdcon(e)
	return not Duel.IsExistingMatchingCard(c7370.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

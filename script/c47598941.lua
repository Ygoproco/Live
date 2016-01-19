--Scripted by Eerie Code
--Amorphage Lysis
function c47598941.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Decrease
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c47598941.atktg)
	e3:SetValue(c47598941.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e4)
	--Set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,47598941)
	e2:SetCondition(c47598941.pccon)
	e2:SetTarget(c47598941.pctg)
	e2:SetOperation(c47598941.pcop)
	c:RegisterEffect(e2)	
end

function c47598941.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c47598941.atktg(e,c)
	return not c:IsSetCard(0xe0)
end
function c47598941.atkval(e,c)
	return Duel.GetMatchingGroupCount(c47598941.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*-100
end

function c47598941.pcfil(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c47598941.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47598941.pcfil,1,nil,tp)
end
function c47598941.pcfilter(c)
	return c:IsSetCard(0xe0) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47598941.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) and Duel.IsExistingMatchingCard(c47598941.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c47598941.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c47598941.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

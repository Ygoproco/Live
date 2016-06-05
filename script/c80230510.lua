--埋葬されし生け贄
--Tribute Burial
--Scripted by edo9300
function c80230510.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c80230510.activate)
	c:RegisterEffect(e1)
end
function c80230510.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	if Duel.GetFlagEffect(tp,80230510)==0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(80230510,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(c80230510.target)
	e1:SetCondition(c80230510.sumcon)
	e1:SetOperation(c80230510.sumop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
	end
	Duel.RegisterFlagEffect(tp,80230510,RESET_PHASE+PHASE_END,0,Duel.GetFlagEffect(tp,80230510)+1)
end
function c80230510.target(e,c)
	local mi,ma=c:GetTributeRequirement()
	return ma==2 and mi==2
end
function c80230510.sumfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c80230510.sumcon(e,c,tp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c80230510.sumfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c80230510.sumfilter,tp,0,LOCATION_GRAVE,1,nil)
	and Duel.GetFlagEffect(tp,80230510)>Duel.GetFlagEffect(tp,80230510+1)
end
function c80230510.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g1=Duel.SelectMatchingCard(tp,c80230510.sumfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g2=Duel.SelectMatchingCard(tp,c80230510.sumfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,80230510+1,RESET_PHASE+PHASE_END,0,Duel.GetFlagEffect(tp,80230510+1)+1)
end

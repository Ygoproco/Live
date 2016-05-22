--Tribute Burial
--Scripted by edo9300
function c7059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c7059.activate)
	c:RegisterEffect(e1)
end
function c7059.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	if Duel.GetFlagEffect(tp,7059)==0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(7059,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(c7059.target)
	e1:SetCondition(c7059.sumcon)
	e1:SetOperation(c7059.sumop)
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
	Duel.RegisterFlagEffect(tp,7059,RESET_PHASE+PHASE_END,0,Duel.GetFlagEffect(tp,7059)+1)
end
function c7059.target(e,c)
	local mi,ma=c:GetTributeRequirement()
	return ma==2 and mi==2
end
function c7059.sumfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c7059.sumcon(e,c,tp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c7059.sumfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c7059.sumfilter,tp,0,LOCATION_GRAVE,1,nil)
	and Duel.GetFlagEffect(tp,7059)>Duel.GetFlagEffect(tp,7059+1)
end
function c7059.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g1=Duel.SelectMatchingCard(tp,c7059.sumfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g2=Duel.SelectMatchingCard(tp,c7059.sumfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,7059+1,RESET_PHASE+PHASE_END,0,Duel.GetFlagEffect(tp,7059+1)+1)
end

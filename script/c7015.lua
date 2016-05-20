--Super Conduction Machine Imperion Magnum
function c7015.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,75347539,7014,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c7015.discon)
	e2:SetTarget(c7015.distg)
	e2:SetOperation(c7015.disop)
	c:RegisterEffect(e2)
	
	--summon Valk and Vers
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c7014.summcnd)
	e3:SetTarget(c7014.summtg)
	e3:SetOperation(c7014.summop)
	c:RegisterEffect(e3)
end

function c7015.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c7015.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c7015.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function c7014.summfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c7014.summcnd(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT)
		and c:GetPreviousControler()==tp
end
function c7014.summtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_HAND+LOCATION_DECK) 
		and (c7014.summfilter(chkc,75347539,e,tp) or c7014.summfilter(chkc,7014,e,tp)) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and Duel.IsExistingTarget(c7014.summfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,75347539,e,tp)
		and Duel.IsExistingTarget(c7014.summfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,7014,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c7014.summfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,75347539,e,tp)
	local g2=Duel.SelectTarget(tp,c7014.summfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,7014,e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,g1:GetCount(),0,0)
end
function c7014.summop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end
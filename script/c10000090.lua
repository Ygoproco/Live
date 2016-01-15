--Scripted by Eerie Code
--The Winged Dragon of Ra - Phoenix Mode
function c10000090.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--summon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10000090,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c10000090.spcon1)
	e4:SetTarget(c10000090.sptg1)
	e4:SetOperation(c10000090.spop1)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c10000090.efilter)
	c:RegisterEffect(e5)
	--To grave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10000090,1))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c10000090.tgcost)
	e6:SetTarget(c10000090.tgtg)
	e6:SetOperation(c10000090.tgop)
	c:RegisterEffect(e6)
	--to grave
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10000090,2))
	e7:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetTarget(c10000090.sptg2)
	e7:SetOperation(c10000090.spop2)
	c:RegisterEffect(e7)
end

function c10000090.cfilter(c,tp)
	return c:IsCode(10000010) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c10000090.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c10000090.cfilter,1,nil,tp) then
		return true
	else
		--Debug.Message("Ra hasn't been sent to Grave.")
		return false
	end
end
function c10000090.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
			--Debug.Message("Insufficient zones.")
			return false
		end
	  if not e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) then
--	  Debug.Message("Cannot be summoned.")
		  return false
	  end
	  return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c10000090.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not c:IsRelateToEffect(e) then
		--Debug.Message("Unrelated to effect.")
		return
	end
	Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
end

function c10000090.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function c10000090.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c10000090.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c10000090.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function c10000090.spfil2(c,e,tp)
	return c:IsCode(10000080) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c10000090.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10000090.spfil2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10000090.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoGrave(c,REASON_EFFECT)>0 then
		local g=Duel.SelectMatchingCard(tp,c10000090.spfil2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
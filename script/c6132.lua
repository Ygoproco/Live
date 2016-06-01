--Divine Serpent Geh
function c6132.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c6132.spcon)
	e1:SetCost(c6132.spcost)
	e1:SetTarget(c6132.sptg)
	e1:SetOperation(c6132.spop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)	
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetCondition(c6132.discon)
	e3:SetTarget(c6132.distg)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e4)	
	--atk change
	local e5=e3:Clone()
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetValue(c6132.atkval)
	c:RegisterEffect(e5)
	--gain ATK
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetCondition(c6132.atkcon)
	e6:SetOperation(c6132.atkop)
	c:RegisterEffect(e6)
end
function c6132.cfilter(c,tp,rp)
	return c:IsReason(REASON_BATTLE)
		or rp~=tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c6132.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c6132.cfilter,1,nil,tp,rp)
end
function c6132.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c6132.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c6132.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end

function c6132.discon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
end
function c6132.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c6132.atkval(e,c)
	return math.ceil(e:GetHandler():GetBattleTarget():GetBaseAttack()/2)
end

function c6132.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c6132.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local tg,val = Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c):GetMaxGroup(Card.GetBaseAttack)
		if val<=0 then return end
	
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(val)
		c:RegisterEffect(e1)
	end
end
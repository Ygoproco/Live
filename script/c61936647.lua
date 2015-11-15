--Scripted by Eerie Code
--The Phantom Sword
function c61936647.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c61936647.condition)
	e1:SetTarget(c61936647.target)
	e1:SetOperation(c61936647.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c61936647.descon)
	e2:SetOperation(c61936647.desop)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,61936647)
	e3:SetCost(c61936647.spcost)
	e3:SetTarget(c61936647.sptg)
	e3:SetOperation(c61936647.spop)
	c:RegisterEffect(e3)
		--Destroy relace
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EFFECT_DESTROY_REPLACE)
		e4:SetRange(LOCATION_SZONE)
		e4:SetTarget(c61936647.reptg)
		e4:SetValue(c61936647.repval)
		e4:SetOperation(c61936647.repop)
		c:RegisterEffect(e4)
end

function c61936647.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c61936647.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c61936647.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c61936647.rcon)
		e1:SetValue(800)
		tc:RegisterEffect(e1,true)
	end
end
function c61936647.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end

function c61936647.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local tc=e:GetHandler():GetFirstCardTarget()
		if not tc then
			--Debug.Message("The card has no target.")
			return false
		else
			--Debug.Message("At least it enters here...")
		end
		if not eg:IsContains(tc) then
			--Debug.Message("The target isn't being destroyed.")
			return false
		end
		if e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) then
			--Debug.Message("The card has already been destroyed.")
			return false
		end
		return true
	end
	return Duel.SelectYesNo(tp,aux.Stringid(61936647,0))
end
function c61936647.repval(e,c)
	--return c:IsFaceup() and c:IsOnField() and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
	if not c:IsFaceup() then
		--Debug.Message("The target is not face-up.")
		return false
	end
	if not c:IsOnField() then
		--Debug.Message("The target is not on the field.")
		return false
	end
	if not c:IsReason(REASON_BATTLE+REASON_EFFECT) then
		--Debug.Message("The target is being destroyed for an invalid reason.")
		return false
	end
	return true
end
function c61936647.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

function c61936647.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_DESTROY_CONFIRMED) then return false end
	local tc=c:GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c61936647.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function c61936647.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c61936647.spfil(c,e,tp)
	return c:IsSetCard(0x10df) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c61936647.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c61936647.spfil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c61936647.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c61936647.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c61936647.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end

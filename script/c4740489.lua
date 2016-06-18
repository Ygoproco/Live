--Magnet Field
function c4740489.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,4740489)
	e2:SetCondition(c4740489.condition)
	e2:SetTarget(c4740489.target)
	e2:SetOperation(c4740489.activate)
	c:RegisterEffect(e2)
		
	--return to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c4740489.hancon)
	e3:SetTarget(c4740489.hantg)
	e3:SetOperation(c4740489.hanop)
	c:RegisterEffect(e3)
end
function c4740489.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2066) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4740489.cfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_ROCK)
end
function c4740489.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c4740489.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c4740489.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c4740489.filter(chkc,e,tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c4740489.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c4740489.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c4740489.activate(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and  c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c4740489.hancon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d==nil then return false end
	
	local c1=a
	local c2=d
	if d:GetControler()==tp then 
		c1=d 
		c2=a
	end
	return c1:IsFaceup() and c1:IsAttribute(ATTRIBUTE_EARTH) and c1:IsRace(RACE_ROCK) and c2:IsOnField() and c2:IsRelateToBattle()
end
function c4740489.hantg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = Duel.GetAttacker()
	if Duel.GetAttacker():GetControler()==tp then c=Duel.GetAttackTarget() end

	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c4740489.hanop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local ex,bc=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	if bc:GetFirst():IsRelateToBattle() then
		Duel.SendtoHand(bc,nil,REASON_EFFECT)
	end
end
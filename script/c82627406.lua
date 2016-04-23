--Scripted by Eerie Code
--Kiwi Magician Girl
function c82627406.initial_effect(c)
	--Increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82627406,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c82627406.condition)
	e1:SetCost(c82627406.cost)
	e1:SetTarget(c82627406.target)
	e1:SetOperation(c82627406.operation)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end

function c82627406.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	return phase~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c82627406.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c82627406.filter(c)
	return (c:IsSetCard(0x20a2) or c:IsSetCard(0x30a2)) and c:IsFaceup()
end
function c82627406.cfilter(c)
	return (c:IsSetCard(0x20a2) or c:IsSetCard(0x30a2)) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c82627406.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82627406.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c82627406.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c82627406.filter,tp,LOCATION_MZONE,0,nil)
	if tg:GetCount()==0 then return end
	local cc=Duel.GetMatchingGroup(c82627406.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil):GetClassCount(Card.GetCode)
	local tc=tg:GetFirst()
	local atk=300*cc
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end

function c82627406.indtg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLocation(LOCATION_MZONE)
end
function c82627406.tglimit(e,re,c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLocation(LOCATION_MZONE)
end
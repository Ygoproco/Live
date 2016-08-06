--捕食植物スキッド・ドロセーラ
--Predator Plant Skid Drosera
--Scripted by Eerie Code
function c69105797.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69105797,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c69105797.con)
	e1:SetCost(c69105797.cost)
	e1:SetTarget(c69105797.tg)
	e1:SetOperation(c69105797.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69105797,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c69105797.ctcon)
	e2:SetTarget(c69105797.cttg)
	e2:SetOperation(c69105797.ctop)
	c:RegisterEffect(e2)
end

function c69105797.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c69105797.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c69105797.fil(c)
	return c:IsFaceup() and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c69105797.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c69105797.fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c69105797.fil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c69105797.fil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c69105797.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(c69105797.atkfilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c69105797.atkfilter(e,c)
	return c:GetCounter(0x3b)>0
end

function c69105797.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c69105797.ctfil(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c69105797.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c69105797.ctfil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,g:GetCount(),0x3b,1)
end
function c69105797.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c69105797.ctfil,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x3b,1)
		tc=g:GetNext()
	end
	--
	if not c69105797.global_flag then
		c69105797.global_flag=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetTarget(c69105797.lvtg)
		e3:SetValue(1)
		Duel.RegisterEffect(e3,0)
	end
end
function c69105797.lvtg(e,c)
	return c:GetCounter(0x3b)>0 and c:IsLevelAbove(1)
end

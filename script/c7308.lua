--捕食植物スキッド・ドロセーラ
--Predator Plant Skid Drosera
--Scripted by Eerie Code
function c7308.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7308,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c7308.con)
	e1:SetCost(c7308.cost)
	e1:SetTarget(c7308.tg)
	e1:SetOperation(c7308.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7308,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c7308.ctcon)
	e2:SetTarget(c7308.cttg)
	e2:SetOperation(c7308.ctop)
	c:RegisterEffect(e2)
end

function c7308.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c7308.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c7308.fil(c)
	return c:IsFaceup() and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c7308.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7308.fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7308.fil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c7308.fil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7308.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(c7308.atkfilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c7308.atkfilter(e,c)
	return c:GetCounter(0x3b)>0
end

function c7308.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c7308.ctfil(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c7308.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c7308.ctfil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,g:GetCount(),0x3b,1)
end
function c7308.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c7308.ctfil,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x3b,1)
		tc=g:GetNext()
	end
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetTarget(c7308.lvtg)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,0)
end
function c7308.lvtg(e,c)
	return c:GetCounter(0x3b)>0 and c:IsLevelAbove(1)
end

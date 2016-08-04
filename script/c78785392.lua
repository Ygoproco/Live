--花合わせ
--Hana Awase
--Scripted by Eerie Code
function c78785392.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,78785392+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c78785392.cost)
	e1:SetTarget(c78785392.tg)
	e1:SetOperation(c78785392.op)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(78785392,ACTIVITY_NORMALSUMMON,c78785392.counterfilter)
	Duel.AddCustomActivityCounter(78785392,ACTIVITY_SPSUMMON,c78785392.counterfilter)
end
function c78785392.counterfilter(c)
	return c:IsSetCard(0xe6)
end

function c78785392.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(78785392,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(78785392,tp,ACTIVITY_NORMALSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c78785392.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c78785392.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe6)
end
function c78785392.fil(c,e,tp)
	return c:IsSetCard(0xe6) and c:GetAttack()==100 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c78785392.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sg=Duel.GetMatchingGroup(c78785392.fil,tp,LOCATION_DECK,0,nil,e,tp)
		return sg:GetClassCount(Card.GetCode)>=4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>3
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
end
function c78785392.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<4 then return end
	local sg=Duel.GetMatchingGroup(c78785392.fil,tp,LOCATION_DECK,0,nil,e,tp)
	if sg:GetClassCount(Card.GetCode)<4 then return end
	local g=Group.CreateGroup()
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=sg:Select(tp,1,1,nil)
		local tc1=g2:GetFirst()
		sg:Remove(Card.IsCode,nil,tc1:GetCode())
		g:AddCard(tc1)
	end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UNRELEASABLE_SUM)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
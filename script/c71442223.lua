--方界輪廻
--Cubic Samsara
--Scripted by Eerie Code
function c71442223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c71442223.condition)
	e1:SetTarget(c71442223.target)
	e1:SetOperation(c71442223.activate)
	c:RegisterEffect(e1)
end
function c71442223.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c71442223.spfil1(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71442223.spfil2(c,e,tp)
	return c:IsSetCard(0xe3) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c71442223.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc==at end
	if chk==0 then return at:IsOnField() and at:IsCanBeEffectTarget(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c71442223.spfil1,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,nil,at:GetCode(),e,1-tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c71442223.spfil2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetTargetCard(at)
end
function c71442223.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local el=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if el<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local og=Duel.GetMatchingGroup(c71442223.spfil1,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,nil,tc:GetCode(),e,1-tp)
	local cg=Duel.GetMatchingGroup(c71442223.spfil2,tp,LOCATION_HAND,0,nil,e,tp)
	if og:GetCount()==0 or cg:GetCount()==0 then return end
	if og:GetCount()>el then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		og=og:Select(1-tp,el,el,nil)
	end
	if Duel.SpecialSummon(og,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)==0 then return end
	local sg=Duel.GetOperatedGroup()
	sg:AddCard(tc)
	local sc=sg:GetFirst()
	while sc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1)
		sc:AddCounter(0x39,1)
		sc=sg:GetNext()
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetTarget(c71442223.atktg)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	Duel.RegisterEffect(e4,tp)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local cc=cg:Select(tp,1,1,nil)
	Duel.SpecialSummon(cc,0,tp,tp,true,false,POS_FACEUP)
end
function c71442223.atktg(e,c)
	return c:GetCounter(0x39)>0
end

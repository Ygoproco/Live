--王者の調和
--King's Synchro
--Scripted by Eerie Code
function c7367.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c7367.condition)
	e1:SetOperation(c7367.activate)
	c:RegisterEffect(e1)	
end

function c7367.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return not Duel.GetAttacker():IsControler(tp) and tc and tc:IsFaceup() and tc:IsControler(tp) and tc:IsType(TYPE_SYNCHRO)
end
function c7367.fil1(c,e,tp,lv)
	return c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c7367.fil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+c:GetLevel())
end
function c7367.fil2(c,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c7367.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateAttack() then return end
	local sc=Duel.GetAttackTarget()
	if sc and sc:IsLocation(LOCATION_MZONE) and sc:IsAbleToRemove() and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c7367.fil1,tp,LOCATION_GRAVE,0,1,nil,e,tp,sc:GetLevel()) and Duel.SelectYesNo(tp,aux.Stringid(7367,0)) then
		Duel.BreakEffect()
		local sl=sc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,c7367.fil1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,sl)
		if tg:GetCount()==0 then return end
		local tc=tg:GetFirst()
		sl=sl+tc:GetLevel()
		local rg=Group.FromCards(sc,tc)
		if Duel.Remove(rg,nil,REASON_EFFECT)==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c7367.fil2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sl)
			if g:GetCount()==0 then return end
			Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			g:GetFirst():CompleteProcedure()
		end
	end
end
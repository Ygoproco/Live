--Scripted by Eerie Code
--Harmony of the King's Soul
function c24590232.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c24590232.condition)
	e1:SetOperation(c24590232.activate)
	c:RegisterEffect(e1)
end

function c24590232.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c24590232.filter1(c,e,tp)
	if c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost() then
		local mg=Duel.GetMatchingGroup(c24590232.filter2,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(c24590232.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel(),mg)
	else return false end
end
function c24590232.filter2(c)
	return c:IsAbleToRemoveAsCost() and not c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1)
end
function c24590232.filter3(c,e,tp,lv,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and mg:CheckWithSumEqual(Card.GetOriginalLevel,c:GetLevel()-lv,1,63,c)
end
function c24590232.spfil1(c,e,tp)
	if c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) then
		return Duel.IsExistingMatchingCard(c24590232.spfil2,tp,LOCATION_GRAVE,0,1,nil,tp,c)
	else return false end
end
function c24590232.spfil2(c,tp,sc)
	if c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost() then
		local mg=Duel.GetMatchingGroup(c24590232.filter2,tp,LOCATION_GRAVE,0,nil)
		--return Duel.IsExistingMatchingCard(c24590232.spfil3,tp,LOCATION_EXTRA,0,1,nil,sc:GetLevel()-c:GetLevel(),mg,sc)
		return mg:IsExists(c24590232.spfil3,1,nil,sc:GetLevel()-c:GetLevel(),mg,sc)
	else return false end
end
function c24590232.spfil3(c,limlv,mg,sc)
	local fg=mg:Clone()
	fg:RemoveCard(c)
	--Debug.Message("Difference: " .. mg:GetCount() .. "/" .. fg:GetCount())
	local newlim=limlv-c:GetLevel()
	--Debug.Message("Code: "  .. c:GetCode() .. ", new level = " .. newlim)
	--return newlim==0 or mg:CheckWithSumEqual(Card.GetOriginalLevel,newlim,1,63,sc)
	if newlim==0 then return true else return fg:CheckWithSumEqual(Card.GetOriginalLevel,newlim,1,63,sc) end
end
function c24590232.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	if Duel.IsExistingMatchingCard(c24590232.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(24590232,0)) then
		--local g1=Duel.SelectMatchingCard(tp,c24590232.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		--local lv=g1:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local exg=Duel.SelectMatchingCard(tp,c24590232.spfil1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local ex=exg:GetFirst()
		local tglv=ex:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,c24590232.spfil2,tp,LOCATION_GRAVE,0,1,1,nil,tp,ex)
		local lv=g1:GetFirst():GetLevel()
		local mg2=Duel.GetMatchingGroup(c24590232.filter2,tp,LOCATION_GRAVE,0,nil)
		while lv<tglv do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g2=mg2:FilterSelect(tp,c24590232.spfil3,1,1,nil,tglv-lv,mg2,ex)
			local gc=g2:GetFirst()
			lv=lv+gc:GetLevel()
			mg2:RemoveCard(gc)
			g1:AddCard(gc)
		end
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT+REASON_COST)
		Duel.SpecialSummon(ex,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		ex:CompleteProcedure()
	end
end

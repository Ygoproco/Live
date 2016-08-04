--化合獣オキシン・オックス
--Chemical Beast Oxine Ox
--Scripted by Eerie Code
function c7325.initial_effect(c)
	aux.EnableDualAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7325,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,7325)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(c7325.sptg)
	e1:SetOperation(c7325.spop)
	c:RegisterEffect(e1)
end

function c7325.spfil(c,e,tp)
	return c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7325.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c7325.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7325.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsType(TYPE_DUAL)
end
function c7325.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c7325.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g1:GetCount()>0 and Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(c7325.filter,tp,LOCATION_MZONE,0,nil)
		local lv=g1:GetFirst():GetOriginalLevel()
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
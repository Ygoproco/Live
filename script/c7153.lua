--Scripted by Eerie Code
--Super Hippo Carnival
function c7153.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c7153.target)
	e1:SetOperation(c7153.activate)
	c:RegisterEffect(e1)
end

function c7153.filter(c,e,tp)
	return c:IsCode(41440148) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7153.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c7153.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7153.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 then return end
	local g=Duel.SelectMatchingCard(tp,c7153.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if ft>1 and not Duel.IsPlayerAffectByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummon(tp,18027139,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH) and Duel.SelectYesNo(tp,aux.Stringid(7153,0)) then
			Duel.BreakEffect()
			ft=ft-1
			for i=1,ft do
				local token=Duel.CreateToken(tp,18027139)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UNRELEASABLE_SUM)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				token:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e3:SetRange(LOCATION_MZONE)
				e3:SetAbsoluteRange(tp,1,0)
				e3:SetTarget(c7153.splimit)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e3)
			end
			Duel.SpecialSummonComplete()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(c7153.atlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c7153.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c7153.atlimit(e,c)
	return not c:IsCode(18027139)
end

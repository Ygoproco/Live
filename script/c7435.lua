--堕天使の戒壇
--Altar of the Darklords
--Script by mercury233
function c7435.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7435+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c7435.sptg)
	e1:SetOperation(c7435.spop)
	c:RegisterEffect(e1)
end

function c7435.filter(c,e,tp)
	local pos=0
	if POS_FACEUP_DEFENSE then
		pos=POS_FACEUP_DEFENSE
	else
		pos=POS_FACEUP_DEFENCE
	end
	return c:IsSetCard(0xef) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,pos)
end
function c7435.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c7435.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c7435.spop(e,tp,eg,ep,ev,re,r,rp)
	local pos=0
	if POS_FACEUP_DEFENSE then
		pos=POS_FACEUP_DEFENSE
	else
		pos=POS_FACEUP_DEFENCE
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7435.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,pos)
	end
end
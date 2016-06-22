--怒気土器
--Dokidoki
--Scripted by Eerie Code
function c7381.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,7381)
	e1:SetCost(c7381.cost)
	e1:SetTarget(c7381.tg)
	e1:SetOperation(c7381.op)
	c:RegisterEffect(e1)
end

function c7381.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c7381.cfil(c,e,tp)
	return c:IsRace(RACE_ROCK) and c:IsDiscardable() and Duel.IsExistingMatchingCard(c7381.fil,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c7381.fil(c,e,tp,dc)
	return c:IsRace(RACE_ROCK) and c:GetOriginalLevel()==dc:GetOriginalLevel() and c:GetOriginalAttribute()==dc:GetOriginalAttribute() and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN))
end
function c7381.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c7381.cfil,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	--local g=Duel.DiscardHand(tp,c7381.cfil,1,1,REASON_COST+REASON_DISCARD,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c7381.cfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7381.op(e,tp,eg,ep,ev,re,r,rp)
	local dc=e:GetLabelObject()
	if not dc or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7381.fil,tp,LOCATION_DECK,0,1,1,nil,e,tp,dc)
	local tc=g:GetFirst()
	if tc then
		local spos=0
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then spos=spos+POS_FACEUP_ATTACK end
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) then spos=spos+POS_FACEDOWN_DEFENCE end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,spos)
		if tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

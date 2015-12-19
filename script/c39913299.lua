--Scripted by Eerie Code
--True Name
function c39913299.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,39913299+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c39913299.target)
	e1:SetOperation(c39913299.operation)
	c:RegisterEffect(e1)
end

function c39913299.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c39913299.exfil(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DEVINE) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c39913299.thfil(c)
	return c:IsAttribute(ATTRIBUTE_DEVINE) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c39913299.spfil(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DEVINE) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c39913299.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsCode(ac) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		if (Duel.IsExistingMatchingCard(c39913299.thfil,tp,LOCATION_DECK,0,1,nil) or (Duel.IsExistingMatchingCard(c39913299.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) and Duel.SelectYesNo(tp,aux.Stringid(39913299,0)) then
			local g=Duel.SelectMatchingCard(tp,c39913299.exfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			local tc2=g:GetFirst()
			local b1=tc2:IsAbleToHand()
			local b2=tc2:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			if b1 and b2 then
				local op=Duel.SelectOption(tp,aux.Stringid(39913299,1),aux.Stringid(39913299,2))
				if op==0 then
					Duel.SendtoHand(tc2,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc2)
					Duel.ShuffleHand(tp)
				else
					Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
				end
			elseif b1 then
				Duel.SendtoHand(tc2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc2)
				Duel.ShuffleHand(tp)
			else
				Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	end
end
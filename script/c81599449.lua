--化合獣カーボン・クラブ
--Chemical Beast Carbon Crab
--Scripted by Eerie Code
function c81599449.initial_effect(c)
	aux.EnableDualAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81599449,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81599449)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(c81599449.tg)
	e1:SetOperation(c81599449.op)
	c:RegisterEffect(e1)
end

function c81599449.tgfil(c,tp)
	return c:IsType(TYPE_DUAL) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c81599449.thfil,tp,LOCATION_DECK,0,1,c)
end
function c81599449.thfil(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToHand()
end
function c81599449.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81599449.tgfil,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c81599449.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c81599449.tgfil,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()==0 then return end
	local tc1=g1:GetFirst()
	if Duel.SendtoGrave(tc1,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c81599449.thfil,tp,LOCATION_DECK,0,1,1,tc1)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end

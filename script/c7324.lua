--化合獣カーボン・クラブ
--Chemical Beast Carbon Crab
--Scripted by Eerie Code
function c7324.initial_effect(c)
	aux.EnableDualAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7324,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,7324)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(c7324.tg)
	e1:SetOperation(c7324.op)
	c:RegisterEffect(e1)
end

function c7324.tgfil(c,tp)
	return c:IsType(TYPE_DUAL) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c7324.thfil,tp,LOCATION_DECK,0,1,c)
end
function c7324.thfil(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToHand()
end
function c7324.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7324.tgfil,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c7324.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c7324.tgfil,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()==0 then return end
	local tc1=g1:GetFirst()
	if Duel.SendtoGrave(tc1,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c7324.thfil,tp,LOCATION_DECK,0,1,1,tc1)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end

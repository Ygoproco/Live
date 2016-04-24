--魔導契約の扉
--Gate of the Magical Contract
--Scripted by Eerie Code
function c18809562.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c18809562.target)
	e1:SetOperation(c18809562.activate)
	c:RegisterEffect(e1)
end

function c18809562.fil(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and (c:GetLevel()==7 or c:GetLevel()==8) and c:IsAbleToHand()
end
function c18809562.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,e:GetHandler(),TYPE_SPELL) and Duel.IsExistingMatchingCard(c18809562.fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c18809562.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,e:GetHandler(),TYPE_SPELL)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,1-tp,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c18809562.fil,tp,LOCATION_DECK,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g2,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end

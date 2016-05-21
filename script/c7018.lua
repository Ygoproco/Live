--黒魔術の継承
--Dark Magic Succession
--Scripted by Eerie Code
function c7018.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7018+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c7018.cost)
	e1:SetTarget(c7018.tg)
	e1:SetOperation(c7018.op)
	c:RegisterEffect(e1)
end
c7018.dark_magician_list=true
c7018.dark_magician_girl_list=true

function c7018.cfil(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c7018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7018.cfil,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c7018.cfil,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c7018.fil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c.dark_magician_list or c.dark_magician_girl_list) and c:IsAbleToHand()
end
function c7018.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7018.fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c7018.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7018.fil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

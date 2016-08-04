--黒魔術の継承
--Dark Magic Succession
--Scripted by Eerie Code
function c41735184.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,41735184+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c41735184.cost)
	e1:SetTarget(c41735184.tg)
	e1:SetOperation(c41735184.op)
	c:RegisterEffect(e1)
end
c41735184.dark_magician_list=true
c41735184.dark_magician_girl_list=true

function c41735184.cfil(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c41735184.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c41735184.cfil,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c41735184.cfil,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c41735184.fil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c.dark_magician_list or c.dark_magician_girl_list) and not c:IsCode(41735184) and c:IsAbleToHand()
end
function c41735184.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c41735184.fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c41735184.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c41735184.fil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

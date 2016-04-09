--Scripted by Eerie Code
--Illusion Magic
function c73616671.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,73616671+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c73616671.cost)
	e1:SetTarget(c73616671.target)
	e1:SetOperation(c73616671.activate)
	c:RegisterEffect(e1)
end
c73616671.dark_magician_list=true

function c73616671.cfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c73616671.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c73616671.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c73616671.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c73616671.filter(c)
	return c:IsCode(46986414) and c:IsAbleToHand()
end
function c73616671.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73616671.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c73616671.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c73616671.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
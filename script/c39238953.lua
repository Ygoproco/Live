--天声の服従
--Lullaby of Obedience
function c39238953.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c39238953.cost)
	e1:SetTarget(c39238953.target)
	e1:SetOperation(c39238953.activate)
	c:RegisterEffect(e1)
end
function c39238953.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c39238953.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local code=Duel.AnnounceCard(tp,TYPE_MONSTER)
	e:SetLabel(code)
end
function c39238953.filter(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsAbleToHand()
end
function c39238953.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if Duel.IsExistingMatchingCard(c39238953.filter,tp,0,LOCATION_DECK,1,nil,code) then
		local g=Duel.SelectMatchingCard(1-tp,c39238953.filter,tp,0,LOCATION_DECK,1,1,nil,code)
		Duel.ConfirmCards(tp,g)
		local op=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,1-tp,true,false,POS_FACEUP_ATTACK,tp) then
			if g:GetFirst():IsAbleToHand() then
				op=Duel.SelectOption(1-tp,aux.Stringid(39238953,0),aux.Stringid(39238953,1))
			else
				op=1
			end
		else 
			if not g:GetFirst():IsAbleToHand() then return end
		end
		if op==0 then --add to hand
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		else --summon
			Duel.SpecialSummon(g,0,1-tp,tp,true,false,POS_FACEUP_ATTACK)
		end
	end
end
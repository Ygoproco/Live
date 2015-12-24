--Scripted by Eerie Code
--Dark Advance
function c97001138.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,97001138+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c97001138.condition)
	e1:SetTarget(c97001138.target)
	e1:SetOperation(c97001138.activate)
	c:RegisterEffect(e1)
end

function c97001138.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or ph==PHASE_BATTLE
end
function c97001138.thfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackAbove(2400) and c:GetDefence()==1000 and c:IsAbleToHand()
end
function c97001138.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c97001138.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c97001138.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c97001138.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c97001138.asfil(c)
	return c:IsAttackAbove(2400) and c:GetDefence()==1000 and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1))
end
function c97001138.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	if Duel.IsExistingMatchingCard(c97001138.asfil,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(97001138,0)) then
		local g=Duel.SelectMatchingCard(tp,c97001138.asfil,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()==0 then return end
		local tc2=g:GetFirst()
		local s1=tc2:IsSummonable(true,nil,1)
		local s2=tc2:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc2,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENCE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc2,true,nil,1)
		else
			Duel.MSet(tp,tc2,true,nil,1)
		end
	end
end

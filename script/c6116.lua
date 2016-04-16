--Scripted by Eerie Code
--Lemon Magician Girl
function c6116.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6116,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c6116.thcost)
	e1:SetTarget(c6116.thtg)
	e1:SetOperation(c6116.thop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6116,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c6116.sptg)
	e2:SetOperation(c6116.spop)
	c:RegisterEffect(e2)
end

function c6116.thcfil(c)
	return (c:IsSetCard(0x20a2) or c:IsSetCard(0x30a2)) and not c:IsCode(6116)
end
function c6116.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c6116.thcfil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c6116.thcfil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c6116.thfil(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c6116.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6116.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c6116.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c6116.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c6116.spfil(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6116.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c6116.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c6116.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttacker()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,c6116.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) and not tc:IsImmuneToEffect(e) then
			local atk=at:GetAttack()/2
			--Duel.CalculateDamage(at,tc)
			Duel.ChangeAttackTarget(tc)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK_FINAL)
			e2:SetValue(atk)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			at:RegisterEffect(e2,true)
		end
	end
end

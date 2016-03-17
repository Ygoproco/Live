--Scripted by Eerie Code
--Apple Magician Girl
function c7215.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7215,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c7215.sptg)
	e1:SetOperation(c7215.spop)
	c:RegisterEffect(e1)
	--Back to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7215,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c7215.regcon)
	e4:SetTarget(c7215.regtg)
	e4:SetOperation(c7215.regop)
	c:RegisterEffect(e4)
end

function c7215.spfil(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7215.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c7215.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7215.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttacker()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,c7215.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) and not tc:IsImmuneToEffect(e) then
			local atk=at:GetAttack()/2
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK_FINAL)
			e2:SetValue(atk)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			at:RegisterEffect(e2,true)
			Duel.CalculateDamage(at,tc)
		end
	end
end

function c7215.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c7215.regfil(c,e)
  return c:IsSetCard(0xe1) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c7215.regtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc~=e:GetHandler() and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7215.regfil(chkc,e) end
  if chk==0 then return Duel.IsExistingTarget(c7215.regfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e) end
  local g=Duel.GetMatchingGroup(c7215.regfil,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g1=g:Select(tp,1,1,nil)
  g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(7215,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(7215,2)) then
			g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
	end
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
end
function c7215.regop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  if g:GetCount()>0 then
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
  end
end
--Scripted by Eerie Code
--Choco Magician Girl
function c6128.initial_effect(c)
  --Draw
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(6128,0))
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCountLimit(1)
  e1:SetCost(c6128.drcost)
  e1:SetTarget(c6128.drtg)
  e1:SetOperation(c6128.drop)
  c:RegisterEffect(e1)
  --Redirect
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(6128,1))
  e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c6128.sptg)
	e2:SetOperation(c6128.spop)
  c:RegisterEffect(e2)
end

function c6128.drcfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsDiscardable()
end
function c6128.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6128.drcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c6128.drcfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c6128.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c6128.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c6128.spfil(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and not c:IsCode(6128) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6128.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6128.spfil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c6128.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c6128.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c6128.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttacker()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	if at:IsAttackable() and not at:IsImmuneToEffect(e) and not tc:IsImmuneToEffect(e) then
		local atk=at:GetAttack()/2
		Duel.ChangeAttackTarget(tc)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		at:RegisterEffect(e2,true)
		--Duel.CalculateDamage(at,tc)
	end
end
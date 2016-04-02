--Scripted by Eerie Code
--Meteor Houkai Device Duja
function c6127.initial_effect(c)
  --Send to Grave
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6127,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c6127.tgtg)
	e3:SetOperation(c6127.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Increase ATK
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(6127,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetHintTiming(TIMING_DAMAGE_STEP)
	e5:SetCountLimit(1)
	e5:SetCondition(c6127.atkcon)
	e5:SetOperation(c6127.atkop)
	c:RegisterEffect(e5)
end

function c6127.tgfilter(c)
	return c:IsSetCard(0xe5) and c:IsAbleToGrave()
end
function c6127.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6127.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c6127.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6127.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function c6127.atkcfil(c,tid)
  return c:IsType(TYPE_MONSTER) and c:GetTurnId()==tid and not c:IsReason(REASON_RETURN)
end
function c6127.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and Duel.IsExistingMatchingCard(c6127.atkcfil,tp,LOCATION_GRAVE,0,1,nil,Duel.GetTurnCount())
end
function c6127.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
  local val=g:GetClassCount(Card.GetCode)*200
  if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
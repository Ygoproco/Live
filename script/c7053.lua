--沈黙の剣
--Silent Sword
--Scripted by Eerie Code
function c7053.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetTarget(c7053.tg)
  e1:SetOperation(c7053.op)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c7053.thcost)
	e2:SetTarget(c7053.thtg)
	e2:SetOperation(c7053.thop)
	c:RegisterEffect(e2)
end

function c7053.fil(c)
  return c:IsFaceup() and c:IsSetCard(0xe7)
end
function c7053.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7053.fil(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c7053.fil,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c7053.fil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7053.op(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	  local e1=Effect.CreateEffect(c)
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_UPDATE_ATTACK)
	  e1:SetValue(1500)
	  e1:SetReset(RESET_EVENT+0x1fe0000)
	  tc:RegisterEffect(e1)
	  local e2=e1:Clone()
	  e2:SetCode(EFFECT_UPDATE_DEFENCE)
	  tc:RegisterEffect(e2)
	  local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetValue(c7053.efilter)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
	end
end
function c7053.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end

function c7053.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c7053.thfilter(c)
	return c:IsSetCard(0xe7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c7053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7053.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c7053.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7053.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Scripted by Eerie Code
--Red Mirror
function c8706701.initial_effect(c)
  --Recover
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(8706701,0))
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,8706701)
  e1:SetCondition(c8706701.thcon1)
  e1:SetCost(c8706701.thcost)
  e1:SetTarget(c8706701.thtg1)
  e1:SetOperation(c8706701.thop1)
  c:RegisterEffect(e1)
  --Recover (self)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(8706701,1))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCountLimit(1,8706701+1)
  e2:SetCondition(c8706701.thcon2)
  e2:SetTarget(c8706701.thtg2)
  e2:SetOperation(c8706701.thop2)
  c:RegisterEffect(e2)
end

function c8706701.thcon1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()~=tp
end
function c8706701.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c8706701.thfil(c)
  return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_FIEND) and not c:IsCode(8706701) and c:IsAbleToHand()
end
function c8706701.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c8706701.thfil(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c8706701.thfil,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c8706701.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c8706701.thop1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
  end
end

function c8706701.cfilter(c,tp)
  return c:IsControler(tp) and bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c8706701.thcon2(e,tp,eg,ep,ev,re,r,rp)
  if not eg then return false end
  return aux.exccon(e) and eg:IsExists(c8706701.cfilter,1,nil,tp)
end
function c8706701.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHand() end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c8706701.thop2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetHandler()
  if tc:IsRelateToEffect(e) then
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
  end
end
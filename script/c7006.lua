--Scripted by Eerie Code
--Performapal Longphone Bull
function c7006.initial_effect(c)
  --Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7006,0))
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCountLimit(1,7006)
  e1:SetTarget(c7006.thtg)
  e1:SetOperation(c7006.thop)
  c:RegisterEffect(e1)
end

function c7006.thfil(c)
  return c:IsSetCard(0x9f) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c7006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c7006.thfil,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c7006.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c7006.thfil,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
  end
end
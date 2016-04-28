--融爆
--Fusplosion
--Scripted by Eerie Code
function c68077936.initial_effect(c)
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c68077936.condition)
	e1:SetTarget(c68077936.target)
	e1:SetOperation(c68077936.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c68077936.condition2)
	e2:SetCost(c68077936.cost)
	c:RegisterEffect(e2)
end

function c68077936.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function c68077936.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c68077936.cfilter,1,nil,tp) and re:IsActiveType(TYPE_SPELL)
end
function c68077936.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c68077936.activate(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
  end
end

function c68077936.condition2(e,tp,eg,ep,ev,re,r,rp)
  return c68077936.condition(e,tp,eg,ep,ev,re,r,rp) and aux.exccon(e)
end
function c68077936.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

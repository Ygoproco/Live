--Scripted by Eerie Code
--Performapal Slyhand Sorcerer
function c7001.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c7001.hspcon)
  e1:SetOperation(c7001.hspop)
  c:RegisterEffect(e1)
  --Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(7001,0))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1)
  e2:SetCost(c7001.cost)
  e2:SetTarget(c7001.target)
  e2:SetOperation(c7001.operation)
  c:RegisterEffect(e2)
end

function c7001.hspfil(c)
  return c:IsSetCard(0x9f) and not c:IsType(TYPE_PENDULUM)
end
function c7001.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c7001.hspfil,1,nil)
end
function c7001.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c7001.hspfil,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c7001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c7001.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c7001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and c7001.filter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c7001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c7001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c7001.operation(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
  end
end
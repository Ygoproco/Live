--Scripted by Eerie Code
--Pendulum Hole
function c68477598.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_SPSUMMON)
  e1:SetCondition(c68477598.condition)
  e1:SetTarget(c68477598.target)
  e1:SetOperation(c68477598.operation)
  c:RegisterEffect(e1)
end

function c68477598.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c68477598.condition(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetCurrentChain()==0 and eg:IsExists(c68477598.filter,1,nil)
end
function c68477598.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c68477598.operation(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateSummon(eg)
  Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
end
--Scripted by Eerie Code
--Performapal Bot-Eyes Lizard
function c7105.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7105,0))
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCondition(c7105.con)
  e1:SetCost(c7105.cost)
  e1:SetOperation(c7105.op)
  c:RegisterEffect(e1)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_SUMMON_SUCCESS)
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e3:SetOperation(c7105.regop)
  c:RegisterEffect(e3)
  local e2=e3:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
end

function c7105.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(7105)~=0
end
function c7105.cfilter(c)
  return c:IsSetCard(0x99) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c7105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c7105.cfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c7105.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabel(cg:GetFirst():GetCode())
end
function c7105.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(e:GetLabel())
	c:RegisterEffect(e1)
end

function c7105.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(7105,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end
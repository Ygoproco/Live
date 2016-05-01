--Kozmourning
--Scripted by Eerie Code
function c6986.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Redirect
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c6986.rdtg)
	e2:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e2)
	--Reverse
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c6986.rvcost)
	e3:SetOperation(c6986.rvop)
	c:RegisterEffect(e3)
end

function c6986.rdtg(e,c)
	return c:IsSetCard(0xd2)
end

function c6986.rvcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c6986.rvop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCountLimit(1)
	e1:SetCondition(c6986.con)
	e1:SetValue(c6986.rev)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c6986.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_BATTLE)>0
end
function c6986.con(e)
  local tp=e:GetHandlerPlayer()
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  return (a and a:IsControler(tp) and a:IsSetCard(0xd2)) or (d and d:IsControler(tp) and d:IsSetCard(0xd2))
end
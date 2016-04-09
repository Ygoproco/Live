--Scripted by Eerie Code
--Magic Expand
function c111280.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c111280.tg)
  e1:SetOperation(c111280.op)
  c:RegisterEffect(e1)
end
c111280.dark_magician_list=true

function c111280.cfil(c)
  return (c:IsCode(46986414) or c:IsCode(38033121)) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c111280.fil(c)
  return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)
end
function c111280.atkfil(c)
  return c111280.fil(c) and c:IsFaceup()
end
function c111280.tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
	local mc=Duel.GetMatchingGroupCount(c111280.cfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	return mc>0 and (mc>1 or Duel.IsExistingMatchingCard(c111280.atkfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil))
  end
end
function c111280.op(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local mc=Duel.GetMatchingGroupCount(c111280.cfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
  if mc>=1 and Duel.IsExistingMatchingCard(c111280.atkfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c111280.atkfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
  end
  if mc>=2 then
	local e2=Effect.CreateEffect(c)
	  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	  e2:SetCode(EVENT_CHAINING)
	  e2:SetOperation(c111280.chainop)
	  e2:SetReset(RESET_PHASE+PHASE_END)
	  Duel.RegisterEffect(e2,tp)
	  local e3=Effect.CreateEffect(c)
	  e3:SetType(EFFECT_TYPE_FIELD)
	  e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	  e3:SetTargetRange(LOCATION_SZONE,0)
	  e3:SetValue(c111280.indval)
	  e3:SetReset(RESET_PHASE+PHASE_END)
	  Duel.RegisterEffect(e3,tp)
  end
  if mc>=3 then
	local e4=Effect.GlobalEffect()
	  e4:SetType(EFFECT_TYPE_FIELD)
	  e4:SetCode(EFFECT_IMMUNE_EFFECT)
	  e4:SetTargetRange(LOCATION_MZONE,0)
	  e4:SetTarget(c111280.fil)
	  e4:SetValue(c111280.efilter)
	  e4:SetReset(RESET_PHASE+PHASE_END)
	  Duel.RegisterEffect(e4,tp)
  end
end

function c111280.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and tp==rp then
		Duel.SetChainLimit(c111280.chainlm)
	end
end
function c111280.chainlm(e,rp,tp)
	return tp==rp
end
function c111280.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c111280.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

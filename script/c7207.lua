--竜の闘志
--Dragon's Perseverance
--Scripted by Eerie Code
function c7207.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c7207.con)
  e1:SetTarget(c7207.tg)
  e1:SetOperation(c7207.op)
  c:RegisterEffect(e1)
  if not c7207.global_check then
		c7207.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c7207.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c7207.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(7207)==0 then
			tc:RegisterFlagEffect(7207,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end

function c7207.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() or Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c7207.fil1(c)
  return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:GetFlagEffect(7207)>0 and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c7207.fil2(c)
  return c:GetFlagEffect(7207)>0
end
function c7207.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7207.fil1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c7207.fil1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c7207.fil2,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c7207.fil1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7207.op(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) then return end
  local mc=Duel.GetMatchingGroupCount(c7207.fil2,tp,0,LOCATION_MZONE,nil)
  if mc>0 then
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(mc)
		tc:RegisterEffect(e1)
	end
end
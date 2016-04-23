--竜の闘志
--Dragon's Perseverance
--Scripted by Eerie Code
function c95697223.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c95697223.con)
  e1:SetTarget(c95697223.tg)
  e1:SetOperation(c95697223.op)
  c:RegisterEffect(e1)
  if not c95697223.global_check then
		c95697223.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c95697223.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c95697223.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(95697223)==0 then
			tc:RegisterFlagEffect(95697223,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end

function c95697223.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() or Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c95697223.fil1(c)
  return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:GetFlagEffect(95697223)>0 and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c95697223.fil2(c)
  return c:GetFlagEffect(95697223)>0
end
function c95697223.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95697223.fil1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c95697223.fil1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c95697223.fil2,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c95697223.fil1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c95697223.op(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) then return end
  local mc=Duel.GetMatchingGroupCount(c95697223.fil2,tp,0,LOCATION_MZONE,nil)
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
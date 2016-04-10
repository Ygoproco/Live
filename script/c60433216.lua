--Scripted by Eerie Code
--King Scarlet
function c60433216.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetCondition(c60433216.con)
  e1:SetTarget(c60433216.tg)
  e1:SetOperation(c60433216.op)
  c:RegisterEffect(e1)
end

function c60433216.con(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetAttacker()
  local ac=Duel.GetAttackTarget()
  if tc:IsControler(tp) and tc:IsSetCard(0x1045) then
	e:SetLabelObject(tc)
	return true
  elseif ac and ac:IsControler(tp) and ac:IsSetCard(0x1045) then
	e:SetLabelObject(ac)
	return true
  else return false end
end
function c60433216.tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,60433216,0,0x11,0,0,1,RACE_FIEND,ATTRIBUTE_FIRE) end
  Duel.SetTargetCard(e:GetLabelObject())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60433216.op(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,60433216,0,0x11,0,0,1,RACE_FIEND,ATTRIBUTE_FIRE) then
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		c:AddTrapMonsterAttribute(TYPE_NORMAL+TYPE_TUNER,ATTRIBUTE_FIRE,RACE_FIEND,1,0,0)
	  Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	  c:TrapMonsterBlock()
  end
end
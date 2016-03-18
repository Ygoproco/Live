--Scripted by Eerie Code
--Odd-Eyes Mirage Dragon
function c7251.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Exchange
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7251,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCondition(c7251.pncon)
  e1:SetTarget(c7251.pntg)
  e1:SetOperation(c7251.pnop)
  c:RegisterEffect(e1)
  --Indes
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(7251,1))
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1,7251)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(c7251.incon)
  e2:SetTarget(c7251.intg)
  e2:SetOperation(c7251.inop)
  c:RegisterEffect(e2)
end

function c7251.desfil(c,tp)
  return c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c7251.pncon(e,tp,eg,ep,ev,re,r,rp)
  return eg and eg:IsExists(c7251.desfil,1,nil,tp)
end
function c7251.pncfil(c)
  return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c7251.pnfil(c)
  return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x99) and not c:IsCode(7251) and not c:IsForbidden()
end
function c7251.pntg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c7251.pncfil,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c7251.pnfil,tp,LOCATION_EXTRA,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c7251.pnop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local dg=Duel.SelectMatchingCard(tp,c7251.pncfil,tp,LOCATION_SZONE,0,1,1,nil)
  if dg:GetCount()>0 and Duel.Destroy(dg,REASON_EFFECT)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local fg=Duel.SelectMatchingCard(tp,c7251.pnfil,tp,LOCATION_EXTRA,0,1,1,nil)
	if fg:GetCount()>0 then
	  Duel.MoveToField(fg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
  end
end

function c7251.incon(e,tp,eg,ep,ev,re,r,rp)
  local c1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
  local c2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
  return (c1 and c1:IsSetCard(0x99)) or (c2 and c2:IsSetCard(0x99))
end
function c7251.infil(c)
  return c:IsFaceup() and c:IsSetCard(0x99)
end
function c7251.intg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7251.infil(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c7251.infil,tp,LOCATION_MZONE,0,1,nil) end
  Duel.SelectTarget(tp,c7251.infil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7251.inop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCountLimit(1)
	e2:SetValue(c7251.valcon)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
  end
end
function c7251.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
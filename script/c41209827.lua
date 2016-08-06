--スターヴ・ヴェノム・フュージョン・ドラゴン
--Starve Venom Fusion Dragon
--Scripted by Eerie Code
function c41209827.initial_effect(c)
  --fusion
  c:EnableReviveLimit()
  aux.AddFusionProcFunRep(c,c41209827.mat_filter,2,false)
  --
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(41209827,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetCondition(c41209827.atkcon)
  e1:SetTarget(c41209827.atktg)
  e1:SetOperation(c41209827.atkop)
  c:RegisterEffect(e1)
  --
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(41209827,1))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1)
  e2:SetTarget(c41209827.nmtg)
  e2:SetOperation(c41209827.nmop)
  c:RegisterEffect(e2)
  --
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(41209827,2))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_DESTROYED)
  e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
  e3:SetCondition(c41209827.descon)
  e3:SetTarget(c41209827.destg)
  e3:SetOperation(c41209827.desop)
  c:RegisterEffect(e3)
end

function c41209827.mat_filter(c)
  return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsType(TYPE_TOKEN) and c:IsLocation(LOCATION_MZONE)
end

function c41209827.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c41209827.atkfil(c)
  return c:IsFaceup() and c:IsAttackAbove(1) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c41209827.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c41209827.atkfil,tp,0,LOCATION_MZONE,1,nil) end
end
function c41209827.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsLocation(LOCATION_MZONE) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectMatchingCard(tp,c41209827.atkfil,tp,0,LOCATION_MZONE,1,1,nil)
  if g:GetCount()>0 then
	local atk=g:GetFirst():GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
  end
end

function c41209827.nmfil(c)
  return c:IsFaceup() and c:IsLevelAbove(5)
end
function c41209827.nmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c41209827.nmfil(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c41209827.nmfil,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c41209827.nmfil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c41209827.nmop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
	local code=tc:GetCode()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	c:RegisterEffect(e1)
	c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
  end
end

function c41209827.descon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c41209827.desfil(c)
  return c:IsDestructable() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c41209827.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=Duel.GetMatchingGroup(c41209827.desfil,tp,0,LOCATION_MZONE,nil)
  if chk==0 then return g:GetCount()>0 end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c41209827.desop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c41209827.desfil,tp,0,LOCATION_MZONE,nil)
  if g:GetCount()>0 then
	Duel.Destroy(g,REASON_EFFECT)
  end
end

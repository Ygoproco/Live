--ＥＭバリアバルーンバク
--Performapal Barrier Balloon Baku
--Scripted by Eerie Code
function c7104.initial_effect(c)
  --Damage to 0
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7104,0))
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c7104.dmcon)
  e1:SetCost(c7104.dmcost)
  e1:SetOperation(c7104.dmop)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(7104,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_ATTACK_ANNOUNCE)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCountLimit(1,7104)
  e2:SetCondition(c7104.spcon)
  e2:SetCost(c7104.spcost)
  e2:SetTarget(c7104.sptg)
  e2:SetOperation(c7104.spop)
  c:RegisterEffect(e2)
end

function c7104.dmcon(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a:GetControler()~=d:GetControler()
end
function c7104.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c7104.dmop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c100909002.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c7104.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end

function c7104.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c7104.spcfil(c)
  return c:IsSetCard(0x9f) and c:IsDiscardable()
end
function c7104.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7104.spcfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c7104.spcfil,1,1,REASON_COST+REASON_DISCARD)
end
function c7104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c7104.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
  end
end
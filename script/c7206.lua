--パンデミック・ドラゴン
--Pandemic Dragon
--Scripted by Eerie Code
function c7206.initial_effect(c)
  --Reduce ATK
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7206,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCost(c7206.atkcost)
  e1:SetTarget(c7206.atktg1)
  e1:SetOperation(c7206.atkop1)
  c:RegisterEffect(e1)
  --Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(7206,1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1)
  e2:SetTarget(c7206.destg)
  e2:SetOperation(c7206.desop)
  c:RegisterEffect(e2)
  --
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(7206,2))
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_SUMMON_SUCCESS)
  e3:SetCondition(c7206.atkcon)
  e3:SetTarget(c7206.atktg2)
  e3:SetOperation(c7206.atkop2)
  c:RegisterEffect(e3)
end

function c7206.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	local lp=Duel.GetLP(tp)
	local t={}
	local f=math.floor((lp)/100)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local atk=g:GetMaxGroup(Card.GetAttack):GetAttack()
	f=math.min(f,math.floor((atk)/100))
	local l=1
	while l<=f do
		t[l]=l*100
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(7206,3))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce)
	e:SetLabel(announce)
	e:GetHandler():SetHint(CHINT_NUMBER,announce)
end
function c7206.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function c7206.atkop1(e,tp,eg,ep,ev,re,r,rp)
  local atk=e:GetLabel()
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
  local tc=g:GetFirst()
  while tc do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-atk)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
  end
end

function c7206.desfil(c,atk)
  return c:IsFaceup() and c:IsDestructable() and c:GetAttack()<=atk
end
function c7206.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
  local atk=c:GetAttack()
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c and c7206.desfil(chkc,atk) end
  if chk==0 then return Duel.IsExistingTarget(c7206.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,atk) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c7206.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,atk)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c7206.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
  end
end

function c7206.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c7206.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c7206.atkop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
  local tc=g:GetFirst()
  while tc do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
  end
end
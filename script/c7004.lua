--Scripted by Eerie Code
--Performapal King Bear
function c7004.initial_effect(c)
  aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1160)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c7004.reg)
	c:RegisterEffect(e0)
  --Search
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
  e1:SetDescription(aux.Stringid(7004,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCondition(c7004.thcon)
  e1:SetTarget(c7004.thtg)
  e1:SetOperation(c7004.thop)
  c:RegisterEffect(e1)
  --Indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c7004.efilter)
	c:RegisterEffect(e4)
  --ATK
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c7004.atkcon)
	e2:SetValue(c7004.atkval)
	c:RegisterEffect(e2)
end

function c7004.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(7004,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function c7004.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetFlagEffect(7004)~=0
end
function c7004.thfil(c)
  return ((c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)) or (c:IsLocation(LOCATION_GRAVE))) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function c7004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c7004.thfil,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c7004.thop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
	local g=Duel.SelectMatchingCard(tp,c7004.thfil,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	  Duel.SendtoHand(g,tp,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,g)
	end
  end
end

function c7004.efilter(e,re,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end

function c7004.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandlerPlayer() and (ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
end
function c7004.atkfil(c)
	return c:IsFaceup() and c:IsSetCard(0x9f)
end
function c7004.atkval(e,c)
	return Duel.GetMatchingGroupCount(c7004.atkfil,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)*100
end
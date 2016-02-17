--Scripted by Eerie Code
--Performapal Swing Cobra
function c7003.initial_effect(c)
  --Pendulum
  aux.EnablePendulumAttribute(c)
  --Send topdeck
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7003,0))
  e1:SetCategory(CATEGORY_DECKDES)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_BATTLE_DAMAGE)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
	e1:SetCondition(c7003.ddcon)
	e1:SetTarget(c7003.ddtg)
	e1:SetOperation(c7003.ddop)
  c:RegisterEffect(e1)
  --Direct attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e6)
  --Change position
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c7003.poscon)
	e2:SetOperation(c7003.posop)
	c:RegisterEffect(e2)
end

function c7003.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c7003.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
end
function c7003.ddop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
end

function c7003.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c7003.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENCE)
	end
end
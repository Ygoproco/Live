--Scripted by Eerie Code
--Tsukumo Slash
function c25334372.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCountLimit(1,25334372+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c25334372.atkcon)
	e2:SetOperation(c25334372.atkop)
	c:RegisterEffect(e2)
end

function c25334372.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a:IsControler(tp) and d and d:IsControler(1-tp) and a:GetAttack()<d:GetAttack()
end
function c25334372.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if not a or not a:IsRelateToBattle() then return end
	local atk=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(atk)
	a:RegisterEffect(e1)
end
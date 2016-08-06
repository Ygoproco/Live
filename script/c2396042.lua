--Steel Calvary of Dinon
function c2396042.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c2396042.destg)
	e2:SetOperation(c2396042.desop)
	c:RegisterEffect(e2)
end
function c2396042.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsFaceup() and bc:IsType(TYPE_PENDULUM) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,1,0,0)
end
function c2396042.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(c:GetAttack()/2)
		e1:SetReset(RESET_PHASE+RESET_DAMAGE_CAL)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENCE)
		e2:SetValue(c:GetDefence()/2)
		c:RegisterEffect(e2)
	end
end
		

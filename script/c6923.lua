--Scripted by Eerie Code
--Rector Pendulum, the Dracoverlord
function c6923.initial_effect(c)
	--Pendulum
	aux.EnablePendulumAttribute(c)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c6923.distg)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCondition(c6923.descon)
	e3:SetTarget(c6923.destg)
	e3:SetOperation(c6923.desop)
	c:RegisterEffect(e3)
end

function c6923.distg(e,c)
	return c:IsType(TYPE_PENDULUM)
end

function c6923.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsFaceup() and bc:IsType(TYPE_PENDULUM) end
end
function c6923.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return a:IsDestructable() and d:IsDestructable() end
	local g=Group.FromCards(a,d)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c6923.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
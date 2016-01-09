--Scripted by Eerie Code
--Rector Pendulum, the Dracoverlord
function c7127502.initial_effect(c)
	--Pendulum
	aux.EnablePendulumAttribute(c)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c7127502.distg)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(c7127502.destg)
	e3:SetOperation(c7127502.desop)
	c:RegisterEffect(e3)
end

function c7127502.distg(e,c)
	return c:IsType(TYPE_PENDULUM)
end

function c7127502.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local bc=c:GetBattleTarget() 
	if chk==0 then return bc and bc:IsFaceup() and bc:IsType(TYPE_PENDULUM) end 
	local g=Group.FromCards(c,bc) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0) 
end
function c7127502.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=c:GetBattleTarget() 
	if c:IsRelateToBattle() and tc:IsRelateToBattle() then 
		local g=Group.FromCards(c,tc) 
		Duel.Destroy(g,REASON_EFFECT) 
	end 
end
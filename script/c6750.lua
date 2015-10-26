--Scripted by Eerie Code
--Samurai Cavalry of Reptier
function c6750.initial_effect(c)
	--Pendulum Summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6750,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c6750.destg)
	e1:SetOperation(c6750.desop)
	c:RegisterEffect(e1)
end

function c6750.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsFaceup() and not d:IsType(TYPE_PENDULUM) and d:IsControler(1-tp) and d:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c6750.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
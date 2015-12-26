--Scripted by Eerie Code
--Chasm of Spikes
function c75902998.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c75902998.condition)
	e1:SetTarget(c75902998.target)
	e1:SetOperation(c75902998.activate)
	c:RegisterEffect(e1)
	if not c75902998.global_check then
		c75902998.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c75902998.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end

function c75902998.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:GetControler()~=tp and a:GetFlagEffect(75902998)>0
end
function c75902998.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=Duel.GetAttacker()
	if chk==0 then return bc and bc:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetBaseAttack()/2)
end
function c75902998.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,tc:GetBaseAttack()/2,REASON_EFFECT)
	end
end
function c75902998.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(75902998)==0 then
			tc:RegisterFlagEffect(75902998,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
--Scripted by Eerie Code
--Number 35: Ravenous Tarantula
function c90162951.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2)
	c:EnableReviveLimit()
	--boost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c90162951.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90162951,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetCondition(c90162951.damcon)
	--e3:SetTarget(c90162951.damtg)
	e3:SetOperation(c90162951.damop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(90162951,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c90162951.descost)
	e4:SetTarget(c90162951.destg)
	e4:SetOperation(c90162951.desop)
	c:RegisterEffect(e4)
end
c90162951.xyz_number=35

function c90162951.atkval(e,c)
	local tp=c:GetControler()
	return math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
end

function c90162951.damfil(c,sp)
	return c:GetSummonPlayer()==sp
end
--function c90162951.damcon(e,tp,eg,ep,ev,re,r,rp)
--	return eg:IsExists(c90162951.damfil,1,nil,1-tp) and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS)) and e:GetHandler():GetOverlayCount()>0
--end
--function c90162951.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chk==0 then return true end
--	Duel.SetTargetPlayer(1-tp)
--	Duel.SetTargetParam(600)
--	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
--end
function c90162951.damop(e,tp,eg,ep,ev,re,r,rp)
	--local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	--Duel.Hint(HINT_CARD,0,90162951)
	--Duel.Damage(p,d,REASON_EFFECT)
	if eg:IsExists(c90162951.damfil,1,nil,1-tp) and e:GetHandler():GetOverlayCount()>0 then
		Duel.Hint(HINT_CARD,0,90162951)
		Duel.Damage(1-tp,600,REASON_EFFECT)
	end
end

function c90162951.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c90162951.desfil(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and c:IsDestructable()
end
function c90162951.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c90162951.desfil,tp,0,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c90162951.desfil,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c90162951.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c90162951.desfil,tp,0,LOCATION_MZONE,c,c:GetAttack())
	local ct=Duel.Destroy(g,REASON_EFFECT)
end

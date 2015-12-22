--Scripted by Eerie Code
--Number 84: Pain Gainer
function c26556950.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,2,c26556950.ovfilter,aux.Stringid(26556950,0))
	c:EnableReviveLimit()
	--boost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c26556950.atkval)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c26556950.regcon)
	e2:SetOperation(c26556950.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26556950,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c26556950.damcon)
	e3:SetOperation(c26556950.damop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26556950,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c26556950.descost)
	e4:SetTarget(c26556950.destg)
	e4:SetOperation(c26556950.desop)
	c:RegisterEffect(e4)
end
c26556950.xyz_number=84

function c26556950.ovfilter(c)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:GetOverlayCount()>=2 and (rk==8 or rk==9 or rk==10)
end

function c26556950.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetRank)*200
end

function c26556950.regcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c26556950.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(26556950,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function c26556950.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()>0 and ep~=tp and c:GetFlagEffect(26556950)~=0
end
function c26556950.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26556950)
	Duel.Damage(1-tp,600,REASON_EFFECT)
end

function c26556950.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c26556950.desfil(c,atk)
	return c:IsFaceup() and c:IsDefenceBelow(atk) and c:IsDestructable()
end
function c26556950.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26556950.desfil,tp,0,LOCATION_MZONE,1,c,c:GetDefence()) end
	local g=Duel.GetMatchingGroup(c26556950.desfil,tp,0,LOCATION_MZONE,c,c:GetDefence())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c26556950.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c26556950.desfil,tp,0,LOCATION_MZONE,c,c:GetDefence())
	local ct=Duel.Destroy(g,REASON_EFFECT)
end

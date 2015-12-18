--Scripted by Eerie Code
--Number 38: Hope Harbinger Dragon Titanic Galaxy
function c6681.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6681,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c6681.negcon)
	e1:SetTarget(c6681.negtg)
	e1:SetOperation(c6681.negop)
	c:RegisterEffect(e1)
	--Change attack target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6681,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c6681.atkcon)
	e2:SetCost(c6681.atkcost)
	e2:SetOperation(c6681.atkop)
	c:RegisterEffect(e2)
	--ATK Up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6681,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c6681.descon)
	e3:SetTarget(c6681.destg)
	e3:SetOperation(c6681.desop)
	c:RegisterEffect(e3)
end
c6681.xyz_number=38

function c6681.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainDisablable(ev)
end
function c6681.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c6681.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		Duel.NegateEffect(ev)
		tc:CancelToGrave()
		Duel.Overlay(e:GetHandler(),tc)
	end
end

function c6681.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c6681.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c6681.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if a:IsAttackable() and not a:IsImmuneToEffect(e) then
		Duel.CalculateDamage(a,c)
	end
end

function c6681.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsReason(REASON_BATTLE+REASON_EFFECT) and tc:IsPreviousLocation(LOCATION_MZONE) and tc:GetPreviousControler()==tp and tc:IsType(TYPE_XYZ)
end
function c6681.desfil(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c6681.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c6681.desfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6681.desfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c6681.desfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c6681.desop(e,tp,eg,ep,ev,re,r,rp)
	local atk=eg:GetFirst():GetBaseAttack()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
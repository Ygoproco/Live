--Scripted by Eerie Code
--Super Quantum Mecha Beast Granpulse
function c85252081.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c85252081.atcon)
	c:RegisterEffect(e2)
	--Destroy (Ignition)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(85252081,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c85252081.descon2)
	e1:SetCost(c85252081.descost)
	e1:SetTarget(c85252081.destg)
	e1:SetOperation(c85252081.desop)
	c:RegisterEffect(e1)
	--Destroy (Quick)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c85252081.descon)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(85252081,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c85252081.mttg)
	e4:SetOperation(c85252081.mtop)
	c:RegisterEffect(e4)
end

function c85252081.atcon(e)
	return e:GetHandler():GetOverlayCount()==0
end

function c85252081.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c85252081.desfil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c85252081.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c:IsLocation(LOCATION_ONFIELD) and c85252081.desfil(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(85252081)==0 and Duel.IsExistingTarget(c85252081.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,c85252081.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(85252081,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c85252081.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c85252081.descon2(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,12369277)
end
function c85252081.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,12369277)
end

function c85252081.mtfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10dd)
end
function c85252081.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85252081.mtfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
end
function c85252081.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c85252081.mtfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
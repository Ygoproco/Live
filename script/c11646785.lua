--Scripted by Eerie Code
--Super Quantum Mecha Beast Aeroboros
function c11646785.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c11646785.atcon)
	c:RegisterEffect(e2)
	--Destroy (Ignition)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11646785,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11646785.descost)
	e1:SetTarget(c11646785.destg)
	e1:SetOperation(c11646785.desop)
	c:RegisterEffect(e1)
	--Destroy (Quick)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c11646785.descon)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11646785,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c11646785.mttg)
	e4:SetOperation(c11646785.mtop)
	c:RegisterEffect(e4)
end

function c11646785.atcon(e)
	return e:GetHandler():GetOverlayCount()==0
end

function c11646785.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11646785.desfil(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c11646785.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=e:GetHandler() and c11646785.desfil(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c11646785.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c11646785.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c11646785.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE)
	end
end

function c11646785.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,85374678)
end

function c11646785.mtfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10dd)
end
function c11646785.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11646785.mtfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
end
function c11646785.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c11646785.mtfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
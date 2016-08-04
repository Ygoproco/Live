--方界波動
--Cubic Aura
--Scripted by Eerie Code
function c35058588.initial_effect(c)
	--ATK change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c35058588.tg)
	e1:SetOperation(c35058588.op)
	c:RegisterEffect(e1)
	--Counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c35058588.cntcost)
	e2:SetTarget(c35058588.cnttg)
	e2:SetOperation(c35058588.cntop)
	c:RegisterEffect(e2)
end
function c35058588.fil1(c)
	return c:IsFaceup() and c:IsSetCard(0xe3)
end
function c35058588.fil2(c)
	return c:IsFaceup()
end
function c35058588.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c35058588.fil1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c35058588.fil2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(35058588,0))
	local g1=Duel.SelectTarget(tp,c35058588.fil1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(35058588,1))
	Duel.SelectTarget(tp,c35058588.fil2,tp,0,LOCATION_MZONE,1,1,nil)
end
function c35058588.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(hc:GetAttack()*2)
		if hc:RegisterEffect(e1) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK_FINAL)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue((tc:GetAttack())/2)
			tc:RegisterEffect(e2)
		end
	end
end
function c35058588.cfilter(c)
	return c:IsSetCard(0xe3) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c35058588.tgfil(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c35058588.cntcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=Duel.GetMatchingGroupCount(c35058588.tgfil,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return ec>0 and e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c35058588.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c35058588.cfilter,tp,LOCATION_GRAVE,0,1,ec,nil)
	g:AddCard(e:GetHandler())
	local ct=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(ct-1)
end
function c35058588.cnttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local mc=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,mc,nil)
end
function c35058588.cntop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=tg:GetFirst()
	while tc do
		if tc:IsFaceup() then tc:AddCounter(0x39,1) end
		tc=tg:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTarget(c35058588.distg)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	Duel.RegisterEffect(e2,tp)
end
function c35058588.distg(e,c)
	return c:GetCounter(0x39)>0
end
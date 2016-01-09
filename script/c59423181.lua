--融合識別
--Script by mercury233
function c59423181.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c59423181.target)
	e1:SetOperation(c59423181.activate)
	c:RegisterEffect(e1)
end
function c59423181.filter(c)
	return c:IsType(TYPE_FUSION)
end
function c59423181.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(Auxiliary.TRUE,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c59423181.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Auxiliary.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
end
function c59423181.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c59423181.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	if Card.IsFusionCode then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(59423181,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_FUSION_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(cg:GetFirst():GetCode())
		tc:RegisterEffect(e1)
	else --temp implementation for old version
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(59423181,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(cg:GetFirst():GetCode())
		tc:RegisterEffect(e1)
	end
end

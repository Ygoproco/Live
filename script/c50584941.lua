--Scripted by Eerie Code
--Red Supremacy
function c50584941.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c50584941.cost)
	e1:SetTarget(c50584941.target)
	e1:SetOperation(c50584941.activate)
	c:RegisterEffect(e1)
end

function c50584941.cfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x1045) and c:IsAbleToRemoveAsCost()
end
function c50584941.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50584941.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c50584941.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c50584941.filter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x1045) and c:IsFaceup()
end
function c50584941.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50584941.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50584941.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c50584941.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c50584941.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=e:GetLabel()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		tc:RegisterEffect(e1)
		tc:CopyEffect(code,RESET_EVENT+0x1fe0000)
	end
end

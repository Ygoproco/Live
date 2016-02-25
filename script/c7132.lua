--ダイナミスト・アンキロス
--Dinomist Ankylos
--Script by mercury233
function c7132.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7132,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c7132.negcon)
	e1:SetOperation(c7132.negop)
	c:RegisterEffect(e1)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetTarget(c7132.target)
	c:RegisterEffect(e2)
end
function c7132.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd8) and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c7132.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)	
	return e:GetHandler():GetFlagEffect(7132)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
		and g and g:IsExists(c7132.tfilter,1,e:GetHandler(),tp) and Duel.IsChainDisablable(ev)
end
function c7132.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(7132,1)) then
		e:GetHandler():RegisterFlagEffect(7132,RESET_EVENT+0x1fe0000,0,1)
		Duel.NegateEffect(ev)
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c7132.target(e,c)
	return c:IsSetCard(0xd8)
end
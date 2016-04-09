--Scripted by Eerie Code
--Fusion Doom Waltz
function c34449261.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c34449261.tg)
	e1:SetOperation(c34449261.op)
	c:RegisterEffect(e1)
end

function c34449261.fil1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0xad) and Duel.IsExistingTarget(c34449261.fil2,tp,0,LOCATION_MZONE,1,nil,c,tp)
end
function c34449261.fil2(c,fc,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and Duel.GetMatchingGroupCount(c34449261.fil3,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,fc)>0
end
function c34449261.fil3(c,oc,fc)
	return c~=oc and c~=fc and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsDestructable()
end
function c34449261.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c34449261.fil1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c34449261.fil1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local fc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c34449261.fil2,tp,0,LOCATION_MZONE,1,1,nil,fc,tp)
	local oc=g2:GetFirst()
	local mc=Duel.GetMatchingGroup(c34449261.fil3,tp,LOCATION_MZONE,LOCATION_MZONE,nil,oc,fc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,mc,mc:GetCount(),0,0)
end
function c34449261.damfil(c,tp)
	return c:GetPreviousControler()==tp
end
function c34449261.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==2 then
		local fc=tg:GetFirst()
		local oc=tg:GetNext()
		local dam=fc:GetAttack()+oc:GetAttack()
		local mg=Duel.GetMatchingGroup(c34449261.fil3,tp,LOCATION_MZONE,LOCATION_MZONE,nil,oc,fc)
		if Duel.Destroy(mg,REASON_EFFECT)==0 then return end
		Duel.BreakEffect()
		local og=Duel.GetOperatedGroup()
		if og:FilterCount(c34449261.damfil,nil,tp)>0 then Duel.Damage(tp,dam,REASON_EFFECT) end
		if og:FilterCount(c34449261.damfil,nil,1-tp)>0 then Duel.Damage(1-tp,dam,REASON_EFFECT) end
	end
end
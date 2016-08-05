--魔界劇団の楽屋入り
--Entering the Abyss Actor Dressing Room
--Scripted by Eerie Code
function c59057953.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59057953+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c59057953.con)
	e1:SetTarget(c59057953.tg)
	e1:SetOperation(c59057953.op)
	c:RegisterEffect(e1)
end

function c59057953.aafil(c)
	return c:IsSetCard(0x10ec)
end

function c59057953.con(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return tc1 and c59057953.aafil(tc1) and tc2 and c59057953.aafil(tc2)
end
function c59057953.fil(c)
	return c:IsType(TYPE_PENDULUM) and c59057953.aafil(c) and not c:IsForbidden()
end
function c59057953.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c59057953.fil,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
end
function c59057953.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59057953.fil,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(59057953,0))
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(59057953,0))
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 then
		if Duel.SendtoExtraP then
			Duel.SendtoExtraP(tg1,tp,REASON_EFFECT)
		else
			Duel.PSendtoExtra(tg1,tp,REASON_EFFECT)
		end
	end
end

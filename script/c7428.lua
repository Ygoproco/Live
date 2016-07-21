--魔界劇団の楽屋入り
--Entering the Abyss Actor Dressing Room
--Scripted by Eerie Code
function c7428.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7428+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c7428.con)
	e1:SetTarget(c7428.tg)
	e1:SetOperation(c7428.op)
	c:RegisterEffect(e1)
end

function c7428.aafil(c)
	return (c:IsSetCard(0x10ee) or c:IsSetCard(0x120e))
end

function c7428.con(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return tc1 and c7428.aafil(tc1) and tc2 and c7428.aafil(tc2)
end
function c7428.fil(c)
	return c:IsType(TYPE_PENDULUM) and c7428.aafil(c) and not c:IsForbidden()
end
function c7428.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c7428.fil,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
end
function c7428.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c7428.fil,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(7428,0))
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(7428,0))
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 then
		Duel.PSendtoExtra(tg1,tp,REASON_EFFECT)
	end
end

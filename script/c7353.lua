--アメイジング・ペンデュラム
--Amazing Pendulum
--Scripted by Eerie Code
function c7353.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCountLimit(1,7353+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c7353.con)
	e1:SetTarget(c7353.tg)
	e1:SetOperation(c7353.op)
	c:RegisterEffect(e1)
end

function c7353.cfil(c)
	local seq=c:GetSequence()
	return seq==6 or seq==7
end
function c7353.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c7353.cfil,tp,LOCATION_SZONE,0,nil)==0
end
function c7353.fil(c)
	return c:IsFaceup() and c:IsSetCard(0x98) and c:IsAbleToHand()
end
function c7353.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c7353.fil,tp,LOCATION_EXTRA,0,nil)
		return mg:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,0)
end
function c7353.op(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c7353.fil,tp,LOCATION_EXTRA,0,nil)
	if mg:GetClassCount(Card.GetCode)<2 then return end
	local g=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=mg:Select(tp,1,1,nil)
		local tc=g2:GetFirst()
		g:AddCard(tc)
		mg:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end

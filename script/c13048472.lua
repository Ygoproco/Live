--Scripted by Eerie Code
--Pre-Preparation of Rites
function c13048472.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13048472)
	e1:SetTarget(c13048472.target)
	e1:SetOperation(c13048472.activate)
	c:RegisterEffect(e1)
end

function c13048472.fil1(c)
	if bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand() then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if mt==nil or mt.fit_monster==nil then return false end
		return Duel.IsExistingMatchingCard(c13048472.fil2,c:GetOwner(),LOCATION_DECK+LOCATION_GRAVE,0,1,nil,mt)
	else
		return false
	end
end
function c13048472.fil2(c,class)
	if bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand() then
		for i=1,#class.fit_monster do
			if c:IsCode(class.fit_monster[i]) then return true end
		end
		return false
	else return false end
end
function c13048472.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13048472.fil1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,0)
end
function c13048472.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,c13048472.fil1,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()==0 then return end
	local code=g1:GetFirst():GetOriginalCode()
	local mt=_G["c" .. code]
	local g2=Duel.SelectMatchingCard(tp,c13048472.fil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,mt)
	if g2:GetCount()==0 then return end
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end

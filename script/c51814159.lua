--Scripted by Eerie Code
--Raidraptor - Necro Vulture
function c51814159.initial_effect(c)
	--Recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c51814159.cost)
	e1:SetTarget(c51814159.target)
	e1:SetOperation(c51814159.operation)
	c:RegisterEffect(e1)
end

function c51814159.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0xba) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0xba)
	Duel.Release(g,REASON_COST)
end
function c51814159.filter(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end
function c51814159.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c51814159.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c51814159.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c51814159.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c51814159.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c51814159.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c51814159.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return sumtype==SUMMON_TYPE_XYZ and not se:GetHandler():IsSetCard(0x95)
end
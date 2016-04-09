--Scripted by Eerie Code
--Frightfur Sanctuary
function c74839123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c74839123.actcost)
	c:RegisterEffect(e1)
	--Change to Frightfur
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c74839123.sertg)
	e2:SetValue(0xad)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EFFECT_ADD_FUSION_SETCODE)
	c:RegisterEffect(e2b)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74839123,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c74839123.tdtg)
	e3:SetOperation(c74839123.tdop)
	c:RegisterEffect(e3)
end

function c74839123.cfil1(c)
	return c:IsAbleToGraveAsCost()
end
function c74839123.cfil2(c)
	return c:IsSetCard(0xad) and c:IsAbleToGraveAsCost()
end
function c74839123.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74839123.cfil1,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c74839123.cfil2,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c74839123.cfil1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c74839123.cfil2,tp,LOCATION_EXTRA,0,2,2,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end

function c74839123.sertg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end

function c74839123.tdfil(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xad) and c:IsAbleToDeck()
end
function c74839123.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c74839123.tdfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c74839123.tdfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c74839123.tdfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c74839123.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

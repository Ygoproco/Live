--Scripted by Eerie Code
--D/D Sage of Prophecy Newton
function c6604.initial_effect(c)
	--Pendulum Summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6604,2))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(aux.nfbdncon)
	e2:SetTarget(c6604.splimit)
	c:RegisterEffect(e2)
	--Disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c6604.distg)
	e3:SetOperation(c6604.disop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(6604,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,6604)
	e4:SetCost(c6604.thcost)
	e4:SetTarget(c6604.thtg)
	e4:SetOperation(c6604.thop)
	c:RegisterEffect(e4)
end

function c6604.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xaf) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c6604.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(6604)==0 end
end
function c6604.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsChainDisablable(ev) then return end
	if not aux.damcon1(e,tp,eg,ep,ev,re,r,rp) then return end
	if not re:IsActiveType(TYPE_TRAP) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(6604,0)) then
		c:RegisterFlagEffect(6604,RESET_EVENT+0x1fe0000,0,1)
		Duel.NegateEffect(ev)
		Duel.Destroy(c,REASON_EFFECT)
	end
end

function c6604.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c6604.thfilter(c)
	return (c:IsSetCard(0xae) or c:IsSetCard(0xaf)) and not c:IsCode(6604) and c:IsAbleToHand()
end
function c6604.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6604.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6604.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c6604.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c6604.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
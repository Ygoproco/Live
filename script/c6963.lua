--Scripted by Eerie Code
--Amorphage Infection
function c6963.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c6963.tg)
	e2:SetValue(c6963.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,6963)
	e4:SetCondition(c6963.thcon1)
	e4:SetTarget(c6963.thtg)
	e4:SetOperation(c6963.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_RELEASE)
	e5:SetCondition(c6963.thcon2)
	c:RegisterEffect(e5)
end

function c6963.tg(e,c)
	return c:IsSetCard(0xe2)
end
function c6963.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe2)
end
function c6963.val(e,c)
	return Duel.GetMatchingGroupCount(c6963.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*100
end

function c6963.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c6963.thfilter1,1,nil,tp)
end
function c6963.thfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and c:GetPreviousControler()==tp
end
function c6963.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c6963.thfilter2,1,nil,tp,r)
end
function c6963.thfilter2(c,tp,r)
	return c:IsType(TYPE_MONSTER) and bit.band(r,REASON_EFFECT)~=0 and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and c:GetPreviousControler()==tp
end
function c6963.thfil(c)
	return c:IsSetCard(0xe2) and c:IsAbleToHand()
end
function c6963.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6963.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c6963.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6963.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
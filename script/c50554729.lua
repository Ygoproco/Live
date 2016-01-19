--Scripted by Eerie Code
--Amorphage Infection
function c50554729.initial_effect(c)
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
	e2:SetTarget(c50554729.tg)
	e2:SetValue(c50554729.val)
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
	e4:SetCountLimit(1,50554729)
	e4:SetCondition(c50554729.thcon1)
	e4:SetTarget(c50554729.thtg)
	e4:SetOperation(c50554729.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_RELEASE)
	e5:SetCondition(c50554729.thcon2)
	c:RegisterEffect(e5)
end

function c50554729.tg(e,c)
	return c:IsSetCard(0xe0)
end
function c50554729.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c50554729.val(e,c)
	return Duel.GetMatchingGroupCount(c50554729.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*100
end

function c50554729.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50554729.thfilter1,1,nil,tp)
end
function c50554729.thfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetPreviousControler()==tp
end
function c50554729.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50554729.thfilter2,1,nil,tp,r)
end
function c50554729.thfilter2(c,tp,r)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and c:GetPreviousControler()==tp
end
function c50554729.thfil(c)
	return c:IsSetCard(0xe0) and c:IsAbleToHand()
end
function c50554729.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50554729.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50554729.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50554729.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
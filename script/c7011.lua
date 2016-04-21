--Electromagnet Warrior Alpha
function c7011.initial_effect(c)
	--add to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7011,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c7011.thtg)
	e1:SetOperation(c7011.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	--summon 1 Magnet
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7011,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c7011.rmcon)
	e4:SetCost(c7011.rmcost)
	e4:SetTarget(c7011.rmtg)
	e4:SetOperation(c7011.rmop)
	c:RegisterEffect(e4)
end
function c7011.thfilter(c)
	return c:GetLevel()==8 and c:IsSetCard(0xE8) and c:IsAbleToHand()
end
function c7011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,7011)==0
		and Duel.IsExistingMatchingCard(c7011.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,7011,RESET_PHASE+PHASE_END,0,1)
end
function c7011.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7011.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c7011.rmfilter(c,e,tp)
	return c:IsSetCard(0x2066) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7011.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c7011.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c7011.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c7011.rmfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c7011.rmfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c7011.rmfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c7011.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
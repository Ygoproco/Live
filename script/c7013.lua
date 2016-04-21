--Electromagnet Warrior Gamma
function c7013.initial_effect(c)
	--add to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c7013.thtg)
	e1:SetOperation(c7013.rmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	--summon 1 Magnet
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7013,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c7013.rmcon)
	e4:SetCost(c7013.rmcost)
	e4:SetTarget(c7013.rmtg)
	e4:SetOperation(c7013.rmop)
	c:RegisterEffect(e4)
end
function c7013.thfilter(c,e,tp)
	return c:GetLevel()<=4 and c:IsSetCard(0x2066) and not c:IsCode(7013) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c7013.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetFlagEffect(tp,7013)==0
		and Duel.IsExistingTarget(c7013.thfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c7013.thfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c7013.rmfilter(c,e,tp)
	return c:IsSetCard(0x2066) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7013.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c7013.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c7013.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c7013.rmfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c7013.rmfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c7013.rmfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c7013.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end

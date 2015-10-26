--Scripted by Eerie Code
--Raidraptor - Call
function c6525.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,6525+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c6525.cost)
	e1:SetTarget(c6525.target)
	e1:SetOperation(c6525.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(6525,ACTIVITY_SPSUMMON,c6525.counterfilter)
end

function c6525.counterfilter(c)
	return c:IsSetCard(0xba)
end

function c6525.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(6525,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c6525.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c6525.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xba)
end
function c6525.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba) and Duel.IsExistingMatchingCard(c6525.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c6525.filter2(c,e,tp,cd)
	return c:IsCode(cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6525.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c6525.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c6525.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c6525.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c6525.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c6525.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end
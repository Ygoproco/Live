--Scripted by Eerie Code
--Metalphosis Combination
function c7171.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SPSUMMON,TIMING_SPSUMMON)
	e1:SetTarget(c7171.sptg1)
	e1:SetOperation(c7171.spop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7171,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCost(c7171.spcost)
	e2:SetTarget(c7171.sptg2)
	e2:SetOperation(c7171.spop2)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7171,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c7171.thtg)
	e3:SetOperation(c7171.thop)
	c:RegisterEffect(e3)
end

function c7171.filter(c)
	return c:IsType(TYPE_FUSION) and c:GetSummonType()==SUMMON_TYPE_FUSION
end
function c7171.spfil(c,e,tp,tc)
	return c:IsSetCard(0xe2) and c:GetLevel()<tc:GetLevel() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7171.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7171.spfil(chkc,e,tp,e:GetLabelObject()) end
	if chk==0 then return true end
	e:SetLabel(0)
	e:SetLabelObject(nil)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	if res then
		local g=teg:Filter(c7171.filter,nil)
		if g:GetCount()>0 then
			local tg=g:GetMaxGroup(Card.GetLevel)
			local tc=tg:GetFirst()
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c7171.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp,tc) and Duel.SelectYesNo(tp,94) then
				e:SetLabelObject(tc)
				e:SetCategory(CATEGORY_SPECIAL_SUMMON)
				e:SetProperty(EFFECT_FLAG_CARD_TARGET)
				e:GetHandler():RegisterFlagEffect(7171,RESET_PHASE+PHASE_END,0,1)
				e:SetLabel(1)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g2=Duel.SelectTarget(tp,c7171.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
			end
		end
	end
end
function c7171.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c7171.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(7171)==0 end
	e:GetHandler():RegisterFlagEffect(7171,RESET_PHASE+PHASE_END,0,1)
end
function c7171.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7171.spfil(chkc,e,tp,e:GetLabelObject()) end
	local tg=eg:Filter(c7171.filter,nil)
	if chk==0 then
		if tg:GetCount()==0 then return false end
		local tc=tg:GetMaxGroup(Card.GetLevel):GetFirst()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c7171.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp,tc)
	end
	e:SetLabelObject(tg:GetMaxGroup(Card.GetLevel):GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c7171.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end

function c7171.thfil(c)
	return c:IsSetCard(0xe2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c7171.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(c7171.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c7171.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7171.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
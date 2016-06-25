--水晶機巧－スモーガー
--Crystron Smoger
--Scripted by Eerie Code
function c7318.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7318,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,7318)
	e1:SetTarget(c7318.sptg)
	e1:SetOperation(c7318.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7318,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,7318)
	e2:SetCost(c7318.thcost)
	e2:SetTarget(c7318.thtg)
	e2:SetOperation(c7318.thop)
	c:RegisterEffect(e2)
end

function c7318.spfil(c,e,tp)
	return c:IsSetCard(0xeb) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7318.spcfil(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c7318.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and c7318.spcfil(chkc) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<-1 then return false end
		local loc=LOCATION_ONFIELD
		if ft==0 then loc=LOCATION_MZONE end
		e:SetLabel(loc)
		return Duel.IsExistingTarget(c7318.spcfil,tp,loc,0,1,nil)
			and Duel.IsExistingMatchingCard(c7318.spfil,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c7318.spcfil,tp,e:GetLabel(),0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c7318.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c7318.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetTargetRange(1,0)
			e3:SetTarget(c7318.splimit)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c7318.splimit(e,c,tp,sumtp,sumpos)
	return not (c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO)) and c:IsLocation(LOCATION_EXTRA)
end

function c7318.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c7318.thfil(c)
	return c:IsSetCard(0xeb) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c7318.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7318.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c7318.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7318.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
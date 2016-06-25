--水晶機巧－プラシレータ
--Crystron Prasirator
--Scripted by Eerie Code
function c7317.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7317,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,7317)
	e1:SetTarget(c7317.sptg)
	e1:SetOperation(c7317.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7317,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,7317)
	e2:SetCost(c7317.spcost2)
	e2:SetTarget(c7317.sptg2)
	e2:SetOperation(c7317.spop2)
	c:RegisterEffect(e2)
end

function c7317.spfil(c,e,tp)
	return c:IsSetCard(0xeb) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7317.spcfil(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c7317.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and c7317.spcfil(chkc) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<-1 then return false end
		local loc=LOCATION_ONFIELD
		if ft==0 then loc=LOCATION_MZONE end
		e:SetLabel(loc)
		return Duel.IsExistingTarget(c7317.spcfil,tp,loc,0,1,nil)
			and Duel.IsExistingMatchingCard(c7317.spfil,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c7317.spcfil,tp,e:GetLabel(),0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c7317.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c7317.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetTargetRange(1,0)
			e3:SetTarget(c7317.splimit)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c7317.splimit(e,c,tp,sumtp,sumpos)
	return not (c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO)) and c:IsLocation(LOCATION_EXTRA)
end

function c7317.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c7317.spfil2(c,e,tp)
	return c:IsSetCard(0xeb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7317.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c7317.spfil2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7317.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7317.spfil2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--Scripted by Eerie Code
--D/D Lamia
function c6606.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6606,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,6606)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(c6606.spcost)
	e1:SetTarget(c6606.sptg)
	e1:SetOperation(c6606.spop)
	c:RegisterEffect(e1)
end

function c6606.cfilter(c)
	return (c:IsSetCard(0xae) or c:IsSetCard(0xaf)) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and not c:IsCode(6606) and c:IsAbleToGraveAsCost()
end
function c6606.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if ft<0 then return false end
		if ft==0 then 
			return Duel.IsExistingMatchingCard(c6606.cfilter,tp,LOCATION_MZONE,0,1,nil) 
		else
			return Duel.IsExistingMatchingCard(c6606.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if ft==0 then
		local g=Duel.SelectMatchingCard(tp,c6606.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,c6606.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c6606.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c6606.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
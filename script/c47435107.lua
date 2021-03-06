--Scripted by Eerie Code
--Primal Cry
function c47435107.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,10441498)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(c47435107.spcon)
	e1:SetCost(c47435107.spcost)
	e1:SetTarget(c47435107.sptg)
	e1:SetOperation(c47435107.spop)
	c:RegisterEffect(e1)
end

function c47435107.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c47435107.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c47435107.spfil(c,e,tp,turn)
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetTurnID()==turn
	--if not c:IsType(TYPE_RITUAL) then
	--  return false
	--elseif not c:IsPreviousLocation(LOCATION_ONFIELD) then
	--  Debug.Message(""..c:GetCode().." was not on field.")
	--  return false
	--elseif c:GetTurnID()~=turn then
	 --   Debug.Message(""..c:GetCode().." wasn't sent this turn.")
	--  return false
	--else return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
end
function c47435107.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local turn=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c47435107.spfil(chkc,e,tp,turn) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c47435107.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp,turn) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c47435107.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,turn)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c47435107.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

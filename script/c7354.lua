--ＲＵＭ－幻影騎士団ラウンチ
--Rank-Up-Magic The Phantom Knights of Launch
--Scripted by Eerie Code
function c7354.initial_effect(c)
  --
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetHintTiming(0,TIMING_MAIN_END)
  e1:SetCondition(c7354.spcon)
  e1:SetTarget(c7354.sptg)
  e1:SetOperation(c7354.spop)
  c:RegisterEffect(e1)
  --
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCost(c7354.xyzcost)
  e2:SetTarget(c7354.xyztg)
  e2:SetOperation(c7354.xyzop)
  c:RegisterEffect(e2)
end

function c7354.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c7354.spfil1(c,e,tp)
  local rk=c:GetRank()
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:GetOverlayCount()==0 and Duel.IsExistingMatchingCard(c7354.spfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
end
function c7354.spfil2(c,e,tp,mc,rk)
	if c:GetOriginalCode()==6165656 and mc:GetCode()~=48995978 then return false end
  return c:GetRank()==rk and c:IsAttribute(ATTRIBUTE_DARK) and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c7354.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7354.spfil1(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(c7354.spfil1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c7354.spfil1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7354.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7354.spfil2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		c:CancelToGrave()
		Duel.Overlay(sc,Group.FromCards(c))
		sc:CompleteProcedure()
	end
end

function c7354.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c7354.xyzfil(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c7354.matfil(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10db) and not c:IsImmuneToEffect(e)
end
function c7354.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7354.xyzfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7354.xyzfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c7354.matfil,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c7354.xyzfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7354.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c7354.matfil,tp,LOCATION_HAND,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end

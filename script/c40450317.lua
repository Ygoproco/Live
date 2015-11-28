--Scripted by Eerie Code
--Ties of the Brethren
function c40450317.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c40450317.cost)
	e1:SetTarget(c40450317.target)
	e1:SetOperation(c40450317.activate)
	c:RegisterEffect(e1)
end

function c40450317.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 and Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40450317.filter1(c,e,tp)
	return c:IsFaceup() and c:IsLevelBelow(4) and Duel.IsExistingMatchingCard(c40450317.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c40450317.filter2(c,e,tp,tc)
	return c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute()) and c:GetLevel()==tc:GetLevel() and c:GetCode()~=tc:GetCode() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c40450317.filter3,tp,LOCATION_DECK,0,1,nil,e,tp,c,tc:GetCode())
end
function c40450317.filter3(c,e,tp,tc,code)
	return c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute()) and c:GetLevel()==tc:GetLevel() and c:GetCode()~=tc:GetCode() and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40450317.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40450317.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingTarget(c40450317.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SelectTarget(tp,c40450317.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c40450317.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g1=Duel.SelectMatchingCard(tp,c40450317.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
	if g1:GetCount()==0 then return end
	local g2=Duel.SelectMatchingCard(tp,c40450317.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc,g1:GetFirst():GetCode())
	if g2:GetCount()==0 then return end
	g1:Merge(g2)
	Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c40450317.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.SpecialSummonComplete()
end
function c40450317.splimit(e,c)
	return true
end
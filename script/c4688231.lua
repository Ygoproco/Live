--メタルフォーゼ・ミスリエル
--Metalphosis Mythriel
--Scripted by Eerie Code
function c4688231.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c4688231.fscon)
	e0:SetOperation(c4688231.fsop)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4688231,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,4688231)
	e1:SetTarget(c4688231.rttg)
	e1:SetOperation(c4688231.rtop)
	c:RegisterEffect(e1)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(4688231,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c4688231.spcon)
	e6:SetTarget(c4688231.sptg)
	e6:SetOperation(c4688231.spop)
	c:RegisterEffect(e6)
end

function c4688231.filter1(c)
	return c:IsFusionSetCard(0xe1)
end
function c4688231.filter2(c)
	return c:IsType(TYPE_PENDULUM)
end
function c4688231.exfilter(c)
	return c:IsHasEffect(77693536)
end
function c4688231.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local f1=c4688231.filter1
	local f2=c4688231.filter2
	local chkf=bit.band(chkfnf,0xff)
	local exg=Duel.GetMatchingGroup(c4688231.exfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
	exg:Merge(g)
	local mg=exg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler(),true) then return false end
		return (f1(gc) and mg:IsExists(f2,1,gc))
			or (f2(gc) and mg:IsExists(f1,1,gc)) end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
	local tc=mg:GetFirst()
	while tc do
		if f1(tc) then g1:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if f2(tc) then g2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(aux.FConditionFilterF2,1,nil,g2)
	else return g1:IsExists(aux.FConditionFilterF2,1,nil,g2) end
end
function c4688231.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local f1=c4688231.filter1
	local f2=c4688231.filter2
	local chkf=bit.band(chkfnf,0xff)
	local exg=Duel.GetMatchingGroup(c4688231.exfilter,tp,LOCATION_SZONE,0,nil)
	exg:Merge(eg)
	local g=exg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	if gc then
		local sg=Group.CreateGroup()
		if f1(gc) then sg:Merge(g:Filter(f2,gc)) end
		if f2(gc) then sg:Merge(g:Filter(f1,gc)) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(aux.FConditionFilterF2c,nil,f1,f2)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	sg:RemoveCard(tc1)
	local b1=f1(tc1)
	local b2=f2(tc1)
	if b1 and not b2 then sg:Remove(aux.FConditionFilterF2r,nil,f1,f2) end
	if b2 and not b1 then sg:Remove(aux.FConditionFilterF2r,nil,f2,f1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end

function c4688231.rtfil(c)
	return c:IsSetCard(0xe1) and c:IsAbleToDeck()
end
function c4688231.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c4688231.rtfil,tp,LOCATION_GRAVE,0,2,nil) and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c4688231.rtfil,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c4688231.rtop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local ex2,g2=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	g1=g1:Filter(Card.IsRelateToEffect,nil,e)
	if g1:GetCount()>0 and Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)~=0 and g2:GetFirst():IsRelateToEffect(e) then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
end

function c4688231.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c4688231.spfil(c,e,tp)
	return c:IsSetCard(0xe1) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c4688231.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c4688231.spfil,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c4688231.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,c4688231.spfil,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

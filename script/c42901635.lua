--電磁石の戦士マグネット・ベルセリオン
--Verserion the Electromagna Warrior
function c42901635.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c42901635.spcon)
	e0:SetOperation(c42901635.spop)
	c:RegisterEffect(e0)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c42901635.descost)
	e2:SetTarget(c42901635.destg)
	e2:SetOperation(c42901635.desop)
	c:RegisterEffect(e2)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c42901635.spcon2)
	e4:SetTarget(c42901635.sptg2)
	e4:SetOperation(c42901635.spop2)
	c:RegisterEffect(e4)
end

function c42901635.spfil(c,cd)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and c:IsCode(cd) and c:IsAbleToRemoveAsCost()
end
function c42901635.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c42901635.spfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,42023223)
		and Duel.IsExistingMatchingCard(c42901635.spfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,79418928)
		and Duel.IsExistingMatchingCard(c42901635.spfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,15502037)
end
function c42901635.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c42901635.spfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,42023223)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c42901635.spfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,79418928)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c42901635.spfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,15502037)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

function c42901635.descfil(c)
	return c:IsSetCard(0x2066) and c:IsLevelBelow(4) and c:IsAbleToRemoveAsCost()
end
function c42901635.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c42901635.descfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c42901635.descfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c42901635.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c42901635.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c42901635.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c42901635.spfil2(c,cd,e,tp)
	return c:IsFaceup() and c:IsCode(cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c42901635.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingTarget(c42901635.spfil2,tp,LOCATION_REMOVED,0,1,nil,42023223,e,tp)
		and Duel.IsExistingTarget(c42901635.spfil2,tp,LOCATION_REMOVED,0,1,nil,79418928,e,tp)
		and Duel.IsExistingTarget(c42901635.spfil2,tp,LOCATION_REMOVED,0,1,nil,15502037,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c42901635.spfil2,tp,LOCATION_REMOVED,0,1,1,nil,42023223,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c42901635.spfil2,tp,LOCATION_REMOVED,0,1,1,nil,79418928,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectTarget(tp,c42901635.spfil2,tp,LOCATION_REMOVED,0,1,1,nil,15502037,e,tp)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,3,0,0)
end
function c42901635.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=3 then return end
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end

--煉獄の騎士 ヴァトライムス
--Tellarknight Vatlamyus
--Scripted by Eerie Code
function c64414267.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9c),4,2)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--Xyz Change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64414267,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c64414267.spcon1)
	e2:SetCost(c64414267.spcost)
	e2:SetTarget(c64414267.sptg)
	e2:SetOperation(c64414267.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c64414267.spcon2)
	c:RegisterEffect(e3)
end

function c64414267.spcfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9c)
end
function c64414267.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c64414267.spcfil,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)<7
end
function c64414267.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c64414267.spcfil,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=7
end
function c64414267.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and c:GetFlagEffect(64414267)==0 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.DiscardHand(tp,nil,1,1,REASON_COST)
	c:RegisterFlagEffect(64414267,RESET_CHAIN,0,1)
end
function c64414267.spfil(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x9c) and e:GetHandler():IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c64414267.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c64414267.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c64414267.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c64414267.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c64414267.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c64414267.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end

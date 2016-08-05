--堕天使ルシフェル
--Darklord Lucifer
--Scripted by Eerie Code
function c25451652.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25451652,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c25451652.spcon)
	e2:SetTarget(c25451652.sptg)
	e2:SetOperation(c25451652.spop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c25451652.imcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(25451652,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCategory(CATEGORY_DECKDES+CATEGORY_RECOVER)
	e4:SetTarget(c25451652.tgtg)
	e4:SetOperation(c25451652.tgop)
	c:RegisterEffect(e4)
end

function c25451652.spcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c25451652.spfil(c,e,tp)
	return c:IsSetCard(0xef) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c25451652.spcfil(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c25451652.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local mg=Duel.GetMatchingGroupCount(c25451652.spcfil,tp,0,LOCATION_MZONE,nil)
		return lc>0 and mg>0 and Duel.IsExistingMatchingCard(c25451652.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) 
	end
end
function c25451652.spop(e,tp,eg,ep,ev,re,r,rp)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if lc<1 then return end
	local mg=Duel.GetMatchingGroupCount(c25451652.spcfil,tp,0,LOCATION_MZONE,nil)
	if mg==0 then return end
	local mc=math.min(lc,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c25451652.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,mc,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c25451652.imfil(c)
	return c:IsFaceup() and c:IsSetCard(0xef)
end
function c25451652.imcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c25451652.imfil,tp,LOCATION_MZONE,0,1,e:GetHandler())
end

function c25451652.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c25451652.imfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,0) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c25451652.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c25451652.imfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct>0 and Duel.DiscardDeck(tp,ct,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		local oc=og:FilterCount(Card.IsSetCard,nil,0xef)
		if oc>0 then Duel.Recover(tp,oc*500,REASON_EFFECT) end
	end
end
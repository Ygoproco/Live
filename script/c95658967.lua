--Ritual Sanctuary
--Scripted by Eerie Code
function c95658967.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95658967,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetCountLimit(1,95658967)
	e2:SetCost(c95658967.thcost)
	e2:SetTarget(c95658967.thtg)
	e2:SetOperation(c95658967.thop)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95658967,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,95658967+1)
	e3:SetCost(c95658967.spcost)
	e3:SetTarget(c95658967.sptg)
	e3:SetOperation(c95658967.spop)
	c:RegisterEffect(e3)
end

function c95658967.thcfil(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c95658967.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95658967.thcfil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c95658967.thcfil,1,1,REASON_COST+REASON_DISCARD)
end
function c95658967.thfil(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand() and ((c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT)) or c:IsType(TYPE_SPELL))
end
function c95658967.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95658967.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c95658967.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c95658967.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c95658967.spcfil(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeckAsCost()
end
function c95658967.spfil(c,e,tp,sc,eq)
	if c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e) and c:GetLevel()>0 then
		if eq then return c:GetLevel()==sc else return c:GetLevel()<=sc end
	end
end
function c95658967.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c95658967.spcfil,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c95658967.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp,sg:GetCount()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95658967.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,sg:GetCount())
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local hg=sg:Select(tp,tc:GetLevel(),tc:GetLevel(),nil)
	e:SetLabel(tc:GetLevel())
	e:SetLabelObject(tc)
	Duel.SendtoDeck(hg,tp,2,REASON_COST)
end
function c95658967.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv=e:GetLabel()
	local tc=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsLocation(tp) and c95658967.spfil(chkc,e,tp,lv,true) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c95658967.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Scripted by Eerie Code
--True Draco-Awakening
function c87765315.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c87765315.target)
	e1:SetOperation(c87765315.activate)
	c:RegisterEffect(e1)
end

function c87765315.cfil1(c)
	return c:IsFaceup() and c:IsSetCard(0xda)
end
function c87765315.cfil2(c)
	return c:IsFaceup() and c:IsSetCard(0xc7) and not c:IsType(TYPE_PENDULUM)
end
function c87765315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87765315.cfil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c87765315.cfil2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c87765315.spfil(c,e,tp)
	return (c:IsSetCard(0xda) or c:IsSetCard(0xc7)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c87765315.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c87765315.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(87765315,0)) then
		Duel.BreakEffect()
		local tg=Duel.SelectMatchingCard(tp,c87765315.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(tg,0,tp,tp,true,false,POS_FACEUP)
	end
end

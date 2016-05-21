--光波双顎機
--Cipher Twin Raptor
--Scripted by Eerie Code
function c7310.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c7310.spcon)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7310,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,7310)
	e2:SetCost(c7310.cost)
	e2:SetTarget(c7310.tg)
	e2:SetOperation(c7310.op)
	c:RegisterEffect(e2)
end

function c7310.spfil(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA
end
function c7310.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.IsExistingMatchingCard(c7310.spfil,c:GetControler(),0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c7310.cfil(c,e,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c7310.fil,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function c7310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7310.cfil,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.DiscardHand(tp,c7310.cfil,1,1,REASON_COST+REASON_DISCARD,e:GetHandler(),e,tp)
end
function c7310.fil(c,e,tp)
	return c:IsSetCard(0xe5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7310.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7310.fil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7310.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c7310.fil,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c7310.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c7310.splimit(e,c)
	return not c:IsSetCard(0xe5)
end

--妖精伝姫－ターリア
--Fairy Tail - Talia
--Scripted by Eerie Code
function c42921475.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(42921475,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c42921475.sptg)
	e1:SetOperation(c42921475.spop)
	c:RegisterEffect(e1)
	--overwrite
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(42921475,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,42921475)
	e2:SetCondition(c42921475.con)
	e2:SetCost(c42921475.cost)
	e2:SetOperation(c42921475.op)
	c:RegisterEffect(e2)
end

function c42921475.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c42921475.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c42921475.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c42921475.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c42921475.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c42921475.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep~=tp and (rc:GetType()==TYPE_SPELL or rc:GetType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c42921475.fil(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c42921475.cfil(c,tp)
	return Duel.IsExistingMatchingCard(c42921475.fil,tp,LOCATION_MZONE,0,1,c)
end
function c42921475.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c42921475.cfil,1,c,tp) end
	local g=Duel.SelectReleaseGroup(tp,c42921475.cfil,1,1,c,tp)
	Duel.Release(g,REASON_COST)
end
function c42921475.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c42921475.repop)
end
function c42921475.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():CancelToGrave(false)
	local g=Duel.GetMatchingGroup(c42921475.fil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:Select(tp,1,1,nil)
		local p=0
		if POS_FACEDOWN_DEFENSE then
			p=POS_FACEDOWN_DEFENSE
		else
			p=POS_FACEDOWN_DEFENCE
		end
		Duel.ChangePosition(sg:GetFirst(),p)
	end
end

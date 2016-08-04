--超こいこい
--Chokoikoi
--Scripted by Eerie Code
function c7356.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7356+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c7356.tg)
	e1:SetOperation(c7356.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCost(c7356.spcost)
	e2:SetTarget(c7356.sptg)
	e2:SetOperation(c7356.spop)
	c:RegisterEffect(e2)
end

function c7356.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c7356.fil(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe6) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c7356.op(e,tp,eg,ep,ev,re,r,rp)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if lc<1 then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local sg=g:Filter(c7356.fil,nil,e,tp)
	if sg:GetCount()>lc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:FilterSelect(tp,c7356.fil,lc,lc,nil,e,tp)
	end
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e3)
			Duel.SpecialSummonComplete()
			g:RemoveCard(tc)
			tc=sg:GetNext()
		end
	end
	if g:GetCount()>0 then
		local ct=Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-(1000*ct))
	end	
end

function c7356.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Release(sg,REASON_COST)
end
function c7356.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c7356.fil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7356.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7356.fil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end

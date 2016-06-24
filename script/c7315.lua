--水晶機巧－クオン
--Crystron Quon
--Scripted by Eerie Code
function c7315.initial_effect(c)
		--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7315,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,7315)
	e1:SetCondition(c7315.spcon)
	e1:SetTarget(c7315.sptg)
	e1:SetOperation(c7315.spop)
	c:RegisterEffect(e1)
end

function c7315.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	--Preparation for 1.033.9.2 update
	local bpc1=(ph==PHASE_BATTLE or (ph==PHASE_DAMAGE and not Duel.IsDamageCalculated()))
	--This check will be operative as of 1.033.9.2
	local bpc2=false
	if PHASE_BATTLE_START then bpc2=(ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) end
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or bpc1 or bpc2)
end
function c7315.spfil(c,e,tp,mc)
		local mg=Group.FromCards(c,mc)
		return not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.IsExistingMatchingCard(c7315.synfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end
function c7315.synfil(c,mg)
		return c:IsRace(RACE_MACHINE) and c:IsSynchroSummonable(nil,mg)
end
function c7315.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c7315.spfil,tp,LOCATION_HAND,0,1,nil,e,tp,e:GetHandler()) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7315.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c7315.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp,c)
	local tc=tg:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
		local mg=Group.FromCards(c,tc)
			local g=Duel.GetMatchingGroup(c7315.synfil,tp,LOCATION_EXTRA,0,nil,mg)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
			end
		end
end
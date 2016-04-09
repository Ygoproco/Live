--Scripted by Eerie Code
--Blackwing -  Gofu the Hazy Shadow
function c9929398.initial_effect(c)
  c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9929398.spcon)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9929398,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9929398.condition)
	e2:SetTarget(c9929398.target)
	e2:SetOperation(c9929398.operation)
	c:RegisterEffect(e2)
	--Synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9929398,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c9929398.spcost)
	e3:SetTarget(c9929398.sptg)
	e3:SetOperation(c9929398.spop)
	c:RegisterEffect(e3)
end

function c9929398.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c9929398.condition(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetPreviousLocation()==LOCATION_HAND
end
function c9929398.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c9929398.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,9929398+1,0,0x4011,0,0,1,RACE_WINDBEAST,ATTRIBUTE_DARK) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,9929398+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e2,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e5,true)
	end
	Duel.SpecialSummonComplete()
end

function c9929398.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsLevelAbove(1) and not c:IsType(TYPE_TUNER)
end
function c9929398.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c9929398.cfilter,tp,LOCATION_MZONE,0,c)
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c9929398.sptgfil,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel(),mg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9929398.spfil1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
	local sc=g:GetFirst()
	e:SetLabelObject(sc)
	local lv=c:GetLevel()
	local g1=Group.FromCards(c)
	local tglv=sc:GetLevel()
	while lv<tglv do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g2=mg:FilterSelect(tp,c9929398.spfil2,1,1,nil,tglv-lv,mg,sc)
			local gc=g2:GetFirst()
			lv=lv+gc:GetLevel()
			mg:RemoveCard(gc)
			g1:AddCard(gc)
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c9929398.sptgfil(c,e,tp,lv,mg)
	return c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and mg:CheckWithSumEqual(Card.GetOriginalLevel,c:GetLevel()-lv,1,63,c) and c:IsCanBeEffectTarget(e)
end
function c9929398.spfil1(c,e,tp,tc)
	if c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e) then
		local mg=Duel.GetMatchingGroup(c9929398.cfilter,tp,LOCATION_MZONE,0,tc)
		return mg:IsExists(c9929398.spfil2,1,nil,c:GetLevel()-tc:GetLevel(),mg,c)
	else
		return false
	end
end
function c9929398.spfil2(c,limlv,mg,sc)
	local fg=mg:Clone()
	fg:RemoveCard(c)
	local newlim=limlv-c:GetLevel()
	if newlim==0 then return true else return fg:CheckWithSumEqual(Card.GetOriginalLevel,newlim,1,63,sc) end
end
function c9929398.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local sc=e:GetLabelObject()
	Duel.SetTargetCard(sc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sc,1,0,0)
end
function c9929398.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
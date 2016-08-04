--Scripted by Eerie Code
--Ultimitl Bishbalkin the Ultimate Legendary God
function c90884403.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c90884403.sprcon)
	e2:SetOperation(c90884403.sprop)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c90884403.atkval)
	c:RegisterEffect(e4)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(90884403,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e5:SetCountLimit(1)
	e5:SetCondition(c90884403.spcon)
	e5:SetTarget(c90884403.sptg)
	e5:SetOperation(c90884403.spop)
	c:RegisterEffect(e5)
end

function c90884403.sprfilter1(c,tp)
	local lv=c:GetLevel()
	return lv>7 and c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c90884403.sprfilter2,tp,LOCATION_MZONE,0,1,nil,lv)
end
function c90884403.sprfilter2(c,lv)
	return c:IsFaceup() and c:GetLevel()==lv and not c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()
end
function c90884403.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c90884403.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c90884403.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c90884403.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c90884403.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end

function c90884403.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)*1000
end

function c90884403.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph==PHASE_MAIN2 and e:GetHandler():GetAttackAnnouncedCount()==0)
end
function c90884403.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return ft1>0 and ft2>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,90884403+1,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) and Duel.IsPlayerCanSpecialSummonMonster(tp,90884403+1,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,1-tp) end
	local ft=math.min(ft1,ft2)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft*2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft*2,0,0)
end
function c90884403.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if not c:IsRelateToEffect(e) then return end
	local ft=math.min(ft1,ft2)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,90884403+1,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) or not Duel.IsPlayerCanSpecialSummonMonster(tp,90884403+1,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,1-tp) then return end
	--local token=Duel.CreateToken(tp,90884403+1)
	--Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	--token=Duel.CreateToken(tp,90884403+1)
	--Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENCE)
	--ft=ft-1
	--while ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,90884403+1,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) and Duel.IsPlayerCanSpecialSummonMonster(tp,90884403+1,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK,1-tp) and Duel.SelectYesNo(tp,aux.Stringid(90884403,1)) do
		--token=Duel.CreateToken(tp,90884403+1)
		--Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		--token=Duel.CreateToken(tp,90884403+1)
		--Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENCE)
		--ft=ft-1
	--end
	local token=nil
	for i=1,ft do
		token=Duel.CreateToken(tp,90884403+1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		token=Duel.CreateToken(tp,90884403+1)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENCE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
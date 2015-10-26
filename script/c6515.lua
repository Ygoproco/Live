--Scripted by Eerie Code
--Raidraptor - Last Strix
function c6515.initial_effect(c)
	--Special Summon + Recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6515,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCountLimit(1)
	e1:SetCondition(c6515.con)
	e1:SetTarget(c6515.tg)
	e1:SetOperation(c6515.op)
	c:RegisterEffect(e1)
	--Special Summon Xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6515,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6515)
	e2:SetCost(c6515.spcost)
	e2:SetTarget(c6515.sptg)
	e2:SetOperation(c6515.spop)
	c:RegisterEffect(e2)
end

function c6515.con(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and ((a:GetControler()==tp and a:IsSetCard(0xba)) or (d:GetControler()==tp and d:IsSetCard(0xba)))
end
function c6515.cost(e,tp,eg,ep,ev,re,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,6515)==0 end
	Duel.RegisterFlagEffect(tp,6515,RESET_PHASE+RESET_DAMAGE_CAL,0,1)
end
function c6515.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c6515.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,TYPE_SPELL+TYPE_TRAP)
		Duel.Recover(tp,ct*100,REASON_EFFECT)
	end
end

function c6515.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c6515.spfil(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xba) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6515.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c6515.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c6515.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c6515.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then 
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(0,1)
		e3:SetValue(1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local de=Effect.CreateEffect(e:GetHandler())
		de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		de:SetCode(EVENT_PHASE+PHASE_END)
		de:SetCountLimit(1)
		de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		de:SetLabelObject(tc)
		de:SetOperation(c6515.tdop)
		de:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		Duel.RegisterEffect(de,tp)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end 
end
function c6515.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsLocation(LOCATION_MZONE) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
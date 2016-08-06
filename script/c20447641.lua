--機殻の凍結
--Qliphort Down
--Scripted by Eerie Code
--Credit for the temporary procedure goes to nekrozar
function c20447641.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20447641.tg)
	e1:SetOperation(c20447641.op)
	c:RegisterEffect(e1)
end

function c20447641.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,20447641,0xaa,0x41,4,1800,1000,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c20447641.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,20447641,0xaa,0x21,4,1800,1000,RACE_MACHINE,ATTRIBUTE_EARTH) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		c:RegisterEffect(e1,true)
		if EFFECT_TRIPLE_TRIBUTE then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_TRIPLE_TRIBUTE)
			e2:SetCondition(c20447641.dtcon)
			e2:SetValue(c20447641.dtval)
			e2:SetReset(RESET_EVENT+0x1fc0000)
			c:RegisterEffect(e2)
		else
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(20447641,0))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
			e3:SetRange(LOCATION_MZONE)
			e3:SetTargetRange(LOCATION_HAND,0)
			e3:SetCondition(c20447641.tmpcon)
			e3:SetTarget(c20447641.tmptg)
			e3:SetOperation(c20447641.tmpop)
			e3:SetValue(SUMMON_TYPE_ADVANCE)
			e3:SetReset(RESET_EVENT+0x1fc0000)
			c:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_LIMIT_SET_PROC)
			c:RegisterEffect(e4)
		end
		Duel.SpecialSummonComplete()
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e5:SetTargetRange(LOCATION_ONFIELD,0)
		e5:SetTarget(c20447641.indtg)
		e5:SetValue(1)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	end
end
function c20447641.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xaa)
end
function c20447641.dtcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c20447641.dtval(e,c)
	return c:IsSetCard(0x10aa)
end
function c20447641.tmpfilter(c)
	return c:IsCode(20447641) and c:IsReleasable() and c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c20447641.tmpcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c20447641.tmpfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20447641.tmptg(e,c)
	return c:IsSetCard(0x10aa) or c:IsCode(27279764,40061558)
end
function c20447641.tmpop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c20447641.tmpfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
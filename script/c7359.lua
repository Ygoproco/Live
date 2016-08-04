--化合電界
--Spark Field
--SCripted by Eerie Code
function c7359.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7359,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetCondition(c7359.ntcon)
	e2:SetTarget(c7359.nttg)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7359,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetTarget(c7359.destg)
	e4:SetOperation(c7359.desop)
	c:RegisterEffect(e4)
end

function c7359.ntcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c7359.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsType(TYPE_DUAL)
end

function c7359.descfil(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and c:IsDualState() and c:IsAbleToRemove()
end
function c7359.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c7359.descfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c7359.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c7359.descfil,tp,LOCATION_MZONE,0,1,1,nil)
	local rc=g:GetFirst()
	if rc and Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)>0 and rc:IsLocation(LOCATION_REMOVED) then
		g:KeepAlive()
		rc:RegisterFlagEffect(7359,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c7359.retcon)
		e1:SetOperation(c7359.retop)
		e1:SetLabelObject(rc)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c7359.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(7359)==0 then
		e:Reset()
		return false
	else
		return Duel.GetTurnPlayer()~=tp
	end
end
function c7359.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end

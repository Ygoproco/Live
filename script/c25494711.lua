--Scripted by Eerie Code
--Deskbot 009
function c25494711.initial_effect(c)
	--Increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25494711,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c25494711.atkcon)
	e1:SetTarget(c25494711.atktg)
	e1:SetOperation(c25494711.atkop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c25494711.aclimit)
	e2:SetCondition(c25494711.actcon)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c25494711.reptg)
	e3:SetOperation(c25494711.repop)
	c:RegisterEffect(e3)
end

function c25494711.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c25494711.atkfil(c)
	return c:IsFaceup() and c:IsSetCard(0xab) and not c:IsCode(25494711)
end
function c25494711.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c25494711.atkfil,tp,LOCATION_MZONE,0,1,c) end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_OATH)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c25494711.ftarget)
	e2:SetLabel(c:GetFieldID())
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)  
end
function c25494711.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=0
		local g=Duel.GetMatchingGroup(c25494711.atkfil,tp,LOCATION_MZONE,0,tc)
		local bc=g:GetFirst()
		while bc do
			atk=atk+bc:GetAttack()
			bc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
	end
end
function c25494711.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end

function c25494711.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c25494711.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function c25494711.repfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xab) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c25494711.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c25494711.repfilter,tp,LOCATION_ONFIELD,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(25494711,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c25494711.repfilter,tp,LOCATION_ONFIELD,0,1,1,c)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c25494711.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end

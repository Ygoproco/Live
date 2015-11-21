--Scripted by Eerie Code
--Dark Contract with the Yamimakai
function c6624.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Pendulum Set (Grave)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6624,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c6624.cost)
	e2:SetTarget(c6624.tg1)
	e2:SetOperation(c6624.op1)
	c:RegisterEffect(e2)
	--Pendulum Set (Extra)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6624,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c6624.cost)
	e3:SetTarget(c6624.tg2)
	e3:SetOperation(c6624.op2)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetCondition(c6624.damcon)
	e4:SetTarget(c6624.damtg)
	e4:SetOperation(c6624.damop)
	c:RegisterEffect(e4)
end

function c6624.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(6624)==0 end
	e:GetHandler():RegisterFlagEffect(6624,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c6624.fil1(c)
	return c:IsSetCard(0xaf) and c:IsType(TYPE_PENDULUM)
end
function c6624.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6624.fil1(chkc) end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) and Duel.IsExistingTarget(c6624.fil1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SelectTarget(tp,c6624.fil1,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c6624.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not e:GetHandler():IsRelateToEffect(e) or (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))==false then return end
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c6624.fil2(c)
	return c:IsFaceup() and c6624.fil1(c)
end
function c6624.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) and Duel.IsExistingMatchingCard(c6624.fil2,tp,LOCATION_EXTRA,0,1,nil) end
end
function c6624.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))==false then return end
	local g=Duel.SelectMatchingCard(tp,c6624.fil2,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c6624.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c6624.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function c6624.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
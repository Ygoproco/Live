--Scripted by Eerie Code
--Dark Contract with the Yamimakai
function c45974017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Pendulum Set (Grave)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45974017,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c45974017.cost)
	e2:SetTarget(c45974017.tg1)
	e2:SetOperation(c45974017.op1)
	c:RegisterEffect(e2)
	--Pendulum Set (Extra)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(45974017,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c45974017.cost)
	e3:SetTarget(c45974017.tg2)
	e3:SetOperation(c45974017.op2)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetCondition(c45974017.damcon)
	e4:SetTarget(c45974017.damtg)
	e4:SetOperation(c45974017.damop)
	c:RegisterEffect(e4)
end

function c45974017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(45974017)==0 end
	e:GetHandler():RegisterFlagEffect(45974017,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c45974017.fil1(c)
	return c:IsSetCard(0xaf) and c:IsType(TYPE_PENDULUM)
end
function c45974017.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c45974017.fil1(chkc) end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) and Duel.IsExistingTarget(c45974017.fil1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SelectTarget(tp,c45974017.fil1,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c45974017.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not e:GetHandler():IsRelateToEffect(e) or (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))==false then return end
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c45974017.fil2(c)
	return c:IsFaceup() and c45974017.fil1(c)
end
function c45974017.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) and Duel.IsExistingMatchingCard(c45974017.fil2,tp,LOCATION_EXTRA,0,1,nil) end
end
function c45974017.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))==false then return end
	local g=Duel.SelectMatchingCard(tp,c45974017.fil2,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c45974017.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c45974017.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function c45974017.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
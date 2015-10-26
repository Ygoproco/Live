--Scripted by Eerie Code
--Kaiju Capture Mission
function c6789.initial_effect(c)
	c:SetCounterLimit(0x37,3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c6789.target)
	e1:SetOperation(c6789.setop)
	c:RegisterEffect(e1)
	--Position
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c6789.settg)
	e2:SetOperation(c6789.setop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,6789)
	e3:SetCondition(c6789.drcon)
	e3:SetTarget(c6789.drtg)
	e3:SetOperation(c6789.drop)
	c:RegisterEffect(e3)
end

function c6789.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd4) and c:IsCanTurnSet()
end
function c6789.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c6789.filter(chkc) end
	if chk==0 then return true end
	if e:GetHandler():GetCounter(0x37)<3 and Duel.IsExistingTarget(c6789.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(6789,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_POSITION)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectTarget(tp,c6789.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
		e:GetHandler():RegisterFlagEffect(6789,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
	end
end
function c6789.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE)
		e:GetHandler():AddCounter(0x37,1)
	end
end

function c6789.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c6789.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(6789)==0 and e:GetHandler():GetCounter(0x37)<3 and Duel.IsExistingTarget(c6789.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c6789.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(6789,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c6789.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY+REASON_EFFECT)==REASON_DESTROY+REASON_EFFECT and rp==1-tp
end
function c6789.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c6789.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
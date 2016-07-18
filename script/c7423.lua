--魔界台本 「ファンタジー・マジック」
--Abyss Script - Fantasy Magic
--Scripted by Eerie Code
--return to hand effect by mercury233
function c7423.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c7423.target)
	e1:SetOperation(c7423.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7423,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c7423.tdcon)
	e2:SetTarget(c7423.tdtg)
	e2:SetOperation(c7423.tdop)
	c:RegisterEffect(e2)
end

function c7423.aafil(c)
	return (c:IsSetCard(0x10ee) or c:IsSetCard(0x120e))
end

function c7423.filter(c)
	return c:IsFaceup() and c7423.aafil(c)
end
function c7423.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7423.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7423.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c7423.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7423.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g=Group.CreateGroup()
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DAMAGE_STEP_END)
		e1:SetLabelObject(g)
		e1:SetOperation(c7423.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetDescription(aux.Stringid(7423,0))
		e2:SetCode(EVENT_BATTLED)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetLabelObject(e1)
		e2:SetOperation(c7423.regop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c7423.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:GetCount()>0 then
		local sg=g:Filter(Card.IsRelateToBattle,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		g:Clear()
	end
end
function c7423.regop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and not bc:IsStatus(STATUS_BATTLE_DESTROYED) then
		local g=e:GetLabelObject():GetLabelObject()
		g:AddCard(bc)
	end
end

function c7423.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and Duel.IsExistingMatchingCard(c7423.filter,tp,LOCATION_EXTRA,0,1,nil)
end
function c7423.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c7423.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end

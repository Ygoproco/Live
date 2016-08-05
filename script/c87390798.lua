--魔界台本 「ファンタジー・マジック」
--Abyss Script - Fantasy Magic
--Scripted by Eerie Code
--return to hand effect by mercury233
function c87390798.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c87390798.target)
	e1:SetOperation(c87390798.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87390798,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c87390798.tdcon)
	e2:SetTarget(c87390798.tdtg)
	e2:SetOperation(c87390798.tdop)
	c:RegisterEffect(e2)
end

function c87390798.aafil(c)
	return c:IsSetCard(0x10ec)
end

function c87390798.filter(c)
	return c:IsFaceup() and c87390798.aafil(c)
end
function c87390798.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c87390798.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c87390798.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c87390798.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c87390798.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local fid=tc:GetRealFieldID()
		--Debug.Message("Abyss Actor Field ID: "..fid)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetDescription(aux.Stringid(87390798,0))
		e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		local g=Group.CreateGroup()
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCategory(CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_DAMAGE_STEP_END)
		e1:SetLabelObject(g)
		e1:SetTarget(c87390798.rettg)
		e1:SetOperation(c87390798.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLED)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetLabel(fid)
		e2:SetLabelObject(e1)
		e2:SetOperation(c87390798.regop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c87390798.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c87390798.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:GetCount()>0 then
		local sg=g:Filter(Card.IsRelateToBattle,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		g:Clear()
	end
end
function c87390798.regop(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	--Debug.Message("Attacker FID: "..a:GetRealFieldID())
	local g=e:GetLabelObject():GetLabelObject()
	if not d then return end
	--Debug.Message("Target FID: "..d:GetRealFieldID())
	if a:GetRealFieldID()==fid and not d:IsStatus(STATUS_BATTLE_DESTROYED) then
		g:AddCard(d)
	elseif d:GetRealFieldID()==fid and not a:IsStatus(STATUS_BATTLE_DESTROYED) then
		g:AddCard(a)
	end
	--local bc=e:GetHandler():GetBattleTarget()
	--if bc and not bc:IsStatus(STATUS_BATTLE_DESTROYED) then
	--  local g=e:GetLabelObject():GetLabelObject()
	--  g:AddCard(bc)
	--end
end

function c87390798.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and Duel.IsExistingMatchingCard(c87390798.filter,tp,LOCATION_EXTRA,0,1,nil)
end
function c87390798.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c87390798.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end

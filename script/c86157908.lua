--Performapal Odd-Eyes Unicorn
-- Script By TNDMPT Group (ShirayukiCleber, Vinny41, FramDzi)
function c86157908.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Increase ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86157908,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c86157908.atkcon)
	e2:SetTarget(c86157908.atktg)
	e2:SetOperation(c86157908.atkop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(86157908,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c86157908.rectg)
	e3:SetOperation(c86157908.recop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c86157908.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsSetCard(0x99)
end
function c86157908.atkfil(c)
	return c:IsFaceup() and c:IsSetCard(0x9f) and c:GetAttack()>0
end
function c86157908.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc~=Duel.GetAttacker() and c86157908.atkfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c86157908.atkfil,tp,LOCATION_MZONE,0,1,Duel.GetAttacker()) end
	Duel.SelectTarget(tp,c86157908.atkfil,tp,LOCATION_MZONE,0,1,1,Duel.GetAttacker())
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,Duel.GetAttacker(),1,0,0)
end
function c86157908.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	local at=Duel.GetAttacker()
	if g:IsRelateToEffect(e) and at:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(g:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		at:RegisterEffect(e1)
	end
end
function c86157908.filter(c)
	return c:GetAttack()>0 and c:IsSetCard(0x9f)
end
function c86157908.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c86157908.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c86157908.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c86157908.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c86157908.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end

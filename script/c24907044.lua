--魔界劇団－プリティ・ヒロイン
--Abyss Actor - Pretty Heroine
--Scripted by Eerie Code
function c24907044.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c24907044.pcon)
	e1:SetTarget(c24907044.ptg)
	e1:SetOperation(c24907044.pop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24907044,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetTarget(c24907044.atktg)
	e2:SetOperation(c24907044.atkop)
	c:RegisterEffect(e2)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(24907044,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c24907044.setcon)
	e5:SetTarget(c24907044.settg)
	e5:SetOperation(c24907044.setop)
	c:RegisterEffect(e5)
end

function c24907044.aafil(c)
	return c:IsSetCard(0x10ec)
end
function c24907044.asfil(c)
	return c:IsSetCard(0x20ec)
end

function c24907044.pcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return ep==tp and a:IsControler(1-tp)
end
function c24907044.thfil(c,dam)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c24907044.aafil(c) and c:IsAttackBelow(dam) and c:IsAbleToHand()
end
function c24907044.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local dam=ev
	local b1=a:IsRelateToBattle()
	local b2=Duel.IsExistingMatchingCard(c24907044.thfil,tp,LOCATION_EXTRA,0,1,nil,dam)
	if chk==0 then return b1 or b2 end
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(24907044,0),aux.Stringid(24907044,1))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(24907044,0))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(24907044,1))+1
	end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	else
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	end
end
function c24907044.pop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if opt==0 then
		local a=Duel.GetAttacker()
		if a:IsRelateToBattle() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-ev)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			a:RegisterEffect(e1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c24907044.thfil,tp,LOCATION_EXTRA,0,1,1,nil,ev)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function c24907044.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c24907044.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ev)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end

function c24907044.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)) or c:IsReason(REASON_BATTLE)
end
function c24907044.setfil(c)
	return c24907044.asfil(c) and c:IsType(TYPE_SPELL) and c:IsSSetable(false)
end
function c24907044.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c24907044.setfil,tp,LOCATION_DECK,0,1,nil) end
end
function c24907044.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c24907044.setfil,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end

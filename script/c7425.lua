--魔界台本「火竜の住処」
--Abyss Script - Abode of the Fire Dragon
--Scripted by Eerie Code
function c7425.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c7425.target)
	e1:SetOperation(c7425.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7425,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,7425)
	e2:SetCondition(c7425.rmcon)
	e2:SetTarget(c7425.rmtg2)
	e2:SetOperation(c7425.rmop2)
	c:RegisterEffect(e2)
end

function c7425.aafil(c)
	return (c:IsSetCard(0x10ee) or c:IsSetCard(0x120e))
end

function c7425.filter(c)
	return c:IsFaceup() and c7425.aafil(c)
end
function c7425.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7425.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7425.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c7425.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7425.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetDescription(aux.Stringid(7425,0))
		e2:SetCategory(CATEGORY_REMOVE)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTarget(c7425.rmtg1)
		e2:SetOperation(c7425.rmop1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c7425.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,0,0)
end
function c7425.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g:GetCount()==0 then return end
	local ct=3
	if g:GetCount()<3 then ct=g:GetCount() end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local mg=g:FilterSelect(1-tp,Card.IsAbleToRemove,ct,ct,nil)
	if mg:GetCount()>0 then
		Duel.Remove(mg,nil,REASON_EFFECT)
	end
end

function c7425.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and Duel.IsExistingMatchingCard(c7425.filter,tp,LOCATION_EXTRA,0,1,nil)
end
function c7425.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c7425.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	if mg:GetCount()>0 then
		Duel.Remove(mg,nil,REASON_EFFECT)
	end
end
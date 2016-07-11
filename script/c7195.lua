--The Hidden City
--Scripted by Eerie Code
function c7195.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1,7195+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c7195.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetDescription(aux.Stringid(7195,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c7195.postg)
	e2:SetOperation(c7195.posop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7195,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c7195.condition)
	e3:SetTarget(c7195.postg)
	e3:SetOperation(c7195.operation)
	c:RegisterEffect(e3)
end

function c7195.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xec) and c:IsAbleToHand()
end
function c7195.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c7195.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(7195,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c7195.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c7195.posfil(c)
	local pos=0
	if POS_FACEDOWN_DEFENSE then pos=POS_FACEDOWN_DEFENSE else pos=POS_FACEDOWN_DEFENCE end
	return c:IsSetCard(0xec) and c:IsPosition(pos)
end
function c7195.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7195.posfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c7195.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pdd=0
	local pud=0
	if POS_FACEUP_DEFENSE then pud=POS_FACEUP_DEFENSE else pud=POS_FACEUP_DEFENCE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c7195.posfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	local pos=POS_FACEUP_ATTACK
	local opt=Duel.SelectOption(tp,1156,1155)
	if opt==1 then pos=pud end
	Duel.ChangePosition(tc,pos)
end

function c7195.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp
end
function c7195.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pdd=0
	local pud=0
	if POS_FACEUP_DEFENSE then pud=POS_FACEUP_DEFENSE else pud=POS_FACEUP_DEFENCE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c7195.posfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	local pos=POS_FACEUP_ATTACK
	local opt=Duel.SelectOption(tp,1156,1155)
	if opt==1 then pos=pud end
	if Duel.ChangePosition(tc,pos)>0 and Duel.SelectYesNo(tp,aux.Stringid(7195,2)) then
		Duel.BreakEffect()
		Duel.NegateAttack()
	end
end

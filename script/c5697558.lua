--The Hidden City
--Scripted by Eerie Code
function c5697558.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1,5697558+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c5697558.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetDescription(aux.Stringid(5697558,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c5697558.postg)
	e2:SetOperation(c5697558.posop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5697558,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c5697558.condition)
	e3:SetTarget(c5697558.postg)
	e3:SetOperation(c5697558.operation)
	c:RegisterEffect(e3)
end

function c5697558.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xed) and c:IsAbleToHand()
end
function c5697558.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c5697558.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(5697558,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c5697558.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c5697558.posfil(c)
	local pos=0
	if POS_FACEDOWN_DEFENSE then pos=POS_FACEDOWN_DEFENSE else pos=POS_FACEDOWN_DEFENCE end
	return c:IsSetCard(0xed) and c:IsPosition(pos)
end
function c5697558.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5697558.posfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c5697558.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pdd=0
	local pud=0
	if POS_FACEUP_DEFENSE then pud=POS_FACEUP_DEFENSE else pud=POS_FACEUP_DEFENCE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c5697558.posfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	local pos=POS_FACEUP_ATTACK
	local opt=Duel.SelectOption(tp,1156,1155)
	if opt==1 then pos=pud end
	Duel.ChangePosition(tc,pos)
end

function c5697558.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp
end
function c5697558.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pdd=0
	local pud=0
	if POS_FACEUP_DEFENSE then pud=POS_FACEUP_DEFENSE else pud=POS_FACEUP_DEFENCE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c5697558.posfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	local pos=POS_FACEUP_ATTACK
	local opt=Duel.SelectOption(tp,1156,1155)
	if opt==1 then pos=pud end
	if Duel.ChangePosition(tc,pos)>0 and Duel.SelectYesNo(tp,aux.Stringid(5697558,2)) then
		Duel.BreakEffect()
		Duel.NegateAttack()
	end
end

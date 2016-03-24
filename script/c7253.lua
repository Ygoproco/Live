--Scripted by Eerie Code
--Performapal Corn
function c7253.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7253,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c7253.thcon)
	e1:SetTarget(c7253.thtg)
	e1:SetOperation(c7253.thop)
	c:RegisterEffect(e1)
	--reduce damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7253,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c7253.reccon)
	e2:SetCost(c7253.reccost)
	e2:SetTarget(c7253.rectg)
	e2:SetOperation(c7253.recop)
	c:RegisterEffect(e2)
	if not c7253.global_check then
		c7253.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(7253)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(7253)
		Duel.RegisterEffect(ge2,0)
	end
end

function c7253.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK) and e:GetHandler():GetFlagEffect(7253)>0
end
function c7253.thcfil(c)
	return c:IsSetCard(0x9f) and c:IsAttackBelow(1000) and c:IsPosition(POS_FACEUP_ATTACK)
end
function c7253.thfil(c)
	return c:IsSetCard(0x99) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c7253.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc~=e:GetHandler() and c7253.thcfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7253.thcfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c7253.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c7253.thcfil,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c7253.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPosition(POS_FACEUP_ATTACK) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsPosition(POS_FACEUP_ATTACK) then return end
	local g=Group.FromCards(c,tc)
	Duel.ChangePosition(g,POS_FACEUP_DEFENCE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c7253.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end

function c7253.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c7253.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9f) and not c:IsCode(7253)
end
function c7253.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c7253.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c7253.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c7253.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c7253.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

--サイレント・バーニング
--Silent Burning
--Scripted by Diablade Zat
function c44968459.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44968459,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c44968459.drcon)
	e1:SetTarget(c44968459.target)
	e1:SetOperation(c44968459.operation)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44968459,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c44968459.thcost)
	e2:SetTarget(c44968459.thtg)
	e2:SetOperation(c44968459.thop)
	c:RegisterEffect(e2)
end

function c44968459.drfil(c)
	return c:IsSetCard(0xe8) and c:IsFaceup()
end
function c44968459.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	--Preparation for 1.033.9.2 update
	local bpc1=(ph==PHASE_BATTLE or (ph==PHASE_DAMAGE and not Duel.IsDamageCalculated()))
	--This check will be operative as of 1.033.9.2
	local bpc2=false
	if PHASE_BATTLE_START then bpc2=(ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) end
	return (bpc1 or bpc2) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) and Duel.IsExistingMatchingCard(c44968459.drfil,tp,LOCATION_MZONE,0,1,nil)
end
function c44968459.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ht2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsPlayerCanDraw(1-tp) and ht1<6 and ht2<6 end
	Duel.SetTargetPlayer(tp,1-tp)
	Duel.SetTargetParam(6-ht1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1-tp,tp,6-ht1)
end
function c44968459.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if(ht<6) then 
		Duel.Draw(tp,6-ht,REASON_EFFECT)
	end
	local ht=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if(ht<6) then 
		Duel.Draw(1-tp,6-ht,REASON_EFFECT)
	end
end

function c44968459.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c44968459.thfilter(c)
	return c:IsSetCard(0xe8) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c44968459.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44968459.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c44968459.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c44968459.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

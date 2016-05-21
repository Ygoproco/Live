--サイレント・バーニング
--Silent Burning
--Scripted by Diablade Zat
function c7054.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7054,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c7054.drcon)
	e1:SetTarget(c7054.target)
	e1:SetOperation(c7054.operation)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7054,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c7054.thcost)
	e2:SetTarget(c7054.thtg)
	e2:SetOperation(c7054.thop)
	c:RegisterEffect(e2)
end

function c7054.drfil(c)
	return c:IsSetCard(0xe8) and c:IsFaceUp()
end
function c7054.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_BATTLE or (ph==PHASE_DAMAGE and not Duel.IsDamageCalculated())) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) and Duel.IsExistingMatchingCard(c7054.drfil,tp,LOCATION_MZONE,0,1,nil)
end
function c7054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ht2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsPlayerCanDraw(1-tp) and ht1<6 and ht2<6 end
	Duel.SetTargetPlayer(tp,1-tp)
	Duel.SetTargetParam(6-ht1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1-tp,tp,6-ht1)
end
function c7054.operation(e,tp,eg,ep,ev,re,r,rp)
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

function c7054.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c7054.thfilter(c)
	return c:IsSetCard(0xe8) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c7054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7054.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c7054.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7054.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

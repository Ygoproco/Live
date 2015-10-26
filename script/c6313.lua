--Scripted by Eerie Code
--Gaia the Soaring Dragon Champion
function c6313.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c6313.mfilter1,c6313.mfilter2,true)
	c:EnableReviveLimit()
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetValue(66889139)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6313,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCost(c6313.cost)
	e2:SetTarget(c6313.thtg1)
	e2:SetOperation(c6313.tgop1)
	c:RegisterEffect(e2)
	--Change Position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6313,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(c6313.atktg)
	e3:SetOperation(c6313.atkop)
	c:RegisterEffect(e3)
end

function c6313.mfilter1(c)
	return c:IsSetCard(0xbd)
end
function c6313.mfilter2(c)
	return c:IsRace(RACE_DRAGON)
end

function c6313.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c6313.thfilter1(c)
	return c:IsCode(49328340) and c:IsAbleToHand()
end
function c6313.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6313.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c6313.tgop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6313.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c6313.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local at=Duel.GetAttackTarget()
		return at
	end
end
function c6313.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if tc:IsRelateToBattle() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
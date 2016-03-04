--Scripted by Eerie Code
--Amorphactor Psycho, the Vain Dracoverlord
function c98287529.initial_effect(c)
	c:EnableReviveLimit()
	--Skip Main Phase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c98287529.regop)
	c:RegisterEffect(e2)
	--Disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c98287529.distg)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98287529,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c98287529.condition)
	e4:SetTarget(c98287529.target)
	e4:SetOperation(c98287529.operation)
	c:RegisterEffect(e4)
end

function c98287529.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,98287529)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_M1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,98287529,RESET_PHASE+PHASE_END,0,1)
end

function c98287529.distg(e,c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end

function c98287529.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c98287529.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98287529.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98287529.filter(c)
	return c:IsSetCard(0xda) and not c:IsCode(98287529) and c:IsAbleToHand()
end
function c98287529.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98287529.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

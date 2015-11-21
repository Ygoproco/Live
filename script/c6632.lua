--Scripted by Eerie Code
--D/D Rebuild
function c6632.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xae))
	e2:SetValue(c6632.indval)
	c:RegisterEffect(e2)
	--Shuffle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6632,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c6632.cost)
	e3:SetTarget(c6632.target)
	e3:SetOperation(c6632.operation)
	c:RegisterEffect(e3)
end

function c6632.indval(e,re,tp)
	return e:GetHandlerPlayer()==1-tp
end

function c6632.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c6632.filter(c)
	return c:IsSetCard(0xaf) and c:IsAbleToDeck()
end
function c6632.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and chkc~=e:GetHandler() and c6632.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6632.filter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,c6632.filter,tp,LOCATION_REMOVED,0,1,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c6632.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
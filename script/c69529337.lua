--Scripted by Eerie Code
--Tramid Dancer
function c69529337.initial_effect(c)
  --To Deck
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(69529337,0))
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1)
  e1:SetTarget(c69529337.tdtg)
  e1:SetOperation(c69529337.tdop)
  c:RegisterEffect(e1)
  --Replace Field
  local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69529337,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c69529337.condition)
	e2:SetTarget(c69529337.target)
	e2:SetOperation(c69529337.operation)
	c:RegisterEffect(e2)
end

function c69529337.tdfil(c)
  return c:IsSetCard(0xe4) and c:IsAbleToDeck()
end
function c69529337.tdafil(c,e)
  return c:IsFaceup() and c:IsRace(RACE_ROCK) and not c:IsImmuneToEffect(e)
end
function c69529337.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c69529337.tdfil(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c69529337.tdfil,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c69529337.tdfil,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c69529337.tdop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
	local mg=Duel.GetMatchingGroup(c69529337.tdafil,tp,LOCATION_MZONE,0,nil,e)
	local mc=mg:GetFirst()
	while mc do
	  local e1=Effect.CreateEffect(c)
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_UPDATE_ATTACK)
	  e1:SetValue(500)
	  e1:SetReset(RESET_EVENT+0x1fe0000)
	  mc:RegisterEffect(e1)
	  local e2=e1:Clone()
	  e2:SetCode(EFFECT_UPDATE_DEFENCE)
	  mc:RegisterEffect(e2)
	  mc=mg:GetNext()
	end
  end
end

function c69529337.filter(c,tp,code)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0xe4) and c:GetActivateEffect():IsActivatable(tp) and not c:IsCode(code)
end
function c69529337.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c69529337.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc and tc:IsFaceup() and tc:IsSetCard(0xe4) and tc:IsAbleToGrave() and tc:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c69529337.filter,tp,LOCATION_DECK,0,1,nil,tp,tc:GetCode()) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end
function c69529337.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	if tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c69529337.filter,tp,LOCATION_DECK,0,1,1,nil,tp,tc1:GetCode())
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
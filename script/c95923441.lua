--Scripted by Eerie Code
--Tramid Hunter
function c95923441.initial_effect(c)
  --Double Summon
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCondition(c95923441.excon)
	e1:SetTarget(c95923441.extg)
	c:RegisterEffect(e1)
  --Replace Field
  local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95923441,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c95923441.condition)
	e2:SetTarget(c95923441.target)
	e2:SetOperation(c95923441.operation)
	c:RegisterEffect(e2)
end

function c95923441.exfil(c)
  return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c95923441.excon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c95923441.exfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c95923441.extg(e,c)
	return c:IsRace(RACE_ROCK)
end

function c95923441.filter(c,tp,code)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0xe4) and c:GetActivateEffect():IsActivatable(tp) and not c:IsCode(code)
end
function c95923441.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c95923441.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc and tc:IsFaceup() and tc:IsSetCard(0xe4) and tc:IsAbleToGrave() and tc:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c95923441.filter,tp,LOCATION_DECK,0,1,nil,tp,tc:GetCode()) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end
function c95923441.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	if tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c95923441.filter,tp,LOCATION_DECK,0,1,1,nil,tp,tc1:GetCode())
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
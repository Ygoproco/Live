--Union Hangar
function c7027.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCountLimit(1,7027+EFFECT_COUNT_CODE_OATH)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c7027.activate)
	c:RegisterEffect(e2)
	--equip from deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c7027.check)
	e3:SetTarget(c7027.tg)
	e3:SetOperation(c7027.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end

function c7027.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_UNION) and c:IsAbleToHand()
end
function c7027.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c7027.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(7027,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c7027.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c7027.LMU(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_UNION)
end
function c7027.checkFilter(c,tp)
	return c7027.LMU(c) and c:IsFaceup() and c:IsControler(tp)
end
function c7027.select(c,tp)
	return c7027.checkFilter(c,tp) and Duel.IsExistingMatchingCard(c7027.filter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c7027.filter2(c,code)
	return c7027.LMU(c) and not c:IsCode(code:GetCode()) and c:CheckEquipTarget(code)
end
function c7027.check(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7027.checkFilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c7027.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c7027.checkFilter(chkc,tp) end
	if chk==0 then return eg:FilterCount(c7027.select,nil,tp)>0 end
	local tc = eg:FilterSelect(tp,c7027.select,1,1,nil,tp):GetFirst()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c7027.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c7027.filter2,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.Equip(tp,g:GetFirst(),tc) then
		g:GetFirst():SetStatus(STATUS_UNION,true)
		
		--cannot special summon
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e1)
	end
end
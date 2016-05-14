--The Grand Jupiter
--Scripted by Eerie Code
function c16255173.initial_effect(c)
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c16255173.cost)
	e1:SetTarget(c16255173.tg)
	e1:SetOperation(c16255173.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c16255173.sptg)
	e2:SetOperation(c16255173.spop)
	c:RegisterEffect(e2)
end

function c16255173.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c16255173.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c16255173.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.Equip(tp,tc,c)==0 then return end
		local atk=tc:GetBaseAttack()
		if tc:IsFacedown() or atk<0 then atk=0 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c16255173.eqlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(16255173,RESET_EVENT+0x1fe0000,0,1)
end
function c16255173.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end

function c16255173.spfil(c,e,tp,eg)
	return eg:IsContains(c) and c:GetFlagEffect(16255173) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16255173.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local qg=e:GetHandler():GetEquipGroup()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c16255173.spfil(chkc,e,tp,qg) end
	if chk==0 then return qg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c16255173.spfil,tp,LOCATION_SZONE,0,1,nil,e,tp,qg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16255173.spfil,tp,LOCATION_SZONE,0,1,1,nil,e,tp,qg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c16255173.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

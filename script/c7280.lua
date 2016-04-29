--銀河眼の光波竜
--Galaxy-Eyes Cipher Dragon
--Scripted by Eerie Code
function c7280.initial_effect(c)
  --xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--Control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetDescription(aux.Stringid(7280,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c7280.cost)
	e1:SetTarget(c7280.target)
	e1:SetOperation(c7280.operation)
	c:RegisterEffect(e1)
end

function c7280.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7280.filter(c)
  return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c7280.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c7280.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7280.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c7280.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c7280.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c7280.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e4=Effect.CreateEffect(c)
		  e4:SetType(EFFECT_TYPE_SINGLE)
		  e4:SetCode(EFFECT_CHANGE_CODE)
		  e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		  e4:SetValue(7280)
		tc:RegisterEffect(e4)
	  if Duel.GetControl(tc,tp,PHASE_END,1) then
		local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		  tc:RegisterEffect(e1)
		  local e2=e1:Clone()
		  e2:SetCode(EFFECT_DISABLE_EFFECT)
		  tc:RegisterEffect(e2)
		  local e3=e2:Clone()
		  e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		  e3:SetValue(3000)
		  tc:RegisterEffect(e3)
	else
		tc:RegisterFlagEffect(7280,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	  if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			  Duel.Destroy(tc,REASON_EFFECT)
		  end
	end
  end
end
function c7280.nccon(e)
	return e:GetHandler():GetFlagEffect(7280)==0
end
function c7280.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
--Scripted by Eerie Code
--Number 45: Crumble Logos
function c7273.initial_effect(c)
  c:EnableReviveLimit()
  aux.AddXyzProcedure(c,nil,2,2,nil,nil,5)
  --Negate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7273,0))
  e1:SetCategory(CATEGORY_DISABLE)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1)
  e1:SetCost(c7273.cost)
  e1:SetTarget(c7273.tg)
  e1:SetOperation(c7273.op)
  c:RegisterEffect(e1)
end
c7273.xyz_number=45

function c7273.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
  c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7273.fil(c,rc)
  return aux.disfilter1(c) and not c:IsRelateToCard(rc)
end
function c7273.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
  if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc~=c and c7273.fil(chkc,c) end
  if chk==0 then return Duel.IsExistingTarget(c7273.fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c7273.fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,c)
end
function c7273.op(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
	c:CreateRelation(tc,RESET_EVENT+0x1fe0000)
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetCondition(c7273.discon)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetCondition(c7273.discon)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
	  e3:SetType(EFFECT_TYPE_FIELD)
	  e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	  e3:SetRange(LOCATION_MZONE)
	  e3:SetTargetRange(1,1)
	  e3:SetLabel(tc:GetCode())
	  e3:SetLabelObject(tc)
	  e3:SetCondition(c7273.accon)
	  e3:SetValue(c7273.aclimit)
		c:RegisterEffect(e3)
	end
end
function c7273.discon(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c7273.accon(e)
  local tc=e:GetLabelObject()
  return tc and tc:IsFaceup() and tc:IsRelateToCard(e:GetHandler())
end
function c7273.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and not re:GetHandler():IsImmuneToEffect(e)
end
--ダーク・レクイエム・エクシーズ・ドラゴン
--Dark Requiem Xyz Dragon
--Scripted by Eerie Code
function c7349.initial_effect(c)
  aux.AddXyzProcedure(c,nil,5,3)
  c:EnableReviveLimit()
  --
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7349,0))
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1)
  e1:SetCondition(c7349.con)
  e1:SetCost(c7349.cost)
  e1:SetTarget(c7349.atktg)
  e1:SetOperation(c7349.atkop)
  c:RegisterEffect(e1)
  --
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(7349,1))
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
  e2:SetCode(EVENT_CHAINING)
  e2:SetRange(LOCATION_MZONE)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e2:SetCondition(c7349.negcon)
  e2:SetCost(c7349.cost)
  e2:SetTarget(c7349.negtg)
  e2:SetOperation(c7349.negop)
  c:RegisterEffect(e2)
end

function c7349.con(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,16195942)
end
function c7349.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7349.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end
  if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
end
function c7349.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	local atk=tc:GetBaseAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	  local e2=Effect.CreateEffect(c)
	  e2:SetType(EFFECT_TYPE_SINGLE)
	  e2:SetCode(EFFECT_UPDATE_ATTACK)
	  e2:SetValue(atk)
	  e2:SetReset(RESET_EVENT+0x1fe0000)
	  c:RegisterEffect(e2)
	end
  end
end

function c7349.negcon(e,tp,eg,ep,ev,re,r,rp)
  return c7349.con(e,tp,eg,ep,ev,re,r,rp) and rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c7349.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c7349.negfil(c,e,tp)
  return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7349.negop(e,tp,eg,ep,ev,re,r,rp)
  	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c7349.negfil,tp,LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(7349,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then return end
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

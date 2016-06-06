--捕食植物フライ・へル
--Predator Plant Fly Hell
--Scripted by Eerie Code
function c7306.initial_effect(c)
  --
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7306,0))
  e1:SetCategory(CATEGORY_COUNTER)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1)
  e1:SetTarget(c7306.cttg)
  e1:SetOperation(c7306.ctop)
  c:RegisterEffect(e1)
  --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7306,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c7306.destg)
	e2:SetOperation(c7306.desop)
	c:RegisterEffect(e2)
end

function c7306.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x3b,1)
end
function c7306.ctop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
	tc:AddCounter(0x3b,1)
  end
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetTarget(c7306.lvtg)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,0)
end
function c7306.lvtg(e,c)
	return c:GetCounter(0x3b)>0 and c:IsLevelAbove(1)
end

function c7306.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsFaceup() and tc:IsLevelAbove(1) and tc:IsLevelBelow(e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c7306.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and tc:IsRelateToBattle() and Duel.Destroy(tc,REASON_EFFECT)>0 then
	  local lv=tc:GetOriginalLevel()
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
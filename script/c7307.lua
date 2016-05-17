--捕食植物モーレイ・ネペンテス
--Predator Plant Moray Nepenthes
--Scripted by Eerie Code
function c7307.initial_effect(c)
  --
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c7307.atkval)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7307,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c7307.eqcon)
	e2:SetTarget(c7307.eqtg)
	e2:SetOperation(c7307.eqop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7307,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c7307.rctg)
	e3:SetOperation(c7307.rcop)
	c:RegisterEffect(e3)
end

function c7307.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x3b)*200
end

function c7307.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	e:SetLabelObject(tc)
	return aux.bdogcon(e,tp,eg,ep,ev,re,r,rp)
end
function c7307.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c7307.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c7307.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c7307.eqlimit(e,c)
	return e:GetOwner()==c
end

function c7307.rcfil(c,eg)
  return eg and eg:IsContains(c) and c:IsDestructable()
end
function c7307.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local qg=e:GetHandler():GetEquipGroup()
  if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and qg and c7307.rcfil(chkc,qg) end
  if chk==0 then return Duel.IsExistingTarget(c7307.rcfil,tp,LOCATION_SZONE,0,1,nil,qg) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c7307.rcfil,tp,LOCATION_SZONE,0,1,1,nil,qg)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  local rc=g:GetFirst():GetBaseAttack()
  Duel.SetTargetPlayer(tp)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rc)
end
function c7307.rcop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
	local atk=tc:GetBaseAttack()
	Duel.Recover(tp,atk,REASON_EFFECT)
  end
end
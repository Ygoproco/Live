--Scripted by Eerie Code
--Performapal Radish Horse
function c71863024.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Reduce ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71863024,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c71863024.atktg1)
	e1:SetOperation(c71863024.atkop1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c71863024.spcon)	
	c:RegisterEffect(e2)
	--Modulate ATK
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(71863024,1))
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c71863024.atktg2)
	e3:SetOperation(c71863024.atkop2)
	c:RegisterEffect(e3)
end

function c71863024.atkfil1(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end
function c71863024.atkfil2(c)
	return c:IsFaceup() and c:IsAttackAbove(1) and c:IsSetCard(0x9f)
end
function c71863024.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c71863024.atkfil1,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingTarget(c71863024.atkfil2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c71863024.atkfil1,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,c71863024.atkfil2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c71863024.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local hc=g:GetFirst()
	if tc==hc then hc=g:GetNext() end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-hc:GetAttack())
		tc:RegisterEffect(e1)
	end
end

function c71863024.spfil(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsFaceup()
end
function c71863024.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c71863024.spfil,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end

function c71863024.atktg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c71863024.atkfil1,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingTarget(c71863024.atkfil1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c71863024.atkfil1,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,c71863024.atkfil1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c71863024.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local hc=g:GetFirst()
	if tc==hc then hc=g:GetNext() end
	local c=e:GetHandler()
	if c:IsFaceup() and hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=c:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-atk)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetValue(atk)
		hc:RegisterEffect(e2)
	end
end
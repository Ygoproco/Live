--ＥＭレ・ベルマン
--Performapal Le-Bellman
--Scripted by Eerie Code
function c6134.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6134,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c6134.lvtg1)
	e1:SetOperation(c6134.lvop1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6134,1))
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c6134.lvtg2)
	e2:SetOperation(c6134.lvop2)
	c:RegisterEffect(e2)
end

function c6134.lvfil1(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsLevelAbove(1)
end
function c6134.lvtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6134.lvfil1,tp,LOCATION_MZONE,0,1,nil) end
end
function c6134.lvop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c6134.lvfil1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

function c6134.lvfil2(c)
	return c:IsFaceup() and c:IsSetCard(0x9f) and c:IsLevelAbove(1)
end
function c6134.lvtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c6134.lvfil2(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c6134.lvfil2,tp,LOCATION_MZONE,0,1,c) and c:IsLevelAbove(2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c6134.lvfil2,tp,LOCATION_MZONE,0,1,1,c)
	local t={}
	local i=1
	local p=1
	local lv=math.min(5,c:GetLevel()-1)
	for i=1,lv do
		t[p]=i
		p=p+1
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c6134.lvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:GetLevel()>lv and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetValue(lv)
		tc:RegisterEffect(e2)
	end
end

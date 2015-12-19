--Scripted by Eerie Code, based on Ygohack137's script
--Holding Arms
function c43730887.initial_effect(c)
	--lock
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43730887,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c43730887.target)
	e1:SetOperation(c43730887.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(c43730887.incon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e6:SetTarget(c43730887.indtg)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e7)
end

function c43730887.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c43730887.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		tc:RegisterFlagEffect(43730887,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c43730887.incon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFirstCardTarget()~=nil
end
function c43730887.indtg(e,c)
	return e:GetHandler():IsHasCardTarget(c) and c:GetFlagEffect(43730887)~=0
end
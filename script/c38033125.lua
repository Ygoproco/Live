--ブラック·マジシャン·ガール
function c38033125.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c38033125.val)
	c:RegisterEffect(e1)
end
function c38033125.val(e,c)
	return Duel.GetMatchingGroupCount(c38033125.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*300
end
function c38033125.filter(c)
	local code=c:GetCode()
	return code==46986414 or code==30208479
end

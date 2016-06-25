--真紅眼の凶星竜－メテオ・ドラゴン
--Red-Eyes Meteor Dragon
--Scripted by Eerie Code
function c7328.initial_effect(c)
	aux.EnableDualAttribute(c)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(aux.IsDualState)
	e2:SetTarget(c7328.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
end

function c7328.indtg(e,c)
	return c:IsSetCard(0x3b) and c~=e:GetHandler()
end
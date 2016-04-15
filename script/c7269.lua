--Scripted by Eerie Code
--Hand-Holding Genie
function c7269.initial_effect(c)
	--untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c7269.atlimit)
	c:RegisterEffect(e1)
	--defup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c7269.atkval)
	c:RegisterEffect(e2)
end

function c7269.atlimit(e,c)
	return c~=e:GetHandler()
end

function c7269.atkval(e,c)
	local ndef=0
	local ng=Duel.GetMatchingGroup(Card.IsPosition,c:GetControler(),LOCATION_MZONE,0,c,POS_FACEUP_DEFENCE)
	local nbc=ng:GetFirst()
	while nbc do
		ndef=ndef+nbc:GetBaseDefence()
		nbc=ng:GetNext()
	end
	 return ndef
end
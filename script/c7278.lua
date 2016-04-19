--光波翼
--Cipher Wing
--Scripted by Eerie Code
function c7278.initial_effect(c)
  --Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7278,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c7278.spcon)
	c:RegisterEffect(e1)
	--Level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7278,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c7278.lvcost)
	e2:SetTarget(c7278.lvtg)
	e2:SetOperation(c7278.lvop)
	c:RegisterEffect(e2)
end

function c7278.spfil(c)
	return c:IsFaceup() and c:IsSetCard(0xe6)
end
function c7278.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c7278.spfil,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c7278.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c7278.filter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0xe6)
end
function c7278.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7278.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function c7278.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c7278.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(4)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
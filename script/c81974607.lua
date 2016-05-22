--光波翼
--Cipher Wing
--Scripted by Eerie Code
function c81974607.initial_effect(c)
  --Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81974607,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81974607.spcon)
	c:RegisterEffect(e1)
	--Level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81974607,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c81974607.lvcost)
	e2:SetTarget(c81974607.lvtg)
	e2:SetOperation(c81974607.lvop)
	c:RegisterEffect(e2)
end

function c81974607.spfil(c)
	return c:IsFaceup() and c:IsSetCard(0xe5)
end
function c81974607.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81974607.spfil,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c81974607.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c81974607.filter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0xe5)
end
function c81974607.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81974607.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function c81974607.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81974607.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(4)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

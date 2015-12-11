--Scripted by Eerie Code
--D/D/D Cruel Dragon King Beowulf
function c8463720.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c8463720.mfilter1,c8463720.mfilter2,true)
	c:EnableReviveLimit()
	--Pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf))
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8463720,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c8463720.con)
	e2:SetTarget(c8463720.tg)
	e2:SetOperation(c8463720.op)
	c:RegisterEffect(e2)
end

function c8463720.mfilter1(c)
	return c:IsSetCard(0x10af)
end
function c8463720.mfilter2(c)
	return c:IsSetCard(0xaf)
end

function c8463720.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c8463720.fil(c)
	return c:GetSequence()<5 and c:IsDestructable()
end
function c8463720.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8463720.fil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c8463720.fil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c8463720.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c8463720.fil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
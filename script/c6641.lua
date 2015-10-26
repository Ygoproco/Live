--Scripted by Eerie Code
--D/D/D Cruel Dragon King Beowulf
function c6641.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c6641.mfilter1,c6641.mfilter2,true)
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
	e2:SetDescription(aux.Stringid(6641,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c6641.con)
	e2:SetTarget(c6641.tg)
	e2:SetOperation(c6641.op)
	c:RegisterEffect(e2)
end

function c6641.mfilter1(c)
	return c:IsSetCard(0x10af)
end
function c6641.mfilter2(c)
	return c:IsSetCard(0xaf)
end

function c6641.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c6641.fil(c)
	return c:GetSequence()<5 and c:IsDestructable()
end
function c6641.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6641.fil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c6641.fil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c6641.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c6641.fil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
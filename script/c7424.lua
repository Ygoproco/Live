--魔界台本「オープニング・セレモニー」
--Abyss Script - Opening Ceremony
--Scripted by Eerie Code
function c7424.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7424,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,7424)
	e1:SetTarget(c7424.rctg)
	e1:SetOperation(c7424.rcop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7424,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,7424+1)
	e2:SetCondition(c7424.drcon)
	e2:SetTarget(c7424.drtg)
	e2:SetOperation(c7424.drop)
	c:RegisterEffect(e2)
end

function c7424.rcfil(c)
	return c:IsFaceup() and (c:IsSetCard(0x10ed) or c:IsSetCard(0x120e))
end
function c7424.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7424.rcfil,tp,LOCATION_MZONE,0,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c7424.rcfil,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c7424.rcop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c7424.rcfil,tp,LOCATION_MZONE,0,nil)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,ct*500,REASON_EFFECT)
end

function c7424.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and Duel.IsExistingMatchingCard(c7424.rcfil,tp,LOCATION_EXTRA,0,1,nil)
end
function c7424.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		return h<5 and Duel.IsPlayerCanDraw(tp,5-h)
	end
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5-h)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5-h)
end
function c7424.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local h=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if h>=5 then return end
	Duel.Draw(p,5-h,REASON_EFFECT)
end
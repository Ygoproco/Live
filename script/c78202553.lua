--Subterror Behemoth Stalagmo
--Scripted by Eerie Code
function c78202553.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78202553,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FLIP)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,78202553)
	e1:SetTarget(c78202553.drtg)
	e1:SetOperation(c78202553.drop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78202553,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c78202553.sptg)
	e2:SetOperation(c78202553.spop)
	c:RegisterEffect(e2)
	--turn set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78202553,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c78202553.postg)
	e3:SetOperation(c78202553.posop)
	c:RegisterEffect(e3)
end

function c78202553.drcfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xed) and c:IsDiscardable()
end
function c78202553.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78202553.drcfil,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c78202553.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.DiscardHand(tp,c78202553.drcfil,1,1,REASON_EFFECT+REASON_DISCARD,nil)>0 then
		Duel.BreakEffect()
		Duel.Draw(p,d,REASON_EFFECT)
	end
end

function c78202553.spfil1(c,tp)
	return c:IsFacedown() and c:IsPreviousPosition(POS_FACEUP) and c:IsControler(tp)
end
function c78202553.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local pos=0
	if POS_FACEUP_DEFENSE then
		pos=POS_FACEUP_DEFENSE
	else pos=POS_FACEUP_DEFENCE end
	if chk==0 then return eg and eg:IsExists(c78202553.spfil1,1,nil,tp) and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,pos) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c78202553.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local pos=0
	if POS_FACEUP_DEFENSE then pos=POS_FACEUP_DEFENSE else pos=POS_FACEUP_DEFENCE end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,pos)
	end
end

function c78202553.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(78202553)==0 end
	c:RegisterFlagEffect(78202553,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c78202553.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENCE)
	end
end

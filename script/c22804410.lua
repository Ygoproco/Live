--ディープアイズ・ホワイト・ドラゴン
--Deep-Eyes White Dragon
--Scripted by Eerie Code
function c22804410.initial_effect(c)
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22804410.spcon)
	e1:SetTarget(c22804410.sptg)
	e1:SetOperation(c22804410.spop)
	c:RegisterEffect(e1)
	--Change ATK
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c22804410.atktg)
	e2:SetOperation(c22804410.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroyed
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c22804410.descon)
	e4:SetTarget(c22804410.destg)
	e4:SetOperation(c22804410.desop)
	c:RegisterEffect(e4)
end

function c22804410.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0xdd) and c:GetPreviousControler()==tp and c:GetReasonPlayer()~=tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c22804410.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22804410.cfilter,1,nil,tp)
end
function c22804410.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local mg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_DRAGON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,mg:GetClassCount(Card.GetCode)*600)
end
function c22804410.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local mc=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_DRAGON):GetClassCount(Card.GetCode)
		Duel.Damage(1-tp,600*mc,REASON_EFFECT)
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
			Duel.SendtoGrave(c,REASON_RULE)
		end
	end
end

function c22804410.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsRace(RACE_DRAGON) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_DRAGON) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsRace,tp,LOCATION_GRAVE,0,1,1,nil,RACE_DRAGON)
end
function c22804410.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end

function c22804410.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetReason(),0x41)==0x41
end
function c22804410.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return mc:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,mc,mc:GetCount(),0,0)
end
function c22804410.desop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if mg:GetCount()>0 then
		Duel.Destroy(mg,REASON_EFFECT)
	end
end

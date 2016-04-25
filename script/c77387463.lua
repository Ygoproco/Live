--方界帝ヴァルカン・ドラグニー
--Vulcan Dragni, the Cubic Emperor
--Scripted by Eerie Code
function c77387463.initial_effect(c)
  c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c77387463.spcon)
	e2:SetOperation(c77387463.spop)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c77387463.damcon)
	e3:SetTarget(c77387463.damtg)
	e3:SetOperation(c77387463.damop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c77387463.sptg2)
	e4:SetOperation(c77387463.spop2)
	c:RegisterEffect(e4)
end

function c77387463.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe3) and c:IsAbleToGraveAsCost()
end
function c77387463.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c77387463.filter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c77387463.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c77387463.filter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1600)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end

function c77387463.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c77387463.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c77387463.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c77387463.spfil(c,e,tp)
  return c:IsCode(15610297) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77387463.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77387463.spfil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(c77387463.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():IsAbleToGrave() end
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	if lc>3 then lc=3 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then lc=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77387463.spfil,tp,LOCATION_GRAVE,0,1,lc,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c77387463.thfil(c)
	return c:IsCode(3775068) and c:IsAbleToHand()
end
function c77387463.spop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
  if not c:IsRelateToEffect(e) or Duel.SendtoGrave(c,REASON_EFFECT)==0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) and tg:GetCount()>1 then
			local tc=tg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	if Duel.IsExistingMatchingCard(c77387463.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(77387463,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c77387463.thfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--Scripted by Eerie Code
--Acrobat Magician
function c7109.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Special Summon (P.Zone)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7109,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,7109)
	e1:SetCondition(c7109.spcon1)
	e1:SetTarget(c7109.sptg)
	e1:SetOperation(c7109.spop1)
	c:RegisterEffect(e1)
	--Special Summon (hand)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7109,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c7109.spcon2)
	e2:SetTarget(c7109.sptg)
	e2:SetOperation(c7109.spop1)
	c:RegisterEffect(e2)
	--Place
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(7109,1))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BATTLE_DESTROYED)
	e7:SetTarget(c7109.pentg)
	e7:SetOperation(c7109.penop)
	c:RegisterEffect(e7)
end

function c7109.spcfil1(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function c7109.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7109.spcfil1,1,nil,tp)
end
function c7109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c7109.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c7109.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function c7109.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c7109.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
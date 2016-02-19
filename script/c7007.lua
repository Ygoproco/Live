--Scripted by Eerie Code
--Performapal Seesawhopper
function c7007.initial_effect(c)
  --Indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c7007.valcon)
	c:RegisterEffect(e1)
  --Recover
  local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7007,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c7007.thcon)
	e2:SetTarget(c7007.thtg)
	e2:SetOperation(c7007.thop)
	c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7007,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,7007)
	e3:SetTarget(c7007.sptg)
	e3:SetOperation(c7007.spop)
	c:RegisterEffect(e3)
end

function c7007.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 and bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end

function c7007.thcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()~=tp
end
function c7007.thfil(c)
  return c:IsSetCard(0x9f) and c:IsLevelBelow(3) and c:IsAbleToHand()
end
function c7007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7007.thfil(chkc) end
  if chk==0 then return e:GetHandler():IsAbleToGrave() and Duel.IsExistingTarget(c7007.thfil,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c7007.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c7007.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end

function c7007.spcfil(c)
	return c:IsSetCard(0x9f) and c:IsPreviousLocation(LOCATION_HAND)
end
function c7007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c7007.spcfil,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c7007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
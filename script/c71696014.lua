--Scripted by Eerie Code
--Magician's Robe
function c71696014.initial_effect(c)
  --Special Summon (DM)
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(71696014,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,71696014)
  e1:SetCondition(c71696014.spcon)
  e1:SetCost(c71696014.spcost)
  e1:SetTarget(c71696014.sptg)
  e1:SetOperation(c71696014.spop)
  c:RegisterEffect(e1)
  --Special Summon (Self)
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71696014,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,71696014+1)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c71696014.spscon)
	e3:SetTarget(c71696014.spstg)
	e3:SetOperation(c71696014.spsop)
	c:RegisterEffect(e3)
end

function c71696014.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()~=tp
end
function c71696014.cfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c71696014.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c71696014.cfilter,tp,LOCATION_HAND,0,1,nil) end
  Duel.DiscardHand(tp,c71696014.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c71696014.spfil(c,e,tp)
  return c:IsCode(46986414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71696014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c71696014.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c71696014.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
  local g=Duel.SelectMatchingCard(tp,c71696014.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end

function c71696014.spscon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(1)>0
end
function c71696014.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71696014.spsop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
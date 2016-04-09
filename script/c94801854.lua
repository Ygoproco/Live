--Scripted by Eerie Code
--Shiranui Sage
function c94801854.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(94801854,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,94801854)
  e1:SetCost(c94801854.spcost1)
  e1:SetTarget(c94801854.sptg1)
  e1:SetOperation(c94801854.spop1)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(94801854,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_REMOVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e2:SetCountLimit(1,94801854+1)
  e2:SetTarget(c94801854.sptg2)
  e2:SetOperation(c94801854.spop2)
  c:RegisterEffect(e2)
end

function c94801854.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_ZOMBIE) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_ZOMBIE)
	Duel.Release(g,REASON_COST)
end
function c94801854.spfil1(c,e,tp)
  return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_TUNER) and c:GetDefence()==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c94801854.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c94801854.spfil1,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c94801854.spop1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c94801854.spfil1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end

function c94801854.spfil2(c,e,tp)
  return c:IsSetCard(0xd9) and not c:IsCode(94801854) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c94801854.spex(c)
  return c:IsFaceup() and c:IsCode(40005099)
end
function c94801854.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c94801854.spfil2(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c94801854.spfil2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
  local mt=1
  if Duel.IsExistingMatchingCard(c94801854.spex,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then mt=2 end
  local ft=math.min(mt,Duel.GetLocationCount(tp,LOCATION_MZONE))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c94801854.spfil2,tp,LOCATION_REMOVED,0,1,ft,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c94801854.spop2(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=tg:GetCount() then
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
  end
end

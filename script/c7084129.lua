--Scripted by Eerie Code
--Magician's Rod
function c7084129.initial_effect(c)
  --Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7084129,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,7084129)
  e1:SetTarget(c7084129.thtg)
  e1:SetOperation(c7084129.thop)
  c:RegisterEffect(e1)
  --Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7084129,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,7084129+1)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c7084129.svcon)
	e3:SetCost(c7084129.svcost)
	e3:SetTarget(c7084129.svtg)
	e3:SetOperation(c7084129.svop)
	c:RegisterEffect(e3)
end

function c7084129.thfil(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c.dark_magician_list and c:IsAbleToHand()
end
function c7084129.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c7084129.thfil,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c7084129.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c7084129.thfil,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
  end
end

function c7084129.svcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(1)>0
end
function c7084129.costfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c7084129.svcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c7084129.costfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c7084129.costfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c7084129.svtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c7084129.svop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
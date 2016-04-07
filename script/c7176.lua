--Scripted by Eerie Code
--Tramid Pulse
function c7176.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7176,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c7176.tg1)
  e1:SetOperation(c7176.op)
  c:RegisterEffect(e1)
  --Effect
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCost(c7176.cost)
  e2:SetTarget(c7176.tg2)
  e2:SetOperation(c7176.op)
  c:RegisterEffect(e2)
end

function c7176.cfilter(c)
  return ((c:IsRace(RACE_ROCK) and c:IsType(TYPE_MONSTER)) or c:IsType(TYPE_FIELD)) and c:IsAbleToRemoveAsCost()
end
function c7176.fil1(c)
  return c:IsFaceup() and c:IsDestructable()
end
function c7176.fil2(c,e,tp)
  return c:IsRace(RACE_ROCK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
-- What if this card can only Special Summon, and the summonable monster must be used as the cost?
function c7176.fil2bis(c,e,tp)
  return c7176.fil2(c,e,tp) and Duel.IsExistingMatchingCard(c7176.cfilter,tp,LOCATION_GRAVE,0,2,c)
end
function c7176.fil3(c)
  return c:IsType(TYPE_FIELD) and c:IsAbleToDeck()
end
function c7176.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local sel=e:GetLabel()
  if chkc then return (sel==1 and chkc:IsLocation(LOCATION_ONFIELD) and chkc~=e:GetHandler() and c7176.fil1(chkc)) or 
	(sel==2 and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7176.fil2(chkc,e,tp)) or
	(sel==3 and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7176.fil3(chkc)) end
  if chk==0 then return true end
  local cp=Duel.IsExistingMatchingCard(c7176.cfilter,tp,LOCATION_GRAVE,0,2,nil)
  local b1=Duel.IsExistingTarget(c7176.fil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
  local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c7176.fil2bis,tp,LOCATION_GRAVE,0,1,nil,e,tp)
  local b3=Duel.IsExistingTarget(c7176.fil3,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
  if cp and (b1 or b2 or b3) and Duel.SelectYesNo(tp,94) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c7176.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local ops={}
		local opval={}
		local off=1
		if b1 then
			ops[off]=aux.Stringid(7176,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(7176,2)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(7176,3)
			opval[off-1]=3
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		e:SetLabel(sel)
		if sel==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectTarget(tp,c7176.fil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
			e:SetCategory(CATEGORY_DESTROY)
		elseif sel==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectTarget(tp,c7176.fil2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectTarget(tp,c7176.fil3,tp,LOCATION_GRAVE,0,1,3,nil)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
			e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		end
		e:GetHandler():RegisterFlagEffect(7176,RESET_PHASE+PHASE_END,0,1)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
	  e:SetCategory(0)
	  e:SetProperty(0)
  end
end
function c7176.op(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:GetFlagEffect(7176)==0 or not c:IsRelateToEffect(e) then return end
  local sel=e:GetLabel()
  if sel==1 then --Destruction
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	  Duel.Destroy(tc,REASON_EFFECT)
	end
  elseif sel==2 then
	local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		end
	else
	  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	  if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
  end
end

function c7176.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c7176.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c7176.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c7176.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local sel=e:GetLabel()
  if chkc then return (sel==1 and chkc:IsLocation(LOCATION_ONFIELD) and chkc~=e:GetHandler() and c7176.fil1(chkc)) or 
	(sel==2 and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7176.fil2(chkc,e,tp)) or
	(sel==3 and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7176.fil3(chkc)) end
  local b1=Duel.IsExistingTarget(c7176.fil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
  local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c7176.fil2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
  local b3=Duel.IsExistingTarget(c7176.fil3,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
  if chk==0 then return e:GetHandler():GetFlagEffect(7176)==0 and (b1 or b2 or b3) end
  local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(7176,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(7176,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(7176,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c7176.fil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		e:SetCategory(CATEGORY_DESTROY)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c7176.fil2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c7176.fil3,tp,LOCATION_GRAVE,0,1,3,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	end
	e:GetHandler():RegisterFlagEffect(7176,RESET_PHASE+PHASE_END,0,1)
end

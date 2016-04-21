--Verserion the Electromagna Warrior
function c7014.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c7014.spcon)
	e1:SetOperation(c7014.spop)
	c:RegisterEffect(e1)	
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c7014.splimit)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7014,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c7014.descost)
	e3:SetTarget(c7014.destg)
	e3:SetOperation(c7014.desop)
	c:RegisterEffect(e3)	
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7014,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c7014.summtg)
	e3:SetOperation(c7014.summop)
	c:RegisterEffect(e3)
end
function c7014.spfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c7014.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-2 then return false end
	local g1=Duel.GetMatchingGroup(c7014.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,7011)
	local g2=Duel.GetMatchingGroup(c7014.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,7012)
	local g3=Duel.GetMatchingGroup(c7014.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,7013)
	if g1:GetCount()==0 or g2:GetCount()==0 or g3:GetCount()==0 then return false end
	if ft>0 then return true end
	local f1=g1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>0 and 1 or 0
	local f2=g2:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>0 and 1 or 0
	local f3=g3:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>0 and 1 or 0
	if ft==-2 then return f1+f2+f3==3
	elseif ft==-1 then return f1+f2+f3>=2
	else return f1+f2+f3>=1 end
end
function c7014.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c7014.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,7011)
	local g2=Duel.GetMatchingGroup(c7014.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,7012)
	local g3=Duel.GetMatchingGroup(c7014.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,7013)
	g1:Merge(g2)
	g1:Merge(g3)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if ft<=0 then
			tc=g1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
		else
			tc=g1:Select(tp,1,1,nil):GetFirst()
		end
		g:AddCard(tc)
		g1:Remove(Card.IsCode,nil,tc:GetCode())
		ft=ft+1
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c7014.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_HAND)
end

function c7014.desfilter(c)
	return c:GetLevel()<=4 and c:IsSetCard(0x2066) and c:IsAbleToRemoveAsCost()
end
function c7014.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7014.desfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local c = Duel.SelectMatchingCard(tp,c7014.desfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c7014.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c7014.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c7014.summfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7014.summtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) 
		and (c7014.summfilter(chkc,7011,e,tp) or c7014.summfilter(chkc,7012,e,tp) or c7014.summfilter(chkc,7013,e,tp)) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingTarget(c7014.summfilter,tp,LOCATION_REMOVED,0,1,nil,7011,e,tp)
		and Duel.IsExistingTarget(c7014.summfilter,tp,LOCATION_REMOVED,0,1,nil,7012,e,tp)
		and Duel.IsExistingTarget(c7014.summfilter,tp,LOCATION_REMOVED,0,1,nil,7013,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c7014.summfilter,tp,LOCATION_REMOVED,0,1,1,nil,7011,e,tp)
	local g2=Duel.SelectTarget(tp,c7014.summfilter,tp,LOCATION_REMOVED,0,1,1,nil,7012,e,tp)
	local g3=Duel.SelectTarget(tp,c7014.summfilter,tp,LOCATION_REMOVED,0,1,1,nil,7013,e,tp)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,g1:GetCount(),0,0)
end
function c7014.summop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
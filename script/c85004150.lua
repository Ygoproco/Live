--Digital Bug Rhinocebus
function c85004150.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c85004150.xyzcon)
	e1:SetOperation(c85004150.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85004150,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c85004150.descost)
	e3:SetTarget(c85004150.destg)
	e3:SetOperation(c85004150.desop)
	c:RegisterEffect(e3)
end
c85004150.xyz_count=2
function c85004150.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (c:GetRank()==5 or c:GetRank()==6) and c:IsRace(RACE_INSECT) and c:IsCanBeXyzMaterial(xyzc)
		and c:CheckRemoveOverlayCard(tp,2,REASON_COST)
end
function c85004150.ovfilter2(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==7 and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeXyzMaterial(xyzc)
end
function c85004150.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if 2<=ct then return false end
	if ct<1 and not og and Duel.IsExistingMatchingCard(c85004150.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp,c) then
		return true
	end
	return Duel.CheckXyzMaterial(c,c85004150.ovfilter2,7,2,5,og)
end
function c85004150.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct=-ft
		local b1=Duel.CheckXyzMaterial(c,c85004150.ovfilter2,7,2,5,og)
		local b2=ct<1 and Duel.IsExistingMatchingCard(c85004150.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
		if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(85004150,0))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=Duel.SelectMatchingCard(tp,c85004150.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
			mg:GetFirst():RemoveOverlayCard(tp,2,2,REASON_COST)
			local mg2=mg:GetFirst():GetOverlayGroup()
			if mg2:GetCount()~=0 then
				Duel.Overlay(c,mg2)
			end
			c:SetMaterial(mg)
			Duel.Overlay(c,mg)
		else
			local mg=Duel.SelectXyzMaterial(tp,c,c85004150.ovfilter2,7,2,5)
			c:SetMaterial(mg)
			Duel.Overlay(c,mg)
		end
	end
end
function c85004150.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c85004150.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c85004150.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85004150.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c85004150.desfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetDefence)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c85004150.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c85004150.desfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetDefence)
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
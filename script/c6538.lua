--Scripted by Eerie Code
--Super Quantum Mecha Ship Magnacarrier
function c6538.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Xyz Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6538,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c6538.xyzcost)
	e2:SetTarget(c6538.xyztg)
	e2:SetOperation(c6538.xyzop)
	c:RegisterEffect(e2)
	--Summon Magnas
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6538,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c6538.spcost)
	e3:SetTarget(c6538.sptg)
	e3:SetOperation(c6538.spop)
	c:RegisterEffect(e3)
end

function c6538.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c6538.xyzfil1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x10dd) and Duel.IsExistingMatchingCard(c6538.xyzfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetAttribute())
end
function c6538.xyzfil2(c,e,tp,mc,att)
	return c:IsSetCard(0x20dd) and c:IsAttribute(att) and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c6538.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c6538.xyzfil1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=-1 and Duel.IsExistingTarget(c6538.xyzfil1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c6538.xyzfil1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c6538.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6538.xyzfil2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetAttribute())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function c6538.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c6538.spfil1(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x20dd) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and Duel.IsExistingMatchingCard(c6538.spfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c))
end
function c6538.spfil2(c,e,tp,mg)
	local b=true
	local mc=mg:GetFirst()
	while mc do
		if not mc:IsCanBeXyzMaterial(c) then b=false end
		mc=mg:GetNext()
	end
	return c:IsCode(6537) and b and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6538.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and c6538.spfil1(chkc,e,tp) end
	if chk==0 then 
		local mgc=Duel.GetMatchingGroupCount(c6538.spfil1,tp,LOCATION_MZONE,0,nil,e,tp)
		local dg=Duel.GetMatchingGroup(c6538.spfil1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e,tp)
		local ft=0
		if mgc>0 then ft=-1 end
		--Debug.Message("Location count: "..Duel.GetLocationCount(tp,LOCATION_MZONE).." to "..ft)
		--Debug.Message("Class count: "..dg:GetClassCount(Card.GetCode))
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>ft and dg:GetClassCount(Card.GetCode)>=3
	end
	local mg=Duel.GetMatchingGroup(c6538.spfil1,tp,LOCATION_MZONE,0,nil,e,tp)
	local g=Duel.GetMatchingGroup(c6538.spfil1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e,tp)
	local g1
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and mg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g1=mg:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g3=g:Select(tp,1,1,nil)
	g1:Merge(g3)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c6538.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=3 then return end
	local mgc=g:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetCount()
	local lc=0
	if mgc>0 then lc=-1 end
	if ft<lc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c6538.spfil2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g)
	local sc=sg:GetFirst()
	local mg=Group.CreateGroup()
	if sc then
		local mc=g:GetFirst()
		while mc do
			local mg2=mc:GetOverlayGroup()
			if mg2:GetCount()~=0 then
				Duel.Overlay(sc,mg2)
			end
			Group.AddCard(mg,mc)
			mc=g:GetNext()
		end
		sc:SetMaterial(mg)
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
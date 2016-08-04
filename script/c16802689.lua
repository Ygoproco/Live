--Cardian - Kiri ni Houou
--Scripted by Eerie Code
function c16802689.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c16802689.spcon)
	e1:SetOperation(c16802689.spop)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetTarget(c16802689.drtg)
	e2:SetOperation(c16802689.drop)
	c:RegisterEffect(e2)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetCountLimit(1)
	e6:SetCondition(c16802689.ctcon)
	e6:SetTarget(c16802689.drtg)
	e6:SetOperation(c16802689.ctop)
	c:RegisterEffect(e6)
end

function c16802689.spfil(c)
	return c:IsSetCard(0xe6) and c:GetLevel()==12 and not c:IsCode(16802689)
end
function c16802689.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(c:GetControler(),c16802689.spfil,1,nil)
end
function c16802689.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c16802689.spfil,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c16802689.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16802689.drfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe6)
end
function c16802689.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.Draw(tp,1,REASON_EFFECT)
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if c16802689.drfil(tc) then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(16802689,0)) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end

function c16802689.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c16802689.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
--Cardian - Matsu ni Tsuru
--Scripted by Eerie Code
function c16024176.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c16024176.spcon)
	e1:SetOperation(c16024176.spop)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetTarget(c16024176.drtg)
	e2:SetOperation(c16024176.drop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c16024176.damcon)
	e3:SetTarget(c16024176.drtg)
	e3:SetOperation(c16024176.damop)
	c:RegisterEffect(e3)
end

function c16024176.spfil(c)
	return c:IsSetCard(0xe6) and c:GetLevel()==1 and not c:IsCode(16024176)
end
function c16024176.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(c:GetControler(),c16024176.spfil,1,nil)
end
function c16024176.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c16024176.spfil,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c16024176.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16024176.drfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe6)
end
function c16024176.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.Draw(tp,1,REASON_EFFECT)
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if c16024176.drfil(tc) then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(16024176,0)) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end

function c16024176.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c16024176.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
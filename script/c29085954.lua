--Ｎｏ．７８ ナンバーズ・アーカイブ
--Number 78: Number Archive
--Scripted by Eerie Code
function c29085954.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--Number Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c29085954.cost)
	e1:SetTarget(c29085954.tg)
	e1:SetOperation(c29085954.op)
	c:RegisterEffect(e1)
end
c29085954.xyz_number=78

function c29085954.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29085954.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_EXTRA,0,1,nil) end
end
function c29085954.fil(c,e,tp,mc)
	return c:IsSetCard(0x48) and c.xyz_number and c.xyz_number>=1 and c.xyz_number<=99 and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c29085954.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_FACEDOWN)
	local tg=mg:Select(1-tp,1,1,nil)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if c29085954.fil(tc,e,tp,c) then
			local og=c:GetOverlayGroup()
			local fid=c:GetFieldID()
			if og:GetCount()~=0 then Duel.Overlay(tc,og) end
			tc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(tc,Group.FromCards(c))
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(29085954,RESET_EVENT+0x1fe0000,0,1,fid)
			Duel.SpecialSummonComplete()
			tc:CompleteProcedure()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetCondition(c29085954.rmcon)
			e1:SetOperation(c29085954.rmop)
			Duel.RegisterEffect(e1,tp)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c29085954.rmcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffectLabel(29085954)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c29085954.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end

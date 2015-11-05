--Scripted by Eerie Code
--Painful Escape
function c6780.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c6780.cost)
	e1:SetTarget(c6780.tg)
	e1:SetOperation(c6780.op)
	c:RegisterEffect(e1)
end

function c6780.fil1(c,tp)
	return c:IsLevelAbove(0) and Duel.IsExistingMatchingCard(c6780.fil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c,c:GetOriginalRace(),c:GetOriginalAttribute(),c:GetOriginalLevel(),c:GetOriginalCode())
end
function c6780.fil2(c,rc,att,lv,cd)
	return c:GetOriginalRace()==rc and c:GetOriginalAttribute()==att and c:GetOriginalLevel()==lv and c:GetOriginalCode()~=cd and c:IsAbleToHand()
end
function c6780.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c6780.fil1,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c6780.fil1,1,1,nil,tp)
	e:SetLabelObject(sg:GetFirst())
	Duel.Release(sg,REASON_COST)
end
function c6780.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c6780.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc then return end
	local g=Duel.SelectMatchingCard(tp,c6780.fil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,tc,tc:GetOriginalRace(),tc:GetOriginalAttribute(),tc:GetOriginalLevel(),tc:GetOriginalCode())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--プレゼントカード
--Present Card
--Scripted by Eerie Code
function c56119752.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,56119752)
	e1:SetTarget(c56119752.target)
	e1:SetOperation(c56119752.operation)
	c:RegisterEffect(e1)
end
function c56119752.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,5)
end
function c56119752.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT) end
	Duel.BreakEffect()
	Duel.Draw(1-tp,5,REASON_EFFECT)
end
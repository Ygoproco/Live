--Ｎｏ．５１ 怪腕のフィニッシュ・ホールド
--Number 51: Finish Hold the Amazing
--Scripted by Eerie Code
function c7274.initial_effect(c)
	c:EnableCounterPermit(0x34)
	c:SetCounterLimit(0x34,3)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,3)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c7274.ctcost)
	e2:SetOperation(c7274.ctop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c7274.con)
	e3:SetTarget(c7274.tg)
	e3:SetOperation(c7274.op)
	c:RegisterEffect(e3)
end
c7274.xyz_number=51

function c7274.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7274.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		c:AddCounter(0x34+COUNTER_NEED_ENABLE,1)
	end
end

function c7274.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0 and e:GetHandler():GetCounter(0x34)==3
end
function c7274.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return dc:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dc,dc:GetCount(),0,0)
end
function c7274.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsFaceup() or c:GetCounter(0x34)~=3 then return end
	local dc=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	if dc:GetCount()>0 then Duel.Destroy(dc,REASON_EFFECT) end
end
	
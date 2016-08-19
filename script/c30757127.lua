--Ｄ－ＨＥＲＯ デッドリーガイ
--Destiny HERO - Deadlyguy
--Scripted by Eerie Code
function c30757127.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c30757127.mfilter1,c30757127.mfilter2,true)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30757127,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,30757127)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c30757127.cost)
	e1:SetTarget(c30757127.tg)
	e1:SetOperation(c30757127.op)
	c:RegisterEffect(e1)
end

function c30757127.mfilter1(c)
	return c:IsSetCard(0xc008)
end
function c30757127.mfilter2(c)
	return c:IsType(TYPE_EFFECT) and c:IsAttribute(ATTRIBUTE_DARK)
end

function c30757127.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c30757127.cfil(c)
	return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c30757127.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30757127.cfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c30757127.fil(c)
	return c:IsFaceup() and c:IsSetCard(0xc008)
end
function c30757127.afil(c)
	return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER)
end
function c30757127.op(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetMatchingGroup(c30757127.fil,tp,LOCATION_MZONE,0,nil)
	--if ag:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c30757127.cfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local cnt=Duel.GetMatchingGroupCount(c30757127.afil,tp,LOCATION_GRAVE,0,nil)
		local tc=ag:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(cnt*200)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=ag:GetNext()
		end
	end
end

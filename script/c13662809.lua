--魔界台本「魔王の降臨」
--Abyss Script - Rise of the Dark Ruler
--Scripted by Eerie Code
function c13662809.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c13662809.target)
	e1:SetOperation(c13662809.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13662809,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c13662809.thcon)
	e2:SetTarget(c13662809.thtg)
	e2:SetOperation(c13662809.thop)
	c:RegisterEffect(e2)
end

function c13662809.aafil(c)
	return c:IsSetCard(0x10ec)
end
function c13662809.asfil(c)
	return c:IsSetCard(0x20ec)
end

function c13662809.cfil(c)
	return c:IsFaceup() and c13662809.aafil(c) and c:IsPosition(POS_ATTACK)
end
function c13662809.fil(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c13662809.limfil(c)
	return c:IsFaceup() and c13662809.aafil(c) and c:IsLevelAbove(7)
end
function c13662809.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c13662809.cfil,tp,LOCATION_MZONE,0,nil)
	local mc=mg:GetClassCount(Card.GetCode)
	if chkc then return chkc:IsOnField() and c13662809.fil(chkc) and chkc~=c end
	if chk==0 then return mc>0 and Duel.IsExistingTarget(c13662809.fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c13662809.fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,mc,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if Duel.IsExistingMatchingCard(c13662809.limfil,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetChainLimit(c13662809.chlimit)
	end
end
function c13662809.chlimit(e,ep,tp)
	return tp==ep
end
function c13662809.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function c13662809.thcfil(c)
	return c:IsFaceup() and c13662809.aafil(c)
end
function c13662809.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and Duel.IsExistingMatchingCard(c13662809.thcfil,tp,LOCATION_EXTRA,0,1,nil)
end
function c13662809.thfil(c)
	return (c13662809.aafil(c) or (c13662809.asfil(c) and c:IsType(TYPE_SPELL))) and c:IsAbleToHand()
end
function c13662809.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c13662809.thfil,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c13662809.thop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c13662809.thfil,tp,LOCATION_DECK,0,nil)
	if mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=mg:Select(tp,1,1,nil)
	mg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13662809,0)) then
		local g2=mg:Select(tp,1,1,nil)
		g1:Merge(g2)
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end

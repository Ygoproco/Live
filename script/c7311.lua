--光波鏡騎士
--Cipher Mirror Knight
--Scripted by Eerie Code
function c7311.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7311,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCost(c7311.spcost)
	e1:SetTarget(c7311.sptg)
	e1:SetOperation(c7311.spop)
	c:RegisterEffect(e1)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c7311.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7311,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,7311)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c7311.thcon)
	e4:SetTarget(c7311.thtg)
	e4:SetOperation(c7311.thop)
	c:RegisterEffect(e4)
end

function c7311.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c7311.spfil(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and c:GetPreviousControler()==tp
		and c:IsSetCard(0xe5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7311.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=eg:Filter(c7311.spfil,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		return g:GetCount()~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetLabelObject(),1,0,0)
end
function c7311.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or not tc:IsLocation(LOCATION_GRAVE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c7311.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(7311,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c7311.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(7311)>0
end
function c7311.thfilter(c)
	return c:IsSetCard(0xe5) and c:IsAbleToHand()
end
function c7311.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7311.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c7311.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7311.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--魔界劇団－ビッグ・スター
--Abyss Actor - Superstar
--Scripted by Eerie Code
function c7418.initial_effect(c)
	--
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7418,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c7418.thcost)
	e1:SetTarget(c7418.thtg)
	e1:SetOperation(c7418.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c7418.sumsuc)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7418,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c7418.settg)
	e4:SetOperation(c7418.setop)
	c:RegisterEffect(e4)
end

function c7418.thcfil(c)
	return c:IsSetCard(0x10ed) or c:IsSetCard(0x120e)
end
function c7418.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c7418.thcfil,1,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c7418.thcfil,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c7418.thfil(c)
	return c:IsType(TYPE_SPELL) and (c:IsSetCard(0x20ed) or c:IsSetCard(0x220e)) and c:IsAbleToHand()
end
function c7418.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7418.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7418.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c7418.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c7418.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

function c7418.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c7418.chainlim)
end
function c7418.chainlim(e,rp,tp)
	return tp==rp and e:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end

function c7418.setfil(c)
	return c:IsType(TYPE_SPELL) and (c:IsSetCard(0x20ed) or c:IsSetCard(0x220e)) and c:IsSSetable(false)
end
function c7418.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c7418.setfil,tp,LOCATION_DECK,0,1,nil) end
end
function c7418.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c7418.setfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		tc:RegisterFlagEffect(7418,RESET_EVENT+0x1fe0000,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(c7418.descon)
		e1:SetOperation(c7418.desop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c7418.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(7418)>0
end
function c7418.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
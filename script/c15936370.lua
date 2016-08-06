--パンドラの宝具箱
--Pandora's Treasure Box
--Scripted by Eerie Code
function c15936370.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c15936370.con)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15936370,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_CONTROL)
	e2:SetCondition(c15936370.con)
	e2:SetTarget(c15936370.tg)
	e2:SetOperation(c15936370.op)
	c:RegisterEffect(e2)
end

function c15936370.con(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end

function c15936370.fil(c)
	local seq=c:GetSequence()
	return (seq==6 or seq==7) and c:IsDestructable()
end
function c15936370.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c15936370.fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15936370.fil,tp,0,LOCATION_SZONE,1,nil) and c:IsAbleToChangeControler() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c15936370.fil,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,c,1,0,0)
end
function c15936370.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		--Debug.Message("Enters here")
		Duel.SendtoGrave(c,REASON_RULE)
		Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

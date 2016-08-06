--グレイドル・コンバット
--Graydle Combat
--Scripted by Eerie Code
function c84442536.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c84442536.con)
	e1:SetTarget(c84442536.tg)
	e1:SetOperation(c84442536.op)
	c:RegisterEffect(e1)
end

function c84442536.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0xd1)
end
function c84442536.con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return c84442536.cfilter(tc,tp)
end
function c84442536.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc and (Duel.IsChainNegatable(ev) or tc:IsDestructable()) end
	local sel=0
	if Duel.IsChainNegatable(ev) and tc:IsDestructable() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		sel=Duel.SelectOption(tp,aux.Stringid(84442536,0),aux.Stringid(84442536,1))
	elseif tc:IsDestructable() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		sel=Duel.SelectOption(tp,aux.Stringid(84442536,0))
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		sel=Duel.SelectOption(tp,aux.Stringid(84442536,1))+1
	end
	e:SetLabel(sel)
	if sel~=0 then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end
end
function c84442536.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		--Overwrite
		Duel.ChangeChainOperation(ev,c84442536.repop)
	else
		--Negate
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function c84442536.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
		c:CancelToGrave(false)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

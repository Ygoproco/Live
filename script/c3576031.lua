--クリスタルP
--Krystal Potential
--Scripted by Eerie Code
function c3576031.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xea))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	if EFFECT_UPDATE_DEFENSE then
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
	else
		e3:SetCode(EFFECT_UPDATE_DEFENCE)
	end
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3576031,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c3576031.drcon)
	e4:SetTarget(c3576031.drtg)
	e4:SetOperation(c3576031.drop)
	c:RegisterEffect(e4)
	if not c3576031.global_check then
		c3576031.global_check=true
		c3576031[0]=0
		c3576031[1]=0
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e5:SetOperation(c3576031.resetcount)
		Duel.RegisterEffect(e5,0)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		e6:SetOperation(c3576031.addcount)
		Duel.RegisterEffect(e6,0)
	end
end

function c3576031.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c3576031[tp]>0
end
function c3576031.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c3576031[tp]) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c3576031[tp])
end
function c3576031.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,c3576031[tp],REASON_EFFECT)
end

function c3576031.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c3576031[0]=0
	c3576031[1]=0
end
function c3576031.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_SYNCHRO) and tc:IsSetCard(0xea) then
			local p=tc:GetSummonPlayer()
			c3576031[p]=c3576031[p]+1
		end
		tc=eg:GetNext()
	end
end
--クリスタルP
--Krystal Potential
--Scripted by Eerie Code
function c7357.initial_effect(c)
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
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xeb))
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
	e4:SetDescription(aux.Stringid(7357,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c7357.drcon)
	e4:SetTarget(c7357.drtg)
	e4:SetOperation(c7357.drop)
	c:RegisterEffect(e4)
	if not c7357.global_check then
		c7357.global_check=true
		c7357[0]=0
		c7357[1]=0
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e5:SetOperation(c7357.resetcount)
		Duel.RegisterEffect(e5,0)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		e6:SetOperation(c7357.addcount)
		Duel.RegisterEffect(e6,0)
	end
end

function c7357.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c7357[tp]>0
end
function c7357.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c7357[tp]) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c7357[tp])
end
function c7357.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,c7357[tp],REASON_EFFECT)
end

function c7357.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c7357[0]=0
	c7357[1]=0
end
function c7357.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_SYNCHRO) and tc:IsSetCard(0xeb) then
			local p=tc:GetSummonPlayer()
			c7357[p]=c7357[p]+1
		end
		tc=eg:GetNext()
	end
end
--次元障壁
--Dimension Barrier
--Scripted by Eerie Code
function c83326048.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,83326048+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c83326048.tg)
	e1:SetOperation(c83326048.op)
	c:RegisterEffect(e1)
end

function c83326048.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ops={1056,1057,1063,1073,1074}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(op)
end
function c83326048.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lbl=e:GetLabel()
	local tpe=0
	if lbl==0 then tpe=TYPE_FUSION
	elseif lbl==1 then tpe=TYPE_RITUAL
	elseif lbl==2 then tpe=TYPE_SYNCHRO
	elseif lbl==3 then tpe=TYPE_XYZ
	else tpe=TYPE_PENDULUM end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(tpe)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c83326048.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c83326048.distg)
	e2:SetLabel(tpe)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c83326048.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(e:GetLabel())
end
function c83326048.distg(e,c)
	return c:IsFaceup() and c:IsType(e:GetLabel())
end

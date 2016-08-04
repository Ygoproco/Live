--The Despair Uranus
--Scripted by Eerie Code
function c32588805.initial_effect(c)
  --Set
  local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32588805,3))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c32588805.setcon)
	e1:SetTarget(c32588805.settg)
	e1:SetOperation(c32588805.setop)
	c:RegisterEffect(e1)
	--ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c32588805.atkval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

function c32588805.filter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c32588805.setcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and not Duel.IsExistingMatchingCard(c32588805.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c32588805.setfil(c,st)
  return c:IsType(st) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function c32588805.settg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c32588805.setfil,tp,LOCATION_DECK,0,1,nil,TYPE_SPELL+TYPE_TRAP) end
end
function c32588805.setop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
  local ops={}
  local opval={}
  ops[1]=aux.Stringid(32588805,1)
  ops[2]=aux.Stringid(32588805,2)
  opval[0]=TYPE_SPELL
  opval[1]=TYPE_TRAP
  Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(32588805,0))
	local op=Duel.SelectOption(1-tp,table.unpack(ops))
	local mg=Duel.GetMatchingGroup(c32588805.setfil,tp,LOCATION_DECK,0,nil,opval[op])
	if mg:GetCount()>0 then
	  local sc=mg:Select(tp,1,1,nil)
	  Duel.SSet(tp,sc:GetFirst())
		Duel.ConfirmCards(1-tp,sc)
	end
end

function c32588805.atkfil(c)
  return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c32588805.atkval(e,c)
	local g=Duel.GetMatchingGroup(c32588805.atkfil,c:GetControler(),LOCATION_ONFIELD,0,nil)
	return g:GetCount()*300
end

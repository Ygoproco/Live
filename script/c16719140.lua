--Subterror Nemesis Warrior
--Scripted by Eerie Code
function c16719140.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16719140,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16719140)
	e1:SetCost(c16719140.cost)
	e1:SetTarget(c16719140.tg)
	e1:SetOperation(c16719140.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16719140,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_FLIP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,16719140+1)
	e2:SetCondition(c16719140.spcon)
	e2:SetTarget(c16719140.sptg)
	e2:SetOperation(c16719140.spop)
	c:RegisterEffect(e2)
end

function c16719140.cfil(c,e,tp,mg,hl)
	if c:IsSetCard(0xed) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() then
		local lv=c:GetLevel()-hl
		return mg:CheckWithSumGreater(Card.GetOriginalLevel,lv)
	else return false
	end
end
function c16719140.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,c)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c16719140.cfil,tp,LOCATION_DECK,0,1,nil,e,tp,mg,c:GetOriginalLevel())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16719140.cfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg,c:GetOriginalLevel())
	Duel.SendtoGrave(g,REASON_EFFECT)
	e:SetLabelObject(g:GetFirst())
end
function c16719140.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c16719140.op(e,tp,eg,ep,ev,re,r,rp)
	local pud=0
	local pdd=0
	if POS_FACEUP_DEFENSE then
		pud=POS_FACEUP_DEFENSE
		pdd=POS_FACEDOWN_DEFENSE 
	else 
		pud=POS_FACEUP_DEFENCE 
		pdd=POS_FACEDOWN_DEFENCE 
	end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc and tc:IsLocation(LOCATION_GRAVE) and (tc:IsCanBeSpecialSummoned(e,0,tp,false,false,pud) or tc:IsCanBeSpecialSummoned(e,0,tp,false,false,pdd)) then
		local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,c)
		local lv=tc:GetLevel()-c:GetOriginalLevel()
		local mat=nil
		if lv==0 then
			mat=mg:Select(tp,1,1,nil)
		else
			mat=mg:SelectWithSumGreater(tp,Card.GetOriginalLevel,lv)
		end
		if mat:GetCount()==0 then return end
		mat:AddCard(c)
		if Duel.Release(mat,REASON_EFFECT)>0 then
			local opt=Duel.SelectOption(tp,aux.Stringid(16719140,2),aux.Stringid(16719140,3))
			local pos=pud
			if opt>0 then pos=pdd end
			Duel.SpecialSummon(tc,0,tp,tp,false,false,pos)
		end
	end
end

function c16719140.spcfil(c)
	return c:IsSetCard(0x10ed)
end
function c16719140.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16719140.spcfil,1,e:GetHandler())
end
function c16719140.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c16719140.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

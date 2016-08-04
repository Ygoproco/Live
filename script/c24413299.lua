--The Suppression Pluto
--Scripted by Eerie Code
function c24413299.initial_effect(c)
  --
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(24413299,0))
  e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetTarget(c24413299.target)
  e1:SetOperation(c24413299.operation)
  c:RegisterEffect(e1)
end

function c24413299.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and 
	  (Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil) or 
		(Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c24413299.operation(e,tp,eg,ep,ev,re,r,rp)
  local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local cg=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	local cc=cg:GetCount()
	local dc=dg:GetCount()
	local b1=(cc>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local b2=dc>0
	Duel.ConfirmCards(tp,hg)
	Duel.ShuffleHand(1-tp)
	if g:GetCount()>0 and cc+dc>0 then
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(24413299,1),aux.Stringid(24413299,2)) elseif b1 then op=0 else op=1 end
		if op==0 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		  local ctg=cg:Select(tp,1,1,nil)
		  Duel.HintSelection(ctg)
		  local ctc=ctg:GetFirst()
		  if not Duel.GetControl(ctc,tp) then
			if not ctc:IsImmuneToEffect(e) and ctc:IsAbleToChangeControler() then
				Duel.Destroy(ctc,REASON_EFFECT)
			end
		  end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dtg=dg:Select(tp,1,1,nil)
			local dtc=dtg:GetFirst()
			Duel.HintSelection(dtg)
			if Duel.Destroy(dtc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not dtc:IsLocation(LOCATION_HAND+LOCATION_DECK) and dtc:IsType(TYPE_SPELL+TYPE_TRAP) and dtc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(24413299,3)) then
				Duel.BreakEffect()
				Duel.SSet(tp,dtc)
				Duel.ConfirmCards(1-tp,dtc)
			end
		end
	end
end
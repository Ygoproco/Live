--Scripted by Eerie Code
--Metalphosis Adamante
function c7143.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe2),c7143.matfilter,1,1,true)
end
function c7143.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()<=2500
end
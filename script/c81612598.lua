--Scripted by Eerie Code
--Metalphosis Adamante
function c81612598.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe2),c81612598.matfilter,1,1,true)
end
function c81612598.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()<=2500
end
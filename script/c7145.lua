--メタルフォーゼ・カーディナル
--Metalphosis Cardinal
--Script by mercury233
function c7145.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe2),c7145.matfilter,2,2,true)
end
function c7145.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()<=3000
end
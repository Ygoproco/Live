--メタルフォーゼ・カーディナル
--Metalphosis Cardinal
--Script by mercury233
function c54401832.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe1),c54401832.matfilter,2,2,true)
end
function c54401832.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()<=3000
end
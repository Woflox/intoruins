[1mdiff --git a/cavedunj.p8 b/cavedunj.p8[m
[1mindex f3eb918..5141167 100644[m
[1m--- a/cavedunj.p8[m
[1m+++ b/cavedunj.p8[m
[36m@@ -107,6 +107,7 @@[m [mfunction alltiles(func)[m
 end[m
 [m
 function drawmap()[m
[32m+[m	[32mdarkpal=split("14,238,238,238,238,238,238,238,238,238,238,238,238")[m
 	alltiles(function(pos,tile)[m
 		typ = tile.typ[m
 		[m
[36m@@ -116,10 +117,7 @@[m [mfunction drawmap()[m
 		pal(14,129,1)[m
 		if tile.light==0 or [m
 					not tile.vis then[m
[31m-			for i=2,13 do[m
[31m-				pal(i,238,2)[m
[31m-			end[m
[31m-			pal(1,14,2)[m
[32m+[m			[32mpal(darkpal,2)[m
 		else[m
 			pal(1,225,2)[m
 		end[m

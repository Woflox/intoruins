pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--iNTO rUINS
--BY ERIC BILLINGSLEY

function _init()
assigntable(
[[mode:title,statet:0,depth:0,turnorder:0,btnheld:0,shake:0,playerdir:2,invindex:1
,tempty:0,tcavefloor:50,tcavefloorvar:52
,tcavewall:16,tdunjfloor:48,tywall:18,txwall:20
,tshortgrass1:54,tflatgrass:38,tlonggrass:58
,thole:32,txbridge:60,tybridge:44
,minroomw:3,minroomh:2,roomsizevar:8
,specialtiles:{},textanims:{},spawns:{},diags:{},inventory:{},rangedatks:{}]],
_ENV)
entdata=assigntable(
[[64=n:yOU,hp:20,atk:0,dmg:2,armor:0,atkanim:patk,moveanim:move,deathanim:pdeath,fallanim:pfall,acol:13,ccol:8
70=n:rAT,hp:3,atk:0,dmg:1,armor:0,ai:,pdist:-15,runaway:,alert:14,hurt:15,fallanim:fall
71=n:jACKAL,hp:4,atk:0,dmg:2,armor:0,ai:,pdist:0,pack:,movandatk:,alert:20,hurt:21
65=n:gOBLIN,hp:7,atk:1,dmg:3,armor:0,ai:,pdist:0,alert:30,hurt:11
66=n:gOBLIN MYSTIC,hp:6,atk:1,dmg:3,armor:0,ai:,pdist:-2,alert:30,hurt:11
67=n:gOBLIN ARCHER,hp:7,atk:1,dmg:3,armor:0,ai:,pdist:-3,alert:30,hurt:11
68=n:gOBLIN WARLOCK,hp:6,atk:1,dmg:3,armor:0,ai:,pdist:-3,alert:30,hurt:11
69=n:oGRE,hp:15,atk:2,dmg:8,armor:1,slow:,knockback:,stun:2,ai:,pdist:0,alert:31,hurt:16
72=n:bAT,hp:4,atk:2,dmg:6,armor:0,movratio:0.6,ai:,behav:wander,darksight:,burnlight:,pdist:0,flying:,idleanim:batidle,alert:32,hurt:13
73=n:pINK JELLY,hp:10,atk:1,dmg:2,armor:0,ai:,hurtsplit:,pdist:0,moveanim:emove,movratio:0.33,alert:19,hurt:19
137=n:mUSHROOM,hp:1,blocking:,sporeburst:12,light:4,lcool:,deathanim:mushdeath,flippable:,flammable:,death:42
136=n:bRAZIER,hp:1,nofire:,blocking:,hitfire:,light:4,idleanim:idle3,deathanim:brazierdeath,animspeed:0.3,death:23
169=n:cHAIR,hp:2,nofire:,blocking:,hitpush:,dmg:2,stun:1,flippable:,deathanim:propdeath,animspeed:0.3,death:23
200=n:bARREL,hp:2,blocking:,hitpush:,dmg:2,stun:1,flammable:,deathanim:propdeath,animspeed:0.3,death:23
138=n:fIRE,var:effect,light:4,idleanim:fire,deathanim:firedeath,animspeed:0.33
139=n:sPORES,var:effect,light:4,lcool:,idleanim:sporeidle,deathanim:firedeath,animspeed:0.33,flippable:,flying:
idle3=l012
fire=01f0l.1.2.3f1f2f3
firedeath=0_
sporeidle=0l112233
batidle=l0022
move=044
turn=44
throw=444
emove=022
esplit=02022
sleep=lz000000000000000000000
flash=l!0000000000000000000000000000000000000000000
patk=wa22d22r
eatk=wa22dr22
batatk=wa20dr22
death=wb0cv50v500v50r_
pdeath=w444l6
mushdeath=w01r_
brazierdeath=w33r_
propdeath=w11r_
fall=w0v50v50v60cv70v80v8or_
pfall=w0v54v54v64cv74v84v84e444r_
fallin=wsv90v90v94v94sv5h4m6666666sv54v3440r
slofall=wsv94v84v74v64v54v54v54v54v544v5444v54m00r
130=n:tORCH,var:item,slot:wpn,dmg:3,atk:1,lit:,throw:4,light:4,throwln:0,wpnfrms:16,id:
132=n:sPEAR,var:item,slot:wpn,dmg:3,atk:1,pierce:,throwatk:3,throw:6,throwln:0.25,wpnfrms:16
133=n:rAPIER,var:item,slot:wpn,dmg:2,atk:3,lunge:,throw:4,throwln:1,wpnfrms:16
134=n:aXE,var:item,slot:wpn,dmg:3,atk:1,arsc:,throw:5,wpnfrms:16
135=n:hAMMER,var:item,slot:wpn,dmg:6,atk:1,stun:2,knockback:,slow:,throw:2,wpnfrms:16
129=n:oAKEN STAFF,var:item,unid:,throw:4
145=n:dRIFTWOOD STAFF,var:item,throw:4
161=n:eBONY STAFF,var:item,throw:4
177=n:pUPLEHEART STAFF,var:item,throw:4
140=n:bRONZE AMULET,acol:9,var:item,slot:amulet,throw:4
141=n:pEWTER AMULET,acol:5,var:item,slot:amulet,throw:4
142=n:gOLDEN AMULET,acol:10,var:item,slot:amulet,throw:4
143=n:sILVER AMULET,acol:7,var:item,slot:amulet,throw:4
156=n:oCHRE CLOAK,ccol:9,var:item,slot:cloak,throw:2
157=n:gREY CLOAK,ccol:5,var:item,slot:cloak,throw:2
158=n:gREEN CLOAK,ccol:3,var:item,slot:cloak,throw:2
159=n:cYAN CLOAK,ccol:12,var:item,slot:cloak,throw:2
172=n:cYAN ORB,var:item,light:2,throw:6
173=n:yELLOW ORB,var:item,light:2,throw:6
174=n:rED ORB,var:item,light:2,throw:6
175=n:bLACK ORB,var:item,light:2,throw:6
188=n:gREEN ORB,var:item,light:2,throw:6
189=n:oRANGE ORB,var:item,light:2,throw:6
190=n:pURPLE ORB,var:item,light:2,throw:6
191=n:pINK ORB,var:item,light:2,throw:6
]],nil,"\n","=")
 
 function mapgroup(x,y)
  group={}
  for i=y,31 do
			local typ=mget(x,i)
			if typ == tempty then
				return group,i+1
			else
				add(group,typ)
			end
  end
 end
 
	tlsfx,adj,wpnpos,fowpals,whitepal,redpal,items=
	assigntable"58:37,38:10,54:10,44:38,60:38,40:43",--tlsfx
	vec2list"-1,0|0,-1|1,-1|1,0|0,1|-1,1",--adj
 vec2list"3,-2|2,-1|1,-2|1,3|3,-3|1,0",--wpnpos
{split"0,0,0,0,0,0,0,0,0,0,0,0,0,0",
	split"15,255,255,255,255,255,255,255,255,255,255,255,255,255",
	split"241,18,179,36,21,214,103,72,73,154,27,220,93,46"
},
	split"7,7,7,7,7,7,7,7,7,7,7,7,7,7",--whitepal
 split"8,8,8,8,8,8,8,8,8,8,8,8,8,8",--redpal
	mapgroup(14,0)--items
	
 for s in all(
split([[16
-9,-4
0,-8|5,-8|13,-8|13,4|4,4|2,4
5,13|8,13|5,13|5,4|11,4|3,4
◆32
-8,-4
0,0|4,0|13,0|0,0|4,1|13,0
4,8|8,8|3,8|4,8|7,7|4,8
◆20
-9,-2
12,-6|0,-8
4,13|12,17
◆18
-5,-2
9,-8|2,-8
6,17|7,17
◆default
-8,-4
1,0
15,8]],"◆")) do
		local typ,baseoffset,offset,size=unpack(split(s,"\n"))
		specialtiles[typ]=
		{vec2s(baseoffset),
		 vec2list(offset),
		 vec2list(size)}
 end
 
	for i=0,9 do
		curspawns=add(spawns,{})
		local y=0
		while true do
			group,y=mapgroup(i,y)
			if (#group==0) break
			add(curspawns,group)
		end
	end
	
	local rseed=rnd(0xffff.ffff)
	srand(0x5b04.17cb)
	genmap(vec2s"10,13")
	srand(rseed)
	
	addtoinventory(create(130)).eQUIP(true)
	calclight()
end


function updateturn()
 if (waitforanim) return
	
	if turnorder==0 then
		pseen=false
	 if not taketurn(player,player.pos,player.tl) then
	 	return
	 end
	 tickstatuses(player)
	 updatemap()
	elseif turnorder==1 then
		for i,ent in next,ents do
			if ent.ai then
			 taketurn(ent,ent.pos,ent.tl,ent.group)
			end
			if ent!=player then
				tickstatuses(ent)
			end
		end
	else
	 for i,ent in ipairs(ents) do
			postturn(ent)
		end
		updateenv()
		turnorder=0
		return
	end
	turnorder+=1
	updateturn()
end

function modeis(m)
	return mode==m
end

function _update()
	if modeis"play" then
		updateturn()
	elseif modeis"aim" then
		updateaim(unpack(aimparams))
	elseif modeis"reset" and
	 statet>0.3 
	then
	 run()
	end
	
	statet+=0.033
	
	if mode!="ui" then
 	waitforanim=#rangedatks>0
		for i,ent in ipairs(ents) do
			updateent(ent)
		end
 end
	
	local camtarget= 
 	screenpos(
 		lerp(player.pos,
 							vec2s"10,9.5",
 							mode=="gameover" and
 							max(0.36-statet*2) or
 							0.36))
	smoothb=lerp(smoothb,camtarget,0.5)
	smooth=lerp(smooth,smoothb,0.25)
	
	function getcampos(val)
	 return flr(rnd(shake*2)-
	            shake+val-63.5)
	end
	
	campos=vec2(getcampos(smooth.x),
													getcampos(smooth.y))
	shake*=0.66
end

function _draw()
	cls()
	camera(campos.x,campos.y)
	lfillp=localfillp(0xbfd6.4,
								-campos.x,
								-campos.y)

 anyfire=false
	for i,drawcall in 
					ipairs(drawcalls) do
		drawcall[1](
			unpack(drawcall[2]))
	end
	if anyfire != fireplaying then
		fireplaying=anyfire
		music(anyfire and 32 or -1, 500, 3)
	end
	
	for atk in all(rangedatks) do
	 atk[1]+=1 --counter
		if rangedatk(unpack(atk)) then
		 del(rangedatks,atk)
		end
	end
	
	pal()
	palt(1)
	pal(usplit"15,129,1")
	pal(usplit"11,131,1")
	fillp()
	
	if fadetoblack then
  textanims={}
 end
 if modeis"play" then
		for anim in all(textanims) do
		 local t=(anim[5] or 1)*
		          (time()-anim[7])
		 local col=anim[4] or 7
		 if t>0.5 then
				del(textanims,anim)
			else
				anim[2].y-=0.5-t
				local text,x=anim[1],anim[2].x
				print(text,
										mid(campos.x,4+x-#text*2,campos.x+128-#text*4)-
										(anim[3] and cos(t*2) or 0),
										anim[2].y+(anim[6] or 0)-6,
										t>0.433 and 5 or col)
			end
		end
	elseif modeis"aim" then
		?"\+fe\19",aimscrpos.x,aimscrpos.y,7
	end
	camera()
 
	if modeis"play" or
	   modeis"ui" then
		local x=drawbar(player.hp/player.maxhp,
		        "HP",2,123,2,8)
		for k,v in 
			pairs(player.statuses)
		do
			x=drawbar(v[1]/v[2],k,x,123,v[3],v[4])	
		end
	elseif modeis"aim" then
		?"\f6⬅️\+fd⬆️\+8m⬇️\+fd➡️:aIM     ❎:fIRE",18,118
	end
	if modeis"ui" then
		if btnp"4" then
			if (popdiag())	return
		end
		uitrans*=0.33
		for i,d in ipairs(diags) do
		 focus=i==#diags
		 curindex=0
		 d()
	 end
	elseif textcrawl(
"\^x5\-hiNTO rUINS\^x4\
			                \
\
\
\
\
\
\
\
\
\
\
\
  press ❎",
  usplit"41,24,0.1,6,title,0,9")
	then
	 setmode"intro"
	elseif	textcrawl(
" tHE CAVE OPENING CALLS TO YOU.      \
cOULD THIS BE THE RESTING PLACE\
OF THE FABLED wINGS OF yENDOR?    \
\
\
\
\
\
\
\
\
\
\
   \-jtHERE'\-eS NO TURNING BACK\-f.\-e.\-e.    \
\
         ❎:jump down",
  usplit"2,18,0,6,intro")
 then
  if statet > 5.75 then
	  setmode"play"
	  music(-1,300)
	  musicplayed=false
	  move(player,vec2s"10,12")
	 else
	 	statet=5.75
	 end
	elseif textcrawl(
"\^x5\-dgAME oVER\^x4                                        \
\
\
\
\
\
\
\
\
\
\-kdEPTH:"..depth.. 
"            \n\n\-a❎:tRY AGAIN",
 usplit"47,29,1.3,13,gameover,16")
 then
 	fadetoblack=true
 	music(-1,300)
 	setmode"reset"
	end
	inputblocked=false
end

function popdiag()
	deli(diags)
	if #diags==0 then
		setmode"play"
		return true
	end
end

function drawbar(ratio,label,x,y,col1,col2)
 ?label,x-1,y-7,0
 ?label,x,y-6,col1
 
 local w = max(#label*4-1,20)
 local barw=ceil(ratio*w)-1
 rect(x-1,y-1,x+w,y+3,15)
 rect(x,y,x+barw,y+2,col2)
 if barw>0 then
	 rectfill(x,y+1,x+barw-1,
	 									y+2,col1)
	end
 return x+w+4
end

function textcrawl(str,x,y,fadet,col,m,mus,xtra)
 if modeis(m) and statet>fadet then
	 if mus and not musicplayed then
		 music(mus)
		 musicplayed=true
		end
 	print(sub(str,0,statet*30+(xtra or 0)),x,y,statet>fadet+0.1and col or 1)	
	 return btnp"5"
	end
end

function animtext(text,ent,wavy,col,spd,offset)
 add(textanims,{text,entscreenpos(ent),wavy,col,spd,offset,time()})
end

function log(text)
 animtext(text,player,false,7,0.5)
end

function frame(x,y,x2,y2,func)
 clip()
 func(x-1,y-1,x2+1,y2+1,0)
	rect(x,y,x2,y2,1)
	cursor(x-3,y+4)
	clip(x-3,y,x2-x+2,y2-y)
end

function listitem(str,sel)
 if sel==nil then
  curindex+=1
  sel=curindex==menuindex
 end
 ?(sel and "\#0\f7\|h❎ "or"\fd\|h  ")..str
	return sel and focus and 
	 not inputblocked and btnp"5" 
end

function getindex(maxind,cur)
 cur=cur or menuindex
	return focus and not inputblocked and
												(cur+tonum(btnp"3")-
													tonum(btnp"2")+
												maxind-1)%maxind+1
												or cur
end

function gettrans(a,b)
	return lerp(b,a,focus and uitrans or 0.53*(1-uitrans))
end

function inv()
 frame(gettrans(126,42),6,126,111,rect)
 local i=0
 local sely=0
	?"\fd  iNVENTORY\n\f1 …………… EQUIPPED"
	
	invindex=getindex(#inventory,invindex)
	
	function listitems(eqpd)
		for item in all(inventory) do
			if item.equipped==eqpd then
			 i+=1
				if listitem(item.n,i==invindex) then
					dialog(info)
					selitem=item
				end
			end
		end
	end
	
	listitems(true)
	?"\n\f1 ……………… STOWED"
	listitems()
end

function info()
 local eqpd = selitem.equipped
 local x=gettrans(42,5)
 frame(x,6,gettrans(42,90.5),111,rectfill)
 menuindex=getindex(2)

 spr(selitem.typ+(selitem.ai and 16 or 0),x+3,8)
 ?"\fd    "..selitem.n
 local statstr="\f1 ……………………………\fd\|j"
 if selitem.id then
 	for str in all(split([[
 
  nAME: ,name|
  cASTS LIGHT
,lit|
  pIERCING ATTACK
,pierce|
  aRC ATTACK
,arc|
  lUNGE ATTACK
,lunge|
  kNOCKBACK=knockback|
  hEALTH:      ,hp|/=maxhp|
  aCCURACY:   +,atk|
  dAMAGE:      ,dmg|
  aRMOR:       ,armor|
  tHROW RANGE: ,throw|
  tHROW ACC:   ,throwatk|
  sTUN:        ,stun|
  cHARGES:     ,charge|/,maxcharges]]
  ,"|"))
  do
  	k,v=usplit(str)
	  local val=selitem[v]
	  if val then
	   statstr..=k..val
	  end
	 end
	else
		statstr..="\n  ????"
	end
 ?statstr
 
 --menu
 ?"\f1 ……………………………",x-3,86
 
 for action in all(
 {selitem.slot and
  (eqpd and 
   (selitem.lit and"eXTINGUISH" or "sTOW") 
   or"eQUIP")or "uSE",
  "tHROW"})
 do
 	if listitem(action) then
 	 popdiag()popdiag()
 	 skipturn,waitforanim=
 	 true,true
 		selitem[action]()
 		sfx"25"
 	end
 end
end

function confirmjump()
	frame(32,gettrans(33,38.5),96,gettrans(33,82.5),rect)
	menuindex=getindex(2)
	?"\fd\|i  tHE HOLE OPENS\n  UP BELOW YOU\-f.\-e.\-e.\n"
	
	if listitem" jUMP DOWN" then
	 popdiag()
	 move(player,playerdst)
	elseif listitem" dON'T JUMP" then
	 popdiag()
	end
end

function dialog(func)
	uitrans=mode=="ui" and 
	        0.33 or 1
 setmode"ui"
	menuindex=1
 add(diags,func)
 sfx"39"
end

function setmode(m)
	mode,statet,inputblocked=
	m,0,true
end
-->8
--[[tiles, rendering

flags:

0:navigable
1:passlight
2:xtraheight
3:infrontwall
4:genable
5:drawnormal
6:flippable
7:manmade
8:navflying
9:flammable
10:flammable2
11:wall
12:bridge
]]

function tile(typ,pos)
	local tl={typ=typ,pos=pos}
	assigntable("fow:1,fire:0,spores:0,newspores:0,hilight:0,hifade:0",tl)
	return tl
end

function settile(tl,typ)
	tl.typ,tl.bg,tl.genned=typ
end
	
function drawcall(func,args)
	add(drawcalls, {func,args})
end

function initpal(tl, fadefow)
 pal()	
	palt(1)
	fow=1
	if fadefow then
	 if not fadetoblack then
			if modeis"gameover" then
				fow=tl==player.tl and 3 or 1
			elseif vistoplayer(tl) and
			   mode != "ui" then
				fow=tl.light>=2 and 4 or 3
			elseif tl.explored then
				fow=2
			end
		end
		tl.fow+=mid(-1,fow-tl.fow,1)
	end
	fow=tl.fow

	if fow<4 then
		fillp(lfillp)
		pal(fowpals[fow],2)
	else
		fillp()
 end
end

function onscreenpos(pos,pad)
 local scrpos=screenpos(pos)
 local scrposrel=scrpos-smooth
	return max(abs(scrposrel.x),
        abs(scrposrel.y))<=pad and
        scrpos
end

function drawtl(tl,typ,pos,baseoffset,offset,size,flp,bg,hilight)
	typ=typ or (bg and tl.bg) or tl.typ
	local xtraheight,litsprite=
	fget(typ,2)and 5 or 0,typ+192
	
	--lighting
	for i=0,6 do
		if not bg and fow==4 and 
		   fget(litsprite,i) then
			local adjtile=
				getadjtl(pos,i)
			if adjtile and
						adjtile.lightsrc then
				typ=litsprite
				pal(8,adjtile.lcool and 13 or 4)
				pal(9,adjtile.lcool and 12 or 9)
			end
		end
	end
	
	local scrpos=screenpos(pos)+
	             offset+baseoffset
	sspr(typ%16*8+offset.x,
							flr(typ/16)*8+
								offset.y-xtraheight,
							size.x,size.y+xtraheight,
							scrpos.x,scrpos.y-xtraheight,
							size.x,size.y+xtraheight,flp)
	if hilight then
	 tl.hifade+=mid(-1,tl.hilight-tl.hifade,1)
	 if tl.hifade>0 then
	  if (tl.explored)pal(2,34,2)
	 	spr(tl.hifade*16-8,scrpos.x,scrpos.y,2,1)
	 end
 	tl.hilight=0
	end
end

function drawents(tl)
 function drawent(var)
  local ent=tl[var]
		if ent and (vistoplayer(tl) or
		   ent.lasttl and vistoplayer(ent.lasttl))
	 then
			initpal(ent.tl)
			if ent==player then
				pal(8,ent.stat"ccol")
				pal(9,ent.stat"acol") 
			end
			if ent.flash then
				pal(whitepal)
				ent.flash=false
			elseif ent.pal then
				pal(ent.pal)
				if ent.fillp then
				 fillp(lfillp)
				end
			end
			local flp=ent.xface<0 or ent.animflip
			local scrpos=ent.renderpos+
						vec2(flp and -1 or 0,0)
			local frame=
							ent.animframe
							+0.5+ent.yface*0.5
			spr(ent.typ+frame*16,
							scrpos.x,scrpos.y,
							1,ent.animheight,
							flp)
			local held=aimitem or ent.wpn
			if ent==player and
			   held and
			   frame<=5 then
			 local wpnpos=wpnpos[frame+1]
				pal(8,8)
				pal(9,9)
				
				spr(held.typ +
				    frame%4*held.wpnfrms,
								scrpos.x+
								wpnpos.x*ent.xface,
								scrpos.y+wpnpos.y,
								1,ent.animheight,
								flp)
			end
			ent.lasttl=nil
		end
	end

	drawent"item"
 drawent"ent"
 checkeffects(tl)
 drawent"effect"
end

function checkeffects(tl)

 function checkeffect(typ,has)
 	local effect=tl.effect
 	if effect then
		 if	effect.typ==typ then
		  if not effect.dead and
		 	not has then
			 	effect.setanim(effect.deathanim)
			 	effect.dead,effect.light=true
		 	end
		 elseif has then
		 	destroy(effect)
		 end
		end
		if not tl.effect and has then
		 create(typ,tl.pos)
		end
	end
	
	local hasfire=tl.fire>0 or
 						tl.ent and 
 						tl.ent.statuses.BURN
 local hasspores=tl.spores>0

	anyfire=anyfire or hasfire and mode!="ui"

 checkeffect(138,hasfire)
 checkeffect(139,hasspores)
end

function setupdrawcalls()
	drawcalls={}
	alltiles(
	
	function(pos,tl)
		local typ,palready=
		tl.typ,false
		
		function draw(tltodraw,pos,i,bg)
			if not palready then
				drawcall(initpal,{tl,true})
				palready=true
			end
			local typ,flp=
			i and (bg and tltodraw.bg or
			              tltodraw.typ),
			tl.flip
			if not i and tltodraw.typ==tywall then
				typ=tdunjfloor
			end

		 local baseoffset,offsets,sizes=unpack(specialtiles[i and typ or "default"])
		 local offset,size=
		 offsets[i or 1],
		 sizes[i or 1]
		 --special tiles
			if i then
			 if typ==tywall and
							(pos.y+genpos.y)%2==0 then
					baseoffset+=vec2s"-6,-2"
				end
				if typ==thole then
				 typ+=192
					if i>3 then
					 typ += 2--brick hole
					 flp=false
					 baseoffset+=vec2s"0,1"
					end
				end
				if (i-2)%3 !=0 then
				 flp=false
				end
			end
			
			drawcall(drawtl,
							 {tltodraw,typ,pos,
							  baseoffset,offset,size,
							 	flp and 
							 		tileflag(tltodraw,6), bg, 
							 	not i and not bg})
		end
		
		infront=fget(typ,3)
		
		if tl.bg then
			draw(tl,pos,nil,true)
		end
		
		if not infront and
					fget(typ,5) or
					(typ==tywall and
					(pos.y+genpos.y)%2==1) then
			draw(tl,pos)
		end
		
		for n=1,6 do
			i=split"2,1,3,4,5,6"[n]
			
			if infront and i==4 then
				draw(tl,pos)		
			end
			
			local adjtl=getadjtl(pos,i)
			if adjtl then
				adjtyp = adjtl.typ
				
			 if typ!=tcavewall and
				 		typ!=tempty and
				 		adjtyp==tcavewall 
				then
					draw(adjtl,pos,i)
				elseif i<=2 and
					      tileflag(adjtl,11)
				then
				 wallpos=pos+adj[i]
					if adjtyp==tywall and
							 i==1 and
							 (wallpos.y+genpos.y)%2==0 
					then
					 draw(adjtl,wallpos)
					end
					draw(adjtl,wallpos,i)
				end
				if (typ==thole or
				    tl.bg==thole) and
				   i<=3 and
							adjtyp!=thole and
							adjtl.bg!=thole
				then
				 draw(tl,pos,i+
				 	(manmade(adjtl)
				 	and 3 or 0),--brick hole
				 	tl.bg==thole)--bridges
				end 
			end
		end
		local uprtl=getadjtl(pos,3)
		if uprtl and 
					navigable(uprtl,true) then
			drawcall(drawents,{uprtl})	
		end
	end)	
end

-->8
--map stuff

function gettile(pos)
 local y=world[pos.y]
	return y and y[pos.x]
end

function inbounds(pos)
 local y=tileinbounds[pos.y]
	return y and y[pos.x]
end

function getadjtl(pos,i)
	return gettile(i==0 and pos or
	               pos+adj[i])
end

function visitadj(pos,func)
	for i=1,6 do
		local npos=pos+adj[i]
		func(npos,gettile(npos))
	end
end

function visitadjrnd(pos,func)
	local indices=split"1,2,3,4,5,6"
	for i=1,6 do
		local n=i+rndint(7-i)
		local npos=pos+adj[indices[n]]
		indices[n]=indices[i]
		func(npos,gettile(npos))
	end
end

function rndpos()
	return inboundposes[rndint(#inboundposes)+1]
end

function alltiles(func)
	for i,tl in ipairs(validtiles) do
		func(tl.pos,tl)
	end
end

function tileflag(tl,i)
	return fget(tl.typ+flr(i/8),i%8)
end

function navigable(tl,flying)
	return tileflag(tl,flying and 8 or 0)
end

function passlight(tl)
	return tileflag(tl,1)
end

function genable(tl)
	return tileflag(tl,4)
end

function manmade(tl)
	return tileflag(tl,7) or
	(tl.bg and fget(tl.bg,7))
end

function vistoplayer(tl)
	return tl.vis and (tl.light>0 or tl.pdist>-2)
end

function dijkstra(var,tovisit,check)
	while #tovisit>0 do
		local tl=deli(tovisit,1)
		local pos,d=tl.pos,tl[var]-1
		for i=1,6 do
		 local ntl=gettile(pos+adj[i])
			if ntl[var]<d then
				ntl[var]=d
				if check(ntl) then
					add(tovisit,ntl) 
				end
			end
		end
	end
end

function calcdist(pos,var,ignblock)
	alltiles(
	function(npos,ntl)
		ntl[var]=pos==npos and 0
		         or -1000
	end)
	dijkstra(var,{gettile(pos)},
	function(tl)
		return tileflag(tl,0) and 
		(ignblock or not
		(tl.ent and tl.ent.blocking))
	end)
end

function viscone(pos,dir1,dir2,lim1,lim2,d)
	pos+=dir1
	local lastvis,notfirst=false
	for i=ceil(lim1),flr(lim2) do
	 local tlpos=pos+i*dir2
		local tl=gettile(tlpos)
	 if tl then
			local vis,splitlim=
			passlight(tl),-1
			tl.vis=tileflag(tl,5) or
											(tl.typ==tywall and
											 player.pos.x<
											 tlpos.x)
			if vistoplayer(tl) then
			 tl.explored=true
			end
			if vis then 
				if notfirst and
					not lastvis then
					lim1=i-0.5
				end
				if i==flr(lim2) then
					splitlim=lim2
				end
			elseif lastvis then
				splitlim=i-0.5
			end
			
			if splitlim!=-1 then
				local expamd=(d+1)/d
				viscone(pos,dir1,dir2,
												expamd*lim1,
												expamd*splitlim,
												d+1)
			end
			lastvis,notfirst=
			vis,true
		end
	end
end

function calcvis(pos)
	alltiles(
	function(npos,tl)
		tl.vis=npos==pos
	end)
	for i=1,6 do
		viscone(pos,adj[i],adj[(i+1)%6+1],0,1,1)
	end
end

function calclight()
 local tovisit={}

 alltiles(
 function(pos,tl)
		ent=tl.ent
		function checklight(var)
			if tl[var] then
				local light=tl[var].stat"light"
				if light and light>tl.light then
					tl.light=light
					if light>=3 then
						tl.lightsrc=true
						tl.lcool=tl[var].lcool
					end
				end
			end	
		end
		tl.light=-10
		tl.lightsrc=false
		checklight"item"
		checklight"effect"
		checklight"ent"
  if tl.light>0 then
			add(tovisit,tl)
		end
	end)
	dijkstra("light",tovisit,passlight)
end

function flatten(tl)
 if tl.typ==tlonggrass then
 	tl.typ=tflatgrass
 end
end

function effect(var,pos,typ,val)
	local tl=gettile(pos)
	tl[var]=max(tl[var],val)
	if not (tl.effect and 
									tl.effect.typ==typ) then
		create(typ,pos)	
	end
end

function setfire(tl)
 tl.fire,tl.spores,tl.newspores=
 max(tl.fire,1),0,0
 entfire(tl)
end

function sporeburst(tl,val)
	tl.spores+=val
	sfx"17"
end

function trysetfire(pos,tl,nop)
	if tileflag(tl,10) or
    tl.spores>0 or
    (rndp() or nop) and
   	(tileflag(tl,9) or
    	tl.ent and
					tl.ent.flammable)
	then
 	setfire(tl)
 end
end

function entfire(tl)
	if tl.ent and 
		  not tl.ent.nofire then
		 burn(tl.ent)
	end
end
		
function updateenv()
	alltiles(
	function(pos,tl)
	 if tl.spores>0 then
			tl.spores=max(tl.spores-rnd(0.25))
			if tl.spores>1 then
				adjtls={}
				visitadj(pos,
				function(npos,ntl)
					if navigable(ntl,true) and
					   ntl.fire==0
				 then
						add(adjtls,ntl)
					end
				end)
				local portion=tl.spores/(#adjtls+1)
				tl.newspores-=tl.spores-portion
				for ntl in all(adjtls) do
					ntl.newspores+=portion
				end
			end
		end
		if tl.fire>=2 then
		 entfire(tl)
		 visitadj(pos,trysetfire)
			if tileflag(tl,9) then
			 if rndp(0.2) then
			 	tl.fire=0
			 	tl.typ=34
			 end
			else
				tl.fire=0
				if tileflag(tl,10) then
					tl.typ=thole
					checkfall(tl.ent)
				end
			end
		end
		if tl.ent and
		 tl.ent.statuses.BURN then
		 trysetfire(nil,tl,true)
		end
	end)
	alltiles(
	function(pos,tl)
		if tl.fire>=1 then
			tl.fire+=1
		 setfire(tl)
		end
		tl.spores+=tl.newspores
		tl.newspores=0
		checkeffects(tl)
	end)
	calclight()
	
	for ent in all(ents) do
		if ent.burnlight and 
		   ent.tl.light>=2 and
		   not ent.statuses.BURN
		then
			burn(ent)
			sfx"36"
		end
	end
end

function findfree(pos,var)
 calcdist(pos,"free")
 local bestd,bestpos=-100
 alltiles(
 function(npos,ntl)
  local d=ntl.free+rnd()
 	if navigable(ntl) and
 	   not ntl[var] and
 	   d>bestd then
 		bestd,bestpos=
 		d,npos
 	end
 end)
 return bestpos
end

function updatemap()
	calclight()
	calcdist(player.pos,"pdist",true)
	calcvis(player.pos)
end
-->8
--utility
--[[
function checkinput()
	input=bufferedinput
	bufferedbtns=nil
end

function getbtnp(b)
	if bufferedbtns & (1<<b) != 0 then
		bufferedbtns=nil--eat the input
		return true
	end
end
]]
function screenpos(pos)
	return vec2(pos.x*12,
							 				 pos.y*8+pos.x*4) 
end

function entscreenpos(ent)
	return screenpos(ent.pos)+
	        vec2(-2.5,-6.5)
end

function usplit(str)
	return unpack(split(str))
end

function round(x)
 local rnded=flr(x+0.5)
	return rnded,x-rnded
end

--adapted from redblobgames.com/grids/hexagons
function hexdist(p1,p2)
	delta=p1-p2
	return (abs(delta.x)+abs(delta.y)+abs(p1.x+p1.y-p2.x-p2.y))/2
end

function hexline(p1,p2,range,pass,block,cont)
	p2=hexnearest(p2)
	ln={}
	local dist,tl=hexdist(p1,p2)
	for i=1,min(cont and 20 or dist,range) do
	 local pos=hexnearest(
							lerp(p1,p2,i/dist))
	 local tl=gettile(pos)
	 if not tl or
	    not navigable(tl,true) or
	    (tl.ent and block) then
	  break
	 end
		add(ln,pos)
		if tl.ent and not pass then
		 break
		end
	end
	return ln
end

--adapted from observablehq.com/@jrus/hexround
function hexnearest(pos)
	local roundx,remx=round(pos.x)
 local roundy,remy=round(pos.y)
 return abs(remx) > abs(remy) and
 	vec2(roundx+round(remx+remy/2),roundy) or
 	vec2(roundx,roundy+round(remy+remx/2))
end

function hexdir(p1,p2)
 local dist=hexdist(p1,p2)
	return hexnearest(
	        lerp(p1,p2,1/dist))-p1
end

function vec2s(str)
	return vec2(usplit(str))
end

function vec2list(str)
	local ret={}
	for vec in all(split(str,"|")) do
		add(ret,vec2s(vec))
	end
	return ret
end

function assigntable(str,table,delim1,delim2)
 table = table or {}
 for var in 
		all(split(str,delim1 or ","))
	do
		local k,v=unpack(split(var,delim2 or ":"))
		table[k]=v=="{}"and {} or v
	end
	return table
end

function rndint(maxval)
	return flr(rnd(maxval))
end

function rndp(p)
	return rnd()<(p or 0.5)
end

function lerp(a,b,t)
	return a and (1-t)*a+t*b or b
end

--vec2 by mrh & felice 
vec2mt={
 __add=function(v1,v2)
  return vec2(v1.x+v2.x,v1.y+v2.y)
 end,
 __sub=function(v1,v2)
  return -v2+v1
 end,
 __unm=function(self)
  return vec2(-self.x,-self.y)
 end,
 __mul=function(s,v)
  return vec2(s*v.x,s*v.y)
 end,
 __eq=function(v1,v2)
  return v1.x==v2.x and v1.y==v2.y
 end
}
vec2mt.__index=vec2mt
function vec2(x,y)
 return setmetatable({x=x,y=y},vec2mt)
end

--local fillp by makke, felice & sparr
function localfillp(p, x, y)
 local p16, x = flr(p), band(x, 3)
 local f, p32 = flr(15 / 2 ^ x) * 0x1111, rotr(p16 + lshr(p16, 16), band(y, 3) * 4 + x)
 return p - p16 + flr(band(p32, f) + band(rotl(p32, 4), 0xffff - f))
end
-->8
--entities

function checkidle(ent)
	if ent.idleanim then
	 ent.setanim(ent.idleanim)
	else
		ent.animframe,ent.animheight,ent.anim,ent.animclip=
		0,1
	end
end

function create(typ,pos,behav,group)
	local ent={typ=typ,pos=pos,
							behav=behav,group=group}
	assigntable("var:ent,xface:1,yface:-1,animframe:0,animt:1,animspeed:0.5,animheight:1,deathanim:death,atkanim:eatk,fallanim:fall,death:41,wpnfrms:0,statuses:{}",ent)
	assigntable(entdata[typ],ent)						

	ent.animoffset=vec2(0,ent.var=="ent"and 0or 2)
	
	
 ent.setanim=
 function (anim)
		ent.anim,ent.animt,ent.animloop=
		split(entdata[anim],""),0,false
			
		if ent.anim[1]=="w" then
			waitforanim=true
			ent.animwait=true
		end
	end

 ent.setbehav=function(behav)
		if ent.behav!=behav then
			if ent.behav=="sleep" then
			 checkidle(ent)
			end
			
			ent.behav=behav
			if behav=="hunt" then
				animtext("!",ent)
				sfx(ent.alert)
			elseif behav=="search"	then
				animtext("?",ent)
			end
			ent.canact=false 
		end
	end
	
	if ent.pos then
		setpos(ent,ent.pos,true)	
	end
	
	ent.truname=ent.ai and 
		rnd(split"jeffr,jenn,fluff,glarb,greeb,plort,rust,mell,grimb")..
		rnd(split"y,o,us,ox,erbee,elia")
	add(ents,ent)
	ent.maxhp=ent.hp
	if (ent.flippable or ent.ai)
	   and rndp() then
		ent.xface*=-1
	end
	if ent.ai and rndp() then
		ent.yface*=-1
	end
	checkidle(ent)
	if ent.behav=="sleep" then
		ent.setanim"sleep"
	end
	
	if ent.var=="item" then
		inititem(ent)
	end
	
	ent.stat=function(name)
	 local val=0
	 function checkslot(slot)
	  if ent[slot] then
				local s = ent[slot][name]
				if s then
					val=type(s)=="number" and val+s or s
				end
			end
	 end
		checkslot"wpn"
		checkslot"cloak"
		checkslot"amulet"
		
		return val!=0 and val or ent[name]
	end
	
	return ent
end

function checkfall(ent)
	if ent and ent.var=="ent" and
	   not ent.flying and
				ent.tl.typ==thole
	then
		sfx"24"
		ent.setanim(ent.fallanim)
		if (ent==player) calclight()
	end
end

function setpos(ent,pos,setrender)
	ent.pos=pos
	ent.tl=gettile(pos)
	ent.tl[ent.var]=ent
	if setrender then
		ent.renderpos=entscreenpos(ent)+ent.animoffset
	end
	checkfall(ent)
	if not ent.flying then
		flatten(ent.tl)
	end
end

function setstatus(ent,name,str)
	ent.statuses[name]=split(str)
end

function tickstatuses(ent)
 if (ent==player or ent.ai)
    and ent.tl.spores>0
 then
 	ent.hp=min(ent.hp+2, ent.maxhp)
 	if vistoplayer(ent.tl) then
 		animtext("+",ent)
 	end
 	if ent==player then
 		sfx(17,-1,6)
 	end
 end
	for k,v in next,ent.statuses do
		v[1]-=1
		if v[1]<=0 then
			ent.statuses[k]=nil
			if k=="TORCH" then
				ent.wpn.eXTINGUISH()
				log"tORCH BURNT OUT"
			end
		end
		if k=="BURN" then
		 hurt(ent,1)
		end
	end
end

function updateent(ent)
	function tickanim()
	 local anim,index,atkinfo=
	   ent.anim,flr(ent.animt),
	   ent.atkinfo
		local char=anim[index]
		
		if type(char)=="number" or
		   flr(ent.animt) > #anim then
			ent.animframe=char
			ent.animt+=ent.animspeed
			
			if flr(ent.animt)>#anim then
			 if ent.animloop then
			 	ent.animt=ent.animloop
			 else
			 	checkidle(ent)
					ent.animoffset=vec2s"0,0"
			 end
			end
		else
		 function case(c)
		 	return char==c
		 end
			ent.animflip=case"f"
			if case"l"then
			 ent.animloop=index+1
			 ent.animt+=rnd(#anim-index-1)
			elseif case"r" then
				ent.animwait=false
			elseif case"z" and
			 vistoplayer(ent.tl) 
			then
		 	animtext("z",ent,true)
			elseif case"_" then
				destroy(ent)
			 if ent==player then
					--next level
					depth+=1
					genmap(player.pos,player.tl.manmade)
				end
		 elseif case"m" then
				log("dEPTH "..depth)
			elseif case"v" then
			 ent.animt+=1
			 ent.animoffset.y+=anim[index+1]-4
			elseif case"c" then
				ent.animclip=ent.animoffset.y
			elseif case"e" then
			 fadetoblack=true
			elseif case"!" then
				ent.flash=true
			elseif case"b" then
				ent.pal=redpal
				ent.fillp=true
				animtext(".",ent,false,8,3,6)
			elseif case"a" then
				ent.animoffset=
				(ent.movratio or 0.25)*
					screenpos(
						atkinfo[2]-
						ent.pos)
				sfx"33"
			elseif case"d" then
				local b = atkinfo[1]
			 if atkinfo[3] then--hits
					hurt(b,atkinfo[4],ent)
				else 
					aggro(b.pos)
				end
			elseif case"s" then
				ent.renderpos=nil
			elseif case"h" then
			 local hp,maxhp=ent.hp,ent.maxhp
			 hurt(ent,(hp>maxhp/20) and 
			    min(maxhp/3,hp-1) or
			    hp)
			end
			ent.animt+=1
			tickanim()
		end
		
		if ent.animclip then
			ent.animheight=1-(ent.animoffset.y-ent.animclip)/8
		end
	end
	
	if ent.anim then
		tickanim()
	end
	if ent.animwait then
		waitforanim=true
	end
	
	if ent.pos then
		ent.renderpos=
			 lerp(ent.renderpos,
			      entscreenpos(ent)+
			      ent.animoffset,
			      0.5)					
	end
end

function canmove(ent,pos,special)
	local tl=gettile(pos)
	return
	 (tl.ent and
	  special != "noatk" and not
	  (ent.ai and tl.ent.ai) and
	  (not tl.ent.blocking or
	   ent.behav=="hunt" or
	   ent==player))
	 or
	 (not tl.ent and
	  special != "atkonly" and
	  navigable(tl,ent.flying))
end

function seesplayer(ent)
	return ent.tl.vis and
	       (ent.tl.pdist>=-1 or
				    player.tl.light>=2 or
				    ent.darksight)				 
end

function findmove(ent,var,goal,special)
	local tl = ent.tl
	local bestscore=-2
	visitadjrnd(ent.pos,
	function(npos,ntl)
		if canmove(ent,npos,special) and
		   ntl.fire==0
		then
		 local score=
		 							(abs(tl[var]-goal))-
		 							(abs(ntl[var]-goal))
		 if ntl.ent and 
		 	ntl.ent.blocking then
		 	score-=ent.flying and 10 or 1
		 end
		 if ent.stat"burnlight" and 
		    tl.light>-1 and 
		    tl.pdist<-1 then
		 	score-=3*(ntl.light-tl.light)
		 end
			if score>bestscore then
				bestscore=score
				bestpos=npos
			end
		end
 end)
 if bestscore>-2 then
		if special=="aggro" and
		   gettile(bestpos).pdist==0
		then
			aggro(ent.pos)
		else
			return move(ent,bestpos)
 	end
 end
end

function taketurn(ent,pos,tl,group)
	if ent==player then
		--player
		poke(0x5f5c,9)--key repeat
		poke(0x5f5d,6)
		
		playerdst,aimitem=
		ent.pos+adj[playerdir]
		if skipturn then
		 skipturn=false
		 return true
		end
		
		if btnp"5" then
		 dialog(inv)
		 return
		end
		
		if btnp"4" then
			tock=not tock
			sfx(40,-1,not tock and 16 or 0, 8)
			return true --wait 1 turn
		end
		
		function turn(btnid,i)
		 if btnp(btnid) then
				playerdir=(playerdir+i+5)%6+1
				ent.setanim"turn"
			end
		end
		
		turn(⬅️,-1)
		turn(➡️,1)
		turn(⬇️,3)
		updatefacing(ent,adj[playerdir])	
		
		local dsttile=gettile(playerdst)
		if dsttile.typ!=tywall or
		   playerdst.x<=ent.pos.x
		then
			dsttile.hilight=2
		end
		if btnp"2" then
		 dsttile.hilight=0
		 if canmove(ent,playerdst) then
				move(ent,playerdst,true)
								
				if player.tl==dsttile then
					if dsttile.item then
						pickup(dsttile.item)
					end
				end
				return true
			elseif dsttile.typ==thole then
				dialog(confirmjump)
			end
		end
		return
	elseif ent.ai and ent.canact and
	 ent.behav!="dead"
	then
	 --ai
	 function checkseesplayer()
	 	if seesplayer(ent) then
			 pseen=true
			 lastpseenpos=player.pos
			end
	 end
	 if ent.behav=="hunt" then
		 if ent.pack then
		 	ent.pdist=rndp() and 0 or -2
		 elseif ent.runaway then
		 	ent.pdist=ent.tl.pdist>=-1 and
		 													0 or -15		
		 end
		 checkseesplayer()
		 findmove(ent,"pdist",ent.pdist,ent.movandatk and "noatk")
			checkseesplayer()
			if ent.movandatk then
				findmove(ent,"pdist",0,"atkonly")
			end
		else
			--notice player
			function checkaggro(p)
				if seesplayer(ent)
				   and rndp(p)
				   and onscreenpos(ent.pos,62)
				then
				 aggro(pos)
				 return true
				end
			end
			checkaggro(behav=="search"
			           and 1.0 or 0.29)
			if ent.behav=="wander" then
				if not wanderdsts[group]
				   or ent.pos==wanderdsts[group]
				   or rndp(0.025)
				then
					repeat
						wanderdsts[group]=rndpos()
						local tl = gettile(
													wanderdsts[group])
					until navigable(tl) and
											tl.pdist>-1000
					calcdist(wanderdsts[group],
														group)
				end
				findmove(ent,group,0,"aggro")
				checkaggro(0.29)
			elseif ent.behav=="search" 
			then
				local goal=ent.pack and 0 or ent.pdist
				findmove(ent,"search",goal,"aggro")
				if not checkaggro(1.0) and
					  ent.tl.search == goal
			 then
					ent.setbehav"wander"
				end
			end
		end
	end
	return true
end

function postturn(ent)
 if ent.ai then
		if ent.behav=="hunt" and not
		   pseen then
			ent.setbehav"search"
			setsearchpos(lastpseenpos)
		end
  ent.canact=true
	end
end

function setsearchpos(pos)
	if (searchpos==pos)return
 lastpseenpos=pos
	calcdist(pos,"search")
	searchpos=lastpseenpos
end

function aggro(pos)
	setsearchpos(player.pos)
	calcdist(pos,"aggro",true)
	for i,ent in ipairs(ents) do
		if ent.ai and
		   ent.behav!="dead" and
					ent.tl.aggro>=-3
		then
			if seesplayer(ent) then
				ent.setbehav"hunt"
				pseen=true
			elseif ent.behav!="hunt"
			then
				ent.setbehav"search"
			end
		end
	end
end

function destroy(ent)
	del(ents,ent)
	ent.tl[ent.var]=nil
end

function hurt(ent,dmg,atkr)
	ent.hp-=dmg
 ent.flash=true
	if ent==player then
		shake=1
	end
	if ent.hp<=0 then
	 sfx(ent.death or 41)
		ent.setbehav"dead"
		ent.setanim(ent.deathanim)
		waitforanim=true
		if ent==player then
			setmode"gameover"
			poke(0x5f40,31)
			calclight()
		elseif ent.sporeburst then
			sporeburst(ent.tl,ent.sporeburst)
		end
	else
		sfx"34"
		if ent.hurtsplit and atkr then
			local splitpos=findfree(ent.pos,"ent")
			if splitpos then
				ent.hp/=2
				local newent=create(ent.typ,splitpos,ent.behav,ent.group)
			 for k,v in next,ent.statuses do
			 	newent.statuses[k]={unpack(v)}
			 end
			 newent.renderpos,newent.hp=
			 ent.renderpos,ent.hp
				newent.setanim"esplit"
			end
		end
	end
	if ent.hurt then
		sfx(ent.hurt)	
	end
	if ent.hitfire then
		local firepos=ent.pos
		if atkr then
			local dirpos=firepos+
			 hexdir(atkr.pos,ent.pos)
			local ntl=gettile(dirpos)
			if navigable(ntl) then
				firepos=dirpos
			end
		end
		sfx"36"
		ent.light=nil
		setfire(gettile(firepos))
	end
	aggro(ent.pos)
end

function burn(ent)
	setstatus(ent,"BURN","6,6,8,9")
end

function hitp(a,b)
	if b.armor then
	 local diff=a.stat"atk"-b.stat"armor"
	 return (max(diff)+1)/
	        (abs(diff)+2)
	end
	return 1
end

function interact(a,b)
 local hit = rndp(hitp(a,b))
 a.setanim(a.atkanim)
 waitforanim=true
 a.atkinfo={b,b.pos,hit,a.stat"dmg"}
end

function move(ent,dst,playsfx)
	local dir=hexdir(ent.pos,dst)
	local dsttile=gettile(dst)
	ent.lasttl=ent.tl
	
	if dsttile.ent then
		interact(ent,dsttile.ent,
		         ent.wpn or ent)
	else
		ent.tl.ent=nil
		if ent.moveanim then
			ent.setanim(ent.moveanim)
		end
		
		if playsfx then
		 local snd=tlsfx[dsttile.typ]
	  sfx(snd or 35)
	  if snd==43 then
				--bonez
				aggro(playerdst)	
		 end
		end
	 
	 setpos(ent,dst)
	end

	updatefacing(ent,dir)
end

function updatefacing(ent,dir)
	if dir.x!=0 then 
		ent.xface=sgn(dir.x)
 end
 if dir.y!=0 then
 	ent.yface=sgn(dir.y)
 elseif x!=0 then
  ent.yface=sgn(dir.x)
 end
end
-->8
--level generation

function genmap(startpos,manmade)
	genpos=startpos
	cave=not manmade
	
	world,ents,validtiles,inboundposes,tileinbounds=
	{},{},{},{},{},{}

	for y=0,20 do
	 world[y],tileinbounds[y]=
	 {},{}
	 local startx,endx=
	 max(10-y),min(30-y,20)
	 for x=startx,endx do
	  local pos=vec2(x,y)
	  local tl = tile(tempty,pos)
	  world[y][x]=tl
	  add(validtiles,tl)
	  if y>0 and y<20 and 
	     x>startx and x<endx then
				add(inboundposes,pos)
				tileinbounds[y][x]=tl
			end
	 end
	end
	
	entropy=1.5
	if manmade then
		genroom(startpos)
	else
		gencave(startpos)
	end
	postproc()
	setupdrawcalls()
end

function genroom(pos)
	local roomextrasize=
		rndint(roomsizevar)
	local roomextraw=
		rndint(roomextrasize+1)
	local w,h=minroomw
											+roomextraw,
											minroomh
											+roomextrasize
											-roomextraw
		 
	h=(h\4+1)*4
	w+=w%2
	local yoffset=ceil(rnd(h-1))-2
	local minpos=pos+
														vec2(-ceil(rnd(w-3)+1)
																			+ceil(yoffset/2),
																			-yoffset)
	minpos.x+=(minpos.x-genpos.x)%2
	minpos.y-=(minpos.y+2-genpos.y)%4
	
	function doroom(test)
		local offset,openplan=
		minpos-pos,rndp()
		for y=0,h do
		 local alt=(pos.y+offset.y+genpos.y+y)%2
			offset.x-=alt
			local xwall=y==0 or y==h
			for x=0,w do
				local ywall=x==0 or	x==w
				local npos=pos+offset+vec2(x,y)
				local tl=inbounds(npos)
				if test then
				 if not tl or
				   (cave and npos==genpos)
				 then
				 	return true
				 end
				elseif tl then
					if tl.ent then
					 destroy(tl.ent)
					end
					
					if (xwall or ywall) and
							 not (tl.typ==tdunjfloor 
							 					and openplan) 
					then
					 if rndp(crumble) and
					    alt!=1 and not
					    (xwall and ywall) then				   
						 tl.typ=tdunjfloor --needs manmade flag
							gentile(txwall,npos)
							if not tl.ent then
								tl.genned=false
								--still want eg. grass
								--to spread here
							end
						else
							settile(tl,
								xwall and txwall or tywall)
						end
					else
						settile(tl,tdunjfloor)
					end
					tl.manmade=true
				end
			end
	 end
	end
	
	if entropy<1.5 and doroom(true) then
		return genroom(rndpos())
	end
		
	entropy-=0.15+rnd(0.1)
	local crumble = rnd(0.25)
	if entropy>=0 then
		doroom()
		if rndp(0.15) then
			gencave(rndpos())				 
		end
		genroom(rndpos())	
	end
end

function gencave(pos)
	local tl = inbounds(pos)
	if(tl.typ==tempty)tl.typ=tcavefloor
	
	entropy -= 0.013
	if tl then
		visitadjrnd(pos,
		function(npos,ntl)
			if not genable(ntl) then
				if inbounds(npos) and 
							rndp(entropy) then
					gentile(tl.typ,npos)
					if genable(ntl) then
						if rndp(0.01) then
							genroom(rndpos())
						end
					 gencave(npos)
					end
				end
			end
		end)
	end
end

function gentile(typ,pos)
	local y,tl = 
	ceil(rnd(15)),gettile(pos)
	if (manmade(tl)) y+=16
	settile(tl,mget(typ,y))
	local typ2=mget(typ+1,y)
	tl.flip,tl.genned=
	rndp(),true
 if typ2!=0 then
  if typ2<64 then
 		tl.bg=typ2
	 else
 		create(typ2,pos)
 	end
 end									
end

function postgen(pos,tl,prevtl)
	tl.postgenned=true
	visitadjrnd(pos,
	function(npos,ntl)
		if genable(ntl) and not
					ntl.postgenned then
			if not ntl.genned then
				gentile(tl.typ,npos)
			end
			postgen(npos,ntl,genable(tl) and tl or prevtl)
		end
	end)
end

function notblocking(pos)
	function navat(i)
		return navigable(getadjtl(pos,i))
	end
	local lastnav,numnavreg=
	navat(6),0
	for i=1,6 do
		local nav = navat(i)
		if nav and not lastnav then
			numnavreg+=1
		end
		lastnav=nav
	end
	
	return numnavreg<2
end

function postproc()
	function connectareas(permissive)
		for i=1,20 do
			--what a mess
		 calcdist(genpos,"pdist")
		 
			local unreach,numtls=
			{},0
			alltiles(
			function(pos,tl)
				if navigable(tl) and
							tl.pdist==-1000 and
							((permissive or
							  not manmade(tl)) or
								pos.y%2==1)
				then
					add(unreach,pos)
				end
			end)
			
			if (#unreach==0)	return
				
			local bestdist=100
			
			for j=1,200 do
				if #unreach==0 then
					return
				end
				local p1=rnd(unreach)
				local diri=
		   manmade(gettile(p1)) and
		   not permissive and 
		   rnd(split"1,2,4,5") or
		   rndint(6)+1
				local dir=adj[diri]
				local p2=p1+rndint(18)*dir
				local tl2=gettile(p2)
				if tl2 then
					if navigable(tl2) and
								genable(tl2) and
								tl2.pdist>-1000 then
						d=hexdist(p1,p2)
						if d<bestdist then
							bestdist,bestp1,
							bestdir,bestdiri=
							d,p1,dir,diri
						end
					end
				end
			end
			
			if bestdist<100 then
				repeat
					bestp1+=bestdir
					local tl=gettile(bestp1)
					local nav=navigable(tl)
					if not nav then
					 if manmade(tl) then
					 	tl.typ=tdunjfloor
					 elseif tl.typ == thole then
					 	if bestdiri%3==2 then
					 		tl.typ=tybridge
					 	else
					 		tl.typ=txbridge
					 		tl.flip=bestdiri%3==1
					 	end
					 	tl.bg=thole
					 else
					 	tl.typ=tcavefloor
						end
					end
				until nav and 
										tl.pdist>-1000
			end
		end
	end

 connectareas()
	
	--delete bridges lol
	alltiles(
	function(pos,tl)
		if tileflag(tl,12) then
			settile(tl,thole)
		end			
	end)
	
	--fill out manmade area tiles
	postgen(genpos, 
									gettile(genpos),
									gettile(genpos))
	
	connectareas()
	
	--replace single cavewalls
	alltiles(
	function(pos,tl)
		if tl.typ==tempty and 
					inbounds(pos) then
			if genable(
							getadjtl(pos,2)) and
				  genable(
							getadjtl(pos,5)) then
				gentile(tcavewall,pos)
			end
		end
	end)
	
	connectareas(true)
	local numholes=0
	
	alltiles(
	function(pos,tl)
		local uptl,uprighttl,righttl=
				getadjtl(pos,2),getadjtl(pos,3),getadjtl(pos,4)
		if tl.typ==tempty then
			--add cavewalls
			for i = 1,6 do
				ntl = getadjtl(pos,i)
				if ntl and 
							tileflag(ntl,5) then--drawnormal
					 tl.typ=tcavewall
				end
			end
		elseif tl.typ==txwall then
			--swap x walls for y
			if uptl and righttl and
			 uprighttl and
				uptl.typ==tywall and
				genable(uprighttl) and
				genable(righttl) 
			then
				tl.typ=tywall
			end
		elseif tl.typ==tywall and
		  righttl.typ==txwall
		then
			tl.typ=txwall
		elseif tl.typ==thole and
									tl.pdist>-1000 then
			numholes+=1
		end
	end)
	
	function checkspawn(pos,mindist,nolight)
		local tl=gettile(pos)
		return navigable(tl) and
		 tl.pdist < mindist and
			tl.pdist > -1000 and
			notblocking(pos) and
			not tl.ent and
			(not nolight or tl.light<=0)
	end
	
	--create exit hole if needed
	--attempts=0
	if numholes==0 then
		local bestdist=0
		local tilesfound=0
		while tilesfound<10 do
		 --[[attempts+=1
		 if attempts>20000 then
		  sfx(28)
		  goto abort
		 end]]
		 local tl=gettile(rndpos())
		 if checkspawn(tl.pos,0) then
		 	if tl.pdist<bestdist then
		 	 bestdist=tl.pdist
		 	 besttl=tl
		 	end
		 	tilesfound+=1
		 end
		end
	 settile(besttl,thole)
	end
	--::abort::
	if not player then
		player=create(64,genpos)
	else
	 player.tl=gettile(genpos)
  player.tl.ent,player.animheight,player.animclip,fadetoblack
  =player,1
  add(ents,player)
	end
	updatemap()
	
	if depth>0 then
		player.animoffset.y=-21
	 player.setanim"fallin"
	 
		--spawn entities										
		wanderdsts={}
		
		for n=1,6 do
			local spawnpos=rndpos()
			local spawndepth=depth
			while rndp(0.45) do
			 spawndepth+=1
			end
			local spawn,behav,spawnedany
			=rnd(spawns[min(ceil(spawndepth/2),10)]),
			rnd{"sleep","wander"}
			for i,typ in ipairs(spawn) do
				local found=false
				visitadjrnd(spawnpos,
				function(npos)
					if not found and
				 	checkspawn(npos,-4,typ==72)
				 then
						found=true
						create(typ,npos,behav,i)
						spawnpos=npos
					end
				end)
			end
			local itempos=rndpos()
			if checkspawn(itempos,-3) then
				create(rnd(items),itempos)
			end
		end
	end
end
-->8
--items

--[[

orbs[green,orange,purple,pink,cyan,yellow,red,silver:
power,life,data,gravity,
light,fire,ice,teleport

cloaks[navy,cyan,gold,red]:
protection,darksight,
recharging,vampirism

amulets[gold,silver,pewter,bronze]:
defense,darksight,
wisdom,pacifism

staffs[oaken,driftwood,ebony,purpleheart]:
fire,lightning,ice,blinking
]]

function inititem(item)
item.setanim"flash"
item.eQUIP=function(nosnd)
	if player[item.slot] then
		player[item.slot].sTOW()
	end
	player[item.slot]=item
	item.equipped=true
	if item.lit then
		setstatus(player,"TORCH","160,160,2,9")
	end
end

item.sTOW=function(staylit)
	if item.equipped then
		item.equipped=nil
		if item.lit then
		 if staylit then
				player.statuses.TORCH=nil
		 else
		 	item.eXTINGUISH()
			end
		end
		player[item.slot]=nil
	end
end

item.tHROW=function()
 aim{item,{item.throw},"throw",12}
end

--[[item.dROP=function()
	local pos = findfree(player.pos,"item",100)
	if pos then	
	 sfx(25)
		item.sTOW()
		setpos(item,pos,true)
		del(inventory,item)
	else
		log"nO ROOM"
	end
end]]

item.eXTINGUISH=function()
	item.throwln,item.lit,item.light,
	player.statuses.TORCH=0.125
	item.typ+=1
end
end

function pickup(item)
	addtoinventory(item)
	item.tl.item=nil
	log("+"..item.n)
	sfx"25"
end

function addtoinventory(item)
 return add(inventory,item)
end
-->8
--ranged attacks

function aim(params)
	aimparams,aimpos=params,playerdst
	setmode"aim"
end

function updateaim(item,lineparams,atktype,fx)
 aimitem=item
 local ppos=player.pos
 aimscrpos=
  screenpos(aimpos)+1.5*
  vec2(1.5*(tonum(btn"1")
           -tonum(btn"0")),
       tonum(btn"3")
      -tonum(btn"2"))
	
 aimscrpos.x=mid(campos.x,aimscrpos.x,campos.x+127)
	aimscrpos.y=mid(campos.y,aimscrpos.y,campos.y+127)
	aimpos=vec2(aimscrpos.x/12,
	            aimscrpos.y/8-aimscrpos.x/24)
 
 local aimline=hexline(ppos,aimpos,unpack(lineparams))
	for pos in all(aimline) do
	 gettile(pos).hilight=2
	end
	local dir = hexdir(ppos,aimpos)
	for i=1,6 do
		if adj[i]==dir then
			playerdir=i
		end
	end
	updatefacing(player,aimpos-ppos)
	item.xface=player.xface
	if #aimline>0 and btn"5" and
	   statet>0.2 then
		setmode"play"
		sfx(fx)
		if atktype=="throw" then
			item.sTOW(true)
			del(inventory,item)
			aimitem=nil
		end
		player.setanim"throw"
		add(rangedatks,{0,player.pos,aimline,item,atktype})
	elseif btnp"4" then
	 skipturn=false
	 setmode"play"
	end
end

function rangedatk(i,origin,ln,item,atktype)
	function atkis(str)
	 return atktype==str
	end
	
	local dst=ln[#ln]
	local dsttl=gettile(dst)
	local spd=atkis"throw" and item.throw/12 or 1
	
 if (i*spd>=#ln) then
  if atkis"throw" then
		 if dsttl.typ==thole then
		 	sfx"24"
		 elseif item.lit then
		 	setfire(dsttl)
		 	sfx"36"
		 else
		  --todo:orb effects
		  --todo:damage
		  --todo:deposit on ground
		 	local free=findfree(dst,"item")
		 	if free then
		 		setpos(item,free,true)
		 	end
		 end
		end
		return true
	end
	
	local tl = gettile(ln[flr(i*spd)+1])
 
	if atkis"throw" then
		flatten(tl)
		initpal(tl)
		
		function getpos(i,offs)
			local t,airtime=
			spd*i/#ln, #ln/spd
			local arcy,pos=
			(t*t-t)*airtime*airtime/4,
			lerp(origin,ln[#ln],t)
			local scrpos=screenpos(pos)+offs
			return scrpos.x,scrpos.y+arcy,1,1,item.xface<0
		end
		
		if item.throwln then
			local x1,y1=getpos(i-1,vec2s"0,-2")
		 local x2,y2=getpos(i,vec2s"0,-2")
		 tline(x2,y2,x1,y1,18,item.throwln)
		else
			spr(item.typ,getpos(i,vec2s"-3,-6"))
		end
	end
end
__gfx__
fffffffffffffffffffffff000ffffffffff000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffff0100000fffffffff0000000ffffff0000000fffffffffffffffffffffffff155111551ffffffffffffffffffffffffffffffffffffffffffffffffffff
000ff00100011fff00fff0000000000fff00000000000fffffffffffffffffffff5fffffffff5fffffffffffffffffffffffffffffffffffffffffffffffffff
0010110150015f0000ff0000000000dff000000000000000ffffffff0ffffffff1fffffffffff1ffffffffffffffffffffffffffffffffffffffffffffffffff
001105015010500000f0000000000ddf000000000000000dfffffff00fffffff5fffffffffffff5ffffff055d5fffffffffffffffffffffffffff0055dffffff
001d0501101000100000000000001d1f555000000000001dfffffff0d0fffffff1fffffffffff1ffffff0511515ffffffffff000ffffffffffff055511dfffff
011d01011010101000550000000d11df1550550000000d11fffffff0d00fffffff5fffffffff5ffffff01055000dffffffff0555000fffffffff05115510ffff
0d010100000010000055505000dd11df000055505000dd11ffffff005d0f0ffffff155111551ffffffff0511511dfffffff051515550ffffffff01501115d0ff
0d0100000f0000000000505551d1d11f505000505550d1d1ffff00011d00d0ffffffffffffffffffffff050151d1ffffff05050151d5ffffffff01550101d0ff
0d10ffff0ffff00100500005511dd1df5055500005501dd1fff000011501d0fffff2dd222dd2ffffffff01011010ffffff5552050d510ffffffff0155d150fff
0110050fffffff0000505550011d1ddf0005505550001d1dff0500001101d00fffdfffffffffdfffffff01115d10f1ffff505555d151010ffffff0015500f1ff
010ffffffffff0f0000015505d111d0f555000155055111dff01100115001d00f2fffffffffff2ffffff01511550111ff050512151511110ffff00100100111f
0001fffffffffff1005500005d1d100f1550550000551d100111010111001150dfffffffffffffdffff05000000dffff0020505051550000fff05000000dffff
00001ffff00f50100055505001dd00fffff055505000dd00f011010110d01010f2fffffffffff2fffff105505550110ff051505050511100fff105505550110f
ff0000110000110000f0505551d00fffffff00505550d00fff0011010050100fffdfffffffffdfffff0011000001100fff555151d501100fff0011000001100f
fff0000000000000ffff00055100fffffffffff0055000fffff01111101110fffff2dd222dd2fffffff00110111000fffff00555511000fffff00110111000ff
ffffffffffffffffffffff0000fffffffffffffff000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff042222242fffffffffffffffffff
fffffffffffffffffffffffffffffffffffff0bbb00fffffffff3ffffffb3f33fff000110111ffffffffffffffffffffffff150000050ffffff000550111ffff
fffffffffffffffffffffffffffffffffff10bbbbbbbf1fff33ff3fff0b0f3ffff011d005111f10fffffffffffffffffffff005222202fffff0111000111f10f
fffffffffffffffffffff00ffff0ffffff10b11bbbbd111ffff3ff3f33ff3ffff01150dd1d5015d0ffffffffffff3fffffff050000050ffff011110110001110
1ffffffffffffffffffffff5f05f0ffffff055511b5dffffffff3f3fff3fbfff00005550050d0000fffffffffff3ffffffff042222240fff0000001111050001
fffffffffff1fffffff05ff05f00fffff01055155d501100fffffbfbffb00ffff011000050050100fffff3fffff3ffffffff021000100ffff001000010111100
fffff1ffffffffffffffff0fffffffffff0000155d01100fffff0b0bfbffffffff0011510050500fffffff3ffff3ffffffff042222242fffff0011110001100f
fffffffffffffffffffffffffffffffffff00100001000fffffffffbfffffffffff00150110005fffff3ff3f3ff3f3ffffff050000020ffffff00110111000ff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffff3ffffffffff666666666fffffff3f3f3f3ff3ffffffffffff505ffffffffff5ffffffff
fff000110111fffffff01111111110fffff01111111110fffffffffffbfffffffff6dddd6dddd6ffffff3f3ff3bf3ffffffffff5502202ffffff5055d11000ff
ff0111000111f10fff0111111111110fff0111111111110ffffffffffff3ffffff6dddd6dddddd6fffff3f3ff3b03fffffff05502202202fffff1000000055ff
f011110110001110f011100111111110f011111111111110fffff3fffffbfffff6dddd6dddddd6d6ffff3ff3f3ffbffff505202202205504fff15500d00555ff
000000111101000001111111111111110101111111111111fffff3ff3fffffff6dddd6ddd6dd6dddfffff3f3fbffbfff022022022055044fff00555dd00500f1
f011000010111100f011111110011110f011111111100110fffffbf3fffffffffddddddd6dddddddfffffbf3fbff00fff02202505404fffff051005d10d11100
ff0011110001100fff0111111111110fff0111111111100ffffffffbffffffffffddddd6dddddddfffff0b0bffffffffff055044ffffffffff001111055d100f
fff00110111000fffff01111111110fffff01111111110fffffffffffffffffffffddd6dddddddfffffffffbfffffffffff44ffffffffffffff00510111000ff
fff67ffffffffffffffffffffffffffffff11fffff999fffffffffffffffffffff11f1ffffffffffffffffffff8888fffff7fffffffcfcffffffffffffffffff
fff62ffffffffffffff22fffffffffffff1001ff333333fffffffffffffffffff100101ffffffffffffcfffff828228fffc77fffffffcfcfffffffffffffffff
ff888ffffff3f3fffff223fffff3f3ffff1003ffb3333344ffffffffffff4f4f10000001ffffffffffc7cfff2f88fff2fcc777ffffffcdcfffffff8f9989ffff
ff88dfffffbbb3f6ff22234fff44439ff100038fb3333b42ffffffffffff444f05000550fffeeeffffc7cffff8288228ffdccfffffffdddffffff88988888fff
ff88d6ffffbbbf6fff222f4fff4445f9f100014f4bbbb92ffff4f4ffff44422f11101111ffe227effccdccfff8f28288ffdccfffcffccdff889f8598855588ff
ff882fffffbbb3ffff22234fff222366f100034ffbbbb4ffffff55fff44422fffff1ffffffe222effffcfffff2f28f2ffffcfffffccdddffff899988888f8fff
ff2f2fffff444fffff222f4fffddd99ff10001fff2222fffff5555ff442402ffffffffffffe20eeffffffffff288822ffffdfffff22dfdffff2888882086ffff
ffd0dfffff202fffff222fffffd0dffff10001fff2002ffffe544ffff202fffffffffffffe2222efffffffff2828882ffffffffffdfdfffffff262226fffffff
fff67ffffffffffffffffffffffffffffff11fffff997fffffffffffffffffffff11f1ffffffffffffffffffff88d8fffff7fffffffcfcffffffffffffffffff
fff22ffffffffffffff22fffffffffffff1001ff333993fffffffffffffffffff100101ffffffffffffcfffff822828fffc77fffffffcfcfffffffffffffffff
ff882ffffff3f3fffff323fffff3f3ffff13031f99333bffffffffffffffffff10500001ffffffffffc7cfff2f88fffefcc777ffffffcfcfffffff8fffffffff
ff8d9fffffb333ffff2333ffff4333fff103331f99b33b44ffffffff4fffffff05580850fffeeeffffc7cffff8288228ffdccfffcfff6c6f889ff888f99fffff
ff86dfffffbbbff6ff222f4fff44299ff1000181499bbf42ffffffff24424f4f11101111ffe227effccdccfffef28282ffdccffffccfdcffff898558888a8fff
ff826fffffbbbf6fff222f4fff2445f9f1000141f449942ffef4f4fff422444ffff1ffffffe222effffcfffff2f28f2ffffcfffffddcddffff289855588888ff
ff2f2fffff44b3ffff22234fffdd4366f1000341f2244fffff5555fff204240fffffffffffe20eeffffffffff288822ffffdfffffdfd22fffff228888822ffff
ffd0dfffff202fffff222f4fffd0d99ff100011ff2002fffff0555fffff202fffffffffffe2222efffffffff2882822ffffffffffffdfdfffffff22226006fff
ffffffffffffffffffffc4cfffffffffff11ff8fffffff6fffffffffff6fff6f11ffff11ffffffffffcccffffffffffffff7ffffffffffffffff8fff98ffffff
fff67fffffffffffff2ec4cffffffffff1051878fffffff6fffffffffff64f460011f100ffffffffffffccfff628ff28ffc77efffffffffffff888f9888fffff
fff88fffff7666ffff223c4cfff3f3fff1003184ffff9996f6ff6ffffff6444650001005fffffffffffffccfff6f8868ecc777eeff2c7c7fff85588982ff88ff
ff8886fff763f36fff22223cff4443fff1000531ff333336ff4f46fff4f4442615000051fffffffffffcfccfff628286ffdccffffff2c7c7ffff65888888858f
ff88dffff3bbb3f6ff222ec4f4444f9ff100001ff33333b6ff6556ffff444226f100051ffffffffffffcc77cff688286ffdccfffcf2cddd7ffff6f8988855fff
f8822fffffbbbfffff22efc4ff224f9ff10001fff333bb94ff5555fff4244f2fff1011ffffeeeeefffcd7ccff2882f86fffcfffffccdd2dfff89ff89882f6fff
ff2f2fffff444fffff22effcffddd9fff10001fff2222942ff544fffffff4ffffff1fffffe22227efffccfff28882288fffdffffd2dfdffffff8999882ff6fff
fd00dffff4004fffff222fffffd0dffff10001ff200002fffe5fffffff00ffffffffffffe222002efffcffff8888822effffffffffffffffffff88888066ffff
fffffffffffffffffffffcffffffffffff11ff8fffffffffffffffffffffffff11ffff11ffffffffffffcffffffffffffff7ffffffffffffffff8fff9a8fffff
fff67fffffffffffff2ec4cffffffffff1051878ffffff6fffffffffffffffff0011f100fffffffffffffcffff28ff28ffc7effffffffffffff888f98888ffff
fff22fffffffffffff3234cffff3f3fff1303141ffff9996ffffffffffffff6f50001005fffffffffffffccfffff88d8eeee7eeeff2d7c7fff85588982fff8ff
ff822ffffff3f36fffbb3c4cff4333fff1bb3141ff333976ffffffff4f624f4615000051ffffffffffccfccff8682262ffdcefffcff2c7c7ff8ff6588888858f
ff6d9fffffb333f6ff222e3cff44499ff1000531f3333336ff64f6fff4464446f158081ffffffffffcdccccffff68226ffdccffffccdc7c7fffff69888556f8f
f86226ffffbbbff6ff222ec4f4425ff9f100001ff94bbb66fef6556f42462406ff1011ffffeeeeeffcc7ccfff2862f26fffcffffddd26c6fff896f98882f6fff
ff6f2fffff44bf66ff22efc4ff435ff9f10001fff9924446ff56556fff262f26fff1fffffe22227efffc7cff28862226fffdfffffffd2cfffff8998888f6ffff
fd00dffff4002377ff222fffffd0d99ff10001ff29444426ff55ff5ffff4fff4ffffffffe222002effffcfff888e822effffffffffdfdfffffff8868286fffff
fff67ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fff62fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff99ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff888fffffffff3fffffffffffffffffffffffffffffffffffffffffffffffffff899ffffffffffffffffffffffffffffff40ffffff50ffffff94ffffff65fff
ff88d6fffffff44ffffafffffffffffffffff7fffffffffffffff4ffffff97ffff998ffffffccffffff8fffffffffcffff4ff4ffff5ff5ffff9ff9ffff6ff6ff
ff88dffffff4400ffff9fffffff5ffffffffdfffffff7fffffff5d6fffff997fff544fffffccc7ffff8ffffffffffffffff49ffffff56ffffff9affffff67fff
f8822ffff4400ffffff4fffffff4fffffff4ffffff56fffffff4f6fffff5f9fffff5ffffffffdffff898ffffffffffffff4fffffff5fffffff9fffffff6fffff
ff22fffff00fffffffffffffffffffffff4fffffff5fffffff4fffffff5fffffff554ffffcf2d2fff8998fffffffffffffffffffffffffffffffffffffffffff
ff0dfffffffffffffffffffffffffffff4ffffffffffffffffffffffffffffffff505ffffdf00fffff88ffffffdfffffffffffffffffffffffffffffffffffff
fff67ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fff22fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff899fffffcfcfffff8fffffcfffffffffffffffffffffffffffffffffffffff
ff882fffffffffcfffffffffffffffffffffffffffffffffffffffffffffffffff998ffff7dfd7fff998ffffffffffffffff9fffffffdfffffff3fffffffcfff
ff8d9ffffffff66ffffaffffffffffffffffffffffffffffffffffffffffffffff998fffcdfffdcff8998ffffffff7ffff9999ffffdd5dffff3333ffffccccff
ff86dffffff6600ffff9fffffff5ffffffffffffffffffffffffffffffff97ffff454fffffffffff899998fffffffffff4490ffff5550ffffbb30ffffddc0fff
f82626fff6600ffffff4fffffff4ffff44ffffffff567ffffffff4fffff5997ffff5ffffcdfffdcf8999998ffffffffcf900fffff500fffff300fffffc00ffff
fff22ffff00fffffffffffffffffffffff44ffffffdfffffff445d6fff5ff9ffff554ffff7dfd7ff8899998ffffffffff0fffffff0fffffff0fffffff0ffffff
ff0dffffffffffffffffffffffffffffffffd7fffffffffffffff6ffffffffffff505fffffcfcffff88888ffffcfffffffffffffffffffffffffffffffffffff
fffffffffffffffff988fffffffffffffffffffffffffffffffffffffffffffffff9fffffffffffff88fffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffa9998fffffff5ffffffffff7fffffff7f66676fffffff6ffff998fffffffffff8988ffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffff8f9fff98fffffffdffffffff6fffffff7f656ff67fffffff6fff999ffffffdfffff88ff8ff7fffffffffffffffffffffffffffffffffffffff
fffffffffffff55ff4fff98ffffff5fffffff46fffff566f64ffff67ffffff6fff899fffffd5fffff898fffffffffcffff3c3fffff4a4fffff282fffff5d5fff
fffffffffff5500ffffffffffffffd5fffff4fffffffff6fffffff66fffff66fff554fffff51bbff899988fffffffff7ffc37fffff947fffff827fffffd07fff
fffdd8fff5500fffffffffffffff445ffff4ffffffffff6ffffffffffffff66ffff5ffffff5bb5ff8999998fffffffffff3c3fffff494fffff282fffff5d5fff
f2288887f00ffffffffffffffffffffffffffffffffff6ffffffff66fff5557fff554fffff5155ff8999998fffcfffffffffffffffffffffffffffffffffffff
d8888886fffffffffffffffffffffffffffffffffffffffffffffffffffff99fff505ffff0505ffff88888ffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffff66ffff6ffffffffffffffffffff8fff8ffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffff5ffffffffffffff6fffffffffffffffff6ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffeffffffffffffff5ffffffffffffff6fffffffff66fffff6ffffffffffffffffffff8fffffcffffcffffffffffffffffffffffffffffffffff
fffffffffffff22fffffff9ffffffdfff44fffffffff6fffffffff66ffff66fffffffffffffffffff8988fffffffffffffbdbfffff898fffff2e2fffff8e8fff
fffffffffff2200ffffff98fff4ff5fffff446ffff566fffffffff7fff5f66fffffffffffffbbbff8999988ffffffffcff3b7fffff987fffffd27fffffe87fff
ff8888fff2200fffff4998fffff4dffffffff46fffff7fff6f4ff6fffff577ffff54f4ffff5550ff8899998fffffffffffb3bfffff898fffff2d2fffff8e8fff
f826d226f00fffffffa98fffffff5fffffffff67fffff7ff656667ffffff99fffff555fffb51110ff88988ffffffffffffffffffffffffffffffffffffffffff
d66d9227fffffffffffffffffffffffffffffffffffffffff667ffffffffffffff5505ff555550fff88888ffff7fffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffff000ffffffffffffffffffffffffffffffffffffffffffffffffffffffa999888876555555ffffffffffffffffffffffffffffffff
ffffff0100000fffffffff0000000ffffff0000fffffffffffffffffffffffffffffffffffefefff544fffff7665ffffffffffffffffffffffffffffffffffff
000ff00100011fff00fff0000000000fff00000000ffffffffffffffffffffffff222ffffe757eff76d44444ffffffffffffffffffffffffffffffffffffffff
0010110180018f0000ff0000000000dff000000000000fffffffffff0ffffffff22222fffe656effffffffffffffffffffffffffffffffffffffffffffffffff
001108018010800000f0000000000d9f000000000000000dfffffff00fffffff022224fffe6564effffff055d5fffffffffffffffffffffffffff0055dffffff
0019080110100010000000000000191f555000000000001dfffffff0d0fffffff12444fffe5e5effffff0511515ffffffffff000ffffffffffff055511dfffff
011901011010101000550000000d119f1550550000000d11fffffff0900fffff021114fffffffffffff01055000dffffffff0555000fffffffff05115510ffff
0d010100000010000055505000dd119f000055505000dd11ffffff005d0f0ffff02440ffffffffffffff0511511dfffffff051515550ffffffff01501115d0ff
090100000f0000000000505551d1911f505000505550d1d1ffff00011d0090ffffffffffffffffffffff05015191ffffff05050151d5ffffffff01550101d0ff
0d10ffff0ffff00800500005511d919f5055500008801dd1fff000011501d0ffffffffffffffffffffff01011010ffffff5552050d510ffffffff01549150fff
0110050fffffff0000505550011d19df0005505580001d1dff0800001101d00ff242ffffff757fffffff01118910f1ffff5055559151010ffffff0015500f1ff
010ffffffffff0f0000015505d111d0f555000158058111dff01100115001d0024224fffff656fffffff01511550111ff050512151511110ffff00100100111f
0001fffffffffff1005500005d1d100f1550550000581d10f111010111001150222444ffff6564fffff05000000dffff0020505051550000fff05000000dffff
00001ffff00f80100055505001dd00fffff055505000dd0ff011010110d01010122444fff8a8a8fffff105505850110ff051505050511100fff105505450110f
ff000811000011000000505551d00fffffff00505880d0ffff0011010050100f012444fff89898ffff0011000001100fff5551519501100fff0011000001100f
fff0000000000000ffff00055100fffffffffff005500ffffff01111101110fff0122fffff8f8ffffff00110111000fffff00555511000fffff00110111000ff
ffff115515150fffffffff0000fffffffffffffff000ffffffffffffffffffffffffffff5550500fffffffffffffffffffff042992242fffffffffffffffffff
fff11015010105ffffff015500fffffffffff0bbb00fffffffff9ffffffb9f33fff000110050555fffffffffffffffffffff150000050ffffff000880811ffff
ffd110111101011ffff10111015ffffffff10bbbbbb8f1fff33ff9fff0b0f3ffff011d00ff00055fffffffffffffffffffff005222202fffff0111000111f10f
fd11001101000101ff1d1000011501ffff10b11bbb9d111ffff3ff3f99ff3ffff01150d9195015d0ffffffffffff9fffffff050000050ffff011110180001110
5151000000000100f155010100010155fff05551195dffffffff3f3fff3fbfff00005550050d0000fffffffffff9ffffffff042922240fff0000001111080000
11500011010000011150f00011000011f01155155d501100fffffbfbffb00ffff011000050050100fffff9fffff3ffffffff021000100ffff011000010111100
1101fffffffff1015001ffff00011100ff0000155d01100fffff0b0bfbffffffff0011510050500fffffff9ffff3ffffffff042222242fffff0011110001100f
101fffffffffff005001fffffff00001fff00100001000fffffffffbfffffffffff00150110005fffff3ff3f9ff3f3ffffff050000020ffffff00110111000ff
ffffff88fffffffffffffff888ffffffffffffff88fffffffffffffff9ffffffffff667777766fffffff3f3f3f3ff3ffffffffffff505ffffffffff5ffffffff
fff000110881fffffff01111111110fffff01111111110fffffffffffbfffffffff6ddd979ddd6ffffff3f3ff3bf3ffffffffff5904202ffffff5055d11000ff
ff0111000111f10fff0111111111110fff0111118111110ffffffffffff9ffffff6dddd69ddddd6fffff3f3ff3b03fffffff05902902202fffff1000050045ff
f011110180001110f011100111111110f011111111111110fffff9fffffbfffff6dddd6d9dddd6d6ffff3ff3f3ffbffff505502402405504fff15500d55455ff
000000111101000001111118111111110101111111111111fffff3ff9ffffffffdddd6ddd6dd6dddfffff3f3fbffbfff022022022055044ff0005559d0550001
f011000010111100f011111110011110f011111111100110fffffbf3ffffffffffdddddd7ddddddffffffbf3fbff00fff02202505404fffff051005910d11100
ff0011110001100fff0111118111110fff0111111181100ffffffffbfffffffffffdddd6ddddddffffff0b0bffffffffff055044ffffffffff0011110559100f
fff00110111000fffff01111111110fffff01111111110ffffffffffffffffffffffdd6ddddddffffffffffbfffffffffff44ffffffffffffff00510111000ff
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888777777888eeeeee888eeeeee888eeeeee888eeeeee888eeeeee888eeeeee888eeeeee888888888ff8ff8888228822888222822888888822888888228888
8888778887788ee88eee88ee888ee88ee888ee88ee8e8ee88ee888ee88ee8eeee88ee888ee88888888ff888ff888222222888222822888882282888888222888
888777878778eeee8eee8eeeee8ee8eeeee8ee8eee8e8ee8eee8eeee8eee8eeee8eeeee8ee88888888ff888ff888282282888222888888228882888888288888
888777878778eeee8eee8eee888ee8eeee88ee8eee888ee8eee888ee8eee888ee8eeeee8ee88888888ff888ff888222222888888222888228882888822288888
888777878778eeee8eee8eee8eeee8eeeee8ee8eeeee8ee8eeeee8ee8eee8e8ee8eeeee8ee88888888ff888ff888822228888228222888882282888222288888
888777888778eee888ee8eee888ee8eee888ee8eeeee8ee8eee888ee8eee888ee8eeeee8ee888888888ff8ff8888828828888228222888888822888222888888
888777777778eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee888888888888888888888888888888888888888888888888888888
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111116661666161616661166166616661616161111711166166616661111161611111616111116661666166116661666
1e111e1e1e1e1e1111e111e11e1e1e1e111111611611161611611611161616161616161117111611116116161111161611111616111116111616161616111161
1ee11e1e1e1e1e1111e111e11e1e1e1e111111611661116111611611166116661616161117111666116116611111116111111666111116611666161616611161
1e111e1e1e1e1e1111e111e11e1e1e1e111111611611161611611611161616161666161117111116116116161171161611711116117116111616161616111161
1e1111ee1e1e11ee11e11eee1ee11e1e111111611666161611611166161616161666166611711661116116161711161617111666171116111616166616661161
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee111111661666166616661666166617111666166616611666166611111eee1e1e1eee1ee111111111111111111111111111111111111111111111
111111e11e111111161111611616116116111161117116111616161616111161111111e11e1e1e111e1e11111111111111111111111111111111111111111111
111111e11ee11111166611611666116116611161111716611666161616611161111111e11eee1ee11e1e11111111111111111111111111111111111111111111
111111e11e111111111611611616116116111161117116111616161616111161111111e11e1e1e111e1e11111111111111111111111111111111111111111111
11111eee1e111111166111611616116116661161171116111616166616661161111111e11e1e1eee1e1e11111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1eee111116661616116611111eee1ee11ee111111ee111ee1eee11111666161611661666116616661611166616161666166111111eee1e1e1eee
1111111111e11e11111116661616161111111e1e1e1e1e1e11111e1e1e1e11e1111116661616161111611611161616111616161616111616111111e11e1e1e11
1111111111e11ee1111116161616166611111eee1e1e1e1e11111e1e1e1e11e1111116161616166611611611166616111666166616611616111111e11eee1ee1
1111111111e11e11111116161616111611111e1e1e1e1e1e11111e1e1e1e11e1111116161616111611611611161116111616111616111616111111e11e1e1e11
111111111eee1e11111116161166166111111e1e1e1e1eee11111e1e1ee111e1111116161166166116661166161116661616166616661666111111e11e1e1eee
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111bbb1b1b11bb1bbb11bb117116661616116611111ccc1ccc1ccc1171111111111111111111111111111111111111111111111111111111111111
1111111111111bbb1b1b1b1111b11b1117111666161616111111111c1c1c1c1c1117111111111111111111111111111111111111111111111111111111111111
1111111111111b1b1b1b1bbb11b11b111711161616161666111111cc1c1c1c1c1117111111111111111111111111111111111111111111111111111111111111
1111111111111b1b1b1b111b11b11b1117111616161611161171111c1c1c1c1c1117111111111111111111111111111111111111111111111111111111111111
1111111111111b1b11bb1bb11bbb11bb117116161166166117111ccc1ccc1ccc1171111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111666161611661666116616661611166616161666166111111ccc1ccc1c1c1ccc1111111111111111111111111111111111111111111111111111
11111111111116661616161111611611161616111616161616111616177711c11c1c1c1c1c111111111111111111111111111111111111111111111111111111
11111111111116161616166611611611166616111666166616611616111111c11cc11c1c1cc11111111111111111111111111111111111111111111111111111
11111111111116161616111611611611161116111616111616111616177711c11c1c1c1c1c111111111111111111111111111111111111111111111111111111
11111111111116161166166116661166161116661616166616661666111111c11c1c11cc1ccc1111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1ee11ee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ee11e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1e1e1eee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1eee11111bbb1bbb1bb11bbb117111666661117111111eee1e1e1eee1ee111111111111111111111111111111111111111111111111111111111
1111111111e11e1111111b1b11b11b1b1b1b1711166161661117111111e11e1e1e111e1e11111111111111111111111111111111111111111111111111111111
1111111111e11ee111111bb111b11b1b1bbb1711166616661117111111e11eee1ee11e1e11111111111111111111111111111111111111111111111111111111
1111111111e11e1111111b1b11b11b1b1b111711166161661117111111e11e1e1e111e1e11111111111111111111111111111111111111111111111111111111
111111111eee1e1111111bbb11b11b1b1b111171116666611171111111e11e1e1eee1e1e11111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111166616661171166616161666166111111ccc1ccc1c1c1ccc11111111111111111111111111111111111111111111111111111111111111111111
1111111111111616161111171161161616161616111111c11c1c1c1c1c1111111111111111111111111111111111111111111111111111111111111111111111
1111111111111661166111111161161616611616111111c11cc11c1c1cc111111111111111111111111111111111111111111111111111111111111111111111
1111111111111616161111111161161616161616111111c11c1c1c1c1c1111111111111111111111111111111111111111111111111111111111111111111111
1111111111111616166611111161116616161616111111c11c1c11cc1ccc11111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1ee11ee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ee11e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1e1e1eee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111bbb1bbb1bbb1bb11bbb117111bb1b1b1bbb117111661666166611111ccc111111661666166616661666166617171ccc1ccc11711111161611111616
111111111b1b1b1b11b11b1b11b117111b111b1b1b1b171116111161161611111c1c11111611116116161161161111611171111c1c1c11171111161611111616
111111111bbb1bb111b11b1b11b117111bbb1b1b1bb1171116661161166111111c1c1111166611611666116116611161177711cc1c1c11171111116111111666
111111111b111b1b11b11b1b11b11711111b1b1b1b1b171111161161161611711c1c11711116116116161161161111611171111c1c1c11171171161611711116
111111111b111b1b1bbb1b1b11b111711bb111bb1bbb117116611161161617111ccc171116611161161611611666116117171ccc1ccc11711711161617111666
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1ee11ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1e1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111116661661166616661666166616161666117116661666161616661111166616611666111116161666161616161111
1e111e1e1e1e1e1111e111e11e1e1e1e111116161616116116661161161116161161171111611611161611611111161116161161111116161616161616161111
1ee11e1e1e1e1e1111e111e11e1e1e1e111116661616116116161161166111611161171111611661116111611111166116161161111116161666161616661111
1e111e1e1e1e1e1111e111e11e1e1e1e111116161616116116161161161116161161171111611611161611611171161116161161117116661616166611161171
1e1111ee1e1e11ee11e11eee1ee11e1e111116161616166616161161166616161161117111611666161611611711166616161161171116661616116116661711
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111bbb1bb11bb11171166616661616166616661661166616661166111111771666166616161666111116661661166611661166166616661666166116661166
11111b1b1b1b1b1b1711116116111616116116161616116116661611111111711161161116161161111116111616116116111611161616111611161616161616
11111bbb1b1b1b1b1711116116611161116116661616116116161666111117711161166111611161111116611616116116661611166116611661161616661616
11111b1b1b1b1b1b1711116116111616116116161616116116161116117111711161161116161161117116111616116111161611161616111611161616111616
11111b1b1bbb1bbb1171116116661616116116161616166616161661171111771161166616161161171116661616116116611166161616661666161616111661
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888828282288222888282228222822288888888888888888888888888888888888882228288828882228882822282288222822288866688
82888828828282888888828288288282882882888882888288888888888888888888888888888888888888828288828882828828828288288282888288888888
82888828828282288888822288288282882882228882882288888888888888888888888888888888888888828222822282228828822288288222822288822288
82888828828282888888888288288282882888828882888288888888888888888888888888888888888888828282828282828828828288288882828888888888
82228222828282228888888282228222828882228882822288888888888888888888888888888888888888828222822282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
000000000000000000000000000000004000800880082c000000ee00be00ee007a016301ba016b03f30109096b15b301b30173017301730323017d036b15ea0104040404000000000000000000000000040404040000000000000000000000000404040400000000000000000000000004040404000000000000000000000000
0000000000000000008000000000000000000000000000000000000000000000040000000000000300000000000000000400000000000003000000000000000001010000000000000000000000000000010110002000700000003000300030000000000010000407040000090401040004000407040004070487040904003000
__map__
464647474141424b4b4b00000000acac1011ca0014150000000000001c1d000020210000242500002829000000002e2f303132333435363738393a3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0046474741434900000000000000adad3200cb0000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
460047474244494e4c4c00000000aeae3200000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46470047004200004d4d00000000afaf3400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0047410041004d454d4d00000000bc003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4700414143414d454d4d00000000bd003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0041004100414d42000000000000be001600000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00004141494200444e4e00000000bf001600000000000000000000003200000020000000320000003200000000003200320032003200363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000049424c44000000000000bc001600000000000000000000003200000020000000320000003200000000003200320032003400363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000414100000000000000000000bd001600000000000000000000003200000020000000320000003200000000003200320032003400363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000042424841454c000000000000be0016000000000000000000000032000000200000003200000032000000000032003200340034003a3200003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004841454d000000000000bf0016000000000000000000000032000000200000003200000032000000000032003200340034003a32000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000048434843004d0000000000009c0032890000000000000000000032000000200000003200000032000000000032003200340034003a34000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000043454d0000000000009d0032890000000000000000000032000000100000003200000032000000000032003200340020003200000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00004948450042000000000000009e0034890000000000000000000032000000100000003200000032000000000032003200340036323200000036340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000048004500490000000000009f0034890000000000000000000032000000340000003200000032000000000032003200320036343400000036340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000410044490000000000008c001011000014150000000000001c1d000020210000242500002829000000002e2f303132333435363738393a3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000049424544420000000000008d000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000434548420000000000008e000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000440048000000000000008f000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004d480000000000000081000000000030000000000000002ec80000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000434d00000000000000009100000000002e000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000043000000000000000000a100000000002e0000000000000030000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000420000000000000000b100000000002e0000000000000030000000200000002ea900003000000000001c00300030003000363000003a2e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004900000000000000008400000000002e0000000000000030000000200000002ea900003000000000002ea93000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000008500000000003e0000000000000030000000200000002ea9000030000000000028003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004800000000000000008600000000003e0000000000000030000000200000002ea900003000000000002ec83000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004800000000000000008700000000003e0000000000000030000000200000002ea9000030000000000024003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004800000000000000000000000000001e0000000000000030000000200000002ea9000030000000000030882e0030003000362e000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001a0000000000000030000000200000002ea900002e000000000020002e002e002e003a2e0000362e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002ec800000000000030000000200000002ea900002e000000000036302e002e002e003000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000308800000000000030000000300000002ea900002e0000000000362e2e002e002e002e0000002e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
38500810220342202022010220122201022010220150060518500185000f5000f5001350013500165001650018500185000f5000f5001350013500165001650018500185000f5000f50013500135001650016500
900100000064000620006100061000610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900200000062403630036000062000610006000060000600056000060005600016000060000600006000060000600006000060000600005000050000600006000050000500005000050000500005000050000500
c4281400184151a4151f41521415184151a4151f41521415184251a4251f42521425184251a4251f42521425184251a4251f415214152140523405284052a4050000000000000000000000000000000000000000
48030c1c0862024524240242404124051240412403124021240212402124021240212403124031240412404124031240312402124021240312403124041240412403124031240212402124011240112401123011
480800000a05301030010210102101015010000100001000010000100000000000000800301000010000905301030010210102101015006450051300503050050000000000000000000000000000000000000000
520a100000605006053a6053a6053b615000053b6253a6053b6150000000000000003d6103d615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9303002000661026510c6710267008661016310866001661106710366009641026610567006651016710b640066610167103670046510267109640016610a671026400466103671076310b650036610667103631
0027002005f7113f7111f7112f7108f7110f711af710df7115f7105f7121f710df7112f7118f7104f7106f7112f711bf7110f710ff7106f7104f7111f710ff710cf7115f7118f7104f710cf7111f710bf710ff71
520709003e65331651006113e62330621006113e61311611006150060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
9002060017a1417a1017a1017a1017a1017a100060009a0009a0009a0009a0009a0009a0000600006000060000600006000060000600005000050000600006000050000500005000050000500005000050000500
00020a001414015151151611216111141061330613105121051200512102100011000210003100031000210003100081000810000100001000010000100001000010000100001000010000100001000010000000
900117000062000621056310a64112641186512065110051060310302101621006210262000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
a8020600322303f2613e2413c231342010b2002e2002f2002320000200002000020000200002002d2001d20000200002000020000200002000020000200002000020000200002000020000200002000020000200
aa0506003e6143a5213f5213f5113d501005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
aa0407003e6143e5213f521355112f511005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
d402170000120071501a2701665013260122601015009250041500e15000250052000024004200031000023000100001000023000100001000010000100001000010000100001000010000200002000020000200
d4080a00170033e544345353d5353e525345153d5153e51531507375073a5073d5073a50732507325073a5073b5072f50732507375072b5073750721507285070050000500005000050000500005000050000500
18041000021340e1410616209142061620614206162061320615105151061510612103151001230d1010d1010b101071010a1010a105000000000000000000000000000000000000000000000000000000000000
000706000000109071190010000107031200010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c403110000610022210a631241412c3401a641132310a221066200000001220000000120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c4020b00326103503437061242311d213102310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
200411000f13404141061620814208162081420e1610813108151071510815107121091510e1210d0000d1010b101071010a1010a105000000000000000000000000000000000000000000000000000000000000
900409000f65500301000010065006011006013600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900b04003f00438011320212900100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480606000062507071000000062400620006250000001605006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
940310000165500000206650002106051090210b541095210a5310b5010a5210b5010c5010b5010a5110b50100000000000000000000000000000000000000000000000000000000000000000000000000000000
c40406003a62532525136003f52500605026010160100505006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04020c0006553000030955300003000031153300003000031a5330000300003355230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000603003e00013031000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000114000915009161091710b1700a171091500416102150021300113101150011610117102170031610317002171031700815108130001000010000100001000010000100001000010000100001000010000100
d40220000015000250002500f6600f2600e2500915009650091500425009150052500325004250031500125000100002500010000100002500010000230001000010000100001000023000200002000020000200
a8011700322103e2313f2313f2312f200232002e2002f20023200002000020000200002003020038201272022f221392513d2513d251002000020000200002000020000200002000020000200002000020000200
900119000061000611026210862117621236313063123631166210c01105611006110261000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
4c0603000667306573005530d503005030c5030050500103001010010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000000000000000000000
9001190019920199201992019920199201992019920199200d9000d9000d900059100591005910059100591005910059100591005910059100591005910059100b9000b9000b9000b9000b9000b9000b9000b900
4a020000016212f641056600a671136710965003641026413663005621036310562008621056310e630056210162100610096110061100620006312d621006110061001601016210160100610006210060100611
480210000261000620036100161000600006100061000610006000061000600006000050000500006150060000500005000050000500005000050000500005000000000000000000000000000000000000000000
78020b000e91006010040110301500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a8030400260242a011001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000000000000000000000000000000000000000000000000000000000
920100003b3153461034615270000000000000000000000000000000002b6002e600000000000000000000003931530610306151a6052900029000290053b6000000000000000003b600000003b600000003b600
90070b001967316333073130060315333073131530315303153130010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000000000000000000000000000
000b02000f05300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90010d0007615006110061524500316000060000600006003162500610006110060100601006011e60500601006010060100601006051d600006050560004600000000060500000000000a600086050000002600
600a09001a6051c5311a5211952119512195011950100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7e0200000c050006500145033650366603666036660366503665036650366503665036650366501764017630176301333000000123501760025600206001133000000296002a600003000c310000000000000000
7e0219000c0500065001450386503a6602766020660163502d65014350366003660015350366001760017600176000040000000000001760025600206000030000000296002a6000030000000000000000000000
00070000161011e1001c1011c1011c1011a1010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04a014001882018820188251b8001c8001e8101e8241e81518c001bc001f8101f8101f815240002a8001f8201f825158000000000000000000000000000000000000000000000000000000000000000000000000
6ca00014155141e52621517155120e5111e5141e5141e502175141f5061c51418516185121a5111a5121b5111b5141b5121b5121b5133f5000050000500005000050000500005000050000500005000050000500
6150000014e0424e2015c2415c301ac541ac401ac301ac301ac2015c3019c3019c4019c3419c351bc000000000000000000000018c2418c5418c5018c3018c4018c541cc161cc301cc301cc2017c5016c5416c55
00a0140019d7019d7019d7019d7019d0019d7018d7018d7018d0018d7017d7017d7017d7017d7017d0017d701dd701dd7027d00000001dd000000000000000000000000000000000000000000000000000000000
90a014001fb441fb401fb441fb401fb351de301eb441eb401eb201eb201fb441fb401fb441fb401fb2020b4420b4020b3020b2020b10000002d4002c400000000000000000000000000000000000000000000000
04a014001782017820178251fc0023c0516820168341682524c001bc0017820178201782500000000001482014825000000000000000000000000000000000000000000000000000000000000000000000000000
6050000028c0411c001bc0015c301ac541ac401ac301ac301cc2417c5018c5418c5018c3418c351bc000000000000000000000028c0411c001bc0015c0015c331ac541ac401ac301ac301cc2417c5016c5416c55
01a014001ed701ed001ed701ed701ed001ed701dd701dd701dd001dd701cd701cd001cd701cd701cd001cd7018d7018d7027d0018d001dd00000001dd00000000000000000000000000000000000000000000000
__music__
01 3d3c3f7c
00 3d3f3e7c
00 3d3c3e7c
00 3d3c3b7c
00 3d3c3f7c
00 3c3f3e7c
00 3d3f3e3c
02 3d3b3a3c
00 3d3b397c
00 3d3f3e3c
02 3d3b3a3c
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 3d383c7f
01 3d3c3b7c
02 3d387c3f
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
03 08424344

__change_mask__
fafffffffffffffffffffffffffffffffffffffff5fffffff5ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

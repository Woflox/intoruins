pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--game name???
--BY ERIC BILLINGSLEY

function _init()
assigntable(_ENV,
[[gamestate:play,depth:5,mapsize:20,mapcenter:10,turnorder:0,
,tempty:0,tcavefloor:50,tcavefloorvar:52
,tcavewall:16,tdunjfloor:48,tywall:18,txwall:20
,tshortgrass:54,tflatgrass:38,tlonggrass:58,tmushroom:56
,thole:32,txbridge:60,tybridge:44
,minroomw:3,minroomh:2,roomsizevar:8]])
entdata={}
assigntable(entdata,
[[64=name:you,hp:20,atk:0,dmg:2,armor:0,atkanim:patk,light:4,hitshake:true,moveanim:move,deathanim:pdeath
70=name:rat,hp:3,atk:0,dmg:1,armor:0,ai:true,pdist:-15,runaway:true,alertsfx:14,hurtsfx:15
71=name:jackal,hp:4,atk:0,dmg:2,armor:0,ai:true,pdist:0,pack:true,movandatk:true,alertsfx:20,hurtsfx:21
65=name:goblin,hp:7,atk:1,dmg:3,armor:0,ai:true,pdist:0,alertsfx:30,hurtsfx:11
66=name:goblin mystic,hp:6,atk:1,dmg:3,armor:0,ai:true,pdist:-2,alertsfx:30,hurtsfx:11
67=name:goblin archer,hp:7,atk:1,dmg:3,armor:0,ai:true,pdist:-3,alertsfx:30,hurtsfx:11
68=name:goblin warlock,hp:6,atk:1,dmg:3,armor:0,ai:true,pdist:-3,alertsfx:30,hurtsfx:11
69=name:ogre,hp:15,atk:2,dmg:8,armor:1,slow:true,knockback:true,stun:2,ai:true,pdist:0,alertsfx:31,hurtsfx:16
72=name:bat,hp:4,atk:2,dmg:6,armor:0,movratio:0.6,ai:true,behav:wander,darksight:true,burnlight:true,pdist:0,flying:true,idleanim:batidle,alertsfx:32,hurtsfx:13
73=name:pink jelly,hp:10,atk:1,dmg:2,armor:0,ai:true,pdist:0,moveanim:emove,movratio:0.33,alertsfx:19,hurtsfx:19
137=name:mushroom,hp:1,blocking:true,light:4,lcool:true,deathanim:mushdeath,flippable:true,deathsfx:42
136=name:brazier,hp:1,blocking:true,hitfire:true,light:4,idleanim:idle3,deathanim:brazierdeath,animspeed:0.3,deathsfx:23
169=name:chair,hp:2,blocking:true,hitpush:true,dmg:2,stun:1,flippable:true,deathanim:propdeath,animspeed:0.3,deathsfx:23
200=name:barrel,hp:2,blocking:true,hitpush:true,dmg:2,stun:1,flammable:true,deathanim:propdeath,animspeed:0.3,deathsfx:23
138=name:fire,effect:true,idleanim:fire,deathanim:firedeath
139=name:spores,effect:true,idleanim:idle4,animspeed:0.25,flippable:true
idle3=l012
fire=0l.1.2.3f1f2f3
firedeath=0
idle4=l0123
batidle=l0022
move=044
turn=44
emove=022
sleep=lz000000000000000000000
patk=wa22d22r
eatk=wa22dr22
batatk=wa20dr22
death=wb0vc0vc0c0c0r_
pdeath=w444l6
mushdeath=w01r_
brazierdeath=w33r_
propdeath=w11r_
fall=wv0000c00r_
130=name:torch,slot:wpn,dmg:3,atk:1,lit:true,throw:4,fuel:160,light:4,namenofuel:club,dmgincrease:1
132=name:spear,slot:wpn,dmg:3,atk:1,pierce:true,throwbonus:1,throw:8,dmgincrease:1
133=name:rapier,slot:wpn,dmg:2,atk:2,lunge:true,throw:4,dmgincrease:1
134=name:axe,slot:wpn,dmg:3,atk:1,swing:true,throw:6,dmgincrease:1
135=name:hammer,slot:wpn,dmg:6,atk:1,stun:2,knockback:true,slow:true,throw:2,dmgincrease:2
]],"\n","=")
 
	adj=vec2list
[[-1, 0,
	 0 ,-1,
		1 ,-1,
		1 , 0,
		0 , 1,
		-1, 1]]
	
	specialtiles={
	[tcavewall]={
		vec2(-9,-4),
		vec2list--xy
	[[0 ,-8,
		 5 ,-8,
		 13,-8,
		 13, 4,
		 4 , 4,
		 2 , 4]],
 	vec2list--wh
	[[5,13,
		 8,13,
		 5,13,
		 5, 4,
		 11, 4,
		 3, 4]]},
	[thole]={
		vec2(-8,-4),
		vec2list--xy
	[[0, 0,
		 4, 0,
		 13,0,
		 0,0,
		 4,1,
		 13,0]],--last 3 are brick
		vec2list--wh
	[[4,8,
		 8,8,
			3,8,
			4,8,
			7,7,
			4,8]]},
	[txwall]={
		vec2(-9,-2),
		vec2list--xy
	[[12,-8,
 		 0,-8]],
		vec2list--wh
	[[7 ,17,
		 12,17]]},
	[tywall]={
		vec2(-5,-2),
		vec2list--xy
	[[9,-8,
		 2,-8]],
		vec2list--wh
	[[7 ,17,
		 7,17]]}
 }
 
 wpnpos=vec2list
[[3,-2,
 	2,-1,
 	1,-2,
 	1,3,
 	3,-3,
 	1,-2]]
 	
 darkpal=split"15,255,255,255,255,255,255,255,255,255,255,255,255,255"
	dimpal=split"241,18,179,36,21,214,103,72,73,154,27,220,93,46"
	blackpal=split"0,0,0,0,0,0,0,0,0,0,0,0,0,0"
 whitepal=split"7,7,7,7,7,7,7,7,7,7,7,7,7,7"
 redpal=split"8,8,8,8,8,8,8,8,8,8,8,8,8,8"

	textanims={}
	textlog={}
	introtext=
[[  tHE CAVE OPENING CALLS TO YOU.    
cOULD THIS BE THE RESTING PLACE
OF THE FABLED wINGS OF yENDOR?    





   tHERE'S NO TURNING BACK...  

        ❎:jump down]]
 
	spawns={}
	for i=0,7 do
		local curspawns={}
		local spawn={}
		add(spawns,curspawns)
		for j=0,31 do
			local typ=mget(i,j)
			if typ != tempty then
				add(spawn,typ)
			elseif #spawn>0 then
				add(curspawns,spawn)
				spawn={}
			end
		end
	end
	
	genmap(vec2(mapcenter,mapsize*0.75))--mapsize/*0.75))

 local torch = create(130)
	addtoinventory(torch)
	equip(torch)
	calclight()
	--music(0)
end

function updateturn()
 if (waitforanim) return
	
	if turnorder==0 then
		pseen=false
		playerwaited=false
	 if not taketurn(player,player.pos,player.tl) then
	 	return
	 end
	 tickstatuses(player)
	 updatemap()
	elseif turnorder==1 then
		for i,ent in ipairs(ents) do
			if ent.ai then
			 taketurn(ent,ent.pos,ent.tl,ent.group)
	   tickstatuses(ent)
			end
		end
	else
	 for i,ent in ipairs(ents) do
			postturn(ent)
		end
		--todo: environmental changes
		
		calclight()
		turnorder=0
		return
	end
	turnorder+=1
	updateturn()
end

shake=0

function _update()	

	updateturn()
	waitforanim=false
	for i,ent in ipairs(ents) do
		updateent(ent)
	end
	
	local camtarget = 
 	screenpos(
 		lerp(player.pos,
 							vec2(mapcenter,
 												mapcenter-0.5),
 							gamestate=="gameover" and 0 or 0.36))
	local tmod = 
		gamestate=="gameover" and
													 0.25 or 0.5	
	smoothb = smoothb and
											lerp(smoothb,camtarget,
											tmod)
											or camtarget
	smooth = smooth and 
		lerp(smooth,smoothb,0.5*tmod)
		or	smoothb
		
	campos=vec2(flr(rnd(shake*2)-
	                shake+
	                smooth.x-63.5),
													flr(rnd(shake*2)-
	                shake+
	                smooth.y-63.5))
	shake*=0.66
end

function _draw()
	cls()
	camera(campos.x,campos.y)
	lfillp=localfillp(0xbfd6.4,
								-campos.x,
								-campos.y)
	drawmap(world)
	pal()
	pal(15,129,1)
	pal(11,131,1)
	fillp()

	for i,anim in ipairs(textanims) do
	 local t=(anim[5] or 1)*
	          (time()-anim[7])
	 local col=anim[4] or 7
	 if t>0.5 then
			del(textanims, anim)
		else
			anim[2].y-=0.5-t
			print(anim[1],
									anim[2].x+2-
									(anim[3] and cos(t*2) or 0),
									anim[2].y+(anim[6] or 0)-6,
									t>0.433 and 5 or col)
		end
	end
	camera(0,0)
	--print("fps: "..stat(7)..
	--      " cpu: "..stat(1),0,2,5)
	cursor(1,2)
	for i,entry in ipairs(textlog) do
		local t = time()-entry[2]
		if t>2.5 then
			del(textlog, entry)
		else
			?entry[1],t<2.434 and 6 or 5
		end
	end

	if gamestate=="play" then
		local x=drawbar(player.hp/player.maxhp,
		        "HP",2,123,2,8)
		for k,v in 
			pairs(player.statuses)
		do
			x=drawbar(v[1]/v[2],k,x,123,v[3],v[4])	
		end
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

function animtext(text,ent,wavy,col,spd,offset)
 add(textanims,{text,entscreenpos(ent),wavy,col,spd,offset,time()})
end

function log(text)
	add(textlog,{text,time()},1)
end
-->8
--tiles, rendering

--[[
tile flags

0:navigable
1:passlight
2:xtraheight
3:infrontwall
4:genable
5:drawnormal
6:flippable
7:manmade

lit tile flags

0:lit from this tile
1-6:lit from adj tile
7:emits light

extra tile flags

0:navflying
]]

function tile(typ)
	return {typ=typ,fow=0}
end

function settile(tl,typ)
	tl.typ=typ
	tl.bg=nil
	tl.genned=false
end
	
function drawcall(func,args)
	add(drawcalls, {func,args})
end

function initpal(tl, fadefow)
	pal()	
	palt(0, false)
	palt(15, true)
	local fow=0
	if fadefow then
		if vistoplayer(tl) then
			fow=tl.light>=2 and 3 or 2
		elseif tl.explored then
			fow=gamestate=="gameover"
			    and 0 or 1
		end
		local oldfow=tl.fow
		tl.fow = mid(oldfow-1,fow,oldfow+1)
	end
	fow=tl.fow
	fillp(fow==3 and █	or 
						 lfillp)
	if fow==0 then
		pal(blackpal)
	elseif fow==1 then
		pal(darkpal,2)
	else
	 pal(dimpal,2)
	end
end

function onscreenpos(pos,pad)
 local scrpos=screenpos(pos)
 local scrposrel=scrpos-smooth
	if max(abs(scrposrel.x),
        abs(scrposrel.y))<=pad
 then
	 return scrpos
	end
end

function drawtl(tl,pos,flp,bg,i)
	local scrpos=onscreenpos(pos,72)
 if (not scrpos) return
	
	local typ = tl.typ
	if not i and typ==tywall then
		typ=tdunjfloor
	end
	if bg and tl.bg then
		typ=tl.bg
	end
	
	local xtraheight = fget(typ,2)
																	   and 8 or 0
	local baseoffset = vec2(-8,-4)
	local offset = vec2(1,
																		  -xtraheight)
	local size = vec2(15,
																		 8+xtraheight)
	local litsprite = typ+192
 
	--special tiles
	if i then
		local tileinfo = 
									specialtiles[typ]
		baseoffset,offset,size=
			tileinfo[1],
			tileinfo[2][i],
			tileinfo[3][i]
		if typ == tywall and
					pos.y%2 == 1 then
			baseoffset+=vec2(-6,-2)
		end
		if typ==thole then
		 typ=litsprite
			if i>3 then
			 typ += 2--brick hole
			 flp = false
			 baseoffset+=vec2(0,1)
			end
		end
		if (i-2)%3 !=0 then
		 flp = false
		end
	end
	
	--lighting
	for i=0,6 do
		if not bg and tl.fow==3 and 
		   fget(litsprite,i) then
			local adjtile =
				getadjtl(pos,i)
			if adjtile and
						adjtile.lightsrc then
				typ = litsprite
			 if adjtile.ent then
					pal(8,adjtile.ent.lcool and 13 or 4)
					pal(9,adjtile.ent.lcool and 12 or 9)
			 end
			end
		end
	end
	scrpos+=offset+baseoffset
	
	sspr(typ%16*8+offset.x,
							flr(typ/16)*8+
								offset.y,
							size.x,size.y,
							scrpos.x,scrpos.y,
										size.x,size.y,
										flp)
end

function drawent(tl,entvar)
	local ent = tl[entvar]
	if ent and (vistoplayer(tl) or
	   (ent.lasttl and
	   vistoplayer(ent.lasttl)))
 then
		initpal(tl)
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
		if ent.wpn and frame <= 4 then
			local wpnpos=wpnpos[frame+1]
			local wpnframe = frame%4
			
			spr(ent.wpn.typ+wpnframe*16,
							scrpos.x+
							wpnpos.x*ent.xface,
							scrpos.y+wpnpos.y,
							1,ent.animheight,
							flp)
		end
		ent.lasttl=nil
	end
end

function drawents(tl)
	drawent(tl,"item")
 drawent(tl,"ent")
 drawent(tl,"effect")
end

function drawmap()
	for i,drawcall in 
					ipairs(drawcalls) do
		drawcall[1](
			unpack(drawcall[2]))
	end
end


function setupdrawcalls()
	drawcalls={}
	alltiles(
	
	function(pos,tl)
		local typ = tl.typ
		local palready=false
		
		function draw(tltodraw,pos,i,bg)
			if not palready then
				drawcall(initpal,{tl,true})
				palready=true
			end
			drawcall(drawtl,
							 {tltodraw,pos,
							 	tl.flip and 
							 		tileflag(tltodraw,6),
							 	bg,i})
		end
		
		infront=fget(typ,3)
		
		if tl.bg then
			draw(tl,pos,nil,true)
		end
		
		if not infront and
					fget(typ,5) or
					(typ == tywall and
					 pos.y%2==0) then
			draw(tl,pos)
		end
		
		for n=1,6 do
			i=n
			if (n==1)i=2
			if (n==2)i=1
			
			if infront and i==4 then
				draw(tl,pos)		
			end
			
			local adjtl=getadjtl(pos,i)
			if adjtl then
				adjtyp = adjtl.typ
				
			 if typ != tcavewall and
				 		typ != tempty and
				 		adjtyp==tcavewall 
				then
					draw(adjtl,pos,i)
				elseif i<=2 and
					     (adjtyp==txwall or
					      adjtyp==tywall) 
				then
				 wallpos=pos+adj[i]
					if adjtyp==tywall and
							 i==1 and
							 wallpos.y%2==1 
					then
					 draw(adjtl,wallpos)
					end
					draw(adjtl,wallpos,i)
				end
				if i <= 3 and
				   (typ == thole or
				   tl.bg == thole) and
							adjtyp != thole and
							adjtl.bg != thole
				then
				 draw(tl,pos,i+
				 	(manmade(adjtl)
				 	and 3 or 0),--brick hole
				 	tl.bg==thole)--bridges
				end 
			end
		end
		uprtl=getadjtl(pos,3)
		if uprtl and 
					navigable(uprtl,true) then
			drawcall(drawents,{uprtl})	
		end
	end)	
end

-->8
--map stuff

function inbounds(pos)
	local x,y=pos.x,pos.y
	return x>0 and
							 x<mapsize and
								y>0  and
								y<mapsize and
								x+y>mapcenter and
								x+y<mapsize*1.5
end

function validpos(pos)
	local x,y=pos.x,pos.y
	return x>=0 and
								x<=mapsize and
								y>=0 and
								y<=mapsize and
								x+y>=mapcenter and
								x+y<=mapsize*1.5
end
			
function getadjtl(pos,i)
	if (i==0) return gettile(pos)
	local dst=pos+adj[i]
	if validpos(dst) then
		return gettile(dst)
	end
end

function visitadj(pos,func)
	for i = 1,6 do
		local npos = pos+adj[i]
		func(npos,gettile(npos))
	end
end

function visitadjrnd(pos,func)
	local indices=split"1,2,3,4,5,6"
	for i = 1,6 do
		local n = i+rndint(7-i)
		local npos = pos+adj[indices[n]]
		indices[n]=indices[i]
		func(npos,gettile(npos))
	end
end

function rndpos()
	return inboundposes[rndint(#inboundposes)+1]
end

function alltiles(func)
	for i,pos in ipairs(validposes) do
		func(pos,
							validtiles[i])
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
	return tl.vis and tl.light>0
end

function dijkstra(var,tovisit,check)
	repeat
		local pos=deli(tovisit,1)
		local d=gettile(pos)[var]-1
		visitadj(pos,
		function(npos,ntl)
			if ntl[var]<d
			then  
				ntl[var]=d
				if check(ntl) then
					add(tovisit,npos) 
				end
			end
		end)
	until #tovisit==0
end

function calcdist(pos,var,ignblock)
	alltiles(
	function(npos,ntl)
		ntl[var]=pos==npos and 0
		         or -1000
	end)
	dijkstra(var,{pos},
	function(tl)
		return tileflag(tl,0) and 
		(ignblock or not
		(tl.ent and tl.ent.blocking))
	end)
end

function gettile(pos)
	return world[pos.x][pos.y]
end

function viscone(pos,dir1,dir2,lim1,lim2,d)
	pos += dir1
	local lastvis=false
	local notfirst=false
	for i=ceil(lim1),flr(lim2) do
	 local tlpos=pos+i*dir2
	 if validpos(tlpos) then
			local tl = gettile(tlpos)
			local vis = passlight(tl)
			tl.vis = tileflag(tl,5) or
												(tl.typ==tywall and
												 player.pos.x<
												 tlpos.x)
			if vistoplayer(tl) then
			 tl.explored=true
			end
			local splitlim=-1
			if vis then 
				if notfirst and
					not lastvis then
					lim1=i-0.5
				end
				if i == flr(lim2) then
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
			lastvis=vis
			notfirst=true
		end
	end
end

function calcvis(pos)
	alltiles(
	function(npos,tl)
		tl.vis = npos == pos
	end)
	for i=1,6 do
		viscone(pos,adj[i],adj[(i+1)%6+1],0,1,1)
	end
end

function calclight()
 local tovisit={}

 alltiles(
 function(pos,tl)
		ent = tl.ent
		tl.light = gamestate=="gameover" and 
		           (ent==player and 1 or -20) or
		           (ent and ent.light or -20)
		tl.lightsrc = tl.light>=2
		if tl.light>0 then
			add(tovisit,pos)
		end
	end)
	dijkstra("light",tovisit,passlight)
end

function updatemap()
	calclight()
	calcdist(player.pos,"pdist",true)
	calcvis(player.pos)
end
-->8
--utility

function screenpos(pos)
	return vec2(pos.x*12,
							 				 pos.y*8+pos.x*4) 
end

function entscreenpos(ent)
	return screenpos(ent.pos)+
	        vec2(-2.5,-6.5)
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

--this too
function hexline(p1,p2,func)
	local dist=hexdist(p1,p2)
	for i=0,dist do
		if func(hexnearest(
							lerp(p1,p2,i/dist))) then
			return
		end
	end
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
	        lerp(p1,p2,1/dist)
	       )-p1
end

function axisinput(pos,neg)
	return tonum(btnp(pos))-
								tonum(btnp(neg))
end

function vec2list(str)
	local vals = split(str)
	local ret = {}
	for i=1,#vals,2 do
		add(ret,vec2(vals[i],vals[i+1]))
	end
	return ret
end

function assigntable(table,str,delim1,delim2)
 for i,var in 
		ipairs(split(str,delim1 or ","))
	do
		local pair=split(var,delim2 or ":")
		table[pair[1]]=pair[2]
	end
end

function rndint(maxval)
	return flr(rnd(maxval))
end

function rndp(p)
	return rnd()<(p or 0.5)
end

function lerp(a,b,t)
	return (1-t)*a+t*b
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
    end,
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

function setanim(ent,anim)
	ent.anim,ent.animt,
	ent.animloop=
		split(entdata[anim],""),0,
		false
		
	if ent.anim[1]=="w" then
		waitforanim=true
		ent.animwait=true
	end
end

function checkidle(ent)
	if ent.idleanim then
	 setanim(ent,ent.idleanim)
	else
		ent.anim=nil
		ent.animframe=0
	end
end

function create(typ,pos,behav,group)
	local ent = {typ=typ,pos=pos,
							behav=behav,group=group,
							xface=1,yface=-1,
							animframe=0,animt=1,
							animspeed=0.5,
							animflip=false,
							animoffset=vec2(0,0),
							animheight=1,
							deathanim="death",
							atkanim="eatk",
							deathsfx=41}
	assigntable(ent,entdata[typ])						
	
	if ent.pos then
		ent.tl=gettile(ent.pos)
		ent.tl.ent = ent
		ent.renderpos=entscreenpos(ent)
	end
	
	ent.truname=ent.ai and 
		rnd(split"jeffr,jenn,fluff,glarb,greeb,plort,rust,mell,grimb")..
		rnd(split"y,o,us maximus,ox,erbee,elia")
	add(ents,ent)
	ent.maxhp=ent.hp
	ent.statuses={}
	if ent.flippable or ent.ai and
	   rndp() then
		ent.xface *= -1
	end
	if ent.ai and rndp() then
		ent.yface *= -1
	end
	checkidle(ent)
	if ent.behav=="sleep" then
		setanim(ent,"sleep")
	end
	return ent
end

function setstatus(ent,name,str)
	ent.statuses[name]=split(str)
end

function tickstatuses(ent)
	for k,v in pairs(ent.statuses) do
		v[1]-=1
		if v[1]<=0 then
			ent.statuses[k]=nil
			if k=="TORCH" then
				ent.wpn.lit=false
				ent.wpn.typ+=1
			end
		end
	end
	if ent==player then
		ent.light=ent.wpn and ent.wpn.lit and 4 or 1.5
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
					ent.animoffset=vec2(0,0)
			 end
			end
		else
			
			ent.animflip=char=="f"
			if char=="l"then
			 ent.animloop=index+1
			 ent.animt+=rnd(#anim-index-1)
			elseif char=="r" then
				ent.animwait=false
			elseif char=="z" and
			 vistoplayer(ent.tl) 
			then
		 	animtext("z",ent,true)
			elseif char=="_" then
				destroy(ent)
			elseif char=="v" then
			 ent.animoffset.y+=ent.animt/4
			elseif char=="c" then
				ent.animheight=1-
													ent.animoffset.y/8
			elseif char=="b" then
				ent.pal=redpal
				ent.fillp=true
				animtext(".",ent,false,8,3,6)
			elseif char=="a" then
				ent.animoffset=
				(ent.movratio or 0.25)*
					screenpos(
						atkinfo[2]-
						ent.pos)
				sfx(33)
			elseif char=="d" then
				local b = atkinfo[1]
			 if atkinfo[3] then--hits
					sfx(b.hp<=atkinfo[4] and
					    b.deathsfx or 34)
					b.flash=true
					if b.hurtsfx then
						sfx(b.hurtsfx)
					end
					hurt(b,atkinfo[4])
				else
					aggro(b.pos)
				end	
			end
			ent.animt+=1
			tickanim()
		end
	end--tickanim()
	
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

function canmove(ent,pos,speial)
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
				    player.tl.light>=2)				 
end

function findmove(ent,var,goal,special)
	local tl = ent.tl
	local bestscore=-2
	visitadjrnd(ent.pos,
	function(npos,ntl)
		if canmove(ent,npos,special)
		then
		 local score=
		 							(abs(tl[var]-goal))-
		 							(abs(ntl[var]-goal))
		 if ntl.ent and 
		 	ntl.ent.blocking then
		 	score-=0.5
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
		
		if btnp(🅾️) then
			tock = not tock
			sfx(40,-1,not tock and 16 or 0, 8)
			return true --wait 1 turn
		end
		
		local movx,movy=
		axisinput(1,0),axisinput(3,2)
		
		if movx != 0 then
			movy = 0
		end
		
		if	ent.yface != movx then
			movy -= movx
		end
		local yfacechange =
					btnp(❎) or 
					(movy!=0 and
					 movy!=ent.yface)
		if yfacechange then
			ent.yface *= -1
		end
		
		if movx!=0 or movy!=0 then
			local dst=pos+
										vec2(movx,movy)
			local dst2=dst-
										vec2(0,ent.yface)
			if canmove(ent,dst) then
				move(ent,dst,true) 
				return true
			elseif movx!= 0 and
			 canmove(ent,dst2) then
				move(ent,dst2,true) 
				return true
			end
		end
		if yfacechange then
		 setanim(ent,"turn")
		 sfx(39)
		end
		return false
	elseif ent.ai and ent.canact and
	 ent.behav != "dead" then
	 --ai
	 function checkseesplayer()
	 	if seesplayer(ent) then
			 pseen=true
			 lastpseenpos=player.pos
			end
	 end
	 if ent.behav=="hunt" then
		 if ent.pack then
		 	ent.pdist = rndp() and 0 or -2
		 elseif ent.runaway then
		 	ent.pdist = ent.tl.pdist>=-1 and
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
					setbehav(ent,"wander")
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
			setbehav(ent,"search")
			setsearchpos(lastpseenpos)
		end
  ent.canact=true
	end
end

function setbehav(ent,behav)
	if ent.behav != behav then
		if ent.behav=="sleep" then
		 checkidle(ent)
		end
		
		ent.behav = behav
		if behav == "hunt" then
			animtext("!",ent)
			sfx(ent.alertsfx)
		elseif behav == "search"
		 --and vistoplayer(ent.tl)
		then
			animtext("?",ent)
		end
		ent.canact = false 
	end
end

function setsearchpos(pos)
	if (searchpos == pos)return
 lastpseenpos=pos
	calcdist(pos,"search")
	searchpos=lastpseenpos
end

function aggro(pos)
	setsearchpos(player.pos)
	calcdist(pos,"aggro",true)
	for i,ent in ipairs(ents) do
		if ent.ai and
		   ent.behav != "dead" and
					ent.tl.aggro>=-3
		then
			if seesplayer(ent) then
				setbehav(ent,"hunt")
				pseen=true
			elseif ent.behav != "hunt"
			then
				setbehav(ent,"search")
			end
		end
	end
end

function destroy(ent)
	del(ents,ent)
	ent.tl.ent=nil
end

function hurt(ent,dmg)
	ent.hp-=dmg
	if ent.hitshake then
		shake=1
	end
	if ent.hp<=0 then
		setbehav(ent,"dead")
		setanim(ent,ent.deathanim)
		waitforanim=true
		if ent==player then
			gamestate="gameover"
			--music(8)
			calclight()
		end
	end
	aggro(ent.pos)
end

function hitp(a,b)
	if b.armor then
	 local diff=a.atk-b.armor
	 return (max(diff,0)+1)/
	        (abs(diff)+2)
	end
	return 1
end

function interact(a,b,wpn)
 local hit = rndp(hitp(wpn,b))
 setanim(a,a.atkanim)
 waitforanim=true
 a.atkinfo={b,b.pos,hit,wpn.dmg}
end

function move(ent,dst,playsfx)
	local dir = hexdir(ent.pos,dst)
	local dsttile = gettile(dst)
	ent.lasttl=ent.tl
	
	if dsttile.ent then
		interact(ent,dsttile.ent,
		         ent.wpn or ent)
	else
		ent.tl.ent = nil
		ent.pos=dst
		dsttile.ent = ent
		ent.tl=dsttile
		
		if ent.moveanim then
			setanim(ent,ent.moveanim)
		end
		
		if playsfx then
			if dsttile.typ==tlonggrass then
			 sfx(37)
			elseif dsttile.typ==tshortgrass or
										dsttile.typ==tflatgrass then
				sfx(10)
			elseif dsttile.typ==txbridge or
										dsttile.typ==tybridge then
				sfx(38)
			elseif dsttile.typ==40 then
				sfx(43)--bonez			
				aggro(dst)	
			else
				sfx(35)
			end
		end
	end

	if dir.x != 0 then 
		ent.xface = sgn(dir.x)
 end
 if dir.y != 0 then
 	ent.yface = sgn(dir.y)
 elseif x != 0 then
  ent.yface = sgn(dir.x)
 end
	
	if dsttile.typ==tlonggrass then
		dsttile.typ=tflatgrass
	end
end
-->8
--level generation

function genmap(startpos)
	printh("genmap()")
	
	world={}
	ents={}
	inboundposes = {}
	validposes = {}
	validtiles = {}
	for x=0,mapsize do
	 world[x] = {}
		for y=0,mapsize do
		 world[x][y] = tile(tempty)
		end
	end
	for y=0,mapsize do
	 for x=0,mapsize do
	 	local pos=vec2(x,y)
			if validpos(pos) then
				add(validposes,pos)
				add(validtiles,gettile(pos))
				if inbounds(pos) then
					add(inboundposes,pos)
				end
			end
	 end
	end
	
	entropy=1.5
	if rndp() then
		gencave(startpos)
	else
		genroom(startpos)
	end
	postproc(startpos)
	
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
		 
	h=flr(h/4+1)*4
	w+=w%2
	yoffset=ceil(rnd(h-1))
	local minpos=pos+
														vec2(-ceil(rnd(w-2)+1)
																			+ceil(yoffset/2),
																			-yoffset)
	minpos.x+=(minpos.x)%2
	minpos.y=flr(minpos.y/4)*4+1
	local maxpos=minpos+
								vec2(w-flr(h/2),h)
	offset=minpos-pos
	openplan=rndp()
	local wvec = vec2(w,0)
	if not 
	  (validpos(minpos) and
				validpos(minpos+wvec) and
				validpos(maxpos) and
				validpos(maxpos-wvec) or
				p==startp)
	then
		return genroom(rndpos())
	end
	entropy-=0.15+rnd(0.1)
	local crumble = rnd(0.25)
	if (entropy<0) return
	for y=0,h do
	 local alt=(pos.y+offset.y+y+1)%2
		offset.x -= alt
		local xwall = y==0 or
										y==h
		for x=0,w do
			local ywall = x==0 or
											x==w
			npos = pos+offset+vec2(x,y)
			if inbounds(npos) then
				tl=gettile(npos)
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
			end
		end
	end
	
	if rndp(0.15) then
		gencave(rndpos())				 
	end
	genroom(rndpos())			
end

function gencave(pos)
	 
	local tl = gettile(pos)
	if(tl.typ==tempty)tl.typ=tcavefloor
	
	entropy -= 0.013
	if inbounds(pos) then
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
	local y = ceil(rnd(15))
	tl = gettile(pos)
	if (manmade(tl)) y+=16
	settile(tl,mget(typ,y))
	typ2=mget(typ+1,y)
	tl.flip=rndp()
	tl.genned=true
 if typ2 != 0 then
  if typ2 < 64 then
 		tl.bg=typ2
	 else
 		create(typ2,pos)
 	end
 end									
end

function postgen(pos, tl, prevtl)
	tl.postgenned=true
	visitadjrnd(pos,
	function(npos,ntl)
		if genable(ntl) and not
					ntl.postgenned then
			if not ntl.genned then
				gentile(tl.typ,npos)
			end
			postgen(npos, ntl, genable(tl) and tl or prevtl)
		end
	end)
end

function connectareas(pos,permissive)
	for i=1,20 do
		--what a mess
	 calcdist(pos,"pdist")
	 
		local unreach={}
		local numtls=0
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
			
		local bestdist = 100
		
		for j=1,200 do
			if #unreach==0 then
				return
			end
			local p1=rnd(unreach)
			local tl1,diri=
			gettile(p1),ceil(rnd(6))
			
			if manmade(tl1) and
			   permissive and
			 (diri==3 or diri==6) then
					diri-=ceil(rnd(2))
			end
			local dir=adj[diri]
			if (not dir) break--wtf??
			local p2=p1+rndint(18)*dir
			if validpos(p2) then
				local tl2=gettile(p2)
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
				local nav = navigable(tl)
				if not nav then
				 if manmade(tl) then
				 	tl.typ=tdunjfloor
				 elseif tl.typ == thole then
				 	if bestdiri==2 
				 				or bestdiri==5 then
				 		tl.typ=tybridge
				 	else
				 		tl.typ=txbridge
				 		tl.flip=bestdiri==1 or 
				 		        bestdiri==4
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

function notblocking(pos)
	function navat(i)
		return navigable(getadjtl(pos,i))
	end
	local lastnav=navat(6)
	local numnavreg=0
	for i=1,6 do
		local nav = navat(i)
		if nav and not lastnav then
			numnavreg+=1
		end
		lastnav=nav
	end
	
	return numnavreg<2
end

function postproc(pos)
	
 connectareas(pos)
	
	--delete bridges lol
	alltiles(
	function(pos,tl)
		if tl.typ==txbridge or
					tl.typ==tybridge then
			settile(tl,thole)
		end			
	end)
	
	--fill out manmade area tiles
	postgen(pos, 
									gettile(pos),
									gettile(pos))
	
	connectareas(pos)
	
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
	
	connectareas(pos,true)
	local numholes=0
	
	alltiles(
	function(pos,tl)
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
			uptl=getadjtl(pos,2)
			uprighttl=getadjtl(pos,3)
			righttl=getadjtl(pos,4)
			if uptl and righttl and
			 uprighttl and
				uptl.typ==tywall and
				genable(uprighttl) and
				genable(righttl) 
			then
				tl.typ=tywall
			end
		elseif tl.typ==tywall then
			--swap y walls for x
			righttl=getadjtl(pos,4)
			if righttl.typ==txwall then
				tl.typ=txwall
			end
		elseif tl.typ==thole and
									tl.pdist>-1000 then
			numholes+=1
		end
	end)
	
	--create exit hole if needed
	if numholes==0 then
		local bestdist=0
		local tilesfound=0
		while tilesfound<10 do
		 testpos=rndpos()
		 tl=gettile(testpos)
		 pdist=tl.pdist
		 if navigable(tl) and
		    pdist<0 and
		    pdist>-1000 and
		    notblocking(testpos) then
		 	if pdist<bestdist then
		 	 bestdist=pdist
		 	 besttl=tl
		 	end
		 	tilesfound+=1
		 end
		end
		
	 settile(besttl,thole)
	end
	
	if not player then
		player = create(64,pos)
	else
	 player.tl=gettile(pos)
  player.pl.ent = player
  add(ents,player)
	end
	updatemap()
	
	--spawn entities										
	wanderdsts={}
	local numspawned=0
	local tospawn=flr(2+rnd(1.5)+rnd(1.5))
	while numspawned<tospawn do
		local spawnpos=rndpos()
		local spawndepth=depth
		while rndp(0.45) and spawndepth <= 15 do
		 spawndepth+=1
		end
		local spawn = rnd(spawns[ceil(spawndepth/2)])
		behav=rnd{"sleep","wander"}
		local spawnedany = false
		for i,typ in ipairs(spawn) do
			local found=false
			visitadjrnd(spawnpos,
			function(npos,ntl)
				if navigable(ntl) and
							ntl.pdist < -4 and
							ntl.pdist > -1000 and
							notblocking(npos) and
							not (found or ntl.ent)
			 then
					found=true
					if not spawnedany then
						spawnedany=true
						numspawned+=1
					end
					local ent=create(typ,npos,behav,i)
					spawnpos=npos
				end
			end)
		end
	end
end
-->8
--items

--[[
runics???
force,fire,ice,warning,curse??

orbs[green,orange,purple,pink,cyan,yellow,red,silver:
ench,life,info,air,
light,fire,ice,teleport,invis??

cloaks[navy,cyan,gold,red]:
protection,darksight,
recharging,vampirism

amulets[gold,silver,pewter,bronze]:
protection,darksight,
recharging,pacifism

staffs[oaken,driftwood,ebony,purpleheart]:
fire,lightning,ice,blinking
]]

inventory={}

function unequip(slot)
 local item=player[slot]
 if item then
 	local typ=item.typ
 	if typ=="torch" then
 		item.lit=false
 	end
 end
end

function equip(item)
	unequip(item.slot)
	player[item.slot]=item
	if item.lit then
		setstatus(player,"TORCH",item.fuel..",160,2,9")
	end
end

function addtoinventory(item)
	add(inventory,item)
end
__gfx__
fffffffffffffffffffffff000ffffffffff000fffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff
ffffff0100000fffffffff0000000ffffff0000000ffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff
000ff00100011fff00fff0000000000fff00000000000fffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff
0010110150015f0000ff0000000000dff000000000000000ffffffff0fffffff0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff
001105015010500000f0000000000ddf000000000000000dfffffff00fffffff0000000000000000fffff055d5fffffffffffffffffffffffffff0055dffffff
001d0501101000100000000000001d1f555000000000001dfffffff0d0ffffff0000000000000000ffff0511515ffffffffff000ffffffffffff055511dfffff
011d01011010101000550000000d11df1550550000000d11fffffff0d00fffff0000000000000000fff01055000dffffffff0555000fffffffff05115510ffff
0d010100000010000055505000dd11df000055505000dd11ffffff005d0f0fff0000000000000000ffff0511511dfffffff051515550ffffffff01501115d0ff
0d0100000f0000000000505551d1d11f505000505550d1d1ffff00011d00d0ffffffffffffffffffffff050151d1ffffff05050151d5ffffffff01550101d0ff
0d10ffff0ffff00100500005511dd1df5055500005501dd1fff000011501d0ffffff2d2d2d2d2fffffff01011010ffffff5552050d510ffffffff0155d150fff
0110050fffffff0000505550011d1ddf0005505550001d1dff0500001101d00ffffdfffffffffdffffff01115d10f1ffff505555d151010ffffff0015500f1ff
010ffffffffff0f0000015505d111d00555000155055111dff01100115001d00ff2fffffffffff2fffff01511550111ff050512151511110ffff00100100111f
0001fffffffffff1005500005d1d100f1550550000551d100111010111001150fdfffffffffffffdfff05000000dffff0020505051550000fff05000000dffff
00001ffff00f50100055505001dd00fffff055505000dd00f011010110d01010ff2fffffffffff2ffff105505550110ff051505050511100fff105505550110f
ff000011000011000000505551d00fffffff00505550d00fff0011010050100ffffdfffffffffdffff0011000001100fff555151d501100fff0011000001100f
fff0000000000000fff000055100fffffffffff0055000fffff01111101110ffffff2d2d2d2d2ffffff00110111000fffff00555511000fffff00110111000ff
ffffffffffffffffffffff0000fffffffffffffff000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff042222242fffffffffffffffffff
fffffffffffffffffffffffffffffffffffff0bbb00fffffffff3ffffffb3f33fff000110111ffffffffffffffffffffffff150000050ffffff000550111ffff
fffffffffffffffffffffffffffffffffff10bbbbbbbf1fff33ff3fff0b0f3ffff011d005111f10fffffffffffffffffffff005222202fffff0111000111f10f
ffffffffffffffffffffff0ff00fffffff10b11bbbbd111ffff3ff3f33ff3ffff01150dd1d5015d0ffffffffffff3fffffff050000050ffff011110110001110
1ffffffffffffffffffffff0f5fffffffff055511b5dffffffff3f3fff3fbfff00005550050d0000fffffffffff3ffffffff042222240fff0000001111050001
fffffffffff1ffffffff0ff50f00fffff01055155d501100fffffbfbffb00ffff011000050050100fffff3fffff3ffffffff021000100ffff001000010111100
fffff1ffffffffffffffff00ffffffffff0000155d01100fffff0b0bfbffffffff0011510050500fffffff3ffff3ffffffff042222242fffff0011110001100f
fffffffffffffffffffffffffffffffffff00100001000fffffffffbfffffffffff00150110005fffff3ff3f3ff3f3ffffff050000020ffffff00110111000ff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffff3ffffffffff666666666fffffff3f3f3f3ff3ffffffffffff505ffffffffff5ffffffff
fff000110111fffffff01111111110fffff01111111110fffffffffffbfffffffff6dddd6dddddffffff3f3ff3bf3ffffffffff5502202ffffff5055d11000ff
ff0111000111f10fff0111111111110fff0111111111110ffffffffffff3ffffff6dddd6dddddddfffff3f3ff3b03fffffff05502202202fffff1000000055ff
f011110110001110f011100111111110f011111111111110fffff3fffffbfffff6dddd6dddddd6ddffff3ff3f3ffbffff505202202205504fff15500d00555ff
000000111101000001111111111111110101111111111111fffff3ff3fffffff6dddd6ddd6dd6dddfffff3f3fbffbfff022022022055044fff00555dd00500f1
f011000010111100f011111110011110f011111111100110fffffbf3fffffffffddddddd6dddddddfffffbf3fbff00fff02202505404fffff051005d10d11100
ff0011110001100fff0111111111110fff0111111111100ffffffffbffffffffffddddd6dddddddfffff0b0bffffffffff055044ffffffffff001111055d100f
fff00110111000fffff01111111110fffff01111111110fffffffffffffffffffffddd6dddddddfffffffffbfffffffffff44ffffffffffffff00510111000ff
fff67ffffffffffffffffffffffffffffff11fffff999fffffffffffffffffffff11f1ffffffffffffffffffff88d8fffff7fffffffffcffffffffffffffffff
fff62ffffffffffffff22fffffffffffff1001ff333333fffffffffffffffffff100101ffffffffffffcfffff822828fffc77fffffffcfcfffffffffffffffff
ff888ffffff3f3fffff223fffff3f3ffff1003ffb3333344ffffffffffff4f4f10000001ffffffffffc7cfff2f88fffefcc777ffffffcdcfffffff8f9989ffff
ff88dfffffbbb3f6ff22234fff44439ff100038fb3333b42ffffffffffff444f05000550fffeeeffffc7cffff8288228ffdccfffffffdddffffff88988888fff
ff88d6ffffbbbf6fff222f4fff4445f9f100014f4bbbb92ffff4f4ffff44422f11101111ffe227effccdccfffef28282ffdccfffcffccdff889f8598855588ff
ff882fffffbbb3ffff22234fff222366f100034ffbbbb4ffffff55fff44422fffff1ffffffe222effffcfffff2f28f2ffffcfffffccdddffff899988888f8fff
ff2f2fffff444fffff222f4fffddd99ff10001fff2222fffff5555ff442402ffffffffffffe20eeffffffffff288822ffffdfffff22dfdffff2888882086ffff
ffd0dfffff202fffff222fffffd0dffff10001fff2002ffffe544ffff202fffffffffffffe2222efffffffff2882822ffffffffffdfdfffffff262226fffffff
fff67ffffffffffffffffffffffffffffff11fffff997fffffffffffffffffffff11f1ffffffffffffffffffff8888fffff7fffffffffcffffffffffffffffff
fff22ffffffffffffff22fffffffffffff1001ff333993fffffffffffffffffff100101ffffffffffffcfffff828228fffc77fffffffcfcfffffffffffffffff
ff882ffffff3f3fffff323fffff3f3ffff13031f99333bffffffffffffffffff10500001ffffffffffc7cfff2f88fff2fcc777ffffffcfcfffffff8fffffffff
ff8d9fffffb333ffff2333ffff4333fff103331f99b33b44ffffffff4fffffff05580850fffeeeffffc7cffff8288228ffdccfffcfff6c6f889ff888f99fffff
ff86dfffffbbbff6ff222f4fff44299ff1000181499bbf42ffffffff24424f4f11101111ffe227effccdccfff8f28288ffdccffffccfdcffff898558888a8fff
ff826fffffbbbf6fff222f4fff2445f9f1000141f449942ffef4f4fff422444ffff1ffffffe222effffcfffff2f28f2ffffcfffffddcddffff289855588888ff
ff2f2fffff44b3ffff22234fffdd4366f1000341f2244fffff5555fff204240fffffffffffe20eeffffffffff288822ffffdfffffdfd22fffff228888822ffff
ffd0dfffff202fffff222f4fffd0d99ff100011ff2002fffff0555fffff202fffffffffffe2222efffffffff2828882ffffffffffffdfdfffffff22226006fff
ffffffffffffffffffffc4cfffffffffff11ff8fffffffffffffffffff6fff6f11ffff11ffffffffffcccffffffffffffff7ffffffffffffffff8fff98ffffff
fff67fffffffffffff2ec4cffffffffff1051878ffffff6ffffffffffff64f460011f100ffffffffffffccffff28ff28ffc77efffffffffffff888f9888fffff
fff88fffff7666ffff223c4cfff3f3fff1003184ffff9996f6ff6ffffff6444650001005fffffffffffffccfffff88d8ecc777eeff2ddc77ff85588982ff88ff
ff8886fff763f36fff22223cff4443fff1000531ff333336ff4f46fff4f4442615000051fffffffffffcfccff8682262ffdccffffff2c7c7ffff65888888858f
ff88dffff3bbb3f6ff222ec4f4444f9ff100001ff33333b6ff6556ffff444226f100051ffffffffffffcc77cfff68226ffdccfffcf2cddd7ffff6f8988855fff
f8822fffffbbbfffff22efc4ff224f9ff10001fff333bb94ff5555fff4244f2fff1011ffffeeeeefffcd7ccff2862f26fffcfffffccdd2dfff89ff89882f6fff
ff2f2fffff444fffff22effcffddd9fff10001fff2222942ff544fffffff4ffffff1fffffe22227efffccfff28862226fffdffffd2dfdffffff8999882ff6fff
fd00dffff4004fffff222fffffd0dffff10001ff200002fffe5fffffff00ffffffffffffe222002efffcffff888e822effffffffffffffffffff88888066ffff
fffffffffffffffffffffcffffffffffff11ff8fffffffffffffffffffffffff11ffff11ffffffffffffcffffffffffffff7ffffffffffffffff8fff9a8fffff
fff67fffffffffffff2ec4cffffffffff1051878ffffff6fffffffffffffffff0011f100fffffffffffffcfff628ff28ffc7effffffffffffff888f98888ffff
fff22fffffffffffff3234cffff3f3fff1303141ffff9996ffffffffffffff6f50001005fffffffffffffccfff6f8868eeee7eeeff2ddc77ff85588982fff8ff
ff822ffffff3f36fffbb3c4cff4333fff1bb3141ff333976ffffffff4f624f4615000051ffffffffffccfccfff628286ffdcefffcff2c7c7ff8ff6588888858f
ff6d9fffffb333f6ff222e3cff44499ff1000531f3333336ff64f6fff4464446f158081ffffffffffcdccccfff688286ffdccffffccdc7c7fffff69888556f8f
f86226ffffbbbff6ff222ec4f4425ff9f100001ff94bbb66fef6556f42462406ff1011ffffeeeeeffcc7ccfff2882f86fffcffffddd26d6fff896f98882f6fff
ff6f2fffff44bf66ff22efc4ff435ff9f10001fff9924446ff56556fff262f26fff1fffffe22227efffc7cff28882288fffdfffffffd2dfffff8998888f6ffff
fd00dffff4002377ff222fffffd0d99ff10001ff29444426ff55ff5ffff4fff4ffffffffe222002effffcfff8888822effffffffffdfdfffffff8868286fffff
fff67ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fff62fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff99ffffffffffffffff8ffffdffffffffffffffffffffffffffffffffffffff
ff888fffffffffbfffffffffffffffffffffffffffffffffffffffffffffffffff899ffffffffffffff8fffffffffcfffff40ffffff50ffffff94ffffff65fff
ff88d6fffffff44ffffafffffffffffffffff7fffffffffffffff4ffffff97ffff998ffffffccffffff88fffffffffffff4ff4ffff5ff5ffff9ff9ffff6ff6ff
ff88dffffff44ffffff9fffffff5ffffffffdfffffff7fffffff5d6fffff997fff544fffffccc7ffff898ffffffffffffff49ffffff56ffffff9affffff67fff
f8822ffff44ffffffff4fffffff4fffffff4ffffff56fffffff4f6fffff5f9fffff5ffffffffdfffff8998ffffffffdfff4fffffff5fffffff9fffffff6fffff
ff22ffffffffffffffffffffffffffffff4fffffff5fffffff4fffffff5fffffff554ffffcf2d2fffff88fffffffffffffffffffffffffffffffffffffffffff
ff0dfffffffffffffffffffffffffffff4ffffffffffffffffffffffffffffffff505ffffdf00fffffffffffffcfffffffffffffffffffffffffffffffffffff
fff67ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8fffffffffffffff8ffffffffffffffffffffffffffffffffffffffffffff
fff22fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff899fffffffffffff88fffffcffffffffffffffffffffffffffffffffffffff
ff882fffffffffcfffffffffffffffffffffffffffffffffffffffffffffffffff998ffffffcffffff898fffffffffffff9fffffff8fffffffbfffffffcfffff
ff8d9ffffffff66ffffaffffffffffffffffffffffffffffffffffffffffffffff998ffffffcfffff88988fffffffdffff9999ffff8888ffffbbbbffffccccff
ff86dffffff66ffffff9fffffff5ffffffffffffffff7fffffffffffffff97ffff454fffcfffffcff899998ffffffffffff999fffff888fffffbbbfffffcccff
f82626fff66ffffffff4fffffff4ffff44ffffffff56fffffffff4fffff5997ffff5fffffcfffcfff899998fffffffcffffff9fffffff8fffffffbfffffffcff
fff22fffffffffffffffffffffffffffff44ffffffdfffffff445d6fff5ff9ffff554fffffffffffff8988ffffdfffffffffffffffffffffffffffffffffffff
ff0dffffffffffffffffffffffffffffffffd7fffffffffffffff6ffffffffffff505fffccfffccff8ffff8fffffffffffffffffffffffffffffffffffffffff
fffffffffffffffff988fffffffffffffffffffffffffffffffffffffffffffffff9ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffa9998ffffffff6fffffffff7ff6667fff66676fffffff6ffff998fffffffffffff88ff8fffffffffffffffffffffffffffffffffffffffff
ffffffffffffff8f9fff98ffffffff6fffffff6fffff6f6f656ff67fffffff6fff999ffffffdffffff8888fffdfffffffffccffffffaaffffff88ffffff66fff
fffffffffffff55ff4fff98fffffff6ffffff46fffff5ff664ffff67ffffff6fff899fffffd5ffffff89898ffffffcffffcd7cffffa97affff8278ffff6576ff
fffffffffff55ffffffffffffffff56fffff4ffffffffff6ffffff66fffff66fff554fffff51bbfff899998fffffffdfffcddcffffa99affff8228ffff6556ff
fffdd8fff55fffffffffffffffff445ffff4fffffffffffffffffffffffff66ffff5ffffff5bb5fff889998ffffffffffffccffffffaaffffff88ffffff66fff
f2288887ffffffffffffffffffffffffffffffffffffffffffffff66fff5557fff554fffff5155ffff88988fffcfffffffffffffffffffffffffffffffffffff
d8888886fffffffffffffffffffffffffffffffffffffffffffffffffffff99fff505ffff0505fff88ffff8fffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffff66ffff6fffffffffffffffffffffff8fffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6fffffffffffffffffffff898ffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffefffffffffffffff6fffffffffffffff6fffffff66fffff6ffffffffffffffffffff8898fffcfffdfffff33ffffff99ffffffddffffffeefff
fffffffffffff22fffffff9fffffff6ff44fffffffffff6fffffff66ffff66ffffffffffffffffffff89988fffffffffff3b73ffff9879ffffd27dffffe87eff
fffffffffff22ffffffff98fff4fff6ffff446fff5ffff6fffffff7fff5f66fffffffffffffbbbfff899998fffffffcfff3bb3ffff9889ffffd22dffffe88eff
ff8888fff22fffffff4998fffff456fffffff46fff6f76ff6f4ff6fffff577ffff54f4ffff5550fff899998ffffffffffff33ffffff99ffffffddffffffeefff
f826d226ffffffffffa98fffffff5fffffffff67fff67fff656667ffffff99fffff555fffb51110fff8888ffffffffffffffffffffffffffffffffffffffffff
d66d9227fffffffffffffffffffffffffffffffffff7fffff667ffffffffffffff5505ff555550fff8ffff88ffdfffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffff000ffffffffff000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffff0100000fffffffff0000000ffffff0000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
000ff00100011fff00fff0000000000fff00000000000fffffffffffffffffffff222fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0010110180018f0000ff0000000000dff000000000000000ffffffff0ffffffff22222ffff757fffffffffffffffffffffffffffffffffffffffffffffffffff
001108018010800000f0000000000d9f000000000000000dfffffff00fffffff022224ffff656ffffffff055d5fffffffffffffffffffffffffff0055dffffff
0019080110100010000000000000191f555000000000001dfffffff0d0fffffff12444ffff6564ffffff0511515ffffffffff000ffffffffffff055511dfffff
011901011010101000550000000d119f1550550000000d11fffffff0900fffff021114ffff5f5ffffff01055000dffffffff0555000fffffffff05115510ffff
0d010100000010000055505000dd119f000055505000dd11ffffff005d0f0ffff02440ffffffffffffff0511511dfffffff051515550ffffffff01501115d0ff
090100000f0000000000505551d1911f505000505550d1d1ffff00011d0090ffffffffff00000000ffff05015191ffffff05050151d5ffffffff01550101d0ff
0d10ffff0ffff00800500005511d919f5055500008801dd1fff000011501d0ffffffffff00000000ffff01011010ffffff5552050d510ffffffff01549150fff
0110050fffffff0000505550011d19df0005505580001d1dff0800001101d00ff242ffff00000000ffff01118910f1ffff5055559151010ffffff0015500f1ff
010ffffffffff0f0000015505d111d0f555000158058111dff01100115001d0024224fff00000000ffff01511550111ff050512151511110ffff00100100111f
0001fffffffffff1005500005d1d10ff1550550000581d10f111010111001150222444ff00000000fff05000000dffff0020505051550000fff05000000dffff
00001ffff00f80100055505001dd0fff000055505000dd0ff011010110d01010122444ff00000000fff105505850110ff051505050511100fff105505450110f
ff000811000011000000505551d0fffffff000505880d0ffff0011010050100f012444ff00000000ff0011000001100fff5551519501100fff0011000001100f
fff0000000000000ffff0005510fffffffffff0005500ffffff01111101110fff0122fff00000000fff00110111000fffff00555511000fffff00110111000ff
ffff115515150fffffffff0000fffffffffffffff000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff042992242fffffffffffffffffff
fff11015010105ffffff015500fffffffffff0bbb00fffffffff9ffffffb9f33fff000110111ffffffffffffffffffffffff150000050ffffff000880811ffff
ffd110111101011ffff10111015ffffffff10bbbbbb8f1fff33ff9fff0b0f3ffff011d005111f10fffffffffffffffffffff005222202fffff0111000111f10f
fd11001101000101ff1d1000011501ffff10b11bbb9d111ffff3ff3f99ff3ffff01150d9195015d0ffffffffffff9fffffff050000050ffff011110180001110
5151000000000100f155010100010155fff05551195dffffffff3f3fff3fbfff00005550050d0000fffffffffff9ffffffff042922240fff0000001111080000
11500011010000011150f00011000011f01155155d501100fffffbfbffb00ffff011000050050100fffff9fffff3ffffffff021000100ffff011000010111100
1101fffffffff1015001ffff00011100ff0000155d01100fffff0b0bfbffffffff0011510050500fffffff9ffff3ffffffff042222242fffff0011110001100f
101fffffffffff005001fffffff00001fff00100001000fffffffffbfffffffffff00150110005fffff3ff3f9ff3f3ffffff050000020ffffff00110111000ff
ffffff88fffffffffffffff888ffffffffffffff88fffffffffffffff9ffffffffff667777766fffffff3f3f3f3ff3ffffffffffff505ffffffffff5ffffffff
fff000110881fffffff01111111110fffff01111111110fffffffffffbfffffffff6ddd979ddddffffff3f3ff3bf3ffffffffff5904202ffffff5055d11000ff
ff0111000111f10fff0111111111110fff0111118111110ffffffffffff9ffffff6dddd69ddddddfffff3f3ff3b03fffffff05902902202fffff1000050045ff
f011110180001110f011100111111110f011111111111110fffff9fffffbfffff6dddd6d9dddd6ddffff3ff3f3ffbffff505502402405504fff15500d55455ff
000000111101000001111118111111110101111111111111fffff3ff9fffffff6dddd6ddd6dd6dddfffff3f3fbffbfff022022022055044ff0005559d0550001
f011000010111100f011111110011110f011111111100110fffffbf3fffffffffddddddd7dddddddfffffbf3fbff00fff02202505404fffff051005910d11100
ff0011110001100fff0111118111110fff0111111181100ffffffffbffffffffffddddd6dddddddfffff0b0bffffffffff055044ffffffffff0011110559100f
fff00110111000fffff01111111110fffff01111111110fffffffffffffffffffffddd6dddddddfffffffffbfffffffffff44ffffffffffffff00510111000ff
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888777777888eeeeee888eeeeee888eeeeee888eeeeee888eeeeee888eeeeee888888888888888888ff8ff8888228822888222822888888822888888228888
8888778887788ee88eee88ee888ee88ee888ee88ee8e8ee88ee888ee88ee8eeee88888888888888888ff888ff888222222888222822888882282888888222888
888777878778eeee8eee8eeeee8ee8eeeee8ee8eee8e8ee8eee8eeee8eee8eeee88888e88888888888ff888ff888282282888222888888228882888888288888
888777878778eeee8eee8eee888ee8eeee88ee8eee888ee8eee888ee8eee888ee8888eee8888888888ff888ff888222222888888222888228882888822288888
888777878778eeee8eee8eee8eeee8eeeee8ee8eeeee8ee8eeeee8ee8eee8e8ee88888e88888888888ff888ff888822228888228222888882282888222288888
888777888778eee888ee8eee888ee8eee888ee8eeeee8ee8eee888ee8eee888ee888888888888888888ff8ff8888828828888228222888888822888222888888
888777777778eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee888888888888888888888888888888888888888888888888888888888888888
11111eee1ee11ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111711111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e1e1e1e1111111111111111111111111111111111111771111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111777111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1e1eee1111111111111111111111111111111111111777711111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111771111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111117111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111166166616611666166616661171161616661166166611711666166616661166166616611666166616661111166616661666116616661666166617171ccc
11111611161116161666161616161711161616111611111617111666161616161611161116161161161116161111166616161616161111611116161111711c1c
11111611166116161616166616661711161616611611166617111616166616661611166116161161166116611111161616661666166611611161166117771c1c
11111616161116161616161616111711166616111611161117111616161616111611161116161161161116161171161616161611111611611611161111711c1c
11111666166616161616161616111171116116661166166611711616161616111166166616161161166616161711161616161611166116661666166617171ccc
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e1111111666116616661166161611111111111111661666166616661666166611711cc1117111111111111111111111111111111111
11111e111e1e1e111e1e1e11111111611616161616111616111117771111161116161611161611611611171111c1111711111111111111111111111111111111
11111e111e1e1e111eee1e11111111611616166116111666111111111111161116611661166611611661171111c1111711111111111111111111111111111111
11111e111e1e1e111e1e1e11111111611616161616111616111117771111161116161611161611611611171111c1111711111111111111111111111111111111
11111eee1ee111ee1e1e1eee11111161166116161166161611111111111111661616166616161161166611711ccc117111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111666166116611666116616661661161616661661166611661666161611711666116616661166161611711111111111111111111111111111111111111111
11111616161616161161161611611616161616111616116116161616161617111161161616161611161611171111111111111111111111111111111111111111
11111666161616161161161611611616161616611616116116161661166617111161161616611611166611171111111111111111111111111111111111111111
11111616161616161161161611611616166616111616116116161616111617111161161616161611161611171111111111111111111111111111111111111111
11111616166616661161166116661616116116661616116116611616166611711161166116161166161611711111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111666116116161666166611711666116616661166161611711111111111111111111111111111111111111111111111111111111111111111111111111111
11111611161616161161161617111161161616161611161611171111111111111111111111111111111111111111111111111111111111111111111111111111
11111661161616161161166617111161161616611611166611171111111111111111111111111111111111111111111111111111111111111111111111111111
11111611166116161161161117111161161616161611161611171111111111111111111111111111111111111111111111111111111111111111111111111111
11111666116611661666161111711161166116161166161611711111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111166166616111166161116661166161616661171117111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111611161616111611161111611611161611611711111711111111111111111111111111111111111111111111111111111111111111111111111111111111
11111611166616111611161111611611166611611711111711111111111111111111111111111111111111111111111111111111111111111111111111111111
11111611161616111611161111611616161611611711111711111111111111111111111111111111111111111111111111111111111111111111111111111111
11111166161616661166166616661666161611611171117111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111ddd1d1d11dd1ddd11dd11d11ddd11d1111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111ddd1d1d1d1111d11d111d111d1d111d111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111ddd1ddd1d1d1d1d1ddd11d11d111d111d1d111d111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111d1d1d1d111d11d11d111d111d1d111d111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111d1d11dd1dd11ddd11dd11d11ddd11d1111111111111111111111111111111111111111111111111111111111111111111111111111111111111
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
16661616166616611166166616611666166611111ccc111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11611616161616161616161616161611161617771c1c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11611616166116161616166116161661166111111c1c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11611616161616161616161616161611161617771c1c111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11611166161616161661161616661666161611111ccc111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111116161666166116661666166616661616166616611171117111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111116161616161616161161161111611616161616161711111711111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111116161666161616661161166111611616166116161711111711111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111116161611161616161161161111611616161616161711111711111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111111661611166616161161166611611166161616161171117111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee1111117116161666166616661666116616661666166116661666117111111eee1eee1eee1e1e1eee1ee111111111111111111111111111111111
111111e11e111111171116161616116111611611161616161616161611611666111711111e1e1e1111e11e1e1e1e1e1e11111111111111111111111111111111
111111e11ee11111171116161666116111611661161616611666161611611616111711111ee11ee111e11e1e1ee11e1e11111111111111111111111111111111
111111e11e111111171116661616116111611611161616161616161611611616111711111e1e1e1111e11e1e1e1e1e1e11111111111111111111111111111111
11111eee1e111111117116661616166611611611166116161616161616661616117111111e1e1eee11e111ee1e1e1e1e11111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee1111166616161666166111661666166116661666111111111ccc11111eee1e1e1eee1ee111111111111111111111111111111111111111111111
111111e11e111111116116161616161616161616161616111616177717771c1c111111e11e1e1e111e1e11111111111111111111111111111111111111111111
111111e11ee11111116116161661161616161661161616611661111111111c1c111111e11eee1ee11e1e11111111111111111111111111111111111111111111
111111e11e111111116116161616161616161616161616111616177717771c1c111111e11e1e1e111e1e11111111111111111111111111111111111111111111
11111eee1e111111116111661616161616611616166616661616111111111ccc111111e11e1e1eee1e1e11111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111666116616661666166111111ccc1ccc1c1111cc1ccc1111111111111111111111111111111111111111111111111111111111111111111111111111
111111111616161116111611161617771c111c1c1c111c111c111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111666166616611661161611111cc11ccc1c111ccc1cc11111111111111111111111111111111111111111111111111111111111111111111111111111
111111111611111616111611161617771c111c1c1c11111c1c111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111611166116661666161611111c111c1c1ccc1cc11ccc1111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111116661611166616161666166616161666166616661666166111111ccc1ccc1c1111cc1ccc111111111111111111111111111111111111111111111111
1111111116161611161616161611161616161616116111611611161617771c111c1c1c111c111c11111111111111111111111111111111111111111111111111
1111111116661611166616661661166116161666116111611661161611111cc11ccc1c111ccc1cc1111111111111111111111111111111111111111111111111
1111111116111611161611161611161616661616116111611611161617771c111c1c1c11111c1c11111111111111111111111111111111111111111111111111
1111111116111666161616661666161616661616166611611666166611111c111c1c1ccc1cc11ccc111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1eee11111ee111ee1eee111116661666161616661666161616661661117116661611166616161666166611111666161116661616166616661111
1111111111e11e1111111e1e1e1e11e1111111611616161616111161161616161616171116161611161616161611161611111616161116161616161116161111
1111111111e11ee111111e1e1e1e11e1111111611666166116611161161616611616171116661611166616661661166111111666161116661666166116611111
1111111111e11e1111111e1e1e1e11e1111111611616161616111161161616161616171116111611161611161611161611711611161116161116161116161111
111111111eee1e1111111e1e1ee111e1111111611616161616661161116616161616117116111666161616661666161617111611166616161666166616161171
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822282228882822282288288888888888888888888888888888888888888888882228222822282888882822282288222822288866688
82888828828282888888828282888828888288288288888888888888888888888888888888888888888882888882888282888828828288288282888288888888
82888828828282288888822282228828822288288222888888888888888888888888888888888888888882228822882282228828822288288222822288822288
82888828828282888888888288828828828888288282888888888888888888888888888888888888888888828882888282828828828288288882828888888888
82228222828282228888888282228288822282228222888888888888888888888888888888888888888882228222822282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
000000000000000000000000000000004000840084002c00b300ee00be00ee0072016300ba016b01f30109096b01b301b30173017301730123017d016b01ea0104040404000000000000000000000000040404040000000000000000000000000404040400000000000000000000000004040404000000000000000000000000
0000000000000000008000000000000000000000000000000000000000000000040000000000000300000000000000000400000000000003000000000000000001010000000000000000000000000000010110002000700000003000300030000000000010000407040000090401040004000407040004070487040904003000
__map__
464647474141424b4b4b0000000000001011000014150000000000001c1d000020210000242500002829000000002e2f303132333435363738393a3b00000000bc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0046474741434900000000008f0000003200000000000000000000003200000020000000320000003200000000003200320032003200363200003a3200000000bd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
460047474244494e4c4c0000000000003200000000000000000000003200000020000000320000003200000000003200320032003200363200003a3200000000a0000000000000000000000000000000000000000000000000000000000000000000000010001000100000000000000000000000000000000000000000000000
46470047004200004d4d0000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a3200000000b00000000000000000000000000000000000000000000000000000000000000000001000203436323a3400000000000000000000000000000000000000000000
0047410041004d454d4d0000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000081000000000000000000000000000000000000000000000000000000000000001000363236343a32000000000000000000000000000000000000000000000000
4700414143414d454d4d0000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000091000000000000000000000000000000000000000000000000000000000000003a333a3426323a32000000000000000000000000000000000000000000000000
0041004100414d4200000000000000001600000000000000000000003200000020000000320000003200000000003200320032003200363200003a3200000000a10000000000000000000000000000000000000000000000000000000000000000003a3226323a34000000000000000000000000000000000000000000000000
00004141494200444e4e0000000000001600000000000000000000003200000020000000320000003200000000003200320032003200363400003a3400000000b10000000000000000000000000000000000000000000000000000000000000000003a3226343a32000000000000000000000000000000000000000000000000
0000000049424c4400000000000000001600000000000000000000003200000020000000320000003200000000003200320032003400363400003a3400000000000000000000000000000000000000000000000000000000000000000000000000003a3226320000000000000000000000000000000000000000000000000000
000041410000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003400363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000042424841454c000000000000000016000000000000000000000032000000200000003200000032000000000032003200340034003a3200003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004841454d000000000000000016000000000000000000000032000000200000003200000032000000000032003200340034003a32000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000048434843004d000000000000000032890000000000000000000032000000200000003200000032000000000032003200340034003a34000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000043454d000000000000000032890000000000000000000032000000100000003200000032000000000032003200340020003200000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000494845004200000000000000000034890000000000000000000032000000100000003200000032000000000032003200340036323200000036340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000004800450049000000000000000034890000000000000000000032000000340000003200000032000000000032003200320036343400000036340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004100444900000000000000001011000014150000000000001c1d000020210000242500002829000000002e2f303132333435363738393a3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000494245444200000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004345484200000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004400480000000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004d480000000000000000000000000030000000000000002ec80000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000434d00000000000000000000000000002e000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000430000000000000000000000000000002e0000000000000030000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004200000000000000000000000000002e0000000000000030000000200000002ea900003000000000001c00300030003000363000003a2e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004900000000000000000000000000002e0000000000000030000000200000002ea900003000000000002ea93000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003e0000000000000030000000200000002ea9000030000000000028003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004800000000000000000000000000003e0000000000000030000000200000002ea900003000000000002ec83000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004800000000000000000000000000003e0000000000000030000000200000002ea9000030000000000024003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
9203002000661026510c6710267008661016310866001661106710366009641026610567006651016710b640066610167103670046510267109640016610a671026400466103671076310b650036610667103631
002700200cf7113f7111f7112f710bf7110f711af710df7115f710af7121f710df7112f7118f710af710ff7112f711bf7110f710ff710af710ff7111f710ff710cf7115f7118f710df710bf7111f710bf710ff71
520709003e65331651006113e62330621006113e61311611006150060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
9002060017a1417a1017a1017a1017a1017a100060009a0009a0009a0009a0009a0009a0000600006000060000600006000060000600005000050000600006000050000500005000050000500005000050000500
00020a001414015151151611216111141061330613105121051200512102100011000210003100031000210003100081000810000100001000010000100001000010000100001000010000100001000010000000
900117000062000621056310a64112641186512065110051060310302101621006210262000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
a8010600322303f2613e2413c231342010b2002e2002f2002320000200002000020000200002002d2001d20000200002000020000200002000020000200002000020000200002000020000200002000020000200
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
940310000163500000206250001106041090110b531095110a5210b5010a5110b5010c5010b5010a5110b50100000000000000000000000000000000000000000000000000000000000000000000000000000000
c40406003a62532525136003f52500605026010160100505006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04020c0006553000030955300003000031153300003000031a5330000300003355230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480603003e00013051000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
930100003b3153461034615270000000000000000000000000000000002b6002e600000000000000000000003931530610306151a6052900029000290053b6000000000000000003b600000003b600000003b600
90070b001967316333073130060315333073131530315303153130010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000000000000000000000000000
000b02000f05300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90010000076150061100615245003160000600006000060031625006100061100601006010060100605006010060100601006010060500000000000560004600000000000000000000000a600086050000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04a014001882018820188251b8001c80019810198241981518c001bc001a8101a8101a815240002a8001b8101b8151a8050000000000000000000000000000000000000000000000000000000000000000000000
6ca00014155141e52621517155120e5111e5141e5141e502175141f5061c51418516185121a5111a5121b5111b5141b5121b5121b5133f5000050000500005000050000500005000050000500005000050000500
6150000014e0424e2015c2415c301ac541ac401ac301ac301ac2015c3019c3019c4019c3419c351bc000000000000000000000018c2418c5418c5018c3018c4018c541cc161cc301cc301cc2017c5016c5416c55
00a0140019d7019d7019d7019d7019d0019d7018d7018d7018d0018d7017d7017d7017d7017d7017d0017d701dd701dd7027d00000001dd000000000000000000000000000000000000000000000000000000000
91a014001fb441fb401fb441fb401fb351de301eb441eb401eb201eb201fb441fb401fb441fb401fb2020b4420b4020b3020b2020b10000002d4002c400000000000000000000000000000000000000000000000
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
00 3d383c7f
02 3d3c3b7c
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 3d3b397c
00 3d3f3e3c
02 3d3b3a3c
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

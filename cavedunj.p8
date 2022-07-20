pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--game loop

depth=1

function _init()
	adj=vec2list
	"-1, 0,\
	 0 ,-1,\
		1 ,-1,\
		1 , 0,\
		0 , 1,\
		-1, 1"
	
	specialtiles={}
	specialtiles[tcavewall]={
		vec2(-9,-4),--baseoffset
		vec2list--xy
		"0 ,-8,\
		 5 ,-8,\
		 13,-8,\
		 13, 4,\
		 4 , 4,\
		 2 , 4",
 	vec2list--wh
		"5,13,\
		 8,13,\
		 5,13,\
		 5, 4,\
		 11, 4,\
		 3, 4"}
		
	specialtiles[thole]={
		vec2(-8,-4),--baseoffset
		vec2list--xy
		"0, 0,\
		 4, 0,\
		 13,0,\
		 0,0,\
		 4,1,\
		 13,0",--last 3 are brick
		vec2list--wh
		"4,8,\
		 8,8,\
			3,8,\
			4,8,\
			7,7,\
			4,8,"}
			
	specialtiles[txwall]={
		vec2(-9,-2),--baseoffset
		vec2list--xy
		"12,-8,\
 		 0,-8",
		vec2list--wh
		"7 ,17,\
		 12,17"}
		 
	specialtiles[tywall]={
		vec2(-5,-2),--baseoffset
		vec2list--xy
		"9,-8,\
		 2,-8",
		vec2list--wh
		"7 ,17,\
		 7,17"}
	
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

end

function updateturn()
	for ent in all(ents) do
		if not taketurn(ent,ent.pos,ent.tl,ent.group) then
		 return
		end
	end
 for ent in all(ents) do
		postturn(ent)
	end

end

function _update()	

	updateturn()
	for ent in all(ents) do
		updateent(ent)
	end
	
	local camtarget = entscreenpos(player)
 local center = screenpos(vec2(mapcenter,mapcenter),vec2(-3,-7))
	camtarget=lerp(camtarget,
																	center,
																	0.36)
	smooth = smooth and 
		lerp(smooth,camtarget,0.25)
		or	camtarget
	campos=vec2(flr(smooth.x-63.5),
													flr(smooth.y-63.5))
	
end

function _draw()
	cls()
	camera(campos.x,campos.y)
	lfillp=localfillp(0x7d69.4,
								-campos.x,
								-campos.y)
	drawmap(world)
	pal()
	pal(15,129,1)
	fillp(█)

	for anim in all(textanims) do
	 t=time()-anim[4]
		if t>0.5 then
			del(textanims, anim)
		else
			anim[2].y-=0.5-t
			print(anim[1],
									anim[2].x+3-
									(anim[3] and cos(t*2) or 0),
									anim[2].y-6,
									t>0.433 and 5 or 7)
		end
	end
end

textanims={}

function animtext(text,ent,wavy)
	add(textanims,{text,ent.renderpos,wavy,time()})
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
]]

tempty,tcavefloor,tcavefloorvar=
0     ,50        ,52
tcavewall,tdunjfloor,tywall,txwall=
16       ,48        ,18    ,20
tshortgrass,tflatgrass,tlonggrass,tmushroom=
54         ,38       ,58         ,56
thole,txbridge,tybridge=
32   ,60      ,44

function tile(typ)
	return {typ=typ,fow=0}
end

function settile(tl,typ)
	tl.typ=typ
	tl.bg=nil
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
			fow=1
		end
		local oldfow=tl.fow
		tl.fow = mid(oldfow-1,fow,oldfow+1)
	end
	fow=tl.fow
	usingblackpal = false
	fillp(fow==3 and █	or 
						 lfillp)
	if fow==0 then
		pal(blackpal)
		usingblackpal=true
	elseif fow==1 then
		pal(darkpal,2)
	else
	 pal(1,241,2)
	end
end

function drawtl(tl,pos,flp,bg,i)
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
		if not bg and 
		   fget(litsprite,i) then
			local adjtile =
				getadjtl(pos,i)
			if adjtile and
						adjtile.lightsrc then
				typ = litsprite
			 if not usingblackpal then
					pal(8,adjtile.ent.lcol1)
					pal(9,adjtile.ent.lcol2)
			 end
			end
		end
	end
	local scrpos=
							screenpos(pos,
																	offset+
																	baseoffset)
	sspr((typ%16)*8+offset.x,
							flr(typ/16)*8+
								offset.y,
							size.x,size.y,
							scrpos.x,scrpos.y,
										size.x,size.y,
										flp)
end

function drawent(tl)
 local ent = tl.ent
	if ent and vistoplayer(tl) then
		initpal(tl)
		--fillp(█)
		local scrpos=ent.renderpos+
					vec2(ent.xface,0)
		spr(ent.typ 
						+ flr(ent.animframe)*16
						+ (ent.yface > 0 
								 and 16 or 0),
						scrpos.x,scrpos.y,
						1,1,
					 ent.xface<0)
	end
end

function drawmap()
	for drawcall in 
					all(drawcalls) do
		drawcall[1](
			unpack(drawcall[2]))
	end
end


function setupdrawcalls()
	drawcalls={}
	darkpal=split"15,255,255,255,255,255,255,255,255,255,255,255,255,255"
	blackpal=split"0,0,0,0,0,0,0,0,0,0,0,0,0,0"

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
		if lasttl and 
					navigable(lasttl) then
			drawcall(drawent,{lasttl})	
		end
		lasttl = tl		
	end)
	
end

-->8
--map stuff

mapsize,mapcenter=
20     ,10

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
	local indices=split"1,2,3,4,5,6"
	for i = 1,6 do
		local n = i+rndint(7-i)
		local npos = pos+adj[indices[n]]
		indices[n]=indices[i]
		func(npos,gettile(npos))
	end
end

function alltiles(func)
	for y=0,mapsize do
		for x=0,mapsize do
			local pos=vec2(x,y)
			if validpos(pos) then
				func(pos,gettile(pos))
			end
		end
	end
end

function tileflag(tl,i)
	return fget(tl.typ,i)
end

function navigable(tl)
	return tileflag(tl,0)
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

function calcdist(pos,var)
	var=var or "pdist"
 local tl=gettile(pos)
	alltiles(
	function(npos,ntl)
		ntl[var]=-1
	end)
	local tovisit={{pos,tl,1}}
	tl[var]=0
	repeat
		local pos,tl,d=
			unpack(deli(tovisit,1))
		if inbounds(pos) and
					navigable(tl) then
			visitadj(pos,
			function(npos,ntl)
				if ntl[var] == -1 then
					ntl[var]=d
					add(tovisit,{npos,ntl,d+1}) 
				end
			end)
		end
	until #tovisit==0
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

function calcvis(pos,tl)
	for i=1,6 do
		viscone(pos,adj[i],adj[(i+1)%6+1],0,1,1)
	end
end

function calclight(pos,tl)
 
 local maxlight=tl.light
 local minlight=maxlight
	local tovisit={}
	
	function addtovisit(pos,tl)
		local light=ceil(tl.light)
		if not tovisit[light] then
			tovisit[light]={}
		end
		maxlight=max(maxlight,light)
		minlight=min(minlight,light)
		add(tovisit[light],{pos,tl})
 end
 
 addtovisit(pos,tl)
 repeat
		while #(tovisit[maxlight])==0 do
			maxlight -= 1
			if (maxlight < minlight)return
		end
		pos,tl=unpack(deli(
							 	 tovisit[maxlight],1))
		local light=tl.light-1
		visitadj(pos,
		function(npos,ntl)
			if ntl.light<light then
				ntl.light = light
				if passlight(ntl) then
					addtovisit(npos,ntl)
				end
			elseif ntl.light >
										light+2 and
										passlight(ntl) then
					addtovisit(npos,ntl)				
			end
		end)	
	until false
end

function updatemap()
 pseen=false
	alltiles(
	function(pos,tl)
		ent = tl.ent
		tl.light = ent and ent.light or 
													(fget(tl.typ+192,7) and 
													4 or -10)--todo: do tiles need to emit light 
		tl.lightsrc = tl.light>=2
		tl.vis = ent == player
	end)
	ppos=player.pos
	calclight(ppos,gettile(ppos))
	calcdist(ppos)
	calcvis(ppos)

end
-->8
--utility

function screenpos(pos,
																			offset)
	return vec2(offset.x+pos.x*12,
							 				 offset.y+pos.y*8+
							 				  pos.x*4) 
end

function entscreenpos(ent)
	return screenpos(ent.pos,
																		vec2(-3,-6.5))
end

function hexdist(p1,p2)
	delta=p1-p2
	z,z2=-p1.x-p1.y,-p2.x-p2.y
	return (abs(delta.x)+abs(delta.y)+abs(z-z2))/2
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

function rndint(maxval)
	return flr(rnd(maxval))
end

function lerp(a,b,t)
	return (1-t)*a+t*b
end
--sort by aaaidan
--[[function sort(a,cmp)
 for i=1,#a do
 	local j=i
 	while j>1 and 
 	cmp(a[j-1],a[j]) do
 	 a[j],a[j-1]=a[j-1],a[j]
 	 j -= 1
 	end
 end
end
]]

--vec2 by mrh & felice 
vec2mt={
    __add=function(v1,v2)
        return vec2(v1.x+v2.x,v1.y+v2.y)
    end,
    __sub=function(v1,v2)
        return vec2(v1.x-v2.x,v1.y-v2.y)
    end,
    __unm=function(self)
        return vec2(-self.x,-self.y)
    end,
    __mul=function(s,v)
        return vec2(s*v.x,s*v.y)
    end,
   -- __len=function(self)
   --     return sqrt(self.x*self.x+self.y*self.y)
   -- end,
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

eplayer,erat,ejackal,egoblin=
64     ,70  ,71     ,65  
emushroom,ebrazier=
137      ,136

entdata={
[eplayer]=
"hp:20,dmg:3,light:1.5,lcol1:4,lcol2:9,playercontrolled:true",
[erat]=
"hp:3,dmg:2,ai:true,pdist:0,alertsfx:14,hurtsfx:15",
[ejackal]=
"hp:4,dmg:2,ai:true,pdist:0,alertsfx:20,hurtsfx:21",
[egoblin]=
"hp:7,dmg:3,ai:true,pdist:0,alertsfx:30,hurtsfx:11",
[emushroom]=
"hp:1,light:4,lcol1:13,lcol2:12",
[ebrazier]=
"hp:1,light:4,lcol1:4,lcol2:9,idleanim:true,animspeed:0.33,animfrom:0,animframes:3",
}


function create(typ,pos,behav,group)
	local ent = {typ=typ,pos=pos,
							behav=behav,group=group,
							xface=1,yface=-1,
							animframe=0,
							rndoffset=rnd(),
							tl=gettile(pos)}
	ent.renderpos=entscreenpos(ent)
	ent.name=rnd(split"jeffr,jenn,fluff,glarb,greeb,plort,rust,mell,grimb")..
										rnd(split"y,o,us maximus,ox,erbee,elia")
	add(ents,ent)
	ent.tl.ent = ent
	for var in 
		all(split(entdata[typ]))
	do
		pair=split(var,":")
		ent[pair[1]]=pair[2]
	end
	return ent
end

function updateent(ent)
	ent.renderpos=
		 lerp(ent.renderpos,
		      entscreenpos(ent),
		      0.5)													
	
	--todo:more flexible animations
	--     with frames&offsets 
	--     defined in tables
	if ent.idleanim then
		ent.animframe=
		 (ent.animframe+ent.animspeed
		  -ent.animfrom)%ent.animframes
		  +ent.animfrom
	end
	
	if ent.behav=="sleep" and
				vistoplayer(ent.tl) 
	then
		ent.rndoffset+=0.015
		if ent.rndoffset > 1 then
			ent.rndoffset-=1
		 animtext("z",ent,true)
		end
	end
end

function canmove(ent,pos)
	local tl=gettile(pos)
	return navigable(tl) and
	   (not tl.ent or
	    tl.ent.playercontrolled !=
	    ent.playercontrolled)
end

function seesplayer(ent)
	return ent.tl.vis and
	       (ent.tl.pdist<=1 or
				    player.tl.light>=2)				 
end

function findmove(ent,var,goal)
	local tl = ent.tl
	local bestscore=-2
	visitadj(ent.pos,
	function(npos,ntl)
		if canmove(ent,npos) then
		 local score=
		 							(abs(tl[var]-goal))-
		 							(abs(ntl[var]-goal))
			if score>bestscore then
				bestscore=score
				bestpos=npos
			end
		end
 end)
 if bestscore>-2 then
			move(ent,bestpos)
 end
end

function taketurn(ent,pos,tl,group)
	if ent.playercontrolled then
		
		--player
		local movx,movy=
		axisinput(1,0),axisinput(3,2)
		
		if movx != 0 then
			movy = 0
		end
		
		if	ent.yface != movx then
			movy -= movx
		end
		
		if btnp(5) or 
					(movy!=0 and
					 movy!=ent.yface) then
			ent.yface *= -1
		end
		
		if movx!=0 or movy!=0 then
			local dst=pos+
										vec2(movx,movy)
			local dst2=dst-
										vec2(0,ent.yface)
			if canmove(ent,dst) then
				move(ent,dst,true)
				updatemap()
			elseif movx!= 0 and
					canmove(ent,dst2) then
				move(ent,dst2,true)
				updatemap()
			else
				return false
			end
		else
			return false
		end
	elseif ent.ai and ent.canact then
	 --ai
	 function checkseesplayer()
	 	if seesplayer(ent) then
			 pseen=true
			 lastpseenpos=player.pos
			end
	 end
	 if ent.behav=="hunt" then
		 checkseesplayer()
		 findmove(ent,"pdist",ent.pdist)
			checkseesplayer()
		else
			--notice player
			function checkaggro(p)
				if seesplayer(ent)
				   and rnd() < p
				then
				 pseen=true
				 aggro(pos)
				 return true
				end
			end
			checkaggro(behav=="search"
			           and 1.0 or 0.29)
			if ent.behav=="wander" then
				if not wanderdsts[group]
				   or ent.pos==wanderdsts[group]
				   or rnd()<0.025
				then
					repeat
						wanderdsts[group]=rndpos()
						local tl = gettile(
													wanderdsts[group])
					until navigable(tl) and
											tl.pdist>=0
					calcdist(wanderdsts[group],
														group)
				end
				findmove(ent,group,0)
				checkaggro(0.29)
			elseif ent.behav=="search" 
			then
				findmove(ent,"search",0)
				if not checkaggro(1.0) and
					  ent.tl.search == 0 then
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
		ent.behav = behav
		if behav == "hunt" then
			animtext("!",ent)
			sfx(ent.alertsfx)
		elseif behav == "search" then
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
	calcdist(pos,"aggro")
	for ent in all(ents) do
		if ent.ai and
					ent.tl.aggro<=3
		then
			if seesplayer(ent) then
				setbehav(ent,"hunt")
			elseif ent.behav != "hunt"
			then
				setbehav(ent,"search")
			end
		end
	end
end

function move(ent,dst,playsfx)
	local delta=dst-ent.pos
	local dsttile = gettile(dst)
	ent.tl.ent = nil
	ent.pos=dst
	dsttile.ent = ent
	ent.tl=dsttile

	if delta.x != 0 then 
		ent.xface = sgn(delta.x)
 end
 if delta.y != 0 then
 	ent.yface = sgn(delta.y)
 elseif x != 0 then
  ent.yface = sgn(delta.x)
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
		else
			sfx(35)
		end
	end
	
	if dsttile.typ==tlonggrass then
		dsttile.typ=tflatgrass
	end
	
	return true
end
-->8
--level generation

minroomw,minroomh,roomsizevar=
       3,       2,          8
startp=1.5

function rndpos()
	return validposes[rndint(#validposes)+1]
end

function genmap(startpos)
	printh("genmap()")
	
	world={}
	ents={}
	for x=0,mapsize do
	 world[x] = {}
		for y=0,mapsize do
			world[x][y] = tile(tempty)
		end
	end
	validposes = {}
	alltiles(
	function(pos,tl)
	 if (inbounds(pos))add(validposes,pos)
	end)
	
	p=startp
	if rnd() > 0.5 then
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
	openplan=rnd()>0.5
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
	p-=0.15+rnd(0.1)
	local crumble = rnd(0.25)
	if (p<0) return
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
				if (xwall or ywall) and
						 (rnd()>crumble or alt==1 or
						 (xwall and ywall)) and
						 not (tl.typ==tdunjfloor 
						 					and openplan) 
				then
					tl.typ =
						xwall and txwall or tywall
				else
					tl.typ = tdunjfloor
				end
			end
		end
	end
	
	if rnd() < 0.15 then
		gencave(rndpos())				 
	end
	genroom(rndpos())			
end

function gencave(pos)
	 
	local tl = gettile(pos)
	if(tl.typ==tempty)tl.typ=tcavefloor
	
	p -= 0.013
	if inbounds(pos) then
		visitadj(pos,
		function(npos,ntl)
			if not genable(ntl) then
				if inbounds(npos) and 
							rnd()<p then
					gentile(tl.typ,npos)
					if genable(ntl) then
						if rnd()<0.01 then
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
	tl.flip=rnd()<0.5
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
	visitadj(pos,
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

function connectareas(pos)
	for i=1,20 do
		--what a mess
	 calcdist(pos)
	 
		local unreach={}
		local numtls=0
		alltiles(
		function(pos,tl)
			if navigable(tl) and
						tl.pdist==-1 and
						((not manmade(tl)) or
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
							tl2.pdist>=0 then
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
									tl.pdist>=0
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
	
	local numholes=0
	
	alltiles(
	function(pos,tl)
		if tl.typ==tempty then
			--add cavewalls
			for i = 1,6 do
				ntl = getadjtl(pos,i)
				if ntl and 
							(navigable(ntl) or
				   genable(ntl)) then
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
									tl.pdist>0 then
			numholes+=1
		end
	end)
	
	--replace single cavewalls
	alltiles(
	function(pos,tl)
		if tl.typ==tcavewall and 
					inbounds(pos) then
			if genable(
							getadjtl(pos,2)) and
				  genable(
							getadjtl(pos,5)) then
				gentile(tcavewall,pos)
			end
		end
	end)
	
	connectareas(pos)
	
	--create exit hole if needed
	if numholes==0 then
		local bestdist=0
		local tilesfound=0
		while tilesfound<10 do
		 testpos=rndpos()
		 tl=gettile(testpos)
		 pdist=tl.pdist
		 if navigable(tl) and
		    pdist>0 and
		    notblocking(testpos) then
		 	if pdist>bestdist then
		 	 bestdist=pdist
		 	 besttl=tl
		 	end
		 	tilesfound+=1
		 end
		end
		
	 settile(besttl,thole)
	end
	 
	player = create(eplayer,
																	pos)
	
	updatemap()
	
	--spawn entities										
	wanderdsts={}
	for i=1,5 do
		local spawnpos=rndpos()
		local spawndepth=depth
		while rnd() < 0.45 and spawndepth <= 15 do
		 spawndepth+=1
		end
		local spawn = rnd(spawns[ceil(spawndepth/2)])
		behav=rnd{"sleep","wander"}
		for typ in all(spawn) do
			local found=false
			visitadj(spawnpos,
			function(npos,ntl)
				if navigable(ntl) and
							ntl.pdist > 4 and
							notblocking(npos) and
							not (found or ntl.ent or
							vistoplayer(ntl))
			 then
					found=true
					local ent=create(typ,npos,behav,i)
					spawnpos=npos
				end
			end)
		end
	end
end
__gfx__
fffffffffffffffffffffff000ffffffffff000fffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffff0100000fffffffff0000000ffffff0000000ffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
000ff00100011fff00fff0000000000fff00000000000fffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
0010110150015f0000ff0000000000dff000000000000000ffffffff0fffffff0000000000000000000000000000000000000000000000000000000000000000
001105015010500000f0000000000ddf000000000000000dfffffff00fffffff0000000000000000000000000000000000000000000000000000000000000000
001d0501101000100000000000001d1f555000000000001dfffffff0d0ffffff0000000000000000000000000000000000000000000000000000000000000000
011d01011010101000550000000d11df1550550000000d11fffffff0d00fffff0000000000000000000000000000000000000000000000000000000000000000
0d010100000010000055505000dd11df000055505000dd11ffffff005d0f0fff0000000000000000000000000000000000000000000000000000000000000000
0d0100000f0000000000505551d1d11f505000505550d1d1ffff00011d00d0ff0000000000000000000000000000000000000000000000000000000000000000
0d10ffff0ffff00100500005511dd1df5055500005501dd1fff000011501d0ff0000000000000000000000000000000000000000000000000000000000000000
0110050fffffff0000505550011d1ddf0005505550001d1dff0500001101d00f0000000000000000000000000000000000000000000000000000000000000000
010ffffffffff0f0000015505d111d00555000555055111dff01100115001d000000000000000000000000000000000000000000000000000000000000000000
0001fffffffffff1005500005d1d100f1550550000551d1001110101110011500000000000000000000000000000000000000000000000000000000000000000
00001ffff00f50100055505001dd00ff000055505000dd00f011010110d010100000000000000000000000000000000000000000000000000000000000000000
ff000011000011000000505551d00ffffff000505550d00fff0011010050100f0000000000000000000000000000000000000000000000000000000000000000
fff0000000000000fff000055100ffffffffff00055000fffff01111101110ff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffff0000fffffffffffffff000ffffffffffffffffffff0000000000000000ffffffffffffffffffff042222242fffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffff3ffffff53f330000000000000000ffffffffffffffffffff150000050ffffff000110111ffff
fffffffffffffffffffffffffffffffffffffffffffffffff33ff3fff050f3ff0000000000000000ffffffffffffffffffff005222202fffff0111000111f10f
fffffffffffffffffffffffffffffffffffffffffffffffffff3ff3f33ff3fff0000000000000000ffffffffffff3fffffff050000050ffff011110110001110
1fffffffffffffffffffffffffffffffffffffffffffffffffff3f3fff3f5fff0000000000000000fffffffffff3ffffffff042222240fff0000001111010001
fffffffffff1fffffffffffffffffffffffffffffffffffffffff5f5ff500fff0000000000000000fffff3fffff3ffffffff021000100ffff001000010111100
fffff1ffffffffffffffffffffffffffffffffffffffffffffff0505f5ffffff0000000000000000ffffff3ffff3ffffffff042222242fffff0011110001100f
fffffffffffffffffffffffffffffffffffffffffffffffffffffff5ffffffff0000000000000000fff3ff3f3ff3f3ffffff050000020ffffff00110111000ff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffff3ffffffffff666666666fffffff3f3f3f3ff3ffffffffffff505fff0000000000000000
fff000110111fffffff01111111110fffff01111111110fffffffffff5fffffffff6dddd6dddddffffff3f3ff35f3ffffffffff5502202ff0000000000000000
ff0111000111f10fff0111111111110fff0111111111110ffffffffffff3ffffff6dddd6dddddddfffff3f3ff3503fffffff05502202202f0000000000000000
f011110110001110f011100111111110f011111111111110fffff3fffff5fffff6dddd6dddddd6ddffff3ff3f3ff5ffff5052022022055040000000000000000
000000111101000001111111111111110101111111111111fffff3ff3fffffff6dddd6ddd6dd6dddfffff3f3f5ff5fff022022022055044f0000000000000000
f011000010111100f011111110011110f011111111100110fffff5f3fffffffffddddddd6dddddddfffff5f3f5ff00fff02202505404ffff0000000000000000
ff0011110001100fff0111111111110fff0111111111100ffffffff5ffffffffffddddd6dddddddfffff0505ffffffffff055044ffffffff0000000000000000
fff00110111000fffff01111111110fffff01111111110fffffffffffffffffffffddd6dddddddfffffffff5fffffffffff44fffffffffff0000000000000000
fff67ffffffffffffffffffffffffffffff11fffff999ffffffffffffffffffff11ffddfffffffff00000000000000000000000000000000ffffffffffffffff
fff62f9ffffffffffff22fffffffffffff1001ff333333ffffffffffffffffff10011001ffffffff00000000000000000000000000000000ffffffffffffffff
ff888faffff3f3fffff223fffff3f3ffff10031f33333344ffffffffffff4f4f05000050ffffffff00000000000000000000000000000000ffffff8f9989ffff
ff88df4fff5553f6ff22234fff44439ff100038133333342ffffffffffff444f11500511fffbbbff00000000000000000000000000000000fffff88988888fff
ff88d6ffff555f6fff222f4fff4445f9f10001419333392ffff4f4ffff44422fff1011ffffb337bf00000000000000000000000000000000889f8598855588ff
ff882fffff5553ffff22234fff222366f1000341f33339ffffff55fff44422fff101ffffffb333bf00000000000000000000000000000000ff899988888f8fff
ff2f2fffff444fffff222f4fff66699ff100011ff2222fffff5555ff442402ffff1fffffffb35bbf00000000000000000000000000000000ff2888882086ffff
ffd0dfffff202fffff222fffff606ffff10001fff2002ffffe544ffff202fffffff00ffffb3553bf00000000000000000000000000000000fff262226fffffff
fff67ffffffffffffffffffffffffffffff11fffff997ffffffffffffffffffff111f1ffffffffff00000000000000000000000000000000ffffffffffffffff
fff22ffffffffffffff22fffffffffffff1001ff333993ffffffffffffffffff10001001ffffffff00000000000000000000000000000000ffffffffffffffff
ff882f9ffff3f3fffff323fffff3f3ffff13031f993333ffffffffffffffffff05500050ffffffff00000000000000000000000000000000ffffff8fffffffff
ff86dfafff5333ffff2333ffff4333fff103331f99333344ffffffff4fffffff11500011fffbbbff00000000000000000000000000000000889ff888f99fffff
ff8d6f4fff555ff6ff222f4fff44299ff100018199933f42ffffffff24424f4fff1011ffffb337bf00000000000000000000000000000000ff898558888a8fff
ff8226ffff555f6fff222f4fff2445f9f1000141f999942ffef4f4fff422444ff101ffffffb333bf00000000000000000000000000000000ff289855588888ff
ff2f2fffff4453ffff22234fff664366f1000341f2299fffff5555fff204240fff1fffffffb35bbf00000000000000000000000000000000fff228888822ffff
ffd0dfffff202fffff222f4fff60699ff100011ff2002fffff0555fffff202fffff00ffffb3553bf00000000000000000000000000000000fffff22226006fff
fff67fffffffffffffffc4cfffffffffff11ff8fffffffffffffffffff6fff6fffffffffffffffff00000000000000000000000000000000ffff8fff98ffffff
fff66fffffffffffff2ec4cffffffffff1051878fff999fff6ff6ffffff64f461ff1f1f1ffffffff00000000000000000000000000000000fff888f9888fffff
ff888ffff66666ffff22bc4cfff3f3fff100b184f3333336ff6ff6fffff64446011010106fffff6f00000000000000000000000000000000ff85588982ff88ff
ff888fff6663f36fff2222bcff4443fff10005b1f3333336ff4f46fff4f4442650000005f6fffff600000000000000000000000000000000ffff65888888858f
f6882ffff35553f6ff222ec4f4444f9ff100001ff3333336ff6556ffff44422615000551f6bbbbb600000000000000000000000000000000ffff6f8988855fff
ff882fffff555fffff22efc4ff224f9ff10001fff3333394ff5555fff4444f2ff11011fffb33337b00000000000000000000000000000000ff89ff89882f6fff
ff2f2fffff444fffff22effcff6669fff10001fff2222942ff544fffff2f4ffff101fffffb33553b00000000000000000000000000000000fff8999882ff6fff
fd00dffff4004fffff222fffff606ffff10001ff200002fffe5fffffff00ffffff100fffb335555b00000000000000000000000000000000ffff88888066ffff
fff67ffffffffffffffffcffffffffffff11ff8fffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000ffff8fff988fffff
fff22fffffffffffff2ec4cffffffffff1051878fff999ffffffffffffffffff1ff1f1f1ffffffff00000000000000000000000000000000fff888f98a88ffff
ff882fffffffffffffb2b4cffff3f3fff1b0b141f333973fffffffffffffff6f011010106fffff6f00000000000000000000000000000000ff85588982fff8ff
ff86dffffff3f3ffff33bc4cff4333fff133b141f9933336ff6ff6ff4f624f4650000005f6fffff600000000000000000000000000000000ff8ff6588888858f
ff8d6fffff5333f6ff222ebcff44499ff10005b199933336fff6f46ff446444615500051f6bbbbb600000000000000000000000000000000fffff69888556f8f
ff8226ff635555f6ff222ec4f4425ff9f100001f99333366fef6556f42462406ff1011fffb33337b00000000000000000000000000000000ff896f98882f6fff
ff2f2fff66645f6fff22efc4ff435ff9f10001ff9924466fff56556fff262f26f101fffffb33553b00000000000000000000000000000000fff8998888f6ffff
ffd0dffff46666ffff222fffff60699ff10001ff9444262fff55ff5ffff4fff4ff100fffb335555b00000000000000000000000000000000ffff8868286fffff
ffffffffffffffffffffffffffffffff00000000000000000000000000000000fff8ffffffffffffffffffffffffffff00000000000000000000000000000000
ffffffffffffffffffff11ffffffffff00000000000000000000000000000000ff99ffffffffffffffff8ffffdffffff00000000000000000000000000000000
fffffffffffffffffff1001fffffff7f00000000000000000000000000000000ff899ffffffffffffff8fffffffffcff00000000000000000000000000000000
ffffffffffffffffff1001fffffff6ff00000000000000000000000000000000ff998ffffffccffffff88fffffffffff00000000000000000000000000000000
fffbbffffffccfffff1051ffffff4fff00000000000000000000000000000000ff549fffffccc7ffff898fffffffffff00000000000000000000000000000000
ffb37bffffcd7cfff10051fffff4ffff00000000000000000000000000000000fff5ffffffffdfffff8998ffffffffdf00000000000000000000000000000000
ffb33bffffcddcffff111fffff4fffff00000000000000000000000000000000ff554ffffcf2d2fffff88fffffffffff00000000000000000000000000000000
fffbbffffffccfffffffffffffffffff00000000000000000000000000000000ff505ffffdf00fffffffffffffcfffff00000000000000000000000000000000
ffffffffffffffffffffffffffffffff00000000000000000000000000000000fff8ffff00000000fff8ffffffffffff00000000000000000000000000000000
ffffffffffffffffffffffffffffffff00000000000000000000000000000000ff899fff00000000ff88fffffcffffff00000000000000000000000000000000
ffffffffffffffffffffccffffffff7f00000000000000000000000000000000ff998fff00000000ff898fffffffffff00000000000000000000000000000000
fffffffffffffffffffccffffffff6ff00000000000000000000000000000000ff998fff00000000f88988fffffffdff00000000000000000000000000000000
fff99ffffffaaffffffccffffffd6fff00000000000000000000000000000000ff454fff00000000f899998fffffffff00000000000000000000000000000000
ff9879ffffa97affffcccffffffdffff00000000000000000000000000000000fff5ffff00000000f899998fffffffcf00000000000000000000000000000000
ff9889ffffa99affffffffffffffffff00000000000000000000000000000000ff554fff00000000ff8988ffffdfffff00000000000000000000000000000000
fff99ffffffaafffffffffffffffffff00000000000000000000000000000000ff505fff00000000f8ffff8fffffffff00000000000000000000000000000000
ffffffffffffffffffffffffffffffff00000000000000000000000000000000fff9ffffffffffffffffffffffffffff00000000000000000000000000000000
fffffffffffffffffffffffffffff7ff00000000000000000000000000000000ff998fffff4fffffff88ff8fffffffff00000000000000000000000000000000
ffffffffffffffffffff99ffffff65ff00000000000000000000000000000000ff999ffff42fffffff8988fffdffffff00000000000000000000000000000000
fffffffffffffffffff99ffffffff45700000000000000000000000000000000ff899ffff42fffffff89898ffffffcff00000000000000000000000000000000
fffddffffff88ffffff99fffffff4f6f00000000000000000000000000000000ff554ffff42224fff899998fffffffdf00000000000000000000000000000000
ffd27dffff8278ffff999ffffff4ffff00000000000000000000000000000000fff5fffff44442fff889998fffffffff00000000000000000000000000000000
ffd22dffff8228ffffffffffffffffff00000000000000000000000000000000ff554ffff42f42ffff88988fffcfffff00000000000000000000000000000000
fffddffffff88fffffffffffffffffff00000000000000000000000000000000ff505ffff4ff4fff88ffff8fffffffff00000000000000000000000000000000
ffffffffffffffffffffffffffffffff00000000000000000000000000000000ffffffffffffffffffff8fffffffffff00000000000000000000000000000000
ffffffffffffffffffffffffffffff7f00000000000000000000000000000000fffffffffffffffffff898ffffffffff00000000000000000000000000000000
ffffffffffffffffffffbbfffffff99700000000000000000000000000000000ffffffffffffffffff8898fffcfffdff00000000000000000000000000000000
fffffffffffffffffffbbffffffffd9900000000000000000000000000000000ffffffffffff222fff89988fffffffff00000000000000000000000000000000
fffeeffffff66ffffffbbfffffffdfff00000000000000000000000000000000fffffffffff444fff899998fffffffcf00000000000000000000000000000000
ffe87effff6576ffffbbbffffffdffff00000000000000000000000000000000ff54f4fffff42ffff899998fffffffff00000000000000000000000000000000
ffe88effff6556ffffffffffffffffff00000000000000000000000000000000fff555fff224222fff8888ffffffffff00000000000000000000000000000000
fffeeffffff66fffffffffffffffffff00000000000000000000000000000000ff5505ff444444fff8ffff88ffdfffff00000000000000000000000000000000
fffffffffffffffffffffff000ffffffffff000fffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffff0100000fffffffff0000000ffffff0000000ffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
000ff00100011fff00fff0000000000fff00000000000fffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
0010110180018f0000ff0000000000dff000000000000000ffffffff0fffffff0000000000000000000000000000000000000000000000000000000000000000
001108018010800000f0000000000d9f000000000000000dfffffff00fffffff0000000000000000000000000000000000000000000000000000000000000000
0019080110100010000000000000191f555000000000001dfffffff0d0ffffff0000000000000000000000000000000000000000000000000000000000000000
011901011010101000550000000d119f1550550000000d11fffffff0900fffff0000000000000000000000000000000000000000000000000000000000000000
0d010100000010000055505000dd119f000055505000dd11ffffff005d0f0fff0000000000000000000000000000000000000000000000000000000000000000
090100000f0000000000505551d1911f505000505550d1d1ffff00011d0090ff0000000000000000000000000000000000000000000000000000000000000000
0d10ffff0ffff00800500005511d919f5055500008801dd1fff000011501d0ff0000000000000000000000000000000000000000000000000000000000000000
0110050fffffff0000505550011d19df0005505580001d1dff0800001101d00f0000000000000000000000000000000000000000000000000000000000000000
010ffffffffff0f0000015505d111d0f555000558058111dff01100115001d000000000000000000000000000000000000000000000000000000000000000000
0001fffffffffff1005500005d1d10ff1550550000581d10f1110101110011500000000000000000000000000000000000000000000000000000000000000000
00001ffff00f80100055505001dd0fff000055505000dd0ff011010110d010100000000000000000000000000000000000000000000000000000000000000000
ff000811000011000000505551d0fffffff000505880d0ffff0011010050100f0000000000000000000000000000000000000000000000000000000000000000
fff0000000000000ffff0005510fffffffffff0005500ffffff01111101110ff0000000000000000000000000000000000000000000000000000000000000000
ffff115515150fffffffff0000fffffffffffffff000ffffffffffffffffffff0000000000000000ffffffffffffffffffff054992252fffffff001800000fff
fff11015010105ffffff015500ffffffffffffffffffffffffff9ffffff59f330000000000000000ffffffffffffffffffff151100050ffffff00011088100ff
ffd110111101011ffff10111015ffffffffffffffffffffff33ff9fff050f3ff0000000000000000ffffffffffffffffffff005224202fffff0111000111010f
fd11001101000101ff1d1000011501fffffffffffffffffffff3ff3f99ff3fff0000000000000000ffffffffffff9fffffff050000050ffff011110880001110
5151000000000100f155010100010155ffffffffffffffffffff3f3fff3f5fff0000000000000000fffffffffff9ffffffff052922450fff0000001111010000
11500011010000011150f00011000011fffffffffffffffffffff5f5ff500fff0000000000000000fffff9fffff3ffffffff021000100ffff011000010811100
1101fffffffff1015001ffff00011100ffffffffffffffffffff0505f5ffffff0000000000000000ffffff9ffff3ffffffff054422252fffff0011110001100f
101fffffffffff005001fffffff00001fffffffffffffffffffffff5ffffffff0000000000000000fff3ff3f9ff3f3ffffff000000000ffffff00110111000ff
ffff008800000ffffffffff888ffffffffffffff88fffffffffffffff9ffffffffff667777766fffffff3f3f3f3ff3ffffffffffff505fff0000000000000000
fff00011088100fffff01111111110fffff01111111110fffffffffff5fffffffff6ddd979ddddffffff3f3ff35f3ffffffffff5904202ff0000000000000000
ff0118000111010fff0111111111110fff0111118111110ffffffffffff9ffffff6dddd69ddddddfffff3f3ff3503fffffff05902902202f0000000000000000
f011110880001110f011100111111110f011111111111110fffff9fffff5fffff6dddd6d9dddd6ddffff3ff3f3ff5ffff5055024024055040000000000000000
000000111801000001111118111111110101111111111111fffff3ff9fffffff6dddd6ddd6dd6dddfffff3f3f5ff5fff022022022055044f0000000000000000
f011000010111100f011111110011110f011111111100110fffff5f3fffffffffddddddd7dddddddfffff5f3f5ff00fff02202505404ffff0000000000000000
ff0011180001100fff0111118111110fff0111111181100ffffffff5ffffffffffddddd6dddddddfffff0505ffffffffff055044ffffffff0000000000000000
fff00110111000fffff01111111110fffff01111111110fffffffffffffffffffffddd6dddddddfffffffff5fffffffffff44fffffffffff0000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888eeeeee888eeeeee888eeeeee888777777888eeeeee888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88ee88eee88ee888ee88ee888ee88778787188ee888ee88888888888888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee8eeee8eee8eeeee8ee8eeeee8ee8777878171eee8eeee88888e88888888888888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8eeee8eee8eee888ee8eeee88ee87778881711e1888ee8888eee8888888888888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee8eeee8eee8eee8eeee8eeeee8ee87777781717171e8ee88888e88888888888888888888ff888ff888822228888228222888882282888222288888
888eee888ee8eee888ee8eee888ee8eee888ee8777771177777188ee888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee87777171777771eeee888888888888888888888888888888888888888888888888888888888888888888888888
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee17777771eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee117771eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeefffeffeefffefffefffefffefffeeffeeeeee17771eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeefeeefefeefeeefeeefeeefeefeeefeeeeeeeee111eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
efffefffeffeefefeefeeefeeefeeefeeffeefffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeefeeefefeefeeefeeefeeefeefeeeeefeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeefffefefeefeefffeefeefffefffeffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
17711666161611661661161616161661166116161177111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1c1c1c1c1ccc11111cc111111c111ccc11cc1c1c1ccc11111c1c11111c1111cc11cc1c111cc111111cc11ccc11111c1111cc11cc1c111ccc11111cc11ccc1c1c
1c1c1c1c1c1c11c111c111111c1111c11c111c1c11c111c11c1c11111c111c111c1c1c1111c111c111c1111c11111c111c111c1c1c11111c11c111c1111c1c1c
11111ccc1ccc111111c111111c1111c11c111ccc11c111111ccc11111c111c111c1c1c1111c1111111c111cc11111c111c111c1c1c111ccc111111c11ccc1111
11111c1c1c1111c111c111c11c1111c11c1c1c1c11c111c1111c11c11c111c111c1c1c1111c111c111c1111c11c11c111c111c1c1c111c1111c111c11c111111
11111c1c1c1111111ccc1c111ccc1ccc1ccc1c1c11c11111111c1c111ccc11cc1cc11ccc1ccc11111ccc1ccc1c111ccc11cc1cc11ccc1ccc11111ccc1ccc1111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
17711666166616661666166616661666166611771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
17111611161616161616111611611611161611171777111111111111111111111111111111111111111111111111111111111111111111111111111111111111
17111661166116611666116111611661166111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
17111611161616161616161111611611161611171777111111111111111111111111111111111111111111111111111111111111111111111111111111111111
17711666166616161616166616661666161611771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1c1c1c1c1ccc11111cc111111c111ccc11cc1c1c1ccc11111c1c11111c1111cc11cc1c111cc111111c1c11111c1111cc11cc1c111ccc11111ccc11111ccc1cc1
1c1c1c1c1c1c11c111c111111c1111c11c111c1c11c111c11c1c11111c111c111c1c1c1111c111c11c1c11111c111c111c1c1c11111c11c11c1c111111c11c1c
11111ccc1ccc111111c111111c1111c11c111ccc11c111111ccc11111c111c111c1c1c1111c111111ccc11111c111c111c1c1c111ccc11111ccc111111c11c1c
11111c1c1c1111c111c111c11c1111c11c1c1c1c11c111c1111c11c11c111c111c1c1c1111c111c1111c11c11c111c111c1c1c111c1111c1111c11c111c11c1c
11111c1c1c1111111ccc1c111ccc1ccc1ccc1c1c11c11111111c1c111ccc11cc1cc11ccc1ccc1111111c1c111ccc11cc1cc11ccc1ccc1111111c1c111ccc1ccc
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
17711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
17711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111661666166616661666166611711666161616661111166611661166111116661666161616661616111111661666
1e111e1e1e1e1e1111e111e11e1e1e1e111116111616161116161161161117111161161616161111161616161611111116161611161616161616111116111616
1ee11e1e1e1e1e1111e111e11e1e1e1e111116111661166116661161166117111161166616661111166616161666111116611661166616661616111116111661
1e111e1e1e1e1e1111e111e11e1e1e1e111116111616161116161161161117111161111616111171161116161116117116161611161616161666117116161616
1e1111ee1e1e11ee11e11eee1ee11e1e111111661616166616161161166611711161166616111711161116611661171116661666161616161161171116661616
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e1111111666166116661111111111111177166616161666111116661616166611111666116611661111166611661166111111111111
11111e111e1e1e111e1e1e1111111611161611611111177711111171116116161616177711611616161611111616161616111777161616161611111111111111
11111e111e1e1e111eee1e1111111661161611611111111111111771116116661666111111611666166611111666161616661111166616161666111111111111
11111e111e1e1e111e1e1e1111111611161611611111177711111171116111161611177711611116161111711611161611161777161116161116117111111111
11111eee1ee111ee1e1e1eee11111666161611611111111111111177116116661611111111611666161117111611166116611111161116611661171111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111666166616161666161611111666166616161666161611111166166611661616166611111166166611661616166611111111
11111111111111111111111111111616161116161616161617771616161116161616161611111611161616161616161617771611161616161616161611111111
11111111111111111111111111111661166116661666161611111661166116661666161611111611166116161616166611111611166116161616166611111111
11111111111111111111111111111616161116161616166617771616161116161616166611711616161616161616161117771616161616161616161111711111
11111111111111111111111111111666166616161616116111111666166616161616116117111666161616611166161111111666161616611166161117111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111616166616661166166611111cc1111116161666166611661666111111111cc1111111111111111111111111111111111111
111111111111111111111111111116161611161616111611177711c11111161616111616161116111777111111c1111111111111111111111111111111111111
111111111111111111111111111111611661166616111661111111c111111666166116661611166111111ccc11c1111111111111111111111111111111111111
111111111111111111111111111116161611161616111611177711c11171111616111616161116111777111111c1117111111111111111111111111111111111
11111111111111111111111111111616161116161166166611111ccc171116661611161611661666111111111ccc171111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111116661661166616661666166616661666166611111ccc17711111111111111111111111111111111111111111111111111111
111111111111111111111111111116161616116116661611161616161666161117771c1c11711111111111111111111111111111111111111111111111111111
111111111111111111111111111116661616116116161661166116661616166111111c1c11771111111111111111111111111111111111111111111111111111
111111111111111111111111111116161616116116161611161616161616161117771c1c11711111111111111111111111111111111111111111111111111111
111111111111111111111111111116161616166616161611161616161616166611111ccc17711111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111666166116661111166616661661166116661666166611661166111116661661166611661166166616661666166116661166116611711666166116661171
11111611161611611111161616111616161616111616161616161611177716111616116116111611161616111611161616161616161117111611161611611117
11111661161611611111166116611616161616611661166616161666111116611616116116661611166116611661161616661616166617111661161611611117
11111611161611611111161616111616161616111616161116161116177716111616116111161611161616111611161616111616111617111611161611611117
11111666161611611171161616661616166616661616161116611661111116661616116116611166161616661666161616111661166111711666161611611171
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111666166116661111166116661666166611111bbb1bb11bb1117111bb1bbb1b111bbb1bbb1c1c1ccc1ccc1ccc1ccc1ccc11111ccc1ccc1cc11cc111111ccc
11111611161611611111161616161666161117771b1b1b1b1b1b17111b111b1b1b1111b111b11c1c11c11c111c111c111c1c111111c11c111c1c1c1c11111c11
11111661161611611111161616661616166111111bb11b1b1b1b17111bbb1bbb1b1111b111b1111111c11cc11cc11cc11cc1111111c11cc11c1c1c1c11111cc1
11111611161611611111161616161616161117771b1b1b1b1b1b1711111b1b111b1111b111b1111111c11c111c111c111c1c11c111c11c111c1c1c1c11c11c11
11111666161611611171161616161616166611111b1b1b1b1bbb11711bb11b111bbb1bbb11b111111cc11ccc1c111c111c1c1c111cc11ccc1c1c1c1c1c111c11
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111bbb1bb11bb1117111bb1bbb1b111bbb1bbb1c1c1c1c111111cc11111c1c11cc111111cc1c1c11111ccc1ccc
11111111111111111111111111111111111111111b1b1b1b1b1b17111b111b1b1b1111b111b11c1c1c1c11111c1c11111c1c1c1111111c1c1c1c11111c111c1c
11111111111111111111111111111111111111111bb11b1b1b1b17111bbb1bbb1b1111b111b111111ccc11111c1c11111c1c1ccc11111c1c11c111111cc11cc1
11111111111111111111111111111111111111111b1b1b1b1b1b1711111b1b111b1111b111b11111111c11c11c1c11c11c1c111c11c11c1c1c1c11c11c111c1c
11111111111111111111111111111111111111111b1b1b1b1bbb11711bb11b111bbb1bbb11b111111ccc1c111cc11c1111cc1cc11c111cc11c1c1c111ccc1c1c
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111bbb1bb11bb11171166616611666116611111666166116661171111111111111111111111111111111111111111111111111111111111111111111111111
11111b1b1b1b1b1b1711161116161161161111111611161611611117111111111111111111111111111111111111111111111111111111111111111111111111
11111bbb1b1b1b1b1711166116161161166611111661161611611117111111111111111111111111111111111111111111111111111111111111111111111111
11111b1b1b1b1b1b1711161116161161111611711611161611611117111111111111111111111111111111111111111111111111111111111111111111111111
11111b1b1bbb1bbb1171166616161161166117111666161611611171111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111166166616661666166616111666117116661166116611711111166616611666111111111111166616611666111111111111111111111111111111111111
11111611161111611161116116111611171116161616161111171111161116161161111117771111161116161161111111111111111111111111111111111111
11111611166111611161116116111661171116661616166611171111166116161161111111111111166116161161111111111111111111111111111111111111
11111616161111611161116116111611171116111616111611171111161116161161111117771111161116161161111111111111111111111111111111111111
11111666166611611161166616661666117116111661166111711171166616161161111111111111166616161161111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee11ee1eee111116161666166611111eee1ee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111161616161616111111e11e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e1e1ee11111161616661661111111e11e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111166616161616111111e11e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111ee11e1e111111611616161611111eee1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822282888882822882228222888888888888888888888888888888888888888882228222822282828882822282288222822288866688
82888828828282888888888282888828882882888882888888888888888888888888888888888888888888828882828282828828828288288282888288888888
82888828828282288888822282228828882882228222888888888888888888888888888888888888888888228882822282228828822288288222822288822288
82888828828282888888828882828828882888828288888888888888888888888888888888888888888888828882828288828828828288288882828888888888
82228222828282228888822282228288822282228222888888888888888888888888888888888888888882228882822288828288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
000000000000000000000000000000004000840084002c0004000000000000007200040000006b07b30009096b01b300b30073077300730723877d096b01030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000008000000000000000000000000000000000000000000000000000000007000700000000000000000000000300030003000700000303000001010000000000000000000000000000010110002000700000000000000000000000000000000407b30009090400040004000407040004072387040904000000
__map__
464647474100000000000000000000001011000000000000000000000000000020210000000000000000000000002e2f303132333435363738393a3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
004647474100000000000000000000003200000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
460047474200000000000000000000003200000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
464700470000000000000000000000003400000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
004741004100000000000000000000003400000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
470041414300000000000000000000003400000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
004100410000000000000000000000001600000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000041414900000000000000000000001600000000000000000000000000000020000000000000000000000000000000000032003200363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004900000000000000000000001600000000000000000000000000000020000000000000000000000000000000000032003400363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000041410000000000000000000000001600000000000000000000000000000020000000000000000000000000000000000032003400363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000424248000000000000000000000016000000000000000000000000000000200000000000000000000000000000000000340034003a3200003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000048000000000000000000000016000000000000000000000000000000200000000000000000000000000000000000340034003a32000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000484348000000000000000000000032890000000000000000000000000000200000000000000000000000000000000000340034003a34000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000032890000000000000000000000000000100000000000000000000000000000000000340020003200000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000494845000000000000000000000034890000000000000000000000000000100000000000000000000000000000000000340036323200000036340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000004800000000000000000000000034890000000000000000000000000000340000000000000000000000000000000000320036343400000036340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000494200000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004300000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004400000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004300000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004300000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a2e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000030003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000002e003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000002e003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000002e003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000030882e0030003000362e000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000020002e002e002e003a2e0000362e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000036302e002e002e003000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000362e2e002e002e002e0000002e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
8004081018514185150f5240f5351354413555165641656518574185750f5740f5751357413575165741657518564185650f5540f5551354413545165341653518524185250f5140f51513514135151651416515
900100000064000620006100061000610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900200000062403630036000062000610006000060000600056000060005600016000060000600006000060000600006000060000600005000050000600006000050000500005000050000500005000050000500
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9203002000661026510c6710267008661016310866001661106710366009641026610567006651016710b640066610167103670046510267109640016610a671026400466103671076310b650036610667103631
0027021e09f5413f6111f7112f710bf7110f711af710df7115f710af7121f710df7112f7118f710af710ff7112f711bf7110f710ff710af7118f7111f710ff710cf7115f710af711ff710bf7111f710bf6107f55
520700003e65331651006113e62330621006113e61311611006150060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
9002000017a1417a1017a1017a1017a1017a100060009a0009a0009a0009a0009a0009a0000600006000060000600006000060000600005000050000600006000050000500005000050000500005000050000500
000100000d1501416112171111700e1410e130041310e170031300312102121021200110002100031000310002100031000810008100001000010000100001000010000100001000010000100001000010000100
900100000062000621056310a64112641186512065110051060310302101621006210262000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
a8010000322303f2613e2413c231342010b2002e2002f2002320000200002000020000200002002d2001d20000200002000020000200002000020000200002000020000200002000020000200002000020000200
aa0500003e6143a5213f5213f5113d501005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
aa0500003e6143e5213f521355112f511005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
d402000000120071501a2701665013260122601015009250041500e15000250052000024004200031000023000100001000023000100001000010000100001000010000100001000010000200002000020000200
d4080000170033e544345353d5353e525345153d5153e51531507375073a5073d5073a50732507325073a5073b5072f50732507375072b5073750721507285070050000500005000050000500005000050000500
18040000021340e1410616209142061620614206162061320615105151061510612103151001230d1010d1010b101071010a1010a105000000000000000000000000000000000000000000000000000000000000
7c0200000000000231002300060100230006010160100230006010563101631002300463104221082210b6300e23111231112200e2310e2310163000231006210122101221012110060000601000010000000000
c403000000610022210a631241412c3401a641132310a221066200000001220000000120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c4020000326103503437061242311d213102310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
200400000f13404141061620814208162081420e1610813108151071510815107121091510e1210d0000d1010b101071010a1010a105000000000000000000000000000000000000000000000000000000000000
900300000f655000001c6000065500605000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900b00003f00438011320212900100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480600000062507071000000062400620006250000001605006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
940300000163500000206250001106041090110b531095110a5210b5010a5110b5010c5010b5010a5110b50100000000000000000000000000000000000000000000000000000000000000000000000000000000
c40400003a62532525136003f52500605026010160100505006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402000006553000030955300003000031153300003000031a5330000300003355230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480600003e00013051000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000915009161091710b1700a171091500416102150021300113101150011610117102170031610317002171031700815108130001000010000100001000010000100001000010000100001000010000100
d40200000015000250002500f6600f2600e2500915009650091500425009150052500325004250031500125000100002500010000100002500010000230001000010000100001000023000200002000020000200
a8010000322103e2313f2313f2312f200232002e2002f20023200002000020000200002003020038201272022f221392513d2513d251002000020000200002000020000200002000020000200002000020000200
900100000062000621026310863117631236413064123641166310c02105621006210262000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
940b00000f67306573006050d503005030c5030050500103001010010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000000000000000000000
9001000019920199201992019920199201992019920199200d9000d9000d900059100591005910059100591005910059100591005910059100591005910059100b9000b9000b9000b9000b9000b9000b9000b900
4a020000016212f641056600a671136710965003641026413663005621036310562008621056310e630056210162100610096110061100620006312d621006110061001601016210160100610006210060100611
480200000261000620036100161000600006100061000610006000061000600006000050000500006150060000500005000050000500005000050000500005000000000000000000000000000000000000000000
780200000e91006010040110301500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
20c800002680026834268202681526804258342582025815000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20c800002180021834218202181520834208202081525803000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 7e7f4144

__change_mask__
fafffffffffffffffffffffffffffffffffffffff5fffffff5ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

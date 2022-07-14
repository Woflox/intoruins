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
	 
	genmap(vec2(mapcenter,mapsize*0.75))--mapsize/*0.75))

	spawns={}
	for i=0,15 do
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
end

function _update()
	for ent in all(ents) do
		updateent(ent)
	end
	
	local camtarget = entscreenpos(player)
 local center = screenpos(vec2(mapcenter,mapcenter),vec2(-3,-7))
	camtarget.y = lerp(camtarget.y,
																	center.y,
																	0.5)
	camtarget.x = lerp(camtarget.x,
																	center.x,
																	0.36)
	smooth = smooth and 
		lerp(smooth,camtarget,0.25)
		or	camtarget
	campos=vec2(flr(smooth.x-64),
													flr(smooth.y-64))
	
end

function _draw()
	cls()
	camera(campos.x,campos.y)
	lfillp=localfillp(0xc7d3.4,
								1-campos.x,
								2-campos.y)
	drawmap(world)
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
tflatgrass,tlonggrass,tmushroom=
38       ,58         ,56
thole,txbridge,tybridge=
32   ,60      ,44

function tile(typ)
	return {typ=typ,fow=0}
end
	
function drawcall(func,args)
	add(drawcalls, {func,args})
end

function initpal(tl)
	pal()	
	palt(0, false)
	palt(15, true)
	pal(15,129,1)
	local fow=0
	if vistoplayer(tl) then
		fow=tl.light>=2 and 3 or 2
	elseif tl.explored then
		fow=1
	end
	local oldfow=tl.fow
	fow = mid(oldfow-1,fow,oldfow+1)
	tl.fow=fow
		
	fillp(fow==3 and █	or 
						 lfillp)
	if fow==0 then
		pal(blackpal)
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
	if vistoplayer(tl) and ent then
		initpal(tl)
		--fillp(█)
		local scrpos=ent.renderpos
			
		spr(ent.typ 
						+ flr(ent.animframe)*16
						+ (ent.yface > 0 
								 and 16 or 0),
						scrpos.x,scrpos.y,
						0.875,1,
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
				drawcall(initpal,{tl})
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
					
function getadj(i)
	return adj[(i-1)%6+1]
end

function getadjtl(pos,i)
	if (i==0) return gettile(pos)
	local dst=pos+getadj(i)
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

function calcpdist(pos)
 local tl=gettile(pos)
	alltiles(
	function(npos,ntl)
		ntl.pdist=-1
	end)
	local tovisit={{pos,tl,1}}
	tl.pdist=0
	repeat
		local pos,tl,d=
			unpack(deli(tovisit,1))
		if inbounds(pos) and
					navigable(tl) then
			visitadj(pos,
			function(npos,ntl)
				if ntl.pdist == -1 then
					ntl.pdist=d
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
		viscone(pos,getadj(i),getadj(i+2),0,1,1)
	end
end

function calclight(pos,tl)
 
 local maxlight=tl.light
 local minlight=maxlight
	local tovisit={}
	
	function addtovisit(pos,tl)
		local light=tl.light
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
	alltiles(
	function(pos,tl)
		ent = tl.ent
		tl.light = ent and ent.light or 
													(fget(tl.typ+192,7) and 
													4 or -10) 
		tl.lightsrc = tl.light>=2
		tl.vis=ent == player
	end)
	ppos=player.pos
	ptile=gettile(ppos)
	calclight(ppos,ptile)
	calcpdist(ppos)
	calcvis(ppos)
	alltiles(function(pos,tl)
		if vistoplayer(tl) then
			tl.explored=true
		end
	end)

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
																		vec2(-3,-7))
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

eplayer,egoblin=
64     ,65
emushroom,ebrazier=
137      ,136

entdata={}

entdata[eplayer]=
"hp:20,dmg:3,light:4,playercontrolled:true"
entdata[egoblin]=
"hp:6,dmg:3"
entdata[emushroom]=
"hp:1,light:4"
entdata[ebrazier]=
"hp:1,light:4,idleanim:true,animspeed:0.33,animfrom:0,animframes:3"

function create(typ,pos)
	local ent = {typ=typ,pos=pos,
							xface=1,yface=-1,
							animframe=0}
	ent.renderpos=entscreenpos(ent)
	add(ents,ent)
	gettile(pos).ent = ent
	for var in 
		all(split(entdata[typ]))
	do
		pair=split(var,":")
		ent[pair[1]]=pair[2]
	end

	return ent
end

function updateent(ent)
	if ent.playercontrolled then
		local movx,movy=
		axisinput(1,0),axisinput(3,2)
		
		if movx != 0 then
			movy = 0
		end
		
		if	player.yface != movx then
			movy -= movx
		end
		
		if btnp(5) or 
					(movy!=0 and
					 movy!=player.yface) then
			player.yface *= -1
		end
		
	 local moved=false
		if movx!=0 or movy!=0 then
			moved=move(player,vec2(movx,movy))
				
			if not moved and movx!=0 then
				moved=move(player,vec2(movx,movy-player.yface))
			end
		end
		
		if moved then
			updatemap()
		end
	elseif ent.ai then
	
	end
	
	ent.renderpos=
		 lerp(ent.renderpos,
		      entscreenpos(ent),
		      0.5)													
	
	if ent.idleanim then
		ent.animframe=
		 (ent.animframe+ent.animspeed
		  -ent.animfrom)%ent.animframes
		  +ent.animfrom
	end
	
end

function move(ent,delta)
	local dst=ent.pos+delta
	local dsttile = gettile(dst)
	if not navigable(dsttile) then
		return false
	end
	gettile(ent.pos).ent = nil
	ent.pos=dst
	if delta.x != 0 then 
		ent.xface = delta.x
 end
 if delta.y != 0 then
 	ent.yface = delta.y
 elseif x != 0 then
  ent.yface = delta.x
 end
	
	dsttile.ent = ent
	
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
	
	player = create(eplayer,
																	startpos)
	updatemap()
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
	tl.typ,typ2=
	 mget(typ,y),
		mget(typ+1,y)
	tl.flip=rnd()<0.5
	tl.genned=true
 if typ2 == 0 then
		--todo destroy entity
		tl.bg=nil
	else
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
	 calcpdist(pos)
	 
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
			local tl1=gettile(p1)
		 
	 	local diri=ceil(rnd(6))
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
						bestdist=d
						bestp1=p1
						bestdir=dir
						bestdiri=diri
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
			tl.typ=thole
			tl.bg=nil
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
		
	 besttl.typ=thole
	 besttl.bg=nil
	 besttl.ent=nil
	 sfx(11)
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
fffffffffffffffffffffffffffffffffffffffffffffffffffffffff3ffffff0000000000000000ffff3f3f3f3ff3ffffffffffff505fff0000000000000000
fff000110111fffffff01111111110fffff01111111110fffffffffff5ffffff0000000000000000ffff3f3ff35f3ffffffffff5502202ff0000000000000000
ff0111000111f10fff0111111111110fff0111111111110ffffffffffff3ffff0000000000000000ffff3f3ff3503fffffff05502202202f0000000000000000
f011110110001110f011100111111110f011111111111110fffff3fffff5ffff0000000000000000ffff3ff3f3ff5ffff5052022022055040000000000000000
000000111101000001111111111111110101111111111111fffff3ff3fffffff0000000000000000fffff3f3f5ff5fff022022022055044f0000000000000000
f011000010111100f011111110011110f011111111100110fffff5f3ffffffff0000000000000000fffff5f3f5ff00fff02202505404ffff0000000000000000
ff0011110001100fff0111111111110fff0111111111100ffffffff5ffffffff0000000000000000ffff0505ffffffffff055044ffffffff0000000000000000
fff00110111000fffff01111111110fffff01111111110ffffffffffffffffff0000000000000000fffffff5fffffffffff44fffffffffff0000000000000000
fff67ffffffffffffffffffffffffffffff11fffff999fffffffffffffffffff10011001ffffffff000000000000000000000000000000000000000000000000
fff62f9ffffffffffff22fffffffffffff1001ff333333ffffffffffffffffff00000000ffffffff000000000000000000000000000000000000000000000000
ff888faffff3f3fffff223fffff3f3ffff10031f33333344ffffffffffffffff11000011ffffffff000000000000000000000000000000000000008099890000
ff88df4fff5553f6ff22234fff44439ff100038133333344ffffffff4fffffffff1011fffffbbbff000000000000000000000000000000000000088988888000
ff88d6ffff555f6fff222f4fff4445f9f10001419333394ffffefefff4454f4ff101ffffffb337bf000000000000000000000000000000008890859885558800
ff882fffff5553ffff22234fff444366f1000341f33339ffffff55fff445444fff1fffffffb333bf000000000000000000000000000000000089998888808000
ff2f2fffff444fffff222f4fff66699ff100011ff2222fffff5555fff404440fffffffffffb35bbf000000000000000000000000000000000028888820860000
ffd0dfffff404fffff222fffff606ffff10001fff2002ffffe555ffffff404fffff00ffffb3553bf000000000000000000000000000000000002622260000000
fff67ffffffffffffffffffffffffffffff11fffff997fffffffffffffffffff10001001ffffffff000000000000000000000000000000000000000000000000
fff22ffffffffffffff22fffffffffffff1001ff333993ffffffffffffffffff05500050ffffffff000000000000000000000000000000000000000000000000
ff882f9ffff3f3fffff323fffff3f3ffff13031f993333ffffffffffffff4f4f11500011ffffffff000000000000000000000000000000000000008000000000
ff86dfafff5333ffff2333ffff4333fff103331f99333344ffffffffffff444fff1011fffffbbbff000000000000000000000000000000008890088809900000
ff8d6f4fff555ff6ff222f4fff44499ff100018199933f44ffffffffff44455ff101ffffffb337bf0000000000000000000000000000000000898558888a8000
ff8226ffff555f6fff222f4fff4445f9f1000141f999944ffefefefff44454ffff1fffffffb333bf000000000000000000000000000000000028985558888800
ff2f2fffff4453ffff22234fff664366f1000341f2299fffff5555ff444404ffffffffffffb35bbf000000000000000000000000000000000002288888220000
ffd0dfffff404fffff222f4fff60699ff100011ff2002fffff0555fff404fffffff00ffffb3553bf000000000000000000000000000000000000022226006000
00000000ffffffffffffc4cfffffffffff11ff8ffffffffffffffffffffffffff6fff6ffffffffff000000000000000000000000000000000000800098000000
00000000ffffffffff22c4cffffffffff1001878fff999ffffffffffffffffff1f6fff61ffffffff000000000000000000000000000000000008880988800000
00000000f66666ffff223c4cfff3f3fff1003184f3333336ff666fffffffffff016010606fffff6f000000000000000000000000000000000085588982008800
000000006663f36fff22223cff4443fff1000031f3333336f6e6e66f4f454f4f00000000f6fffff6000000000000000000000000000000000000658888888580
00000000f35553f6ff2222c4f4444f9ff100001ff33333366ff55ff6f445444f10000001f6bbbbb6000000000000000000000000000000000000608988855000
00000000ff555fffff222fc4ff444f9ff10001fff3333394ff5555fff4f44406f11011fffb33337b000000000000000000000000000000000089008988206000
00000000ff444fffff222ffcff6669fff10001fff2222944ff555fff664fff6ff101fffffb33553b000000000000000000000000000000000008999882006000
00000000f4004fffff222fffff606ffff10001ff200002fffe5ffffff66666ffff100fffb335555b000000000000000000000000000000000000888880660000
00000000fffffffffffffcffffffffffff11ff8ffffffffffffffffffffffffff6fff6ffffffffff000000000000000000000000000000000000800098800000
00000000ffffffffff22c4cffffffffff1001878fff999fffffffffff664646f1f6fff61ffffffff00000000000000000000000000000000000888098a880000
00000000ffffffffff3234cffff3f3fff1303141f333973fffffffff66f4446f016010606fffff6f000000000000000000000000000000000085588982000800
00000000fff3f3ffff333c4cff4333fff1333141f9933336ffffffffff4455f650000005f6fffff6000000000000000000000000000000000080065888888580
00000000ff5333f6ff22223cff44499ff100003199933336fffefefff44454ff15500051f6bbbbb6000000000000000000000000000000000000069888556080
00000000635555f6ff2222c4f4445ff9f100001f993333666ef555f64444f4ffff1011fffb33337b000000000000000000000000000000000089609888206000
0000000066645f6fff222fc4ff435ff9f10001ff9924466f66555666f444fffff101fffffb33553b000000000000000000000000000000000008998888060000
00000000f46666ffff222fffff60699ff10001ff9444462ff66666ff4004ffffff100fffb335555b000000000000000000000000000000000000886828600000
ffffffffffffffffffffffffffffffff00000000000000000000000000000000fff8ffffffffffff000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffff11ff00000000000000000000000000000000ff99ffffffffffff000000000000000000000000000000000000000000000000
fffffffffffffffffffffffffff1001f00000000000000000000000000000000ff899fffffffffff000000000000000000000000000000000000000000000000
fffffffffffffffffffff7ffff1001ff00000000000000000000000000000000ff998ffffffccfff000000000000000000000000000000000000000000000000
fffbbffffffccfffffff6fffff1001ff00000000000000000000000000000000ff549fffffccc7ff000000000000000000000000000000000000000000000000
ffb37bffffcd7cfffff4fffff10001ff00000000000000000000000000000000fff5ffffffffdfff000000000000000000000000000000000000000000000000
ffb33bffffcddcffffffffffff111fff00000000000000000000000000000000ff554ffffcf2d2ff000000000000000000000000000000000000000000000000
fffbbffffffccfffffffffffffffffff00000000000000000000000000000000ff505ffffdf00fff000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffff00000000000000000000000000000000fff8ffffffffffff000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffff00000000000000000000000000000000ff899fffff4fffff000000000000000000000000000000000000000000000000
ffffffffffffffffffffff7fffffccff00000000000000000000000000000000ff998ffff42fffff000000000000000000000000000000000000000000000000
fffffffffffffffffffff6fffffccfff00000000000000000000000000000000ff998ffff42fffff000000000000000000000000000000000000000000000000
fff99ffffffaaffffffd6ffffffccfff00000000000000000000000000000000ff454ffff42224ff000000000000000000000000000000000000000000000000
ff9879ffffa97afffffdffffffcccfff00000000000000000000000000000000fff5fffff44442ff000000000000000000000000000000000000000000000000
ff9889ffffa99affffffffffffffffff00000000000000000000000000000000ff554ffff42f42ff000000000000000000000000000000000000000000000000
fff99ffffffaafffffffffffffffffff00000000000000000000000000000000ff505ffff4ff4fff000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffff00000000000000000000000000000000fff9ffffffffffff000000000000000000000000000000000000000000000000
fffffffffffffffffffff7ffffffffff00000000000000000000000000000000ff998fffffffffff000000000000000000000000000000000000000000000000
ffffffffffffffffffff65ffffff99ff00000000000000000000000000000000ff999fffffffffff000000000000000000000000000000000000000000000000
fffffffffffffffffffff457fff99fff00000000000000000000000000000000ff899fffffff222f000000000000000000000000000000000000000000000000
fffddffffff88fffffff4f6ffff99fff00000000000000000000000000000000ff554ffffff444ff000000000000000000000000000000000000000000000000
ffd27dffff8878fffff4ffffff999fff00000000000000000000000000000000fff5fffffff42fff000000000000000000000000000000000000000000000000
ffd22dffff8888ffffffffffffffffff00000000000000000000000000000000ff554ffff224222f000000000000000000000000000000000000000000000000
fffddffffff88fffffffffffffffffff00000000000000000000000000000000ff505fff444444ff000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffff00000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffff7fffffffff00000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000
fffffffffffffffffffff997ffffbbff00000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffd99fffbbfff00000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000
fffeeffffff66fffffffdffffffbbfff00000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000
ffe87effff6576fffffdffffffbbbfff00000000000000000000000000000000ff54f4ff00000000000000000000000000000000000000000000000000000000
ffe88effff6556ffffffffffffffffff00000000000000000000000000000000fff555ff00000000000000000000000000000000000000000000000000000000
fffeeffffff66fffffffffffffffffff00000000000000000000000000000000ff5505ff00000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffff000ffffffffff000fffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffff0100000fffffffff0000000ffffff0000000ffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
000ff00100011fff00fff0000000000fff00000000000fffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
0010110140014f0000ff0000000000dff000000000000000ffffffff0fffffff0000000000000000000000000000000000000000000000000000000000000000
001104014010400000f0000000000d9f000000000000000dfffffff00fffffff0000000000000000000000000000000000000000000000000000000000000000
0019040110100010000000000000191f555000000000001dfffffff0d0ffffff0000000000000000000000000000000000000000000000000000000000000000
011901011010101000550000000d119f1550550000000d11fffffff0900fffff0000000000000000000000000000000000000000000000000000000000000000
0d010100000010000055505000dd119f000055505000dd11ffffff005d0f0fff0000000000000000000000000000000000000000000000000000000000000000
090100000f0000000000505551d1911f505000505550d1d1ffff00011d0090ff0000000000000000000000000000000000000000000000000000000000000000
0d10ffff0ffff00400500005511d919f5055500004401dd1fff000011501d0ff0000000000000000000000000000000000000000000000000000000000000000
0110050fffffff0000505550011d19df0005505540001d1dff0400001101d00f0000000000000000000000000000000000000000000000000000000000000000
010ffffffffff0f0000015505d111d0f555000554054111dff01100115001d000000000000000000000000000000000000000000000000000000000000000000
0001fffffffffff1005500005d1d10ff1550550000541d10f1110101110011500000000000000000000000000000000000000000000000000000000000000000
00001ffff00f40100055505001dd0fff000055505000dd0ff011010110d010100000000000000000000000000000000000000000000000000000000000000000
ff000411000011000000505551d0fffffff000505440d0ffff0011010050100f0000000000000000000000000000000000000000000000000000000000000000
fff0000000000000ffff0005510fffffffffff0005500ffffff01111101110ff0000000000000000000000000000000000000000000000000000000000000000
ffff115515150fffffffff0000fffffffffffffff000ffffffffffffffffffff0000000000000000ffffffffffffffffffff054992252fffffff004400000fff
fff11015010105ffffff015500ffffffffffffffffffffffffff9ffffff59f330000000000000000ffffffffffffffffffff151100050ffffff00011044100ff
ffd110111101011ffff10111015ffffffffffffffffffffff33ff9fff050f3ff0000000000000000ffffffffffffffffffff005224202fffff0154000111010f
fd11001101000101ff1d1000011501fffffffffffffffffffff3ff3f99ff3fff0000000000000000ffffffffffff9fffffff050000050ffff011110440001110
5151000000000100f155010100010155ffffffffffffffffffff3f3fff3f5fff0000000000000000fffffffffff9ffffffff052922450fff0000001114010000
11500011010000011150f00011000011fffffffffffffffffffff5f5ff500fff0000000000000000fffff9fffff3ffffffff021000100ffff011000010111100
1101fffffffff1015001ffff00011100ffffffffffffffffffff0505f5ffffff0000000000000000ffffff9ffff3ffffffff054422252fffff0011140001100f
101fffffffffff005001fffffff00001fffffffffffffffffffffff5ffffffff0000000000000000fff3ff3f9ff3f3ffffff000000000ffffff00110111000ff
ffff004400000ffffffffff444ffffffffffffff44fffffffffffffff9ffffff0000000000000000ffff3f3f3f3ff3ffffffffffff505fff0000000000000000
fff00011044100fffff01111111110fffff01111111110fffffffffff5ffffff0000000000000000ffff3f3ff35f3ffffffffff5904202ff0000000000000000
ff0114000111010fff0111111111110fff0111114111110ffffffffffff9ffff0000000000000000ffff3f3ff3503fffffff05902902202f0000000000000000
f011110440001110f011100111111110f011111111111110fffff9fffff5ffff0000000000000000ffff3ff3f3ff5ffff5055024024055040000000000000000
000000111401000001111114111111110101111111111111fffff3ff9fffffff0000000000000000fffff3f3f5ff5fff022022022055044f0000000000000000
f011000010111100f011111110011110f011111111100110fffff5f3ffffffff0000000000000000fffff5f3f5ff00fff02202505404ffff0000000000000000
ff0011140001100fff0111114111110fff0111111141100ffffffff5ffffffff0000000000000000ffff0505ffffffffff055044ffffffff0000000000000000
fff00110111000fffff01111111110fffff01111111110ffffffffffffffffff0000000000000000fffffff5fffffffffff44fffffffffff0000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888ffffff882222228888888888888888888888888888888888888888888888888888888888888888228228888ff88ff888222822888888822888888228888
88888f8888f882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888222822888882282888888222888
88888ffffff882888828888888888888888888888888888888888888888888888888888888888888882288822888f8ff8f888222888888228882888888288888
88888888888882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888888222888228882888822288888
88888f8f8f88828888288888888888888888888888888888888888888888888888888888888888888822888228888ffff8888228222888882282888222288888
888888f8f8f8822222288888888888888888888888888888888888888888888888888888888888888882282288888f88f8888228222888888822888222888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555557777777777770000000000000000000000000000005555555
55555550ffffffffffffffff000000000000000000000000000000000000ffffffffffff05555557000000000071111111112222222222333333333305555555
55555550ffffffffffffffff000000000000000000000000000000000000ffffffffffff05555557000000000071111111112222222222333333333305555555
55555550ffffffffffffffff000000000000000000000000000000000000ffffffffffff05555557000000000071111111112222222222333333333305555555
55555550ffffffffffffffff000000000000000000000000000000000010ffffffffffff05555557000000000071111111112222222222333333333305555555
55555550ffffffffffff00001111000000000000111111111111111111710000ffffffff05555557000000000071111111112222222222333333333305555555
55555550ffffffffffff00001111000000000000111111111111111111111000ffffffff05555557000000000071111111112222222222333333333305555555
55555550ffffffffffff00001111000000000000111111111111111171117100ffffffff05555557000000000071111111112222222222333333333305555555
55555550ffffffffffff00001111000000000000111111111111111111111000ffffffff05555557000000000071111111112222222222333333333305555555
55555550ffffffff0000000011111111111111110000000000001111017111110000ffff05555557000000000071111111112222222222333333333305555555
55555550ffffffff0000000011111111111111110000000000001111001011110000ffff05555557777777777775555555556666666666777777777705555555
55555550ffffffff0000000011111111111111110000000000001111000011110000ffff05555550444444444455555555556666666666777777777705555555
55555550ffffffff0000000011111111111111110000000000001111000011110000ffff05555550444444444455555555556666666666777777777705555555
55555550ffff00001111111100000000000011111111111111110000000000001111000005555550444444444455555555556666666666777777777705555555
55555550ffff00001111111100000000000011111111111111110000000000001111000005555550444444444455555555556666666666777777777705555555
55555550ffff00001111111100000000000011111111111111110000000000001111000005555550444444444455555555556666666666777777777705555555
55555550ffff00001111111100000000000011111111111111110000000000001111000005555550444444444455555555556666666666777777777705555555
55555550000000000000111111111111111100000000000000001111111111110000000005555550444444444455555555556666666666777777777705555555
55555550000000000000111111111111111100000000000000001111111111110000000005555550444444444455555555556666666666777777777705555555
5555555000000000000011111111111111110000000000000000111111111111000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555000000000000011111111111111110000000000000000111111111111000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550ffff0000111100000000000011111111111100000000000000001111000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550ffff0000111100000000000011111111111100000000000000001111000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550ffff0000111100000000000011111111111100000000000000001111000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550ffff0000111100000000000011111111111100000000000000001111000000000555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550ffffffff0000111111111111000000000000111111111111111100000000ffff0555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550ffffffff0000111111111111000000000000111111111111111100000000ffff0555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550ffffffff0000111111111111000000000000111111111111111100000000ffff0555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550ffffffff0000111111111111000000000000111111111111111100000000ffff05555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550ffffffffffff00001111111111111111111100000000000000000000ffffffff05555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550ffffffffffff00001111111111111111111100000000000000000000ffffffff05555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550ffffffffffff00001111111111111111111100000000000000000000ffffffff05555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550ffffffffffff00001111111111111111111100000000000000000000ffffffff05555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550ffffffffffff66667777ffffffffffffffffffffffffffffffffffffffffffff05555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550ffffffffffff66667777ffffffffffffffffffffffffffffffffffffffffffff05555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550ffffffffffff66667777ffffffffffffffffffffffffffffffffffffffffffff05555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550ffffffffffff66667777ffffffffffffffffffffffffffffffffffffffffffff05555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550ffffffffffff66662222ffff9999ffffffffffffffffffffffffffffffffffff05555550000000000000000000000000000000000000000005555555
55555550ffffffffffff66662222ffff9999ffffffffffffffffffffffffffffffffffff05555555555555555555555555555555555555555555555555555555
55555550ffffffffffff66662222ffff9999ffffffffffffffffffffffffffffffffffff05555555555555555555555555555555555555555555555555555555
55555550ffffffffffff66662222ffff9999ffffffffffffffffffffffffffffffffffff05555555555555555555555555555555555555555555555555555555
55555550ffffffff888888888888ffffaaaaffffffffffffffff3333ffff3333ffffffff05555556666666555556667655555555555555555555555555555555
55555550ffffffff888888888888ffffaaaaffffffffffffffff3333ffff3333ffffffff05555556666666555555666555555555555555555555555555555555
55555550ffffffff888888888888ffffaaaaffffffffffffffff3333ffff3333ffffffff0555555666666655555556dddddddddddddddddddddddd5555555555
55555550ffffffff888888888888ffffaaaaffffffffffffffff3333ffff3333ffffffff055555566606665555555655555555555555555555555d5555555555
55555550ffffffff88888888ddddffff4444ffffffffffff5555555555553333ffff666605555556666666555555576666666d6666666d666666655555555555
55555550ffffffff88888888ddddffff4444ffffffffffff5555555555553333ffff666605555556666666555555555555555555555555555555555555555555
55555550ffffffff88888888ddddffff4444ffffffffffff5555555555553333ffff666605555556666666555555555555555555555555555555555555555555
55555550ffffffff88888888ddddffff4444ffffffffffff5555555555553333ffff666605555555555555555555555555555555555555555555555555555555
55555550ffffffff88888888dddd6666ffffffffffffffff555555555555ffff6666ffff05555555555555555555555555555555555555555555555555555555
55555550ffffffff88888888dddd6666ffffffffffffffff555555555555ffff6666ffff05555556665666555555555555566676555555555555555555555555
55555550ffffffff88888888dddd6666ffffffffffffffff555555555555ffff6666ffff05555556555556555555555555556665555555555555555555555555
55555550ffffffff88888888dddd6666ffffffffffffffff555555555555ffff6666ffff0555555555555555555555ddddddd6dddddddddddddddd5555555555
55555550ffffffff888888882222ffffffffffffffffffff5555555555553333ffffffff055555565555565555555655555556555555555555555d5555555555
55555550ffffffff888888882222ffffffffffffffffffff5555555555553333ffffffff05555556665666555555576666666d6666666d666666655555555555
55555550ffffffff888888882222ffffffffffffffffffff5555555555553333ffffffff05555555555555555555555555555555555555555555555555555555
55555550ffffffff888888882222ffffffffffffffffffff5555555555553333ffffffff05555555555555555555555555555555555555555555555555555555
55555550ffffffff2222ffff2222ffffffffffffffffffff444444444444ffffffffffff05555555555555555555555555555555555555555555555555555555
55555550ffffffff2222ffff2222ffffffffffffffffffff444444444444ffffffffffff05555555555555555555555555555555555555555555555555555555
55555550ffffffff2222ffff2222ffffffffffffffffffff444444444444ffffffffffff05555550005550005550005550005550005550005550005550005555
55555550ffffffff2222ffff2222ffffffffffffffffffff444444444444ffffffffffff055555088705099705011d05011d05011d050dd705011d05011d0555
55555550ffffffffdddd0000ddddffffffffffffffffffff444400004444ffffffffffff0555550888050999050111050111050111050ddd0501110501110555
55555550ffffffffdddd0000ddddffffffffffffffffffff444400004444ffffffffffff0555550888050999050111050111050111050ddd0501110501110555
55555550ffffffffdddd0000ddddffffffffffffffffffff444400004444ffffffffffff05555550005550005550005550005550005550005550005550005555
55555550ffffffffdddd0000ddddffffffffffffffffffff444400004444ffffffffffff05555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555555575555555ddd55555d5d5d5d55555d5d555555555d5555555ddd555555ffff000055555555555555555555555555555555555555555555555555
555555555555777555555ddd55555555555555555d5d5d55555555d55555d555d55555fff0100056666666666666555557777755555555555555555555555555
555555555557777755555ddd55555d55555d55555d5d5d555555555d555d55555d5555ff00111156ddd6d6d6ddd6555577ddd775566666555666665556666655
555555555577777555555ddd55555555555555555ddddd5555ddddddd55d55555d5555f011000156d6d6d6d6d6d6555577d7d77566dd666566ddd66566ddd665
5555555557577755555ddddddd555d55555d555d5ddddd555d5ddddd555d55555d55550001111056d6d6ddd6ddd6555577d7d775666d66656666d665666dd665
5555555557557555555d55555d55555555555555dddddd555d55ddd55555d555d55555f010001156d6d666d6d6d6555577ddd775666d666566d666656666d665
5555555557775555555ddddddd555d5d5d5d555555ddd5555d555d5555555ddd555555ff01110056ddd666d6ddd655557777777566ddd66566ddd66566ddd665
5555555555555555555555555555555555555555555555555555555555555555555555fff0111156666666666666555577777775666666656666666566666665
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555566666665ddddddd5ddddddd5ddddddd5
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffff000ffffffffff00fffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffff0100000fffffffff0000000ffffff000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffff00100011ffffffff0000000dfffff000000000ffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
f10110150015f00ffff00000001dffff0000000000000fffffffffff0fffffff0000000000000000000000000000000000000000000000000000000000000000
f1105015010500000f0000000d11ffff5500000000000dfffffffff00fffffff0000000000000000000000000000000000000000000000000000000000000000
01d0501101000100f0000000dd11ffff5505500000001dfffffffff0d0ffffff0000000000000000000000000000000000000000000000000000000000000000
11d010110101010000000001d1d1ffff00055055000d11fffffffff0d00fffff0000000000000000000000000000000000000000000000000000000000000000
d010100000010000055000d11dd1ffff0550005550dd11ffffffff005d0f0fff0000000000000000000000000000000000000000000000000000000000000000
d0100000f000000005550dd11d1dffff0555000050d1d1ffffff00011d00d0ff0000000000000000000000000000000000000000000000000000000000000000
d10ffff0ffff001000050d1d111dffff00050550001dd1fffff000011501d0ff0000000000000000000000000000000000000000000000000000000000000000
110050fffffff000005001dd1d10ffff55000550551d1dffff0500001101d00f0000000000000000000000000000000000000000000000000000000000000000
10ffffffffff0f00005551d1dd0fffff5505500055111dfff001100115001d000000000000000000000000000000000000000000000000000000000000000000
001fffffffffff1000055111d0ffffff00055055001d10ff01110101110011500000000000000000000000000000000000000000000000000000000000000000
0001ffff00f50100055001d10fffffffff00005550dd0ffff011010110d010100000000000000000000000000000000000000000000000000000000000000000
f000011000011000f5550dd0fffffffffffff00050d0ffffff0011010050100f0000000000000000000000000000000000000000000000000000000000000000
ff0000000000000ff0050d0ffffffffffffffff0000ffffffff01111101110ff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffd500000fffffffff0000000fffffffffffffffffffffffff0300000fffffffffffffffffffffffffffffffffffff0000000000000000
fffffffffffffffffffd00555110fffffff000100110ffffffff311111153f33fff000310310ffffffffffffffffffffffffffffffffffff0000000000000000
ffffffffffffffffffd1050005500fffff00100050100ffff3311311105013ffff00113513150fffffffffffffffffffffffffffffffffff0000000000000000
fffffffffffffffffd150115000555fff0010101005010ffff1311313311311ff0031151553110ffffffffffffff3fffffffffffffffffff0000000000000000
1fffffffffffffffd1d500110500005f010050100100010ff101313111315111005515111150010ffffffffffff3ffffffffffffffffffff0000000000000000
fffffffffff1fffff0500000011105fff0110000000010fff011151511500110f0115553101110fffffff3fffff3ffffffffffffffffffff0000000000000000
00000000000000000001001000105fffff00100001110fffff0105051511100fff00111501110fffffffff3ffff3ffffffffffffffffffff0000000000000000
777777777777777770f000000005fffffff011101000fffffff01115111110fffff001151000fffffff3ff3f3ff3f3fffffffff8ffffffff0000000000000000
ffff000000000fff70ff000000000fffffff000000000fffffff000003000fffffff000000000fffffff3f3f3f3ff3ffffff0089800fffffffffdddddddfffff
fff01000111110ff70f01111111110fffff01111111110fffff01111151110fffff01111111110ffffff313113513ffffff000899110fffffffd1111111dffff
ff0011110001010f700111111111110fff0111111111110fff0111111113110fff011111cc11110ffff13130135031ffff00119981100fffffd1ddddd111dfff
f0110001111000107011100111111110f011111111111110f011131111151110f001111ccc711110ff1131131311511ff0011055400110fffd11dddd1ddd1dff
0001111000011100701111111111111101011111111111110101131131111111011111111d111101f101131315115111010010151100010fd1111111111111df
f0100011100001007011111110011110f011111111100110f011151311100110f01111c12d211110f011151315110010f0110055401110fffd1dd1ddddd11dff
ff0111000111100f700111111111110fff0111111111100fff0111151111100fff0111d10011110fff0105051111100fff00105051110fffffd11d11ddd1dfff
fff01111100000ff70f01111111110fffff01111111110fffff01111111110fffff01111111110fffff01115111110fffff011101000fffffffd1111111dffff
00000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
000000000000000000000000000000004000840084002c0004000000000000007200040000006b07b30009096b01b300b30073077300730763877d096b01030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000800000000000000000000000000c000000000000000000000000000707030700000707000000000000030003000307000003000303000001010000000000000000000000000000010110002000700000000000000000000000000000000407000009090400040004000407040004070000040904000000
__map__
460000000000000000000000000000001011000000000000000000000000000020210000000000000000000000002e2f303132333435363738393a3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003200000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
460000000000000000000000000000003200000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
460000000000000000000000000000003400000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003400000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
470000000000000000000000000000003400000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
470000000000000000000000000000001600000000000000000000000000000020000000000000000000000000000000000032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
470000000000000000000000000000001600000000000000000000000000000020000000000000000000000000000000000032003200363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000000000000020000000000000000000000000000000000032003400363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
410000000000000000000000000000001600000000000000000000000000000020000000000000000000000000000000000032003400363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000016000000000000000000000000000000200000000000000000000000000000000000340034003a3200003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000016000000000000000000000000000000200000000000000000000000000000000000340034003a32000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000032890000000000000000000000000000200000000000000000000000000000000000340034003a34000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000032890000000000000000000000000000100000000000000000000000000000000000340020003200000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000034890000000000000000000000000000100000000000000000000000000000000000340036323200000036340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000034890000000000000000000000000000340000000000000000000000000000000000320036343400000036340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000003000300030003000363000003a2e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000030003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000030003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000002e003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000002e003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000003088300030003000362e000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000020002e002e002e003a2e0000362e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000036302e002e002e003000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000362e2e002e002e002e0000002e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
8004081018514185150f5240f5351354413555165641656518574185750f5740f5751357413575165741657518564185650f5540f5551354413545165341653518524185250f5140f51513514135151651416515
482300002c1152b11527115241152c1152b11527115241152c1152b11527115241152c1152b115271152411500000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9203002000661026510c6710267008661016310866001661106710366009641026610567006651016710b640066610167103670046510267109640016610a671026400466103671076310b650036610667103631
0027021e09f5413f6111f7112f710bf7110f711af710df7115f710af7121f710df7112f7118f710af710ff7112f711bf7110f710ff710af7118f7111f710ff710cf7115f710af711ff710bf7111f710bf6107f55
520700003e65331651006113e62330621006113e61311611006150060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
900200000061403620036000061003600026000060000600056000060005600016000060000600006000060000600006000060000600005000050000600006000050000500005000050000500005000050000500
000100000d1501416112171111700e1410e130041310e170031300312102121021200110002100031000310002100031000810008100001000010000100001000010000100001000010000100001000010000100
900100000062000621056310a64112641186512065110051060310302101621006210262000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
a8010000322303f2613e2413c231342010b2002e2002f2002320000200002000020000200002002d2001d20000200002000020000200002000020000200002000020000200002000020000200002000020000200
aa0500003e6143a5213f5213f5113d501005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
aa0500003e6143e5213f521355112f511005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
d402000000120071501a2701665013260122601015009250041500e15000250052000024004200031000023000100001000023000100001000010000100001000010000100001000010000200002000020000200
d4080000170733e544345353d5353e525345153d5153e51531507375073a5073d5073a50732507325073a5073b5072f50732507375072b5073750721507285070050000500005000050000500005000050000500
18040000021340e1410616209142061620614206162061320615105151061510612103151001230d1010d1010b101071010a1010a105000000000000000000000000000000000000000000000000000000000000
7c0200000000000231002300060100230006010160100230006010563101631002300463104221082210b6300e23111231112200e2310e2310163000231006210122101221012110060000601000010000000000
c403000000610022210a63124141262501a651132310a221066200000001220000000120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c4020000006000a652355342d5612b231242131a23100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
200400000f13404141061620814208162081420e1610813108151071510815107121091510e1210d0000d1010b101071010a1010a105000000000000000000000000000000000000000000000000000000000000
900300000f655000001c6000065500605000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900b00003f00438011320212900100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480600000062507071000000062400620006250000001605006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
940300000165500000206550001106041090110b531095110a5210b5010a5110b5010c5010b5010a5110b50100000000000000000000000000000000000000000000000000000000000000000000000000000000
c40400003a62532525136003f52500605026010160100505006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0402000006553000030955300003000031153300003000031a5330000300003355230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480600003e00013051000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000915009161091710b1700a171091500416102150021300113101150011610117102170031610317002171031700815108130001000010000100001000010000100001000010000100001000010000100
d40200000015000250002500f6600f2600e2500915009650091500425009150052500325004250031500125000100002500010000100002500010000230001000010000100001000023000200002000020000200
a8010000322103e2313f2313f2312f200232002e2002f20023200002000020000200002003020038201272022f221392513d2513d251002000020000200002000020000200002000020000200002000020000200
900100000062000621026310863117631236413064123641166310c02105621006210262000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
940b00000f67306573006050d503005030c5030050500103001010010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000000000000000000000
900100000064000620006100061000610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a020000016212f641056600a671136710965003641026413663005621036310562008621056310e630056210162100610096110061100620006312d621006110061001601016210160100610006210060100611
480200000061003640086200a63003610026000060000600056100062005620016100060000610006100061000600006100060000600005000050000615006000050000500005000050000500005000050000500
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
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20c800002680026834268202681526804258342582025815000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20c800002180021834218202181520834208202081525803000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 7e7f4144

__change_mask__
fafffffffffffffffffffffffffffffffffffffff5fffffff5ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

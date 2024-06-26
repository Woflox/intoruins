pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--iNTO rUINS
--BY ERIC BILLINGSLEY

function modeis(m)
	return mode==m
end

function _update()

	statet+=0.033
	
	if mode!="ui" then
 	waitforanim=#rangedatks>0
		for ent in all(ents) do
			ent.update()
		end
 end
	
	local camtarget= 
 	screenpos(
 		lerp(player.pos,
 							vec2s"10,9.5",
 							mode=="gameover" and
 							max(0.36-statet*2) or
 							0.36))
	smoothb=lerp(smoothb,camtarget,modeis"play"and 0.5 or 0.25)
	smooth=lerp(smooth,smoothb,modeis"play"and 0.25 or 0.125)
	
	function getcampos(val)
	 return flr(val-63.5)
	end
	
	campos=vec2(getcampos(smooth.x),
													getcampos(smooth.y))
end

function _draw()
	cls()
	camera(campos.x,campos.y)
	lfillp=localfillp(0xbfd6.4,
								-campos)

	for i,drawcall in 
					ipairs(drawcalls) do
		drawcall[1](
			unpack(drawcall[2]))
	end

	for atk in all(rangedatks) do
	 atk[2][1]+=1 --counter
		if atk[1](unpack(atk[2])) then
		 del(rangedatks,atk)
		end
	end
	
	pal()
	palt(1)
	pal(usplit"15,129,1")
	pal(usplit"11,131,1")
	fillp()
	
	if modeis"title" then
		camera(0,-campos.y)
		if statet>0.1 then
			if statet<0.15 then
				pal{[6]=1,[13]=0,[5]=0}
			elseif statet<0.2 then
				pal{[6]=5,[13]=1,[5]=0}
			elseif statet<0.25 then
				pal{[6]=13,[13]=5,[5]=1}
			end
			spr(65,29,-50,9,1)
		end
	end
	camera()
 
	if modeis"play" then
		local x=drawbar(player.hp/player.maxhp,
		        "HP",2,2,8)
		for k,v in 
			pairs(player.statuses)
		do
			x=drawbar(v[1]/v[2],k,x,v[3],v[4])	
		end
	elseif textcrawl(
"\14                  \
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
 \-ipRESS ❎",
  usplit"44,23,0.1,6,title,0,9")
	then
	 setmode"intro"
	elseif	textcrawl(
"\14 tHE CAVE OPENING CALLS TO YOU.         \
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
    \|jtHERE'\-fS NO TURNING BACK...    \
\
          ❎:jUMP dOWN",
  usplit"6,15,0,6,intro")
 then
  if statet > 5.75 then
	  setmode"play"
	  music(-1,300)
	  musicplayed=false
	  player.move(vec2s"10,12")
	 else
	 	statet=5.75
	 end
	end
	inputblocked=false
	
end

function drawbar(ratio,label,x,col1,col2)
 
 local w=max(#label*4-1,20)
 local barw=ceil(ratio*w)-1
 rect(x-1,122,x+w,126,15)
 rect(x,123,x+barw,125,col2)
 if barw>0 then
	 rectfill(x,124,x+barw-1,
	 									125,col1)
	end
	?label,x,116,col1
 
 return x+w+4
end

function textcrawl(str,x,y,fadet,col,m,mus,xtra)
 if modeis(m) and statet>fadet then
	 if mus and not musicplayed then
		 music(mus)
		 musicplayed=true
		end
		local i=statet*30+(xtra or 0)
		if modeis"intro" and i<=#str and str[i]!=" " and str[i]!="\n" then
			sfx"9"
		end
 	print(sub(str,0,i),x,y,statet>fadet+0.1and col or 1)	
	 return btnp"5"
	end
end

function setmode(m)
	mode=m
	assigntable("statet:0,inputblocked:true,btns:0",_ENV)
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
13:freezable
]]

function tile(_typ,_pos)
	local _ENV=setmetatable({},{__index=_ENV})
	typ,pos,tlscrpos=
	_typ,_pos,screenpos(_pos)
--tile member functions)
set=function(ntyp)
	typ,bg,genned=ntyp
end

draw=function(_typ,postl,scrpos,offset,size,flp,_bg,_hilight)
	dtyp=_typ or (_bg and bg) or typ
	if frozen then
		if fget(dtyp+1,5)	then
			dtyp,flp=56
		else
			pal(frozepal)
		end
	end
	local xtraheight,litsprite=
	fget(dtyp,2)and 5 or 0,dtyp+192
	
	--lighting
	for i=0,6 do
		if not _bg and fow==4 and 
		   fget(litsprite,i) then
			local adjtile=i==0 and postl or postl.adjtl[i]
			if adjtile and
						adjtile.lightsrc then
				dtyp=litsprite
				pal(8,adjtile.lcool and 13 or 4)
				pal(9,adjtile.lcool and 12 or 9)
			end
		end
	end
	
	sspr(dtyp%16*8+offset.x,
							dtyp\16*8+
								offset.y-xtraheight,
							size.x,size.y+xtraheight,
							scrpos.x,scrpos.y-xtraheight,
							size.x,size.y+xtraheight,flp)
	if _hilight then
	 local _ENV=postl
	 hifade+=mid(-1,hilight-hifade,1)
	 if hifade>0 then
	  pal(usplit"2,34,2")
	 	spr(hifade*16-8,scrpos.x,scrpos.y,2,1)
	 end
 	hilight=0
	end
end

initpal=function(fadefow)
 pal()	
	palt(1)
	local nfow=1
	if fadefow then
	 if not fadetoblack then
			if modeis"gameover" then
				nfow=_ENV==player.tl and 3 or 1
			elseif vistoplayer() and
			   mode != "ui" then
				nfow=light>=2 and 4 or 3
			elseif explored then
				nfow=2
			end
		end
		fow+=mid(-1,nfow-fow,1)
	end

	if fow<4 then
		fillp(lfillp)
		pal(fowpals[fow],2)
	else
		fillp()
 end
end

tileflag=function(i)
	return fget(typ+flr(i/8),i%8)
end

navigable=function(flying)
	return tileflag(flying and 8 or 0)
end

genable=function()
	return tileflag"4"
end

ismanmade=function()
	return tileflag"7" or
	(bg and fget(bg,7))
end

vistoplayer=function()
	return vis and (light>-player.stat"darksight" 
	    or pdist>-2-player.stat"darksight")
end

flatten=function()
 if typ==tlonggrass then
 	typ=tflatgrass
 end
end

--end tile member functions
	return assigntable("fow:1,fire:0,spores:0,newspores:0,hilight:0,hifade:0,light:-10,lflash:-10,lflashl:-10,adjtl:{}",_ENV)
end

function drawcall(func,args)
	add(drawcalls, {func,args})
end

function drawents(tl)
	function drawent(var)
		if (tl[var]) tl[var].draw()
	end

	drawent"item"
	drawent"ent"
	drawent"effect"
end

function setupdrawcalls()
	alltiles(
	
	function(_ENV)
		local _typ,palready=typ
		
		function tdraw(tltodraw,postl,i,_bg)
			if not palready then
				drawcall(initpal,{true})
				palready=true
			end
			local _typ,flp=
			i and (bg and tltodraw.bg or
			              tltodraw.typ),
			flip
			if not i and tltodraw.typ==tywall then
				_typ=tdunjfloor
			end

		 local baseoffset,offsets,sizes=unpack(specialtiles[i and _typ or "default"])
		 local offset,size=
		 offsets[i or 1],
		 sizes[i or 1]
		 --special tiles
			if i then
			 if _typ==tywall and
							(postl.pos.y+genpos.y)%2==0 then
					baseoffset+=vec2s"-6,-2"
				end
				if _typ==thole then
				 _typ+=192
					if i>3 then
					 _typ += 2--brick hole
					 flp=false
					 baseoffset+=vec2s"0,1"
					end
				end
				if (i-2)%3 !=0 then
				 flp=false
				end
			end
			
			drawcall(draw,
							 {_typ,postl,
							 postl.tlscrpos+offset+baseoffset,
							  offset,size,
							 	flp and 
							 		tltodraw.tileflag"6", _bg, 
							 	not(i or _bg)})
		end
		
		local infront,uprtl=fget(_typ,3),adjtl[3]
		
		if bg then
			tdraw(_ENV,_ENV,nil,true)
		end
		
		if not infront and
					fget(typ,5) or
					(_typ==tywall and
					(pos.y+genpos.y)%2==1) then
			tdraw(_ENV,_ENV)
		end
		
		for n=1,6 do
			i=split"2,1,3,4,5,6"[n]
			
			if infront and i==4 then
				tdraw(_ENV,_ENV)		
			end
			
			local _adjtl=adjtl[i]
			if _adjtl then
				local adjtyp = _adjtl.typ
				
			 if _typ!=tcavewall and
				 		_typ!=tempty and
				 		adjtyp==tcavewall 
				then
					tdraw(_adjtl,_ENV,i)
				elseif i<=2 and
					      _adjtl.tileflag"11"
				then
				 walltl=adjtl[i]
					if adjtyp==tywall and
							 i==1 and
							 (walltl.pos.y+genpos.y)%2==0 
					then
					 tdraw(_adjtl,walltl)
					end
					tdraw(_adjtl,walltl,i)
				end
				if (_typ==thole or
				    bg==thole) and
				   i<=3 and
							adjtyp!=thole and
							_adjtl.bg!=thole
				then
				 tdraw(_ENV,_ENV,i+
				 	(_adjtl.ismanmade()
				 	and 3 or 0),--brick hole
				 	bg==thole)--bridges
				end 
			end
		end
		if uprtl and 
					uprtl.tileflag"8" then
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

function passlight(tl)
	return tl.tileflag"1"
end

function getadjtl(pos,i)
	return gettile(i==0 and pos or
	               pos+adj[i])
end

function visitadjrnd(pos,func)
	local indices=split"1,2,3,4,5,6"
	for i=1,6 do
		local n=i+rndint(7-i)
		local tl=getadjtl(pos,indices[n])
		indices[n]=indices[i]
		func(tl,tl.pos)
	end
end

function rndpos()
	return rnd(inboundposes)
end

function alltiles(func)
	for i,tl in ipairs(validtiles) do
		func(tl)
	end
end

function dijkstra(var,tovisit,flag)
	while #tovisit>0 do
		local tl=deli(tovisit,1)
		local d=tl[var]-1
		for k,ntl in ipairs(tl.adjtl) do
			if ntl[var]<d then
				ntl[var]=d
				if fget(ntl.typ,flag) then
					add(tovisit,ntl) 
				end
			end
		end
	end
end

function calcdist(pos,var,mindist)
	alltiles(
	function(ntl)
		ntl[var]=mindist or-1000
	end)
	gettile(pos)[var]=0
	dijkstra(var,{gettile(pos)},0)
end

function viscone(pos,dir1,dir2,lim1,lim2,d)
	pos+=dir1
	local lastvis,notfirst=false
	for i=ceil(lim1),flr(lim2) do
	 local tlpos=pos+i*dir2
		local tl=gettile(tlpos)
	 if tl then
			local vis,splitlim=
			passlight(tl)
			tl.vis=tl.tileflag"5" or
											tl.typ==tywall and
											 player.pos.x<
											 tlpos.x
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
			
			if splitlim then
				local expand=(d+1)/d
				viscone(pos,dir1,dir2,
												expand*lim1,
												expand*splitlim,
												d+1)
			end
			lastvis,notfirst=
			vis,true
		end
	end
end

function calcvis()
	alltiles(
	function(_ENV)
		vis=pos==player.pos
	end)
	for i=1,6 do
		viscone(player.pos,adj[i],adj[(i+1)%6+1],0,1,1)
	end
end

function calclight(clearflash)
 local tovisit={}

 alltiles(
 function(_ENV)
		function checklight(var)
		 local nent =_ENV[var]
			if nent then
				local tlight=nent.stat"light"
				if tlight and tlight>light then
					light=tlight
					if tlight>=3 then
						lightsrc=true
						lcool=nent.lcool
					end
				end
			end	
		end
		if vistoplayer() then
			explored=true
		end
		local flash=max(lflash,lflashl)
		light,lightsrc,lcool=
		flash,flash>1,flash>1
		if (clearflash) lflash=-10
		lflashl=-10
		checklight"item"
		checklight"effect"
		checklight"ent"
  if light>0 then
			add(tovisit,_ENV)
		end
	end)
	dijkstra("light",tovisit,1)
end

-->8
--utility

function screenpos(pos)
	return vec2(pos.x*12,
							 				 pos.y*8+pos.x*4) 
end

function usplit(str,delim)
	return unpack(split(str,delim))
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
	    not tl.tileflag"8" or
	    (tl.ent and block) then
	  break
	 end
		add(ln,tl)
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
	local dir=hexnearest(
	        lerp(p1,p2,1/dist))-p1
	for i=1,6 do
		if (adj[i]==dir) return dir,i
	end
	return dir
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
		all(split(str,delim1))
	do
		local k,v=usplit(var,delim2 or ":")
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
function localfillp(p, _ENV)
 local p16, x = flr(p), x&3
 local f, p32 = 15\2^x*0x1111,p16+(p16>>>16)>><(y&3)*4+x
 return p - p16 + flr((p32&f) + band(p32<<>4, 0xffff - f))
end
-->8
--entities


function create(_typ,_pos,_behav,_group)
	local _ENV=setmetatable({},{__index=_ENV})
	typ,pos,behav,group=
	_typ,_pos,_behav,_group
	
	assigntable("var:ent,xface:1,yface:-1,animframe:0,animt:1,animspeed:0.5,animheight:1,animflip:1,deathanim:death,atkanim:eatk,fallanim:fall,death:41,wpnfrms:0,throwflp:1,movratio:0.25,diri:2,pdist:0,lvl:0,statuses:{}",_ENV)
	assigntable(entdata[_typ],_ENV)						

	animoffset=vec2(0,var=="ent"and 0or 2)
	counts[_typ]=(counts[_typ]or 0)+1
	
--member functions
draw=function()
	if tl.vistoplayer() or
		lasttl and lasttl.vistoplayer()
	then
		tl.initpal()
		if isplayer then
			pal(8,stat"ccol")
			pal(9,stat"acol") 
		end
		if flash then
			pal(split"7,7,7,7,7,7,7,7,7,7,7,7,7,7")
			flash=false
		elseif animpal then
			pal(animpal)
			fillp(lfillp)
		elseif statuses.FROZEN then
			pal(frozepal)
		end
		local flp=xface*animflip<0
		local scrpos=renderpos+
					vec2(flp and -1 or 0,0)
		local frame=
						animframe
						+0.5+yface*0.5
		spr(animtele and 153 or
		    typ+frame*16,
						scrpos.x,scrpos.y,
						1,animheight,
						flp)
		local held=aimitem or wpn
		if isplayer and
			held and
			frame<=5 then
			local wpnpos=vec2list"3,-2|2,-1|1,-2|1,3|3,-3|1,0"[frame+1]
			pal(8,8)
			pal(9,9)
			
			spr(held.typ +
				frame%4*held.wpnfrms,
							scrpos.x+
							wpnpos.x*xface,
							scrpos.y+wpnpos.y,
							1,animheight,
							flp)
		end
		lasttl=nil
	end
end

setanim=
function (name)
	anim,animt,animloop=
	split(entdata[name],""),0,false
		
	if anim[1]=="w" then
		_g.waitforanim=true
		animwait=true
	end
end

checkidle=function()
	if idleanim then
	setanim(idleanim)
	else
		animframe,animheight,anim,animclip=
		0,1
	end
end

checkfall=function()
	if var=="ent" and
	not flying and
				tl.typ==thole
	then
		sfx"24"
		setanim(fallanim)
		if (isplayer) calclight()
	end
end

setpos=function(npos,setrender)
	if npos then
		pos=npos
		tl=gettile(npos)
		tl[var]=_ENV
		if setrender then
			renderpos=entscreenpos()+animoffset
		end
		checkfall()
		if not flying then
			tl.flatten()
		end
	end
end

stat=function(name)
	local val=0
	function checkslot(slot)
		if _ENV[slot] then
			local s = _ENV[slot][name]
			if s then
				val=type(s)=="number" and val+s or s
			end
		end
	end
	checkslot"wpn"
	checkslot"cloak"
	checkslot"amulet"
	
	return val!=0 and val or _ENV[name]
end

setstatus=function(str)
	local k,v=usplit(str,":")
	statuses[k]=split(v)
end

tickstatuses=function()
	for k,v in next,statuses do
		v[1]-=1
		if v[1]<=0 then
			statuses[k]=nil
			if k=="TORCH" then
				wpn.eXTINGUISH()
			end
		end
	end
end

animfuncs={
	function()--[a]ttack
		animoffset=
		movratio*
		screenpos(dir)
	end,
	function()--[b]lood
		animpal=split"8,8,8,8,8,8,8,8,8,8,8,8,8,8"
		animtext".,col:8,speed:0.1,offset:0"
	end,
	function()--[c]lip
		animclip=animoffset.y
	end,
	function()--[d]amage
		doatk(atktl,stat"atkpat")
	end,
	function()--[e] fade
		_g.fadetoblack=true
	end,
	function()--[f]lip
		animflip=-1
	end,
	function()--[g] sleep Z
		if tl.vistoplayer() then
			animtext"z,wavy:1"
		end
	end,
	function()--[h]urt
		hurt(hp>maxhp\20 and 
			min(maxhp\3,hp-1) or
			1000)
	end,
	function()--[i] flash
		flash=true
	end,
	function()--[j] jet start
		shake,_g.shakedamp=1,0.985
		call"music(32,20,3"
	end,
	function()--[k] push collision
		hurt(2)
		animoffset=vec2s"0,0"
		if pushtl.ent then
			pushtl.ent.hurt(2,pushdir)
		end
		if statuses.BURN then
			pushtl.entfire()
		end
	end,
	function()--[l]oop
		animloop=animindex+1
		animt+=rnd(#anim-animindex-1)
	end,
	function()--[m] land
		if stat"fallheal" then
			heal(3)
			call"sfx(17,-1,6"
		end
		if stat"recharge" then
			for i,item in inext,inventory do
				if item.charges then
					item.charges = min(
						item.maxcharges,item.charges+stat"recharge")
				end
			end
			call"sfx(55,-1,6,10"
		end
		if depth==16 then
			call"sfx(61,-1,1,3"
			animtext"\-i◜ dEPTH 16 ◝,speed:0.014,col:14"
		else
			log("\-i◆ dEPTH "..depth.." ◆")
		end
	end,
	function()--[n]one (reset state)
		flip,animtele=1
	end,
	function()--[o] destroy
		destroy(_ENV)
	end,
	function()--[p]ut on wings
		inventory[#inventory].eQUIP()
		sfx"25"
	end,
	function()--[q] blast off
		call"sfx(2)music(-1,300"
	end,
	function()--[r]elease
		animwait=false
	end,
	function()--[s]nap
		renderpos=nil
	end,
	function()--[t]eleport effect
		animtele=true
	end,
	function()--[u] player light
		animt+=1
		light,lcool=
		anim[animindex+1]-4
		call"calclight(,t,t"
	end,
	function()--[v]ertical offset
		animt+=1
		animoffset.y+=anim[animindex+1]-4
	end,
	function()--[w]ait
		_g.waitforanim,animwait=
		true,true
	end,
	function()--[x]new level
		load("intoruins_main","new game")
	end
}

update=function()
	function tickanim()
		animindex=flr(animt)
		local char=anim[animindex]
		
		if type(char)=="string" then
			animfuncs[ord(char)-96]()
			animt+=1
			tickanim()
		else
			animframe=char or 0
			animt+=animspeed
			
			if flr(animt)>#anim then
				if animloop then
					animt=animloop
				else
					checkidle()
					animoffset=vec2s"0,0"
				end
			end
		end
		
		if animclip then
			animheight=1-(animoffset.y-animclip)/8
		end
	end
	
	if anim then
		tickanim()
	end
	if animwait then
		_g.waitforanim=true
	end
	
	if pos then
		renderpos=
			 lerp(renderpos,
			      entscreenpos()+
			      animoffset,
			      0.5)					
	end
end

canmove=function(npos,special)
	local ntl=gettile(npos)
	return
	 (ntl.ent and atk and
	  special != "noatk" and not
	  (ai and ntl.ent.ai) and
	  (ntl.ent.armor or
	   behav=="hunt" or
	   isplayer))
	 or
	 (not ntl.ent and
	  special != "atkonly" and
	  ntl.navigable(flying))
end

move=function(dst,playsfx)
	local dsttile=gettile(dst)
	lasttl=tl
	lookat(dst)
	if dsttile.ent then
		interact(dsttile.ent,
		         wpn or ent)
	else
		tl.ent=nil
		if moveanim then
			setanim(moveanim)
		end
		
		if playsfx then
		 if dsttile.frozen then
	  	call"sfx(28,-1,12,3"
	  else
		  local snd=assigntable"58:37,38:10,54:10,44:38,60:38,40:43"[dsttile.typ]
		  sfx(snd or 35)
		  if snd==43 then
					--bonez
					aggro(playerdst)	
			 end
			end
		end
	 
	 setpos(dst)
	end
end

lookat=function(dst)
	local deltax,lookdir,lookdiri=
	dst.x-pos.x,
	hexdir(pos,dst)
 dir=lookdir
 diri=lookdiri
 if deltax!=0 then 
		xface,yface=
		sgn(deltax),sgn(deltax)
 end
 if lookdir.y!=0 then
 	yface=sgn(lookdir.y)
 end
end

eQUIP=function()
	player[slot]=_ENV
	equipped=true
	if lit then
		player.setstatus"TORCH:160,160,2,9"
	end
end

addtoinventory=function()
 return add(inventory,_ENV)
end

entscreenpos=function()
	return screenpos(pos)+
	        vec2(-2.5,-6.5)
end
--end member functions

	if _pos then
		setpos(pos,true)	
	end
	
	add(ents,_ENV)
	maxhp=hp
	if flippable
	   and rndp() then
		xface*=-1
	end
	checkidle()

	return _ENV
end

-->8
--entity management

function destroy(_ENV)
 if _ENV then
		del(ents,_ENV)
		if tl then
			tl[var]=nil
		end
	end
end
-->8
--level generation

function genmap(startpos,manmade)
	genpos,cave=
	startpos,not manmade
	
	alltiles(function(_ENV)
	 --required for now or we run
	 --out of memory
		adjtl=nil
	end)

	assigntable("world:{},ents:{},validtiles:{},inboundposes:{},tileinbounds:{},drawcalls:{}",_ENV)

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

	alltiles(
	function(_ENV)
		for i=1,6 do
			adjtl[i]=getadjtl(pos,i)
		end
	end)
	
	entropy=1.5
	if manmade then
		genroom(startpos)
	else
		gencave(startpos)
	end
	postproc()
	setupdrawcalls()
	btns=0
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
					destroy(tl.ent)
					
					if (xwall or ywall) and
							 not (tl.typ==tdunjfloor 
							 					and openplan) 
					then
					 if rndp(crumble) and
					    alt!=1 and not
					    (xwall and ywall) then				   
						 tl.typ=tdunjfloor --needs manmade flag
							gentile(txwall,tl)
							if not tl.ent then
								tl.genned=false
								--still want eg. grass
								--to spread here
							end
						else
							tl.set(
								xwall and txwall or tywall)
						end
					else
						tl.set(tdunjfloor)
					end
					tl.manmade=true
				end
			end
	 end
	end
	
	if entropy<1.5 and doroom(true) then
		return genroom(rndpos())
	end
		
	entropy-=0.15+rnd"0.1"
	local crumble = rnd"0.25"
	if entropy>=0 then
		doroom()
		if rndp(0.4-depth*0.025) then
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
		function(ntl,npos)
			if not ntl.genable() then
				if inbounds(npos) and 
							rndp(entropy) then
					gentile(tl.typ,ntl)
					if ntl.genable() then
						if rndp(0.005+depth*0.001) then
							genroom(rndpos())
						end
					 gencave(npos)
					end
				end
			end
		end)
	end
end

function gentile(typ,_ENV)
	local y =	ceil(rnd"15")
	if (ismanmade()) y+=16
	set(mget(typ,y))
	local typ2=mget(typ+1,y)
	flip,genned=
	rndp(),true
 if typ2!=0 then
  if typ2<64 then
 		bg=typ2
	 else
 		create(typ2,pos)
 	end
 end									
end

function postgen(_pos,tl,prevtl)
	tl.postgenned=true
	visitadjrnd(_pos,
	function(_ENV)
		if genable() and not
					postgenned then
			if not genned then
				gentile(tl.typ,_ENV)
			end
			postgen(pos,_ENV,tl.genable() and tl or prevtl)
		end
	end)
end

function postproc()
	function connectareas(permissive)
		for i=1,20 do
			--what a mess
		 calcdist(genpos,"pdist")
		 
			local unreach,numtls={},0
			alltiles(
			function(_ENV)
				if navigable() and
							pdist==-1000 and
							((permissive or
							  not ismanmade()) or
								pos.y%2==1)
				then
					add(unreach,pos)
				end
			end)
			
			if (#unreach==0) return
				
			local bestdist=100
			
			for j=1,200 do
				if #unreach==0 then
					return
				end
				local p1=rnd(unreach)
				local diri=
		   gettile(p1).ismanmade() and
		   not permissive and 
		   rnd(split"1,2,4,5") or
		   rndint(6)+1
				local dir=adj[diri]
				local p2=p1+rndint(18)*dir
				local tl2=gettile(p2)
				if tl2 then
					if tl2.navigable() and
								tl2.genable() and
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
					local nav=tl.navigable()
					if not nav then
					 if tl.ismanmade() then
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
				until nav and tl.pdist>-1000
			end
		end
	end

 connectareas()
	
	--delete bridges lol
	alltiles(
	function(_ENV)
		if tileflag"12" then
			set(thole)
		end			
	end)
	
	--fill out manmade area tiles
	postgen(genpos, 
									gettile(genpos),
									gettile(genpos))
	
	connectareas()
	
	--replace single cavewalls
	alltiles(
	function(_ENV)
		if typ==tempty and 
					inbounds(pos) then
			if adjtl[2].genable() and
				  adjtl[5].genable() then
				gentile(tcavewall,_ENV)
			end
		end
	end)
	
	connectareas(true)
	local numholes,furthestd=0,0
	
		
	function checkspawn(_ENV,_typ,mindist,nolight,allowent)
		if navigable(nolight) and
		 pdist < mindist and
			pdist > -1000 and
			(allowent or not ent) and
			(not nolight or light<=0) 
		then	
			return _typ and create(_typ,pos) or true
		end
	end
	
	alltiles(
	function(_ENV)
		--local uptl,uprighttl,righttl=
		--		getadjtl(pos,2),getadjtl(pos,3),getadjtl(pos,4)
		if typ==tempty then
			--add cavewalls
			for k,ntl in next,adjtl do
				if ntl and 
							ntl.tileflag"5" then--drawnormal
					 typ=tcavewall
				end
			end
		--[[elseif tl.typ==txwall then
			--swap x walls for y
			if uptl and righttl and
			 uprighttl and
				uptl.typ==tywall and
				genable(uprighttl) and
				genable(righttl) 
			then
				tl.typ=tywall
			end]]
		elseif typ==tywall and
		  adjtl[4].typ==txwall
		then
			typ=txwall
		elseif pdist>-1000 and
		 typ==thole 
		then
			numholes+=1
		end
		if checkspawn(_ENV,nil,0,false,true) then
			furthestd=min(furthestd,pdist)
		end
	end)
	
	--create exit holes if needed
	if numholes<3 then
		alltiles(
		function (_ENV)
			if checkspawn(_ENV,nil,furthestd+2.5+rnd(),false,true)
			then
			 set(thole)
				destroy(ent)
			end
		end)
	end
	
	if not player then
		player=create(64,genpos)
	else
	 player.tl=gettile(genpos)
  player.tl.ent,player.animheight,player.animclip,fadetoblack
  =player,1
  add(ents,player)
	end
	calcdist(player.pos,"pdist")
	calclight()
	calcvis()
	calclight()
end

-->8
--game data / init

--custom font
?"⁶!5600⁴⁸⁷\0\0¹\0\0\0\0\0\0⁙³`\0w\0\0p\0\0\0⁶q▮¹\0\0\0\0▮\0\0\0\0p⁷'\0\0\0\0 \0\0\0\0▮□■▮r▶!■□□■!■²\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0⁷⁷⁷⁷⁷\0\0\0\0⁷⁷⁷\0\0\0\0\0⁷⁵⁷\0\0\0\0\0⁵²⁵\0\0\0\0\0⁵\0⁵\0\0\0\0\0⁵⁵⁵\0\0\0\0⁴⁶⁷⁶⁴\0\0\0¹²⁶²¹\0\0\0³2!!.\0\0\0¹\r		\n\0\0\0⁶■9ᵇ1\0\0\0\0\0²\0\0\0\0\0\0\0\0¹²\0\0\0\0\0\0\0\0\0\0\0⁵⁵\0\0\0\0\0\0²⁵²\0\0\0\0\0\0\0\0\0\0\0\0\0²²²\0²\0\0\0⁵⁵\0\0\0\0\0\0⁵⁷⁵⁷⁵\0\0\0⁷³⁶⁷²\0\0\0⁵⁴²¹⁵\0\0\0³³⁶⁵⁷\0\0\0²¹\0\0\0\0\0\0²¹¹¹²\0\0\0²⁴⁴⁴²\0\0\0⁵²⁷²⁵\0\0\0\0²⁷²\0\0\0\0\0\0\0\0²¹\0\0\0\0⁷\0\0\0\0\0\0\0\0\0¹\0\0\0⁴²²²¹\0\0\0⁶			⁶\0\0\0²³²²²\0\0\0²⁵⁴²⁷\0\0\0⁶	⁴⁸⁷\0\0\0\n\n	ᶠ⁸\0\0\0⁷¹³⁴³\0\0\0⁶¹³⁵⁷\0\0\0⁷⁴²²²\0\0\0⁶⁵⁷⁵⁷\0\0\0²⁵⁷⁴²\0\0\0\0²\0²\0\0\0\0\0²\0²¹\0\0\0⁴²¹²⁴\0\0\0\0⁷\0⁷\0\0\0\0¹²⁴²¹\0\0\0⁷ᶜ⁶\0²\0\0\0²⁵⁵¹⁶\0\0\0\0³⁶⁵⁶\0\0\0¹⁷⁵⁵³\0\0\0\0⁶¹¹⁶\0\0\0¹²⁵⁵⁶\0\0\0\0²⁷¹⁶\0\0\0⁶¹¹³¹\0\0\0\0⁶¹⁵⁷⁴\0\0¹³⁵⁵⁵\0\0\0\0³²²²\0\0\0\0³²²²¹\0\0¹⁵³⁵⁵\0\0\0¹¹¹¹²\0\0\0\0ᵇ‖‖‖\0\0\0\0³⁵⁵⁵\0\0\0\0²⁵⁵²\0\0\0\0³⁵⁵⁷¹\0\0\0⁶⁵⁵⁷⁴\0\0\0³⁵³⁵\0\0\0\0⁶³⁴³\0\0\0\0⁷²²⁴\0\0\0\0⁵⁵⁵⁶\0\0\0\0⁵⁵⁷²\0\0\0\0‖‖‖¥\0\0\0\0⁵³²⁵¹\0\0\0⁵⁵⁶⁴³\0\0\0⁷⁴²⁷\0\0\0³¹¹¹³\0\0\0¹²²²⁴\0\0\0⁶⁴⁴⁴⁶\0\0\0²⁵\0\0\0\0\0\0\0\0\0\0⁷\0\0\0²⁴\0\0\0\0\0\0³⁶\rᵇ	\0\0\0⁵\n⁶¥ᵉ\0\0\0⁶	¹¹ᵉ\0\0¹⁶			⁶\0\0\0ᵉ¹ᶠ¹ᵉ\0\0\0⁶¹¹⁷¹¹\0\0ᵉ¹¹	ᶠ⁸\0¹\r⁙■■	\0\0\0³²²²²\0\0\0³²²²²¹\0¹	⁷⁵		\0\0\0³²¹¹ᵉ\0\0\0\n‖‖‖‖\0\0\0	ᵇ\r		\0\0\0⁶			⁶\0\0\0\r□□□ᵉ²\0\0⁶		\r⁶⁸\0\0\r□□\n□\0\0\0ᵉ³⁶⁸⁷\0\0\0ᶠ²²²ᶜ\0\0\0			\r\n\0\0\0		⁵⁶²\0\0\0‖‖‖‖¥\0\0\0ᵇ⁶⁴\n	\0\0\0		\r\n⁸⁷\0\0ᶠ⁴²⁷」\0\0\0⁶²³²⁶\0\0\0²²²²²\0\0\0³²⁶²³\0\0\0\0⁴⁷¹\0\0\0\0\0²⁵²\0\0\0\0○○○○○\0\0\0U*U*U\0\0\0A○]]>\0\0\0>ccw>\0\0\0■D■D■\0\0\0⁴<、゛▮\0\0>○>\0\0\0\0\0\0⁸、>⁸⁸\0\0\0、6w6、\0\0\0p⁸'\0p\0\0\0⁷\0r⁸⁷\0\0\0>gcg>\0\0\0○]○A○\0\0\0、⁴⁴⁷⁷\0\0\0>ckc>\0\0\0⁸、>、⁸\0\0\0\0\0]\0\0\0\0\0>scs>\0\0\0\0\0\r\0\0\0\0\0>、⁸、>\0\0\0>wcc>\0\0\0\0⁵R \0\0\0\0\0■*D\0\0\0\0>kwk>\0\0\0○\0○\0○\0\0\0UUUUU\0\0"
poke(0x5f58,0x81)
memcpy(0xf000,0x5600,0xdff)

_g=assigntable(
[[mode:title,statet:0,depth:0,turnorder:0,btnheld:0,shake:0,invindex:1,btns:0
,tempty:0,tcavefloor:50,tcavefloorvar:521
,tcavewall:16,tdunjfloor:48,tywall:18,txwall:20
,tshortgrass1:54,tflatgrass:38,tlonggrass:58
,thole:32,txbridge:60,tybridge:44
,minroomw:3,minroomh:2,roomsizevar:8
,specialtiles:{},textanims:{},spawns:{},diags:{},inventory:{},rangedatks:{},mapping:{}]],
_ENV)
entstr=[[64=n:yOU,hp:20,atk:0,dmg:2,armor:0,atkanim:patk,moveanim:move,deathanim:pdeath,fallanim:pfall,acol:13,ccol:8,darksight:0,shake:0,isplayer:,yoffs:0,yfacespr:1,canfall:,actor:
70=n:rAT,hp:3,atk:0,dmg:1,armor:0,ai:,flippable:,pdist:-15,alert:14,hurtfx:15,fallanim:fall,profilepic:16,yoffs:0,yfacespr:1,canfall:,actor:
71=n:jACKAL,hp:4,atk:0,dmg:2,armor:0,ai:,flippable:,altpdist:-2,movandatk:,alert:20,hurtfx:21,profilepic:16,yoffs:0,yfacespr:1,desc1:aTTACKS WHILE MOVING⁵gk,canfall:,actor:
65=n:gOB」N,hp:7,atk:1,dmg:3,armor:0,ai:,flippable:,alert:30,hurtfx:11,profilepic:16,yoffs:0,yfacespr:1,canfall:,actor:
66=n:gOB」N MYSTIC,hp:6,armor:0,ai:,flippable:,pdist:-2,alert:30,hurtfx:11,ratks:summon;1_block;0;0;0;22;|heal;1;0;1;0;17,rangep:1,profilepic:16,yoffs:0,yfacespr:1,desc1:sUMMONS SPIRITS,desc2:hEALS AL」ES⁵gk,canfall:,actor:,healer:
67=n:gOB」N ARCHER,hp:6,atk:1,dmg:3,armor:0,ai:,flippable:,pdist:-3,alert:30,hurtfx:11,rangep:0.5,throw:6,throwln:1.125,ratks:throw;4;1;0;0;26,profilepic:16,yoffs:0,yfacespr:1,canfall:,actor:
68=n:gOB」N WARLOCK,hp:6,dmg:4,armor:0,ai:,flippable:,pdist:-3,movratio:-0.25,alert:30,hurtfx:11,ratks:fire;4__;1;0;0;36,rangep:0.25,profilepic:16,yoffs:0,yfacespr:1,desc1:sHOOTS FIRE⁵gk,canfall:,actor:
69=n:oGRE,hp:15,atk:3,dmg:8,armor:1,slow:,knockback:,stun:2,ai:,flippable:,alert:31,hurtfx:16,profilepic:16,yoffs:0,yfacespr:1,desc1:aTTACK TAKES 2 TURNS⁵gk,canfall:,actor:
72=n:bAT,hp:5,atk:3,dmg:8,armor:0,movratio:0.33,ai:,flippable:,behav:wander,nightvision:,burnlight:,flying:,darkspawn:,idleanim:batidle,alert:32,hurtfx:13,profilepic:16,yoffs:0,yfacespr:1,nolightspawn:,desc1:bURNS IN 」GHT,desc2:sEES IN THE DARK⁵gk,actor:
73=n:pINK JELLY,hp:10,atk:1,dmg:2,armor:0,ai:,flippable:,hurtsplit:,deathanim:jellydeath,moveanim:emove,movratio:0.33,alert:19,hurtfx:19,profilepic:0,yoffs:0,desc1:hALVES HP AND SP」TS,desc2:IN TWO WHEN HIT⁵gk,canfall:,actor:
74=n:fLESH HORROR,hp:30,atk:5,dmg:8,armor:0,moveanim:fleshmove,makeflesh:,ai:,flippable:,alert:45,hurtfx:46,movratio:0.33,profilepic:16,yoffs:0,yfacespr:1,desc1:lEAVES FLESH TRAIL.,desc2:sURROUNDS YOU WITH,desc3:FLESH WHEN ATTACKING⁵gk,canfall:,actor:
89=n:pILE OF FLESH,hp:3,nopush:,death:42,hurtfx:10,flippable:,idleanim:fleshidle,yoffs:0,deathanim:fleshsplode,canfall:,isflesh:
75=n:sPECTRAL BLADE,hp:3,atk:2,dmg:2,armor:0,alwayshunt:,movratio:0.6,death:44,idleanim:hover,deathanim:bladedeath,flying:,ai:,flippable:,behav:hunt,light:3,lcool:,profilepic:16,yoffs:0,yfacespr:1,actor:
76=n:mIRRORSHARD,hp:8,ai:,flippable:,pdist:-2,altpdist:-4,dmg:6,armor:1,behav:wander,deathanim:sharddeath,rangep:0.3333,freezeturns:8,flying:,hurtfx:48,alert:47,idleanim:hover,ratks:blink;3_block_;-1;0;1;29|ice;6_pass_;1;0;0;28|lightning;6_pass_;1;0;0;9,profilepic:16,yoffs:0,yfacespr:1,desc1:sHOOTS 」GHTNING,desc2:sHOOTS ICE,desc3:tELEPORTS⁵gk,actor:
77=n:gLOWHORN,hp:6,atk:3,dmg:4,knockback:,movandatk:,sporedeath:5,armor:0,ai:,flippable:,altpdist:-2,light:3,lcool:,alert:49,hurtfx:50,deathanim:horndeath,profilepic:16,yoffs:0,yfacespr:1,desc1:aTTACKS WHILE MOVING,desc2:bURSTS INTO SPORES⁵gk:,canfall:,actor:
78=n:dRAGON,hp:20,atk:5,dmg:8,armor:5,nofire:,ai:,flippable:,moveanim:emove,rangep:0.33,alert:51,hurtfx:52,scrxoffset:-6.5,width:2,movratio:0.33,ratks:fire;4_pass_;1;0;0;51,profilepic:17,yoffs:0,yfacespr:1,desc1:bREATHES FIRE,desc2:dOESN'T BURN⁵gk,canfall:,actor:
137=n:mUSHROOM,hp:1,sporedeath:12,light:4,lcool:,deathanim:mushdeath,flippable:,flammable:,death:42,nopush:,yoffs:1,desc1:bURSTS INTO HEA」NG,desc2:SPORES⁵gk,canfall:
136=n:bRAZIER,hp:1,nofire:,hitpush:,pushanim:brazierpush,fallanim:brazierfall,hitfire:,light:4,idleanim:brazieridle,deathanim:brazierdeath,death:23,yoffs:0,desc1:eASILY KNOCKED OVER⁵gk,canfall:
169=n:cHAIR,hp:3,nofire:,hitpush:,pushanim:proppush,fallanim:propfall,flippable:,deathanim:propdeath,death:23,yoffs:0,canfall:
200=n:bARREL,hp:3,hitpush:,pushanim:proppush,fallanim:propfall,flammable:,deathanim:propdeath,death:23,yoffs:0,canfall:
138=n:fIRE,var:effect,light:4,idleanim:fireidle,deathanim:firedeath,animspeed:0.33,flippable:
139=n:sPORES,var:effect,light:4,lcool:,idleanim:sporeidle,deathanim:firedeath,animspeed:0.33,flippable:,flying:
brazieridle=l001122
fireidle=01f0ln1n2n3f1f2f3
firedeath=n20o
sporeidle=0l112233
batidle=l0022
move=n044
turn=n44
throw=a444
emove=n022
esplit=n02022
hover=lv3000000v5000000
bladesummon=45t2n
bladedeath=w2t5n54ro
sleep=lg000000000000000000000
flash=li0000000000000000000000000000000000000000000
patk=wa22d22r
eatk=wna22dr22
ratk=wna22r22
batatk=wa20dr22
death=wb0cv50v500v50ro
jellydeath=w0cv60v32v52b22ro
sharddeath=wv72i2t22ro
pdeath=w444l6
mushdeath=w01ro
horndeath=wb0cv50t11ro
brazierdeath=w333ro
brazierpush=w3kr
brazierfall=w3v53v53v63cv73v83v83ro
fleshidle=sv5cv62sv3sv30222l00002222
fleshmove=c2v500v3
fleshdeath=cv70v50v50o
fleshsplode=wb0v5cv6bt00ro
propdeath=w111ro
proppush=w1kr
propfall=w1v51v51v61cv71v81v81ro
push=w2kr
tele=rst0ni0
fall=w0v50v50v60cv70v80v80ro
pfall=w0v54v54v64cv74v84v84e444rx
fallin=wwsv90v90v94v94sv5mh46666666sv54v3440r
slofall=wwsv94v84v74v64v54v54v54v54v544v5444v54m00r
victory=w00000000000000000000000p440000000000000000000000u8j2222v32v52v32v52v32v52v32v52v32v52v32v52v32v52v32v52qu9v12v02v4v02v3v02u8v2v02v1v02v0v02u7v0v02v02v0v02u6v0v02v0v02v0v02u5v0v02v0v02u4v0v02v0v02u3v0v0u02l0
130=n:tORCH,var:item,slot:wpn,dmg:3,atk:1,lit:,throw:4,light:4,throwln:0,wpnfrms:16,idleanim:flash,desc1:cAN'T BE RE」T⁵gk,canfall:
132=n:sPEAR,var:item,countid:wpn,slot:wpn,dmg:3,atk:1,guard:,throwatk:3,throwdmg:5,throw:6,throwln:0.25,wpnfrms:16,idleanim:flash,rndlvl:,desc1:wHILE WAITING ATTACK,desc2:CREATURES WHO MOVE,desc3:IN FRONT OF YOU⁵gk,canfall:
133=n:rAPIER,var:item,countid:wpn,slot:wpn,dmg:2,atk:3,lunge:,throw:4,throwln:1,wpnfrms:16,idleanim:flash,rndlvl:,desc1:aTTACK WHEN STEPPING,desc2:TOWARDS A CREATURE⁵gk,canfall:
134=n:aXE,var:item,countid:wpn,slot:wpn,dmg:3,atk:1,arc:,throw:5,throwdmg:5,wpnfrms:16,throwflp:-1,atkpat:1|3,idleanim:flash,rndlvl:,canfall:
135=n:hAMMER,var:item,countid:wpn,slot:wpn,dmg:6,atk:1,stun:3,knockback:,slow:,throw:2,throwdmg:3,wpnfrms:16,idleanim:flash,rndlvl:,desc1:aTTACK TAKES 2 TURNS⁵gk,canfall:
129=n:oAKEN STAFF,var:item,throw:4,idleanim:flash,rndlvl:,canfall:
145=n:dRIFTWOOD STAFF,var:item,throw:4,idleanim:flash,rndlvl:,canfall:
161=n:eBONY STAFF,var:item,throw:4,idleanim:flash,rndlvl:,canfall:
177=n:pUPLEHEART STAFF,var:item,throw:4,idleanim:flash,rndlvl:,canfall:
140=n:bRONZE AMULET,acol:9,var:item,slot:amulet,throw:4,idleanim:flash,canfall:
141=n:pEWTER AMULET,acol:5,var:item,slot:amulet,throw:4,idleanim:flash,canfall:
142=n:gOLDEN AMULET,acol:10,var:item,slot:amulet,throw:4,idleanim:flash,canfall:
143=n:sILVER AMULET,acol:6,var:item,slot:amulet,throw:4,idleanim:flash,canfall:
156=n:oCHRE CLOAK,ccol:9,var:item,slot:cloak,throw:2,idleanim:flash,canfall:
157=n:gREY CLOAK,ccol:5,var:item,slot:cloak,throw:2,idleanim:flash,canfall:
158=n:gREEN CLOAK,ccol:3,var:item,slot:cloak,throw:2,idleanim:flash,canfall:
159=n:cYAN CLOAK,ccol:12,var:item,slot:cloak,throw:2,idleanim:flash,canfall:
172=n:cYAN ORB,var:item,light:2,throw:6,idleanim:flash,canfall:
173=n:yELLOW ORB,var:item,light:2,throw:6,idleanim:flash,canfall:
174=n:rED ORB,var:item,light:2,throw:6,idleanim:flash,canfall:
175=n:bLACK ORB,var:item,light:2,throw:6,idleanim:flash,canfall:
188=n:gREEN ORB,var:item,light:2,throw:6,idleanim:flash,canfall:
189=n:oRANGE ORB,var:item,light:2,throw:6,idleanim:flash,canfall:
190=n:pURPLE ORB,var:item,light:2,throw:6,idleanim:flash,canfall:
191=n:pINK ORB,var:item,light:2,throw:6,idleanim:flash,canfall:
201=n:wINGS OF yENDOR,var:item,light:2,slot:wpn,wpnfrms:8,idleanim:flash,victory:,desc1:aRTIFACT OF LEGEND
248=,nid:oRB OF 「¥,countid:life,orb:life,orbfx:17,desc1:hEALS YOU FULLY⁵gk,desc2:+3 TO MAX HP⁵gk
249=,nid:oRB OF gRAVITY,countid:slofall,orb:slofall,orbfx:54,desc1:lAND SA¥LY WHEN,desc2:DESCENDING⁵gk,desc3:tHROW TO PUSH,desc4:NEARBY CREATURES⁵gk
250=,nid:oRB OF pOWER,countid:empower,orb:eMPOWER,orbfx:55,desc1:pERMANENTLY,desc2:EMPOWERS AN ITEM⁵gk
251=,nid:oRB OF dATA,countid:identify,303,orb:iDENTIFY,orbfx:18,desc1:iDENTIFY AN ITEM⁵gk,desc2:tHROW TO IDENTIFY,desc3:A CREATURE⁵gk
252=,nid:oRB OF 「GHT,countid:light,orb:light,orbfx:53,desc1:pROVIDES 」GHT F⁵fgOR A,desc2:WHILE⁵gk,desc3:tHROW TO BRIEFLY 」GHT,desc4:A LARGE AREA⁵gk
253=,nid:oRB OF fIRE,orb:fire,orbfx:36,desc1:cREATES A BURST OF,desc2:FIRE⁵gk
254=,nid:oRB OF iCE,orb:ice,orbfx:28,desc1:fREEZES NEARBY,desc2:CREATURES⁵gk,desc3:(dAMAGE REDUCES,desc4: FREEZE DURATION)⁵gk,freezeturns:8
255=,nid:oRB OF tELEPORT,orb:tele,orbfx:29,desc1:tELEPORTS TARGET TO,desc2:A RANDOM LOCATION⁵gk
308=,nid:aMULET。OF。dE¥NSE,countid:wearable,armor:1,rndlvl:
309=,nid:dARKSIGHT aMULET,countid:wearable,darksight:1,rndlvl:
310=,nid:aMULET OF。wISDOM,countid:wearable,recharge:1,rndlvl:,desc1:
311=,nid:aMULET OF rECKONING,dmghurt:,fallheal:,cursed:,idprefix:ᶜe³i✽,desc1:dEA」NG MELEE DAMAGE,desc2:HURTS YOU⁵gk,desc3:dESCENDING HEALS +3⁵gk
312=,nid:cLOAK OF dE¥NSE,countid:wearable,armor:1,rndlvl:
313=,nid:dARKSIGHT cLOAK,countid:wearable,darksight:1,rndlvl:
314=,nid:cLOAK OF wISDOM,countid:wearable,recharge:1,falleffect:,rndlvl:,desc1:
315=,nid:vAMPIRE cLOAK,burnlight:,dmgheal:,cursed:,idprefix:ᶜe³i✽,desc1:cATCH FIRE IN 」GHT⁵gk,desc2:dEA」NG MELEE DAMAGE,desc3:HEALS YOU⁵gk
316=,nid:sTAFF OF fIRE,countid:wpn,dmg:4,charges:3,maxcharges:3,range:3,rangetyp:fire,usefx:36,desc1:cREATES A 」NE OF FIRE,desc2:AND DAMAGES TARGET⁵gk
317=,nid:sTAFF OF lYTNING,countid:wpn,dmg:4,charges:3,maxcharges:3,range:3,linemode:pass,rangetyp:lightning,usefx:9,desc1:zAPS MUL⁵fgTIPLE TARGETS,desc2:IN A 」NE⁵gk
318=,nid:sTAFF OF iCE,countid:wpn,charges:3,maxcharges:3,range:3,linemode:pass,freezeturns:7,rangetyp:ice,usefx:28,desc1:fREEZES MUL⁵fgTIPLE,desc2:TARGETS IN A 」NE⁵gk,desc3:(dAMAGE REDUCES,desc4: FREEZE DURATION)
319=,nid:sTAFF OF b」NK,countid:wpn,charges:3,maxcharges:3,range:3,linemode:block,rangetyp:blink,usefx:29,desc1:tELEPORT TO TARGET,desc2:SPACE⁵gk
58=37
38=10
54=10
44=38
60=38
40=43
48=35
50=35
52=35
46=35
34=35
]]
entdata=assigntable(
									entstr,nil,"\n","=")

poke2(0x8000,#entstr)
?"\^!8002"..entstr

adj,fowpals,frozepal,ided,counts,enchstats=
vec2list"-1,0|0,-1|1,-1|1,0|0,1|-1,1",--adj
{split"0,0,0,0,0,0,0,0,0,0,0,0,0,0",
split"15,255,255,255,255,255,255,255,255,255,255,255,255,255",
split"241,18,179,36,21,214,103,72,73,154,27,220,93,46"
},
split"1,13,6,6,13,7,7,6,6,7,13,7,6,7",--frozepal
assigntable"130:,131:,132:,133:,134:,135:",--ided
assigntable"301:-1",--counts
split"lvl,hp,maxhp,atk,throwatk,dmg,throwdmg,armor,darksight,recharge,range,charges,maxcharges"--enchstats

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
◆54
-3,-4
1,0
7,7
◆default
-8,-4
1,0
15,8]],"◆")) do
	local typ,baseoffset,offset,size=usplit(s,"\n")
	specialtiles[typ]=
	{vec2s(baseoffset),
	 vec2list(offset),
	 vec2list(size)}
end

for i=0,19 do
	local curspawns,group=
	add(spawns,{}),{}
	for x=64,127 do
		local typ=mget(x,i)
		if typ>0 then
			add(group,typ)
		elseif #group>0 then
			add(curspawns,group)
			group={}
		else
		 break
		end
	end
end

for str in all(split([[
172,173,174,175,188,189,190,191|248,249,250,251,252,253,254,255
140,141,142,143|308,309,310,311
156,157,158,159|312,313,314,315
129,145,161,177|316,317,318,319]]
,"\n")) do
 local grps=split(str,"|")
	local items=split(grps[1])
	for s in all(split(grps[2])) do
		local i=del(items,rnd(items))
		entdata[i]..=entdata[s]
		mapping[s]=i
		counts[i]=counts[s] or 0
	end
end

local rseed=rnd"0xffff.ffff"
srand"0x5b04.17cb"
genmap(vec2s"10,13")
srand(rseed)

smoothb=vec2s"120,115"

create(130).addtoinventory().eQUIP(true)
calclight()

?"\^!5f5c\9\6"--key repeat poke

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
fffffffffffffffffffffffffffffffffffffffffffffffffffffffff3ffffffffff555565555fffffff3f3f3f3ff3ffffffffffff505ffffffffff5ffffffff
fff000110111fffffff01111111110fffff01111111110fffffffffffbfffffffff5000d000005ffffff3f3ff3bf3ffffffffff5502202ffffff5055d11000ff
ff0111000111f10fff0111111111110fff0111111111110ffffffffffff3ffffff5011d01111106fffff3f3ff3b03fffffff05502202202fffff1000000055ff
f01111011000111ff011100111111110f011111111111110fffff3fffffbfffff5011d0111111d05ffff3ff3f3ffbffff505202202205504fff15500d00555ff
000000111101fffff1111111111111110101111111111111fffff3ff3ffffffffd1110111111d01dfffff3f3fbffbfff022022022055044fff00555dd00500f1
f0110000101111fff011111110011110f011111111100110fffffbf3fffffffff0d11111111101d0fffffbf3fbff00fff02202505404fffff051005d10d111ff
ff00111100011fffff0111111111110fff01111111111ffffffffffbffffffffff0d111111d11d0fffff0b0bffffffffff055044ffffffffffff1111055d1fff
fff00110111fffffffff111111111fffffff111111111fffffffffffffffffffffffddddd6dddffffffffffbfffffffffff44ffffffffffffffff51f111fffff
fff67fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff62fff00d6000000000000000000000000000000d6566600000000000000000000000000000000000000000000000000000000000000000000000000000000
ff888fff0006000d6666500566666000666d000000066005600d6005600d600d6666500006666000000000000000000000000000000000000000000000000000
ff88dfff000600006000650006000006500600000006000560006000600060006000650060000000000000000000000000000000000000000000000000000000
ff88d6ff00060000605006000600000600060000000600d600006000600060006050060056665000000000000000000000000000000000000000000000000000
ff882fff000600006000060006000006000600000006056500006000600060006000060000006000000000000000000000000000000000000000000000000000
ff2f2fff000600006000d50006500006005600000006000650006500600060006000d50060056000000000000000000000000000000000000000000000000000
ffd0dfff00d6000d60006600006d000d6660000000d6000d60000666d000600d60006600d6660000000000000000000000000000000000000000000000000000
fff67ffffff67fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff22ffffff62faf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff882fffff888f9f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff8d9fffff88df4f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff86dfffff88d6ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff826fffff882fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff2f2fffff2f2fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffd0dfffffd0dfff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff67fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff88fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff8886ff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff88dfff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f8822fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff2f2fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fd00dfff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff67fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff22fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff822fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff6d9fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f86226ff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ff6f2fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fd00dfff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff67ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fff62fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff99ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ff888fffffffff3fffffffffffffffffffffffffffffffffffffffffffffffffff899ffffffffffffffffffffffffffffff40ffffff50ffffff94ffffff65fff
ff88d6fffffff44ffffafffffffffffffffff7fffffffffffffff4ffffff97ffff998ffffffccffffff8fffffffffcffff4ff4ffff5ff5ffff9ff9ffff6ff6ff
ff88dffffff4400ffff9fffffff5ffffffffdfffffff7fffffff5d6fffff997fff544fffffccc7ffff8ffffffffffffffff49ffffff56ffffff9affffff67fff
f8822ffff4400ffffff4fffffff4fffffff4ffffff56fffffff4f6fffff5f9fffff5ffffffffdffff898ffffffffffffff4fffffff5fffffff9fffffff6fffff
ff25fffff00fffffffffffffffffffffff4fffffff5fffffff4fffffff5fffffff554ffffcf2d2fff8998fffffffffffffffffffffffffffffffffffffffffff
ff0dfffffffffffffffffffffffffffff4ffffffffffffffffffffffffffffffff505ffffdf00fffff88ffffffdfffffffffffffffffffffffffffffffffffff
fff67ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fff22fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff899fffffcfcfffff8fffffcfffffffffffffffffffffffffffffffffffffff
ff882fffffffffcfffffffffffffffffffffffffffffffffffffffffffffffffff998ffff7fdf7fff998ffffffffffffffff9fffffffdfffffff3fffffffcfff
ff8d9ffffffff66ffffaffffffffffffffffffffffffffffffffffffffffffffff998fffcfdfdfcff8998ffffffff7ffff9999ffffdd5dffff3333ffffccccff
ff86dffffff6600ffff9fffffff5ffffffffffffffffffffffffffffffff97ffff454ffffdfffdff899998fffffffffff4490ffff5550ffffbb30ffffddc0fff
f82626fff6600ffffff4fffffff4ffff44ffffffff567ffffffff4fffff5997ffff5ffffcfdfdfcf8999998ffffffffcf900fffff500fffff300fffffc00ffff
fff22ffff00fffffffffffffffffffffff44ffffffdfffffff445d6fff5ff9ffff554ffff7fdf7ff8899998ffffffffff0fffffff0fffffff0fffffff0ffffff
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
fffffffffffffffffffffff000ffffffffff000fffffffffffffffffffffffffffffffffffffffffa999888876555555ffffffffffffffffffffffffffffffff
ffffff0100000fffffffff0000000ffffff0000000ffffffffffffffffffffffffffffffffefefff544fffff76655555ffffffffffffffffffffffffffffffff
000ff00100011fff00fff0000000000fff00000000000fffffffffffffffffffff222ffffe757eff76d44444ffffffffffffffffffffffffffffffffffffffff
0010110180018f0000ff0000000000dff000000000000000ffffffff0ffffffff22222fffe656effffffffffffffffffffffffffffffffffffffffffffffffff
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
ffff115515150fffffffff0000fffffffffffffff000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff042992242fffffffffffffffffff
fff11015010105ffffff001500fffffffffff0bbb00fffffffff9ffffffb9f33fff000110111ffffffffffffffffffffffff150000050ffffff000880811ffff
ffd110111101011ffff10011015ffffffff10bbbbbb8f1fff33ff9fff0b0f3ffff011d005111f10fffffffffffffffffffff005222202fffff0111000111f10f
fd11001101000101ff1d1000011001ffff10b11bbb9d111ffff3ff3f99ff3ffff01150d9195015d0ffffffffffff9fffffff050000050ffff011110180001110
5151000000000100f155000100000155fff05551195dffffffff3f3fff3fbfff00005550050d0000fffffffffff9ffffffff042922240fff0000001111080000
11500011010000011150f00011000011f01155155d501100fffffbfbffb00ffff011000050050100fffff9fffff3ffffffff021000100ffff011000010111100
1101fffffffff1015001ffff00000100ff0000155d01100fffff0b0bfbffffffff0011510050500fffffff9ffff3ffffffff042222242fffff0011110001100f
101fffffffffff005001fffffff00001fff00100001000fffffffffbfffffffffff00150110005fffff3ff3f9ff3f3ffffff050000020ffffff00110111000ff
ffffff88fffffffffffffff888ffffffffffffff88fffffffffffffff9ffffffffff555979555fffffff3f3f3f3ff3ffffffffffff505ffffffffff5ffffffff
fff000110881fffffff01111111110fffff01111111110fffffffffffbfffffffff5000d800005ffffff3f3ff3bf3ffffffffff5904202ffffff5055d11000ff
ff0111000111f10fff0111111111110fff0111118111110ffffffffffff9ffffff5011d08111106fffff3f3ff3b03fffffff05902902202fffff1000050045ff
f011110180001110f011100111111110f011111111111110fffff9fffffbfffff5011d0181111d05ffff3ff3f3ffbffff505502402405504fff15500d55455ff
000000111101000001111118111111110101111111111111fffff3ff9ffffffffd1110111111d01dfffff3f3fbffbfff022022022055044ff0005559d0550001
f011000010111100f011111110011110f011111111100110fffffbf3fffffffff0d11111111101d0fffffbf3fbff00fff02202505404fffff051005910d11100
ff0011110001100fff0111111111110fff0111111111100ffffffffbffffffffff0d111111d11d0fffff0b0bffffffffff055044ffffffffff0011110559100f
fff00110111000fffff01111111110fffff01111111110fffffffffffffffffffff0ddddd6ddd0fffffffffbfffffffffff44ffffffffffffff00510111000ff
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000d6000000000000000000000000000000d6566600000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000006000d6666500566666000666d000000066005600d6005600d600d6666500006666000000000000000000000000000000
00000000000000000000000000000000600006000650006000006500600000006000560006000600060006000650060000000000000000000000000000000000
0000000000000000000000000000000060000605006000600000600060000000600d600006000600060006050060056665000000000000000000000000000000
00000000000000000000000000000000600006000060006000006000600000006056500006000600060006000060000006000000000000000000000000000000
00000000000000000000000000000000600006000d50006500006005600000006000650006500600060006000d50060056000000000000000000000000000000
0000000000000000000000000000000d6000d60006600006d000d6660000000d6000d60000666d000600d60006600d6660000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000h0100000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000001h000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000h5000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000hhd000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000d0h000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000050h000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000005h0h00000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000dh00000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000010100000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000010000001d00h000000000000000000010000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000010001111d00000000h0000000000000h1000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000010110150015d010000000000000000000000h0100000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000011050150105d010000000000000000000000100111h15hh000000000000000000000000000000000000
0000000000000000000000000000000000000000000001d050110100d1010000000000000000000h000hh0h01h0h010000000000000000000000000000000000
0000000000000000000000000000000000000000000011d01011010111d10000000000000h0000000h0hh01hhh0h0h1000000000000000000000000000000000
00000000000000000000000000000000000000000000d010100000011d1100000000000000000000000000h01h00000000000000000000000000000000000000
00000000000000000000000000000000000000000000d01011551515515100000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000d1011015010111500100000000000000000000000hh0hh00010000000000000000000000000000000000
0000000000000000000000000000000000000000000000d11011110111010000000100000000000000000000000h010000000000000000000000000000000000
00000000000000000000000000000000000000000000010100110100101000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000010000001d00010d001000000000000000000000001000000000000051000000000000000000000000000000000
0000000000000000000000000000000000000010001111d001009000000000000000000001000000000000000000011000000000000000000000000000000000
00000000000000000000000000000000000010150015d01000005d00000000000000000000000000000000000000010100000000000000000000000000000000
00000000000000000000000000000000000050150105d01000011d00900000000000000000000000000000000000010000000000000000000000000000000000
00000000000000000000000000000000000050110100d10000011501d0000000670100000000000000000000d001000100000000000000000000000000000000
00000000000000000000000000000000000010110101110400001101d0000100620a00000000000000000100c000010100000000000000000000000000000000
000000000000000000000h01000000000000100000011001100115001d0000088809000000000000300000005d00000000000000000000000000000000000000
0000000000000000000001h000000000000000000000011101011100115000088d04000000000003000000011d00c00000000000000000000000000000000000
000000000000000000000h50000000000000111011111011010110d0101011188d61100003000003000000011501d00000000000000000000000000000000000
00000000000000000000hhd000000000000150111111110011010050100111188211110000300003000d00001101d00000000000000000000000000000000000
00000000000000000000d0h0000000000011100111111110111110111011911212001113003030030301000115001d0000000000000000000000000000000000
0000000000000000000050h0000000000111111111111111000000000111191d0d11111130303030031100011100115000000000000000000000000000000000
000000000000000000005h00hhhhhhhhh011111110011110111111111011130011191110313113j13011000110d0101000000000000000000000000000000000
00000000000000000000hh00hh1hhh1hhh01111111111101111111111101131111911101313113j0310010010000100000000000000000000000000000000000
0000000000000000000010h11hh11h001hh011111111101111111100111313119131131130031311j11010110001100000000000000000000000000000000000
0000000000000000000000hhh1hhh1hhh1hh00000000011111111111111300303030311113131j11j11000000000000000000000000000000000000000000000
0000000000000000000000hhhh00hhhhhhh011111111101105000111111031j3113130111j131j01001000000000000000000000000000000000000000000000
00000000000000000000000hhh1hhh1hhh0111111111110001000010000130j3113131010j0j1111110000000000000000000000000000000000000000000000
0000000000000000000000001hh11hh11011111101111000000000000000j11313000110111j1111100000000000000000000000000000000000000000000000
000000000000000000000000000000000101111001110000000000000000j11j1310111100000000000000000000000000000000000000000000000000000000
000000000000000000000000hhhhhhhhh011111000100000000000000000000j1310111000000000000000000000000000000000000000000000000000000000
00000000000000000000000hhh1hhh1hhh0111100001000000000000000011011j00010000000000000000000000000000000000000000000000000000000000
0000000000000000000000h11hh11h001hh011000001000000000000000011010j10100000000000000000000000000000000000000000000000000000000000
0000000000000000000001hhh1hhh1hhh1hh00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000hhhh00hhhhhhh000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000hhh1hhh1hhh0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000001hh11hh1100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
000000000000000000000000000000004000800880082c000000ee00be00ee007a016301ba016b03f32109096b15b321b32173217321730323017d036b15ea0104040404000000000000000000000000040404040000000000000000000000000404040400000000000000000000000004040404000000000000000000000000
0000000001010101008000000000000000000000010101010000000000000000040000000101010300000000000000000400000001010103000000000000000001010000000000000000000000000000010110002000700000003000300030000000000010000407040100090401040004000407040004070400040904003000
__map__
000000000000000000000000000000001011ca0014150000000000001c1d000020210000242500002829000000002e2f303132333435363738393a3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003200cb0000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003200000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003200363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003400363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003400363400003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000016000000000000000000000032000000200000003200000032000000000032003200340034003a3200003a340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000016000000000000000000000032000000200000003200000032000000000032003200340034003a32000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000032890000000000000000000032000000200000003200000032000000000032003200340034003a34000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000032890000000000000000000032000000100000003200000032000000000032003200340020003200000036320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000034890000000000000000000032000000100000003200000032000000000032003200340036323200000036340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000034890000000000000000000032000000340000003200000032000000000032003200320036343400000036340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001011000014150000000000001c1d000020210000242500002829000000002e2f303132333435363738393a3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002ec80000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e0000000000000030000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e0000000000000030000000200000002ea900003000000000001c00300030003000363000003a2e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e0000000000000030000000200000002ea900003000000000002ea93000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003e0000000000000030000000200000002ea9000030000000000028003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003e0000000000000030000000200000002ea900003000000000002ec83000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000003e0000000000000030000000200000002ea9000030000000000024003000300030003630000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001e0000000000000030000000200000002ea9000030000000000030882e0030003000362e000036300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001a0000000000000030000000200000002ea900002e000000000020002e002e002e003a2e0000362e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002ec800000000000030000000200000002ea900002e000000000036302e002e002e003000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000308800000000000030000000300000002ea900002e0000000000362e2e002e002e002e0000002e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
38500810220342202022010220122201022010220150060518500185000f5000f5001350013500165001650018500185000f5000f5001350013500165001650018500185000f5000f50013500135001650016500
900100000064000620006100061000610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900200000062403630036000062000610006000060000600056000060005600016000060000600006000060000600006000060000600005000050000600006000050000500005000050000500005000050000500
c4281400184151a4151f41521415184151a4151f41521415184251a4251f42521425184251a4251f42521425184251a4251f415214152140523405284052a4050000000000000000000000000000000000000000
48030c1c0862424524240242404124051240412403124021240212402124021240212403124031240412404124031240312402124021240312403124041240412403124031240212402124011240112401123011
480800000a05301030010210102101015010000100001000010000100000000000000800301000010000905301030010210102101015006450051300503050050000000000000000000000000000000000000000
520a100000605006053a6053a6053b615000053b6253a6053b6150000000000000003d6103d615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
970609003561400600006010060300601006010060300601006050060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
9002060017a1417a1017a1017a1017a1017a100060009a0009a0009a0009a0009a0009a0000600006000060000600006000060000600005000050000600006000050000500005000050000500005000050000500
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
900b04003f00438011320212900100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
9001190019920199201992019920199201992019920199200d9000d9000d900059100591005910059100591005910059100591005910059100591005910059100b9000b9000b9000b9000b9000b9000b9000b900
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
480210000261000620036100161000600006100061000610006000061000600006000050000500006150060000500005000050000500005000050000500005000000000000000000000000000000000000000000
79020b000e91006010040110301500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a9030800260242a011001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000000000000000000000000000000000000000000000000000000000
920100003b3153461034615270000000000000000000000000000000002b6002e600000000000000000000003931530610306151a6052900029000290053b6000000000000000003b600000003b600000003b600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
90010d0007615006110061524500316000060000600006003162500610006110060100601006011e60500601006010060100601006051d600006050560004600000000060500000000000a600086050000002600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
0003002000600026000c6000260008600016000860001600106000360009600026000560006600016000b600066000160003600046000260009600016000a600026000460003600076000b600036000660003600
04a014001882018820188251b8001c8001e8101e8241e81518c001bc001f8101f8101f815240002a8001f8201f825158000000000000000000000000000000000000000000000000000000000000000000000000
6ca00014155141e52621517155120e5111e5141e5141e502175141f5061c51418516185121a5111a5121b5111b5141b5121b5121b5133f5000050000500005000050000500005000050000500005000050000500
6050000014e0424e2015c2415c301ac541ac401ac301ac301ac2015c3019c3019c4019c3419c351bc000000000000000000000018c2418c5418c5018c3018c4018c541cc161cc301cc301cc2017c5016c5416c55
00a0140019d7019d7019d7019d7019d0019d7018d7018d7018d0018d7017d7017d7017d7017d7017d0017d701dd701dd7027d00000001dd000000000000000000000000000000000000000000000000000000000
90a014001fb441fb401fb441fb401fb351de301eb441eb401eb201eb201fb441fb401fb441fb401fb2020b4420b4020b3020b2020b10000002d4002c400000000000000000000000000000000000000000000000
04a014001782017820178251fc0023c0516820168341682524c001bc0017820178201782500000000001482014825000000000000000000000000000000000000000000000000000000000000000000000000000
6050000028c0411c001bc0015c301ac541ac401ac301ac301cc2417c5018c5418c5018c3418c351bc000000000000000000000028c0411c001bc0015c0015c331ac541ac401ac301ac301cc2417c5016c5416c55
00a014001ed701ed001ed701ed701ed001ed701dd701dd701dd001dd701cd701cd001cd701cd701cd001cd7018d7018d7027d0018d001dd00000001dd00000000000000000000000000000000000000000000000
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
00 3d383c6a
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

pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--keep:iNTO rUINS
--keep:BY ERIC BILLINGSLEY
--keep:
--keep:unminified source available at
--keep:https://github.com/woflox/intoruins
--keep:

function modeis(m)
	return mode==m
end

function getbtn(b)
	b&=btns
	btns&=~b
	return b!=0
end

function _update()
	btns|=btnp()

	if modeis"play" and not waitforanim then
		updateturn()
	elseif modeis"aim" then
		updateaim(unpack(aimparams))
	elseif modeis"reset" and
	 statet>0.3 
	then
	 load"intoruins"
	end
	
	statet+=0.03333
	
	if mode!="ui" then
 	waitforanim=#rangedatks>0
		for i,_ENV in inext,ents do
			update()
		end
 end
	
	local camtarget= 
 	screenpos(
 		lerp(player.pos,
 							vec2s"10,9.5",
 							(modeis"gameover" or
							modeis"victory") and
 							max(0.36-statet*2) or
 							0.36))
	smoothb=lerp(smoothb,camtarget,0.5)
	smooth=lerp(smooth,smoothb,0.25)
	
	function getcampos(val)
	 return flr(rnd(player.shake*2)-
	            player.shake+val-63.5)
	end
	
	campos=vec2(getcampos(smooth.x),
													getcampos(smooth.y))
	player.shake*=shakedamp
end

function _draw()
	cls()
	camera(campos.x,campos.y)
	lfillp,anyfire=localfillp(0xbfd6.4,
								-campos)

	for i,drawcall in 
					inext,drawcalls do
		drawcall[1](
			unpack(drawcall[2]))
	end
	if anyfire != fireplaying then
		fireplaying=anyfire
		call(anyfire and "music(32,500,3" or "music(-1,500")
	end
	
	for i,atk in inext,rangedatks do
	 atk[2][1]+=1 --counter
		if atk[1](unpack(atk[2])) then
		 del(rangedatks,atk)
		end
	end
	
	call"pal()palt(1)pal(15,129,1)pal(11,131,1)fillp("
	
	if modeis"play" or modeis"victory"then
		for i,ent in inext,ents do
			local _ENV=ent.textanim
			if _ENV and t<=0.5 then
				t+=speed
				pos.y-=0.5-t
				?text,mid(campos.x,4+pos.x-#text*2,campos.x+128-#text*4)-wavy*cos(t*2),pos.y+offset,t>0.433 and 5 or col
			else
				ent.textanim=nil
			end
		end
	elseif modeis"aim" then
		?"\f7\+fe⁙",aimscrposx,aimscrposy
	end
	camera()
 
	if modeis"play" or
	   modeis"ui" then
		barx=2
		drawbar("HP",
			player.hp,player.maxhp,2,8)
		for k,v in 
			pairs(player.statuses)
		do
			drawbar(unpack(v))	
		end
	elseif modeis"aim" then
		call"print(\f6⬅️\+fd⬆️\+8m⬇️\+fd➡️:aIM     ❎:fIRE,18,118"
	end
	if modeis"ui" then
		if (getbtn"16") popdiag()
		uitrans*=0.33
		for i,d in inext,diags do
		 focus,curindex=i==#diags,0
		 d()
	 end
	end
	call("textcrawl(\^x5\-dgAME oVER\^x4                                        \
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
"            \n\n\-a❎:tRY AGAIN,47,29,1.3,13,gameover,16)textcrawl(  \^x5◆ victory ◆\^x4                                                                                                                                                                                                \
\
\
\
yOU ESCAPED WITH THE\
\-owINGS OF yENDOR!                                        \
\
\-h\|isTEPS TAKEN:    "..stepstaken.."               \
\-hiTEMS FOUND:     "..itemsfound.."             \
\-hcREATURES SLAIN: "..creaturesslain.."                \
\
\
\
\
    ❎:cONTINUE,24,21,6,7,victory,8")
end

function popdiag()
	deli(diags)
	uitrans=1
	if #diags==0 then
		uimode=--nil
		setmode"play"
	end
end

function drawbar(label,val,maxval,col1,col2)
 call"clip(0,117,127,127"
 ?"\#0"..label,barx,117,col1
 
 local w=max(#label*4-1,20)
 local barw=ceil(val*w/maxval)-1
 rect(barx-1,122,barx+w,126,15)
 rect(barx,123,barx+barw,125,col2)
 if barw>0 then
	 rectfill(barx,124,barx+barw-1,
	 									125,col1)
	end
 barx+=w+4
end

function textcrawl(str,x,y,fadet,col,m,mus)
	if mode==m and statet>fadet then
		if not musicplayed then
			music(mus)
			musicplayed=true
			end
		?sub(str,0,statet*30+tonum(statet>7.25)*40),x,y,statet>fadet+0.1and col or 1	
		if btnp"5" then
			fadetoblack=true
			call"music(-1,300)setmode(reset"
		end
	end
end

function log(text)
 player.animtext(text..",col:7,speed:0.01666")
end

function frame(x,y,x2,y2,func)
 clip()
 func(x-1,y-1,x2+1,y2+1,0)
	rect(x,y,x2,y2,1)
	cursor(x-3,y+4)
	clip(0,0,x2-1,y2)
end

function listitem(str,sel,dis)
 if sel==nil then
  curindex+=1
  sel=curindex==menuindex
 end
 ?(sel and "\#0\|h❎ "or"\|h  ")..str, dis and 5 or sel and 7 or 13
	return sel and focus and 
	 getbtn"32" and not dis
end

function getindex(maxind,cur)
	return focus and
												(cur+tonum(getbtn"8")-
													tonum(getbtn"4")+
												maxind-1)%maxind+1
												or cur
end

function gettrans(str)
 local a,b=usplit(str)
	return lerp(b,a,focus and uitrans or 0.56*(1-uitrans))
end


function listitems(nop,eqpd)
	for j,item in inext,inventory do
		if item.equipped==eqpd then
			invi+=1
			if listitem(item.getname(),
							invi==invindex,
							uimode=="iDENTIFY"and
								item.isid() or
							uimode=="eMPOWER"and
								item.orb)
			then
				dialog(info)
				selitem=item
			end
		end
	end
end

function inv()
 frame(gettrans"126,40",6,126,111,rect)
	?uimode and"\fc  "..uimode.." AN iTEM\n\f1 ……………… EQUIPPED"or"\fd  iNVENTORY\n\f1 ……………… EQUIPPED"
	
 	invi,invindex=
	0,getindex(#inventory,invindex)
	
	call"listitems(t,t)print(\n\f1 ………………… STOWED)listitems("
end

function info()
 menuindex=getindex(uimode and 1 or 2,menuindex)

 local _ENV,x=selitem,gettrans"42,4"
 frame(x,6,gettrans"42,93.5",111,rectfill)

 spr(typ+profilepic,x+3,8)
 ?"\fd    "..getname()
 local statstr="\f1 ……………………………\fd\|j"
 if isid() then
 	for i,str in inext,split(
"\
  nAME: ,name|\
  wHEN DESCENDING\
  STAFFS CHARGE +,recharge|\
  cASTS LIGHT\
  tHROW TO START FIRE\
		\
  sTOWING DOUSES FLAME,lit|\
  ,desc1|\
  ,desc2|\
  ,desc3|\
  ,desc4|\
  ,desc5|\
		,desc6|\
  aTTACK SHAPE:   \|f\^:3e7f3e0000000000\-2\^:00003e7f3e000000\-k\^:00003e7f3e000000\+2h\^:000000081c3e0808\
,arc|\
  dARKSIGHT:  +,darksight|\
  hEALTH:    ,hp|/,maxhp|\
  fREEZE TURNS:,freezeturns|\
  kNOCKBACK:   1,knockback|\
  sTUN:        ,stun|\
  aCCURACY:   +,atk|\
  dAMAGE:      ,dmg|\
  rANGE:       ,range|\
  aRMOR:      +,armor|\
  tHROW RANGE: ,throw|\
  tHROW ACC:  +,throwatk|\
  tHROW DAMAGE:,throwdmg|\
\
  cHARGES: ,charges|/,maxcharges|\
  \
  \fecURSED: cANNOT BE\
  REMOVED; dESTROYED\
  BY EMPOWERMENT,cursed",
  "|")
  do
  	k,v=usplit(str)
	  local val,enchval=
	  selitem[v],
	  eMPOWER(v,true)
	  if val then
	   statstr..=k..val
	   if uimode=="eMPOWER" and
	    		enchval
	   then
	   	statstr..="\fc▶"..enchval.."\fd"
	   end
	  end
	 end
	else
		statstr..="\n  ????"
	end
 ?statstr
 
 --menu
 ?"\f1 ……………………………",x-3,86
                             
 for i,action in inext,
 uimode and{uimode}or
 {slot and
  (equipped and 
   (lit and"eXTINGUISH" or "sTOW") 
   or"eQUIP")or "uSE",
  "tHROW"}
 do
 	if listitem(action,nil,
				 	cursed and equipped and not _g.uimode or 
					 action=="uSE" and charges==0 or
					 action=="eQUIP" and player[slot] 
					  and player[slot].cursed)
  then
 	 call"popdiag()popdiag()sfx(25"
 	 player.skipturn=true
 		selitem[action]()
 	end
 end
end

function confirmjump()
	frame(32,gettrans"33,38.5",96,gettrans"33,82.5",rect)
	menuindex=getindex(2,menuindex)
	?"\fd\|i  tHE HOLE OPENS\n  UP BELOW YOU\-f.\-e.\-e.\n"
	
	if listitem" jUMP DOWN" then
	 popdiag()
	 player.move(playerdst)
	elseif listitem" dON'\-fT JUMP" then
	 popdiag()
	end
end

function dialog(func,nosnd)
	uitrans,menuindex=
	mode=="ui" and 0.33 or 1,1
	     
 setmode"ui"
 add(diags,func)
 return nosnd or sfx"39"
end

function setmode(m)
	assigntable("statet:0,btns:0,mode:"..m,_ENV)
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
7:manmade << no longer used
8:navflying
9:flammable
10:flammable2
11:wall
12:bridge
13:freezable
14:ywall
15:hole
]]

function tile(_typ,_pos)
	local _ENV=objtable"fow:1,fire:0,spores:0,newspores:0,hilight:0,hifade:0,light:-10,lflash:-10,lflashl:-10,death:41,adjtl:{}"
	typ,pos,tlscrpos=
	_typ,_pos,screenpos(_pos)
--tile member functions)
set=function(ntyp)
	typ,bg,genned=ntyp
end

draw=function(_typ,postl,scrpos,offset,size,flp,_bg,_hilight)
	dtyp=_typ or _bg and bg or typ
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
			local adjtile=postl.adjtl[i]
			if adjtile and adjtile.lightsrc then
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
	  call"pal(2,34,2"
	 	spr(hifade*16-8,scrpos.x,scrpos.y,2,1)
	 end
 	hilight=0
	end
end

drawents = function()

	checkeffects()
	for i,var in inext,tlentvars do
		if (_ENV[var]) _ENV[var].draw()
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
			elseif vistoplayer and
			   mode != "ui" and
			   (mode != "victory" or statet<6)then
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

checkeffects=function()

 function checkeffect(_typ,has)
 	if effect then
	 	local _ENV = effect
		 if	typ==_typ then
		  if alive and
		 	not has then
			 	setanim(deathanim)
			 	alive,light=nil
		 	end
		 elseif has then
		 	destroy(_ENV)
		 end
		end
		if not effect and has then
		 create(_typ,pos)
		end
	end
	
	local hasfire=fire>0 or
 						ent and 
 						ent.statuses.BURN

	_g.anyfire=_g.anyfire or hasfire and mode!="ui" and mode!="victory"

 checkeffect(138,hasfire)
 checkeffect(139,spores>0)
end


tileflag=function(i)
	return fget(typ+i\8,i%8)
end

navigable=function(flying)
	return tileflag(flying and 8 or 0)
end


flatten=function()
 if typ==tlonggrass then
 	typ=tflatgrass
 end
end

setfire=function()
 fire,spores,newspores,frozen=
 max(fire,1),0,0
 entfire()
end

sporeburst=function(val)
	spores+=val
	sfx"17"
end

entfire=function()
	if ent and 
		  not ent.nofire then
		 ent.burn()
	end
end

freeze=function(turns)
	frozen,fire=true,0
	flatten()
	local _ENV = ent
	if _ENV then
	 if hitfire then
	 	setanim"brazierdeath"
	 end
		statuses.BURN=--nil
		setstatus("FROZEN,"..turns..","..turns..",13,6")
		animtext"○"
		_g.aggro(tl)
	end
end

visitadjrnd=function(func)
	local neighbors={unpack(adjtl)}
	for i=1,6 do
		func(del(neighbors,rnd(neighbors)))
	end
end
--end tile member functions
	return _ENV
end

function setupdrawcalls()
	alltiles(
	
	function(_ENV)
		local palready=nil
		
		function tdraw(tltodraw,postl,i,_bg)
			if not palready then
				add(drawcalls,{initpal,{true}})
				palready=true
			end
			local _typ,flp=
			i and (bg and tltodraw.bg or
			              tltodraw.typ),
			flip
			if not i and tltodraw.tileflag"14" then
				_typ=tdunjfloor
			end

		 local baseoffset,offsets,sizes=unpack(specialtiles[i and _typ or "default"])
		 local offset,size=
		 offsets[i or 1],
		 sizes[i or 1]
		 --special tiles
			if i then
			 if _typ==tywall and
							not postl.altwall then
					baseoffset+=vec2s"-6,-2"
				elseif _typ==thole then
				 _typ+=192
					if i>3 then
					 _typ += 2--brick hole
					 flp=false
					 baseoffset+=vec2s"0,1"
					end
				end
				flp=flp and i%3==2
			end
			
			add(drawcalls,{draw,
							 {_typ,postl,
							 postl.tlscrpos+offset+baseoffset,
							  offset,size,
							 	flp and 
							 		tltodraw.tileflag"6", _bg, 
							 	not(i or _bg)}})
		end
		
		local infront,uprtl=fget(typ,3),adjtl[3]
		
		if bg then
			tdraw(_ENV,_ENV,nil,true)
		end
		
		if not infront and
					tileflag"5" or
					tileflag"14" and
					altwall then
			tdraw(_ENV,_ENV)
		end
		
		for k,i in inext,split"2,1,3,4,5,6" do
			
			if infront and i==4 then
				tdraw(_ENV,_ENV)		
			end
			
			local _adjtl=adjtl[i]
			if _adjtl then
				local adjtyp = _adjtl.typ
				
			 if typ!=tcavewall and
				 		typ!=tempty and
				 		adjtyp==tcavewall 
				then
					tdraw(_adjtl,_ENV,i)
				elseif i<=2 and
					      _adjtl.tileflag"11"
				then
				 walltl=adjtl[i]
					if adjtyp==tywall and
							 i==1 and
							 not walltl.altwall
					then
					 tdraw(_adjtl,walltl)
					end
					tdraw(_adjtl,walltl,i)
				end
				if (tileflag"15" or
				    bg==thole) and
				   i<=3 and
							adjtyp!=thole and
							_adjtl.bg!=thole
				then
				 tdraw(_ENV,_ENV,i+
				 	(_adjtl.manmade and 3 or 0),--brick hole
				 	bg==thole)--bridges
				end 
			end
		end
		if uprtl and 
					uprtl.tileflag"8" then
			add(drawcalls,{uprtl.drawents,{}})
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

function rndtl()
	return rnd(inboundtls)
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
		for k,_ENV in inext,tl.adjtl do
			if _ENV[var]<d then
				_ENV[var]=d
				if fget(typ,flag) then
					add(tovisit,_ENV) 
				end
			end
		end
	end
end

function calcdist(var,tl,mindist)
	tl=tl or player.tl
	alltiles(
	function(ntl)
		ntl[var]=mindist or-1000
	end)
	tl[var]=0
	dijkstra(var,{tl},0)
end

function viscone(pos,dir1,dir2,lim1,lim2,d)
	pos+=dir1
	local lastvis,notfirst=false
	for i=ceil(lim1),flr(lim2) do
	 local _ENV=gettile(pos+i*dir2)
	 if _ENV then
			local _vis,splitlim=
			tileflag"1"
			vis=tileflag"5" or
											tileflag"14" and
											 player.pos.x<
											 pos.x
			if _vis then 
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
			_vis,true
		end
	end
end

function calcvis()
	alltiles(
	function(_ENV)
		vis=pos==player.pos
	end)
	for i,offs in inext,adj do
		viscone(player.pos,offs,adj[(i+1)%6+1],usplit"0,1,1")
	end
end

function calclight(nop,checkburn,clearflash,despawn)
 local tovisit={}

 alltiles(
function(_ENV)
		light=lflash
		if clearflash then 
			lflash,lflashl=-10,-10
		else
			light=max(light,lflashl)
		end
		lcool=light>2
		for i,var in inext,tlentvars do
			local nent =_ENV[var]
			if nent then
				local tlight=nent.stat"light"
				if tlight and tlight>light then
					light,lcool=
					tlight,lcool or nent.lcool
				end
			end	
		end

		lightsrc=light>2
  if light>0 then
			add(tovisit,_ENV)
		end
	end)
	dijkstra("light",tovisit,1)
	
	alltiles(
	function(_ENV)
		local darks=player.stat"darksight"
		vistoplayer=vis and (light>-darks 
							or pdist>-2-darks)
		explored=explored or vistoplayer
	end)

	if checkburn then
		for _ENV in all(ents) do
			if hp and 
			   stat"burnlight" and 
			   tl.light>=2 and
			   not statuses.BURN
			then
				if despawn and nolightspawn then
					destroy(_ENV)
				else
					burn()
					trysetfire(tl,true)
					sfx"36"
				end
			end
		end
	end
end

function trysetfire(_ENV,always)
	frozen=nil
	if tileflag"10" or
    spores>0 or
    (rndp"0.5" or always) and
   	(tileflag"9" or
    	ent and
					ent.flammable)
	then
 	setfire()
 end
end

function updateenv()
	alltiles(
	function(_ENV)
		if spores>0 then
			spores=max(spores-rnd"0.25")
			if spores>1 then
				local adjtls={}
				visitadjrnd(
				function(_ENV)
					if tileflag"8" and
						fire==0
					then
							add(adjtls,_ENV)
					end
				end)
				local portion=spores/(#adjtls+1)
				newspores-=spores-portion
				for i,ntl in inext,adjtls do
					ntl.newspores+=portion
				end
			end
		end
		if fire>=2 then
			entfire()
			visitadjrnd(trysetfire)
			if tileflag"9" then
				if rndp"0.2" then
					fire,typ=0,34
				end
			else
				fire=0
				if tileflag"10" then
					typ=thole
					if ent then 
						ent.checkfall()
					end
					if item then
					 item.checkfall()
					end
				end
			end
		end
	end)
	alltiles(
	function(_ENV)
		spores+=newspores
		newspores=0
		if ent and
		 ent.statuses.BURN then
		 trysetfire(_ENV,true)
		end
		if fire>=1 then
			fire+=1
		 setfire()
		end
		checkeffects()
	end)
end

function findfree(tl,var,distlimit)
 calcdist("free",tl,distlimit)
 local bestd,bestpos=distlimit or-1000
 alltiles(
 function(_ENV)
  local d=free-rnd()
 	if navigable() and
 	   not _ENV[var] and
 	   d>bestd then
 		bestd,bestpos=
 		d,pos
 	end
 end)
 return bestpos
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

function hexline(p1,p2,range,linemode,cont)
	p2=hexnearest(p2),{}
	local ln,dist,tl={},hexdist(p1,p2)
	for i=1,min(cont and 20 or dist,range) do
	 local tl=gettile(hexnearest(
							lerp(p1,p2,i/dist)))
	 if not tl or
	    not tl.tileflag"8" or
	    tl.ent and linemode=="block" then
	  break
	 end
		add(ln,tl)
		if tl.ent and linemode!="pass" then
		 break
		end
	end
	return ln,#ln>=dist
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
	local dir=hexnearest(
	        lerp(p1,p2,1/hexdist(p1,p2)))-p1
	for i,d in inext,adj do
		if (d==dir) return dir,i
	end
end

function vec2s(str)
	return vec2(usplit(str))
end

function vec2list(str)
	local ret={}
	for i,vec in inext,split(str,"|") do
		add(ret,vec2s(vec))
	end
	return ret
end

function assigntable(str,table,delim1,delim2)
 table = table or {}
 for i,var in 
		inext,split(str,delim1)
	do
		local k,v=usplit(var,delim2 or ":")
		table[k]=v=="{}"and {} or v
	end
	return table
end

function objtable(str)
	return setmetatable(assigntable(str),{__index=_ENV})
end

function call(str)
	for i,s in inext,split(str,")")do
		local func,args=unpack(split(s,"(",false))
		_ENV[func](usplit(args))
	end
end

function rndint(maxval)
	return flr(rnd(maxval))
end

function rndp(p)
	return rnd()<tonum(p)
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
 __eq=function(_ENV,v2)
  return x==v2.x and y==v2.y
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
	local _ENV=	objtable"var:ent,xface:1,yface:-1,animframe:0,animt:1,animspeed:0.5,animheight:1,animflip:1,deathanim:death,atkanim:eatk,fallanim:fall,death:41,wpnfrms:0,throwflp:1,movratio:0.25,diri:2,pdist:0,lvl:0,scrxoffset:-2.5,width:1,pushanim:push,profilepic:0,idprefix:³g☉ ,yoffs:2,yfacespr:0,countid:generic,alive:true,statuses:{}"
	
	behav,typ,group=
	_behav,_typ,_group
	
	assigntable(entdata[_typ],_ENV)		
	counts[countid]+=1
	animoffset,name,maxhp=
	vec2(0,yoffs),
	ai and rnd(split"jEFFR,jENN,fLUFF,gLARB,gREEB,pLORT,rUST,mELL,gRIMB")..rnd(split"Y\n,O\n,US\n,OX\n,ERBEE\n,ELIA\n"),
	hp
	
--member functions
draw=function()
	if tl.vistoplayer or
		lasttl and lasttl.vistoplayer
	then
		tl.initpal()
		if isplayer then
			pal(8,stat"ccol")
			pal(9,stat"acol") 
		end
		if flash then
			flash=pal(split"7,7,7,7,7,7,7,7,7,7,7,7,7,7")
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
						+max(yface*yfacespr)
		spr(animtele and 153 or
		    typ+frame*16,
						scrpos.x,scrpos.y,
						width,animheight,
						flp)
		local held=aimitem or wpn
		if held and
			frame<=5 then
			local wpnpos=vec2list"3,-2|2,-1|1,-2|1,3|3,-3|1,0"[frame+1]
			if held.victory then
				wpnpos=vec2s"-1,1"
				call"palt(14,t"
			end
			call"pal(8,8)pal(9,9"
			
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
	split(entdata[name],""),1,false
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
	if canfall and
				tl.tileflag"15"
	then
		sfx"24"
		setanim(fallanim)
		if (isplayer) calclight()
	end
end

setbehav=function(name)
	if behav!=name then
		if behavis"sleep" then
			checkidle()
		end
		
		behav,canact=name
		if not statuses.FROZEN then
			if behavis"hunt" then
				animtext"!"
				sfx(alert)
			elseif behavis"search" then
				animtext"?"
			end
		end
	end
end

behavis=function(name)
	return behav==name
end

setpos=function(npos,setrender)
	if tl and tl[var]==_ENV then
	 tl[var],tl=nil
	end
	if npos then
		tl,pos=gettile(npos),npos
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
	for i,slot in inext,itemslots do
		if _ENV[slot] then
			local s = _ENV[slot][name]
			if s then
				val=type(s)=="number" and val+s or s
			end
		end
	end
	
	return val!=0 and val or _ENV[name]
end

setstatus=function(str)
	statuses[split(str)[1]]=split(str)
end

heal=function(val)
 	hp=min(hp+val, maxhp)
end

tickstatuses=function()
 if actor
    and tl.spores>0
 then
	heal(2)
 	if tl.vistoplayer and (not textanim or textanim.lowprio) then
 		animtext"+,lowprio:"
 	end
 	if isplayer then
 		call"sfx(17,-1,6"
 	end
 end
	for k,v in next,statuses do
		v[2]-=1
		if v[2]<=0 then
			statuses[k]=nil
			if k=="TORCH" then
				wpn.eXTINGUISH()
			elseif k=="LIGHT" then
				light,lcool=nil
			end
		end
		if k=="BURN" then
		 hurt(1,nil,true)
		end
	end
	if isflesh and rndp"0.25" then
		alive=--nil
		setanim"fleshdeath"
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
		if tl.vistoplayer then
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
		animt+=rnd(#anim-animloop)
	end,
	function()--[m] land
		if stat"fallheal" then
			heal(3)
			call"sfx(17,-1,6"
		end
		if stat"recharge" then
			for i,item in inext,inventory do
				if item.charges then
					item.charges=min(
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
		animflip,animtele=1
	end,
	function()--[o] destroy
		destroy(_ENV)
	end,
	function()--[p]ut on wings
		deli(inventory).eQUIP()
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
		animwait=true
	end,
	function()--[x]new level
		_g.depth+=1
		genmap(pos,tl.manmade)
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
	end
	
	if anim then
		tickanim()
	end
	if animwait then
		_g.waitforanim=true
	end
	if animclip then
		animheight=1-(animoffset.y-animclip)/8
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
	if ntl.ent then
		return
	 	atk and
	  special != "noatk" and not
	  (ai and ntl.ent.ai) and
	  (ntl.ent.armor or
	   behavis"hunt" or
	   isplayer)
	end

	return special != "atkonly" and ntl.navigable(flying)
end

seesplayer=function()
	return tl.vis and
	       (tl.pdist>=-1 or
				    player.tl.light>=2 or
				    nightvision)				 
end

findmove=function(var,goal,special)
	local bestscore,besttl=-2
	tl.visitadjrnd(
	function(ntl)
		if canmove(ntl.pos,special) and
		   ntl.fire==0
		then
		 local score=
		 							abs(tl[var]-goal)-
		 							abs(ntl[var]-goal)
		 if burnlight and 
		    tl.light>-1 and 
		    tl.pdist<-1 then
		 	score-=3*(ntl.light-tl.light)
		 end
			if score>bestscore then
				bestscore,besttl=score,ntl
			end
		end
	end)
	if besttl then
			if special=="aggro" and
			besttl.pdist==0
			then
				aggro(tl)
			else
				return move(besttl.pos)
		end
 	end
end

taketurn=function()
 function checkseesplayer()
		if seesplayer() then
			_g.pseen,_g.lastpseentl=true,player.tl
		end
	end
 if statuses.FROZEN or
    statuses.STUN or
	skipturn then
  skipturn,waited=--nil
  ai and checkseesplayer()
  return true
 end
	if isplayer then
		
		call"turn(1,4)turn(2,6)turn(8,8"
		
		function updst()
			_g.playerdst,aimitem=
			pos+adj[player.diri]
			dsttile=gettile(playerdst)
		end
		updst()
		lookat(playerdst)
		waited,dsttile.hilight=
		getbtn"16",2
		
		if getbtn"32" then
			dialog(inv)
			return
		end
		
		if waited then
			sfx"40"
			return true --wait 1 turn
		end
		
		if getbtn"4" then
			dsttile.hilight=0
			if canmove(playerdst) then
				if move(playerdst,true) then
					pickup(dsttile.item)
				updst()
				if stat"lunge" and
					dsttile.vistoplayer and
					dsttile.ent
				then
					interact(dsttile.ent)
				end
			end
					
			return true
			elseif dsttile.tileflag"15" then
				dialog(confirmjump)
			end
		end
	elseif ai and canact and alive then
		if behavis"hunt" then
			checkseesplayer()
			if not (ratks and rndp(rangep) and dorangedatk(usplit(rnd(split(ratks,"|")),";"))) then
				findmove("pdist",rndp"0.5" and altpdist or pdist,movandatk and "noatk")
			end
				checkseesplayer()
			if movandatk then
				findmove("pdist",0,"atkonly")
			end
		else
			--notice player
			function checkaggro(p)
				if seesplayer()
				and rndp(p)
				then
				aggro(tl)
				return true
				end
			end
			if behavis"search" then
				checkaggro"1.0"
				local goal=pdist
				findmove("search",goal,"aggro")
				if not checkaggro"1.0" and
					tl.search == goal
				then
					setbehav"wander"
				end
			else
				checkaggro"0.29"
				if behavis"wander" then
					if not wanderdsts[group]
					or pos==wanderdsts[group]
					or rndp"0.025"
					then
						repeat
							wandertl =rndtl()
							wanderdsts[group]=wandertl
						until wandertl.navigable() and
												wandertl.pdist>-1000
						calcdist(group,wandertl)
					end
					findmove(group,0,"aggro")
					checkaggro"0.29"
				end
			end
		end
	end
end


dorangedatk=function(atktype,lineparams,ptarg,etarg,btarg,fx,summon)
	local bestscore,bestln,besttl=0
	if (atktype=="ice" and noice) return
	function checktl(ntl)
		local ln,hit=hexline(pos,ntl.pos,usplit(lineparams,"_"))
		if hit then
			local _ENV,score = ntl.ent,
			summon and not summoned and 100+ntl.pdist or ptarg
			if _ENV and ai and hp<maxhp and ntl.spores==0 then
				score+=etarg
			end
			if score>bestscore then
				bestscore,bestln,besttl=score,ln,ntl
			end
		end
	end
	checktl(player.tl)
	ptarg=btarg --hacky but saves tokens
	tl.visitadjrnd(checktl)
	if bestln then
		sfx(fx)
		setanim"ratk"
		lookat(besttl.pos)
		if summon then
			summoned=create(75,besttl.pos)
			summoned.setanim"bladesummon"
		elseif healer then
			besttl.sporeburst(0.9)
		end
		return add(rangedatks,{rangedatk,{0,bestln,atktype}})
	end
end

hurt=function(dmg,atkdir,nosplit,_push)
	hp-=dmg
	flash,shake=true,1
	if hp<=0 then
		if ai and alive then
			_g.creaturesslain+=1
		end
	 sfx(death)
		alive=--nil
		setbehav"dead"
		setanim(deathanim)
		if isplayer then
			call"setmode(gameover)print(\^!5f40\31)calclight("
		elseif sporedeath then
			tl.sporeburst(sporedeath)
		elseif summoned and summoned.alive then
			summoned.hurt(10)
		end
	else 
		sfx"34"
		if hurtsplit and 
		not (statuses.FROZEN or nosplit) 
		then
			local splitpos=findfree(tl,"ent",-2)
			if splitpos then
				hp/=2
				local newent=create(typ,splitpos,behav,group)
				if statuses.BURN then
					newent.burn()
				end
				newent.renderpos,newent.hp=
				renderpos,hp
				newent.setanim"esplit"
			end
		end
	end
	if statuses.FROZEN then
	 sfx"27"
	 statuses.FROZEN[2]-=dmg
	elseif hurtfx then
		sfx(hurtfx)	
	end
	aggro(tl)
	if _push or hitpush and atkdir then
		push(atkdir)
	elseif hitfire then
		sfx"36"
		tl.setfire()
	end
end

push=function(dir)
	if (nopush) return
	local pushpos=pos+dir
	pushdir,pushtl,lasttl=dir,gettile(pushpos),tl
	if hitfire then
		sfx"36"
		light=--nil
		(pushtl.navigable() and pushtl or tl).setfire()
	end
	if (pushtl.navigable(flying) or pushtl.tileflag"15") and not pushtl.ent then
		setpos(pushpos)
		if isplayer then
			call"calcdist(pdist)calcvis()calclight("
		end
	else 
		setanim(pushanim)
		animoffset=0.66*screenpos(dir)
	end
end

burn=function()
	statuses.FROZEN=--nil
	setstatus"BURN,6,6,8,9"
end

doatk=function(ntl,pat)
 local b=ntl.ent
 
	if atk and b then
 	local hitp=1
	if b.armor then
		local diff=(throwatk or stat"atk")-b.stat"armor"
		hitp=(max(diff)+1)/
			(abs(diff)+2)
	end
	local atkdir,atkdiri=hexdir(pos,ntl.pos)
	if rndp(hitp) then
		local dmgv=min(stat"dmg",b.hp)
		b.hurt(throwdmg or dmgv,atkdir,nil,armor and stat"knockback")
		if b.armor then
			if stat"dmgheal" then
				heal(dmgv)
				animtext"+,col:8"
			end
			if stat "dmghurt" then
				hurt(dmgv)
			end
			if stat"stun" and armor and b.hp>0 then
				b.setstatus(ai and "STUN,2,2,11,3" or "STUN,3")
				b.animtext"○,wavy:1"
			end
		end
		if b.hitfire and stat"torch" then
			--relight torch
			assigntable("thrwln:0,typ:130,lit:,light:4",wpn)
			setstatus"TORCH,160,160,2,9"
		end
		
		if makeflesh then
			ntl.visitadjrnd(
				function(_ENV)
					if navigable() and not ent then
						create(89,pos)
					end
				end
			)
		end
	else
		aggro(ntl)
	end
	
 for p in all(split(pat,"|")) do
 	doatk(ntl.adjtl[(atkdiri+p)%6+1])
 end
 end

 skipturn=stat"slow"
end

interact=function (b)
 setanim(atkanim)
	sfx"33"
 atktl=b.tl 
end

move=function(dst,playsfx)
	local dsttile,lasttl=
	gettile(dst),tl
	lookat(dst)
	if dsttile.ent and not 
	(makeflesh and 
		dsttile.ent.isflesh)
	then
		interact(dsttile.ent)
	else
		if moveanim then
			setanim(moveanim)
		end
		
		if playsfx then
			_g.stepstaken+=1
		 if dsttile.frozen then
	  	call"sfx(28,-1,12,3"
	  else
		  sfx(entdata[dsttile.typ])
		  if dsttile.typ==40 then
					--bonez
					aggro(dsttile)	
			 end
			end
		end
	 
	 setpos(dst)
		if makeflesh then
			create(89,lasttl.pos)
		end
		if player.waited and player.stat"guard" and dst==playerdst then
			player.interact(_ENV)
		end
	 return true
	end
end

lookat=function(dst)
	deltax,dir,diri=
	dst.x-pos.x,
	hexdir(pos,dst)
 if deltax!=0 then 
		xface=sgn(deltax)
 end
	yface=dir.y==0and xface or dir.y
end

tele=function(dst)
	if not	dst then
		repeat 
		 dst=rndtl()
		until dst.navigable() and
		      not dst.ent
	end
	setanim"tele"
	if (dst.ent) return --fixes 2 mirrorshards blinking to same space
	setpos(dst.pos,true)
	if isplayer then
		pickup(	dst.item)
		call"calcdist(pdist)calcvis()calclight("
	end
end

eQUIP=function()
	if player[slot] then
		player[slot].sTOW()
	end
	player[slot],equipped=_ENV,"t"
	id()
	if cursed then
		sfx"44"
	end
end

sTOW=function(staylit)
	if equipped then
		equipped,player[slot]=nil
		if lit then
		 eXTINGUISH(staylit)
		end
	end
end

tHROW=function()
 aim{_ENV,{throw},"throw"}
end

function orbis(str)
	return orb==str
end

uSE=function()
	if orb then
		orbeffect(player.tl,true)
		
		destroy(_ENV)
	else
		--staffs
		aim{_ENV,{range,linemode,true},rangetyp}
	end
end

orbeffect=function(tl,used)
	local entoritem=tl.ent or tl.item
 if used then
	 if orbis"light" then
			player.setstatus"LIGHT,160,160,2,13"
			assigntable("light:4,lcool:",player)
			calclight()
		elseif orbis"slofall" then
			player.setstatus"SLOFALL,160,160,2,3"
		elseif orbis"eMPOWER" or orbis"iDENTIFY"then
			_g.uimode=orb
			dialog(inv,true)
		elseif orbis"life" then
		 player.maxhp+=3
		 player.hp=player.maxhp
 		log"+MAX HP"
		end
	else
		sfx"27"
		if orbis"light" then
			tl.lflash=8
		elseif (orbis"eMPOWER" or 
		       orbis"iDENTIFY") and 
		       entoritem then
			entoritem[orb]()
		elseif orbis"life" then
			tl.sporeburst(12)
		end
	end
	
	for i=6,0,-1 do
		local ntl=tl.adjtl[i]
		if orbis"slofall" and 
		   ntl.ent and not used
		then
		   ntl.ent.push(i>0 and adj[i] or player.dir)
		elseif ntl.tileflag"8" and
		  ntl.typ!=thole
		then
		 if orbis"fire" then
				ntl.setfire()
			elseif orbis"ice" then
			 ntl.freeze(freezeturns)
		 end
		end
	end
	
 sfx(orbfx)
	id()
	
	if orbis"tele" and entoritem then
		entoritem.tele()
	end
end

eXTINGUISH=function(statusonly)
	if not statusonly then
		throwln,typ,lit,light=0.125,131
	end
	player.statuses.TORCH=nil
end

eMPOWER=function(test,nosnd)
	for i,estat in inext,enchstats do
		if _ENV[estat] then
		 local val=(estat=="charges"and
		           maxcharges or
		           _ENV[estat])+1
			if test then
			 if test==estat then
			 	return val
			 end
			else
				_ENV[estat]=val
			end
		end
	end
	if not nosnd then
		call"sfx(55,-1,0,16"
		if (tl and not cursed) animtext"+LVL,speed:0.01666"
	end
	if cursed and not test then
		sTOW()
		destroy(_ENV)
		ided[typ]=true
		call"log(ᶜe³mCURSED ITEM DESTROYED)sfx(44"
	end
end

iDENTIFY=function()
	id()
	call"sfx(55,-1,16,16"
	dialog(info)
	_g.selitem,_g.uimode=
	_ENV,"dISMISS"
end

dISMISS=popdiag

getname=function()
 return isid() and 
  (nid or n)..
  (lvl>0 and "+"..lvl or "")or n
end

id=function()
	if not isid() then
		ided[typ]=true
		log(idprefix..getname())
	end
end

isid=function()
 return ided[typ]
end

rangedatk=function(i,ln,atktype)
	function atkis(str)
	 return atktype==str
	end
	
	local spd,lngth=atkis"throw" and throw/12 or 0.999,#ln
 
	local tl = ln[min(flr(i*spd)+1,lngth)]

 if atkis"lightning" then
	drawln=function(_pos)
		line(_pos.x+rnd(6)-3,
				_pos.y-2.5-rnd(3))
	end	
	fillp()
	line(i%2*5+7)
	drawln(0.5*(screenpos(pos)+ln[1].tlscrpos))
	for i=1,min(i,lngth) do
		drawln(ln[i].tlscrpos)
		ln[i].lflashl=6
	end
end

	function drawburst()
		spr(153,tl.tlscrpos.x-2.5,tl.tlscrpos.y-4.5)
	end
 
	tl.initpal()
 if i*spd>=lngth then
  if atkis"throw" then
			doatk(tl)
		 if tl.tileflag"15" then
		 	setpos(tl.pos,true)
		 elseif lit then
		 	tl.setfire()
		 	sfx"36"
		 elseif orb then
		  orbeffect(tl)
				id()
		  drawburst()
		 elseif throw and not ai then
			 	setpos(findfree(tl,"item"),true)
		 end
			aggro(tl)
		end
		return true
	end

	if atkis"blink" then
	 (ai and _ENV or player).tele(ln[lngth])
		return true
	end
	tl.flatten()
	if atkis"throw" then
		function getpos(i,offs)
			local t,airtime=
			spd*i/lngth, lngth/spd
			local arcy,_pos=
			(t*t-t)*airtime*airtime/4,
			lerp(pos,ln[lngth].pos,t)
			local scrpos=screenpos(_pos)+offs
			return scrpos.x,scrpos.y+arcy,1,1,xface<0
		end
		
		if throwln then
			local x1,y1=getpos(i-1,vec2s"0,-2")
		 local x2,y2=getpos(i,vec2s"0,-2")
		 tline(x2,y2,x1,y1,18,throwln)
		else
		 xface*=throwflp		 
			spr(typ,getpos(i,vec2s"-3,-6"))
		end
	elseif atkis"ice" then
		tl.freeze(freezeturns)
		drawburst()
 	else
		if i==1 then
			gettile(pos).lflash=2
		end
		if atkis"fire" then
			trysetfire(tl,true)
			if tl.fire==0 then
				create(138,tl.pos)
			end
			tl.entfire()
		end
		if dmg then --lightning/fire
			if tl.ent then
				tl.ent.hurt(dmg)
			else
				aggro(tl)
			end
			call"calclight(,t"
		end
	end
end

animtext=function(str)
 textanim=objtable("t:0,speed:0.03333,col:7,offset:-6,wavy:0,text:"..str)
 textanim.pos=entscreenpos()
end

entscreenpos=function()
	return screenpos(pos)+
	        vec2(scrxoffset,-6.5)
end
--end member functions

	setpos(_pos,true)
	
	while rndlvl and rndp"0.33"do
		eMPOWER(nil,true)
	end
	
	add(ents,_ENV)
	if flippable
	   and rndp"0.5" then
		xface*=-1
	end
	yface=rnd{-1,1}
	checkidle()
	if behavis"sleep" then
		setanim"sleep"
	end

	return _ENV
end

function pickup(_ENV)
	if _ENV then
		if not beenfound then
			beenfound=true
			_g.itemsfound+=1
		end
		if #inventory<10 or victory then
			sfx"25"
			add(inventory,_ENV)
			if victory then
				player.aimitem=--nil (fix for blinking onto wings)
				player.setanim"victory"
				player.yface,player.statuses,tl.fire,light=
				-1,{},0
				call"setmode(victory)calcvis()calclight("
			end
			setpos()
			log("+"..getname())
		else
			log"INVENTORY FULL"
		end
	end
end

function turn(btnid,i)
	if getbtn(btnid) then
		player.diri=(player.diri+i)%6+1
		player.setanim"turn"
	end
end

-->8
--entity management
function updateplayer()
	if player.taketurn() then
		player.tickstatuses()
		call"calcdist(pdist)calcvis("
		updateturn=function()
			calclight()
			for i,_ENV in inext,ents do
				if ai then
					taketurn()
				end
				if not isplayer then
					tickstatuses()
				end
			end
			updateturn=function()
				for i,_ENV in inext,ents do
					if ai and behavis"hunt" and
						not _g.pseen and not alwayshunt
					then
						setbehav"search"
						setsearchtl(lastpseentl)
					end
					if summoned and not summoned.alive then
						summoned=nil
					end
					canact,noice=true,player.statuses.FROZEN
				end
				updateturn=function()
					updateenv()
					updateturn=function()
						call"calclight(,t,t"
						updateturn,pseen=updateplayer
					end
				end
			end
		end
	end
end

function setsearchtl(tl)
	if searchtl!=tl then
		lastpseentl,searchtl=tl,tl
		calcdist("search",tl)
	end
end

function aggro(_tl)
	setsearchtl(player.tl)
	calcdist("aggro",_tl,-4)
	for i,_ENV in inext,ents do
		if ai and
		   alive and
					tl.aggro>=-3
		then
			if seesplayer() then
				setbehav"hunt"
				_g.pseen=true
			elseif behav!="hunt"
			then
				setbehav"search"
			end
		end
	end
end

function destroy(_ENV)
 if _ENV then
		del(ents,_ENV)
		del(inventory,_ENV)
		setpos()
	end
end
-->8
--level generation

function genmap(startpos,manmade)
	alltiles(function(_ENV)
	 --required for now or we run
	 --out of memory
		adjtl=nil
	end)

	genpos,cave,ents,pseen=
	startpos,not manmade,{unpack(inventory)}
	
	assigntable("world:{},validtiles:{},inboundtls:{},tileinbounds:{},drawcalls:{}",_ENV)
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
				add(inboundtls,tl)
				tileinbounds[y][x]=tl
			end
	 end
	end

	alltiles(
	function(_ENV)
		for i,offs in inext,adj do
			adjtl[i]=gettile(pos+offs)
		end
		adjtl[0]=_ENV
	end)
	
	entropy,gentl=1.5,gettile(genpos)
	if manmade then
		genroom(gentl)
	else
		gencave(gentl)
	end
	call"postproc()setupdrawcalls("
end

function genroom(tl)
	local roomextrasize,pos=
		rndint"8",tl.pos
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
		local offset,openplan,crumble=
		minpos-pos,rndp"0.5",rndp"0.25"
		for y=0,h do
		 local alt=(pos.y+offset.y+genpos.y+y)%2
			offset.x-=alt
			local xwall=y==0 or y==h
			for x=0,w do
				local ywall,npos=
				x==0 or x==w,pos+offset+vec2(x,y)
				local tl=inbounds(npos)
				if test then
				 if not tl or
				   cave and npos==genpos
				 then
				 	return true
				 end
				elseif tl then
					local _ENV=tl
					altwall=alt!=0
					destroy(ent)
					manmade=true
					
					if (xwall or ywall) and
							 not (typ==tdunjfloor 
							 					and openplan) 
					then
					 if rndp(crumble) and
					    not altwall and not
					    (xwall and ywall) then				   
							gentile(txwall,tl)
							if not ent then
								genned=false
								--still want eg. grass
								--to spread here
							end
						else
							set(
								xwall and txwall or tywall)
						end
					else
						set(tdunjfloor)
					end
				end
			end
	 end
	end
	
	if entropy<1.5 and doroom(true) then
		return genroom(rndtl())
	end
		
	entropy-=0.15+rnd"0.1"
	if entropy>=0 then
		doroom()
		if rndp(0.4-depth*0.025) then
			gencave(rndtl())				 
		end
		genroom(rndtl())	
	end
end

function gencave(tl)
	if(tl.typ==tempty)tl.typ=tcavefloor
	
	entropy -= 0.013
	if tl then
		tl.visitadjrnd(
		function(ntl)
			if not ntl.tileflag"4" then
				if inbounds(ntl.pos) and 
							rndp(entropy) then
					gentile(tl.typ,ntl)
					if ntl.tileflag"4" then
						if rndp(0.005+depth*0.001) then
							genroom(rndtl())
						end
					 gencave(ntl)
					end
				end
			end
		end)
	end
end

function gentile(typ,_ENV)
	local y =	ceil(rnd"15")
	if (manmade) y+=16
	set(mget(typ,y))
	if depth==16 and tileflag"15" then
		return gentile(typ,_ENV)
	end
	local typ2=mget(typ+1,y)
	flip,genned=
	rndp"0.5",true
 if typ2!=0 then
  if typ2<64 then
 		bg=typ2
	 else
 		create(typ2,pos)
 	end
 end									
end

function postgen(tl,prevtl)
	tl.postgenned=true
	tl.visitadjrnd(
	function(_ENV)
		if tileflag"4" and not
					postgenned then
			if not genned then
				gentile(tl.typ,_ENV)
			end
			postgen(_ENV,tl.tileflag"4" and tl or prevtl)
		end
	end)
end

function checkspawn(_ENV,_typ,mindist,allowent)
	if navigable() and
		pdist < mindist and
		pdist > -1000 and
		not item and
		(allowent or not ent)
	then	
		return not _typ or create(_typ,pos)
	end
end

function postproc()
	function connectareas(permissive)
		for i=1,20 do
			--what a mess
		 calcdist("pdist",gentl)
		 
			local unreach,numtls,bestdist={},0,100
			alltiles(
			function(_ENV)
				if navigable() and
							pdist==-1000 and
							(permissive or
							 not altwall)
				then
					add(unreach,pos)
				end
			end)
			
			if (#unreach==0) return
			
			for j=1,200 do
				if #unreach==0 then
					return
				end
				local p1=rnd(unreach)
				local tl1=gettile(p1)
				local diri=
		   rnd(split(tl1.manmade and
		   not permissive and "1,2,4,5" or"1,2,3,4,5,6"))
				local dir=adj[diri]
				local p2=p1+rndint"18"*dir
				local tl2=gettile(p2)
				if tl2 then
					if tl2.navigable() and
								tl2.tileflag"4" and
								tl2.pdist>-1000 then
						d=hexdist(p1,p2)
						if d<bestdist then
							bestdist,besttl1,bestdiri=
							d,tl1,diri
						end
					end
				end
			end
			
			if bestdist<100 then
				repeat
					besttl1=besttl1.adjtl[bestdiri]
					local _ENV=besttl1
					local nav=navigable()
					if not nav then
					 if tileflag"15" then
					 	if bestdiri%3==2 then
					 		typ=tybridge
					 	else
					 		typ=txbridge
					 		flip=bestdiri%3==1
					 	end
					 	bg=thole
					 elseif manmade then
					 	typ=tdunjfloor
					 else
					 	typ=tcavefloor
						end
					end
				until nav and pdist>-1000
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
	postgen(gentl,gentl)
	
	connectareas()
	
	--replace single cavewalls
	alltiles(
	function(_ENV)
		if typ==tempty and 
					inbounds(pos) then
			if adjtl[2].tileflag"4" and
				  adjtl[5].tileflag"4" then
				gentile(tcavewall,_ENV)
			end
		end
	end)
	
	connectareas(true)
	local numholes,furthestd=0,0
	
	alltiles(
	function(_ENV)
		if typ==tempty then
			--add cavewalls
			for k,ntl in next,adjtl do
				if ntl and 
							ntl.tileflag"5" then--drawnormal
					 typ=tcavewall
				end
			end
		elseif tileflag"14" and
		  adjtl[4].typ==txwall
		then
			typ=txwall
		elseif pdist>-1000 and
		 tileflag"15"
		then
			numholes+=1
		end
		if checkspawn(_ENV,nil,0,true) then
			furthestd=min(furthestd,pdist)
		end
	end)
	
	--create exit holes if needed
	if depth==16 then
		repeat until 
			checkspawn(rndtl(),201,furthestd*0.66)
	elseif numholes<3 then
		alltiles(
		function (_ENV)
			if checkspawn(_ENV,nil,furthestd+2.5+rnd(),true)
			then
			 set(thole)
				destroy(ent)
			end
		end)
	end
	
	if not player then
		player=create(64,genpos)
	else
  		add(ents,player)
	end
	
	do
		local _ENV=player
		setpos(genpos)
		call"calcdist(pdist)calclight("
		tl.checkeffects()
		
		animoffset.y,animheight,animclip=
		-21,1
		setanim(statuses.SLOFALL and alive and "slofall" or "fallin")
	end
	--spawn entities										
	wanderdsts,fadetoblack={}
	for n=1,6 do
		for i=depth,20 do
			spawn=rnd(spawns[i])
			if (rndp"0.55") break
		end
		local spawntl,behav,spawnedany
		=rndtl(),rnd{"sleep","wander"}
		for i,typ in inext,spawn do
			local found=false
			spawntl.visitadjrnd(
			function(_ENV)
				if not found and
			 	checkspawn(_ENV,nil,-4)
			 then
			  create(typ,pos,behav,n)
					found,spawntl=
					true,_ENV
				end
			end)
		end
	end
	
	--spawn items
	for n=1,7-depth\5.99 do
		checkspawn(rndtl(),mget(64+rndint"56",24),-3)
	end
	--rubberbanding items
	function rband(countid,options,targetcount)
		for i=counts[countid],targetcount or depth/2.001 do
			local spwnid=rnd(split(options,"|"))
			--printh(countid)
			checkspawn(rndtl(),mapping[spwnid] or spwnid,-3)
		end
	end

	--printh"\n\n====rubberbanding====\n"
	call"rband(life,300)rband(slofall,301)rband(empower,302)rband(identify,303)rband(light,304)rband(wpn,132|133|134|135|316|317|318|319,0)rband(wearable,308|309|310|312|313|314,0)calcvis()calclight(,t,t,t"
end

-->8
--aiming

function aim(params)
	aimparams,aimpos=params,playerdst
	setmode"aim"
end

function updateaim(_ENV,lineparams,atktype)
 player.aimitem,aimscrpos,_g.aimscrposy=_ENV,
  screenpos(aimpos)+1.5*
  vec2(1.5*(tonum(btn"1")
           -tonum(btn"0")),
       tonum(btn"3")
      -tonum(btn"2"))
	
 _g.aimscrposx,_g.aimscrposy=
 mid(campos.x,aimscrpos.x,campos.x+127),
 mid(campos.y,aimscrpos.y,campos.y+127)
	_g.aimpos=vec2(aimscrposx/12,
	            aimscrposy/8-aimscrposx/24)
 
 local aimline=hexline(player.pos,aimpos,unpack(lineparams))
	for i,tl in inext,aimline do
	 if (tl==player.tl) return
	 tl.hilight=2
	end
	player.lookat(aimpos)
	xface=player.xface
	if getbtn"32" and #aimline>0 and
	   statet>0.2 then
		setmode"play"
		pos=player.pos
		if atktype=="throw" then
			sfx"12"
			player.aimitem=--nil
			sTOW(true)
			del(inventory,_ENV)
		else
			id()
			charges-=1
			sfx(usefx)
		end
		player.setanim"throw"
		add(rangedatks,{rangedatk,{0,aimline,atktype}})
	elseif getbtn"16" then
	 player.skipturn=false
	 setmode"play"
	end
end

-->8
--game data / init


_g=assigntable(
[[mode:play,statet:0,depth:1,btnheld:0,shake:0,invindex:1,btns:0,shakedamp:0.66
,tempty:0,tcavefloor:50,tcavefloorvar:52
,tcavewall:16,tdunjfloor:48,tywall:18,txwall:20
,tshortgrass1:54,tflatgrass:38,tlonggrass:58
,thole:32,txbridge:60,tybridge:44
,minroomw:3,minroomh:2
,stepstaken:0,itemsfound:0,creaturesslain:0
,specialtiles:{},spawns:{},diags:{},inventory:{},rangedatks:{},mapping:{}]],
_ENV)
entdata=assigntable(
	chr(peek(0x8002,%0x8000)),
	nil,"\n","=")

adj,fowpals,frozepal,ided,enchstats,tlentvars,itemslots,updateturn,counts=
vec2list"-1,0|0,-1|1,-1|1,0|0,1|-1,1",--adj
{split"0,0,0,0,0,0,0,0,0,0,0,0,0,0",
split"15,255,255,255,255,255,255,255,255,255,255,255,255,255",
split"241,18,179,36,21,214,103,72,73,154,27,220,93,46"
},
split"1,13,6,6,13,7,7,6,6,7,13,7,6,7",--frozepal
assigntable"130:,131:,132:,133:,134:,135:,201:",--ided
split"lvl,hp,maxhp,atk,throwatk,dmg,throwdmg,armor,darksight,recharge,range,charges,maxcharges,freezeturns",--enchstats
split"item,ent,effect",--tlentvars
split"wpn,cloak,amulet",--itemslots
updateplayer,--updateturn
assigntable"generic:0,wpn:0,wearable:0,life:-1,slofall:-1,empower:0,identify:0,light:0"--counts

for i,s in inext,
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
15,8]],"◆") do
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

--shuffle item colors
for j,str in inext,split([[
172,173,174,175,188,189,190,191|300,301,302,303,304,305,306,307
140,141,142,143|308,309,310,311
156,157,158,159|312,313,314,315
129,145,161,177|316,317,318,319]]
,"\n") do
 local itemstr,mapstr=usplit(str,"|")
	local items=split(itemstr)
	for k,s in inext,split(mapstr) do
		local i=del(items,rnd(items))
		entdata[i]..=entdata[s]
		mapping[s]=i
	end
end
genmap(vec2s"10,12")

add(inventory,create(130)).eQUIP(true)
player.setstatus"TORCH,160,160,2,9"
--add(inventory,create(mapping[319]))
call"calclight()print(\^!5f5c\9\6"--key repeat poke

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
f011110110001110f011100111111110f011111111111110fffff3fffffbfffff5011d0111111d05ffff3ff3f3ffbffff505202202205504fff15500d00555ff
000000111101000001111111111111110101111111111111fffff3ff3ffffffffd1110111111d01dfffff3f3fbffbfff022022022055044fff00555dd00500f1
f011000010111100f011111110011110f011111111100110fffffbf3fffffffff0d11111111101d0fffffbf3fbff00fff02202505404fffff051005d10d11100
ff0011110001100fff0111111111110fff0111111111100ffffffffbffffffffff0d111111d11d0fffff0b0bffffffffff055044ffffffffff001111055d100f
fff00110111000fffff01111111110fffff01111111110fffffffffffffffffffff0ddddd6ddd0fffffffffbfffffffffff44ffffffffffffff00510111000ff
fff67fffffffffffffffffffffffffffff11ffffff999fffffffffffffffffffff11f1ffffffffffff8888fffffffffffff7fffffffcfcffffffffffffffffff
fff62ffffffffffffff22ffffffffffff1001fff333333fffffffffffffffffff100101ffffffffff828228ffffcffffffc77fffffffcfcfffffff2989ffffff
ff888ffffff3f3fffff223fffff3f3fff1003fffb3333344ffffffffffff4f4f10000001ffffffff2f88fff2ffc7cffffcc777ffffffcdcffffff2982828afff
ff88dfffffbbb3f6ff22234fff44439f100038ffb3333b42ffffffffffff444f05000550fffeeefff8288228ffc7cfffffdccfffffffdddffffff9822282e8ff
ff88d6ffffbbbf6fff222f4fff4445f9100014ff4bbbb92ffff4f4ffff44422f11101111ffe227eff8f28288fccdccffffdccfffcffccdfff89ff9822282ffff
ff882fffffbbb3ffff22234fff222366100034fffbbbb4ffffff55fff44422fffff1ffffffe222eff2f28f2ffffcfffffffcfffffccdddffff89982225282fff
ff2f2fffff444fffff222f4fffddd99f10001ffff2222fffff5555ff442402ffffffffffffe20eef2228822ffffffffffffdfffff22d02fffff8822200528fff
ffd0dfffff202fffff222fffffd0dfff10001ffff2002ffffe544ffff202fffffffffffffe2222eff282882ffffffffffffffffff202ffffffff25025fffffff
fff67fffffffffffffffffffffffffffff11ffffff997fffffffffffffffffffff11f1ffffffffffff88d8fffffffffffff7fffffffcfcffffffffffffffffff
fff22ffffffffffffff22ffffffffffff1001fff333993fffffffffffffffffff100101ffffffffff822828ffffcffffffc77fffffffcfcffffffffe99ffffff
ff882ffffff3f3fffff323fffff3f3fff13031ff99333bffffffffffffffffff10500001ffffffff2f88fffeffc7cffffcc777ffffffcfcfffffff988898ffff
ff8d9fffffb333ffff2333ffff4333ff103331ff99b33b44ffffffff4fffffff05580850fffffffff8288228ffc7cfffffdccfffcfff6c6ffffff9828289a8ff
ff86dfffffbbbff6ff222f4fff44299f1000181f499bbf42ffffffff24424f4f11101111fff88ffffef28282fccdccffffdccffffccfdcfff89ff9822828e88f
ff826fffffbbbf6fff222f4fff2445f91000141ff449942ffef4f4fff422444ffff1ffffff28e8fff2f28f2ffffcfffffffcfffffddcddffff2998222822ffff
ff2f2fffff44b3ffff22234fffdd43661000341ff2244fffff5555fff204240ffffffffff2d888fff288822ffffffffffffdfffff20d22fffff2222252802fff
ffd0dfffff202fffff222f4fffd0d99f100011fff2002fffff0555fffff202ffffffffff2822dd2f2882802ffffffffffffffffffff202ffffff2250052802ff
ffffffffffffffffffffc4cffffffffff11fffffffffff6fffffffffff6fff6f11ffff11ffffffffffffffffffcccffffff7ffffffffffffffff8fff9a8fffff
fff67fffffffffffff2ec4cfffffffff1041fffffffffff6fffffffffff64f460011f100fffffffff828ff28ffffccffffc77efffffffffffff888f98e0fffff
fff88fffff7666ffff223c4cfff3f3ff100a1f8fffff9996f6ff6ffffff6444650001005ffffffffff8f8888fffffccfecc777eeff2c7c7fff855889822f88ff
ff8886fff763f36fff22223cff4443ff10001878ff333336ff4f46fff4f4442615000051ffffffffff828288fffcfccfffdccffffff2c7c7fffff5898888858f
ff88dffff3bbb3f6ff222ec4f4444f9f1000438ff33333b6ff6556ffff444226f100051fffffffffff888288fffcc77cffdccfffcf2cddd7ffffff8982255fff
f8822fffffbbbfffff22efc4ff224f9f10000ffff333bb94ff5555fff4244f2fff1011ffffeeeeeff2882f88ffcd7ccffffcfffffccdd2dfff89ff89822fffff
ff2f2fffff444fffff22effcffddd9ff10001ffff2222942ff544fffffff4ffffff1fffffe22227e28882288fffccffffffdffffd2dfdffffff8999822ffffff
fd00dffff4004fffff222fffffd0dfff10001fff200002fffe5fffffff00ffffffffffffe222002e8288822efffcffffffffffffffffffffffff8882250fffff
fffffffffffffffffffffcfffffffffff11fffffffffffffffffffffffffffff11ffff11ffffffffffffffffffffcffffff7ffffffffffffffffffff9a88ffff
fff67fffffffffffff2ec4cfffffffff1041ffffffffff6fffffffffffffffff0011f100ffffffffff28ff28fffffcffffc7efffffffffffffff8ff98e0fffff
fff22fffffffffffff3234cffff3f3ff1a0a1fffffff9996ffffffffffffff6f50001005ffffffffffff88d8fffffccfeeee7eeeff2d7c7ffff88888828f28ff
ff822ffffff3f36fffbb3c4cff4333ff133a1f8fff333976ffffffff4f624f4615000051fffffffff8882282ffccfccfffdcefffcff2c7c7ff8558582222858f
ff6d9fffffb333f6ff222e3cff44499f10001878f3333336ff64f6fff4464446f158081ffff22ffffff88228fcdccccfffdccffffccdc7c7ffffff982255ffff
f86226ffffbbbff6ff222ec4f4425ff910004a8ff94bbb66fef6556f42462406ff1011ffff288e2ff2882f28fcc7ccfffffcffffddd26c6fff89ff98222fffff
ff6f2fffff44bf66ff22efc4ff435ff9100001fff9924446ff56556fff262f26fff1fffffd88882f28882228fffc7cfffffdfffffffd2cffffff998222ffffff
fd00dffff4002377ff222fffffd0d99f10001fff29444426ff55ff5ffff4fff4ffffffff282d8d2f882e822effffcfffffffffffffdfdfffffff2262250fffff
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
fffffffffffffffffffffff000ffffffffff000fffffffffffffffffffffffffffffffffffefefffa999888876555555ffffffffffffffffffffffffffffffff
ffffff0100000fffffffff0000000ffffff0000000fffffffffffffffffffffffffffffffe757eff544fffff76655555ffffffffffffffffffffffffffffffff
000ff00100011fff00fff0000000000fff00000000000fffffffffffffffffffff222ffffe656eff76d44444ffffffffffffffffffffffffffffffffffffffff
0010110180018f0000ff0000000000dff000000000000000ffffffff0ffffffff22222fffe6564efffffffffffffffffffffffffffffffffffffffffffffffff
001108018010800000f0000000000d9f000000000000000dfffffff00fffffff022224fffe5e5efffffff055d5fffffffffffffffffffffffffff0055dffffff
0019080110100010000000000000191f555000000000001dfffffff0d0fffffff12444ffffefefffffff0511515ffffffffff000ffffffffffff055511dfffff
011901011010101000550000000d119f1550550000000d11fffffff0900fffff021114fffffffffffff01055000dffffffff0555000fffffffff05115510ffff
0d010100000010000055505000dd119f000055505000dd11ffffff005d0f0ffff02440ffffffffffffff0511511dfffffff051515550ffffffff01501115d0ff
090100000f0000000000505551d1911f505000505550d1d1ffff00011d0090ffffffffffffffffffffff05015191ffffff05050151d5ffffffff01550101d0ff
0d10ffff0ffff00800500005511d919f5055500008801dd1fff000011501d0ffffffffffff757fffffff01011010ffffff5552050d510ffffffff01549150fff
0110050fffffff0000505550011d19df0005505580001d1dff0800001101d00ff242ffffff656fffffff01118910f1ffff5055559151010ffffff0015500f1ff
010ffffffffff0f0000015505d111d0f555000158058111dff01100115001d0024224fffff6564ffffff01511550111ff050512151511110ffff00100100111f
0001fffffffffff1005500005d1d100f1550550000581d10f111010111001150222444fff8a8a8fffff05000000dffff0020505051550000fff05000000dffff
00001ffff00f80100055505001dd00fffff055505000dd0ff011010110d01010122444fff89898fffff105505850110ff051505050511100fff105505450110f
ff000811000011000000505551d00fffffff00505880d0ffff0011010050100f012444ffff8f8fffff0011000001100fff5551519501100fff0011000001100f
fff0000000000000ffff00055100fffffffffff005500ffffff01111101110fff0122ffffffffffffff00110111000fffff00555511000fffff00110111000ff
ffff115515150fffffffff0000fffffffffffffff000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff042992242fffffffffffffffffff
fff11015010105ffffff001500fffffffffff0bbb00fffffffff9ffffffb9f33fff000110111ffffffffffffffffffffffff150000050ffffff000880811ffff
ffd110111101011ffff10011015ffffffff10bbbbbb8f1fff33ff9fff0b0f3ffff011d005111f10fffffffffffffffffffff005222202fffff0111000111f10f
fd11001101000101ff1d1000011001ffff10b11bbb9d111ffff3ff3f99ff3ffff01150d9195015d0ffffffffffff9fffffff050000050ffff011110180001110
5151000000000100f155000100000155fff05551195dffffffff3f3fff3fbfff00005550050d0000fffffffffff9ffffffff042922240fff0000001111080000
11500011010000011150f00011000011f01155155d501100fffffbfbffb00ffff011000050050100fffff9fffff3ffffffff021000100ffff011000010111100
1101fffffffff1015001ffff00000100ff0000155d01100fffff0b0bfbffffffff0011510050500fffffff9ffff3ffffffff042222242fffff0011110001100f
101fffffffffff01500ffffffff00001fff00100001000fffffffffbfffffffffff00150110005fffff3ff3f9ff3f3ffffff050000020ffffff00110111000ff
ffffff88fffffffffffffff888ffffffffffffff88fffffffffffffff9ffffffffff555979555fffffff3f3f3f3ff3ffffffffffff505ffffffffff5ffffffff
fff000110881fffffff01111111110fffff01111111110fffffffffffbfffffffff5000d800005ffffff3f3ff3bf3ffffffffff5904202ffffff5055d11000ff
ff0111000111f10fff0111111111110fff0111118111110ffffffffffff9ffffff5011d08111106fffff3f3ff3b03fffffff05902902202fffff1000050045ff
f011110180001110f011100111111110f011111111111110fffff9fffffbfffff5011d0181111d05ffff3ff3f3ffbffff505502402405504fff15500d55455ff
000000111101000001111118111111110101111111111111fffff3ff9ffffffffd1110111111d01dfffff3f3fbffbfff022022022055044ff0005559d0550001
f011000010111100f011111110011110f011111111100110fffffbf3fffffffff0d11111111101d0fffffbf3fbff00fff02202505404fffff051005910d11100
ff0011110001100fff0111111111110fff0111111111100ffffffffbffffffffff0d111111d11d0fffff0b0bffffffffff055044ffffffffff0011110559100f
fff00110111000fffff01111111110fffff01111111110fffffffffffffffffffff0ddddd6ddd0fffffffffbfffffffffff44ffffffffffffff00510111000ff
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
000000000000000000000000000000004000804880082c000000ee00be00ee007a816301ba016b03f32109096b15b321b32173217321730323017d036b15ea0104040404000000000000000000000000040404040000000000000000000000000404040400000000000000000000000004040404000000000000000000000000
0000000001010101008000000000000000000000010101010000000000000000040000000101010300000000000000000400000001010103000000000000000001010000000000000000000000000000010110002000700000003000300030000000000010000407040100090401040004000407040004070400040904003000
__map__
000000000000000000000000000000001011ca0014150000000000001c1d000020210000242500002829000000002e2f303132333435363738393a3b0000000046004646004600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003200cb0000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000046004646004700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003200000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000046460047470041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000046460047470041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000047474700414100410041420048004900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003400000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000047474700414100410041420048004900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003200363200003a320000000041414100414200430048480049000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003200363400003a340000000041414100414200430048480049000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003400363400003a340000000041414200414300494900484848004500414243440043430000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001600000000000000000000003200000020000000320000003200000000003200320032003400363400003a340000000041414200414300494900484848004500414243440043430000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000016000000000000000000000032000000200000003200000032000000000032003200340034003a3200003a340000000041434442004141424200414143430045004545004d4d004249004848480000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000016000000000000000000000032000000200000003200000032000000000032003200340034003a32000036320000000041434442004141424200414143430045004545004d4d004249004848480000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000032890000000000000000000032000000200000003200000032000000000032003200340034003a340000363200000000424949004d4d4d004c00454500454200444448484800000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000328900000000000000000000320000001000000032000000320000000000320032003400200032000000363200000000424949004d4d4d004c00454500454200444448484800000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003489000000000000000000003200000010000000320000003200000000003200320034003632320000003634000000004545424444004c4d4d4d004444484848480042424949000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003489000000000000000000003200000034000000320000003200000000003200320032003634340000003634000000004a004e004545424444004c4d4d4d0044444848484800424249490000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001011000014150000000000001c1d000020210000242500002829000000002e2f303132333435363738393a3b000000004a004c4d4d4d004e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a30000000004a004c4d4d4d004e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a30000000004a004c4d4d4d004e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002e000000200000002ea900003000000000003000300030003000363000003a30000000004a004c4d4d4d004e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000030000000000000002ec80000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e000000000000002e000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e0000000000000030000000200000002ea900003000000000003000300030003000363000003a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e0000000000000030000000200000002ea900003000000000001c00300030003000363000003a2e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002e0000000000000030000000200000002ea900003000000000002ea930003000300036300000363000000000acadaeafbcbdbebfacadaeafbcbdbebfacadaeafbcbdbebf848586878191a1b18c8d8e8f9c9d9e9f848586878191a1b18c8d8e8f9c9d9e9f0000000000000000
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
9205000017631276702c6702f6703167033670316703267030671316712f6602cf7029f702af7026f602af5126f5125f5125f4020f411ff411ef301df311cf301bf211af2119f2018f1116f1115f1113f1105f01
c4281400184151a4151f41521415184151a4151f41521415184251a4251f42521425184251a4251f42521425184251a4251f415214152140523405284052a4050000000000000000000000000000000000000000
48030c1c0862424524240242404124051240412403124021240212402124021240212403124031240412404124031240312402124021240312403124041240412403124031240212402124011240112401123011
490800000a05301030010210102101015010000100001000010000100000000000000800301000010000905301030010210102101015006450051300503050050000000000000000000000000000000000000000
520a100000605006053a6053a6053b615000053b6253a6053b6150000000000000003d6103d615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9303002000661026510c6710267008661016310866001661106710366009641026610567006651016710b640066610167103670046510267109640016610a671026400466103671076310b650036610667103631
9127002005f7113f7111f7112f7108f7110f711af710df7115f7105f7121f710df7112f7118f7104f7106f7112f711bf7110f710ff7106f7104f7111f710ff710cf7115f7118f7104f710cf7111f710bf710ff71
520709003e65331651006113e62330621006113e61311611006150060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
900207000f9140f9300f9450f9030f9200f92509a0009a0009a0009a0009a0009a000060000600006000060000600006000060000500005000060000600005000050000500005000050000500005000050000000
00020a001414015151151611216111141061330613105121051200512102100011000210003100031000210003100081000810000100001000010000100001000010000100001000010000100001000010000000
900117000062000621056310a64112641186512065110051060310302101621006210262000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
a8020600322303f2613e2413c231342010b2002e2002f2002320000200002000020000200002002d2001d20000200002000020000200002000020000200002000020000200002000020000200002000020000200
aa0506003e6143a5213f5213f5113d501005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
aa0407003e6143e5213f521355112f511005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
d402170000120071501a2701665013260122601015009250041500e15000250052000024004200031000023000100001000023000100001000010000100001000010000100001000010000200002000020000200
d4080a00170033e544345353d5353e525345153d5153e51531507375073a5073d5073a50732507325073a5073b5072f50732507375072b5073750721507285070050000500005000050000500005000050000500
40051000005003c020005003201000500370102a500005003c50000500005000050000500005000050000500005003c000005003200000500370002a500005000050000500005000050000500005000050000500
010706000000109071190010000107031200010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c403110000610022210a631241412c3401a641132310a221066200000001220000000120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c4020b00326103503437061242311d213102310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
220411002d6210a0530f12104131061520813208152081320e1510812108141071410814107121091410e1110b101071010a1010a105000000000000000000000000000000000000000000000000000000000000
900409000f65500301000010065006011006013600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900b04003f00438011320212900100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480606000062507071000000062400620006250000001605006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
940310000165500000206650051106531095110b521095110a5210b5010a5110b5010c5010b5010a5110b50100000000000000000000000000000000000000000000000000000000000000000000000000000000
c40406003a62532525136003f52500605026010160100505006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
060212000655300003095530000300003115333f5153f5051a533000030000335545206153b515000003b5003f500000000000000000000000000000000000000000000000000000000000000000000000000000
36030b003d60135211006113e5113e5113a511385013e5003a5013850100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000114000915009161091710b1700a171091500416102150021300113101150011610117102170031610317002171031700815108130001000010000100001000010000100001000010000100001000010000100
d40220000015000250002500f6600f2600e2500915009650091500425009150052500325004250031500125000100002500010000100002500010000230001000010000100001000023000200002000020000200
a8011700322103e2313f2313f2312f200232002e2002f20023200002000020000200002003020038201272022f221392513d2513d251002000020000200002000020000200002000020000200002000020000200
900119000061000611026210862117621236313063123631166210c01105611006110261000610006100061000610006000061000600006100000000610000000000000600000000000000000006000000000000
4c0603000667306573005530d503005030c5030050500103001010010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000000000000000000000
9001190019920199201992019920199201992019920199200d9000d9000d900059100591005910059100591005910059100591005910059100591005910059100b9000b9000b9000b9000b9000b9000b9000b900
4a020000017742f641056600a671136710965003641026413663005621036310562008621056310e630056210162100610096110061100620006312d621006110061001601016210160100610006210060100611
490210000261000620036100161000600006100061000610006000061000600006000050000500006150060000500005000050000500005000050000500005000000000000000000000000000000000000000000
79020b000e91006010040110301500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a9030800260242a011001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000000000000000000000000000000000000000000000000000000000
970108003b5253461034615270000000000000000000000000000000002b6002e600395053060330605306003930030600306001a6052900029000290053b6000000000000000003b600000003b600000003b600
90070b001967316333073130060315333073131530315303153130830000100001000010000100001000010000100001000010000100001000010000100001000010000100001000000000000000000000000000
000b02000f05300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90010d0007615006110061524500316000060000600006003162500610006110060100601006011e60500601006010060100601006051d600006050560004600000000060500000000000a600086050000002600
680809001407323024220112101121001195011950100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7e0200000c050006500145033650366603666036660366503665036650366503665036650366501764017630176301333000000123501760025600206001133000000296002a600003000c310000000000000000
7e0219000c0500065001450386503a6602766020660163502d65014350366003660015350366001760017600176000040000000000001760025600206000030000000296002a6000030000000000000000000000
30070c003e511365203a5253a5113a5123a5153a50231502315020000100001000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
300609003f521305203052539515395023a5053a50231502315020000100001000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0802000012120141211b14220140201302014020130191201b1301c1401c1321c1421d1421d1121d1121d1421d1121d1121d1421d1121c1121c1451c1101c1000000000000000000000000000000000000000000
0902000030121301212a1212614222140221302214022130211201e1301e1301e1221e1221e1221e1121c1211b111191211c1021c1021b1021b1051a1001c1000000000000000000000000000000000000000000
c004000000656046560a666071761167612676156761567614676176761767617676176661566613666106560e656096560865607656066560565602641006310363101621026210061100611006010020100000
90020000006560465602666081761167612676156761567613176176761767617676176661116613666106560e656096560865607656066560565602641006510263103631016210162100611006010020100000
35040d003550135521355223551235512355110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
910600000f60102011080110d6111402119621230313a6113f6010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
400510001f501375513c5001f501375213c5001f501375113c50000500005000050000500005000050000500005003c000005003200000500370002a500005000050000500005000050000500005000050000500
04a014001882018820188251b8001c8001e8101e8241e81518c001bc001f8101f8101f815240002a8001f8201f825158000000000000000000000000000000000000000000000000000000000000000000000000
6da00014155141e52621517155120e5111e5141e5141e502175141f5061c51418516185121a5111a5121b5111b5141b5121b5121b5133f5000050000500005000050000500005000050000500005000050000500
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

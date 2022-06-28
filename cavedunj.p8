pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

function _init()
	adj=vec2list
	"0 ,-1,\
		1 ,-1,\
		1 , 0,\
		0 , 1,\
		-1, 1,\
		-1, 0"
	
	cavewallxy=vec2list
	"4 , -8,\
	 11, -8,\
	 11,  4,\
	 4 ,  4,\
	 1 ,  4,\
	 0 , -8"
	
	cavewallwh=vec2list
	"6,14,\
	 4,14,\
	 4, 4,\
	 7, 4,\
	 3, 4,\
	 4,14,"
	 
	baseoffset=vec2(-7,-4)
	
	genmap(vec2(mapsize/2,mapsize*0.75))
end

function _update()
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
	
	campos = entscreenpos(player)
 center = screenpos(vec2(mapcenter,mapcenter),vec2(-3,-7))
	campos = 0.5*(campos + center)
	--smooth = smooth and 
	--	0.5*(smooth+campos) or
	--	campos
	camera(campos.x-64,campos.y-64)
end

function _draw()
	cls()
	drawmap(world)
end
-->8
tempty,tcavefloor,tcavefloorvar=
0     ,178       ,180
tcavewall,tdunjfloor,tdunjwall=
144      ,176       ,130

function tile(typ)
	return {typ=typ}
end

function drawmap()

	darkpal=split"15,255,255,255,255,255,255,255,255,255,255,255,255,255"
	blackpal=split"0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	alltiles(
	
	function(pos,tl)
	
		--draw tile
		local typ = tl.typ
		if (typ == tempty or typ == tcavewall) return
		pal()	
		palt(0, false)
		palt(15, true)
		pal(15,129,1)
		if vistoplayer(tl) then
			pal(1,241,2)
		elseif tl.explored then
			pal(darkpal,2)
		else
			pal(blackpal)
		end
		if typ > 0 then 
			fillp((tl.light>=2 and tl.vis)
								 and █	or 
								 0xc7d3.4)
			
			for pass=1,2 do
				local sprite=pass == 1 and
																	typ or tcavewall
				local litsprite=sprite+64
				
				function tlspr(size,flp,offset)
					local scrpos=
											screenpos(pos,offset+baseoffset)
										
								sspr((sprite%16)*8+offset.x,
														flr(sprite/16)*8+offset.y,
														size.x,size.y,
														scrpos.x,scrpos.y,
														size.x,size.y,
														flp)
				end
				
				for i=0,6 do
					local adjtile =
						getadjtl(pos,i)
					if adjtile then
						if adjtile.lightsrc and 
								 fget(litsprite,i) then
					  sprite = litsprite
					 end
					 if pass == 2 and
					 		 adjtile.typ ==
					    tcavewall 
					     then
							tlspr(cavewallwh[i],
												 tl.flip and
												  (i-1)%3 == 0,
												 cavewallxy[i])
						end
					end
				end
				if pass == 1 and
							sprite != tcavewall then
					xtraheight=fget(typ,3) and 8 or 0
					tlspr(vec2(15,8+xtraheight),
											tl.flip,
											vec2(0,-xtraheight))
				end
			end	
		end
		
		--draw entity
		local ent = tl.ent
		if vistoplayer(tl) and ent then
			fillp(█)
			local scrpos=
				entscreenpos(ent)
				
			spr(ent.typ + (ent.yface > 0 
																	 and 16 or 0),
							scrpos.x,scrpos.y,
							0.875,1,
						 ent.xface<0)
		end
	end)
	
end

-->8
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
								y<=mapsize
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
		local n = i+flr(rnd(7-i))
		local npos = pos+adj[indices[n]]
		indices[n]=indices[i]
		func(npos,gettile(npos))
	end
end

function alltiles(func)
	for y=0,mapsize do
		for x=0,mapsize do
			local pos=vec2(x,y)
			func(pos,gettile(pos))
		end
	end
end

function navigable(tl)
	return fget(tl.typ,0)
end

function passlight(tl)
	return fget(tl.typ,1)
end

function vistoplayer(tl)
	return tl.vis and tl.light>0
end

function calcpdist(pos,tl)
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
	local lastvis=true
	for i=ceil(lim1),flr(lim2) do
	 local tlpos=pos+i*dir2
	 if validpos(tlpos) then
			local tl = gettile(tlpos)
			tl.vis = true
			local vis = passlight(tl)
			local splitlim=-1
			if vis then 
				if not lastvis then
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
		end
	end
end

function calcvis(pos,tl)
	for i=1,6 do
		viscone(pos,getadj(i),getadj(i+2),0,1,1)
	end
end

function calclight(pos,tl)
	tovisit={{pos,tl}}
	repeat
		pos,tl=unpack(deli(tovisit,1))
		light=tl.light-1
		visitadj(pos,
		function(npos,ntl)
			if ntl.light<light then
				ntl.light = light
				if passlight(ntl) then
					add(tovisit,{npos,ntl})
				end
			elseif ntl.light >
										light+2 then
					add(tovisit,{npos,ntl})				
			end
		end)	
	until #tovisit == 0
end

function updatemap()
	alltiles(
	function(pos,tl)
		ent = tl.ent
		tl.light = ent and ent.light or 
													(fget(tl.typ,7) and 
													4 or -10) 
		tl.lightsrc = tl.light>0
		tl.pdist,tl.vis=
		-1      ,ent == player
	end)
	ppos=player.pos
	ptile=gettile(ppos)
	calclight(ppos,ptile)
	calcpdist(ppos,ptile)
	calcvis(ppos)
	alltiles(function(pos,tl)
		if vistoplayer(tl) then
			tl.explored=true
		end
	end)

end
-->8
function screenpos(pos,
																			offset)
	return vec2(offset.x+pos.x*10,
							 				 offset.y+pos.y*8+
							 				  pos.x*4) 
end

function entscreenpos(ent)
	return screenpos(ent.pos,
																		vec2(-3,-7))
end

function hexdist(x,y,x2,y2)
	z,z2=-x-y,-x2-y2
	return (abs(x-x2)+abs(y-y2)+abs(z-z2))/2
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
-->8
eplayer,egoblin=
1      ,2

function create(typ,pos)
	local ent = {typ=typ,pos=pos,
							xface=1,yface=-1}
		
	add(ents,ent)
	gettile(pos).ent = ent
	return ent
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
	return true
end
-->8
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
	gettile(startpos).typ = tcavefloor
	gen(startpos)
	postproc()
	
	player = create(eplayer,
																	startpos)
	player.light=4
	updatemap()
end

p=1.5

function gen(pos)
	--local typ = gettile(pos).typ
	p -= 0.015
	if inbounds(pos) and
			 navigable(gettile(pos)) then
		visitadj(pos,
		function(npos,tl)
			if not navigable(tl) then
				if inbounds(npos) and 
							rnd()<p then
					if rnd()<0.7 then
						tl.typ=tcavefloor
					else
						tl.typ=tcavefloorvar
					end
					tl.flip=rnd()<0.5
					gen(npos)
				else
					tl.typ=tcavewall
				end
			end
		end)
	end
end

function choosetile(typ)
	return mget(typ/2,
													ceil(rnd(15)))
end

function postproc()
	alltiles(
	
	function(pos,tl)
		if tl.typ==tcavewall and 
					inbounds(pos) then
			if navigable(
							getadjtl(pos,1)) and
				  navigable(
							getadjtl(pos,4)) then
				tl.typ=choosetile(tcavewall)
			end
		end
	end)
end
__gfx__
fffffffffff67ffffffffffffffffffffffffffffff11fffff999fff000000000000000000000000000000000000000000000000000000000000000000000000
fffffffffff62f9ffffffffffff22fffffffffffff1001ff333333ff000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffff888faffff3f3fffff223fffff3f3ffff10031f33333344000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffff88df4fff5553f6ff22234fff44439ff100038133333344000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffff88d6ffff555f6fff222f4fff4445f9f10001419333394f000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffff882fffff5553ffff22234fff444366f1000341f33339ff000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffff2f2fffff444fffff222f4fff66699ff100011ff2222fff000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffd0dfffff404fffff222fffff606ffff10001fff2002fff000000000000000000000000000000000000000000000000000000000000000000000000
fffffffffff67ffffffffffffffffffffffffffffff11fffff997fff000000000000000000000000000000000000000000000000000000000000000000000000
fffffffffff22ffffffffffffff22fffffffffffff1001ff333993ff000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffff882f9ffff3f3fffff323fffff3f3ffff13031f993333ff000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffff86dfafff5333ffff2333ffff4333fff103331f99333344000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffff8d6f4fff555ff6ff222f4fff44499ff100018199933f44000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffff8226ffff555f6fff222f4fff4445f9f1000141f999944f000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffff2f2fffff4453ffff22234fff664366f1000341f2299fff000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffd0dfffff404fffff222f4fff60699ff100011ff2002fff000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ffffffffffffc4cfffffffffff11ff8fffffffff000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ffffffffff22c4cffffffffff1001878fff999ff000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ff6666ffff223c4cfff3f3fff1003184f3333336000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000f663f36fff22223cff4443fff1000031f3333336000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000f35553f6ff2222c4f4444f9ff100001ff3333336000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ff555fffff222fc4ff444f9ff10001fff3333394000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ff444fffff222ffcff6669fff10001fff2222944000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000f4004fffff222fffff606ffff10001ff200002ff000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000fffffffffffffcffffffffffff11ff8fffffffff000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ffffffffff22c4cffffffffff1001878fff999ff000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ffffffffff3234cffff3f3fff1303141f333973f000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000fff3f3ffff333c4cff4333fff1333141f9933336000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ff5333f6ff22223cff44499ff100003199933336000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000f35555f6ff2222c4f4445ff9f100001f99333366000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000f6645f6fff222fc4ff435ff9f10001ff9924466f000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000f46666ffff222fffff60699ff10001ff9444462f000000000000000000000000000000000000000000000000000000000000000000000000
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
ffffffffffffffffffffff000fffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffff000000dffffffff000fffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffff010000fffffffff0000001dfffffff000000fffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fff00010010ffffffff000000d11ffffff0000000000fffffffffff0ffffffff0000000000000000000000000000000000000000000000000000000000000000
f101101501000fffff000000dd11fffff5500000000001ffffffff00ffffffff0000000000000000000000000000000000000000000000000000000000000000
f1105015010010fff0000001d1d1fffff55055000000d1ffffffff0d0fffffff0000000000000000000000000000000000000000000000000000000000000000
01d050110000100f055000d11dd1fffff0005505500dd1ffffffff0d00ffffff0000000000000000000000000000000000000000000000000000000000000000
11d010110100000f05550dd11d1dfffff0550005550d1dfffffff005d0f0ffff0000000000000000000000000000000000000000000000000000000000000000
d01010000100000f00050d1d111dfffff05550000501ddffffff0011d000ffff0000000000000000000000000000000000000000000000000000000000000000
d010000000f0010f005001dd1d10fffff00050550001d1ffff00001150d0ffff0000000000000000000000000000000000000000000000000000000000000000
d1000ff0fff0000f005551d1dd0ffffff5500055055111fff050000110d00fff0000000000000000000000000000000000000000000000000000000000000000
110050ffffff000f00055111d0fffffff55055000551d1fff0110011500d00ff0000000000000000000000000000000000000000000000000000000000000000
100fffffff0ff00f055001d10ffffffff0005505500dd0ff011010111011500f0000000000000000000000000000000000000000000000000000000000000000
00ffffffffff000f05550dd0ffffffffffff0005550d0ffff01010110d0100ff0000000000000000000000000000000000000000000000000000000000000000
ff00fffff0500fff00050d0fffffffffffffff000500ffffff01101005010fff0000000000000000000000000000000000000000000000000000000000000000
fff000f00ff0fffffff000fffffffffffffffffff00ffffffff011111110ffff0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000fffffffccfffffff000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000ffffffccc7ffffff000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000ffffffffdfffffff000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000ffffffffdfffffff000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000000000000000
ffff0000000fffffffff0000000fffffffff0000000fffffffff4004000fffffffff0000000fffff000000000000000000000000000000000000000000000000
fff000110110fffffff011111110fffffff011111110fffffff021121110fffffff011111100ffff000000000000000000000000000000000000000000000000
ff00110011100fffff01111111110fffff01111111110fffff01141410410fffff01111cc1110fff000000000000000000000000000000000000000000000000
f0011101000110fff0110011111110fff0111111111110fff0041242242110fff00111ccc71110ff000000000000000000000000000000000000000000000000
010010111100010f011111111111110f010111111111110f011212421411410f01110111d111010f000000000000000000000000000000000000000000000000
f0110001101110fff0111111001110fff0111111100110fff0111121421410fff0111c12d21110ff000000000000000000000000000000000000000000000000
ff00111001110fffff01111111110fffff01111111100fffff00141121120fffff011d1001110fff000000000000000000000000000000000000000000000000
fff011101000fffffff011111110fffffff011111110fffffff012111110fffffff000111110ffff000000000000000000000000000000000000000000000000
ffffffffffffffffffffff000fffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffff000000dffffffff000fffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffff010000fffffffff0000001dfffffff000000fffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fff00010010ffffffff000000d11ffffff0000000000fffffffffff0ffffffff0000000000000000000000000000000000000000000000000000000000000000
f101101401000fffff000000d911fffff5500000000001ffffffff00ffffffff0000000000000000000000000000000000000000000000000000000000000000
f1104014010040fff00000019191fffff55055000000d1ffffffff0d0fffffff0000000000000000000000000000000000000000000000000000000000000000
019040110010400f055000d11d91fffff0005405500dd1ffffffff0900ffffff0000000000000000000000000000000000000000000000000000000000000000
119010110100100f05550dd11d1dfffff0550004550d1dfffffff005d0f0ffff0000000000000000000000000000000000000000000000000000000000000000
d01010000100000f00050d19111dfffff05540000501ddffffff0011d000ffff0000000000000000000000000000000000000000000000000000000000000000
9010000000f0010f005001d91910fffff00040450001d1ffff0000115090ffff0000000000000000000000000000000000000000000000000000000000000000
d1000ff0fff0000f005551d19d0ffffff5500045045111fff040000110d00fff0000000000000000000000000000000000000000000000000000000000000000
110050ffffff000f00055111d0fffffff55044000451d1fff0110011500d00ff0000000000000000000000000000000000000000000000000000000000000000
100fffffff0ff00f055001d10ffffffff0005504500dd0ff011010111011500f0000000000000000000000000000000000000000000000000000000000000000
00ffffffffff000f05550dd0ffffffffffff0005550d0ffff01010110d0100ff0000000000000000000000000000000000000000000000000000000000000000
ff00fffff0400fff00050d0fffffffffffffff000500ffffff01101005010fff0000000000000000000000000000000000000000000000000000000000000000
fff004f00ff0fffffff000fffffffffffffffffff00ffffffff011111110ffff0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffff0044000fffffffff0044400fffffffff0004400fffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
fff000110410fffffff011111110fffffff011111110ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ff00110041100fffff01111111110fffff01111411110fff00000000000000000000000000000000000000000000000000000000000000000000000000000000
f0011104000110fff0110011111110fff0111111111100ff00000000000000000000000000000000000000000000000000000000000000000000000000000000
010010114100010f011111411111110f010111111111110f00000000000000000000000000000000000000000000000000000000000000000000000000000000
f0110001101110fff0111111001110fff0111111100110ff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ff00114001110fffff01111141110fffff01111141100fff00000000000000000000000000000000000000000000000000000000000000000000000000000000
fff011101000fffffff011111110fffffff011111110ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000808000000000000000000000000000008080000000000000000030307070707070787870000000000000303070707070707878700000000000001010808202038380000000000000000010108082020383800000000000000000003020201010000000000000000000002020202020200000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
